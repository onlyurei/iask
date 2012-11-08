package com.iask.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.iask.business.UserDelegate;
	import com.iask.control.EventNames;
	import com.iask.model.IaskModelLocator;
	import com.iask.model.User;
	import com.iask.util.CairngormUtils;
	import com.iask.validators.ServerErrors;
	
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	public class UpdateUserCommand implements ICommand, IResponder
	{
		public function UpdateUserCommand()
		{
		}
		
		private var _model:IaskModelLocator = IaskModelLocator.getInstance();
		private var _user:User;
		
		public function execute(event:CairngormEvent):void
		{
			CursorManager.setBusyCursor();
			var delegate:UserDelegate = new UserDelegate(this);
			_user = event.data;
			delegate.updateUser(_user);
		}
		
		public function result(data:Object):void
		{
			CursorManager.removeAllCursors();
			if (data.result == "error")
			{
				Alert.show("您可能在这台计算机上用其他帐号登录了本系统。", "修改用户失败");
			}
			else
			{
				var resultXML:XML = XML(data.result);
				if (resultXML.name().localName == "errors")
				{
					Alert.show("请改正表单上用红色线框标出的错误。",
					"修改用户失败");
					_model.accountCreateErrors = new ServerErrors(resultXML);
					return;
				}
				else
				{
					Alert.show("修改用户成功。");
					if (_model.selectedUser.isTeacher)
					{
						_model.updateTeacher(_user);
					}
					else
					{
						_model.updateStudent(_user);
					}
				}
			}
		}
		
		public function fault(info:Object):void
		{
			CursorManager.removeAllCursors();
			Alert.show("这可能是由以下几个原因之一或者多个而引起：\n\n1. 您电脑的网络连接出了故障；\n\n2. 服务器出了故障。", "修改用户失败");
		}
		
	}
}