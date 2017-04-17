
// log to windows log
//http://www.forexfactory.com/showthread.php?t=245303  

/**
* send information to OutputDebugString() to be viewed and logged
* by SysInternals DebugView (free download from microsoft)
* This is ideal for debugging as an alternative to Print().
* The function will take up to 8 string (or numeric) arguments 
* to be concatenated into one debug message.
*/

// #include <_my\utils\UtilsDebug.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#import "kernel32.dll"
    void OutputDebugStringW(string sMsg);
    void OutputDebugStringA(uchar& szAnsiStr[]);
#import



class UtilsDebug
  {
public:

  //const string z="";
  
  // true - print to windows
  // false - print  to print      
  static  int Get_PrintSrc(){ return (int)GlobalVariableGet("UtilsDebug_PrintSrc");} 
  static  void Set_PrintSrc(int v){ GlobalVariableSet("UtilsDebug_PrintSrc",(double)v);} 


  static  int Get_PrintItFlag(){ return (int)GlobalVariableGet("UtilsDebug_PrintItFlag");} 
  static  void Set_PrintItFlag(int v){ GlobalVariableSet("UtilsDebug_PrintItFlag",(double)v);}   
   

  static void InitToMTLog(){Set_PrintSrc(1);}
  static void InitToWindows(){Set_PrintSrc(1);}
  
  static void ShowPrintOut(){Set_PrintSrc(1);}
  static void DoNotShowPrintOut(){Set_PrintSrc(0);}
  



   static void InitClassic(){InitToMTLog();ShowPrintOut();};
   
   

                     UtilsDebug();
                    ~UtilsDebug();
   public:
  
  
  

   static void  PrintIt(string PrintIt1);
   static void  PrintIt(string PrintIt1,string PrintIt2){PrintIt(PrintIt1+PrintIt2);}
   static void  PrintIt(string PrintIt1,string PrintIt2,string PrintIt3){PrintIt(PrintIt1+PrintIt2+PrintIt3);}
   static void  PrintIt(
               string PrintIt1,string PrintIt2,string PrintIt3,
               string PrintIt4
               ){PrintIt(PrintIt1+PrintIt2+PrintIt3 + PrintIt4);}
   static void  PrintIt(
               string PrintIt1,string PrintIt2,string PrintIt3,
               string PrintIt4,string PrintIt5
               ){PrintIt(PrintIt1+PrintIt2+PrintIt3 + PrintIt4+PrintIt5);}
     
   static void  PrintIt(
               string PrintIt1,string PrintIt2,string PrintIt3,
               string PrintIt4,string PrintIt5,string PrintIt6               
               ){PrintIt(PrintIt1+PrintIt2+PrintIt3 + PrintIt4+PrintIt5+PrintIt6);}
   static void  PrintIt(
               string PrintIt1,string PrintIt2,string PrintIt3,
               string PrintIt4,string PrintIt5,string PrintIt6,
               string PrintIt7              
              
               ){PrintIt(PrintIt1+PrintIt2+PrintIt3 + PrintIt4+PrintIt5+PrintIt6+ PrintIt7);}
   static void  PrintIt(
               string PrintIt1,string PrintIt2,string PrintIt3,
               string PrintIt4,string PrintIt5,string PrintIt6,
               string PrintIt7,string PrintIt8
              
               ){PrintIt(PrintIt1+PrintIt2+PrintIt3 + PrintIt4+PrintIt5+PrintIt6+ PrintIt7+PrintIt8);}
   static void  PrintIt(
               string PrintIt1,string PrintIt2,string PrintIt3,
               string PrintIt4,string PrintIt5,string PrintIt6,
               string PrintIt7,string PrintIt8,string PrintIt9              
              
               ){PrintIt(PrintIt1+PrintIt2+PrintIt3 + PrintIt4+PrintIt5+PrintIt6+ PrintIt7+PrintIt8+PrintIt9);}
     
  };
   
UtilsDebug::PrintIt(string printItString)
{

      if(Get_PrintItFlag()==0)
      {
         return;
      }   
    //
    //uchar szAnsiStr[];
    //StringToCharArray(s,szAnsiStr);
    //OutputDebugStringA(szAnsiStr); 
    //OutputDebugStringW("Unicode strings for unicode functions");   
    //
    if(Get_PrintSrc()==1)
    {
       OutputDebugStringW(printItString);    
    }
    else
    {
      Print(printItString);
    }
    
      //uchar szAnsiStr[];
    //StringToCharArray(printItString,szAnsiStr);
    //OutputDebugStringA(szAnsiStr);
 
    //OutputDebugStringW(printItString);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
UtilsDebug::UtilsDebug()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
UtilsDebug::~UtilsDebug()
  {
  }
//+------------------------------------------------------------------+
