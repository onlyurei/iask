package com.iask.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.iask.business.QueryDelegate;
	import com.iask.control.EventNames;
	import com.iask.model.IaskModelLocator;
	import com.iask.model.Query;
	import com.iask.util.CairngormUtils;
	
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	public class UpdateQueryCommand implements ICommand, IResponder
	{
		public function UpdateQueryCommand()
		{
		}
		
		private var _query:Query;
		private var _model:IaskModelLocator = IaskModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			CursorManager.setBusyCursor();
			var delegate:QueryDelegate = new QueryDelegate(this);
			_query = Query(event.data);
			delegate.updateQuery(_query);
		}
		
		public function result(data:Object):void
		{
			CursorManager.removeAllCursors();
			if (data.result == "error")
			{
				Alert.show("您可能在这台计算机上用其他帐号登录了本系统。", "更新提问失败");
				return;
			}
			else if (data.result == "success")
			{
				Alert.show("更新提问成功。");
				if (_query.solved)
				{
					_model.updateQuery(_query);
				}
				else
				{
					_model.updateOneQuery(_query);
				}
			}
		}
		
		public function fault(info:Object):void
		{
			CursorManager.removeAllCursors();
			Alert.show("这可能是由以下几个原因之一或者多个而引起：\n\n1. 您电脑的网络连接出了故障；\n\n2. 服务器出了故障。", "更新提问失败");
		}
		
	}
}