
#property copyright "Copyright � 2013"
#property link      "http://finans-plus.ru"

//#include <stdlib.mqh>
#import "stdlib.ex4"
   string ErrorDescription(int a0); // DA69CBAFF4D38B87377667EEC549DE5A
#import "aladdin_key.dll"
   string tbGetText(int a0, int a1);
   bool tbIsClicked(int a0, int a1);
   int tbPutObject(int a0, string a1, int a2, int a3, int a4, int a5, string a6);
   int tbSetBgColor(int a0, int a1, int a2);
   int tbRemoveAll(int a0);
#import

extern string EA_Name = "Aladdin 9 FX";
extern string Creator = "Copyright � 2013, Finans Plus Company";
int G_acc_number_92 = 3552225;
extern string Set = "����������� ���������";
extern string ald0 = "��������� ������";
bool Gi_112 = FALSE;
extern bool NewCycle_ON = TRUE;
extern bool TradeBuy = TRUE;
extern bool TradeSell = TRUE;
extern string ald1 = "������� ��� �������";
extern bool Close_All = FALSE;
extern string ald2 = "�����-����� ������";
extern int MagicNumber = 777;
extern string MagicNumList = "111 0 222";
extern string ald3 = "�� � ������ ��������";
extern double DefaultProfit = 10.0;
extern string ald4 = "��������� MM";
extern double Risk = 1.0;
extern string ald5 = "��������� �������";
extern int Bonus = 0;
extern double DefaultLot = 0.01;
extern double LotExponent = 2.0;
int Gi_220 = 40;
extern string ald6 = "������� �� �������";
extern int FixLotPercent = 30;
extern bool FixLot = FALSE;
extern string ald7 = "��������� ����������";
extern int Tral_Start = 2;
extern int Tral_Size = 13;
extern int PipStep = 30;
extern string ald8 = "��������� ����������";
extern int LeadingOrder = 4;
extern int ProfitPersent = 30;
int Gi_276 = 50;
extern string ald9 = "�����������";
extern int MaxTrades = 10;
extern double MaxLot = 1.0;
extern int CurrencySL = 0;
extern string ald10 = "��������� CCI";
extern int CCI_TimeFrame = 2;
extern int Level = 100;
extern int Period_CCI = 14;
extern double Sens = 0.0;
extern int PriceTip = 5;
extern string ald11 = "������� ������� �� ��";
extern int TipMAFilter = 2;
extern int Period_�� = 1000;
extern int Distance_�� = 350;
extern string ald12 = "������ �������";
extern bool UseFilterTime = FALSE;
extern bool UseFilterDate = FALSE;
extern int StartHourMonday = 7;
extern int EndHourFriday = 19;
extern int StartMonth = 1;
extern int EndMonth = 1;
string Gs_unused_388 = "��������� ����� � ������� ���������";
int Gi_396 = 55295;
int Gi_400 = 12632256;
int Gi_404 = 36095;
int Gi_408 = 16760576;
int Gi_412 = 300;
int Gi_unused_416 = 800;
int Gi_420 = 10;
extern string ald13 = "�������������� ���������";
extern bool Info = TRUE;
bool Gi_436 = FALSE;
extern int PauseTrade = 6;
extern string ald14 = " ������� ��������! ";
int Gia_452[10] = {0, 1, 5, 15, 30, 60, 240, 1440, 10080, 43200};
int Gia_456[10];
int Gi_460;
int Gi_464;
int G_ticket_468;
int G_ticket_472;
int G_ticket_476;
int G_index_484;
int Gi_488;
int G_count_492;
int G_count_496;
int G_spread_500;
int G_freezelevel_504;
int G_stoplevel_508;
int Gi_512;
int Gi_516;
int Gi_520;
int Gi_524;
int Gi_536;
int Gi_540;
int Gi_544;
int Gi_552;
int Gi_556;
int Gi_560;
int Gi_564;
double Gd_568;
double Gd_576;
double G_order_profit_584;
double G_order_profit_592;
double G_order_profit_600;
double Gd_616;
double Gd_624;
double Gd_632;
double Gd_640;
double Gd_648;
double Gd_656;
double Gd_664;
double G_str2dbl_672;
double Gd_680;
double Gd_688;
double G_minlot_696;
double Gd_704;
double Gd_712;
double Gd_720;
double G_tickvalue_728;
double Gd_736;
double Gd_744;
double Gd_752;
double Gd_760;
double G_marginrequired_768;
double G_lotstep_776;
double Gd_784;
double Gd_792;
double G_order_lots_800;
double G_order_lots_808;
double Gd_816;
double Gd_824;
string G_str_concat_832;
string G_str_concat_840;
bool Gi_848;
bool Gi_852;
bool Gi_856;
bool Gi_860;
bool Gi_864;
bool Gi_868;

// E37F0136AA3FFAF149B351F6A4C948E9
int init() {
   string Ls_4;
   f0_11();
   if (Bars < Period_��) {
      Print("!���������� ����� � �������!");
      Gi_868 = TRUE;
   }
   if ((!IsDllsAllowed()) || !IsLibrariesAllowed()) {
      Print("!��������� ������ DLL!��������� �������!");
      Gi_868 = TRUE;
   }
   if (AccountFreeMargin() < Bonus) {
      Print("!����� �� ����� ��������� ��������� ��������!");
      Gi_868 = TRUE;
   }
   if (AccountBalance() < Bonus) {
      Print("!����� �� ����� ��������� ������� ������!");
      Gi_868 = TRUE;
   }
   if (Gi_868) {
      Print("!������ ������������ ���������!");
      return (0);
   }
   G_tickvalue_728 = MarketInfo(Symbol(), MODE_TICKVALUE);
   G_minlot_696 = MarketInfo(Symbol(), MODE_MINLOT);
   Gd_704 = MarketInfo(Symbol(), MODE_MAXLOT);
   G_marginrequired_768 = MarketInfo(Symbol(), MODE_MARGINREQUIRED);
   G_lotstep_776 = MarketInfo(Symbol(), MODE_LOTSTEP);
   if (G_lotstep_776 >= 1.0) Gi_460 = 0;
   if (G_lotstep_776 >= 0.1) Gi_460 = 1;
   if (G_lotstep_776 >= 0.01) Gi_460 = 2;
   if (G_acc_number_92 > 0 && G_acc_number_92 != AccountNumber()) {
      NewCycle_ON = FALSE;
      TradeBuy = FALSE;
      TradeSell = FALSE;
      Comment("\n", "Aladdin 9 FX �� ����������� �� ������ �����. �������� �������� ��� ��� ���� �� http://finans-plus.ru/");
      return (0);
   }
   if (Gi_436) {
      Gi_544 = WindowHandle(Symbol(), Period());
      tbRemoveAll(Gi_544);
      Gi_524 = tbPutObject(Gi_544, "text", 77, -39, 70, 20, DoubleToStr(G_str2dbl_672, 2));
      Gi_512 = tbPutObject(Gi_544, "button", 149, -39, 70, 20, "Buy");
      Gi_516 = tbPutObject(Gi_544, "button", 5, -39, 70, 20, "Sell");
      Gi_520 = tbPutObject(Gi_544, "button", 221, -39, 90, 20, "������� ���");
      Gi_536 = tbPutObject(Gi_544, "button", 313, -39, 90, 20, "������� Sell");
      Gi_540 = tbPutObject(Gi_544, "button", 405, -39, 90, 20, "������� Buy");
      tbSetBgColor(Gi_544, Gi_520, 55295);
   }
   int Li_0 = MarketInfo(Symbol(), MODE_DIGITS);
   if (Li_0 == 5 || Li_0 == 3) {
      Tral_Start = 10 * Tral_Start;
      Tral_Size = 10 * Tral_Size;
      PipStep = 10 * PipStep;
      Distance_�� = 10 * Distance_��;
      Sens = 10.0 * Sens;
   }
   if (CCI_TimeFrame < 2 || CCI_TimeFrame > 4) CCI_TimeFrame = 2;
   if (DefaultProfit <= 0.0) DefaultProfit = 0.01;
   if (Gi_220 <= 0) Gi_220 = 1;
   if (DefaultLot <= 0.0) DefaultLot = 0.01;
   if (LeadingOrder <= 2) LeadingOrder = 2;
   if (Bid == 0.0 || Ask == 0.0) {
      Print(StringConcatenate("������������ ����. Ask: ", Ask, " Bid: ", Bid));
      return (0);
   }
   G_index_484 = 0;
   int str_len_12 = StringLen(MagicNumList);
   for (int Li_16 = 0; Li_16 < str_len_12; Li_16++) {
      if (StringSubstr(MagicNumList, Li_16, 1) != " ") {
         Ls_4 = Ls_4 + StringSubstr(MagicNumList, Li_16, 1);
         if (Li_16 < str_len_12 - 1) continue;
      }
      if (Ls_4 != "") {
         Gia_456[G_index_484] = StrToInteger(Ls_4);
         G_index_484++;
         Ls_4 = "";
      }
   }
   return (0);
}
	  				  			  		   			 			 		 				   	 		   	 		 		 		  	 				 			 	 		  	 	 		  			 	  		 	 	     			 	      				 			   		 	 					  	 	 		 	  	 
