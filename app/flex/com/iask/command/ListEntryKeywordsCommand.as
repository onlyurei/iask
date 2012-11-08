package com.iask.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.iask.business.EntryDelegate;
	import com.iask.model.Entry;
	import com.iask.model.IaskModelLocator;
	import com.iask.util.CairngormUtils;
	import com.iask.control.EventNames;
	
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	public class ListEntryKeywordsCommand implements ICommand, IResponder
	{
		public function ListEntryKeywordsCommand()
		{
		}
		
		private var _entry:Entry;
		
		public function execute(event:CairngormEvent):void
		{
			_entry = Entry(event.data);
			var delegate:EntryDelegate = new EntryDelegate(this);
			delegate.listKeywords(_entry);
		}
		
		public function result(data:Object):void
		{
			var model:IaskModelLocator = IaskModelLocator.getInstance();
			if (data.result == "error")
			{
				Alert.show("您可能在这台计算机上用其他帐号登录了本系统。", "获取条目关键字列表失败");
				return;
			}
			model.setEntryKeywords(_entry, XMLList(data.result.children()));
			CairngormUtils.dispatchEvent(EventNames.LIST_ENTRY_RELEVANCES, _entry);
		}
		
		public function fault(info:Object):void
		{
			Alert.show("这可能是由以下几个原因之一或者多个而引起：\n\n1. 您电脑的网络连接出了故障；\n\n2. 服务器出了故障。", 
			"获取条目关键字列表失败");
		}
		
	}
}