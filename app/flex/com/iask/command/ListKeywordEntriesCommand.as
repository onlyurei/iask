package com.iask.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.iask.business.EntryDelegate;
	import com.iask.control.EventNames;
	import com.iask.model.Course;
	import com.iask.model.Entry;
	import com.iask.model.IaskModelLocator;
	import com.iask.util.CairngormUtils;
	
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	public class ListKeywordEntriesCommand implements ICommand, IResponder
	{
		public function ListKeywordEntriesCommand()
		{
		}
		
		private var _keywordsAndCourse:Array = [];
		
		public function execute(event:CairngormEvent):void
		{
			CursorManager.setBusyCursor();
			var delegate:EntryDelegate = new EntryDelegate(this);
			_keywordsAndCourse = event.data;
			delegate.listKeywordEntries(_keywordsAndCourse[0], _keywordsAndCourse[1]);
		}
		
		public function result(data:Object):void
		{
			CursorManager.removeAllCursors();
			var model:IaskModelLocator = IaskModelLocator.getInstance();
			model.setCourseEntries(_keywordsAndCourse[1], XMLList(data.result.children()), false);
			if (model.selectedCourse.entries.length == 0)
			{
				Alert.show("查询关键词 “"+ _keywordsAndCourse[0] + "” (属于课程 “" + _keywordsAndCourse[1].name + "” ) 返回0条结果", "查询结果");
			}
			else
			{
				for each (var entry:Entry in _keywordsAndCourse[1].entries)
				{
					CairngormUtils.dispatchEvent(EventNames.LIST_ENTRY_KEYWORDS, entry);
				}
			}
		}
		
		public function fault(info:Object):void
		{
			CursorManager.removeAllCursors();
			Alert.show("这可能是由以下几个原因之一或者多个而引起：\n\n1. 您电脑的网络连接出了故障；\n\n2. 服务器出了故障。", 
				"查询失败");
		}
		
	}
}