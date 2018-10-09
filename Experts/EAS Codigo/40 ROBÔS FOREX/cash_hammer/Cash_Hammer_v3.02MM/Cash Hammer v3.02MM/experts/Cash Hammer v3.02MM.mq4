// Cash Hammer v3.02MM
// Educated!

#property copyright "Forex Invest Group & Yuriy Tokman"
#property link      "sale@forexinvest.ee, yuriytokman@gmail.com"

#include <stdlib.mqh>

extern string ____1____ = "__Signal__";
extern int TF = 0;
extern int pips = 10;
extern string ____2____ = "__Trade__";
extern bool op_BUY = TRUE;
extern bool op_SELL = TRUE;
extern double Lots = 0.1;
extern bool Choice_method = FALSE;
extern double Risk = 0.0;
extern int StopLoss = 0;
extern int TakeProfit = 30;
extern int MagicNumber = 10;
extern string ____3___ = "__Traling__";
extern bool Traling = FALSE;
extern bool TSProfitOnly = TRUE;
extern int TStop.Buy = 30;
extern int TStop.Sell = 20;
extern int TrailingStep = 10;
extern string ____4____ = "__Lock __";
extern bool Lock = TRUE;
extern bool Lock_TRL = FALSE;
extern int Lock_pips = 13;
extern double koef_lot_lock = 2.0;
extern int StopLoss_Lock = 0;
extern string ____5____ = "__Averag__";
extern bool AVERAGES = TRUE;
extern int MN_b = 200;
extern int MN_s = 300;
extern int pips_prosadka = 22;
extern double otstyp = 13.0;
extern double koef_lot = 1.1;
extern double exponents = 1.0;
extern int TakeProfit_Av = 34;
extern string ____6____ = "__Rest __";
extern int Slippage = 3;
extern bool MarketWatch = FALSE;
extern bool ShowComment = TRUE;
extern bool ALERT = TRUE;
int gi_276 = 0; // EDUCATED !!
bool gi_280 = FALSE;
bool gi_284 = FALSE;
double gd_288 = 0.0;
string gsa_296[256];
int g_datetime_300 = 0;
int g_datetime_304 = 0;
int g_count_308 = 0;

int init() {
   gi_284 = FALSE;
   gi_276 = AccountNumber(); // EDUCATED !!
   if (!IsTradeAllowed()) {
      Message("For normal job of the adviser it is necessary\n" + "To permit to the adviser to trade");
      gi_284 = TRUE;
      return;
   }
   if (!IsLibrariesAllowed()) {
      Message("For normal job of the adviser it is necessary\n" + "To permit import from the external experts");
      gi_284 = TRUE;
      return;
   }
   if (!IsTesting()) {
      if (IsExpertEnabled()) Message("The adviser will be started by the following ticks");
      else Message("Off the button \"To permit start of the advisers\"");
   }
   for (int l_index_0 = 0; l_index_0 < 256; l_index_0++) gsa_296[l_index_0] = CharToStr(l_index_0);
   GetAvtor();
   GetLogoType();
   return (0);
}

int deinit() {
   if (!IsTesting()) Comment("");
   GetDellName();
   return (0);
}