// 52D46093050F38C27267BCE42543EF60
int deinit() {
   f0_11();
   tbRemoveAll(WindowHandle(Symbol(), Period()));
   return (0);
}
		 				   		  		 	 			 		  		 			    	 			  	 		  	 		  						 		  	 		    	 		   		 	  	  	 	   	 			 	 	    			  			    	 	 			 	  	 	  	 	  	 
// EA2B2676C28C0DB26D39331A336C6B92
int start() {
   double Ld_12;
   bool Li_20;
   bool Li_24;
   double Ld_28;
   double Ld_36;
   f0_5();
   Gd_744 = NormalizeDouble(AccountFreeMargin() - Bonus, 2);
   Gd_752 = NormalizeDouble(AccountBalance() - Bonus, 2);
   Gd_760 = NormalizeDouble(AccountEquity(), 2);
   G_spread_500 = MarketInfo(Symbol(), MODE_SPREAD);
   G_freezelevel_504 = MarketInfo(Symbol(), MODE_FREEZELEVEL);
   G_stoplevel_508 = MarketInfo(Symbol(), MODE_STOPLEVEL);
   Gd_664 = f0_8();
   if (Gd_688 == 0.0) Gd_688 = 0.00000001;
   if (Gd_744 < 0.0 || Gd_752 < 0.0) return (0);
   if (LeadingOrder >= 2) f0_14();
   if (Gd_680 > 0.0) Gi_552 = 1;
   if (Gd_680 < 0.0) Gi_552 = -1;
   if (Gd_680 == 0.0) Gi_552 = 0;
   int Li_0 = G_spread_500 + G_freezelevel_504 + G_stoplevel_508;
   if (PipStep <= Li_0) PipStep = Li_0;
   if (Tral_Start <= Li_0) Tral_Start = Li_0;
   if (f0_1() && Gi_436) {
      if (tbGetText(Gi_544, Gi_524) != "") G_str2dbl_672 = StrToDouble(tbGetText(Gi_544, Gi_524));
      if (tbIsClicked(Gi_544, Gi_512)) {
         G_str_concat_832 = StringConcatenate("Aladdin 9 FX - ������ �������, ", "Magic : ", MagicNumber);
         f0_6(OP_BUY, G_str2dbl_672, 0, 0, 0, G_str_concat_832, MagicNumber);
      }
      if (tbIsClicked(Gi_544, Gi_516)) {
         G_str_concat_832 = StringConcatenate("Aladdin 9 FX - ������ �������, ", "Magic : ", MagicNumber);
         f0_6(OP_SELL, G_str2dbl_672, 0, 0, 0, G_str_concat_832, MagicNumber);
      }
      if (tbIsClicked(Gi_544, Gi_520)) f0_7(MagicNumber);
      if (tbIsClicked(Gi_544, Gi_536)) f0_7(MagicNumber, OP_SELL);
      if (tbIsClicked(Gi_544, Gi_540)) f0_7(MagicNumber, OP_BUY);
   }
   if (Gd_640 < 0.0 && CurrencySL != 0) {
      if (MathAbs(Gd_640) >= CurrencySL) {
         if (Info) Print("�������� ��������� �������� �������");
         Gi_860 = TRUE;
      }
   }
   if (Gi_488 == 0) {
      Gi_856 = FALSE;
      Close_All = FALSE;
   }
   if (Close_All || Gi_856 || Gi_860) {
      f0_9();
      f0_3("ICloseAll", 2, 10, 150, "�������� �������", Gi_420, "Times New Roman", Gi_396);
      f0_11();
      Gi_860 = FALSE;
      if (!(Info && Close_All)) return (0);
      Print("������� ��� �������");
      return (0);
   }
   if (Gd_616 <= FixLotPercent) Gi_864 = FALSE;
   else Gi_864 = TRUE;
   if (FixLot) Gi_864 = TRUE;
   if (Risk != 0.0) Gd_632 = NormalizeDouble(Gd_664 * DefaultProfit / G_minlot_696, 2);
   else Gd_632 = DefaultProfit;
   if (Gd_640 > Gd_632 + Tral_Start * G_tickvalue_728 * Gd_688 && (!Gi_848)) {
      Gi_848 = TRUE;
      Gi_564 = Gi_404;
      Gi_560 = Gi_408;
   }
   if (!Gi_848 && Gi_488 > 0) {
      Gi_564 = Gi_400;
      Gi_560 = Gi_408;
      Gd_712 = (Gd_632 - Gd_640) / G_tickvalue_728 / Gd_688;
      Gd_720 = Gd_640 / G_tickvalue_728 / Gd_688;
      switch (Gi_552) {
      case 1:
         Gd_568 = NormalizeDouble(Bid + (Gd_712 + Tral_Start) * Point, Digits);
         Gd_576 = NormalizeDouble(Bid - Gd_720 * Point, Digits);
         break;
      case -1:
         Gd_568 = NormalizeDouble(Ask - (Gd_712 + Tral_Start) * Point, Digits);
         Gd_576 = NormalizeDouble(Ask + Gd_720 * Point, Digits);
      }
   }
   if (!(Gi_488 == 0)) {
      if ((!IsTesting()) || IsVisualMode() || (!IsOptimization())) {
         f0_22("ILineTP", Gd_568, Gi_564, 2);
         f0_22("ILineZL", Gd_576, Gi_560, 0);
         f0_19("ItxtTP", "������� ��", Gd_568, Gi_564);
         f0_19("Itxt��", "������� ��", Gd_576, Gi_560);
      } else {
         ObjectDelete("ILineTP");
         ObjectDelete("ILineZL");
         ObjectDelete("ItxtTP");
         ObjectDelete("Itxt��");
      }
   }
   if (Gd_680 != 0.0 && Gi_848 == TRUE) {
      switch (Gi_552) {
      case 1:
         if (Bid <= NormalizeDouble(Gd_568, Digits)) {
            if (Info) Print("������� ����� �� �������� Buy SL");
            Gi_856 = TRUE;
         } else {
            if (Gd_568 >= Bid - Tral_Size * Point) break;
            Gd_568 = NormalizeDouble(Bid - Tral_Size * Point, Digits);
         }
         break;
      case -1:
         if (Ask >= NormalizeDouble(Gd_568, Digits)) {
            if (Info) Print("������� ����� �� �������� Sell SL");
            Gi_856 = TRUE;
         } else {
            if (Gd_568 <= Ask + Tral_Size * Point) break;
            Gd_568 = NormalizeDouble(Ask + Tral_Size * Point, Digits);
         }
      }
   }
   if ((!IsTesting()) || IsVisualMode() || (!IsOptimization())) {
      if (Info) {
         f0_12();
         if (Sens == 0.0) f0_2(Level);
      }
   }
   if ((!Gi_112) && NewCycle_ON && f0_1() && (!Close_All) && (!Gi_852)) {
      Li_20 = FALSE;
      Li_24 = FALSE;
      if (TradeBuy && G_count_492 == 0) {
         if (Li_20 == FALSE) {
            if (f0_10() == 1 || (!(TipMAFilter == 1))) {
               if ((!(f0_13() == 1)) || !(TipMAFilter == 2)) {
                  if (f0_4() == 1) {
                     f0_11();
                     Ld_12 = NormalizeDouble(Gd_664, Gi_460);
                     if (Info) Print("������� �� �������� ������� BUY");
                     G_str_concat_832 = StringConcatenate("1-� ����� Buy, ", "Magic : ", MagicNumber);
                     Li_20 = f0_6(OP_BUY, Ld_12, 0, 0, MagicNumber, G_str_concat_832, Gi_464);
                     if ((!IsTesting()) || IsVisualMode() || (!IsOptimization())) {
                        if (Info) PlaySound("alert.wav");
                        Sleep(1000);
                     }
                  }
               }
            }
         }
      }
      if (TradeSell && G_count_496 == 0) {
         if (Li_24 == FALSE) {
            if (f0_10() == -1 || (!(TipMAFilter == 1))) {
               if ((!(f0_13() == -1)) || !(TipMAFilter == 2)) {
                  if (f0_4() == -1) {
                     f0_11();
                     Ld_12 = NormalizeDouble(Gd_664, Gi_460);
                     if (Info) Print("������� �� �������� ������� SELL");
                     G_str_concat_832 = StringConcatenate("1-� ����� Sell, ", "Magic : ", MagicNumber);
                     Li_24 = f0_6(OP_SELL, Ld_12, 0, 0, MagicNumber, G_str_concat_832, Gi_464);
                     if ((!IsTesting()) || IsVisualMode() || (!IsOptimization())) {
                        if (Info) PlaySound("alert.wav");
                        Sleep(1000);
                     }
                  }
               }
            }
         }
      }
   }
   if (f0_1() && (!Close_All) && (!Gi_852)) {
      ObjectDelete("InewLot");
      if (TradeBuy && G_count_492 > 0 && G_count_492 <= MaxTrades) {
         if (Ask < Gd_816 - PipStep * Point) {
            Ld_28 = f0_20(1);
            Ld_36 = AccountFreeMarginCheck(Symbol(), OP_BUY, Ld_28);
            if (Info) {
               f0_3("InewLot", 3, 10, 115, StringConcatenate("������� �����: Buy ", DoubleToStr(Ld_28, Gi_460), " / ", "�c������� : $", DoubleToStr(Ld_36, 0)), Gi_420, "Times New Roman",
                  Gi_396);
            }
            if (Ld_36 <= 0.0) return;
            if (f0_10() == 1 || (!(TipMAFilter == 1))) {
               if ((!(f0_13() == 1)) || !(TipMAFilter == 2)) {
                  if (f0_4() == 1) {
                     if (Info) Print("������� ����������� �� �������� ������ - BUY");
                     G_str_concat_832 = StringConcatenate(G_count_492 + 1, "-� ����� Buy, ", "Magic : ", MagicNumber);
                     Li_20 = f0_6(OP_BUY, Ld_28, 0, 0, MagicNumber, G_str_concat_832, Gi_464);
                     if ((!IsTesting()) || IsVisualMode() || (!IsOptimization())) {
                        if (Info) PlaySound("alert.wav");
                        Sleep(1000);
                     }
                  }
               }
            }
         }
      }
      if (TradeSell && G_count_496 > 0 && G_count_496 <= MaxTrades) {
         if (Bid > Gd_824 + PipStep * Point) {
            Ld_28 = f0_20(2);
            Ld_36 = AccountFreeMarginCheck(Symbol(), OP_SELL, Ld_28);
            if (Info) {
               f0_3("InewLot", 3, 10, 115, StringConcatenate("������� �����: Sell ", DoubleToStr(Ld_28, Gi_460), " / ", "�c������� : $", DoubleToStr(Ld_36, 0)), Gi_420, "Times New Roman",
                  Gi_396);
            }
            if (Ld_36 <= 0.0) return;
            if (f0_10() == -1 || (!(TipMAFilter == 1))) {
               if ((!(f0_13() == -1)) || !(TipMAFilter == 2)) {
                  if (f0_4() == -1) {
                     if (Info) Print("������� ����������� �� �������� ������ - SELL");
                     G_str_concat_832 = StringConcatenate(G_count_496 + 1, "-� ����� Sell, ", "Magic : ", MagicNumber);
                     Li_24 = f0_6(OP_SELL, Ld_28, 0, 0, MagicNumber, G_str_concat_832, Gi_464);
                     if ((!IsTesting()) || IsVisualMode() || (!IsOptimization())) {
                        if (Info) PlaySound("alert.wav");
                        Sleep(1000);
                     }
                  }
               }
            }
         }
      }
   }
   return (0);
}
	  		 		 			 		    		   		 				 		      	   			  		 	  		 			   		 	  		 	 	  		 			   			 	   	   		        		 		 		  	 		 			 			      		 		   
