package com.iask.model
{	
	public class Keyword
	{
		public static const UNSAVED_ID:int = 0;
	
		
		[Bindable]
		public var value:String;
		
		[Bindable]
		public var relevance:int;
		
		[Bindable]
		public var notes:String;
		
		[Bindable]
		public var entry:Entry;	
		
		[Bindable]
		public var course:Course;
		
		[Bindable]
		public var id:int;
		
		
		public function Keyword(value:String = "", relevance:int = 0, entry:Entry = null, course:Course = null, 
			notes:String = "", id:int = UNSAVED_ID)
		{
			this.value = value;
			this.relevance = relevance;
			this.notes = notes;
			if (entry == null)
			{
				this.entry = Entry.NONE;
				this.course = Course.NONE;
			}
			else
			{
				this.entry = entry;
				if (course == null)
				{
					this.course = entry.course;
				}
				else
				{
					this.course = course;
				}
			}
			this.id = id;
			this.entry.addKeyword(this);
			this.course.addKeyword(this);
		}
		
		public function setEntry(entry:Entry):void
		{
			this.entry = entry;
			this.entry.addKeyword(this);
		}
		
		public function setRelevance(relevance:int):void
		{
			this.relevance = relevance;
		}
		
		public function toUpdateObject():Object
		{
			var obj:Object = {};
			obj["keyword_id"] = id;
			obj["relevance[value]"] = relevance;
			return obj;
		}
		
		public function toDestroyObject():Object
		{
			var obj:Object = {};
			obj["keyword_id"] = id;
			return obj;
		}
		
		public function toCreateObject():Object
		{
			var obj:Object = {};
			obj["keyword[value]"] = value;
			obj["keyword[notes]"] = notes;
			obj["keyword_value"] = value;
			obj["relevance[value]"] = relevance;
			return obj;
		}
		
		public function toXML():XML
		{
			var retval:XML =
				<keyword>
					<id>{id}</id>
					<value>{value}</value>
					<notes>{notes}</notes>
					<relevance>{relevance}</relevance>
				</keyword>;
			return retval;
		}
		
		public static function fromXML(keywordXML:XML):Keyword
		{
			var model:IaskModelLocator = IaskModelLocator.getInstance();
			var keyword:Keyword = new Keyword(keywordXML.value, keywordXML.relevance, 
				null, null, keywordXML.notes, keywordXML.id);
			return keyword;
		}
	}
}