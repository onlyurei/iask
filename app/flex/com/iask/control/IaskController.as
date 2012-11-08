package com.iask.control
{
	import com.adobe.cairngorm.control.FrontController;
	import com.iask.control.EventNames;
	import com.iask.command.*;

	public class IaskController extends FrontController
	{
		public function IaskController()
		{
			initializeCommands();
		}
		
		private function initializeCommands():void
		{
			addCommand(EventNames.ADD_COURSE_USER, AddCourseUserCommand);
			addCommand(EventNames.ADD_USER_COURSE, AddUserCourseCommand);
			addCommand(EventNames.CREATE_COURSE, CreateCourseCommand);
			addCommand(EventNames.CREATE_ENTRY, CreateEntryCommand);
			addCommand(EventNames.CREATE_KEYWORD, CreateKeywordCommand);
			addCommand(EventNames.CREATE_QUERY, CreateQueryCommand);
			addCommand(EventNames.CREATE_QUERIES, CreateQueriesCommand);
			addCommand(EventNames.CREATE_NOTE, CreateNoteCommand);
			addCommand(EventNames.CREATE_USER, CreateUserCommand);
			addCommand(EventNames.CREATE_SESSION, CreateSessionCommand);
			addCommand(EventNames.DESTROY_COURSE, DestroyCourseCommand);
			addCommand(EventNames.DESTROY_ENTRY, DestroyEntryCommand);
			addCommand(EventNames.DESTROY_RELEVANCE, DestroyRelevanceCommand);
			addCommand(EventNames.DESTROY_QUERY, DestroyQueryCommand);
			addCommand(EventNames.DESTROY_NOTE, DestroyNoteCommand);
			addCommand(EventNames.DESTROY_USER, DestroyUserCommand);
			addCommand(EventNames.DESTROY_USER_BY_OFFICIAL_ID, DestroyUserByOfficialIdCommand);
			addCommand(EventNames.DELETE_COURSE_USER, DeleteCourseUserCommand);
			addCommand(EventNames.DELETE_USER_COURSE, DeleteUserCourseCommand);
			addCommand(EventNames.LIST_ALL_COURSES, ListAllCoursesCommand);
			addCommand(EventNames.LIST_COURSES, ListCoursesCommand);
			addCommand(EventNames.LIST_COURSE_KEYWORDS, ListCourseKeywordsCommand);
			addCommand(EventNames.LIST_COURSE_ENTRIES, ListCourseEntriesCommand);
			addCommand(EventNames.LIST_ENTRY_KEYWORDS, ListEntryKeywordsCommand);
			addCommand(EventNames.LIST_ENTRY_RELEVANCES, ListEntryRelevancesCommand);
			addCommand(EventNames.LIST_KEYWORD_ENTRIES, ListKeywordEntriesCommand);
			addCommand(EventNames.LIST_UNSOLVED_QUERIES, ListUnsolvedQueriesCommand);
			addCommand(EventNames.LIST_SOLVED_QUERIES, ListSolvedQueriesCommand);
			addCommand(EventNames.LIST_QUERIES, ListQueriesCommand);
			addCommand(EventNames.LIST_NOTES, ListNotesCommand);
			addCommand(EventNames.LIST_COURSE_TEACHERS, ListCourseTeachersCommand);
			addCommand(EventNames.LIST_COURSE_STUDENTS, ListCourseStudentsCommand);
			addCommand(EventNames.LIST_ALL_STUDENTS, ListAllStudentsCommand);
			addCommand(EventNames.LIST_ALL_TEACHERS, ListAllTeachersCommand);
			addCommand(EventNames.LIST_USER_COURSES, ListUserCoursesCommand);
			addCommand(EventNames.UPDATE_COURSE, UpdateCourseCommand);
			addCommand(EventNames.UPDATE_ENTRY, UpdateEntryCommand);
			addCommand(EventNames.UPDATE_KEYWORD, UpdateKeywordCommand);
			addCommand(EventNames.UPDATE_QUERY, UpdateQueryCommand);
			addCommand(EventNames.UPDATE_NOTE, UpdateNoteCommand);
			addCommand(EventNames.UPDATE_USER, UpdateUserCommand);
			addCommand(EventNames.UPDATE_USER_PASSWORD, UpdateUserPasswordCommand);
			addCommand(EventNames.LOG_OUT, LogoutCommand);
		}
	}
}