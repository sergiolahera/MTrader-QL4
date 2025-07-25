//+------------------------------------------------------------------+
//|                                        EduMethodLog01-072525.mq4 |
//|                                  Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql4.com |
//+------------------------------------------------------------------+
#property strict
//#property copyright "Copyright 2025, MetaQuotes Ltd."
//#property link      "https://www.mql4.com"
//#include <ComHeadsInc.mqh>
#include "ComHeadsInc.mqh"
/*
input bool TriggerUP=false;
input bool TriggerDWN=false;
input double RSIUPTrigger=70;
input double RSILOWTrigger=30;
input double PriceChangePercent=0.0001;
input double StopLossPoints=100;
input double MinimumStopLossPoints=25;

input double RiskPercent=0.01;
input double R2R=2;
double EntryPoint;
double TakeProfit;
double TakeProfitPoints;
double StopLoss;
double StopLossNew;
int canddleCount=0;

double LotSize;
bool IsBuy;
bool TradeIsOk=true;
*/

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
//   EventSetTimer(60); // this might be activated
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
//   EventKillTimer(); // This might be activated
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
      double Rsi0=iRSI(NULL, PERIOD_H1,4,PRICE_CLOSE,0)
      double Rsi1=iRSI(NULL, PERIOD_H1,4,PRICE_CLOSE,1)
      double Rsi2=iRSI(NULL, PERIOD_H1,4,PRICE_CLOSE,2)

      comment("The open orders is equal to: "+OrdersTotal());
      
      ////////////////////Trail Stop loss///////////////
      
      if (SymbolOpenOrders(Symbol())>=2 && IsBuy && Bid<StopLossNew)
      {
         while(SymbolOpenOrders(Symbol()) !=0)
         {
            CloseOrders(Symbol(),True);
            OrderClose;
         }
      }
      
      if (SymbolOpenOrders(Symbol())>=2 && !IsBuy && Ask>StopLossNew)
      {
         While(SymbolOpenOrders(Symbol()) !=0)
         {
            CloseOrders(Symbol(), true);         
         }
      }
      ////////////////////////////////////////////
      If(IsNewCanddle(PERIOD_CURRENT))TradeIsOk=true;
      
      if (SymbolOpenOrders(Symbol()==0 && TradeIsOk)
      {
         if(Rsi1<=RSIUPTrigger && Rsi0>RSIUPTrigger)
         {
            EntryPoint=Ask;
            //StopLoss=SupportAndResistant(Symbol(),EntryPoint,PERIOD_CURRENT,true,1,MinimumStopLossPoints,10);
            StopLoss=EntryPoint-StopLossPoints*Point;
            TakeProfit=Ask+R2R*StopLossPoints*Point;
            LotSize=OptimumLotSize(RiskPercent,EntryPoint,StopLoss);
            OrderSend(Symbol(),OP_BUY,LotSize,EntryPoint,0,StopLoss,0,0,1000,0,0);
            TradeIsOk=false;
            IsBuy=true;
         }
         
         if(Rsi1>=RSILOWTrigger && Rsi0>RSILOWTrigger)
         {
            EntryPoint=Bid;
            //StopLoss=SupportAndResistant(Symbol(),EntryPoint,PERIOD_CURRENT,false,1,MinimumStopLossPoints,10);
            StopLoss=EntryPoint-StopLossPoints*Point;
            TakeProfit=Bid-R2R*StopLossPoints*Point;
            LotSize=OptimumLotSize(RiskPercent,EntryPoint,StopLoss);
            OrderSend(Symbol(),OP_SELL,LotSize,EntryPoint,0,StopLoss,0,0,1000,0,0);
            TradeIsOk=false;
            IsBuy=true;
         }
         
      }
      else
      {
         if(IsBuy && Ask>=TakeProfit)
         {
            TakeProfit=TakeProfit+R2R*StopLossPoints*Point;
            OrderSend(Symbol(),OP_BUY,LotSize,Ask,0,StopLoss,0,0,1000,0,0);
            StopLossNew=Ask-MinimumStopLossPoints*Point;
         }
         
         if(!IsBuy && Bid<=TakeProfit)
         {
            TakeProfit=TakeProfit-R2R*StopLossPoints*Point;
            OrderSend(Symbol(),OP_SELL,LotSize,Bid,0,StopLoss,0,0,1000,0,0);
            StopLossNew=Bid+MinimumStopLossPoints*Point;
         }
      }
  }

/*
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Tester function                                                  |
//+------------------------------------------------------------------+
double OnTester()
  {
//---
   double ret=0.0;
//---

//---
   return(ret);
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
   
  }
//+------------------------------------------------------------------+
*/