// C6EFD723DE0B274929D4473DA802919B
int f0_18() {
   for (int index_0 = 0; index_0 < G_index_484; index_0++)
      if (OrderMagicNumber() == Gia_456[index_0]) return (1);
   return (0);
}
	 		 			 	 		 	   		 	  				  	 			 		  	 	   	  	   	 		  	 	  								 							 	 			 							 	  		 	    	 	 	 				 	 	 	    	 		  		   	       
// 5D60C8D17C876040F63DDE1301EC28B9
int f0_10() {
   int Li_ret_0;
   double ima_4;
   int Li_12;
   double Ld_16;
   double Ld_24;
   if (TipMAFilter == 1) {
      Li_ret_0 = 0;
      ima_4 = iMA(Symbol(), PERIOD_H1, Period_��, 0, MODE_SMMA, PRICE_CLOSE, 1);
      Li_12 = MathAbs(ima_4 - Bid) / Point;
      if (Li_12 > Distance_�� && Bid > ima_4) Li_ret_0 = -1;
      if (Li_12 > Distance_�� && Bid < ima_4) Li_ret_0 = 1;
      Ld_16 = ima_4 - Distance_�� * Point;
      Ld_24 = ima_4 + Distance_�� * Point;
      if ((!IsTesting()) || IsVisualMode() || (!IsOptimization())) {
         f0_22("ILevelNoBuy  ", Ld_16, RoyalBlue, 3);
         f0_22("ILevelNoSell ", Ld_24, Crimson, 3);
         f0_19("ItxtLevelBuy ", "Filter s - ������ Buy", Ld_16, RoyalBlue);
         f0_19("ItxtLevelSell", "Filter s - ������ Sell", Ld_24, Crimson);
      }
   }
   return (Li_ret_0);
}
			  	 		   	   			  		   	       					  			    	  	 			 	   		   	 		 		 	 		 		   				  	 							  		 					     	  				  	       				 	  	  	 	
// 6AAEB1989A9BE9F33AA19EDD1D50A677
int f0_13() {
   int Li_ret_0;
   double ima_4;
   int Li_12;
   double Ld_16;
   double Ld_24;
   if (TipMAFilter == 2) {
      Li_ret_0 = 0;
      ima_4 = iMA(Symbol(), PERIOD_H1, Period_��, 0, MODE_SMMA, PRICE_CLOSE, 1);
      Li_12 = MathAbs(ima_4 - Bid) / Point;
      Ld_16 = ima_4 + Distance_�� * Point;
      Ld_24 = ima_4 - Distance_�� * Point;
      if (Li_12 > Distance_��) {
         if (Bid > ima_4) Li_ret_0 = 1;
         if (Bid < ima_4) Li_ret_0 = -1;
      }
      if ((!IsTesting()) || IsVisualMode() || (!IsOptimization())) {
         f0_22("ILevelNoBuy  ", Ld_16, RoyalBlue, 3);
         f0_22("ILevelNoSell ", Ld_24, Crimson, 3);
         f0_19("ItxtLevelBuy ", "Filter K - ������ Buy", Ld_16, RoyalBlue);
         f0_19("ItxtLevelSell", "Filter K - ������ Sell", Ld_24, Crimson);
      }
   }
   return (Li_ret_0);
}
					 	 	  	 								  	  						  	    	 		 					   	    	 		  	  		  	 	 		  	 	  	      		    					  				  			  			   	   				       		   		 		
// 1DB03562B34ED11E644D60A77F290E8C
int f0_4() {
   double Ld_20;
   double Ld_28;
   double Ld_36;
   int Li_ret_0 = 0;
   double iclose_4 = iClose(Symbol(), Gia_452[CCI_TimeFrame + 1], 0);
   double iclose_12 = iClose(Symbol(), Gia_452[CCI_TimeFrame + 1], 2);
   if (Sens == 0.0) {
      Ld_20 = iCCI(NULL, Gia_452[CCI_TimeFrame], Period_CCI, PRICE_CLOSE, 0);
      Ld_28 = iCCI(NULL, Gia_452[CCI_TimeFrame], Period_CCI, PRICE_CLOSE, 1);
      Ld_36 = iCCI(NULL, Gia_452[CCI_TimeFrame], Period_CCI, PRICE_CLOSE, 3);
   } else {
      Ld_20 = iCustom(NULL, Gia_452[CCI_TimeFrame], "iCCI.NR", Period_CCI, PriceTip, Sens, 0, 0);
      Ld_28 = iCustom(NULL, Gia_452[CCI_TimeFrame], "iCCI.NR", Period_CCI, PriceTip, Sens, 0, 1);
      Ld_36 = iCustom(NULL, Gia_452[CCI_TimeFrame], "iCCI.NR", Period_CCI, PriceTip, Sens, 0, 3);
   }
   if (Ld_20 > (-Level) && Ld_28 < (-Level) && Ld_20 > Ld_36 && iclose_12 > iclose_4) Li_ret_0 = 1;
   if (Ld_20 < Level && Ld_28 > Level && Ld_20 < Ld_36 && iclose_12 < iclose_4) Li_ret_0 = -1;
   return (Li_ret_0);
}
		 		  	  		 	   	 		 	 	  			  	     	 		  		    	 	 							 	 	  	   	   	   	  		  			  	  		 	 		 	  	   	  	  		 		  	 		  	 	   	   	 			  