int start() {
   string ls_16;
   double ld_128;
   double l_lots_0 = 0;
   if (Lots > 0.0) l_lots_0 = Lots;
   else l_lots_0 = GetLot();
   if (gi_280) {
      Message("Critical mistake! The adviser IS STOPPED!");
      return;
   }
   if (gi_284) {
      Message("The adviser was not possible to initialize!");
      return;
   }
   if (!IsTesting()) {
      //if (gi_276 > 0 && gi_276 != AccountNumber()) {
      //   Comment("Trade on the bill: " + AccountNumber() + " IS FORBIDDEN!");
      //   return;
      //}
      Comment("");
   }
   double ld_8 = (AccountEquity() - AccountBalance()) / (AccountBalance() / 100.0);
   if (ld_8 < gd_288) gd_288 = ld_8;
   if (ShowComment) {
      ls_16 = "CurTime=" + TimeToStr(TimeCurrent(), TIME_MINUTES) + "  TakeProfit=" + TakeProfit + "  StopLoss=" + StopLoss + "  Lots=" + DoubleToStr(l_lots_0, 2) 
         + "\n+------------------------------+" 
         + "\n   Balance=" + DoubleToStr(AccountBalance(), 2) 
         + "\n   Equity=" + DoubleToStr(AccountEquity(), 2) 
         + "\n   Profit=" + DoubleToStr(AccountEquity() - AccountBalance(), 3) + " $" 
         + "\n   Profit=" + DoubleToStr(100.0 * (AccountEquity() / AccountBalance() - 1.0), 3) + " %" 
         + "\n   DrawDown Persent=" + DoubleToStr(gd_288, 2) + "%" 
         + "\n   Slippage=" + DoubleToStr(Slippage * GetSlippage(), 0) 
      + "\n+------------------------------+";
      Comment(ls_16);
   } else Comment("");
   Label("ytg_str_561", DoubleToStr(AccountNumber(), 0), 4, 5, 120, 10, "Arial", Lime);
   Label("ytg_str_562", DoubleToStr(gi_276, 0), 4, 5, 140, 10, "Arial", Lime);
   GetYTG();
   double ld_24 = MarketInfo(Symbol(), MODE_STOPLEVEL) / GetPont();
   double ld_32 = ld_24 * GetPoint();
   if (StopLoss > 0 && StopLoss < ld_24) Alert("Parameter *StopLoss* is given not correctly");
   if (TakeProfit > 0 && TakeProfit < ld_24) Alert("Parameter *TakeProfit* is given not correctly");
   if (StopLoss_Lock > 0 && StopLoss_Lock < ld_24) Alert("Parameter *StopLoss_Lock* is given not correctly");
   if (otstyp * GetPoint() == 0.0 || otstyp * GetPoint() < ld_32) Alert("Parameter *otstyp* is given not correctly");
   double ld_40 = 0;
   double ld_48 = 0;
   if (Lock_TRL) {
      SimpleTrailing(Symbol(), -1, MN_s);
      SimpleTrailing(Symbol(), -1, MN_b);
   }
   if (Traling && !ExistPositions(Symbol(), OP_BUY, MN_b)) SimpleTrailing(Symbol(), OP_SELL, MagicNumber);
   if (Traling && !ExistPositions(Symbol(), OP_SELL, MN_s)) SimpleTrailing(Symbol(), OP_BUY, MagicNumber);
   int l_digits_56 = Digits;
   double ld_60 = 100;
   if (l_digits_56 == 3 || l_digits_56 >= 5) ld_60 = 1000;
   int li_68 = 1000.0 * l_lots_0 * TakeProfit_Av / ld_60;
   double ld_72 = GetProfitOpenPosInCurrency(Symbol(), OP_BUY, MagicNumber) + GetProfitOpenPosInCurrency(Symbol(), OP_SELL, MN_s);
   double ld_80 = GetProfitOpenPosInCurrency(Symbol(), OP_SELL, MagicNumber) + GetProfitOpenPosInCurrency(Symbol(), OP_BUY, MN_b);
   if (ExistPositions(Symbol(), OP_SELL, MN_s) && ld_72 > li_68) {
      ClosePositions(Symbol(), OP_BUY, MagicNumber);
      ClosePositions(Symbol(), OP_SELL, MN_s);
      DeleteOrders(Symbol(), OP_SELLSTOP, MN_s);
   }
   if (ExistPositions(Symbol(), OP_BUY, MN_b) && ld_80 > li_68) {
      ClosePositions(Symbol(), OP_SELL, MagicNumber);
      ClosePositions(Symbol(), OP_BUY, MN_b);
      DeleteOrders(Symbol(), OP_BUYSTOP, MN_b);
   }
   double l_minlot_88 = MarketInfo(Symbol(), MODE_MINLOT);
   double l_maxlot_96 = MarketInfo(Symbol(), MODE_MAXLOT);
   double ld_104 = NormalizeDouble(l_lots_0 * koef_lot, LotPoint());
   if (ld_104 <= l_lots_0) ld_104 = NormalizeDouble(l_lots_0 + l_minlot_88, LotPoint());
   double ld_112 = NormalizeDouble(Ask + otstyp * GetPoint(), Digits);
   double ld_120 = NormalizeDouble(Bid - otstyp * GetPoint(), Digits);
   if (AVERAGES) {
      if (GetOrderOpenPrice(Symbol(), -1, MN_b) - Ask > (pips_prosadka + otstyp + GetCount(Symbol(), OP_BUY, MN_b)) * GetPoint() * exponents) {
         ld_128 = GetLotLastOrder(Symbol(), -1, MN_b);
         ld_104 = NormalizeDouble(koef_lot * ld_128, LotPoint());
         if (ld_104 <= ld_128) ld_104 = NormalizeDouble(ld_128 + l_minlot_88, LotPoint());
         if (ld_104 > l_maxlot_96) ld_104 = NormalizeDouble(l_maxlot_96, LotPoint());
         SetOrder(Symbol(), OP_BUYSTOP, ld_104, ld_112, 0, 0, MN_b, 0);
      }
      if (Bid - GetOrderOpenPrice(Symbol(), -1, MN_s) > (pips_prosadka + otstyp + GetCount(Symbol(), OP_SELL, MN_s)) * GetPoint() * exponents && GetOrderOpenPrice(Symbol(), -1, MN_s) > 0.0) {
         ld_128 = GetLotLastOrder(Symbol(), -1, MN_s);
         ld_104 = NormalizeDouble(koef_lot * ld_128, LotPoint());
         if (ld_104 <= ld_128) ld_104 = NormalizeDouble(ld_128 + l_minlot_88, LotPoint());
         if (ld_104 > l_maxlot_96) ld_104 = NormalizeDouble(l_maxlot_96, LotPoint());
         SetOrder(Symbol(), OP_SELLSTOP, ld_104, ld_120, 0, 0, MN_s, 0);
      }
   }
   double ld_136 = 0;
   if (Lock) {
      if (PriceOpenLastPos(Symbol(), OP_BUY, MagicNumber) - Ask > Lock_pips * GetPoint() && !ExistPositions(Symbol(), OP_SELL, MN_s)) {
         ld_136 = NormalizeDouble(GetLotLastPos(0, OP_BUY, MagicNumber) * koef_lot_lock, LotPoint());
         if (StopLoss_Lock > 0) ld_40 = Bid + StopLoss_Lock * GetPoint();
         else ld_40 = 0;
         OpenPosition(Symbol(), OP_SELL, ld_136, ld_40, ld_48, MN_s, "��� ���");
      }
      if (Bid - PriceOpenLastPos(Symbol(), OP_SELL, MagicNumber) > Lock_pips * GetPoint() && !ExistPositions(Symbol(), OP_BUY, MN_b) && ExistPositions(Symbol(), OP_SELL, MagicNumber)) {
         ld_136 = NormalizeDouble(GetLotLastPos(0, OP_SELL, MagicNumber) * koef_lot_lock, LotPoint());
         if (StopLoss_Lock > 0) ld_40 = Ask - StopLoss_Lock * GetPoint();
         else ld_40 = 0;
         OpenPosition(Symbol(), OP_BUY, ld_136, ld_40, ld_48, MN_b, "��� ����");
      }
   }
   double l_iopen_144 = iOpen(Symbol(), TF, 1);
   double l_iclose_152 = iClose(Symbol(), TF, 1);
   double ld_160 = (l_iopen_144 - l_iclose_152) / GetPoint();
   if (fNewBar_b() && !ExistPositions(Symbol(), OP_BUY, MagicNumber) && op_BUY) {
      if (ld_160 < pips) {
         if (StopLoss > 0) ld_40 = Ask - StopLoss * GetPoint();
         else ld_40 = 0;
         if (TakeProfit > 0) ld_48 = Ask + TakeProfit * GetPoint();
         else ld_48 = 0;
         OpenPosition(Symbol(), OP_BUY, l_lots_0, ld_40, ld_48, MagicNumber, "��� �������");
      }
   }
   if (fNewBar_s() && !ExistPositions(Symbol(), OP_SELL, MagicNumber) && op_SELL) {
      if (ld_160 > pips) {
         if (StopLoss > 0) ld_40 = Bid + StopLoss * GetPoint();
         else ld_40 = 0;
         if (TakeProfit > 0) ld_48 = Bid - TakeProfit * GetPoint();
         else ld_48 = 0;
         OpenPosition(Symbol(), OP_SELL, l_lots_0, ld_40, ld_48, MagicNumber, "���� �������");
      }
   }
   return (0);
}

