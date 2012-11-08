package com.iask.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.iask.business.QueryDelegate;
	import com.iask.model.IaskModelLocator;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.managers.CursorManager;

	public class ListSolvedQueriesCommand implements ICommand, IResponder
	{
		public function ListSolvedQueriesCommand()
		{
		}

		public function execute(event:CairngormEvent):void
		{
			CursorManager.setBusyCursor();
			var delegate:QueryDelegate = new QueryDelegate(this);
			delegate.listSolvedQueries();
		}
		
		public function result(data:Object):void
		{
			CursorManager.removeAllCursors();
			var model:IaskModelLocator = IaskModelLocator.getInstance();
			model.setQueries(XMLList(data.result.children()), "solvedQueries");
		}
		
		public function fault(info:Object):void
		{
			CursorManager.removeAllCursors();
			Alert.show("这可能是由以下几个原因之一或者多个而引起：\n\n1. 您电脑的网络连接出了故障；\n\n2. 服务器出了故障。", 
			"获取提问记录失败");
		}
		
	}
}