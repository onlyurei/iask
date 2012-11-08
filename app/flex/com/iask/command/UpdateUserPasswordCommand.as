package com.iask.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.iask.business.UserDelegate;
	import com.iask.control.EventNames;
	import com.iask.model.IaskModelLocator;
	import com.iask.util.CairngormUtils;
	
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	public class UpdateUserPasswordCommand implements ICommand, IResponder
	{
		public function UpdateUserPasswordCommand()
		{
		}
		
		private var _model:IaskModelLocator = IaskModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			CursorManager.setBusyCursor();
			var delegate:UserDelegate = new UserDelegate(this);
			delegate.updateUserPassword(event.data);
		}
		
		public function result(data:Object):void
		{
			CursorManager.removeAllCursors();
			if (data.result == "error")
			{
				Alert.show("当前密码错误。", "修改帐户失败");
			}
			else
			{
				Alert.show("修改帐户成功。");
			}
		}
		
		public function fault(info:Object):void
		{
			CursorManager.removeAllCursors();
			Alert.show("这可能是由以下几个原因之一或者多个而引起：\n\n1.指定的Email已有人使用；\n\n2. 您电脑的网络连接出了故障；\n\n3. 服务器出了故障。", "修改帐户失败");
		}
		
	}
}