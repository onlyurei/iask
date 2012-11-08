package com.iask.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.iask.business.UserDelegate;
	import com.iask.model.IaskModelLocator;
	import com.iask.model.Course;
	
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.rpc.IResponder;

	public class AddUserCourseCommand implements ICommand, IResponder
	{
		public function AddUserCourseCommand()
		{
		}
		
		private var _model:IaskModelLocator = IaskModelLocator.getInstance();
		private var _officialId:String;

		public function execute(event:CairngormEvent):void
		{
			CursorManager.setBusyCursor();
			var delegate:UserDelegate = new UserDelegate(this);
			_officialId = event.data;
			delegate.addCourse(_model.selectedUser, _officialId);
		}
		
		public function result(data:Object):void
		{
			CursorManager.removeAllCursors();
			if (data.result == "error")
			{
				Alert.show("您可能在这台计算机上用其他帐号登录了本系统。", "为用户添加课程失败");
			}
			else if (data.result == "course_not_exist")
			{
				Alert.show("找不到课程号为 “" + _officialId + "” 的课程。", "为用户添加课程失败");
			}
			else if (data.result == "course_exists")
			{
				Alert.show("课程号为 “" + _officialId + "” 的课程已在用户课程列表中。", "为用户添加课程失败");
			}
			else
			{
				var course:Course = Course.fromXML(data.result);
				_model.selectedUser.addCourse(course);
			}
		}
		
		public function fault(info:Object):void
		{
			CursorManager.removeAllCursors();
			Alert.show("这可能是由以下几个原因之一或者多个而引起：\n\n1. 您电脑的网络连接出了故障；\n\n2. 服务器出了故障。", 
			"为用户添加课程失败");
		}
		
	}
}