package com.iask.model
{	
	import mx.collections.ArrayCollection;
		
	public class Note
	{
		public static const UNSAVED_ID:int = 0;
		public static const NONE_ID:int = 0;
		
		public static const NONE: Note = new Note("", NONE_ID);
		
		[Bindable]
		public var id:int;
		
		[Bindable]
		public var content:String;
		
		public function Note(content:String = "", id:int = UNSAVED_ID)
		{
			this.content = content;
			this.id = id;
		}
		
		public function toUpdateObject():Object
		{
			var obj:Object = {};
			obj["note[content]"] = content;
			return obj;
		}
		
		public function toXML():XML
		{
			var retval:XML = 
				<note>
					<content>{content}</content>
				</note>;
			return retval;
		}
		
		public static function fromXML(not:XML):Note
		{
			return new Note(not.content, not.id);
		}
	}
}