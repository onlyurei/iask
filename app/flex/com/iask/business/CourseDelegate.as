package com.iask.business
{
	import com.iask.model.Course;
	import com.iask.model.Entry;
	import com.iask.model.Query;
	import com.iask.model.User;
	import com.iask.util.ServiceUtils;
	
	import mx.rpc.IResponder;
	
	public class CourseDelegate
	{
		private var _responder:IResponder;
		
		public function CourseDelegate(responder:IResponder)
		{
			_responder = responder;
		}
		
		public function listCourses():void
		{
			ServiceUtils.send("/courses.xml", _responder);
		}
		
		public function listAllCourses():void
		{
			ServiceUtils.send("/courses/list_all.xml", _responder);
		}
		
		public function listEntries(course:Course):void
		{
			ServiceUtils.send("/courses/" + course.id + "/list_entries.xml", _responder);
		}
		
		public function listKeywords(course:Course):void
		{
			ServiceUtils.send("/courses/" + course.id + "/list_keywords.xml", _responder);
		}
		
		public function listStudents(course:Course):void
		{
			ServiceUtils.send("/courses/" + course.id + "/list_students.xml", _responder);
		}
		
		public function listTeachers(course:Course):void
		{
			ServiceUtils.send("/courses/" + course.id + "/list_teachers.xml", _responder);
		}
		
		public function createCourse(course:Course):void
		{
			ServiceUtils.send("/courses.xml", _responder, "POST", course.toXML(), true);
		}
		
		public function createEntry(course:Course, entry:Entry):void
		{
			ServiceUtils.send("/courses/" + course.id + "/create_entry.xml", _responder, "POST", entry.toCreateObject());
		}
		
		public function createQuery(course:Course, query:Query):void
		{
			ServiceUtils.send("/courses/" + course.id + "/create_query.xml", _responder, "POST", query.toCreateObject());
		}
		
		public function createQueries(course:Course, query:Query):void
		{
			ServiceUtils.send("/courses/" + course.id + "/create_queries.xml", _responder, "POST", query.toXML(), true);
		}
		
		public function addUser(course:Course, userOfficialId:String):void
		{
			var obj:Object = {};
			obj["user_official_id"] = userOfficialId;
			ServiceUtils.send("/courses/" + course.id + "/add_user.xml", _responder, "PUT", obj);
		}
		
		public function deleteUser(course:Course, userId:int):void
		{
			var obj:Object = {};
			obj["user_id"] = userId;
			ServiceUtils.send("/courses/" + course.id + "/delete_user.xml", _responder, "PUT", obj);
		}
		
		public function updateCourse(course:Course):void
		{
			ServiceUtils.send("/courses/" + course.id + ".xml", _responder, "PUT", course.toUpdateObject());
		}
		
		public function destroyCourse(course:Course):void
		{
			ServiceUtils.send("/courses/" + course.id + ".xml", _responder, "DELETE");
		}
	}
}