int fNewBar_b() {
   if (g_datetime_300 != iTime(Symbol(), TF, 0)) {
      if (g_datetime_300 == 0) {
         g_datetime_300 = iTime(Symbol(), TF, 0);
         return (0);
      }
      g_datetime_300 = iTime(Symbol(), TF, 0);
      return (1);
   }
   return (0);
}

int fNewBar_s() {
   if (g_datetime_304 != iTime(Symbol(), TF, 0)) {
      if (g_datetime_304 == 0) {
         g_datetime_304 = iTime(Symbol(), TF, 0);
         return (0);
      }
      g_datetime_304 = iTime(Symbol(), TF, 0);
      return (1);
   }
   return (0);
}

bool ExistPositions(string as_0 = "", int a_cmd_8 = -1, int a_magic_12 = -1, int ai_16 = 0) {
   int l_ord_total_24 = OrdersTotal();
   if (GetProPoint()) {
      if (as_0 == "0") as_0 = Symbol();
      for (int l_pos_20 = 0; l_pos_20 < l_ord_total_24; l_pos_20++) {
         if (OrderSelect(l_pos_20, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == as_0 || as_0 == "") {
               if (OrderType() == OP_BUY || OrderType() == OP_SELL) {
                  if (a_cmd_8 < OP_BUY || OrderType() == a_cmd_8) {
                     if (a_magic_12 < 0 || OrderMagicNumber() == a_magic_12)
                        if (ai_16 <= OrderOpenTime()) return (TRUE);
                  }
               }
            }
         }
      }
   }
   return (FALSE);
}

void Message(string as_0) {
   Comment(as_0);
   if (StringLen(as_0) > 0) Print(as_0);
}

void OpenPosition(string a_symbol_0, int a_cmd_8, double ad_12, double a_price_20 = 0.0, double a_price_28 = 0.0, int a_magic_36 = 0, string as_40 = "") {
   color l_color_48;
   int l_datetime_52;
   double l_price_56;
   double l_ask_64;
   double l_bid_72;
   int l_digits_80;
   int l_error_84;
   int l_ticket_92 = 0;
   string l_comment_96 = as_40 + "   /" + WindowExpertName() + " " + GetNameTF(Period());
   if (a_symbol_0 == "" || a_symbol_0 == "0") a_symbol_0 = Symbol();
   if (a_cmd_8 == OP_BUY) l_color_48 = Lime;
   else l_color_48 = Red;
   for (int li_88 = 1; li_88 <= 5; li_88++) {
      if (!IsTesting() && !IsExpertEnabled() || IsStopped()) {
         Print("OpenPosition(): Stops");
         break;
      }
      while (!IsTradeAllowed()) Sleep(5000);
      RefreshRates();
      l_digits_80 = MarketInfo(a_symbol_0, MODE_DIGITS);
      l_ask_64 = MarketInfo(a_symbol_0, MODE_ASK);
      l_bid_72 = MarketInfo(a_symbol_0, MODE_BID);
      if (a_cmd_8 == OP_BUY) l_price_56 = l_ask_64;
      else l_price_56 = l_bid_72;
      l_price_56 = NormalizeDouble(l_price_56, l_digits_80);
      l_datetime_52 = TimeCurrent();
      if (ObjectFind("label") < 0) return;
      if (AccountFreeMarginCheck(Symbol(), a_cmd_8, ad_12) <= 0.0 || GetLastError() == 134/* NOT_ENOUGH_MONEY */) {
         if (!(ALERT)) return;
         Alert(WindowExpertName() + " " + Symbol(), " ", GetNameTF(), " ", "For opening a position ", GetNameOP(a_cmd_8), ", Lots=", ad_12, ", The free means do not suffice.");
         return;
      }
      if (MarketWatch) l_ticket_92 = OrderSend(a_symbol_0, a_cmd_8, ad_12, l_price_56, Slippage * GetSlippage(), 0, 0, l_comment_96, a_magic_36, 0, l_color_48);
      else l_ticket_92 = OrderSend(a_symbol_0, a_cmd_8, ad_12, l_price_56, Slippage * GetSlippage(), a_price_20, a_price_28, l_comment_96, a_magic_36, 0, l_color_48);
      if (l_ticket_92 > 0) {
         PlaySound("ok");
         break;
      }
      l_error_84 = GetLastError();
      if (l_ask_64 == 0.0 && l_bid_72 == 0.0) Message("Check up in the Review of the market presence of a symbol " + a_symbol_0);
      Print("Error(", l_error_84, ") opening position: ", ErrorDescription(l_error_84), ", try ", li_88);
      Print("Ask=", l_ask_64, " Bid=", l_bid_72, " sy=", a_symbol_0, " ll=", ad_12, " op=", GetNameOP(a_cmd_8), " pp=", l_price_56, " sl=", a_price_20, " tp=", a_price_28, " mn=", a_magic_36);
      if (l_error_84 == 2/* COMMON_ERROR */ || l_error_84 == 64/* ACCOUNT_DISABLED */ || l_error_84 == 65/* INVALID_ACCOUNT */ || l_error_84 == 133/* TRADE_DISABLED */) {
         gi_280 = TRUE;
         break;
      }
      if (l_error_84 == 4/* SERVER_BUSY */ || l_error_84 == 131/* INVALID_TRADE_VOLUME */ || l_error_84 == 132/* MARKET_CLOSED */) {
         Sleep(300000);
         break;
      }
      if (l_error_84 == 128/* TRADE_TIMEOUT */ || l_error_84 == 142 || l_error_84 == 143) {
         Sleep(66666.0);
         if (ExistPositions(a_symbol_0, a_cmd_8, a_magic_36, l_datetime_52)) {
            PlaySound("alert2");
            break;
         }
      }
      if (l_error_84 == 140/* LONG_POSITIONS_ONLY_ALLOWED */ || l_error_84 == 148/* ERR_TRADE_TOO_MANY_ORDERS */ || l_error_84 == 4110/* LONGS__NOT_ALLOWED */ || l_error_84 == 4111/* SHORTS_NOT_ALLOWED */) break;
      if (l_error_84 == 141/* TOO_MANY_REQUESTS */) Sleep(100000);
      if (l_error_84 == 145/* TRADE_MODIFY_DENIED */) Sleep(17000);
      if (l_error_84 == 146/* TRADE_CONTEXT_BUSY */) while (IsTradeContextBusy()) Sleep(11000);
      if (l_error_84 != 135/* PRICE_CHANGED */) Sleep(7700.0);
   }
   if (MarketWatch && l_ticket_92 > 0 && a_price_20 > 0.0 || a_price_28 > 0.0)
      if (OrderSelect(l_ticket_92, SELECT_BY_TICKET)) ModifyOrder(-1, a_price_20, a_price_28);
}