// 36110F224590ECF5A8915094C3EA7EE7
void f0_5() {
   Gi_488 = 0;
   G_count_492 = 0;
   G_count_496 = 0;
   Gd_640 = 0;
   Gd_616 = 0;
   Gd_784 = 0;
   Gd_792 = 0;
   Gd_648 = 0;
   Gd_656 = 0;
   Gd_816 = 0;
   Gd_824 = 0;
   for (int pos_0 = 0; pos_0 < OrdersTotal(); pos_0++) {
      if (OrderSelect(pos_0, SELECT_BY_POS, MODE_TRADES)) {
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber || f0_18()) {
            if (OrderType() == OP_SELL || OrderType() == OP_BUY) {
               switch (OrderType()) {
               case OP_BUY:
                  G_count_492++;
                  Gd_648 += OrderLots();
                  G_order_lots_800 = OrderLots();
                  Gd_816 = NormalizeDouble(OrderOpenPrice(), Digits);
                  Gd_784 += NormalizeDouble(OrderProfit() + OrderSwap() + OrderCommission(), 2);
                  break;
               case OP_SELL:
                  G_count_496++;
                  Gd_656 += OrderLots();
                  G_order_lots_808 = OrderLots();
                  Gd_824 = NormalizeDouble(OrderOpenPrice(), Digits);
                  Gd_792 += NormalizeDouble(OrderProfit() + OrderSwap() + OrderCommission(), 2);
               }
               break;
            default:
               return;
            }
            Gi_488 = G_count_492 + G_count_496;
            Gd_640 += OrderProfit() + OrderSwap() + OrderCommission();
            Gd_616 = NormalizeDouble(MathMax(100.0 * ((AccountBalance() + AccountCredit() - AccountEquity()) / (AccountBalance() + AccountCredit())), 0), 2);
            Gd_680 = NormalizeDouble(Gd_648 - Gd_656, Gi_460);
            Gd_688 = NormalizeDouble(MathAbs(Gd_680), Gi_460);
            if (AccountMargin() > 0.0) Gd_624 = NormalizeDouble(100.0 * (AccountEquity() / AccountMargin()), 0);
         }
      }
   }
}
	 	  		  	  	 		  	  	 				   								 		 		  		 	 	 	  	    	 				 			  		 			  	  		  			 		    	  	 	  			 					  	   	 	  				 			 	 	 	   	 
// FE9FDF03050549621ADDC68655045DD1
void f0_21() {
   int ticket_0 = 0;
   double Ld_unused_4 = 0;
   double order_profit_12 = 0;
   for (int pos_20 = 0; pos_20 < OrdersTotal(); pos_20++) {
      if (OrderSelect(pos_20, SELECT_BY_POS, MODE_TRADES)) {
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber || f0_18()) {
            if (OrderType() == OP_SELL || OrderType() == OP_BUY) {
               order_profit_12 = OrderProfit();
               ticket_0 = OrderTicket();
               if (order_profit_12 > 0.0 && order_profit_12 > G_order_profit_592) {
                  G_order_profit_600 = G_order_profit_592;
                  G_ticket_472 = G_ticket_468;
                  G_order_profit_592 = order_profit_12;
                  G_ticket_468 = ticket_0;
               }
               if (order_profit_12 < 0.0 && order_profit_12 < G_order_profit_584) {
                  G_order_profit_584 = order_profit_12;
                  G_ticket_476 = ticket_0;
               }
            }
         }
      }
   }
}
		 		     		 	 	 	 		 			  			 		     				  		 	  	 	 	 					 			  	       	      		  	 	  	  	  	 		 		 	   	 		  		 	   	 		 		 	   		  	 				 
// E22AEE74FEDC5B53CC5722692844859F
double f0_20(int Ai_0) {
   double Ld_ret_4;
   double Ld_12;
   switch (Ai_0) {
   case 1:
      if (!Gi_864) Ld_12 = MathAbs((Gd_816 - Ask) / Point / PipStep);
      else Ld_12 = 1;
      Ld_ret_4 = NormalizeDouble(G_order_lots_800 * LotExponent * Ld_12, Gi_460);
      break;
   case 2:
      if (!Gi_864) Ld_12 = MathAbs((Bid - Gd_824) / Point / PipStep);
      else Ld_12 = 1;
      Ld_ret_4 = NormalizeDouble(G_order_lots_808 * LotExponent * Ld_12, Gi_460);
   }
   if (MaxLot != 0.0)
      if (Ld_ret_4 > MaxLot) Ld_ret_4 = NormalizeDouble(MaxLot, Gi_460);
   if (Ld_ret_4 < G_minlot_696) Ld_ret_4 = G_minlot_696;
   return (Ld_ret_4);
}
	 			  			 	 	  	 			 	  					   		   	   	 		  		  	 		   		 	  			   					   			 	  		 			  			 			 	 	 	  	   				 				  		   	    	 		  			 	
// 4CA46AAB119D6115222154B9DE991BEE
double f0_8() {
   double Ld_ret_0 = 0;
   if (Risk != 0.0) Ld_ret_0 = MathAbs(Gd_744 * Risk / 3200.0 / G_marginrequired_768 / G_lotstep_776) * G_lotstep_776;
   else Ld_ret_0 = MathMax(DefaultLot, G_minlot_696);
   if (Ld_ret_0 < G_minlot_696) Ld_ret_0 = G_minlot_696;
   if (MaxLot != 0.0) Ld_ret_0 = MathMin(MaxLot, Ld_ret_0);
   if (Ld_ret_0 * G_marginrequired_768 > Gd_744) {
      if ((!IsTesting()) || IsVisualMode() || (!IsOptimization())) f0_3("INoMoney", 2, Gi_412, 40, "������������ �������!!!", Gi_420 + 5, "Courier", Red);
      else {
         f0_3("INoMoney", 2, Gi_412, 40, "�� ����� ������������ �������!!! �������� �����������!!!", Gi_420 + 5, "Courier", Red);
         Gi_852 = TRUE;
      }
      return (0);
   }
   ObjectDelete("INoMoney");
   return (Ld_ret_0);
}
	 					  	 	  		  				 						 					  	 		 	 	 		 	  		  	  			 					 		  			 		  	 	 	  				 	    				 	  	   								   	  	 				   	 	 	  	  	 
// 07CC694B9B3FC636710FA08B6922C42B
int f0_1() {
   bool Li_ret_0 = FALSE;
   if ((Hour() < StartHourMonday && DayOfWeek() == 1) || (Hour() >= EndHourFriday && DayOfWeek() == 5) && UseFilterTime) Li_ret_0 = FALSE;
   else Li_ret_0 = TRUE;
   if (Day() < StartMonth + 1 || (Day() < 7 && Month() == 1) && UseFilterDate) Li_ret_0 = FALSE;
   else Li_ret_0 = TRUE;
   if (Day() > 31 - EndMonth || (Day() > 28 - EndMonth && Month() == 2) || (Day() > 30 - EndMonth && Month() == 4 || Month() == 6 || Month() == 9 || Month() == 11) &&
      UseFilterDate) Li_ret_0 = FALSE;
   else Li_ret_0 = TRUE;
   return (Li_ret_0);
}
		 		 			 		 		 		 		      				          	  			 	 	 	  	 				      	  			  	  			 		   	   	   			 		   		   		    		  		 	 			   	     	 	 		  	
