package com.iask.business
{
	import com.iask.model.Query;
	import com.iask.util.ServiceUtils;
	
	import mx.rpc.IResponder;
	
	public class QueryDelegate
	{
		private var _responder:IResponder;
		
		public function QueryDelegate(responder:IResponder)
		{
			_responder = responder;
		}
		
		public function listUnsolvedQueries():void
		{
			ServiceUtils.send("/queries/unsolved.xml", _responder);
		}
		
		public function listSolvedQueries():void
		{
			ServiceUtils.send("/queries/solved.xml",  _responder);
		}
		
		public function listQueries():void
		{
			ServiceUtils.send("/queries.xml", _responder);
		}
		
		public function updateQuery(query:Query):void
		{
			ServiceUtils.send("/queries/" + query.id + ".xml", _responder, "PUT", query.toUpdateObject()); 
		}
		
		public function destroyQuery(query:Query):void
		{
			ServiceUtils.send("/queries/" + query.id + ".xml", _responder, "DELETE");
		}
	}
}