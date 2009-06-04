using System;
using System.Collections.Generic;
using System.Text;

namespace ServiceLibrary.Descriptors {
	public class Time {
	
		private DateTime _currentTime;
	
		public DateTime currentTime { 
			get{
				_currentTime = DateTime.Now;
				return _currentTime;
			}
			set{
				_currentTime = value;
			}
		}
	
	}
}
