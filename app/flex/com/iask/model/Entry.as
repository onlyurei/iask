package com.iask.model
{
	import mx.collections.ArrayCollection;
	import mx.collections.ListCollectionView;
		
	public class Entry
	{
		public static const UNSAVED_ID:int = 0;
		public static const NONE_ID:int = 0;
		
		public static const NONE: Entry = new Entry("", "", null, "", "", "", "", NONE_ID);
		
		
		[Bindable]
		public var question:String;
		
		[Bindable]
		public var answer:String;
		
		[Bindable]
		public var notes:String;
		
		[Bindable]
		public var userOfficialId:String;
		
		[Bindable]
		public var userLastName:String;
		
		[Bindable]
		public var userFirstName:String;
		
		[Bindable]
		public var course:Course;	
		
		[Bindable]
		public var id:int;
		
		[Bindable]
		public var relevance:int = 0;
		
		[Bindable]
		public var keywords:ListCollectionView;
		
		public function Entry(question:String = "", answer:String = "", course:Course = null, notes:String = "", 
			userOfficialId:String = "", userLastName:String = "", userFirstName:String = "", id:int = UNSAVED_ID)
		{
			this.question = question;
			this.answer = answer;
			this.userOfficialId = userOfficialId;
			this.userLastName = userLastName;
			this.userFirstName = userFirstName;
			this.notes = notes;
			this.id = id;
			if (course == null)
			{
				this.course = Course.NONE;
			}
			else
			{
				this.course = course;
			}
			this.course.addEntry(this);
			this.relevance = 0;
		}
		
		public function addKeyword(keyword:Keyword):void
		{
			if (keyword.entry != null)
			{
				if (keyword.entry != this)
				{
					keyword.entry = this;
				}
			}
			else
			{
				keyword.entry = this;
			}
			var keywordsArray:Array = [];
			keywordsArray.push(keyword);
			if (this.keywords == null)
			{
				this.keywords = new ArrayCollection(keywordsArray);
			}
			else
			{
				this.keywords.addItem(keyword);
			}
		}
		
		public function removeKeyword(keyword:Keyword):void
		{
			if (keyword.entry == this)
			{
				for (var i:int = 0; i < keywords.length; i++)
				{
					var ithKeyword:Keyword = Keyword(keywords.getItemAt(i));
					if (ithKeyword.id == keyword.id)
					{
						keywords.removeItemAt(i);
						keyword.entry = null;
						break;
					}
				}
			}
		}
		
		public function toUpdateObject():Object
		{
			var obj:Object = {};
			obj["entry[question]"] = question;
			obj["entry[answer]"] = answer;
			obj["entry[notes]"] = notes;
			obj["entry[course_id]"] = course.id;
			obj["entry[user_official_id]"] = userOfficialId;
			obj["entry[user_last_name]"] = userLastName;
			obj["entry[user_first_name]"] = userFirstName;
			return obj;
		}
		
		public function toCreateObject():Object
		{
			var keyword:Object = keywords.getItemAt(0);
			var obj:Object = {};
			obj["entry[question]"] = question;
			obj["entry[answer]"] = answer;
			obj["entry[course_id]"] = course.id;
			obj["entry[notes]"] = notes;
			obj["entry[user_official_id]"] = userOfficialId;
			obj["entry[user_last_name]"] = userLastName;
			obj["entry[user_first_name]"] = userFirstName;
			obj["keyword[value]"] = keyword.value;
			obj["keyword[notes]"] = keyword.notes;
			obj["keyword_value"] = keyword.value;
			obj["relevance[value]"] = keyword.relevance;
			return obj;
		}
		
		public function toXML():XML
		{
			var keyword:Object = keywords.getItemAt(0);
			var retval:XML = 
				<entry>
					<question>{question}</question>
					<answer>{answer}</answer>
					<course_id>{course.id}</course_id>
					<notes>{notes}</notes>
					<user_official_id>{userOfficialId}</user_official_id>
					<user_last_name>{userLastName}</user_last_name>
					<user_first_name>{userFirstName}</user_first_name>
					<keyword_value>{keyword.value}</keyword_value>
					<keyword_notes>{keyword.notes}</keyword_notes>
					<entry_id>{id}</entry_id>
					<keyword_id>{keyword.id}</keyword_id>
					<relevance_value>{keyword.relevance}</relevance_value>
				</entry>;
			return retval;
		}
		
		public static function fromXML(entryXML:XML):Entry
		{
			return new Entry(entryXML.question, entryXML.answer, IaskModelLocator.getInstance().getCourse(entryXML.course_id),
			    entryXML.notes, entryXML.user_official_id, entryXML.user_last_name, 
			    entryXML.user_first_name, entryXML.id);
		}
	}
}