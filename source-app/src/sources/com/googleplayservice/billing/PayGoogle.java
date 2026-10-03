package com.googleplayservice.billing;

import android.util.Log;
import com.android.billingclient.api.AccountIdentifiers;
import com.android.billingclient.api.BillingResult;
import com.android.billingclient.api.Purchase;
import com.ishumei.smantifraud.l11l11I1111l;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.json.JSONException;
import org.json.JSONObject;

public class PayGoogle extends Payment {
    static final boolean Debug = false;
    static final String Debug_Tag = "AgainstWarZPayGoogle";
    private static final String PLAY_STORE_VERSION_EVENT_NAME = "googleplay_store_version";
    static final String SKU_SUBS_GOLD_2277 = "zuanshi_2277";
    static final String SKU_SUBS_GOLD_2278 = "zuanshi_2278";
    static final List<String> subList = Arrays.asList(new String[0]);
    private BillingManager m_helper = null;
    List<String> inappList = new ArrayList();
    List<String> inappListShort = new ArrayList();
    List<String> consumeList = new ArrayList();
    private Map<String, String> tokenMap = new HashMap();
    public boolean queryingPurchaseOrder = false;
    BillingManager.IHandlePurchase iHandlePurchase = new BillingManager.IHandlePurchase() {
        @Override
        public void onCallPayInfo(String str) {
            try {
                JSONObject jSONObject = new JSONObject();
                jSONObject.put("data", str);
                if (PayGoogle.this.mIGamePurchase != null) {
                    PayGoogle.this.mIGamePurchase.onCallPayInfo(jSONObject.toString());
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }

        @Override
        public void onCallPayInfoFail(String str) {
            try {
                JSONObject jSONObject = new JSONObject();
                jSONObject.put("data", str);
                if (PayGoogle.this.mIGamePurchase != null) {
                    PayGoogle.this.mIGamePurchase.onCallPayInfoFail(jSONObject.toString());
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }

        @Override
        public void onBillingClientSetupFinished() {
            if (PayGoogle.this.m_helper != null) {
                PayGoogle.this.m_helper.querySkuInApp(PayGoogle.subList, PayGoogle.this.inappList, PayGoogle.this.inappListShort);
                try {
                    PayGoogle.this.m_helper.queryPurchases(true, true);
                    PayGoogle.this.m_helper.getBillingConfig();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }

        @Override
        public void onConsumeResponse(BillingResult billingResult, String str) {
            if (billingResult.getResponseCode() == 0) {
                Log.e("xx", "xx");
            } else {
                Log.e("xa", "11");
            }
            if (PayGoogle.this.mIPostEventHandler != null) {
                try {
                    PayGoogle.this.mIPostEventHandler.onPostEventData("on_purchase_consumed", "code:" + billingResult.getResponseCode() + "    token:" + str);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }

        @Override
        public void onPurchasesUpdated(List<Purchase> list) {
            String str;
            for (Purchase purchase : list) {
                if (purchase.getPurchaseState() == 1) {
                    ArrayList skus = purchase.getSkus();
                    if (!skus.isEmpty()) {
                        String orderId = purchase.getOrderId();
                        purchase.getPackageName();
                        String str2 = (String) skus.get(0);
                        String signature = purchase.getSignature();
                        String string = Long.valueOf(purchase.getPurchaseTime()).toString();
                        String purchaseToken = purchase.getPurchaseToken();
                        String str3 = orderId == "" ? purchaseToken : orderId;
                        NativeLog.LogToServerInBill(NativeLog.PayLog.GooglePaySuccess);
                        PayGoogle.this.tokenMap.put(str3, purchaseToken);
                        AccountIdentifiers accountIdentifiers = purchase.getAccountIdentifiers();
                        if (accountIdentifiers == null) {
                            str = "";
                        } else {
                            str = accountIdentifiers.getObfuscatedAccountId() + "|" + accountIdentifiers.getObfuscatedProfileId();
                        }
                        PayGoogle.this.callPaySuccess(str3, string, str2, purchase.getOriginalJson(), signature, str);
                        if (!purchase.isAcknowledged() && PayGoogle.this.m_helper != null) {
                            PayGoogle.this.m_helper.acknowledgePurchaseParams(purchaseToken);
                        }
                    }
                } else if (purchase.getPurchaseState() == 2) {
                    try {
                        JSONObject jSONObject = new JSONObject();
                        jSONObject.putOpt("code", "100");
                        jSONObject.putOpt(l11l11I1111l.l111l1111l1Il, "pending");
                        jSONObject.putOpt("typeCode", 100);
                        String string2 = jSONObject.toString();
                        if (PayGoogle.this.mIGamePurchase != null) {
                            PayGoogle.this.mIGamePurchase.onPurchasesFail(string2);
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        }

        @Override
        public void onPurchasesFail(String str, int i) {
            try {
                JSONObject jSONObject = new JSONObject();
                jSONObject.putOpt("code", "3");
                jSONObject.putOpt(l11l11I1111l.l111l1111l1Il, str);
                jSONObject.putOpt("typeCode", Integer.valueOf(i));
                String string = jSONObject.toString();
                NativeLog.LogToServerInBill(NativeLog.PayLog.GooglePayFail);
                if (PayGoogle.this.mIGamePurchase != null) {
                    PayGoogle.this.mIGamePurchase.onPurchasesFail(string);
                }
                if (i == 7) {
                    try {
                        PayGoogle.this.queryPurchaseOrder();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            } catch (Exception e2) {
                e2.printStackTrace();
            }
        }

        @Override
        public void onPurchasesBreak(String str, int i) {
            try {
                JSONObject jSONObject = new JSONObject();
                jSONObject.putOpt("code", "2");
                jSONObject.putOpt("typeCode", Integer.valueOf(i));
                String string = jSONObject.toString();
                if (PayGoogle.this.mIGamePurchase != null) {
                    PayGoogle.this.mIGamePurchase.onPurchasesFail(string);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        @Override
        public void onPostEvent(String str) {
            if (PayGoogle.this.mIPostEventHandler != null) {
                PayGoogle.this.mIPostEventHandler.onPostEvent(str);
            }
        }

        @Override
        public void onPostEventData(String str, String str2) {
            if (PayGoogle.this.mIPostEventHandler != null) {
                PayGoogle.this.mIPostEventHandler.onPostEventData(str, str2);
            }
        }

        @Override
        public void onPostEventJsonData(String str, String str2) {
            if (PayGoogle.this.mIPostEventHandler != null) {
                PayGoogle.this.mIPostEventHandler.onPostEventJsonData(str, str2);
            }
        }

        @Override
        public void onPlayStoreVersionReady(String str) {
            if (PayGoogle.this.mIPostEventHandler != null) {
                PayGoogle.this.mIPostEventHandler.onPostEventJsonData(PayGoogle.PLAY_STORE_VERSION_EVENT_NAME, str);
            }
        }

        @Override
        public void OnCallPayConfig(String str) {
            if (PayGoogle.this.mIGamePurchase != null) {
                PayGoogle.this.mIGamePurchase.onCallPayConfig(str);
            }
        }

        @Override
        public void OnCallPayConfigFail(String str) {
            if (PayGoogle.this.mIGamePurchase != null) {
                PayGoogle.this.mIGamePurchase.onCallPayConfigFail(str);
            }
        }

        @Override
        public void OnGetFormattedPrice(String str) {
            if (PayGoogle.this.mIGamePurchase != null) {
                PayGoogle.this.mIGamePurchase.onGetFormattedPrice(str);
            }
        }

        @Override
        public void OnExternalCheckoutAvailability(String str) {
            if (PayGoogle.this.mIGamePurchase != null) {
                PayGoogle.this.mIGamePurchase.onExternalCheckoutAvailability(str);
            }
        }

        @Override
        public void OnExternalCheckoutToken(String str) {
            if (PayGoogle.this.mIGamePurchase != null) {
                PayGoogle.this.mIGamePurchase.onExternalCheckoutToken(str);
            }
        }

        @Override
        public void OnExternalCheckoutLaunch(String str) {
            if (PayGoogle.this.mIGamePurchase != null) {
                PayGoogle.this.mIGamePurchase.onExternalCheckoutLaunch(str);
            }
        }

        @Override
        public void OnExternalCheckoutFail(String str) {
            if (PayGoogle.this.mIGamePurchase != null) {
                PayGoogle.this.mIGamePurchase.onExternalCheckoutFail(str);
            }
        }
    };

    public void debugLog(String str) {
    }

    public void addNewItems() {
        this.inappList.clear();
        this.inappList.add("prod_1");
        this.inappList.add("prod_2");
        this.inappList.add("prod_3");
        this.inappList.add("prod_4");
        this.inappList.add("prod_5");
        this.inappList.add("prod_10");
        this.inappList.add("prod_20");
        this.inappList.add("prod_25");
        this.inappList.add("prod_50");
        this.inappList.add("prod_100");
        this.inappList.add("pass_prod_2");
        this.inappList.add("pass_prod_20");
        this.inappList.add("allweekly_prod_20");
        this.inappList.add("first_prod_1");
        this.inappList.add("month_prod_25");
        this.inappList.add("week_prod_5");
    }

    @Override
    public void doInit() {
        if (this.m_helper == null) {
            addNewItems();
            BillingManager billingManager = new BillingManager(m_activity.get());
            this.m_helper = billingManager;
            billingManager.setHandlePurchaseInterface(this.iHandlePurchase);
        }
    }

    @Override
    public void queryPurchaseOrder() {
        try {
            BillingManager billingManager = this.m_helper;
            if (billingManager != null) {
                billingManager.queryPurchases(true, true);
            }
        } catch (IllegalStateException e) {
            e.printStackTrace();
        }
    }

    public void queryPurchaseOrderHistory() {
        try {
            BillingManager billingManager = this.m_helper;
            if (billingManager != null) {
                billingManager.queryPurchaseHistory();
            }
        } catch (IllegalStateException e) {
            e.printStackTrace();
        }
    }

    public void querySkuDetailsAsync(String str, List<String> list) {
        BillingManager billingManager = this.m_helper;
        if (billingManager != null) {
            billingManager.querySkuDetailsAsync(str, list);
        }
    }

    public int CheckPayEnv() {
        BillingManager billingManager = this.m_helper;
        if (billingManager != null) {
            return billingManager.CheckPayEnv();
        }
        return 0;
    }

    public void buyGold(String str, String str2, boolean z) {
        if (this.m_helper != null) {
            NativeLog.LogToServerInBill(NativeLog.PayLog.ToPayForGoogle);
            this.m_helper.showBuyGoldView(str, str2);
        } else {
            doInit();
            NativeLog.LogToServerInBill(NativeLog.PayLog.GoogleNativeNoHelper);
        }
    }

    @Override
    public void consumeCallback(String str, int i) {
        if (i == 1) {
            debugLog("Consume callback : consume state:" + i);
        } else if (i == 2) {
            debugLog("Consume callback : consume state:" + i);
        } else if (i == 3) {
            debugLog("Consume callback : consume state:" + i);
        } else {
            debugLog("Consume callback : consume state:" + i);
        }
        String str2 = this.tokenMap.get(str);
        try {
            BillingManager billingManager = this.m_helper;
            if (billingManager == null || str2 == null) {
                return;
            }
            billingManager.consumeAsync(str2);
        } catch (IllegalStateException e) {
            e.printStackTrace();
        }
    }

    public void getBillingConfig() {
        try {
            BillingManager billingManager = this.m_helper;
            if (billingManager != null) {
                billingManager.getBillingConfig();
            }
        } catch (IllegalStateException e) {
            e.printStackTrace();
        }
    }

    public void getFormattedPrice(String str) {
        try {
            BillingManager billingManager = this.m_helper;
            if (billingManager != null) {
                billingManager.getFormattedPrice(str);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void checkExternalCheckoutAvailability(ExternalCheckoutProgram externalCheckoutProgram) {
        try {
            BillingManager billingManager = this.m_helper;
            if (billingManager != null) {
                billingManager.checkExternalCheckoutAvailability(externalCheckoutProgram);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void createExternalContentLinkToken() {
        try {
            BillingManager billingManager = this.m_helper;
            if (billingManager != null) {
                billingManager.createExternalContentLinkToken();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void prepareExternalCheckoutToken(ExternalCheckoutProgram externalCheckoutProgram) {
        try {
            BillingManager billingManager = this.m_helper;
            if (billingManager != null) {
                billingManager.prepareExternalCheckoutToken(externalCheckoutProgram);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void launchExternalContentLink(String str, boolean z) {
        try {
            BillingManager billingManager = this.m_helper;
            if (billingManager != null) {
                billingManager.launchExternalContentLink(str, z);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void launchExternalCheckout(ExternalCheckoutProgram externalCheckoutProgram, String str, boolean z) {
        try {
            BillingManager billingManager = this.m_helper;
            if (billingManager != null) {
                billingManager.launchExternalCheckout(externalCheckoutProgram, str, z);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
