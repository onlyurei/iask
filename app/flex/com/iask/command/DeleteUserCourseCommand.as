package com.iask.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.iask.business.CourseDelegate;
	import com.iask.model.IaskModelLocator;
	import com.iask.model.Course;
	
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.rpc.IResponder;

	public class DeleteUserCourseCommand implements ICommand, IResponder
	{
		public function DeleteUserCourseCommand()
		{
		}
		
		private var _model:IaskModelLocator = IaskModelLocator.getInstance();
		private var _course:Course;

		public function execute(event:CairngormEvent):void
		{
			CursorManager.setBusyCursor();
			var delegate:CourseDelegate = new CourseDelegate(this);
			_course= Course(event.data);
			delegate.deleteUser(_course, _model.selectedUser.id);
		}
		
		public function result(data:Object):void
		{
			CursorManager.removeAllCursors();
			if (data.result == "error")
			{
				Alert.show("您可能在这台计算机上用其他帐号登录了本系统。", "移除用户课程失败");
			}
			else
			{
				_model.selectedUser.removeCourse(_course);
			}
		}
		
		public function fault(info:Object):void
		{
			CursorManager.removeAllCursors();
			Alert.show("这可能是由以下几个原因之一或者多个而引起：\n\n1. 您电脑的网络连接出了故障；\n\n2. 服务器出了故障。", 
			"移除用户课程失败");
		}
		
	}
}