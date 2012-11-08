package com.iask.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.iask.business.EntryDelegate;
	import com.iask.control.EventNames;
	import com.iask.model.Keyword;
	import com.iask.model.IaskModelLocator;
	import com.iask.util.CairngormUtils;
	
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	public class UpdateKeywordCommand implements ICommand, IResponder
	{
		public function UpdateKeywordCommand()
		{
		}
		
		[Bindable]
		private var _model:IaskModelLocator = IaskModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			CursorManager.setBusyCursor();
			var delegate:EntryDelegate = new EntryDelegate(this);
			delegate.updateKeyword(Keyword(event.data));
		}
		
		public function result(data:Object):void
		{
			CursorManager.removeAllCursors();
			if (data.result != "success")
			{
				Alert.show("您可能在这台计算机上用其他帐号登录了本系统。", "更新关键词关联度失败");
			}
		}
		
		public function fault(info:Object):void
		{
			CursorManager.removeAllCursors();
			Alert.show("这可能是由以下几个原因之一或者多个而引起：\n\n1. 您电脑的网络连接出了故障；\n\n2. 服务器出了故障。", "更新关键字关联度失败");
		}
		
	}
}