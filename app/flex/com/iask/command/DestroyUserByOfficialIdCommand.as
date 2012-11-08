package com.iask.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.iask.business.UserDelegate;
	import com.iask.control.EventNames;
	import com.iask.model.IaskModelLocator;
	import com.iask.model.User;
	import com.iask.util.CairngormUtils;
	
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	public class DestroyUserByOfficialIdCommand implements ICommand, IResponder
	{
		public function DestroyUserByOfficialIdCommand()
		{
		}
		
		private var _user:User = null;
		private var _officialId:String;
		private var _model:IaskModelLocator = IaskModelLocator.getInstance();

		public function execute(event:CairngormEvent):void
		{
			CursorManager.setBusyCursor();
			var delegate:UserDelegate = new UserDelegate(this);
			_officialId = event.data;
			if (_model.students != null)
			{
				for each (var student:User in _model.students)
				{
					if (student.officialId == _officialId)
					{
						_user = student;
					}
				}
			}
			if (_user == null)
			{
				if (_model.teachers != null)
				{
					for each (var teacher:User in _model.teachers)
					{
						if (teacher.officialId == _officialId)
						{
							_user = teacher;
						}
					}
				}
			}
			delegate.destroyUserByOfficialId(_officialId);
		}
		
		public function result(data:Object):void
		{
			CursorManager.removeAllCursors();
			var model:IaskModelLocator = IaskModelLocator.getInstance();
			if (data.result == "error")
			{
				Alert.show("学工号为 “" + _officialId + "” 的用户不存在，或者您可能在这台计算机上用其他帐号登录了本系统", "批量删除用户失败");
			}
			else
			{
				if (_user != null)
				{
					if (_user.isTeacher)
					{
						model.removeTeacher(_user);
					}
					else if (!_user.isAdmin)
					{
						model.removeStudent(_user);
					}
				}
			}
		}
		
		public function fault(info:Object):void
		{
			CursorManager.removeAllCursors();
			Alert.show("这可能是由以下几个原因之一或者多个而引起：\n\n1. 您电脑的网络连接出了故障；\n\n2. 服务器出了故障。", "批量删除用户失败");
		}
		
	}
}