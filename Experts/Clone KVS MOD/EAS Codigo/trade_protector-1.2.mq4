// trade assistant - to watch after SL's for your trades
// some ideas and code fragments: "S.Projects" - "cortex.snowcron.com"


extern int logging=1;
//logging=1  - if you want logs in Experts\Files directory
extern int nInitialSL=15;
// inital SL
extern int nTrailingStop=35;
//nTrailingStop [pips] - initial trailing stop. It will be used until your trade will reach profit = nPropSLThreshold
extern int nPropSLThreshold=12;
//nPropSLThreshold [pips] - after reaching this profit proportional trailing stop will be used
extern double dPropSLRatio=0.35;
//dPropSLRatio [decimal] - multiplying factor ( PropSL = Profit * dPropSLRatio  - Spred )
extern int nUseEscape=0;
//nUseEscape [ 1 or 0 ] - escape misplaced trades as soon as they reach some minimal profit
extern int nEscapeLevel=0;
//nEscapeLevel [pips] - lose size after which we want our trade to terminate 
//as soon as it will reach next high
extern int nEscapeTP=35;
//nEscapeTP [pips] - take profit level in pips (you can set to negative value 
//- then it will be a lose that you would be happy to get, 
//in the case your trade reached some impressive negative pips value)
extern int nSleep=0;
//delay after new bar
extern int nSlip = 2;
//maximum price slip allowed

double dEscapeLevel;
double dInitialSL;
double dTrailingStop;
double dEscapeTP;
double dPropSLThreshold;
double dTakeProfit;
double dTakeProfitMin;
double dTakeProfitMax;
double dTakeProfitT;
int nBars, nSpread, nDigits, nBarsSameTrend, nCloseErr, nOpenErr, i;

double dDeltaPrice, dnBid, dnAsk, dSpread, dStopLevel, dMax, dMin, dMacdDelta, dMacd1, dMacd2;

// double dOldBalance, dNewBalance;

int nTakeProfitMax=100;

int nBarsSinceTrade=0;

string strExpert;


// ------

int init ()
{
   nBars = Bars;
   nSpread = MarketInfo(Symbol(), MODE_SPREAD);
   dSpread = NormalizeDouble(nSpread * Point,4);
   nDigits = MarketInfo(Symbol(), MODE_DIGITS);
   dEscapeTP = NormalizeDouble(nEscapeTP * Point,4);  
 
   dEscapeLevel = nEscapeLevel * Point;
   
   strExpert = "tp-1.2.0-"+Symbol()+"-"+Period();

   return(0);
}

// ------
int deinit()
{
   return(0);
}

// ------

int start()
{ 
 
   // ------
   // to let MT rest a bit after new bar:
   Sleep(nSleep*1000);
   if(nSleep > 0)
      RefreshRates();
   
   
   dnBid=NormalizeDouble(Bid,nDigits);
   dnAsk=NormalizeDouble(Ask,nDigits); 
 
   ModifyOrders();
 
   // ------
 
   return(0);
}


// ------

