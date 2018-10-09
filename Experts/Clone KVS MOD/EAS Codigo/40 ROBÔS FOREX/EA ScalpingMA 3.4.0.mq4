#property copyright "ProfFX"
#property link      "http://euronis-free.com/"

//---- input parameters
extern string    A1 = "Orders volume";
extern double    Lots = 0.1;
extern string    A2 = "Periods of fast and slow average";
extern int       FastPeriod = 13;
extern int       SlowPeriod = 21;
extern string    A3 = "Method of calculating the average: 0-SMA, 1-EMA, 2-SMMA, 3-LWMA";
extern int       MAMethod = MODE_EMA;
extern string    A4 = "Calculation of the average price: 0-Close, 1-Open, 2-High, 3-Low, 4-Median..";
extern int       MAPrice = PRICE_TYPICAL;
extern string    A5 = "The number of bars to register flat market (minimum - 2)";
extern int       FlatDuration = 3;
extern string    A6 = "The difference between the center lines in the paragraph shall be deemed Flat";
extern int       FlatPoints = 2;
extern string    A7 = "Margin to stop a percentage of the width of the channel";
extern double    StopMistake = 20.0;
extern string    A8 = "Margin for profit as a percentage of the width of the channel";
extern double    TakeProfitMistake = 0.0;
extern string    A9 = "Other Parameters";
extern string    OpenOrderSound = "ok.wav";        // �������� ������ ��� ��������..
                                                   // ..�������
extern int       MagicNumber = 11259;              // ���������� ������������� �����..
                                                   // ..�������

bool Activate, FreeMarginAlert, FatalError, Signal;
double Tick, Spread, StopLevel, MinLot, MaxLot, LotStep, FreezeLevel, 
       Minimum,                                    // ������� ������������� ������
       Maximum;                                    // �������� ������������� ������
int maxbars;                                       // ������������ ����������..
                                                   // ..�������������� �����       
datetime LastBar,                                  // ����� �������� ����, �� �������..
                                                   // ..���� ����������� ��� ������� � ..
                                                   // ..�������� ��������
         LastSignal;                               // ����� �������� ����, �� �������..
                                                   // ..��� ���������� ��������� ������..
                                                   // ..�������

//+-------------------------------------------------------------------------------------+
//| ������� ������������� ��������                                                      |
//+-------------------------------------------------------------------------------------+
int init()
  {
   FatalError = False;
// - 1 - == ���� ���������� �� �������� �������� ========================================   
   Tick = MarketInfo(Symbol(), MODE_TICKSIZE);                         // ����������� ���    
   Spread = ND(MarketInfo(Symbol(), MODE_SPREAD)*Point);                 // ������� �����
   StopLevel = ND(MarketInfo(Symbol(), MODE_STOPLEVEL)*Point);  // ������� ������� ������
   FreezeLevel = ND(MarketInfo(Symbol(), MODE_FREEZELEVEL)*Point);   // ������� ���������
   MinLot = MarketInfo(Symbol(), MODE_MINLOT);    // ����������� ����������� ����� ������
   MaxLot = MarketInfo(Symbol(), MODE_MAXLOT);   // ������������ ����������� ����� ������
   LotStep = MarketInfo(Symbol(), MODE_LOTSTEP);          // ��� ���������� ������ ������
// - 1 - == ��������� ����� =============================================================

// - 2 - == ���������� ������ ������ � ����������� � �������� ������������ ������ =======   
   Lots = LotRound(Lots);                  // ���������� ������ �� ���������� �����������
// - 2 - == ��������� ����� =============================================================

// - 3 - ==================== �������� ������������ ������� ���������� ==================
   if (FastPeriod < 1)
   {
      Comment("FastPeriod value must be positive. Advisor is disabled!");
      Print("FastPeriod value must be positive. Advisor is disabled!");
      return(0);
   }
   if (SlowPeriod < 1)
   {
      Comment("FastPeriod value must be positive. Advisor is disabled!");
      Print("FastPeriod value must be positive. Advisor is disabled!");
      return(0);
   }
   if (SlowPeriod == FastPeriod)
   {
      Comment("Values FastPeriod and SlowPeriod, can not be equal. Advisor is disabled!");
      Print("Values FastPeriod and SlowPeriod, can not be equal. Advisor is disabled!");
      return(0);
   }
   if (MAMethod < 0 || MAMethod > 3)
   {
      Comment("MAMethod value should be from 0 to 3. Advisor is disabled!");
      Print("MAMethod value should be from 0 to 3. Advisor is disabled!");
      return(0);
   }
   if (MAPrice < 0 || MAPrice > 6)
   {
      Comment("MAPrice value should be from 0 to 6. Advisor is disabled!");
      Print("MAPrice value should be from 0 to 6. Advisor is disabled!");
      return(0);
   }
   if (FlatDuration < 2)
   {
      Comment("FlatDuration value should be 2 or more. Advisor is disabled!");
      Print("FlatDuration value should be 2 or more. Advisor is disabled!");
      return(0);
   }
   if (StopMistake <= 0)
   {
      Comment("StopMistake value must be positive +. Advisor is disabled!");
      Print("StopMistake value must be positive +. Advisor is disabled!");
      return(0);
   }
// - 3 - =========================== ��������� ����� ====================================

   Activate = True; // ��� �������� ������� ���������, �������� ���� ����������� ��������

   return(0);
  }
  