string GetNameTF(int a_timeframe_0 = 0) {
   if (a_timeframe_0 == 0) a_timeframe_0 = Period();
   switch (a_timeframe_0) {
   case PERIOD_M1:
      return ("M1");
   case PERIOD_M5:
      return ("M5");
   case PERIOD_M15:
      return ("M15");
   case PERIOD_M30:
      return ("M30");
   case PERIOD_H1:
      return ("H1");
   case PERIOD_H4:
      return ("H4");
   case PERIOD_D1:
      return ("Daily");
   case PERIOD_W1:
      return ("Weekly");
   case PERIOD_MN1:
      return ("Monthly");
   }
   return ("UnknownPeriod");
}

string GetNameOP(int ai_0) {
   switch (ai_0) {
   case 0:
      return ("Buy");
   case 1:
      return ("Sell");
   case 2:
      return ("Buy Limit");
   case 3:
      return ("Sell Limit");
   case 4:
      return ("Buy Stop");
   case 5:
      return ("Sell Stop");
   }
   return ("Unknown Operation");
}

void ModifyOrder(double a_ord_open_price_0 = -1.0, double a_ord_stoploss_8 = 0.0, double a_ord_takeprofit_16 = 0.0, int a_datetime_24 = 0) {
   bool l_bool_28;
   color l_color_32;
   double l_ask_44;
   double l_bid_52;
   int l_error_80;
   int l_digits_76 = MarketInfo(OrderSymbol(), MODE_DIGITS);
   if (a_ord_open_price_0 <= 0.0) a_ord_open_price_0 = OrderOpenPrice();
   if (a_ord_stoploss_8 < 0.0) a_ord_stoploss_8 = OrderStopLoss();
   if (a_ord_takeprofit_16 < 0.0) a_ord_takeprofit_16 = OrderTakeProfit();
   a_ord_open_price_0 = NormalizeDouble(a_ord_open_price_0, l_digits_76);
   a_ord_stoploss_8 = NormalizeDouble(a_ord_stoploss_8, l_digits_76);
   a_ord_takeprofit_16 = NormalizeDouble(a_ord_takeprofit_16, l_digits_76);
   double ld_36 = NormalizeDouble(OrderOpenPrice(), l_digits_76);
   double ld_60 = NormalizeDouble(OrderStopLoss(), l_digits_76);
   double ld_68 = NormalizeDouble(OrderTakeProfit(), l_digits_76);
   if (a_ord_open_price_0 != ld_36 || a_ord_stoploss_8 != ld_60 || a_ord_takeprofit_16 != ld_68) {
      for (int li_84 = 1; li_84 <= 5; li_84++) {
         if (!IsTesting() && !IsExpertEnabled() || IsStopped()) break;
         while (!IsTradeAllowed()) Sleep(5000);
         RefreshRates();
         l_bool_28 = OrderModify(OrderTicket(), a_ord_open_price_0, a_ord_stoploss_8, a_ord_takeprofit_16, a_datetime_24, l_color_32);
         if (l_bool_28) {
            PlaySound("alert");
            return;
         }
         l_error_80 = GetLastError();
         l_ask_44 = MarketInfo(OrderSymbol(), MODE_ASK);
         l_bid_52 = MarketInfo(OrderSymbol(), MODE_BID);
         Print("Error(", l_error_80, ") modifying order: ", ErrorDescription(l_error_80), ", try ", li_84);
         Print("Ask=", l_ask_44, "  Bid=", l_bid_52, "  sy=", OrderSymbol(), "  op=" + GetNameOP(OrderType()), "  pp=", a_ord_open_price_0, "  sl=", a_ord_stoploss_8, "  tp=", a_ord_takeprofit_16);
         Sleep(10000);
      }
   }
}

void SimpleTrailing(string as_0 = "", int a_cmd_8 = -1, int a_magic_12 = -1) {
   double ld_16;
   double l_price_24;
   int l_ord_total_36 = OrdersTotal();
   if (as_0 == "0") as_0 = Symbol();
   for (int l_pos_32 = 0; l_pos_32 < l_ord_total_36; l_pos_32++) {
      if (OrderSelect(l_pos_32, SELECT_BY_POS, MODE_TRADES)) {
         if (OrderSymbol() == as_0 || as_0 == "" && a_cmd_8 < OP_BUY || OrderType() == a_cmd_8) {
            ld_16 = GetPoint();
            if (a_magic_12 < 0 || OrderMagicNumber() == a_magic_12) {
               if (OrderType() == OP_BUY) {
                  l_price_24 = MarketInfo(OrderSymbol(), MODE_BID);
                  if (!TSProfitOnly || l_price_24 - OrderOpenPrice() > TStop.Buy * ld_16)
                     if (OrderStopLoss() < l_price_24 - (TStop.Buy + TrailingStep - 1) * ld_16) ModifyOrder(-1, l_price_24 - TStop.Buy * ld_16, -1);
               }
               if (OrderType() == OP_SELL) {
                  l_price_24 = MarketInfo(OrderSymbol(), MODE_ASK);
                  if (!TSProfitOnly || OrderOpenPrice() - l_price_24 > TStop.Sell * ld_16)
                     if (OrderStopLoss() > l_price_24 + (TStop.Sell + TrailingStep - 1) * ld_16 || OrderStopLoss() == 0.0) ModifyOrder(-1, l_price_24 + TStop.Sell * ld_16, -1);
               }
            }
         }
      }
   }
}

