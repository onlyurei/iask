package com.iask.util
{
	public class XMLUtils
	{
		public static function xmlListToBoolean(xmlList:XMLList):Boolean
		{
			return xmlList.toString () == "true";
		}
	}
}