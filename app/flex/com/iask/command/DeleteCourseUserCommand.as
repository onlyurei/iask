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

	public class DeleteCourseUserCommand implements ICommand, IResponder
	{
		public function DeleteCourseUserCommand()
		{
		}
		
		private var _model:IaskModelLocator = IaskModelLocator.getInstance();
		private var _user:User;

		public function execute(event:CairngormEvent):void
		{
			CursorManager.setBusyCursor();
			var delegate:CourseDelegate = new CourseDelegate(this);
			_user= User(event.data);
			delegate.deleteUser(_model.selectedCourse, _user.id);
		}
		
		public function result(data:Object):void
		{
			CursorManager.removeAllCursors();
			if (data.result == "error")
			{
				Alert.show("您可能在这台计算机上用其他帐号登录了本系统。", "移除课程用户失败");
			}
			else
			{
				if (_user.isTeacher)
				{
					_model.selectedCourse.removeTeacher(_user)
				}
				else
				{
					_model.selectedCourse.removeStudent(_user);
				}
			}
		}
		
		public function fault(info:Object):void
		{
			CursorManager.removeAllCursors();
			Alert.show("这可能是由以下几个原因之一或者多个而引起：\n\n1. 您电脑的网络连接出了故障；\n\n2. 服务器出了故障。", 
			"移除课程用户失败");
		}
		
	}
}