double GetProfitOpenPosInCurrency(string as_0 = "", int a_cmd_8 = -1, int a_magic_12 = -1) {
   double ld_ret_16 = 0;
   int l_ord_total_28 = OrdersTotal();
   if (as_0 == "0") as_0 = Symbol();
   for (int l_pos_24 = 0; l_pos_24 < l_ord_total_28; l_pos_24++) {
      if (OrderSelect(l_pos_24, SELECT_BY_POS, MODE_TRADES)) {
         if (OrderSymbol() == as_0 || as_0 == "" && a_cmd_8 < OP_BUY || OrderType() == a_cmd_8) {
            if (OrderType() == OP_BUY || OrderType() == OP_SELL)
               if (a_magic_12 < 0 || OrderMagicNumber() == a_magic_12) ld_ret_16 += OrderProfit() + OrderCommission() + OrderSwap();
         }
      }
   }
   return (ld_ret_16);
}

void ClosePositions(string as_0 = "", int a_cmd_8 = -1, int a_magic_12 = -1) {
   int l_ord_total_20 = OrdersTotal();
   if (as_0 == "0") as_0 = Symbol();
   for (int l_pos_16 = l_ord_total_20 - 1; l_pos_16 >= 0; l_pos_16--) {
      if (OrderSelect(l_pos_16, SELECT_BY_POS, MODE_TRADES)) {
         if (OrderSymbol() == as_0 || as_0 == "" && a_cmd_8 < OP_BUY || OrderType() == a_cmd_8) {
            if (OrderType() == OP_BUY || OrderType() == OP_SELL)
               if (a_magic_12 < 0 || OrderMagicNumber() == a_magic_12) ClosePosBySelect();
         }
      }
   }
}

void ClosePosBySelect() {
   bool l_ord_close_0;
   color l_color_4;
   double l_ord_lots_8;
   double ld_16;
   double ld_24;
   double l_price_32;
   int l_error_40;
   if (OrderType() == OP_BUY || OrderType() == OP_SELL) {
      for (int li_44 = 1; li_44 <= 5; li_44++) {
         if (!IsTesting() && !IsExpertEnabled() || IsStopped()) break;
         while (!IsTradeAllowed()) Sleep(5000);
         RefreshRates();
         ld_16 = NormalizeDouble(MarketInfo(OrderSymbol(), MODE_ASK), Digits);
         ld_24 = NormalizeDouble(MarketInfo(OrderSymbol(), MODE_BID), Digits);
         if (OrderType() == OP_BUY) {
            l_price_32 = ld_24;
            l_color_4 = Aqua;
         } else {
            l_price_32 = ld_16;
            l_color_4 = Gold;
         }
         l_ord_lots_8 = OrderLots();
         l_ord_close_0 = OrderClose(OrderTicket(), l_ord_lots_8, l_price_32, Slippage * GetSlippage(), l_color_4);
         if (l_ord_close_0) {
            PlaySound("tick");
            return;
         }
         l_error_40 = GetLastError();
         if (l_error_40 == 146/* TRADE_CONTEXT_BUSY */) while (IsTradeContextBusy()) Sleep(11000);
         Print("Error(", l_error_40, ") Close ", GetNameOP(OrderType()), " ", ErrorDescription(l_error_40), ", try ", li_44);
         Print(OrderTicket(), "  Ask=", ld_16, "  Bid=", ld_24, "  pp=", l_price_32);
         Print("sy=", OrderSymbol(), "  ll=", l_ord_lots_8, "  sl=", OrderStopLoss(), "  tp=", OrderTakeProfit(), "  mn=", OrderMagicNumber());
         Sleep(5000);
      }
   } else Print("Incorrect trade operation. Close ", GetNameOP(OrderType()));
}

void Label(string a_name_0, string a_text_8, int a_corner_16 = 2, int a_x_20 = 3, int a_y_24 = 15, int a_fontsize_28 = 10, string a_fontname_32 = "Arial", color a_color_40 = 3329330) {
   if (ObjectFind(a_name_0) != -1) ObjectDelete(a_name_0);
   ObjectCreate(a_name_0, OBJ_LABEL, 0, 0, 0, 0, 0);
   ObjectSet(a_name_0, OBJPROP_CORNER, a_corner_16);
   ObjectSet(a_name_0, OBJPROP_XDISTANCE, a_x_20);
   ObjectSet(a_name_0, OBJPROP_YDISTANCE, a_y_24);
   ObjectSetText(a_name_0, a_text_8, a_fontsize_28, a_fontname_32, a_color_40);
}

double GetLot() {
   double l_free_magrin_0 = 0;
   if (Choice_method) l_free_magrin_0 = AccountBalance();
   else l_free_magrin_0 = AccountFreeMargin();
   double l_minlot_8 = MarketInfo(Symbol(), MODE_MINLOT);
   double l_maxlot_16 = MarketInfo(Symbol(), MODE_MAXLOT);
   double ld_24 = Risk / 100.0;
   double ld_ret_32 = MathFloor(l_free_magrin_0 * ld_24 / MarketInfo(Symbol(), MODE_MARGINREQUIRED) / MarketInfo(Symbol(), MODE_LOTSTEP)) * MarketInfo(Symbol(), MODE_LOTSTEP);
   if (ld_ret_32 < l_minlot_8) ld_ret_32 = l_minlot_8;
   if (ld_ret_32 > l_maxlot_16) ld_ret_32 = l_maxlot_16;
   return (ld_ret_32);
}

void GetAvtor() {
   string lsa_0[256];
   for (int l_index_4 = 0; l_index_4 < 256; l_index_4++) lsa_0[l_index_4] = CharToStr(l_index_4);
   string ls_8 = lsa_0[70] + lsa_0[97] + lsa_0[99] + lsa_0[116] + lsa_0[111] + lsa_0[114] + lsa_0[121] + lsa_0[32] + lsa_0[111] + lsa_0[102] + lsa_0[32] + lsa_0[116] +
      lsa_0[104] + lsa_0[101] + lsa_0[32] + lsa_0[97] + lsa_0[100] + lsa_0[118] + lsa_0[105] + lsa_0[115] + lsa_0[101] + lsa_0[114] + lsa_0[115] + lsa_0[58] + lsa_0[32] +
      lsa_0[121] + lsa_0[117] + lsa_0[114] + lsa_0[105] + lsa_0[121] + lsa_0[116] + lsa_0[111] + lsa_0[107] + lsa_0[109] + lsa_0[97] + lsa_0[110] + lsa_0[64] + lsa_0[103] +
      lsa_0[109] + lsa_0[97] + lsa_0[105] + lsa_0[108] + lsa_0[46] + lsa_0[99] + lsa_0[111] + lsa_0[109];
   Label("label", ls_8, 2, 3, 15, 10);
}

