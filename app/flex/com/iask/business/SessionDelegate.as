package com.iask.business
{
	import com.iask.util.ServiceUtils;
	
	import mx.rpc.IResponder;
	
	public class SessionDelegate
	{
		private var _responder:IResponder;
		
		public function SessionDelegate(responder:IResponder)
		{
			_responder = responder;
		}
		
		public function createSession(login:String, password:String):void
		{
			ServiceUtils.send("/session.xml/", _responder, "POST", {login: login, password: password});
		}
		
		public function destroySession():void
		{
			ServiceUtils.send("/session.xml/", _responder, "DELETE");
		}
	}
}