void ModifyOrders()
{ 
   double dSl;
   double arrSL[4];
   double arrTP[4];

   dTrailingStop = NormalizeDouble(nTrailingStop * Point,4);
   dEscapeTP = NormalizeDouble(nEscapeTP * Point,4);
   dPropSLThreshold = nPropSLThreshold * Point;
   dSpread = MarketInfo(Symbol(),MODE_SPREAD) * Point;
   dStopLevel = MarketInfo(Symbol(),MODE_STOPLEVEL) * Point;
   dInitialSL = NormalizeDouble(nInitialSL * Point,4);
  
   for(int nCnt = 0; nCnt < OrdersTotal(); nCnt++)
   {
      OrderSelect(nCnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderSymbol() == Symbol() ) //(OrderMagicNumber() == nMagic)
      {
         if(OrderType() == OP_BUY)
         { 
            dSl=OrderStopLoss();
            if( dSl == 0 )
               if( dInitialSL != 0)
                  dSl = dnAsk - dInitialSL;
            
            ArrayResize(arrSL,5);
            ArrayInitialize(arrSL,dSl);
 
            LogSL("OP_BUY-check",dSl,arrSL[0],arrSL[1],arrSL[2],arrSL[3]);
 
 
            if( dPropSLRatio > 0 ) 
            {
               if( Bid >= (OrderOpenPrice() + dPropSLThreshold) )
               {
                  dSl = NormalizeDouble( OrderOpenPrice() + dPropSLRatio*(Bid - OrderOpenPrice()) - dSpread,4 ); 
                  if(OrderStopLoss() < dSl)
                  arrSL[1]=dSl;
               } 
               else
               {
                  if(dTrailingStop != 0)
                     arrSL[2]=dnBid - dTrailingStop;
               }
            }               
            
 
            dSl=arrSL[ArrayMaximum(arrSL)];
 
            LogSL("OP_BUY - max",dSl,arrSL[0],arrSL[1],arrSL[2],arrSL[3]);
 
            if( dSl > OrderStopLoss() || OrderStopLoss() == 0 )
               {
                  OrderModify(OrderTicket(), OrderOpenPrice(), 
                     dSl, OrderTakeProfit(), 0, Yellow);
                  Log("Buy - modify", OrderOpenPrice(), dSl, OrderTakeProfit());
               }
 
            // Escape buy
            //if( dEscape != 0 && dnBid < OrderOpenPrice() - dEscape - 5 * Point ) 
            if( nUseEscape == 1 && dnBid < OrderOpenPrice() - dEscapeLevel - 5 * Point ) 
            {
               OrderModify(OrderTicket(), OrderOpenPrice(), 
               OrderStopLoss(), OrderOpenPrice() + dEscapeTP, 0, Aqua);
               Log("Buy - EscapeLevel", OrderOpenPrice(), dSl, OrderTakeProfit());
            }
 
         } // end OP_BUY

////////////////////////////////////////////////////////////////////////////////////////////////// 

         if(OrderType() == OP_SELL)
         {
            dSl=OrderStopLoss();
            if( dSl == 0 )
               if( dInitialSL != 0)
                  dSl = dnBid + dInitialSL;
            
            ArrayResize(arrSL,5);
            ArrayInitialize(arrSL,dSl);
  
            LogSL("OP_SELL-check",dSl,arrSL[0],arrSL[1],arrSL[2],arrSL[3]);
 
            if( dPropSLRatio > 0 ) 
            {
               if( Ask <= (OrderOpenPrice() - dPropSLThreshold) )
               {
                  dSl = NormalizeDouble(OrderOpenPrice() - dPropSLRatio*(OrderOpenPrice() - Ask) + dSpread,4); 
                  if(OrderStopLoss() > dSl)
                  arrSL[1]=dSl;
               } 
               else
               {
                  if(dTrailingStop != 0)
                     arrSL[2]=dnBid + dTrailingStop;
               }
            }

            dSl=arrSL[ArrayMinimum(arrSL)];
 
            LogSL("OP_SELL - min",dSl,arrSL[0],arrSL[1],arrSL[2],arrSL[3]);
 
            if( dSl < OrderStopLoss() || OrderStopLoss() == 0 )
            {
               OrderModify(OrderTicket(), OrderOpenPrice(), 
                  dSl, OrderTakeProfit(), 0, Yellow);
               Log("Sell - modify", OrderOpenPrice(), dSl, OrderTakeProfit());
            }
 
            // Escape sell
            //if( dEscape != 0 && dnAsk > OrderOpenPrice() + dEscape + 5 * Point ) 
            if( nUseEscape == 1 && dnAsk > OrderOpenPrice() + dEscapeLevel + 5 * Point ) 
            {
               OrderModify(OrderTicket(), OrderOpenPrice(), 
               OrderStopLoss(), OrderOpenPrice() - dEscapeTP, 0, Aqua);
               
               Log("Buy - EscapeLevel", OrderOpenPrice(), dSl, OrderTakeProfit());
            }
 
         } // End OP_SELL
      } //end if(OrderMagicNumber() == nMagic)
 
   } //end for(int nCnt = 0; nCnt < OrdersTotal(); nCnt++)
} // end ModifyOrders()


////////////////////////////////////////////////////////////////////////////////////////////////// 


void Log(string msg, double val1, double val2, double val3)
{
   if(logging > 0 )
   { 
      int handle;
      handle=FileOpen(strExpert+".log",FILE_CSV|FILE_READ|FILE_WRITE,';');
      if(handle<1)
      {
         //Print("File "+strExpert+"-log.txt not found, the last error is ", GetLastError());
         Print("File "+strExpert+"-log.txt not found, the last error is ", GetLastError());
         return(false);
      }

      FileSeek(handle, 0, SEEK_END);
      //---- add data to the end of file
      //FileWrite(handle, Year(), Month(), Day(), Hour(), Minute(), "Bid, Ask ", msg, Bid, Ask, "___", val1, val2, val3, val4, val5, val6);
      FileWrite(handle, Year(), Month(), Day(), Hour(), Minute(), msg, Bid, Ask, "___", val1, "___", val2, val3);
      FileClose(handle);
   }
}


void LogSL(string msg, double val1, double val2, double val3, double val4, double val5)
{
   if(logging > 1 )
   { 
      int handle;
      handle=FileOpen(strExpert+"-sl_log.txt",FILE_CSV|FILE_READ|FILE_WRITE,';');
      if(handle<1)
      {
         Print("File "+strExpert+"-sl_log.txt not found, the last error is ", GetLastError());
         return(false);
      }
      FileSeek(handle, 0, SEEK_END);
      //---- add data to the end of file
      FileWrite(handle, Year(), Month(), Day(), Hour(), Minute(), msg, Bid, Ask, val1, val2, val3, val4, val5);
      FileClose(handle);
   }
}



