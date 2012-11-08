package com.iask.business
{
	import com.iask.model.User;
	import com.iask.util.ServiceUtils;
	
	import mx.rpc.IResponder;
	
	public class UserDelegate
	{
		private var _responder:IResponder;
		
		public function UserDelegate(responder:IResponder)
		{
			_responder = responder;
		}
		
		public function createUser(user:User):void
		{
			ServiceUtils.send("/users.xml", _responder, "POST", user.toXML(), true);
		}
		
		public function listCourses(user:User):void
		{
			ServiceUtils.send("/users/" + user.id + "/list_courses.xml", _responder);
		}
		
		public function listAllStudents():void
		{
			ServiceUtils.send("/users/students.xml", _responder);
		}
		
		public function listAllTeachers():void
		{
			ServiceUtils.send("/users/teachers.xml", _responder);
		}
		
		public function updateUserPassword(user:User):void
		{
			ServiceUtils.send("/users/" + user.id + "/update_password.xml", _responder, "PUT", 
				user.toUpdateObject());
		}
		
		public function updateUser(user:User):void
		{
			ServiceUtils.send("/users/" + user.id + ".xml", _responder, "PUT", 
				user.toUpdateObject());
		}
		
		public function addCourse(user:User, courseOfficialId:String):void
		{
			var obj:Object = {};
			obj["course_official_id"] = courseOfficialId;
			ServiceUtils.send("/users/" + user.id + "/add_course.xml", _responder, "PUT", obj);
		}
		
		public function destroyUser(user:User):void
		{
			ServiceUtils.send("/users/" + user.id + ".xml", _responder, "DELETE");
		}
		
		public function destroyUserByOfficialId(officialId:String):void
		{
			var obj:Object = {};
			obj["official_id"] = officialId;
			ServiceUtils.send("/users/destroy_by_official_id.xml", _responder, "DELETE", obj);
		}
	}
}