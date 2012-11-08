package com.iask.validators
{
	import mx.validators.Validator;
	import mx.validators.ValidationResult;
	
	public class ServerErrors
	{
		public static const BASE:String = ":base";
		
		private var _allErrors:Object;
		
		public function ServerErrors(errorsXML:XML)
		{
			_allErrors = {};
			for each (var error:XML in errorsXML.error)
			{
				var field:String = error.@field;
				if (field == null || field == "")
				{
					field = BASE;
				}
				if (_allErrors[field] == null)
				{
					_allErrors[field] = [createValidationResult(error.@message)];
				}
				else
				{
					var fieldErrors:Array = _allErrors[field];
					fieldErrors.push(createValidationResult(error.@message));
				}
			}	
		}
		
		public function getErrorsForField(field:String):Array
		{
			return _allErrors[field] == null ? [] : _allErrors[field];
		}
		
		private function createValidationResult(message:String):ValidationResult
		{
			return new ValidationResult(true, "", "SERVER_VALIDATION_ERROR", message);
		}
	}
}