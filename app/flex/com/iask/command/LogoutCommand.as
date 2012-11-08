package com.iask.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.iask.business.SessionDelegate;
	import com.iask.control.IaskController;
	import com.iask.model.IaskModelLocator;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	public class LogoutCommand implements ICommand, IResponder
	{
		private var _model:IaskModelLocator = IaskModelLocator.getInstance();
		
		public function LogoutCommand()
		{
		}

		public function execute(event:CairngormEvent):void
		{
			var delegate:SessionDelegate = new SessionDelegate(this);
			delegate.destroySession();
			CursorManager.setBusyCursor();
		}
		
		public function result(data:Object):void
		{
			CursorManager.removeAllCursors();
			var request:URLRequest = new URLRequest("/");
			navigateToURL(request, "_self");
		}
		
		public function fault(info:Object):void
		{
			CursorManager.removeAllCursors();
			Alert.show("这可能是由以下几个原因之一或者多个而引起：\n\n1. 您电脑的网络连接出了故障；\n\n2. 服务器出了故障。\n\n\n为了确保您的帐号安全，请现在就关闭当前浏览器窗口(而不仅是当前Tab！)。", "帐号注销失败");
		}
	}
}