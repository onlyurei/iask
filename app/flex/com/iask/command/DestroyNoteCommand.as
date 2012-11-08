package com.iask.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.iask.business.NoteDelegate;
	import com.iask.control.EventNames;
	import com.iask.model.IaskModelLocator;
	import com.iask.model.Note;
	import com.iask.util.CairngormUtils;
	
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	public class DestroyNoteCommand implements ICommand, IResponder
	{
		public function DestroyNoteCommand()
		{
		}
		
		private var _note:Note;

		public function execute(event:CairngormEvent):void
		{
			var delegate:NoteDelegate = new NoteDelegate(this);
			_note = Note(event.data);
			delegate.destroyNote(_note);
			CursorManager.setBusyCursor();
		}
		
		public function result(data:Object):void
		{
			CursorManager.removeAllCursors();
			var model:IaskModelLocator = IaskModelLocator.getInstance();
			if (data.result == "error")
			{
				Alert.show("服务器出错，请稍候再试。", "删除笔记失败");
			}
			else
			{
				model.removeNote(_note);
			}
		}
		
		public function fault(info:Object):void
		{
			CursorManager.removeAllCursors();
			Alert.show("这可能是由以下几个原因之一或者多个而引起：\n\n1. 您电脑的网络连接出了故障；\n\n2. 服务器出了故障。", "删除笔记失败");
		}
		
	}
}