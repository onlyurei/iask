package com.iask.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.iask.business.SessionDelegate;
	import com.iask.model.IaskModelLocator;
	import com.iask.model.User;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.managers.CursorManager;

	public class CreateSessionCommand implements ICommand, IResponder
	{
		public function CreateSessionCommand()
		{
		}

		public function execute(event:CairngormEvent):void
		{
			var delegate:SessionDelegate = new SessionDelegate(this);
			delegate.createSession(event.data.login, event.data.password);
			CursorManager.setBusyCursor();
		}
		
		public function result(data:Object):void
		{
			CursorManager.removeAllCursors();
			var result:Object = data.result;
			if (data.result == "badlogin")
			{
				Alert.show("用户名/密码组合不正确。", 
				"登录失败");
			}
			else
			{
				var model:IaskModelLocator = IaskModelLocator.getInstance();
				model.user = User.fromXML(XML(data.result));
			}
		}
		
		public function fault(info:Object):void
		{
			CursorManager.removeAllCursors();
			Alert.show("这可能是由以下几个原因之一或者多个而引起：\n\n1. 您电脑的网络连接出了故障；\n\n2. 服务器出了故障。", 
			"登录失败");
		}
		
	}
}