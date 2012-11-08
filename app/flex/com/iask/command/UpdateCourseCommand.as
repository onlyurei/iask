package com.iask.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.iask.business.CourseDelegate;
	import com.iask.control.EventNames;
	import com.iask.model.IaskModelLocator;
	import com.iask.model.Course;
	import com.iask.util.CairngormUtils;
	import mx.controls.Alert;
	
	import mx.managers.CursorManager;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	public class UpdateCourseCommand implements ICommand, IResponder
	{
		public function UpdateCourseCommand()
		{
		}

		private var _course:Course;
		
		public function execute(event:CairngormEvent):void
		{
			CursorManager.setBusyCursor();
			var delegate:CourseDelegate = new CourseDelegate(this);
			_course = Course(event.data);
			delegate.updateCourse(_course);
		}
		
		public function result(data:Object):void
		{
			CursorManager.removeAllCursors();
			if (data.result == "success")
			{
				var model:IaskModelLocator = IaskModelLocator.getInstance();
				model.updateCourse(_course);
				Alert.show("修改课程成功。");
			}
			else if (data.result == "error")
			{
				Alert.show("您可能在这台计算机上用其他帐号登录了本系统。", "修改课程失败");
			}
			else
			{
				Alert.show("服务器出错，请稍候再试。", "修改课程失败");
			}
		}
		
		public function fault(info:Object):void
		{
			CursorManager.removeAllCursors();
			Alert.show("这可能是由以下几个原因之一或者多个而引起：\n\n1. 您电脑的网络连接出了故障；\n\n2. 服务器出了故障。", "修改课程失败");
		}
		
	}
}