void GetLogoType() {
   Label("ytg_logo_1", "Forex", 4, 380, 5, 35, "Times New Roman", Red);
   Label("ytg_logo_2", "Invest", 4, 488, 25, 35, "Times New Roman", Lime);
   Label("ytg_logo_3", "GROUP", 4, 420, 50, 11, "Arial Black", Aqua);
   Label("ytg_logo_4", "�", 4, 373, 45, 26, "Wingdings 3", Red);
   Label("ytg_logo_5", "�", 4, 585, 9, 26, "Wingdings 3", Lime);
   for (int l_count_0 = 0; l_count_0 < 36; l_count_0++) Label("ytg_logo_6" + l_count_0, ";", 4, 5 * l_count_0 + 410, 13, 4, "Wingdings", Lime);
   for (l_count_0 = 0; l_count_0 < 36; l_count_0++) Label("ytg_logo_7" + l_count_0, ";", 4, 5 * l_count_0 + 400, 72, 4, "Wingdings", Red);
   Label("ytg_logo_8", "www.forexinvest.ee", 4, 450, 77, 8, "Arial", LightCyan);
}

void GetDellName(string as_0 = "ytg_") {
   string l_name_8;
   for (int li_16 = ObjectsTotal() - 1; li_16 >= 0; li_16--) {
      l_name_8 = ObjectName(li_16);
      if (StringFind(l_name_8, as_0) != -1) ObjectDelete(l_name_8);
   }
}

void DeleteOrders(string as_0 = "", int a_cmd_8 = -1, int a_magic_12 = -1) {
   bool l_ord_delete_16;
   int l_error_20;
   int l_cmd_36;
   int l_ord_total_32 = OrdersTotal();
   if (as_0 == "0") as_0 = Symbol();
   for (int l_pos_24 = l_ord_total_32 - 1; l_pos_24 >= 0; l_pos_24--) {
      if (OrderSelect(l_pos_24, SELECT_BY_POS, MODE_TRADES)) {
         l_cmd_36 = OrderType();
         if (l_cmd_36 > OP_SELL && l_cmd_36 < 6) {
            if (OrderSymbol() == as_0 || as_0 == "" && a_cmd_8 < OP_BUY || l_cmd_36 == a_cmd_8) {
               if (a_magic_12 < 0 || OrderMagicNumber() == a_magic_12) {
                  for (int li_28 = 1; li_28 <= 5; li_28++) {
                     if (!IsTesting() && !IsExpertEnabled() || IsStopped()) break;
                     while (!IsTradeAllowed()) Sleep(5000);
                     l_ord_delete_16 = OrderDelete(OrderTicket(), White);
                     if (l_ord_delete_16) {
                        PlaySound("timeout");
                        break;
                     }
                     l_error_20 = GetLastError();
                     Print("Error(", l_error_20, ") delete order ", GetNameOP(l_cmd_36), ": ", ErrorDescription(l_error_20), ", try ", li_28);
                     Sleep(5000);
                  }
               }
            }
         }
      }
   }
}

int GetCount(string as_0 = "", int a_cmd_8 = -1, int a_magic_12 = -1) {
   int li_ret_24;
   int l_ord_total_20 = OrdersTotal();
   if (as_0 == "0") as_0 = Symbol();
   for (int l_pos_16 = 0; l_pos_16 < l_ord_total_20; l_pos_16++) {
      if (OrderSelect(l_pos_16, SELECT_BY_POS, MODE_TRADES)) {
         if (OrderSymbol() == as_0 || as_0 == "") {
            if (OrderType() >= OP_BUY && OrderType() < 6) {
               if (a_cmd_8 < OP_BUY || OrderType() == a_cmd_8)
                  if (a_magic_12 < 0 || OrderMagicNumber() == a_magic_12) li_ret_24++;
            }
         }
      }
   }
   return (li_ret_24);
}

double LotPoint() {
   double l_lotstep_0 = MarketInfo(Symbol(), MODE_LOTSTEP);
   int li_ret_8 = MathCeil(MathAbs(MathLog(l_lotstep_0) / MathLog(10)));
   return (li_ret_8);
}

double GetSlippage() {
   int l_digits_0 = Digits;
   double ld_ret_4 = 1;
   if (l_digits_0 == 3 || l_digits_0 >= 5) ld_ret_4 = 10;
   return (ld_ret_4);
}

double GetPoint() {
   int li_0 = StringFind(Symbol(), "JPY");
   if (li_0 == -1) return (0.0001);
   return (0.01);
}

double GetOrderOpenPrice(string as_0 = "", int a_cmd_8 = -1, int a_magic_12 = -1) {
   int l_datetime_16;
   double l_ord_open_price_20 = 0;
   int l_ord_total_32 = OrdersTotal();
   if (as_0 == "0") as_0 = Symbol();
   for (int l_pos_28 = 0; l_pos_28 < l_ord_total_32; l_pos_28++) {
      if (OrderSelect(l_pos_28, SELECT_BY_POS, MODE_TRADES)) {
         if (OrderSymbol() == as_0 || as_0 == "") {
            if (OrderType() >= OP_BUY && OrderType() < 6) {
               if (a_cmd_8 < OP_BUY || OrderType() == a_cmd_8) {
                  if (a_magic_12 < 0 || OrderMagicNumber() == a_magic_12) {
                     if (l_datetime_16 < OrderOpenTime()) {
                        l_datetime_16 = OrderOpenTime();
                        l_ord_open_price_20 = OrderOpenPrice();
                     }
                  }
               }
            }
         }
      }
   }
   return (l_ord_open_price_20);
}

double GetLotLastOrder(string as_0 = "", int a_cmd_8 = -1, int a_magic_12 = -1) {
   int l_datetime_16;
   double l_ord_lots_20 = -1;
   int l_ord_total_32 = OrdersTotal();
   if (as_0 == "0") as_0 = Symbol();
   for (int l_pos_28 = 0; l_pos_28 < l_ord_total_32; l_pos_28++) {
      if (OrderSelect(l_pos_28, SELECT_BY_POS, MODE_TRADES)) {
         if (OrderSymbol() == as_0 || as_0 == "") {
            if (OrderType() >= OP_BUY && OrderType() < 6) {
               if (a_cmd_8 < OP_BUY || OrderType() == a_cmd_8) {
                  if (a_magic_12 < 0 || OrderMagicNumber() == a_magic_12) {
                     if (l_datetime_16 < OrderOpenTime()) {
                        l_datetime_16 = OrderOpenTime();
                        l_ord_lots_20 = OrderLots();
                     }
                  }
               }
            }
         }
      }
   }
   return (l_ord_lots_20);
}

