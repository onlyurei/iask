package com.iask.business
{
	import com.iask.model.Course;
	import com.iask.model.Entry;
	import com.iask.model.Keyword;
	import com.iask.util.ServiceUtils;
	
	import mx.rpc.IResponder;
	
	public class EntryDelegate
	{
		private var _responder:IResponder;
		
		public function EntryDelegate(responder:IResponder)
		{
			_responder = responder;
		}
		
		public function createKeyword(keyword:Keyword):void
		{
			ServiceUtils.send("/entries/" + keyword.entry.id + "/create_keyword.xml", _responder, "POST",
				keyword.toCreateObject());
		}
		
		public function listEntries(courseId:int):void
		{
			ServiceUtils.send("/courses/" + courseId + "/list_entries.xml", _responder);
		}
		
		public function listKeywords(entry:Entry):void
		{
			ServiceUtils.send("/entries/" + entry.id + "/list_keywords.xml", _responder);
		}
		
		public function listRelevances(entry:Entry):void
		{
			ServiceUtils.send("/entries/" + entry.id + "/list_relevances.xml", _responder);
		}
		
		public function listKeywordEntries(keywords:String, course:Course):void
		{
			var obj:Object = {};
			obj["keywords"] = keywords;
			obj["course_id"] = course.id;
			ServiceUtils.send("/keywords/list_entries.xml", _responder, "GET", obj);
		}
		
		public function updateEntry(entry:Entry):void
		{
			ServiceUtils.send("/entries/" + entry.id + ".xml", _responder, "PUT", 
				entry.toUpdateObject());
		}
		
		public function updateKeyword(keyword:Keyword):void
		{
			ServiceUtils.send("/entries/" + keyword.entry.id + "/update_keyword.xml", _responder, "PUT",
				keyword.toUpdateObject());
		}
		
		public function destroyEntry(entry:Entry):void
		{
			ServiceUtils.send("/entries/" + entry.id + ".xml", _responder, "DELETE");
		}
		
		public function destroyRelevance(entry:Entry, keyword:Keyword):void
		{
			ServiceUtils.send("/entries/" + entry.id + "/destroy_relevance.xml", _responder, "DELETE", 
				keyword.toDestroyObject());
		}
	}
}