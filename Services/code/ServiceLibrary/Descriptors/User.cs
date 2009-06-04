using System;
using System.Collections.Generic;
using System.Text;

namespace ServiceLibrary.Descriptors {
	public class User {
		public int userId { get; set; }
		public string firstName { get; set; }
		public string lastName { get; set; }
		public Time requestTime { get; set; }
	}
}
