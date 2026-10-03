package com.googleplayservice.billing;

public class NativeLog {

    public static class PayLog {
        public static final String ClickIcon = "Pay.ClickIcon";
        public static final String GameBillOrderIdNone = "Pay.GameBillOrderIdNone";
        public static final String GameCheckBillFail = "Pay.GameCheckBillFail";
        public static final String GameCheckBillSuccess = "Pay.GameCheckBillSuccess";
        public static final String GetGameBillFail = "Pay.GetGameBillFail";
        public static final String GetGameBillSuccess = "Pay.GetGameBillSuccess";
        public static final String GoogleNativeNoHelper = "Pay.GoogleNativeNoHelper";
        public static final String GoogleNoBill = "Pay.GoogleNoBill";
        public static final String GooglePayFail = "Pay.GooglePayFail";
        public static final String GooglePaySuccess = "Pay.GooglePaySuccess";
        public static final String ToCheckForGame = "Pay.ToCheckForGame";
        public static final String ToGetGameBill = "Pay.ToGetGameBill";
        public static final String ToPayForGoogle = "Pay.ToPayForGoogle";
    }

    public static void LogToServerInBill(String str) {
    }
}
