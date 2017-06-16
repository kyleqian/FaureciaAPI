package com.faurecia.westworks.omega.gmLanController 
{
	/**
	 * ...
	 * @author jimF
	 */
	public class OmegaControlStrings 	
	{
		
		//101 FE 01 3E 00 00 00 00 00 
		//10 24 20 40 02 
		//63D 00 7F 00 00 00 00 00 00 
		
		public static const KEEP_AWAKE_HEADER:String = "";
		public static const KEEP_AWAKE:String = "";
		
		
		/*private var CushionFrontEnable:int = 0x80000000000;
		private var CushionRearEnable:int =  0x20000000000;
		private var SeatForeAftEnable:int =  0x08000000000;
		private var BackForeAftEnable:int =  0x02000000000;
		
		private var LumbarUpDownEnable:int =  0x00800000000;
		private var LumbarForeAftEnable:int = 0x00200000000;
		private var PetalsForeAftEnable:int = 0x00080000000;*/
		
		// driver seat arbId
		public static const OMEGA_HEADER:String = 				"25D";
		public static const OMEGA_HEADER_DRIVER:String = 		"25D";
		public static const OMEGA_HEADER_PASSENGER:String = 	"25E";
		public static const OMEGA_HEADER_LEFT_REAR:String = 	"25F";
		public static const OMEGA_HEADER_RIGHT_REAR:String = 	"25G";
		
		public static const MSM_CONTROLS_OFF:String = 	"06 AE 01 00 00 00 00";
		//public static const MSM_CONTROLS_OFF:String = 	"06AE01AAA80004";
		
		public static const CUSHION_FRONT_UP:String = 	"06 AE 01 AA A8 80 00";
		//public static const CUSHION_FRONT_UP:String = 	"ATSH 25D";
		public static const CUSHION_FRONT_DOWN:String = "06 AE 01 AA A8 40 00";
		public static const CUSHION_REAR_UP:String   = 	"06 AE 01 AA A8 20 00";
		public static const CUSHION_REAR_DOWN:String = 	"06 AE 01 AA A8 10 00";
		
		public static const SEAT_FOWARD:String = 		"06 AE 01 AA A8 08 00";
		public static const SEAT_REARWARD:String = 		"06 AE 01 AA A8 04 00";		
		//public static const SEAT_REARWARD:String = 		"06AE01AAA80404";		
		public static const BACK_FORWARD:String = 		"06 AE 01 AA A8 02 00";	
		public static const BACK_REARWARD:String = 		"06 AE 01 AA A8 01 00";	
		
		public static const LUMBAR_UP:String = 			"06 AE 01 AA A8 00 80";
		public static const LUMBAR_DOWN:String = 		"06 AE 01 AA A8 00 40";
		public static const LUMBAR_FORWARD:String = 	"06 AE 01 AA A8 00 20";
		public static const LUMBAR_REARWARD:String = 	"06 AE 01 AA A8 00 10";
		
		public static const PEDALS_FORWARD:String = 	"06 AE 01 AA A8 00 08";
		public static const PEDALS_REARWARD:String = 	"06 AE 01 AA A8 00 04";
		//dual controlse
		public static const CUSHION_UP:String = 		"06 AE 01 AA A8 A0 00";
		public static const CUSHION_DOWN:String = 		"06 AE 01 AA A8 50 00";
		public static const CUSHION_TILT_FORE:String = 	"06 AE 01 AA A8 60 00";
		public static const CUSHION_TILT_AFT:String = 	"06 AE 01 AA A8 90 00";
		//
		//
		//
		//public static const MBM_CONTROLS_OFF:String = 	 		"06 AE 28 02 80 00 00";
		//public static const MBM_CONTROLS_OFF:String = 	 		"06 AE 28 3A AA 00 00";
		
		public static const MBM_CONTROLS_OFF:String = 	 		"06 AE 28 00 00 00 00";
		
		public static const HEADREST_UP:String = 				"06 AE 28 0A AA 08 00";
		public static const HEADREST_DOWN:String =				"06 AE 28 0A AA 04 00";
		public static const HEADREST_FORWARD:String =			"06 AE 28 0A AA 02 00";
		public static const HEADREST_REARWARD:String =			"06 AE 28 0A AA 01 00";		
		
		public static const THIGH_BOLSTER_FORWARD:String = 		"06 AE 28 0A AA 00 80";
		public static const THIGH_BOLSTER_REARWARD:String =		"06 AE 28 0A AA 00 40";
		public static const CUSHION_BOLSTER_INWARD:String =		"06 AE 28 0A AA 00 20";
		public static const CUSHION_BOLSTER_OUTWARD:String =	"06 AE 28 0A AA 00 10";
		
		public static const BACK_BOLSTER_INWARD:String =		"06 AE 28 0A AA 00 08";
		public static const BACK_BOLSTER_OUTWARD:String =		"06 AE 28 0A AA 00 04";
		public static const SHOULDER_BOLSTER_FORWARD:String =	"06 AE 28 0A AA 00 02";
		public static const SHOULDER_BOLSTER_REARWARD:String =	"06 AE 28 0A AA 00 01";
		//
		//
		public static const SYSTEM_RESET_ON:String =	"06 AE 20 30 30";
		public static const SYSTEM_RESET_OFF:String =	"06 AE 20 30 00";
		//25D 06 AE 29 03 00 02 01
		//public static const MASSAGE_CONTROLS_OFF:String = 	 	"06 AE 29 00 00 00 00";
		public static const MASSAGE_STOP_ALL:String = 	 		"06 AE 29 00 00 00 00";
		// from vSpy:  00 03 02 ????
		//from OBD-MX: 25D 06 AE 29 03 00 01 01 
		// how is this working? DMC == intensity?
		public static const MASSAGE_COMMON_MESSAGE:String = 	"06 AE 29 03 00 ";
		//public static const MASSAGE_COMMON_MESSAGE:String = 	"06 AE 29 11 00 ";
		
		public static const MASSAGE_INTENSITY_0_OFF:String = 	"00 ";
		public static const MASSAGE_INTENSITY_1:String = 	 	"01 ";
		public static const MASSAGE_INTENSITY_2:String = 	 	"02 ";
		public static const MASSAGE_INTENSITY_3:String = 	 	"03 ";
		public static const MASSAGE_INTENSITY_4:String = 	 	"04 ";
		public static const MASSAGE_INTENSITY_5:String = 	 	"05 ";
		public static const MASSAGE_INTENSITY_6:String = 	 	"06 ";
		public static const MASSAGE_INTENSITY_7:String = 	 	"07 ";
		
		/*public static const MASSAGE_INTENSITY_0_OFF:String = 	"06 AE 29 00 10 00 00";
		public static const MASSAGE_INTENSITY_1:String = 	 	"06 AE 29 00 10 00 10";
		public static const MASSAGE_INTENSITY_2:String = 	 	"06 AE 29 00 10 00 20";
		public static const MASSAGE_INTENSITY_3:String = 	 	"06 AE 29 00 10 00 30";
		public static const MASSAGE_INTENSITY_4:String = 	 	"06 AE 29 00 10 00 40";
		public static const MASSAGE_INTENSITY_5:String = 	 	"06 AE 29 00 10 00 50";
		public static const MASSAGE_INTENSITY_6:String = 	 	"06 AE 29 00 10 00 60";
		public static const MASSAGE_INTENSITY_7:String = 	 	"06 AE 29 00 10 00 70";*/
		
		public static const MASSAGE_TYPE_0:String = 	 		"00";
		public static const MASSAGE_TYPE_1:String = 	 		"01";
		public static const MASSAGE_TYPE_2:String = 	 		"02";
		public static const MASSAGE_TYPE_3:String = 	 		"03";
		public static const MASSAGE_TYPE_4:String = 	 		"04";
		public static const MASSAGE_TYPE_5:String = 	 		"05";
		public static const MASSAGE_TYPE_6:String = 	 		"06";
		public static const MASSAGE_TYPE_7:String = 	 		"07";
		public static const MASSAGE_TYPE_8:String = 	 		"08";
		public static const MASSAGE_TYPE_9:String = 	 		"09";
		public static const MASSAGE_TYPE_10:String = 	 		"0A";
		public static const MASSAGE_TYPE_11:String = 	 		"0B";
		public static const MASSAGE_TYPE_12:String = 	 		"0C";
		public static const MASSAGE_TYPE_13:String = 	 		"0D";
		public static const MASSAGE_TYPE_14:String = 	 		"0E";
		public static const MASSAGE_TYPE_15:String = 	 		"0F";
		
		/*public static const MASSAGE_TYPE_0:String = 	 		"06 AE 29 00 01 00 00";
		public static const MASSAGE_TYPE_1:String = 	 		"06 AE 29 00 01 00 01";
		public static const MASSAGE_TYPE_2:String = 	 		"06 AE 29 00 01 00 02";
		public static const MASSAGE_TYPE_3:String = 	 		"06 AE 29 00 01 00 03";
		public static const MASSAGE_TYPE_4:String = 	 		"06 AE 29 00 01 00 04";
		public static const MASSAGE_TYPE_5:String = 	 		"06 AE 29 00 01 00 05";
		public static const MASSAGE_TYPE_6:String = 	 		"06 AE 29 00 01 00 06";
		public static const MASSAGE_TYPE_7:String = 	 		"06 AE 29 00 01 00 07";
		public static const MASSAGE_TYPE_8:String = 	 		"06 AE 29 00 01 00 08";
		public static const MASSAGE_TYPE_9:String = 	 		"06 AE 29 00 01 00 09";
		public static const MASSAGE_TYPE_10:String = 	 		"06 AE 29 00 01 00 0A";
		public static const MASSAGE_TYPE_11:String = 	 		"06 AE 29 00 01 00 0B";
		public static const MASSAGE_TYPE_12:String = 	 		"06 AE 29 00 01 00 0C";
		public static const MASSAGE_TYPE_13:String = 	 		"06 AE 29 00 01 00 0D";
		public static const MASSAGE_TYPE_14:String = 	 		"06 AE 29 00 01 00 0E";
		public static const MASSAGE_TYPE_15:String = 	 		"06 AE 29 00 01 00 0F";*/
		
		//Haptic intensity seems to be 00 - FF for two channels
		public static const HAPTIC_ON:String = 		"07 AE 35 03 FF FF 00 00";
		public static const HAPTIC_ON_LEFT:String = "07 AE 35 03 00 FF 00 00";
		public static const HAPTIC_ON_RIGHT:String ="07 AE 35 03 FF 00 00 00";
		public static const HAPTIC_ON_LOW:String = 	"07 AE 35 03 88 88 00 00";
		public static const HAPTIC_ON_LOW_B:String = "07 AE 35 03 22 22 00 00";
		public static const HAPTIC_OFF:String = 	"07 AE 35 03 00 00 00 00";
		
		
		public static const HAPTIC_INTENSITY_LOW:String = 	"33";
		public static const HAPTIC_INTENSITY_MEDIUM:String = "88";
		public static const HAPTIC_INTENSITY_HIGH:String = 	"FF";

		public function OmegaControlStrings() 
		{
			//var tempNum:String = Number(0xf7).toString(16)
		}
		
	}

}