// 3CC94C06370D2627C52A1F5EBCAEC673
int f0_6(int A_cmd_0, double A_lots_4, int Ai_12, int Ai_16, int A_magic_20, string A_comment_24, int A_error_32) {
   double price_36;
   double price_44;
   double price_52;
   int ticket_60;
   int slippage_64;
   color color_68;
   int error_72;
   string Ls_84;
   bool Li_76 = FALSE;
   if (Info) Print("������� �������� �������");
   if (!IsStopped()) {
      if (!IsTesting()) {
         if (!IsExpertEnabled()) {
            A_error_32 = 133;
            Print("�������� ��������� ���������! ������ \"���������\" ������.");
            return (-1);
         }
         if (Info) Print("�������� ��������� ���������");
         if (!IsConnected()) {
            A_error_32 = 6;
            Print("����� �����������!");
            return (-1);
         }
         if (Info) Print("����� � �������� �����������");
         if (IsTradeContextBusy()) {
            Print("�������� ����� �����!");
            Print(StringConcatenate("������� ", PauseTrade, " cek"));
            Sleep(1000 * PauseTrade);
            Li_76 = TRUE;
//???/*empty:20056:(@)*/
         }
         if (Info) Print("�������� ����� ��������");
         if (Li_76) {
            if (Info) Print("��������� ���������");
            RefreshRates();
            Li_76 = FALSE;
         } else
            if (Info) Print("��������� ���������");
      }
      switch (A_cmd_0) {
      case OP_BUY:
         price_36 = NormalizeDouble(Ask, Digits);
         price_44 = f0_15(Ai_12 == 0, 0, NormalizeDouble(Ask + Ai_12 * Point, Digits));
         price_52 = f0_15(Ai_16 == 0, 0, NormalizeDouble(Ask - Ai_16 * Point, Digits));
         color_68 = Blue;
         break;
      case OP_SELL:
         price_36 = NormalizeDouble(Bid, Digits);
         price_44 = f0_15(Ai_12 == 0, 0, NormalizeDouble(Bid - Ai_12 * Point, Digits));
         price_52 = f0_15(Ai_16 == 0, 0, NormalizeDouble(Bid + Ai_16 * Point, Digits));
         color_68 = Red;
         break;
      default:
         Print("!��� ������ �� ������������� �����������!");
         return (-1);
      }
      Ls_84 = f0_16(A_cmd_0);
      slippage_64 = 2.0 * MarketInfo(Symbol(), MODE_SPREAD);
      if (Info) Print(StringConcatenate("�����: ", Ls_84, " / ", " ����=", price_36, " / ", "Lot=", A_lots_4, " / ", "Slip=", slippage_64, " pip", " / ", A_comment_24));
      if (IsTradeAllowed()) {
         if (Info) Print(">>>>>�������� ���������, ���������� ����� >>>>>");
         ticket_60 = OrderSend(Symbol(), A_cmd_0, A_lots_4, price_36, slippage_64, price_52, price_44, A_comment_24, A_magic_20, 0, color_68);
         if (ticket_60 < 0) {
            error_72 = GetLastError();
            if (error_72 == 4/* SERVER_BUSY */ || error_72 == 129/* INVALID_PRICE */ || error_72 == 130/* INVALID_STOPS */ || error_72 == 135/* PRICE_CHANGED */ || error_72 == 137/* BROKER_BUSY */ ||
               error_72 == 138/* REQUOTE */ || error_72 == 146/* TRADE_CONTEXT_BUSY */ || error_72 == 136/* OFF_QUOTES */) {
               if (!IsTesting()) {
                  Print(StringConcatenate("������(OrderSend - ", error_72, "): ", ErrorDescription(error_72), ")"));
                  Print(StringConcatenate("������� ", PauseTrade, " cek"));
                  Sleep(1000 * PauseTrade);
                  Li_76 = TRUE;
//???/*empty:22244:(@)*/
               }
            }
            Print(StringConcatenate("����������� ������(OrderSend - ", error_72, "): ", ErrorDescription(error_72), ")"));
            A_error_32 = error_72;
         }
      } else
         if (Info) Print("�������� ��������� ���������! ����� ����� � ��������� ��������.");
   }
   if (ticket_60 > 0) {
      if (Info) Print(StringConcatenate("����� ��������� �������. ����� = ", ticket_60));
      else
         if (Info) Print(StringConcatenate("������! ����� �� ���������. (��� ������ = ", A_error_32, ": ", ErrorDescription(A_error_32), ")"));
   }
   return (ticket_60);
}
			 		 		       			 			   	 	     		 		  				   	  					 	  			   	  	 		 	  	 		    			  	  						 			 				      	 					  		      	 		 	  		 	 	
// B0E6010D5C8149E42AF8526F0710FF50
double f0_15(bool Ai_0, double Ad_4, double Ad_12) {
   if (Ai_0) return (Ad_4);
   return (Ad_12);
}
		   	 		 	 	   		   		            				  	 	    	 		 			 		  		     		 		   		 		 	 				    						   		 		 		        				 		      					 	 		  	 	
// 53BB9515C362D5BE7CC2D9AEB44F468A
void f0_9() {
   double price_4;
   color color_12;
   int error_16;
   int slippage_28;
   bool Li_0 = FALSE;
   if (Info) Print("������� �������� �������");
   if (!IsTesting()) {
      if (!IsExpertEnabled()) {
         Gi_464 = 133;
         Print("�������� ��������� ���������!");
         return;
      }
      if (Info) Print("�������� ��������� ���������");
      if (!IsConnected()) {
         Gi_464 = 6;
         Print("����� �����������!");
         return;
      }
   }
   if (!IsTesting())
      if (Info) Print("����� � �������� �����������");
   for (int pos_20 = OrdersTotal() - 1; pos_20 >= 0; pos_20--) {
      if (OrderSelect(pos_20, SELECT_BY_POS, MODE_TRADES)) {
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber || f0_18()) {
            if (Info) Print("��������� ����� #", OrderTicket());
            if (!IsStopped()) {
               if (IsTradeContextBusy()) {
                  Print("�������� ����� �����!");
                  Print(StringConcatenate("������� ", PauseTrade, " cek"));
                  Sleep(1000 * PauseTrade);
                  Li_0 = TRUE;
//???/*empty:23636:(@)*/
               }
               if (!IsTesting())
                  if (Info) Print("�������� ����� ��������");
               if (Li_0) {
                  if (Info) Print("��������� ���������");
                  RefreshRates();
                  Li_0 = FALSE;
               }
               switch (OrderType()) {
               case OP_BUY:
                  price_4 = NormalizeDouble(Bid, Digits);
                  color_12 = Blue;
                  break;
               case OP_SELL:
                  price_4 = NormalizeDouble(Ask, Digits);
                  color_12 = Red;
               }
               slippage_28 = 2.0 * MarketInfo(Symbol(), MODE_SPREAD);
               if (Info) Print(StringConcatenate("���� ��������=", price_4, " / ", "Slip = ", slippage_28, " pip"));
               if (!IsTradeAllowed()) {
                  Print("�������� ��������� ���������, ����� ����� � ��������� ��������!");
                  return;
               }
               if (!OrderClose(OrderTicket(), OrderLots(), price_4, slippage_28, color_12)) {
                  error_16 = GetLastError();
                  if (error_16 == 4/* SERVER_BUSY */ || error_16 == 129/* INVALID_PRICE */ || error_16 == 130/* INVALID_STOPS */ || error_16 == 135/* PRICE_CHANGED */ || error_16 == 137/* BROKER_BUSY */ ||
                     error_16 == 138/* REQUOTE */ || error_16 == 146/* TRADE_CONTEXT_BUSY */ || error_16 == 136/* OFF_QUOTES */) {
                     Print(StringConcatenate("������(OrderClose - ", error_16, "): ", ErrorDescription(error_16), ")"));
                     Print(StringConcatenate("������� ", PauseTrade, " cek"));
                     Sleep(1000 * PauseTrade);
                     Li_0 = TRUE;
//???/*empty:24836:(@)*/
                  }
                  Print(StringConcatenate("����������� ������(OrderClose - ", error_16, "): ", ErrorDescription(error_16), ")"));
               }
            }
            Sleep(100);
         }
      }
   }
   if (Info) Print("����� ������� �������� �������.");
}
	 	 	   		   	 		 	 	 		 		 		 	 			  		  				 			 		 	     	 		 		     			     		    	  		   	 	 	 	 			 		 	 	 		 	 	 		 			 	 	 	  				 						
