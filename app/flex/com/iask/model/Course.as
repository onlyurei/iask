package com.iask.model
{
	import mx.collections.ArrayCollection;
	import mx.collections.ListCollectionView;
		
	public class Course
	{
		public static const UNSAVED_ID:int = 0;
		public static const NONE_ID:int = 0;
		
		public static const NONE: Course = new Course("", "所有 课程", "", "", NONE_ID, 
			IaskModelLocator.getInstance().teacherNone);
		
		
		[Bindable]
		public var officialId:String;
		
		[Bindable]
		public var name:String;
		
		[Bindable]
		public var description:String;
		
		[Bindable]
		public var notes:String;
		
		[Bindable]
		public var id:int;
		
		[Bindable]
		public var isAllEntriesRetrieved:Boolean;
		
		
		[Bindable]
		public var entries:ListCollectionView;
		
		[Bindable]
		public var keywords:ListCollectionView;
		
		[Bindable]
		public var queries:ListCollectionView;
		
		[Bindable]
		public var teachers:ListCollectionView;
		
		[Bindable]
		public var teachersAndNone:ListCollectionView;
		
		[Bindable]
		public var students:ListCollectionView;
		
		[Bindable]
		public var studentsAndNone:ListCollectionView;
		
		
		public function Course(officialId:String = "", name:String = "", description:String = "", 
			notes:String = "", id:int = UNSAVED_ID, teachersAndNone:ListCollectionView = null, 
			studentsAndNone:ListCollectionView = null)
		{
			this.officialId = officialId;
			this.name = name;
			this.description = description;
			this.notes = notes;
			this.id = id;
			this.isAllEntriesRetrieved = false;
			this.teachersAndNone = teachersAndNone;
			this.studentsAndNone = studentsAndNone;
		}
		
		public function addEntry(entry:Entry):void
		{
			if (entry.course != null)
			{
				if (entry.course != this)
				{
					entry.course = this;
				}
			}
			else
			{
				entry.course = this;
			}
			var entriesArray:Array = [];
			entriesArray.push(entry);
			if (this.entries == null)
			{
				this.entries = new ArrayCollection(entriesArray);
			}
			else if (!this.entries.contains(entry))
			{
				this.entries.addItem(entry);
			}
		}
		
		public function updateEntry(entry:Entry):void
		{
			if (entry.course == this)
			{
				for (var i:int = 0; i < entries.length; i++)
				{
					var ithEntry:Entry = Entry(entries.getItemAt(i));
					if (ithEntry.id == entry.id)
					{
						entries.setItemAt(entry, i);
						break;
					}
				}
			}
		}
		
		public function removeEntry(entry:Entry):void
		{
			if (entry.course == this)
			{
				for (var i:int = 0; i < entries.length; i++)
				{
					var ithEntry:Entry = Entry(entries.getItemAt(i));
					if (ithEntry.id == entry.id)
					{
						entries.removeItemAt(i);
						entry.course = null;
						break;
					}
				}
			}
		}
		
		public function addKeyword(keyword:Keyword):void
		{
			if (keyword.course != null)
			{
				if (keyword.course != this)
				{
					keyword.course = this;
				}
			}
			else
			{
				keyword.course = this;
			}
			var keywordsArray:Array = [];
			keywordsArray.push(keyword);
			if (this.keywords == null)
			{
				this.keywords = new ArrayCollection(keywordsArray);
			}
			else if (!this.keywords.contains(keyword))
			{
				this.keywords.addItem(keyword);
			}
		}
		
		public function updateKeyword(keyword:Keyword):void
		{
			if (keyword.course == this)
			{
				for (var i:int = 0; i < keywords.length; i++)
				{
					var ithKeyword:Keyword = Keyword(keywords.getItemAt(i));
					if (ithKeyword.id == keyword.id)
					{
						keywords.setItemAt(keyword, i);
						break;
					}
				}
			}
		}
		
		public function removeKeyword(keyword:Keyword):void
		{
			if (keyword.course == this)
			{
				for (var i:int = 0; i < keywords.length; i++)
				{
					var ithKeyword:Keyword = Keyword(keywords.getItemAt(i));
					if (ithKeyword.id == keyword.id)
					{
						keywords.removeItemAt(i);
						keyword.course = null;
						break;
					}
				}
			}
		}
		
		public function addQuery(query:Query):void
		{
			if (query.course != null)
			{
				if (query.course != this)
				{
					query.course = this;
				}
			}
			else
			{
				query.course = this;
			}
			var queriesArray:Array = [];
			queriesArray.push(query);
			if (this.queries == null)
			{
				this.queries = new ArrayCollection(queriesArray);
			}
			else if (!this.queries.contains(query))
			{
				this.queries.addItem(query);
			}
		}
		
		public function updateQuery(query:Query):void
		{
			if (query.course == this)
			{
				for (var i:int = 0; i < queries.length; i++)
				{
					var ithQuery:Query = Query(queries.getItemAt(i));
					if (ithQuery.id == query.id)
					{
						queries.setItemAt(query, i);
						break;
					}
				}
			}
		}
		
		public function removeQuery(query:Query):void
		{
			if (query.course == this)
			{
				for (var i:int = 0; i < queries.length; i++)
				{
					var ithQuery:Query = Query(queries.getItemAt(i));
					if (ithQuery.id == query.id)
					{
						queries.removeItemAt(i);
						query.course = null;
						break;
					}
				}
			}
		}
		
		public function addTeacher(teacher:User):void
		{
			var teachersArray:Array = [];
			teachersArray.push(teacher);
			if (this.teachers == null)
			{
				this.teachers = new ArrayCollection(teachersArray);
			}
			else if (!this.teachers.contains(teacher))
			{
				this.teachers.addItem(teacher);
			}
		}
		
		public function updateTeacher(teacher:User):void
		{
			for (var i:int = 0; i < teachers.length; i++)
			{
				var ithUser:User = User(teachers.getItemAt(i));
				if (ithUser.id == teacher.id)
				{
					teachers.setItemAt(teacher, i);
					break;
				}
			}
		}
		
		public function removeTeacher(teacher:User):void
		{
			for (var i:int = 0; i < teachers.length; i++)
			{
				var ithUser:User = User(teachers.getItemAt(i));
				if (ithUser.id == teacher.id)
				{
					teachers.removeItemAt(i);
					break;
				}
			}
		}
		
		public function addStudent(student:User):void
		{
			var studentsArray:Array = [];
			studentsArray.push(student);
			if (this.students == null)
			{
				this.students = new ArrayCollection(studentsArray);
			}
			else if (!this.students.contains(student))
			{
				this.students.addItem(student);
			}
		}
		
		public function updateStudent(student:User):void
		{
			for (var i:int = 0; i < students.length; i++)
			{
				var ithUser:User = User(students.getItemAt(i));
				if (ithUser.id == student.id)
				{
					students.setItemAt(student, i);
					break;
				}
			}
		}
		
		public function removeStudent(student:User):void
		{
			for (var i:int = 0; i < students.length; i++)
			{
				var ithUser:User = User(students.getItemAt(i));
				if (ithUser.id == student.id)
				{
					students.removeItemAt(i);
					break;
				}
			}
		}
		
		public function toUpdateObject():Object
		{
			var obj:Object = {};
			obj["course[official_id]"] = officialId;
			obj["course[name]"] = name;
			obj["course[description]"] = description;
			obj["course[notes]"] = notes;
			return obj;
		}
		
		public function toXML():XML
		{
			var retval:XML = 
				<course>
					<official_id>{officialId}</official_id>
					<name>{name}</name>
					<description>{description}</description>
					<notes>{notes}</notes>
				</course>;
			return retval;
		}
		
		public static function fromXML(courseXML:XML):Course
		{
			return new Course(courseXML.official_id, courseXML.name, courseXML.description, courseXML.notes, 
				courseXML.id);
		}
	}
}