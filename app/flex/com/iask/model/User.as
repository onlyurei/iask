package com.iask.model
{
	import com.iask.util.XMLUtils;
	
	import mx.collections.ListCollectionView;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.collections.ArrayCollection;
	
	public class User
	{
		public static const UNSAVED_ID:int = 0;
		public static const NONE_ID:int = 0;
		
		public static const TEACHER_NONE:User = new User("", "", "", "所有", "", 
			true);
		public static const STUDENT_NONE:User = new User("", "", "", "所有", "");
		
		
		[Bindable]
		public var officialId:String;
		
		[Bindable]
		public var login:String;
		
		[Bindable]
		public var email:String;
		
		[Bindable]
		public var lastName:String;
		
		[Bindable]
		public var firstName:String;
		
		[Bindable]
		public var isTeacher:Boolean;
		
		[Bindable]
		public var isAdmin:Boolean;
		
		[Bindable]
		public var password:String;
		
		[Bindable]
		public var notes:String;
		
		[Bindable]
		public var entriesSum:int;
		
		[Bindable]
		public var courses:ListCollectionView;
		
		[Bindable]
		public var id:int;
		
		
		public function User(officialId:String = "", login:String = "", email:String = "", 
							 lastName:String = "", firstName:String = "", 
							 isTeacher:Boolean = false, password:String = "", 
							 entriesSum:int = 0, id:int = UNSAVED_ID, notes:String = "", isAdmin:Boolean = false)
		{
			this.officialId = officialId;
			this.login = login;
			this.email = email;
			this.lastName = lastName;
			this.firstName = firstName;
			this.isTeacher = isTeacher;
			this.isAdmin = isAdmin
			this.password = password;
			this.entriesSum = entriesSum;
			this.notes = notes;
			this.id = id;
		}
		
		public function setCourses(list:XMLList):void
		{
			var coursesArray:Array = [];
			var item:XML;
			for each (item in list)
			{
				var course:Course = Course.fromXML(item);
				coursesArray.push(course);
			}
			coursesArray.sortOn("officialId");
			this.courses = new ArrayCollection(coursesArray);
		}
		
		public function addCourse(course:Course):void
		{
			var coursesArray:Array = [];
			coursesArray.push(course);
			if (this.courses == null)
			{
				this.courses = new ArrayCollection(coursesArray);
			}
			else if (!this.courses.contains(course))
			{
				this.courses.addItem(course);
			}
			var sortByOfficialIdAsc:Sort = new Sort();
			sortByOfficialIdAsc.fields = [new SortField("officialId")];
			this.courses.sort = sortByOfficialIdAsc;
			this.courses.refresh();
		}
		
		public function updateCourse(course:Course):void
		{
			for (var i:int = 0; i < courses.length; i++)
			{
				var ithCourse:Course = Course(courses.getItemAt(i));
				if (ithCourse.id == course.id)
				{
					courses.setItemAt(course, i);
					break;
				}
			}
		}
		
		public function removeCourse(course:Course):void
		{
			for (var i:int = 0; i < courses.length; i++)
			{
				var ithCourse:Course = Course(courses.getItemAt(i));
				if (ithCourse.id == course.id)
				{
					courses.removeItemAt(i);
					break;
				}
			}
		}
		
		public function toXML():XML
		{
			var retval:XML = 
				<user>
					<official_id>{officialId}</official_id>
					<login>{login}</login>
					<email>{email}</email>
					<last_name>{lastName}</last_name>
					<first_name>{firstName}</first_name>
					<is_teacher>{isTeacher}</is_teacher>
					<password>{password}</password>
					<password_confirmation>{password}</password_confirmation>
					<entries_sum>{entriesSum}</entries_sum>
					<comment>{notes}</comment>
				</user>;
			return retval;
		}
		
		public function toUpdateObject():Object
		{
			var obj:Object = {};
			obj["login"] = login;
			obj["current_password"] = notes;
			obj["user[login]"] = login;
			obj["user[email]"] = email;
			obj["user[official_id]"] = officialId;
			obj["user[first_name]"] = firstName;
			obj["user[last_name]"] = lastName;
			obj["user[password]"] = password;
			obj["user[password_confirmation]"] = password
			obj["user[is_teacher]"] = isTeacher;
			return obj;
		} 
		
		public static function fromXML(userXML:XML):User
		{
			var user:User = new User();
			user.officialId = userXML.official_id;
			user.login = userXML.login;
			user.email = userXML.email;
			user.lastName = userXML.last_name;
			user.firstName = userXML.first_name;
			user.isTeacher = XMLUtils.xmlListToBoolean(userXML.is_teacher);
			user.isAdmin = XMLUtils.xmlListToBoolean(userXML.is_admin);
			user.entriesSum = userXML.entries_sum;
			user.notes = userXML.comment;
			user.id = userXML.id;
			
			return user;
		}
	}
}