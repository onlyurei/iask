package com.iask.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.iask.business.EntryDelegate;
	import com.iask.control.EventNames;
	import com.iask.model.Entry;
	import com.iask.model.IaskModelLocator;
	import com.iask.util.CairngormUtils;
	
	import mx.managers.CursorManager;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.controls.Alert;

	public class UpdateEntryCommand implements ICommand, IResponder
	{
		public function UpdateEntryCommand()
		{
		}
		
		public function execute(event:CairngormEvent):void
		{
			CursorManager.setBusyCursor();
			var delegate:EntryDelegate = new EntryDelegate(this);
			delegate.updateEntry(Entry(event.data));
		}
		
		public function result(data:Object):void
		{
			CursorManager.removeAllCursors();
			if (data.result == "save_error")
			{
				Alert.show("服务器出了故障，请稍后再试。", "更新条目失败");
			}
			else if (data.result == "error")
			{
				Alert.show("您可能在这台计算机上用其他帐号登录了本系统。", "更新条目失败");
				return;
			}
			else if (data.result == "success")
			{
				Alert.show("更新条目成功。");
			}
		}
		
		public function fault(info:Object):void
		{
			CursorManager.removeAllCursors();
			Alert.show("这可能是由以下几个原因之一或者多个而引起：\n\n1. 您电脑的网络连接出了故障；\n\n2. 服务器出了故障。", "更新条目失败");
		}
		
	}
}