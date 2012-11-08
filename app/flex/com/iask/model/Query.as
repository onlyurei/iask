package com.iask.model
{	
	import com.iask.util.XMLUtils;
	
	public class Query
	{
		public static const UNSAVED_ID:int = 0;
		
		[Bindable]
		public var question:String;
		
		[Bindable]
		public var solved:Boolean;
		
		[Bindable]
		public var notes:String;
		
		[Bindable]
		public var course:Course;
		
		[Bindable]
		public var courseOfficialId:String;
		
		[Bindable]
		public var courseName:String;
		
		[Bindable]
		public var studentOfficialId:String;
		
		[Bindable]
		public var studentLastName:String;
		
		[Bindable]
		public var studentFirstName:String;
		
		[Bindable]
		public var teacherOfficialId:String;
		
		[Bindable]
		public var teacherLastName:String;
		
		[Bindable]
		public var teacherFirstName:String;
		
		[Bindable]
		public var teacher:User;
		
		[Bindable]
		public var answer:String;	
		
		[Bindable]
		public var id:int;
		
		
		public function Query(question:String = "", solved:Boolean = false, notes:String = null, 
			course:Course = null, courseOfficialId:String = "", courseName:String = "",
			studentOfficialId:String = "", studentLastName:String = "", studentFirstName:String = "",
			teacherOfficialId:String = "", teacherLastName:String = "", teacherFirstName:String = "", 
			teacher:User = null,
			answer:String = null, id:int = UNSAVED_ID)
		{
			this.question = question;
			this.solved = solved;
			this.notes = notes;
			if (course == null)
			{
				this.course = Course.NONE;
			}
			else
			{
				this.course = course;
			}
			this.courseOfficialId = courseOfficialId;
			this.courseName = courseName;
			this.studentOfficialId = studentOfficialId;
			this.studentLastName = studentLastName;
			this.studentFirstName = studentFirstName;
			this.teacherOfficialId = teacherOfficialId;
			this.teacherLastName = teacherLastName;
			this.teacherFirstName = teacherFirstName;
			this.teacher = teacher;
			this.answer = answer;
			this.id = id;
			this.course.addQuery(this);
		}
		
		public function toUpdateObject():Object
		{
			var obj:Object = {};
			obj["query[question]"] = question;
			obj["query[answer]"] = answer;
			obj["query[solved]"] = solved;
			obj["query[notes]"] = notes;
			return obj;
		}
		
		public function toCreateObject():Object
		{
			var obj:Object = {};
			obj["query[question]"] = question;
			obj["query[solved]"] = solved;
			obj["query[notes]"] = notes;
			obj["query[course_official_id]"] = courseOfficialId;
			obj["query[course_name]"] = courseName;
			obj["query[student_official_id]"] = studentOfficialId;
			obj["query[student_last_name]"] = studentLastName;
			obj["query[student_first_name]"] = studentFirstName;
			obj["query[teacher_official_id]"] = teacherOfficialId;
			obj["query[teacher_last_name]"] = teacherLastName;
			obj["query[teacher_first_name]"] = teacherFirstName;
			obj["teacher_id"] = teacher.id;
			return obj;
		}
		
		public function toXML():XML
		{
			var retval:XML =
				<query>
					<question>{question}</question>
					<solved>{solved}</solved>
					<notes>{notes}</notes>
					<course_official_id>{courseOfficialId}</course_official_id>
					<course_name>{courseName}</course_name>
					<student_official_id>{studentOfficialId}</student_official_id>
					<student_last_name>{studentLastName}</student_last_name>
					<student_first_name>{studentFirstName}</student_first_name>
				</query>;
			return retval;
		}
		
		public static function fromXML(queryXML:XML):Query
		{
			var model:IaskModelLocator = IaskModelLocator.getInstance();
			return new Query(queryXML.question, XMLUtils.xmlListToBoolean(queryXML.solved), queryXML.notes,
				model.getCourse(queryXML.course_id), queryXML.course_official_id, queryXML.course_name,
				queryXML.student_official_id, queryXML.student_last_name, queryXML.student_first_name,
				queryXML.teacher_official_id, queryXML.teacher_last_name, queryXML.teacher_first_name, null,
				queryXML.answer, queryXML.id);
		}
	}
}