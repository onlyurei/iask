package com.iask.util
{
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;
	
	public class ServiceUtils
	{
		public static function send(url:String, responder:IResponder = null, 
		    method:String = null, request:Object = null, sendXML:Boolean = false, resultFormat:String = "e4x",
		    useProxy:Boolean = false):void
		{
			var service:HTTPService = new HTTPService();
			service.url = url;
			service.contentType = sendXML ? "application/xml" : "application/x-www-form-urlencoded";
			service.resultFormat = resultFormat;
			if (method == null)
			{
				service.method = (request == null) ? "GET" : "POST";
			}
			else if (method == "PUT" || method == "DELETE")
			{
				service.method = "POST";
				if (request == null)
				{
					request = {};
				}
				request["_method"] = method;
			}
			else
			{
				service.method = method;
			}
			service.request = request;
			service.useProxy = useProxy;
			var call:AsyncToken = service.send();
			if (responder != null)
			{
				call.addResponder(responder);
			}
		}

	}
}