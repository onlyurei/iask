package com.iask.business
{
	import com.iask.model.Note;
	import com.iask.util.ServiceUtils;
	
	import mx.rpc.IResponder;
	
	public class NoteDelegate
	{
		private var _responder:IResponder;
		
		public function NoteDelegate(responder:IResponder)
		{
			_responder = responder;
		}
		
		public function listNotes():void
		{
			ServiceUtils.send("/notes.xml", _responder);
		}
		
		public function createNote(note:Note):void
		{
			ServiceUtils.send("/notes.xml", _responder, "POST", note.toXML(), true);
		}
		
		public function updateNote(note:Note):void
		{
			ServiceUtils.send("/notes/" + note.id + ".xml", _responder, "PUT", 
				note.toUpdateObject(), false);
		}
		
		public function destroyNote(note:Note):void
		{
			ServiceUtils.send("/notes/" + note.id + ".xml", _responder, "DELETE");
		}
	}
}