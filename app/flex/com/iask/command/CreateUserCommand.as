package com.iask.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.iask.business.UserDelegate;
	import com.iask.model.IaskModelLocator;
	import com.iask.model.User;
	import com.iask.validators.ServerErrors;
	
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	public class CreateUserCommand implements ICommand, IResponder
	{
		public function CreateUserCommand()
		{
		}

		private var _user:User;

		public function execute(event:CairngormEvent):void
		{
			var delegate:UserDelegate = new UserDelegate(this);
			_user = User(event.data);
			delegate.createUser(_user);
			CursorManager.setBusyCursor();
		}
		
		public function result(data:Object):void
		{
			CursorManager.removeAllCursors();
			var result:Object = data.result;
			var model:IaskModelLocator = IaskModelLocator.getInstance();
			if (result == "error")
			{
				Alert.show("您可能在这台计算机上用其他帐号登录了本系统。", "创建用户失败");
			}
			else
			{
				var resultXML:XML = XML(data.result);
				if (resultXML.name().localName == "errors")
				{
					Alert.show("请改正表单上用红色线框标出的错误。",
					"创建用户失败");
					model.accountCreateErrors = new ServerErrors(resultXML);
				}
				else
				{
					if (_user.lastName != "(未" && _user.firstName != "命名)")
					{
						Alert.show("创建用户成功");
					}
					if (_user.isTeacher)
					{
						model.addTeacher(User.fromXML(XML(data.result)));
					}
					else if (!_user.isAdmin)
					{
						model.addStudent(User.fromXML(XML(data.result)));
					}
				}
			}
		}
		
		public function fault(info:Object):void
		{
			CursorManager.removeAllCursors();
			Alert.show("这可能是由以下几个原因之一或者多个而引起：\n\n1. 您电脑的网络连接出了故障；\n\n2. 服务器出了故障。", 
			"创建用户失败");
		}
	}
}