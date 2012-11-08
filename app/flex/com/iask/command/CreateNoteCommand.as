package com.iask.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.iask.business.NoteDelegate;
	import com.iask.control.EventNames;
	import com.iask.model.Note;
	import com.iask.model.IaskModelLocator;
	import com.iask.util.CairngormUtils;
	
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	public class CreateNoteCommand implements ICommand, IResponder
	{
		public function CreateNoteCommand()
		{
		}
		
		private var _model:IaskModelLocator = IaskModelLocator.getInstance();

		public function execute(event:CairngormEvent):void
		{
			CursorManager.setBusyCursor();
			var delegate:NoteDelegate = new NoteDelegate(this);
			delegate.createNote(event.data);
		}
		
		public function result(data:Object):void
		{
			CursorManager.removeAllCursors();
			_model.notes.addItem(Note.fromXML(XML(data.result)));
			_model.notes.sort = _model.sortByIdDesc;
			_model.notes.refresh();
			Alert.show("创建笔记成功");
		}
		
		public function fault(info:Object):void
		{
			CursorManager.removeAllCursors();
			Alert.show("这可能是由以下几个原因之一或者多个而引起：\n\n1. 您电脑的网络连接出了故障；\n\n2. 服务器出了故障。", "创建笔记失败");
		}
		
	}
}