// 9DC69C81EE6424C3E21968B2D0383256
void f0_14() {
   G_ticket_468 = 0;
   G_ticket_476 = 0;
   G_order_profit_592 = 0;
   G_order_profit_584 = 0;
   f0_21();
   if (G_count_492 >= LeadingOrder || G_count_496 >= LeadingOrder) {
      if (G_order_profit_592 > 0.0 && G_order_profit_600 <= 0.0 && G_order_profit_584 < 0.0) {
         if (!(G_order_profit_592 + G_order_profit_584 > 0.0 && 100.0 * (G_order_profit_592 + G_order_profit_584) / G_order_profit_592 > ProfitPersent)) return;
         G_ticket_472 = 0;
         f0_17();
         return;
      }
      if (G_order_profit_592 > 0.0 && G_order_profit_600 > 0.0 && G_count_492 > LeadingOrder || G_count_496 > LeadingOrder && G_order_profit_584 < 0.0) {
         if (G_order_profit_592 + G_order_profit_600 + G_order_profit_584 > 0.0 && 100.0 * (G_order_profit_592 + G_order_profit_600 + G_order_profit_584) / (G_order_profit_592 +
            G_order_profit_600) > Gi_276) f0_17();
      }
   }
}
	 				   	 	   	  											  				  				 	 	  	 	  			 	  									 	   			 	   	 	 		 				 		   						  	    								  	  	  			   			 	  	 		 
// C1C0E03DB818979A36F9A3FCFD58FC7E
void f0_17() {
   bool bool_16;
   if (Info) Print("������� ���������� �������.");
   bool is_closed_0 = FALSE;
   bool is_closed_4 = FALSE;
   bool is_closed_8 = FALSE;
   int slippage_12 = 2.0 * MarketInfo(Symbol(), MODE_SPREAD);
   while (is_closed_4 == 0) {
      RefreshRates();
      bool_16 = OrderSelect(G_ticket_468, SELECT_BY_TICKET, MODE_TRADES);
      if (bool_16 != TRUE) {
         Print("������! ���������� ������� ����� � ���������� ��������. ���������� ���������� ��������.");
         return;
      }
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber || f0_18()) {
         switch (OrderType()) {
         case OP_BUY:
            is_closed_4 = OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Bid, Digits), slippage_12, Blue);
            break;
         case OP_SELL:
            is_closed_4 = OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Ask, Digits), slippage_12, Red);
         }
         if (is_closed_4 == 1) {
            if (Info) Print("���������� ����� ������ �������");
            Sleep(500);
            continue;
         }
         Print("������ �������� ����������� ������, ��������� ��������.");
      }
   }
   if (G_ticket_472 != 0) {
      while (is_closed_8 == 0) {
         RefreshRates();
         bool_16 = OrderSelect(G_ticket_472, SELECT_BY_TICKET, MODE_TRADES);
         if (bool_16 != TRUE) {
            Print("������! ���������� ������� ���� ����� � ���������� ��������. ���������� ���������� ��������.");
            return;
         }
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber || f0_18()) {
            switch (OrderType()) {
            case OP_BUY:
               is_closed_8 = OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Bid, Digits), slippage_12, Blue);
               break;
            case OP_SELL:
               is_closed_8 = OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Ask, Digits), slippage_12, Red);
            }
            if (is_closed_8 == 1) {
               if (Info) Print("���� ���������� ����� ������ �������");
               Sleep(500);
               continue;
            }
            Print("������ �������� ���� ����������� ������, ��������� ��������.");
         }
      }
   }
   while (is_closed_0 == 0) {
      RefreshRates();
      bool_16 = OrderSelect(G_ticket_476, SELECT_BY_TICKET, MODE_TRADES);
      if (bool_16 != TRUE) {
         Print("������! ���������� ������� ����� � ���������� ��������. ���������� ���������� ��������.");
         return;
      }
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber || f0_18()) {
         switch (OrderType()) {
         case OP_BUY:
            is_closed_0 = OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Bid, Digits), slippage_12, Blue);
            break;
         case OP_SELL:
            is_closed_0 = OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Ask, Digits), slippage_12, Red);
         }
         if (is_closed_0 == 1) {
            if (Info) Print("������������� ����� ������ �������.");
            Sleep(500);
            continue;
         }
         Print("������ �������� �������������� ������, ��������� ��������.");
      }
   }
   if (Info) Print("����� ������� ���������� �������.");
}
		  		    	    	 	  					   	  		  	 					 		  	  					 			 					    	       	    	  		 	    		  	  				 	 	   		   			   			  		 		 			  			 		 
// 5DD67D171E3A2D8C0E5A7E24A1240E63
int f0_11() {
   string name_4;
   Gi_848 = FALSE;
   Gd_568 = 0;
   Gd_576 = 0;
   int objs_total_0 = ObjectsTotal();
   for (int Li_12 = 0; Li_12 < objs_total_0; Li_12++) {
      name_4 = ObjectName(Li_12);
      if (StringSubstr(name_4, 0, 1) == "I" || StringSubstr(name_4, 0, 1) == "i") {
         ObjectDelete(name_4);
         Comment("");
         Li_12--;
      }
   }
   return (0);
}
	 		 			 	 		 	   		 	  				  	 			 		  	 	   	  	   	 		  	 	  								 							 	 			 							 	  		 	    	 	 	 				 	 	 	    	 		  		   	       
// FFCAA643B493573EC6A0A6AFE59C37B8
void f0_22(string A_name_0, double A_price_8, color A_color_16, int A_width_20) {
   if (ObjectFind(A_name_0) < 0) ObjectCreate(A_name_0, OBJ_HLINE, 0, 0, A_price_8);
   else ObjectMove(A_name_0, 0, Time[1], A_price_8);
   ObjectSet(A_name_0, OBJPROP_COLOR, A_color_16);
   ObjectSet(A_name_0, OBJPROP_WIDTH, A_width_20);
}
			    	    		   		   	 	 	  	  	 			 	 				 	     	  				    	 	 	 	  	  	 	  	    	 			 	 	 		 		   	  					  	 	   		   	 	  	  		 	    	 		  
// CC0E6ACC657AB511326581BDF1677E0A
void f0_19(string A_name_0, string A_text_8, double A_price_16, color A_color_24) {
   if (ObjectFind(A_name_0) < 0) ObjectCreate(A_name_0, OBJ_TEXT, 0, Time[WindowFirstVisibleBar() - WindowFirstVisibleBar() / 5], A_price_16);
   else ObjectMove(A_name_0, 0, Time[WindowFirstVisibleBar() - WindowFirstVisibleBar() / 4], A_price_16);
   ObjectSetText(A_name_0, A_text_8, 10, "Times New Roman", A_color_24);
}
	 				   	 	   	  											  				  				 	 	  	 	  			 	  									 	   			 	   	 	 		 				 		   						  	    								  	  	  			   			 	  	 		 
// 1B15837728C0CB4D4B7CA285BDA606B9
void f0_3(string A_name_0, int A_corner_8, int A_x_12, int A_y_16, string A_text_20, int A_fontsize_28, string A_fontname_32, color A_color_40) {
   if (ObjectFind(A_name_0) < 0) ObjectCreate(A_name_0, OBJ_LABEL, 0, 0, 0);
   ObjectSet(A_name_0, OBJPROP_CORNER, A_corner_8);
   ObjectSet(A_name_0, OBJPROP_XDISTANCE, A_x_12);
   ObjectSet(A_name_0, OBJPROP_YDISTANCE, A_y_16);
   ObjectSetText(A_name_0, A_text_20, A_fontsize_28, A_fontname_32, A_color_40);
}
		 	 		 	 			 				 	 	 	   	  		    		 	 	    			 	  	   			 	 	   				 	  				 	 				     			  		 	 	 			  	 		   	 	  	 	   		  	 		 		 	    		
