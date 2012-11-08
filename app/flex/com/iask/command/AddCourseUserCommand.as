package com.iask.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.iask.business.CourseDelegate;
	import com.iask.model.IaskModelLocator;
	import com.iask.model.User;
	
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.rpc.IResponder;

	public class AddCourseUserCommand implements ICommand, IResponder
	{
		public function AddCourseUserCommand()
		{
		}
		
		private var _model:IaskModelLocator = IaskModelLocator.getInstance();
		private var _officialId:String;

		public function execute(event:CairngormEvent):void
		{
			CursorManager.setBusyCursor();
			var delegate:CourseDelegate = new CourseDelegate(this);
			_officialId = event.data;
			delegate.addUser(_model.selectedCourse, _officialId);
		}
		
		public function result(data:Object):void
		{
			CursorManager.removeAllCursors();
			if (data.result == "error")
			{
				Alert.show("您可能在这台计算机上用其他帐号登录了本系统。", "为课程添加用户失败");
			}
			else if (data.result == "user_not_exist")
			{
				Alert.show("找不到学工号为 “" + _officialId + "” 的用户。", "为课程添加用户失败");
			}
			else if (data.result == "user_exists")
			{
				Alert.show("学工号为 “" + _officialId + "” 的用户已在课程用户列表中。", "为课程添加用户失败");
			}
			else
			{
				var user:User = User.fromXML(data.result);
				if (user.isTeacher)
				{
					_model.selectedCourse.addTeacher(user);
				}
				else
				{
					_model.selectedCourse.addStudent(user);
				}
			}
		}
		
		public function fault(info:Object):void
		{
			CursorManager.removeAllCursors();
			Alert.show("这可能是由以下几个原因之一或者多个而引起：\n\n1. 您电脑的网络连接出了故障；\n\n2. 服务器出了故障。", 
			"为课程添加用户失败");
		}
		
	}
}