package com.googleplayservice.billing;

import android.app.Activity;
import java.lang.ref.WeakReference;
import org.json.JSONObject;

public class Payment {
    public static WeakReference<Activity> m_activity;
    protected IGamePurchase mIGamePurchase = null;
    protected IPostEventHandler mIPostEventHandler = null;

    public interface IGamePurchase {
        void callPaySuccess(String str);

        void onCallPayConfig(String str);

        void onCallPayConfigFail(String str);

        void onCallPayInfo(String str);

        void onCallPayInfoFail(String str);

        void onExternalCheckoutAvailability(String str);

        void onExternalCheckoutFail(String str);

        void onExternalCheckoutLaunch(String str);

        void onExternalCheckoutToken(String str);

        void onGetFormattedPrice(String str);

        void onPurchasesFail(String str);
    }

    public interface IPostEventHandler {
        void onPostEvent(String str);

        void onPostEventData(String str, String str2);

        void onPostEventJsonData(String str, String str2);
    }

    public static void callBuyGold(String str, String str2, String str3, boolean z) {
    }

    public static void callPayInit() {
    }

    public static void onConsumeCallback(String str, int i) {
    }

    public void buyGold(String str, String str2, String str3, boolean z) {
    }

    public void consumeCallback(String str, int i) {
    }

    public void doInit() {
    }

    public void queryPurchaseOrder() {
    }

    public void setIGamePurchaseInterface(IGamePurchase iGamePurchase) {
        this.mIGamePurchase = iGamePurchase;
    }

    public void init(Activity activity) {
        m_activity = new WeakReference<>(activity);
    }

    public static void callPayFailed(int i, String str) {
        WeakReference<Activity> weakReference = m_activity;
        if (weakReference != null) {
            weakReference.get().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                }
            });
        }
    }

    public void callPaySuccess(String str, String str2, String str3, String str4, String str5, String str6) {
        try {
            JSONObject jSONObject = new JSONObject();
            jSONObject.putOpt("code", "0");
            jSONObject.putOpt("orderId", str);
            jSONObject.putOpt("purchaseTime", str2);
            jSONObject.putOpt("productId", str3);
            jSONObject.putOpt("signData", str4);
            jSONObject.putOpt("signature", str5);
            jSONObject.putOpt("payload", str6);
            String string = jSONObject.toString();
            IGamePurchase iGamePurchase = this.mIGamePurchase;
            if (iGamePurchase != null) {
                iGamePurchase.callPaySuccess(string);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void setIPostEventInterface(IPostEventHandler iPostEventHandler) {
        this.mIPostEventHandler = iPostEventHandler;
    }
}