//+-------------------------------------------------------------------------------------+
//| ������� ��������������� ��������                                                    |
//+-------------------------------------------------------------------------------------+
int deinit()
{
 Comment("");
 return(0);
}
  

//+-------------------------------------------------------------------------------------+
//| �������� ������ �� ������������ � ����������                                        |
//+-------------------------------------------------------------------------------------+
double LotRound(double L)
{
 return(MathRound(MathMin(MathMax(L, MinLot), MaxLot)/LotStep)*LotStep);
}

//+-------------------------------------------------------------------------------------+
//| ���������� �������� � �������� ������ ������                                        |
//+-------------------------------------------------------------------------------------+
double ND(double A)
{
 return(NormalizeDouble(A, Digits));
}  

//+-------------------------------------------------------------------------------------+
//| ����������� ��������� �� ������                                                     |
//+-------------------------------------------------------------------------------------+
string ErrorToString(int Error)
{
 switch(Error)
   {
    case 2: return("fixed total error, please contact technical support."); 
    case 5: return("you have an older version of the terminal, update them."); 
    case 6: return("no communication with the server, try to restart the terminal."); 
    case 64: return("account is blocked, please contact technical support.");
    case 132: return("the market is closed."); 
    case 133: return("trade is prohibited."); 
    case 149: return("Blocking is prohibited."); 
   }
}

//+-------------------------------------------------------------------------------------+
//| �������� ��������� ������. ���� ����� ��������, �� ��������� True, ����� - False    |
//+-------------------------------------------------------------------------------------+  
bool WaitForTradeContext()
{
 int P = 0;
 // ���� "����"
 while(IsTradeContextBusy() && P < 5)
   {
    P++;
    Sleep(1000);
   }
 // -------------  
 if(P == 5)
   return(False);
 return(True);    
}

//+-------------------------------------------------------------------------------------+
//| "����������" �������� �������                                                       |
//| � ������� �� OpenOrder ��������� ����������� ������� ������� � ���������������      |
//| ����������:                                                                         |
//|   0 - ��� ������                                                                    |
//|   1 - ������ ��������                                                               |
//|   2 - ������ �������� Price                                                         |
//|   3 - ������ �������� SL                                                            |
//|   4 - ������ �������� TP                                                            |
//|   5 - ������ �������� Lot                                                           |
//+-------------------------------------------------------------------------------------+
int OpenOrderCorrect(int Type, double Lot, double Price, double SL, double TP,
                     bool Redefinition = True)
