package com.iask.validators
{
	import com.iask.validators.ServerErrors;
	import mx.validators.Validator;
	import mx.validators.ValidationResult;

	public class ServerErrorValidator extends Validator
	{
		private var _serverErrors:ServerErrors;
		
		public var field:String;
		
		public function set serverErrors(pServerErrors:ServerErrors):void
		{
			_serverErrors = pServerErrors;
			validate();
		}
		
		public function ServerErrorValidator()
		{
			field = ServerErrors.BASE;
			_serverErrors = null;
			super();
		}
		
		override protected function doValidation(value:Object):Array
		{
			return _serverErrors.getErrorsForField(field);
		}
	}
}