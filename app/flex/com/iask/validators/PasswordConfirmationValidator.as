package com.iask.validators
{
	import mx.validators.ValidationResult;
	import mx.validators.Validator;

	public class PasswordConfirmationValidator extends Validator
	{
		public var password:String;
		
		public function PasswordConfirmationValidator()
		{
			super();
		}
		
		override protected function doValidation(passwordConfirmation:Object):Array
		{
			var results:Array = super.doValidation(passwordConfirmation);
			if (password != passwordConfirmation)
			{
				results.push(new ValidationResult(true, "password_confirmation",
				   "passwordDoesNotMatchConfirmation", 
				   "The password does not match the confirmation."));
			}
			return results;
		}
	}
}