// Redefinition - ��� True ������������ ��������� �� ���������� ����������
//                ��� False - ���������� ������
{
// - 1 - == �������� ������������� ��������� ������� ====================================
 if(AccountFreeMarginCheck(Symbol(), OP_BUY, Lot) <= 0 || GetLastError() == 134) 
  {
   if(!FreeMarginAlert)
    {
     Print("Enough money to open position. Free Margin = ", 
           AccountFreeMargin());
     FreeMarginAlert = True;
    } 
   return(5);  
  }
 FreeMarginAlert = False;  
// - 1 - == ��������� ����� =============================================================

// - 2 - == ������������� �������� Price, SL � TP ��� ������� ������ ====================   
 RefreshRates();
 switch (Type)
   {
    case OP_BUY: 
                string S = "BUY"; 
                if (MathAbs(Price-Ask)/Point > 3)
                  if (Redefinition) Price = ND(Ask);
                  else              return(2);
                if (ND(TP-Bid) <= StopLevel && TP != 0)
                  if (Redefinition) TP = ND(Bid+StopLevel+Tick);
                  else              return(4);
                if (ND(Bid-SL) <= StopLevel)
                  if (Redefinition) SL = ND(Bid-StopLevel-Tick);
                  else              return(3);
                break;
    case OP_SELL: 
                 S = "SELL"; 
                 if (MathAbs(Price-Bid)/Point > 3)
                   if (Redefinition) Price = ND(Bid);
                   else              return(2);
                 if (ND(Ask-TP) <= StopLevel) 
                   if (Redefinition) TP = ND(Ask-StopLevel-Tick);
                   else              return(4);
                 if (ND(SL-Ask) <= StopLevel && SL != 0)
                   if (Redefinition) SL = ND(Ask+StopLevel+Tick);
                   else              return(3);
                 break;
    case OP_BUYSTOP: 
                    S = "BUYSTOP";
                    if (ND(Price-Ask) <= StopLevel)
                      if (Redefinition) Price = ND(Ask+StopLevel+Tick);
                      else              return(2);
                    if (ND(TP-Price) <= StopLevel && TP != 0)
                      if (Redefinition) TP = ND(Price+StopLevel+Tick);
                      else              return(4);
                    if (ND(Price-SL) <= StopLevel)
                      if (Redefinition) SL = ND(Price-StopLevel-Tick);
                      else              return(3);
                    break;
    case OP_SELLSTOP: 
                     S = "SELLSTOP";
                     if (ND(Bid-Price) <= StopLevel)
                       if (Redefinition) Price = ND(Bid-StopLevel-Tick);
                       else              return(2);
                     if (ND(Price-TP) <= StopLevel)
                       if (Redefinition) TP = ND(Price-StopLevel-Tick);
                       else              return(4);
                     if (ND(SL-Price) <= StopLevel && SL != 0)
                       if (Redefinition) SL = ND(Price+StopLevel+Tick);
                       else              return(3);
                     break;
    case OP_BUYLIMIT: 
                     S = "BUYLIMIT";
                     if (ND(Ask-Price) <= StopLevel)
                      if (Redefinition) Price = ND(Ask-StopLevel-Tick);
                      else              return(2);
                     if (ND(TP-Price) <= StopLevel && TP != 0)
                       if (Redefinition) TP = ND(Price+StopLevel+Tick);
                       else              return(4);
                     if (ND(Price-SL) <= StopLevel)
                       if (Redefinition) SL = ND(Price-StopLevel-Tick);
                       else              return(3);
                     break;
    case OP_SELLLIMIT: 
                     S = "SELLLIMIT";
                     if (ND(Price - Bid) <= StopLevel) 
                       if (Redefinition) Price = ND(Bid+StopLevel+Tick);
                       else              return(2);
                     if (ND(Price-TP) <= StopLevel)
                       if (Redefinition) TP = ND(Price-StopLevel-Tick);
                       else              return(4);
                     if (ND(SL-Price) <= StopLevel && SL != 0)
                       if (Redefinition) SL = ND(Price+StopLevel+Tick);
                       else              return(3);
                     break;
   }
// - 2 - == ��������� ����� =============================================================
 
// - 3 - == �������� ������ � �������� ��������� ������ =================================   
 if(WaitForTradeContext())  // �������� ������������ ��������� ������
   {  
    Comment("Sent a request to open an order ", S, " ...");  
    int ticket=OrderSend(Symbol(), Type, Lot, Price, 3, 
               SL, TP, NULL, MagicNumber, 0);// �������� �������
    // ������� �������� ������� ����������� ��������
    if(ticket<0)
      {
       int Error = GetLastError();
       if(Error == 2 || Error == 5 || Error == 6 || Error == 64 
          || Error == 132 || Error == 133 || Error == 149)     // ������ ��������� ������
         {
          Comment("Fatal error when opening a position because "+
                   ErrorToString(Error)+" Advisor is disabled!");
          FatalError = True;
         }
        else 
         Comment("Error opening position ", S, ": ", Error);       // ����������� ������
       return(1);
      }
    // ---------------------------------------------
    
    // ������� �������� �������   
    Comment("position ", S, " opened successfully!"); 
    PlaySound(OpenOrderSound); 
    return(0); 
    // ------------------------
   }
  else
   {
    Comment("Waiting time until the trade flow is up!");
    return(1);  
   } 
// - 3 - == ��������� ����� =============================================================
}