// 1147AA4BFB18C8EEE1DC8A6E293574DD
double f0_2(double Ad_0, int Ai_8 = 0) {
   double ima_12;
   double price_20;
   double Ld_28;
   double Ld_36;
   double Ld_44;
   int Li_60;
   double Ld_68;
   double Ld_52 = 0.015;
   for (int Li_64 = Period_CCI - 1; Li_64 >= 0; Li_64--) {
      Li_60 = Li_64 + Ai_8;
      price_20 = (High[Li_60] + Low[Li_60] + Close[Li_60]) / 3.0;
      ima_12 = iMA(NULL, 0, Period_CCI, 0, MODE_SMA, PRICE_TYPICAL, Ai_8);
      Ld_36 = MathAbs(price_20 - ima_12);
      if (Li_64 > 0) {
         Ld_28 += price_20;
         Ld_44 += Ld_36;
      }
   }
   if (Info == FALSE) {
      Ld_68 = (price_20 - ima_12) / ((Ld_44 + Ld_36) * Ld_52 / Period_CCI);
      f0_3("ICCI", 2, 10, 45, StringConcatenate("CCI (", DoubleToStr(Ad_0, 0), ",", Period_CCI, ",", CCI_TimeFrame, ") = ", DoubleToStr(Ld_68, 0)), Gi_420, "Times New Roman",
         Gi_396);
   }
   double Ld_76 = High[Ai_8];
   double Ld_84 = Low[Ai_8];
   Li_64 = Period_CCI;
   if (Ld_68 >= 0.0) {
      Ld_68 = Ad_0;
      price_20 = -(Ld_76 * Li_64 - Ld_84 * Li_64 * Li_64 - Ld_76 * Li_64 * Li_64 + Ld_84 * Li_64 - Ld_68 * Ld_76 * Ld_52 - Ld_68 * Ld_84 * Ld_52 + 3.0 * Ld_28 * Li_64 - 3.0 * Ld_68 * Ld_52 * Ld_28 +
         Ld_68 * Ld_76 * Ld_52 * Li_64 + Ld_68 * Ld_84 * Ld_52 * Li_64 + 3.0 * Ld_68 * Ld_52 * Ld_44 * Li_64) / (Li_64 - Li_64 * Li_64 - Ld_68 * Ld_52 + Ld_68 * Ld_52 * Li_64);
   } else {
      Ld_68 = -Ad_0;
      price_20 = -(Ld_76 * Li_64 - Ld_84 * Li_64 * Li_64 - Ld_76 * Li_64 * Li_64 + Ld_84 * Li_64 + Ld_68 * Ld_76 * Ld_52 + Ld_68 * Ld_84 * Ld_52 + 3.0 * Ld_28 * Li_64 +
         3.0 * Ld_68 * Ld_52 * Ld_28 - Ld_68 * Ld_76 * Ld_52 * Li_64 - Ld_68 * Ld_84 * Ld_52 * Li_64 + 3.0 * Ld_68 * Ld_52 * Ld_44 * Li_64) / (Li_64 - Li_64 * Li_64 + Ld_68 * Ld_52 - Ld_68 * Ld_52 * Li_64);
   }
   if (ObjectFind("ILineCCI") != -1) ObjectDelete("ILineCCI");
   if (ObjectFind("ItxtCCI") != -1) ObjectDelete("ItxtCCI");
   if (price_20 > Ld_76) {
      ObjectCreate("ILineCCI", OBJ_HLINE, 0, 0, price_20);
      ObjectSet("ILineCCI", OBJPROP_COLOR, SteelBlue);
      f0_19("ItxtCCI", StringConcatenate("CCI < ", DoubleToStr(Ld_68, 0)), price_20, SteelBlue);
   } else ObjectCreate("ILineCCI", OBJ_HLINE, 0, 0, price_20);
   if (price_20 < Ld_84) {
      ObjectCreate("ILineCCI", OBJ_HLINE, 0, 0, price_20);
      ObjectSet("ILineCCI", OBJPROP_COLOR, Teal);
      f0_19("ItxtCCI", StringConcatenate("CCI > ", DoubleToStr(Ld_68, 0)), price_20, Teal);
   } else ObjectCreate("ILineCCI", OBJ_HLINE, 0, 0, price_20);
   return (price_20);
}
		 	   		 				  		 	  	    	 	      	 	  	   	  	 	   		 			  	    		  		  		  		 			 		   		 				 	  	 		  		     	  			 	  	    	 	 	 	 	  		 	
