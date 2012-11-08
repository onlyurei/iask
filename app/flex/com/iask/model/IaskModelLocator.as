package com.iask.model
{
	import com.adobe.cairngorm.model.IModelLocator;
	import com.iask.control.EventNames;
	import com.iask.util.CairngormUtils;
	import com.iask.validators.ServerErrors;
	
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ListCollectionView;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.core.Application;
	import mx.events.CollectionEvent;
	
	[Bindable]
	public class IaskModelLocator implements IModelLocator
	{	    
		public static const VIEWING_SPLASH_SCREEN:int = 0;
		public static const VIEWING_STUDENT_MAIN_BOX:int = 1;
		public static const VIEWING_TEACHER_MAIN_BOX:int = 2;
		public static const VIEWING_ADMIN_MAIN_BOX:int = 3;
		public static const VIEWING_STUDENT_MAIN_BOX_QUERY_SUBMIT_TAB:int = 4;
		public static const VIEWING_STUDENT_MAIN_BOX_QUERY_HISTORY_TAB:int = 5;
		public static const VIEWING_STUDENT_MAIN_BOX_NOTE_TAB:int = 6;
		public static const VIEWING_TEACHER_MAIN_BOX_QUERY_HISTORY_TAB:int = 7;
		public static const VIEWING_TEACHER_MAIN_BOX_ENTRY_SUBMIT_TAB:int = 8;
		public static const VIEWING_TEACHER_MAIN_BOX_REGISTER_TAB:int = 9;
		public static const VIEWING_TEACHER_MAIN_BOX_NOTE_TAB:int = 10;
		public static const VIEWING_SEARCH_RESULT_TAB:int = 11;
		public static const VIEWING_ADMIN_MAIN_BOX_ACCOUNT_MANAGE_TAB:int = 12;
		public static const VIEWING_ADMIN_MAIN_BOX_COURSE_MANAGE_TAB:int = 14;
		public static const VIEWING_ADMIN_MAIN_BOX_NOTE_TAB:int = 15;
		
		private var _user:User;
		
		public function set user(newUser:User):void
		{
			if (_user != newUser)
			{
				_user = newUser;
				if (_user != null)
				{
					_selectedCourse = Course.NONE;
					_selectedTeacher = User.TEACHER_NONE;
					if (user.isTeacher)
					{
						CairngormUtils.dispatchEvent(EventNames.LIST_COURSES);
						CairngormUtils.dispatchEvent(EventNames.LIST_UNSOLVED_QUERIES);
						workflowState = IaskModelLocator.VIEWING_TEACHER_MAIN_BOX;
						mainBoxTabState = IaskModelLocator.VIEWING_TEACHER_MAIN_BOX_QUERY_HISTORY_TAB;
						queriesFilterName = "unresponsed";
					}
					else if (user.isAdmin)
					{
						workflowState = IaskModelLocator.VIEWING_ADMIN_MAIN_BOX;
						mainBoxTabState = IaskModelLocator.VIEWING_ADMIN_MAIN_BOX_COURSE_MANAGE_TAB;
					}
					else
					{
						CairngormUtils.dispatchEvent(EventNames.LIST_COURSES);
						CairngormUtils.dispatchEvent(EventNames.LIST_UNSOLVED_QUERIES);
						workflowState = IaskModelLocator.VIEWING_STUDENT_MAIN_BOX;
						mainBoxTabState = IaskModelLocator.VIEWING_SEARCH_RESULT_TAB;
						queriesFilterName = "responsed";
					}
					
				}
				else
				{
					workflowState = IaskModelLocator.VIEWING_SPLASH_SCREEN;
				}
			}
		}
		
		public function get user():User
		{
			return _user;
		}
		
		public var searchKeywords:String = "";
		public var queriesFilterName:String;
		public var newKeywordName:String;
		public var newEntryName:String;
		public var newNoteContent:String;
		public var selectedNoteContent:String;
		public var courses:ListCollectionView;
		public var coursesAndNone:ListCollectionView;
		public var entries:ListCollectionView;
		public var keywords:ListCollectionView;
		public var queries:ListCollectionView;
		public var unsolvedQueries:ListCollectionView;
		public var solvedQueries:ListCollectionView;
		public var allQueries:ListCollectionView;
		public var students:ListCollectionView;
		public var studentsAndNone:ListCollectionView;
		public var teachers:ListCollectionView;
		public var teachersAndNone:ListCollectionView;
		public var teacherNone:ListCollectionView;
		public var notes:ListCollectionView;
		public var accountCreateErrors:ServerErrors;
		public var workflowState:int = IaskModelLocator.VIEWING_SPLASH_SCREEN;
		public var mainBoxTabState:int;
		public var sortByRelevanceDesc:Sort = new Sort();
		public var sortByIdDesc:Sort = new Sort();
		public var sortByOfficialIdAsc:Sort = new Sort();
		public var sortByNameAsc:Sort = new Sort();
		public var sortByLastNameAsc:Sort = new Sort();
		public var searchResultListRefreshButtonLabel:String = "查看此课程全部条目";
		private var _courseListSelectedItem:Course;
		public function set courseListSelectedItem(course:Course):void
		{
			if (course != null && course.isAllEntriesRetrieved)
			{
				_courseListSelectedItem = course;
				if (user.isTeacher)
				{
					Application.application.teacherMainBox.courseAndTeacherSelectBox.courseSelectBox.coursesList.selectedItem = _courseListSelectedItem;
				}
				else
				{
					Application.application.studentMainBox.courseAndTeacherSelectBox.courseSelectBox.coursesList.selectedItem = _courseListSelectedItem;
				}
			}
		}
		public function get courseListSelectedItem():Course
		{
			return _courseListSelectedItem;
		}
		public var selectedKeyword:String;
		private var _selectedUser:User;
		public function get selectedUser():User
		{
			return _selectedUser;
		}
		public function set selectedUser(user:User):void
		{
			_selectedUser = user;
			if (_selectedUser != null)
			{
				if (_selectedUser.courses == null)
				{
					CairngormUtils.dispatchEvent(EventNames.LIST_USER_COURSES, _selectedUser);
				}
			}
		}
		public var _selectedTeacher:User = User.TEACHER_NONE;
		public function set selectedTeacher(teacher:User):void
		{
			_selectedTeacher = teacher;
			if (_selectedTeacher == null)
			{
				_selectedTeacher = User.TEACHER_NONE;
			}
			if (_selectedTeacher == User.TEACHER_NONE)
			{
				selectedCourse.entries.filterFunction = null;
				selectedCourse.entries.refresh();
			}
			else
			{
				selectedCourse.entries.filterFunction = teacherFilterFunc;
				selectedCourse.entries.refresh();
			}
		}
		public function get selectedTeacher():User
		{
			return _selectedTeacher;
		}
		public var selectedEntry:Entry;
		private var _selectedCourse:Course;
		public function set selectedCourse(course:Course):void
		{
			_selectedTeacher = User.TEACHER_NONE;
			_selectedCourse = course;
			if (_selectedCourse != null && _selectedCourse != Course.NONE)
			{
				if (_selectedCourse.teachers == null)
				{
					CairngormUtils.dispatchEvent(EventNames.LIST_COURSE_TEACHERS, _selectedCourse);
				}
				if (_user.isAdmin)
				{
					if (_selectedCourse.students == null)
					{
						CairngormUtils.dispatchEvent(EventNames.LIST_COURSE_STUDENTS, _selectedCourse);
					}
				}
			}
			if (_user.isTeacher)
			{
				if (Course(Application.application.teacherMainBox.courseAndTeacherSelectBox.courseSelectBox.coursesList.selectedItem) != _selectedCourse)
				{
					if (!_selectedCourse.isAllEntriesRetrieved)
					{
						Application.application.teacherMainBox.courseAndTeacherSelectBox.courseSelectBox.coursesList.selectedItem = null;
						_courseListSelectedItem = null;
					}
					else
					{
						Application.application.teacherMainBox.courseAndTeacherSelectBox.courseSelectBox.coursesList.selectedItem = _selectedCourse;
						_courseListSelectedItem = _selectedCourse;
					}
				}
			}
			else if (!_user.isAdmin)
			{
				if (Course(Application.application.studentMainBox.courseAndTeacherSelectBox.courseSelectBox.coursesList.selectedItem) != _selectedCourse)
				{
					if (!_selectedCourse.isAllEntriesRetrieved)
					{
						Application.application.studentMainBox.courseAndTeacherSelectBox.courseSelectBox.coursesList.selectedItem = null;
						_courseListSelectedItem = null;
					}
					else
					{
						Application.application.studentMainBox.courseAndTeacherSelectBox.courseSelectBox.coursesList.selectedItem = _selectedCourse;
						_courseListSelectedItem = _selectedCourse;
					}
				}
			}
			if (!_user.isAdmin)
			{
				if (_courseListSelectedItem != null && _courseListSelectedItem.isAllEntriesRetrieved)
				{
					searchResultListRefreshButtonLabel = "刷新此课程问题库";
				}
				else
				{
					searchResultListRefreshButtonLabel = "查看此课程全部条目";
				}
			}
		}
		public function get selectedCourse():Course
		{
			return _selectedCourse;
		}
		
		
		public function teacherFilterFunc(item:Object):Boolean
        {
        	return item.userOfficialId == selectedTeacher.officialId;
        }
		
		public function getCourse(courseId:int):Course
		{
			for (var i:int = 0; i < courses.length; i++)
			{
				var ithCourse:Course = Course(courses.getItemAt(i));
				if (ithCourse.id == courseId)
				{
					return ithCourse;
				}
			}
			return null;
		}
		
		public function setCourses(list:XMLList):void
		{
			var coursesArray:Array = [];
			var item:XML;
			for each (item in list)
			{
				var course:Course = Course.fromXML(item);
				coursesArray.push(course);
			}
			coursesArray.sortOn("officialId");
			courses = new ArrayCollection(coursesArray);
			var coursesAndNoneArray:Array = coursesArray.slice(0);
			coursesAndNoneArray.splice(0, 0, Course.NONE);
			coursesAndNone = new ArrayCollection(coursesAndNoneArray);
		}
		
		public function updateCourse(course:Course):void
		{
			for (var i:int = 0; i < courses.length; i++)
			{
				var ithCourse:Course = Course(courses.getItemAt(i));
				if (ithCourse.id == course.id)
				{
					courses.setItemAt(course, i);
					break;
				}
			}
		}
		
		public function removeCourse(course:Course):void
		{
			for (var i:int = 0; i < courses.length; i++)
			{
				var ithCourse:Course = Course(courses.getItemAt(i));
				if (ithCourse.id == course.id)
				{
					courses.removeItemAt(i);
					break;
				}
			}
			courses.sort = sortByOfficialIdAsc;
			courses.refresh();
		}
		
		public function getEntry(entryId:int):Entry
		{
			for each(var i:Entry in entries)
			{
				if (i.id == entryId)
					return i;
			}
			return null;
		}
		
		public function setCourseEntries(course:Course, list:XMLList, isAllEntries:Boolean):void
		{
			var entriesArray:Array = [];
			var item:XML;
			for each (item in list)
			{
				var entry:Entry = Entry.fromXML(item);
				entriesArray.push(entry);
			}
			entriesArray.sortOn("id", Array.DESCENDING|Array.NUMERIC);
			course.entries = new ArrayCollection(entriesArray);
			if (isAllEntries)
			{
				course.isAllEntriesRetrieved = true;
			}
			else
			{
				course.isAllEntriesRetrieved = false;
			}
			for each (var i:Entry in course.entries)
			{
				i.course = course;
			}
			selectedTeacher = User.TEACHER_NONE;
			if (isAllEntries)
			{
				searchResultListRefreshButtonLabel = "刷新此课程问题库";
				_courseListSelectedItem = course;
				if (user.isTeacher)
				{
					Application.application.teacherMainBox.courseAndTeacherSelectBox.courseSelectBox.coursesList.selectedItem = _courseListSelectedItem;
				}
				else
				{
					Application.application.studentMainBox.courseAndTeacherSelectBox.courseSelectBox.coursesList.selectedItem = _courseListSelectedItem;
				}
			}
			else
			{
				searchResultListRefreshButtonLabel = "查看此课程全部条目";
				if (user.isTeacher)
				{
					Application.application.teacherMainBox.courseAndTeacherSelectBox.courseSelectBox.coursesList.selectedItem = null;
				}
				else
				{
					Application.application.studentMainBox.courseAndTeacherSelectBox.courseSelectBox.coursesList.selectedItem = null;
				}
			}
		}
		
		public function setEntries(list:XMLList):void
		{
			var entriesArray:Array = [];
			var item:XML;
			for each (item in list)
			{
				var entry:Entry = Entry.fromXML(item);
				entriesArray.push(entry);
			}
			entriesArray.sortOn("id", Array.DESCENDING|Array.NUMERIC);
			entries = new ArrayCollection(entriesArray);
		}
		
		public function updateEntry(entry:Entry):void
		{
			for (var i:int = 0; i < entries.length; i++)
			{
				var ithEntry:Entry = Entry(entries.getItemAt(i));
				if (ithEntry.id == entry.id)
				{
					entries.setItemAt(entry, i);
					break;
				}
			}
		}
		
		public function removeEntry(entry:Entry):void
		{
			for (var i:int = 0; i < entries.length; i++)
			{
				var ithEntry:Entry = Entry(entries.getItemAt(i));
				if (ithEntry.id == entry.id)
				{
					entries.removeItemAt(i);
					break;
				}
			}
			entries.refresh();
		}
		
		public const RESPONSED_QUERIES:int = 0;
		public const UNRESPONSED_QUERIES:int = 1;
		public const SOLVED_QUERIES:int = 2;
		public const ALL_QUERIES:int = 3;
		
		public const SHOW_CHOICES:Array =
		[
		 {label:"已有答复的提问(尚未被确认)", data:RESPONSED_QUERIES},
		 {label:"还没有答复的提问", data:UNRESPONSED_QUERIES},
		 {label:"已解决的提问", data:SOLVED_QUERIES},
		 {label:"所有提问", data:ALL_QUERIES}
		];
		
		public var selectedQueriesFilter:Object = SHOW_CHOICES[0];
		
		public function responsedQueriesFilterFunc(item:Object):Boolean
        {
        	return ((item.answer != null && item.answer != "") && item.solved == false);
        }
        
        public function unresponsedQueriesFilterFunc(item:Object):Boolean
        {
        	return ((item.answer == null || item.answer == "") && item.solved == false);
        }
        
        public function solvedQueriesFilterFunc(item:Object):Boolean
        {
        	return (item.solved == true);
        }
		
		public function getQuery(queryId:int):Query
		{
			for each(var i:Query in queries)
			{
				if (i.id == queryId)
					return i;
			}
			return null;
		}
		
		public function setCourseQueries(course:Course, list:XMLList):void
		{
			var queriesArray:Array = [];
			var item:XML;
			for each (item in list)
			{
				var query:Query = Query.fromXML(item);
				queriesArray.push(query);
			}
			queriesArray.sortOn("id", Array.DESCENDING|Array.NUMERIC);
			course.queries = new ArrayCollection(queriesArray);
			for each (var i:Query in course.queries)
			{
				i.course = course;
			}
		}
		
		public function setQueries(list:XMLList, queriesType:String):void
		{
			var queriesArray:Array = [];
			var item:XML;
			for each (item in list)
			{
				var query:Query = Query.fromXML(item);
				queriesArray.push(query);
			}
			if (queriesType == "unsolvedQueries")
			{
				unsolvedQueries = new ArrayCollection(queriesArray);
				queries = new ArrayCollection(queriesArray);
				if (queriesFilterName == "responsed")
				{
					queries.filterFunction = responsedQueriesFilterFunc;
					selectedQueriesFilter = SHOW_CHOICES[0];
				}
				else if (queriesFilterName == "unresponsed")
				{
					queries.filterFunction = unresponsedQueriesFilterFunc;
					selectedQueriesFilter = SHOW_CHOICES[1];
				}
				queries.refresh();
			}
			else if (queriesType == "solvedQueries")
			{
				solvedQueries = new ArrayCollection(queriesArray);
				queries = new ArrayCollection(queriesArray);
				selectedQueriesFilter = SHOW_CHOICES[2];
			}
			else if (queriesType == "allQueries")
			{
				allQueries = new ArrayCollection(queriesArray);
				queries = new ArrayCollection(queriesArray);
				selectedQueriesFilter = SHOW_CHOICES[3];
			}
		}
		
		public function updateOneQuery(query:Query):void
		{
			var i:int;
			var ithQuery:Query;
			for (i = 0; i < queries.length; i++)
			{
				ithQuery = Query(queries.getItemAt(i));
				if (ithQuery.id == query.id)
				{
					queries.setItemAt(query, i);
					break;
				}
			}
		}
		
		public function updateQuery(query:Query):void
		{
			var i:int;
			var ithQuery:Query;
			for (i = 0; i < queries.length; i++)
			{
				ithQuery = Query(queries.getItemAt(i));
				if (ithQuery.id == query.id)
				{
					queries.setItemAt(query, i);
					break;
				}
			}
			if (query.solved)
			{
				for (i = 0; i < unsolvedQueries.length; i++)
				{
					ithQuery = Query(unsolvedQueries.getItemAt(i));
					if (ithQuery.id == query.id)
					{
						unsolvedQueries.removeItemAt(i);
						break;
					}
				}
			}
			else
			{
				for (i = 0; i < unsolvedQueries.length; i++)
				{
					ithQuery = Query(unsolvedQueries.getItemAt(i));
					if (ithQuery.id == query.id)
					{
						unsolvedQueries.setItemAt(query, i);
						break;
					}
				}
			}
			if (query.solved)
			{
				solvedQueries.addItem(query);
			}
			for (i = 0; i < allQueries.length; i++)
			{
				ithQuery = Query(allQueries.getItemAt(i));
				if (ithQuery.id == query.id)
				{
					allQueries.setItemAt(query, i);
					break;
				}
			}
		}
		
		public function removeQuery(query:Query):void
		{
			for (var i:int = 0; i < queries.length; i++)
			{
				var ithQuery:Query = Query(queries.getItemAt(i));
				if (ithQuery.id == query.id)
				{
					queries.removeItemAt(i);
					break;
				}
			}
		}
		
		public function setCourseKeywords(course:Course, list:XMLList):void
		{
			var keywordsArray:Array = [];
			var item:XML;
			for each (item in list)
			{
				var keyword:Keyword = Keyword.fromXML(item);
				keywordsArray.push(keyword);
			}
			keywordsArray.sortOn("value", Array.CASEINSENSITIVE);
			course.keywords = new ArrayCollection(keywordsArray);
			for each(var i:Keyword in course.keywords)
			{
				i.course = course;
			}
		}
		
		public function setEntryKeywords(entry:Entry, list:XMLList):void
		{
			var keywordsArray:Array = [];
			var item:XML;
			for each (item in list)
			{
				var keyword:Keyword = Keyword.fromXML(item);
				keywordsArray.push(keyword);
			}
			keywordsArray.sortOn("relevance", Array.DESCENDING | Array.NUMERIC);
			entry.keywords = new ArrayCollection(keywordsArray);
			for each (var i:Keyword in entry.keywords)
			{
				i.entry = entry;
				i.course = entry.course;
			}
		}
		
		public function setKeywords(list:XMLList):void
		{
			var keywordsArray:Array = [];
			var item:XML;
			for each (item in list)
			{
				var keyword:Keyword = Keyword.fromXML(item);
				keywordsArray.push(keyword);
			}
			keywords = new ArrayCollection(keywordsArray);
		}
		
		public function getTeacher(teacherId:int):User
		{
			for each(var i:User in teachersAndNone)
			{
				if (i.id == teacherId)
					return i;
			}
			return null;
		}
		
		public function getTeacherFromTeachers(teacherId:int):User
		{
			for each(var i:User in teachers)
			{
				if (i.id == teacherId)
					return i;
			}
			return null;
		}
		
		public function addTeacher(teacher:User):void
		{
			var teachersArray:Array = [];
			teachersArray.push(teacher);
			if (teachers == null)
			{
				teachers = new ArrayCollection(teachersArray);
			}
			else if (!teachers.contains(teacher))
			{
				teachers.addItem(teacher);
			}
			teachers.sort = sortByOfficialIdAsc;
			teachers.refresh();
		}
		
		public function updateTeacher(teacher:User):void
		{
			for (var i:int = 0; i < teachers.length; i++)
			{
				var ithUser:User = User(teachers.getItemAt(i));
				if (ithUser.id == teacher.id)
				{
					if (!teacher.isTeacher)
					{
						teachers.removeItemAt(i);
						teachers.sort = sortByOfficialIdAsc;
						teachers.refresh();
						if (students != null)
						{
							students.addItem(teacher);
							students.sort = sortByOfficialIdAsc;
							students.refresh();
						}
					}
					else
					{
						teachers.setItemAt(teacher, i);
					}
					break;
				}
			}
		}
		
		public function removeTeacher(teacher:User):void
		{
			for (var i:int = 0; i < teachers.length; i++)
			{
				var ithUser:User = User(teachers.getItemAt(i));
				if (ithUser.id == teacher.id)
				{
					teachers.removeItemAt(i);
					break;
				}
			}
			teachers.sort = sortByOfficialIdAsc;
			teachers.refresh();
		}
		
		public function setTeachers(list:XMLList):void
		{
			var teachersArray:Array = [];
			var item:XML;
			for each (item in list)
			{
				var teacher:User = User.fromXML(item);
				teachersArray.push(teacher);
			}
			teachersArray.sortOn("lastName", Array.CASEINSENSITIVE|Array.DESCENDING);
			teachers = new ArrayCollection(teachersArray);
			var teachersAndNoneArray:Array = teachersArray.slice(0);
			teachersAndNoneArray.splice(0, 0, User.TEACHER_NONE);
			teachersAndNone = new ArrayCollection(teachersAndNoneArray);
		}
		
		public function getStudent(studentId:int):User
		{
			for each(var i:User in students)
			{
				if (i.id == studentId)
					return i;
			}
			return null;
		}
		
		public function addStudent(student:User):void
		{
			var studentsArray:Array = [];
			studentsArray.push(student);
			if (students == null)
			{
				students = new ArrayCollection(studentsArray);
			}
			else if (!students.contains(student))
			{
				students.addItem(student);
			}
			students.sort = sortByOfficialIdAsc;
			students.refresh();
		}
		
		public function updateStudent(student:User):void
		{
			for (var i:int = 0; i < students.length; i++)
			{
				var ithUser:User = User(students.getItemAt(i));
				if (ithUser.id == student.id)
				{
					if (student.isTeacher)
					{
						students.removeItemAt(i);
						students.sort = sortByOfficialIdAsc;
						students.refresh();
						if (teachers != null)
						{
							teachers.addItem(student);
							teachers.sort = sortByOfficialIdAsc;
							teachers.refresh();
						}
					}
					else
					{
						students.setItemAt(student, i);
					}
					break;
				}
			}
		}
		
		public function removeStudent(student:User):void
		{
			for (var i:int = 0; i < students.length; i++)
			{
				var ithUser:User = User(students.getItemAt(i));
				if (ithUser.id == student.id)
				{
					students.removeItemAt(i);
					break;
				}
			}
			students.sort = sortByOfficialIdAsc;
			students.refresh();
		}
		
		public function setStudents(list:XMLList):void
		{
			var studentsArray:Array = [];
			var item:XML;
			for each (item in list)
			{
				var student:User = User.fromXML(item);
				studentsArray.push(student);
			}
			studentsArray.sortOn("officialId", Array.NUMERIC);
			students = new ArrayCollection(studentsArray);
			var studentsAndNoneArray:Array = studentsArray.slice(0);
			studentsAndNoneArray.splice(0, 0, User.STUDENT_NONE);
			studentsAndNone = new ArrayCollection(studentsAndNoneArray);
		}
		
		public function setCourseTeachers(course:Course, list:XMLList):void
		{
			var teachersArray:Array = [];
			var item:XML;
			for each (item in list)
			{
				var teacher:User = User.fromXML(item);
				teachersArray.push(teacher);
			}
			teachersArray.sortOn("lastName", Array.CASEINSENSITIVE);
			course.teachers = new ArrayCollection(teachersArray);
			var teachersAndNoneArray:Array = teachersArray.slice(0);
			teachersAndNoneArray.splice(0, 0, User.TEACHER_NONE);
			course.teachersAndNone = new ArrayCollection(teachersAndNoneArray);
		}
		
		public function setCourseStudents(course:Course, list:XMLList):void
		{
			var studentsArray:Array = [];
			var item:XML;
			for each (item in list)
			{
				var student:User = User.fromXML(item);
				studentsArray.push(student);
			}
			studentsArray.sortOn("officialId", Array.NUMERIC);
			course.students = new ArrayCollection(studentsArray);
			var studentsAndNoneArray:Array = studentsArray.slice(0);
			studentsAndNoneArray.splice(0, 0, User.STUDENT_NONE);
			course.studentsAndNone = new ArrayCollection(studentsAndNoneArray);
		}
		
		public function setNotes(list:XMLList):void
		{
			var notesArray:Array = [];
			var item:XML;
			for each (item in list)
			{
				var note:Note = Note.fromXML(item);
				notesArray.push(note);
			}
			notesArray.sortOn("id", Array.DESCENDING|Array.NUMERIC);
			notes = new ArrayCollection(notesArray);
		}
		
		public function updateNote(note:Note):void
		{
			for (var i:int = 0; i < notes.length; i++)
			{
				var ithNote:Note = Note(notes.getItemAt(i));
				if (ithNote.id == note.id)
				{
					notes.setItemAt(note, i);
					break;
				}
			}
		}
		
		public function removeNote(note:Note):void
		{
			for (var i:int = 0; i < notes.length; i++)
			{
				var ithNote:Note = Note(notes.getItemAt(i));
				if (ithNote.id == note.id)
				{
					notes.removeItemAt(i);
					break;
				}
			}
			notes.refresh();
		}
		
		private static var modelLocator:IaskModelLocator;
		
		public static function getInstance():IaskModelLocator
		{
			if (modelLocator == null)
			{
				modelLocator = new IaskModelLocator();
			}
			return modelLocator;
		}
		
		public function IaskModelLocator()
		{
			if (modelLocator != null)
			{
				throw new Error("Only one IaskModelLocator instance may be instantiated.");
			}
			var teacherNoneArray:Array = [];
			teacherNoneArray.push(User.TEACHER_NONE);
			teacherNone = new ArrayCollection(teacherNoneArray);
			sortByIdDesc.fields = [new SortField("id", false, true, true)];
			sortByOfficialIdAsc.fields = [new SortField("officialId")];
			sortByNameAsc.fields = [new SortField("name")];
			sortByLastNameAsc.fields = [new SortField("lastName")];
			sortByRelevanceDesc.fields = [new SortField("relevance", false, true, true), new SortField("id", false, true, true)];
			selectedKeyword = "关键词1 关键词2 关键词3 ... 关键词20";
		}
	}
}