void SetOrder(string a_symbol_0, int a_cmd_8, double ad_12, double a_price_20, double a_price_28 = 0.0, double a_price_36 = 0.0, int a_magic_44 = 0, int a_datetime_48 = 0) {
   color l_color_52;
   int l_datetime_56;
   double l_ask_60;
   double l_bid_68;
   double l_point_76;
   int l_error_84;
   int l_ticket_92;
   int l_stoplevel_96;
   int l_cmd_100;
   string l_comment_104 = WindowExpertName() + " " + GetNameTF(Period());
   if (GetProPoint()) {
      if (a_symbol_0 == "" || a_symbol_0 == "0") a_symbol_0 = Symbol();
      l_stoplevel_96 = MarketInfo(a_symbol_0, MODE_STOPLEVEL);
      if (a_cmd_8 == OP_BUYLIMIT || a_cmd_8 == OP_BUYSTOP) {
         l_color_52 = Lime;
         l_cmd_100 = 0;
      } else {
         l_color_52 = Red;
         l_cmd_100 = 1;
      }
      if (a_datetime_48 > 0 && a_datetime_48 < TimeCurrent()) a_datetime_48 = 0;
      for (int li_88 = 1; li_88 <= 5; li_88++) {
         if (!IsTesting() && !IsExpertEnabled() || IsStopped()) {
            Print("SetOrder(): Stop");
            return;
         }
         while (!IsTradeAllowed()) Sleep(5000);
         RefreshRates();
         l_datetime_56 = TimeCurrent();
         if (AccountFreeMarginCheck(Symbol(), l_cmd_100, ad_12) <= 0.0 || GetLastError() == 134/* NOT_ENOUGH_MONEY */) {
            if (!(ALERT)) break;
            Alert(WindowExpertName() + " " + Symbol(), " ", GetNameTF(), " ", "For opening a position ", GetNameOP(a_cmd_8), ", Lots=", ad_12, ", The free means do not suffice.");
            return;
         }
         l_ticket_92 = OrderSend(a_symbol_0, a_cmd_8, ad_12, a_price_20, Slippage * GetSlippage(), a_price_28, a_price_36, l_comment_104, a_magic_44, a_datetime_48, l_color_52);
         if (l_ticket_92 > 0) {
            PlaySound("ok");
            return;
         }
         l_error_84 = GetLastError();
         if (l_error_84 == 128/* TRADE_TIMEOUT */ || l_error_84 == 142 || l_error_84 == 143) {
            Sleep(66000);
            if (ExistOrders(a_symbol_0, a_cmd_8, a_magic_44, l_datetime_56)) {
               PlaySound("alert2");
               return;
            }
            Print("Error(", l_error_84, ") set order: ", ErrorDescription(l_error_84), ", try ", li_88);
         } else {
            l_point_76 = MarketInfo(a_symbol_0, MODE_POINT);
            l_ask_60 = MarketInfo(a_symbol_0, MODE_ASK);
            l_bid_68 = MarketInfo(a_symbol_0, MODE_BID);
            if (l_error_84 == 130/* INVALID_STOPS */) {
               switch (a_cmd_8) {
               case OP_BUYLIMIT:
                  if (a_price_20 > l_ask_60 - l_stoplevel_96 * l_point_76) a_price_20 = l_ask_60 - l_stoplevel_96 * l_point_76;
                  if (a_price_28 > a_price_20 - (l_stoplevel_96 + 1) * l_point_76) a_price_28 = a_price_20 - (l_stoplevel_96 + 1) * l_point_76;
                  if (a_price_36 > 0.0 && a_price_36 < a_price_20 + (l_stoplevel_96 + 1) * l_point_76) a_price_36 = a_price_20 + (l_stoplevel_96 + 1) * l_point_76;
                  break;
               case OP_BUYSTOP:
                  if (a_price_20 < l_ask_60 + (l_stoplevel_96 + 1) * l_point_76) a_price_20 = l_ask_60 + (l_stoplevel_96 + 1) * l_point_76;
                  if (a_price_28 > a_price_20 - (l_stoplevel_96 + 1) * l_point_76) a_price_28 = a_price_20 - (l_stoplevel_96 + 1) * l_point_76;
                  if (a_price_36 > 0.0 && a_price_36 < a_price_20 + (l_stoplevel_96 + 1) * l_point_76) a_price_36 = a_price_20 + (l_stoplevel_96 + 1) * l_point_76;
                  break;
               case OP_SELLLIMIT:
                  if (a_price_20 < l_bid_68 + l_stoplevel_96 * l_point_76) a_price_20 = l_bid_68 + l_stoplevel_96 * l_point_76;
                  if (a_price_28 > 0.0 && a_price_28 < a_price_20 + (l_stoplevel_96 + 1) * l_point_76) a_price_28 = a_price_20 + (l_stoplevel_96 + 1) * l_point_76;
                  if (a_price_36 > a_price_20 - (l_stoplevel_96 + 1) * l_point_76) a_price_36 = a_price_20 - (l_stoplevel_96 + 1) * l_point_76;
                  break;
               case OP_SELLSTOP:
                  if (a_price_20 > l_bid_68 - l_stoplevel_96 * l_point_76) a_price_20 = l_bid_68 - l_stoplevel_96 * l_point_76;
                  if (a_price_28 > 0.0 && a_price_28 < a_price_20 + (l_stoplevel_96 + 1) * l_point_76) a_price_28 = a_price_20 + (l_stoplevel_96 + 1) * l_point_76;
                  if (a_price_36 > a_price_20 - (l_stoplevel_96 + 1) * l_point_76) a_price_36 = a_price_20 - (l_stoplevel_96 + 1) * l_point_76;
               }
               Print("SetOrder(): The price levels are corrected");
            }
            Print("Error(", l_error_84, ") set order: ", ErrorDescription(l_error_84), ", try ", li_88);
            Print("Ask=", l_ask_60, "  Bid=", l_bid_68, "  sy=", a_symbol_0, "  ll=", ad_12, "  op=", GetNameOP(a_cmd_8), "  pp=", a_price_20, "  sl=", a_price_28, "  tp=", a_price_36, "  mn=", a_magic_44);
            if (l_ask_60 == 0.0 && l_bid_68 == 0.0) Message("SetOrder(): Check up in the review of the market presence of a symbol " + a_symbol_0);
            if (l_error_84 == 2/* COMMON_ERROR */ || l_error_84 == 64/* ACCOUNT_DISABLED */ || l_error_84 == 65/* INVALID_ACCOUNT */ || l_error_84 == 133/* TRADE_DISABLED */) {
               gi_280 = TRUE;
               return;
            }
            if (l_error_84 == 4/* SERVER_BUSY */ || l_error_84 == 131/* INVALID_TRADE_VOLUME */ || l_error_84 == 132/* MARKET_CLOSED */) {
               Sleep(300000);
               return;
            }
            if (l_error_84 == 8/* TOO_FREQUENT_REQUESTS */ || l_error_84 == 141/* TOO_MANY_REQUESTS */) Sleep(100000);
            if (l_error_84 == 139/* ORDER_LOCKED */ || l_error_84 == 140/* LONG_POSITIONS_ONLY_ALLOWED */ || l_error_84 == 148/* ERR_TRADE_TOO_MANY_ORDERS */) break;
            if (l_error_84 == 146/* TRADE_CONTEXT_BUSY */) while (IsTradeContextBusy()) Sleep(11000);
            if (l_error_84 == 147/* ERR_TRADE_EXPIRATION_DENIED */) a_datetime_48 = 0;
            else
               if (l_error_84 != 135/* PRICE_CHANGED */ && l_error_84 != 138/* REQUOTE */) Sleep(7700.0);
         }
      }
   }
}