// 67A9C06D93A55B8219D15794968966C8
void f0_12() {
   string name_4;
   int Li_24;
   int shift_28;
   double Ld_32;
   bool bool_40;
   string str_concat_44;
   string str_concat_64;
   string str_concat_72;
   string Ls_80;
   string Ls_88;
   string Ls_100;
   int Li_unused_108;
   int Li_unused_112;
   int Li_unused_116;
   string Ls_120;
   int objs_total_0 = ObjectsTotal();
   for (int Li_12 = 0; Li_12 < objs_total_0; Li_12++) {
      name_4 = ObjectName(Li_12);
      if (StringSubstr(name_4, 0, 1) == "i") {
         ObjectDelete(name_4);
         Li_12--;
      }
   }
   int Li_16 = 1;
   for (Li_12 = OrdersTotal(); Li_12 >= 0; Li_12--) {
      if (OrderSelect(Li_12, SELECT_BY_POS, MODE_TRADES)) {
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber || f0_18()) {
            if (OrderType() == OP_BUY) {
               ObjectCreate(StringConcatenate("iB", Li_16), OBJ_TEXT, 0, Time[40], OrderOpenPrice());
               ObjectSetText(StringConcatenate("iB", Li_16), StringConcatenate("Lot: ", DoubleToStr(OrderLots(), 2), " Prof: ", DoubleToStr(OrderProfit(), 2)), 8, "Verdana", DeepSkyBlue);
               Li_16++;
            }
         }
      }
   }
   int Li_20 = 1;
   for (Li_12 = OrdersTotal(); Li_12 >= 0; Li_12--) {
      if (OrderSelect(Li_12, SELECT_BY_POS, MODE_TRADES)) {
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber || f0_18()) {
            if (OrderType() == OP_SELL) {
               ObjectCreate(StringConcatenate("iS", Li_20), OBJ_TEXT, 0, Time[40], OrderOpenPrice());
               ObjectSetText(StringConcatenate("iS", Li_20), StringConcatenate("Lot: ", DoubleToStr(OrderLots(), 2), " Prof: ", DoubleToStr(OrderProfit(), 2)), 8, "Verdana", DarkOrange);
               Li_20++;
            }
         }
      }
   }
   if (ObjectFind("DrawDown") >= 0) {
      Li_24 = ObjectGet("DrawDown", OBJPROP_TIME1);
      shift_28 = iBarShift(Symbol(), 0, Li_24);
      Ld_32 = iHigh(Symbol(), 0, shift_28) + (WindowPriceMax() - WindowPriceMin()) / 20.0;
      bool_40 = ObjectSet("DrawDown", OBJPROP_PRICE1, Ld_32);
   }
   if (Gd_736 < (AccountBalance() + AccountCredit() - AccountEquity() + AccountCredit()) / AccountBalance() + AccountCredit()) {
      ObjectDelete("DrawDown");
      Gd_736 = (AccountBalance() + AccountCredit() - AccountEquity() + AccountCredit()) / AccountBalance() + AccountCredit();
      G_str_concat_840 = StringConcatenate(DoubleToStr(100.0 * Gd_736, 2), " %");
      ObjectCreate("DrawDown", OBJ_ARROW, 0, Time[0], High[0] + (WindowPriceMax() - WindowPriceMin()) / 20.0);
      ObjectSet("DrawDown", OBJPROP_ARROWCODE, 117);
      ObjectSet("DrawDown", OBJPROP_COLOR, DarkOrange);
      ObjectSet("DrawDown", OBJPROP_TIMEFRAMES, NULL);
      ObjectSetText("DrawDown", G_str_concat_840);
   }
   if (Gd_760 >= 5.0 * (Gd_752 / 6.0)) Gi_556 = Gi_396;
   if (Gd_760 >= 4.0 * (Gd_752 / 6.0) && Gd_760 < 5.0 * (Gd_752 / 6.0)) Gi_556 = 16760576;
   if (Gd_760 >= 3.0 * (Gd_752 / 6.0) && Gd_760 < 4.0 * (Gd_752 / 6.0)) Gi_556 = 55295;
   if (Gd_760 >= 2.0 * (Gd_752 / 6.0) && Gd_760 < 3.0 * (Gd_752 / 6.0)) Gi_556 = 17919;
   if (Gd_760 >= Gd_752 / 6.0 && Gd_760 < 2.0 * (Gd_752 / 6.0)) Gi_556 = 3937500;
   if (Gd_760 < Gd_752 / 6.0) Gi_556 = 255;
   int Li_52 = NormalizeDouble((AccountEquity() - AccountStopoutLevel() * AccountEquity() / 100.0) / Gd_688 / G_tickvalue_728, 0);
   string Ls_56 = DoubleToStr(NormalizeDouble(Gd_688 / 100.0 * Gi_220, Gi_460), Gi_460);
   if (Gd_680 != 0.0) {
      str_concat_64 = StringConcatenate("�� ������� ", DoubleToStr(Gd_712 + Tral_Start, 0), " �������");
      str_concat_72 = StringConcatenate("�� ��������� ", DoubleToStr(Gd_720, 0), " �������");
      if (Gd_680 < 0.0) {
         str_concat_44 = StringConcatenate("�� ����� ", Li_52, " ������� �����");
         Ls_56 = StringConcatenate("����� ��� �����������: Buy ", Ls_56);
      } else {
         str_concat_44 = StringConcatenate("�� ����� ", Li_52, " ������� ����");
         Ls_56 = StringConcatenate("����� ��� �����������: Sell ", Ls_56);
      }
   } else {
      if (Gd_648 == 0.0 && Gd_656 == 0.0) {
         str_concat_44 = "��� �������";
         str_concat_64 = "";
         str_concat_72 = "";
      } else {
         str_concat_44 = "���� ������ ������";
         str_concat_64 = "���� ��������";
         str_concat_72 = "��������� �����";
      }
      Ls_56 = StringConcatenate("������� ����������� ������ = ", Gi_220);
   }
   if (MaxLot != 0.0) Gd_704 = MaxLot;
   if (IsDemo()) Ls_80 = "����";
   else Ls_80 = "����";
   Comment("\n", StringConcatenate(" ALADDIN 9 FX  ������� ����������� �� ����� : ", Ls_80, " - �: ", AccountNumber(), " \\ ", AccountCompany()), 
      "\n", "============================================================", 
      "\n", StringConcatenate(" ����� ������� = ", TimeToStr(TimeCurrent(), TIME_SECONDS)), " \\ ", f0_0(DayOfWeek()), 
      "\n", StringConcatenate(" ����� = ", AccountLeverage(), " : 1  \\ ", " ����� = ", G_spread_500), 
      "\n", StringConcatenate(" ������ : ������ = ", G_stoplevel_508, " \\ ", " StopOut = ", AccountStopoutLevel(), "%"), 
      "\n", StringConcatenate(" ����� : Buy = ", MarketInfo(Symbol(), MODE_SWAPLONG), " \\ ", " Sell = ", MarketInfo(Symbol(), MODE_SWAPSHORT)), 
      "\n", StringConcatenate(" ��������� ��� = ", NormalizeDouble(Gd_664, Gi_460)), 
      "\n", StringConcatenate(" ������������ ��� = ", NormalizeDouble(Gd_704, Gi_460), " \\ ", " �����������  ��� = ", NormalizeDouble(G_minlot_696, Gi_460)), 
      "\n", "============================================================", 
      "\n", " http://finans-plus.ru, finansplus@bk.ru ", 
   "\n");
   if (Gi_864) Ls_88 = "������������� ���";
   else Ls_88 = "������������ ���";
   if (!NewCycle_ON) f0_3("INewCycleON", 2, 10, 170, "������ ������ ������ �����", Gi_420, "Times New Roman", DeepSkyBlue);
   if (!TradeBuy) f0_3("ITradeBuy", 2, 10, 155, "������ ������ Buy", Gi_420, "Times New Roman", DeepSkyBlue);
   if (!TradeSell) f0_3("ITradeSell", 2, 10, 130, "������ ������ Sell", Gi_420, "Times New Roman", DeepSkyBlue);
   if (Gi_436) f0_3("IVisualMode", 2, 10, 115, "������� ������ ����� ��������", Gi_420, "Times New Roman", DeepSkyBlue);
   switch (TipMAFilter) {
   case 1:
      if (f0_10() == -1 || f0_10() == 0) f0_3("ILevelBuy", 2, 10, 105, "������ Buy", Gi_420, "Times New Roman", Gi_396);
      else ObjectDelete("ILevelBuy");
      if (f0_10() == 1 || f0_10() == 0) f0_3("ILevelSell", 2, 10, 90, "������ Sell", Gi_420, "Times New Roman", Gi_396);
      else ObjectDelete("ILevelSell");
      break;
   case 2:
      if (f0_13() == 1) f0_3("ILevelBuy", 2, 10, 105, "������ Buy", Gi_420, "Times New Roman", Gi_396);
      else ObjectDelete("ILevelBuy");
      if (f0_13() == -1) f0_3("ILevelSell", 2, 10, 90, "������ Sell", Gi_420, "Times New Roman", Gi_396);
      else ObjectDelete("ILevelSell");
   }
   if (!f0_1()) f0_3("Itime", 2, 10, 75, "������� ������ �������x ����", Gi_420, "Times New Roman", Gi_396);
   else ObjectDelete("Itime");
   if (!Gi_848) Ls_100 = "";
   else Ls_100 = "�����������! ����� ���� �������!";
   f0_3("ITrail", 2, Gi_412, 30, Ls_100, Gi_420 + 5, "Courier", Lime);
   f0_3("IFixLot", 2, 10, 60, Ls_88, Gi_420, "Times New Roman", Gi_396);
   f0_3("Ispips", 3, 10, 55, str_concat_44, Gi_420, "Times New Roman", Gi_556);
   f0_3("Ilock", 3, 10, 10, Ls_56, Gi_420, "Times New Roman", Gi_396);
   f0_3("IProf", 3, 10, 40, str_concat_64, Gi_420, "Times New Roman", Gi_556);
   f0_3("IBezub", 3, 10, 25, str_concat_72, Gi_420, "Times New Roman", Gi_556);
   f0_3("MaxDrDown", 3, 10, 155, StringConcatenate("����. ��������: ", DoubleToStr(100.0 * MathMax(Gd_736, 0), 2), " %"), Gi_420, "Times New Roman", LightCoral);
   f0_3("IBalance ", 3, 10, 100, StringConcatenate("������   ", DoubleToStr(Gd_752, 2)), Gi_420, "Times New Roman", Gi_396);
   f0_3("IEquity  ", 3, 10, 85, StringConcatenate("�������� ", DoubleToStr(Gd_744, 2)), Gi_420, "Times New Roman", Gi_556);
   f0_3("IDrawDown", 3, 10, 70, StringConcatenate("�������� ", DoubleToStr(Gd_616, 2), "%"), Gi_420, "Times New Roman", Gi_556);
   if (Gd_640 < 0.0) Li_unused_108 = 8421616;
   else Li_unused_108 = 65280;
   if (Gd_784 < 0.0) Li_unused_112 = 12695295;
   else Li_unused_112 = 9498256;
   if (Gd_792 < 0.0) Li_unused_116 = 12695295;
   else Li_unused_116 = 9498256;
   if (G_count_492 > MaxTrades || G_count_496 > MaxTrades) Ls_120 = "����������� ����� �����";
   else Ls_120 = "Aladdin 9 FX Real";
   f0_3("IAladdin", 2, 10, 25, Ls_120, Gi_420, "Times New Roman", LightGreen);
}
	  		 		 			 		    		   		 				 		      	   			  		 	  		 			   		 	  		 	 	  		 			   			 	   	   		        		 		 		  	 		 			 			      		 		   
// 004504DA873A9772B488D7F1B80F9C36
string f0_0(int Ai_0) {
   if (Ai_0 == 0) return ("�����������");
   if (Ai_0 == 1) return ("�����������");
   if (Ai_0 == 2) return ("�������");
   if (Ai_0 == 3) return ("�����");
   if (Ai_0 == 4) return ("�������");
   if (Ai_0 == 5) return ("�������");
   if (Ai_0 == 6) return ("�������");
   return ("");
}
		  		    	    	 	  					   	  		  	 					 		  	  					 			 					    	       	    	  		 	    		  	  				 	 	   		   			   			  		 		 			  			 		 
// B6838164ED869516345D96B32AA351B5
string f0_16(int Ai_0) {
   switch (Ai_0) {
   case 0:
      return ("BUY");
   case 1:
      return ("SELL");
   case 2:
      return ("BUY LIMIT");
   case 3:
      return ("SELL LIMIT");
   case 4:
      return ("BUY STOP");
   case 5:
      return ("SELL STOP");
   }
   return ("Unknown Operation");
}
	 	   	 		  					 	    	 		  			 				  	  		 					 	           	 		 	 	 			 	 	 		  	    		 	   	 	    		 						 		     		 	 			 	 		  			 	 	 		
// 41BB59E8D36C416E4C62910D9E765220
void f0_7(int A_magic_0, int A_cmd_4 = -1) {
   bool is_closed_8 = FALSE;
   double slippage_12 = 2.0 * MarketInfo(Symbol(), MODE_SPREAD);
   for (int pos_20 = OrdersTotal() - 1; pos_20 >= 0; pos_20--) {
      OrderSelect(pos_20, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == A_magic_0 || f0_18() && OrderType() == A_cmd_4 || A_cmd_4 == -1) {
         RefreshRates();
         switch (OrderType()) {
         case OP_BUY:
            is_closed_8 = OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Bid, Digits), slippage_12, Blue);
            break;
         case OP_SELL:
            is_closed_8 = OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Ask, Digits), slippage_12, Red);
         }
         if (is_closed_8 == 1) {
            if (Info) Print("O���� ������ ������� �������");
            Sleep(500);
            continue;
         }
         Print("������ �������� ������, ��������� ��������. ");
      }
   }
}
