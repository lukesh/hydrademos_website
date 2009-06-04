using System;
using System.Collections.Generic;
using System.Text;
using ServiceLibrary.Descriptors;

namespace ServiceLibrary {
	/// <summary>
	/// Class library with WebORB
	/// </summary>
	public class TimeService {
	
		public TimeService() {
		}


		public DateTime CurrentTime() {
			return DateTime.Now;
		}
		
		public Time CurrentTimeDescriptor(){
			Time obj = new Time();
			return obj;
		}
		
	}
}
