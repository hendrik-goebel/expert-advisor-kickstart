//+------------------------------------------------------------------+
// Expert Advisor Kickstart Template
//+------------------------------------------------------------------+
#include <stderror.mqh>
#include <stdlib.mqh>

int lotSize=3;
datetime now;
bool isNewBar;
double pipDigits;
int lastError=0;
int barCount = 0;
int magicNumber=735628;
string comment="Automatic Trade";
int orderTicket=0;
int slippage=100;
//+------------------------------------------------------------------+
//|  init    
//+------------------------------------------------------------------+
int init()
  {

   now=iTime(NULL,0,0);
   pipDigits=calculatePipdigits();
   return 0;
  }
//+------------------------------------------------------------------+
//|    Start 
//+------------------------------------------------------------------+
void start()
  {

   if(isNewBar()==true)
     {
      Print("Bar "+barCount);
      if(isBuy())
        {
         openBuyOrder();
        }
     }
   if(isClose())
     {
      closeOpenOrder();
     }
  }
//+------------------------------------------------------------------+
//|   Checks if buy conditions are fullfilled                                                               |
//+------------------------------------------------------------------+
bool isBuy()
  {
   if(isOrderOpen())
     {
      return false;
     }
   if(barCount%5==0)
     {
      return true;
     }

   return false;

  }
//+------------------------------------------------------------------+
//|   Checks if close conditions are fullfilled                                                               |
//+------------------------------------------------------------------+
bool isClose() 
  {

   if(isOrderOpen()) 
     {
      if(barCount%3==0)
        {
         return true;
        }
     }
   return false;
  }
//+------------------------------------------------------------------+
//|    Opens a buy order                                                              |
//+------------------------------------------------------------------+
void openBuyOrder()
  {
   ;
   int stoploss=0;
   int takeprofit=0;
   float price=Ask;

   orderTicket=OrderSend(Symbol(),OP_BUY,lotSize,price,slippage,stoploss,takeprofit,comment,magicNumber,0,clrGreen);
   if(orderTicket==-1)
     {
      handleError();
     }
  }
//+------------------------------------------------------------------+
//|       Closes the currently open order                                                           |
//+------------------------------------------------------------------+
void closeOpenOrder()
  {
   float price=Ask;
   if(isOrderOpen()) 
     {
      bool result=OrderClose(orderTicket,lotSize,price,slippage,clrBlue);
      if(!result) 
        {
         handleError();
        }
     }
  }
//+------------------------------------------------------------------+
//| Checks if there is already an open order on the current currency pair                                                                  |
//+------------------------------------------------------------------+
bool isOrderOpen()
  {

   for(int i=0; i<OrdersTotal(); i++)
     {
      bool result=OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(!result) 
        {
         handleError();

        }
      if(OrderSymbol()==Symbol())
        {
         return true;
        }
     }
   return false;
  }
//+------------------------------------------------------------------+
//|  Prints an error message if an error has occured                                                                 |
//+------------------------------------------------------------------+
void handleError()
  {
   lastError=GetLastError();
   Print("Error: ",ErrorDescription(lastError));
  }
//+------------------------------------------------------------------+
//| Returns true if a new bar has started                                                                 |
//+------------------------------------------------------------------+
int isNewBar()
  {
   if(now!=iTime(Symbol(),0,0))
     {
      now=iTime(Symbol(),0,0);
      barCount++;
      isNewBar=true;
     }
   else
     {
      isNewBar=false;
     }

   return isNewBar;
  }
//+------------------------------------------------------------------+

double calculatePipdigits()
  {

   if(Digits==1)
     {
      return 1;
     }
//If there are 3 or less digits (JPY for example) then return 0.01 which is the pip value
   if(Digits==2 || Digits==3)
     {
      return(0.01);
     }
//If there are 4 or more digits then return 0.0001 which is the pip value
   else if(Digits>=4)
     {
      return(0.0001);
     }
//In all other cases (there shouldn't be any) return 0
   else return(0);
  }
//+------------------------------------------------------------------+