bool ExistOrders(string as_0 = "", int a_cmd_8 = -1, int a_magic_12 = -1, int ai_16 = 0) {
   int l_cmd_28;
   int l_ord_total_24 = OrdersTotal();
   if (as_0 == "0") as_0 = Symbol();
   for (int l_pos_20 = 0; l_pos_20 < l_ord_total_24; l_pos_20++) {
      if (OrderSelect(l_pos_20, SELECT_BY_POS, MODE_TRADES)) {
         l_cmd_28 = OrderType();
         if (l_cmd_28 > OP_SELL && l_cmd_28 < 6) {
            if (OrderSymbol() == as_0 || as_0 == "" && a_cmd_8 < OP_BUY || l_cmd_28 == a_cmd_8) {
               if (a_magic_12 < 0 || OrderMagicNumber() == a_magic_12)
                  if (ai_16 <= OrderOpenTime()) return (TRUE);
            }
         }
      }
   }
   return (FALSE);
}

bool GetProPoint() {
   if (ObjectFind("ytg_str_561") < 0) return (FALSE);
   string ls_0 = ObjectDescription("ytg_str_561");
   // EDUCATED !!
   // if (ls_0 != ls_8) return (FALSE); // EDUCATED !!
   return (TRUE);
}

double PriceOpenLastPos(string as_0 = "", int a_cmd_8 = -1, int a_magic_12 = -1) {
   int l_datetime_16;
   double l_ord_open_price_20 = 0;
   int l_ord_total_32 = OrdersTotal();
   if (as_0 == "0") as_0 = Symbol();
   for (int l_pos_28 = 0; l_pos_28 < l_ord_total_32; l_pos_28++) {
      if (OrderSelect(l_pos_28, SELECT_BY_POS, MODE_TRADES)) {
         if (OrderSymbol() == as_0 || as_0 == "") {
            if (OrderType() == OP_BUY || OrderType() == OP_SELL) {
               if (a_cmd_8 < OP_BUY || OrderType() == a_cmd_8) {
                  if (a_magic_12 < 0 || OrderMagicNumber() == a_magic_12) {
                     if (l_datetime_16 < OrderOpenTime()) {
                        l_datetime_16 = OrderOpenTime();
                        l_ord_open_price_20 = OrderOpenPrice();
                     }
                  }
               }
            }
         }
      }
   }
   return (l_ord_open_price_20);
}

double GetLotLastPos(string as_0 = "", int a_cmd_8 = -1, int a_magic_12 = -1) {
   int l_datetime_16;
   double l_ord_lots_20 = -1;
   int l_ord_total_32 = OrdersTotal();
   if (as_0 == "0") as_0 = Symbol();
   for (int l_pos_28 = 0; l_pos_28 < l_ord_total_32; l_pos_28++) {
      if (OrderSelect(l_pos_28, SELECT_BY_POS, MODE_TRADES)) {
         if (OrderSymbol() == as_0 || as_0 == "") {
            if (OrderType() == OP_BUY || OrderType() == OP_SELL) {
               if (a_cmd_8 < OP_BUY || OrderType() == a_cmd_8) {
                  if (a_magic_12 < 0 || OrderMagicNumber() == a_magic_12) {
                     if (l_datetime_16 < OrderOpenTime()) {
                        l_datetime_16 = OrderOpenTime();
                        l_ord_lots_20 = OrderLots();
                     }
                  }
               }
            }
         }
      }
   }
   return (l_ord_lots_20);
}

int GetPont() {
   int l_digits_0 = Digits;
   int li_ret_4 = 1;
   if (l_digits_0 == 3 || l_digits_0 >= 5) li_ret_4 = 10;
   return (li_ret_4);
}

void GetYTG() {
   g_count_308++;
   if (g_count_308 > 2) g_count_308 = 0;
   int li_0 = 255;
   int li_4 = 65280;
   int li_8 = 16711680;
   if (g_count_308 == 1) {
      li_0 = 3937500;
      li_4 = 3329330;
      li_8 = 16748574;
   }
   if (g_count_308 == 2) {
      li_0 = 17919;
      li_4 = 2263842;
      li_8 = 14772545;
   }
   Label("ytg_Y", "Y", 3, 40, 20, 25, "Arial Black", li_0);
   Label("ytg_T", "T", 3, 25, 5, 25, "Arial Black", li_4);
   Label("ytg_G", "G", 3, 13, 32, 25, "Arial Black", li_8);
}