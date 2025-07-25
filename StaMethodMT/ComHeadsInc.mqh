//+------------------------------------------------------------------+
//|                                 MostCommonIncludes-01-072525.mqh |
//|                                  Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, MetaQuotes Ltd."
#property link      "https://www.mql4.com"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+

double OptimumLotSize(double RiskPercent,double EntryPoint,double StoppLoss)
{
   double OneLotIsEqqual=MarketInfo(NULL,MODE_LOTSIZE)
   double TickValue=MarketInfo(NULL,MODE_TICKVALUE)
   double MaxLossAccountCurrency=RiskPercent*AccountEquity();
   double OpLot=MaxLossAccountCurrency/((OneLotIsEqqual*TickValue)*MathAbs(EntryPoint-StoppLoss));
   OpLot=NormalizeDouble(OpLot,2);
   if(OpLot<0.01)
   {
      OpLot=0.01; 
      Alert("The calculated lot size is less than 0.01");
   }
   return(OpLot);
}

///////////////////////////////////

bool IsTradingAllowed()
{
   if(!IsTradeAllowed())
   {
      return(false);
   }
   if(!IsTradeAllowed(NULL,TimeCurrent()))
   {
      return(false);
   }
   return(true);
}
///////////////////////////////////
bool IsNewCanddle(ENUM_TIMEFRAMES TimeFrame)
{
static datetime LastCandleTime;
datetime CurrentCandleTime=iTime(NULL,TimeFrame,0); ////// Current Candle Time=Time[0]
if(LastCandleTime==CurrentCandleTime)
{
   return (false);
}
else
   {
      LastCandleTime=CurrentCandleTime;
      return(true);
   }
}
////////////////////////////////
int SymbolOpenOrders(String Symbolname)
{
   int OpenOrders=0;
   for(int t=0;t<OrdersTotal();t++)
   {
      OrderSelect(t,SELECT_BY_POS);
      if(OrderSymbol()==Symbolname)
      {
         OpenOrders=OpenOrders+1;
      }
   }
   return(OpenOrders);
}
///////////////////////////End of Day///////////////////////
 datetime TimeMarketClose(string NameOftheSymbol)
 {
   datetime PriorCandleOpenTime=D'2015.01.01 00:00';
   PriorCandleOpenTime=iTime(NULL,PERIOD_M5,1);
   datetime PosteriorCandleOpenTime;
   for(int i=2;i<=100;1++)
   {
      PosteriorCandleOpenTime=iTime(NULL,PERIOD_M5,i);
      if(TimeDay(PriorCandleOpenTime)==TimeDay(PosteriorCandleOpenTime))
      {
         PriorCandleOpenTime=PosteriorCandleOpenTime;
      }
      else
      {
         break;
      }
   }
   return(PosteriorCandleOpenTime);
 }
////////////////////////// Close All Orders /////////////////
void CloseOrders(string Symboll, bool AllOrders)
{
   for(int t=0; t<=OrdersTotal();t++)
   {
      OrderSelect(0,SELECT_BY_POS);
      if(AllOrders && OrderType()==0) OrderClose(OrderTicket(),OrderLots(),Bid,0,0);
      if(AllOrders && OrderType()==1) OrderClose(OrderTicket(),OrderLots(),Ask,0,0);
      if(OrderSymbol()==Symboll && OrderType()==0) OrderClose(OrderTicket(),OrderLots(),Bid,0,0);
      if(OrderSymbol()==Symboll && OrderType()==1) OrderClose(OrderTicket(),OrderLots(),Ask,0,0);
   }
}