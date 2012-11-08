package com.iask.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.iask.business.EntryDelegate;
	import com.iask.model.Entry;
	import com.iask.model.IaskModelLocator;
	import com.iask.model.Keyword;
	
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	public class ListEntryRelevancesCommand implements ICommand, IResponder
	{
		public function ListEntryRelevancesCommand()
		{
		}
		
		private var _entry:Entry;
		
		public function execute(event:CairngormEvent):void
		{
			_entry = Entry(event.data);
			var delegate:EntryDelegate = new EntryDelegate(this);
			delegate.listRelevances(_entry);
		}
		
		public function result(data:Object):void
		{	
			if (data.result == "error")
			{
				Alert.show("您可能在这台计算机上用其他帐号登录了本系统。", "获取条目关键字的关联度列表失败");
				return;
			}
			var model:IaskModelLocator = IaskModelLocator.getInstance();
			if (_entry != null)
			{
				if (_entry.keywords != null)
				{
					if (_entry.keywords.length > 0)
					{
						var relevances:XMLList = XMLList(data.result.children());
						for each(var relevance:XML in relevances)
						{
							for (var i:int = 0; i < _entry.keywords.length; i++)
							{
								if (relevance.keyword_id == _entry.keywords[i].id)
								{
									_entry.keywords[i].setRelevance(relevance.value);
									break;
								}
							}
						}
						_entry.keywords.sort = model.sortByRelevanceDesc;
						_entry.keywords.refresh();
					}
				}
			}
			if (model.searchKeywords != "")
			{
				var i:int;
				var j:int;
				var keywordsArray:Array = model.searchKeywords.split(" ");
				_entry.relevance = 0;
				for (i = 0; i < _entry.keywords.length; i++)
				{
					for (j = 0; j < keywordsArray.length; j++)
					{
						if (_entry.keywords[i].value == keywordsArray[j])
						{
							_entry.relevance += _entry.keywords[i].relevance;
							break;
						}
					}
				}
				model.selectedCourse.entries.sort = model.sortByRelevanceDesc;
				model.selectedCourse.entries.refresh();
			}
		}
		
		public function fault(info:Object):void
		{
			Alert.show("这可能是由以下几个原因之一或者多个而引起：\n\n1. 您电脑的网络连接出了故障；\n\n2. 服务器出了故障。", 
			"获取条目关键字的关联度列表失败");
		}
		
	}
}