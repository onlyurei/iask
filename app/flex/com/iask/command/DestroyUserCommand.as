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

	public class DestroyUserCommand implements ICommand, IResponder
	{
		public function DestroyUserCommand()
		{
		}
		
		private var _user:User;

		public function execute(event:CairngormEvent):void
		{
			var delegate:UserDelegate = new UserDelegate(this);
			_user = User(event.data);
			delegate.destroyUser(_user);
			CursorManager.setBusyCursor();
		}
		
		public function result(data:Object):void
		{
			CursorManager.removeAllCursors();
			var model:IaskModelLocator = IaskModelLocator.getInstance();
			if (data.result == "error")
			{
				Alert.show("您可能在这台计算机上用其他帐号登录了本系统。", "删除用户失败");
			}
			else
			{
				if (_user.isTeacher)
				{
					model.removeTeacher(_user);
				}
				else if (!_user.isAdmin)
				{
					model.removeStudent(_user);
				}
				model.selectedUser = null;
			}
		}
		
		public function fault(info:Object):void
		{
			CursorManager.removeAllCursors();
			Alert.show("这可能是由以下几个原因之一或者多个而引起：\n\n1. 您电脑的网络连接出了故障；\n\n2. 服务器出了故障。", "删除用户失败");
		}
		
	}
}