//+-------------------------------------------------------------------------------------+
//| ���������� �������� � �������� ������ ����                                          |
//+-------------------------------------------------------------------------------------+
double NP(double A)
{
 return(MathRound(A/Tick)*Tick);
}  

//+-------------------------------------------------------------------------------------+
//| ����������� �������� ������������ �����                                             |
//+-------------------------------------------------------------------------------------+
void FlatDetect()
{
// - 1 - ========================= ���������� �������� ������� ==========================
   int i = 1;
   maxbars = Bars - MathMax(FastPeriod, SlowPeriod);
   while (true)                                    // ���� �����������, ����.. 
   {                                               // ..�������������� ����
      double MAFast = iMA(NULL, 0, FastPeriod, 0, MAMethod, MAPrice, i);// ���������..
                                                                        // ..�������
      double MASlow = iMA(NULL, 0, SlowPeriod, 0, MAMethod, MAPrice, i);// �������..
                                                                        // ..�������
      if (MathAbs(MAFast - MASlow) > FlatPoints*Point) // ���� �������� ������� ������..
         break;                                    // ..����������� �������, ��..
                                                   // ..����������� ����� ������������
      i++;                                                   
      if (i > maxbars || i > FlatDuration)
         break;
   }                                                   
// - 1 - ================================ ��������� ����� ===============================

// - 2 - =========================== ��������� ����� ������� ============================
   if (i >= FlatDuration+1)                       // ���� �������� ������� �� ���������..
   {                                              // ..FlatDuration ����� ���� � ��������
      Signal = true;                              // ..���������� ��������, ��..
      Maximum = High[iHighest(NULL, 0, MODE_HIGH, i-1, 1)];// ..�������������� ���� �..
      Minimum = Low[iLowest(NULL, 0, MODE_LOW, i-1, 1)];// ..�������� ��� ������
   }      
   else                                           // ����� ���� �� ��������������
      Signal = false;                             
// - 2 - ================================ ��������� ����� ===============================
}

//+-------------------------------------------------------------------------------------+
//| ������� ������ ����� �������                                                        |
//+-------------------------------------------------------------------------------------+
bool FindOrders()
{
// - 1 - ====================== ������������� ���������� ����� ������� ==================
   int total = OrdersTotal() - 1;
// - 1 - ================================== ��������� ����� =============================
 
// - 2 - ================================ ������������ ������ ===========================
   for (int i = total; i >= 0; i--)                // ������������ ���� ������ �������
      if (OrderSelect(i, SELECT_BY_POS))           // ��������, ��� ����� ������
         if (OrderMagicNumber() == MagicNumber &&  // ����� ������ ���������,
             OrderSymbol() == Symbol())            // ..������� ���������� � �������.. 
            return(true);                          // ������ - ����� ����������
// - 2 - ================================== ��������� ����� =============================
   return(false);                                  // ������ - ����� �� ����������
}

//+-------------------------------------------------------------------------------------+
//| �������� �������                                                                    |
//+-------------------------------------------------------------------------------------+
bool Trade()
{
// - 1 - ========================= ���������� �������� �������� =========================
   double average = (Maximum + Minimum)/2;         // ������� �������� ������
   double bid = MarketInfo(Symbol(), MODE_BID);    // ������� ���� Bid
   double ask = MarketInfo(Symbol(), MODE_ASK);    // ������� ���� Ask
   double slmistake = (Maximum - Minimum)*StopMistake/100; // ����� ��� �����
   double tpmistake = (Maximum - Minimum)*TakeProfitMistake/100; // ����� ��� �������
   int type = -1;                                  // ��� ������ �� ���������
// - 1 - ================================== ��������� ����� =============================

// - 2 - ======================= ���������� ������ ��� �������� ������� =================
   if (bid < average)                              // ������� ���� � ������ ����� ������
   {
      type = OP_BUY;                               // ������� ��� ������ - Buy
      double price = NP(ask);                      // ���� �������� ������ - Ask
      double sl = NP(Minimum - slmistake);         // ����-������ - �� ��������� ������
      double tp = NP(Maximum + tpmistake);         // ������ - ���� ��������� ��� ���� ��
                                                   // ..TakeProfitMistake ���������
      if (tp - price <= StopLevel)                 // ���� ������ ������� ������� ���, ��
         type = -1;                                // ..������ ��������� �� �����
   }      
// - 2 - ============================= ��������� ����� ==================================
           
// - 3 - ====================== ���������� ������ ��� �������� �������� =================
   if (bid > average)                              // ������� ���� � ������� ����� ������
   {
      type = OP_SELL;                              // ������� ��� ������ - Sell
      price = NP(bid);                             // ���� �������� ������ - Bid
      sl = NP(Maximum + Spread + slmistake);       // ����-������ - �� ���������� ������
      tp = NP(Minimum + Spread - tpmistake);       // ������ - ���� ��� ���� �������� ��
                                                   // ..TakeProfitMistake ���������
      if (price - tp <= StopLevel)                 // ���� ������ ������� ������� ���, ��
         type = -1;                                // ..������ ��������� �� �����
   }    
// - 3 - ============================= ��������� ����� ==================================

// - 4 - ============================ ���������� ������ =================================
   if (type >= 0)
      if (OpenOrderCorrect(type, Lots, price, sl, tp) != 0) // ���� ������ �� ����.. 
         return(false);                            // ..���������, �� ������ ������
// - 4 - ============================= ��������� ����� ==================================
 
   return(True);                                   // ��� �������� ��������� 
}

//+-------------------------------------------------------------------------------------+
//| ������� start ��������                                                              |
//+-------------------------------------------------------------------------------------+
int start()
{
// - 1 - ========================== ����� �� �������� ��������? =========================
   if (!Activate || FatalError) return(0);
// - 1 - ============================= ��������� ����� ==================================

// - 2 - ========================== �������� �������� ������ ���� =======================
   if (LastBar == Time[0])                         // ���� �� ������� ���� ��� ����..
      return(0);                                   // ..����������� ����������� ��������,
                                                   // ..�� ��������� ������ ��..
                                                   // ..���������� ����
// - 2 - ============================= ��������� ����� ==================================

// - 3 - ====================== ���������� ���������� � �������� �������� ===============
   if (!IsTesting())
   {
      Tick = MarketInfo(Symbol(), MODE_TICKSIZE);  // ����������� ���    
      Spread = ND(MarketInfo(Symbol(), MODE_SPREAD)*Point);// ������� �����
      StopLevel = ND(MarketInfo(Symbol(), MODE_STOPLEVEL)*Point);//������� ������� ������
      FreezeLevel = ND(MarketInfo(Symbol(), MODE_FREEZELEVEL)*Point);// ������� ���������
   } 
// - 3 - ============================= ��������� ����� ==================================

// - 4 - ========================== ������ �������� �������� � �������� =================
   if (LastSignal != Time[0])                      // �� ������� ���� ��� �� ���..
   {                                               // ..���������� ����� �����
      FlatDetect();                                // ����������, ���� �� ����
      LastSignal = Time[0];                        // ����������� ����� �� ������� ����..
   }                                               // ..�����������
// - 4 - ============================= ��������� ����� ==================================
   
// - 5 - ================== ���������� �������� ��� ����������� ������ ����� ============
   if (Signal && !FindOrders())                    // ���� ���� ������ � ��� ����� ������
      if (!Trade()) return(0);                     // �������� ������
// - 5 - ============================= ��������� ����� ==================================

   LastBar = Time[0];

   return(0);
}

