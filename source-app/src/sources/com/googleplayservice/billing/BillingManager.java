package com.googleplayservice.billing;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.util.Log;
import com.android.billingclient.api.AcknowledgePurchaseParams;
import com.android.billingclient.api.AcknowledgePurchaseResponseListener;
import com.android.billingclient.api.BillingClient;
import com.android.billingclient.api.BillingClientStateListener;
import com.android.billingclient.api.BillingConfig;
import com.android.billingclient.api.BillingConfigResponseListener;
import com.android.billingclient.api.BillingFlowParams;
import com.android.billingclient.api.BillingProgramAvailabilityDetails;
import com.android.billingclient.api.BillingProgramAvailabilityListener;
import com.android.billingclient.api.BillingProgramReportingDetails;
import com.android.billingclient.api.BillingProgramReportingDetailsListener;
import com.android.billingclient.api.BillingProgramReportingDetailsParams;
import com.android.billingclient.api.BillingResult;
import com.android.billingclient.api.ConsumeParams;
import com.android.billingclient.api.ConsumeResponseListener;
import com.android.billingclient.api.GetBillingConfigParams;
import com.android.billingclient.api.LaunchExternalLinkParams;
import com.android.billingclient.api.LaunchExternalLinkResponseListener;
import com.android.billingclient.api.PendingPurchasesParams;
import com.android.billingclient.api.ProductDetails;
import com.android.billingclient.api.ProductDetailsResponseListener;
import com.android.billingclient.api.Purchase;
import com.android.billingclient.api.PurchasesResponseListener;
import com.android.billingclient.api.PurchasesUpdatedListener;
import com.android.billingclient.api.QueryProductDetailsParams;
import com.android.billingclient.api.QueryProductDetailsResult;
import com.android.billingclient.api.QueryPurchasesParams;
import com.google.android.gms.common.GoogleApiAvailability;
import java.math.BigDecimal;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Currency;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.json.JSONException;
import org.json.JSONObject;

public class BillingManager implements PurchasesUpdatedListener {
    public static final int BILLING_MANAGER_NOT_INITIALIZED = -1;
    private static final String GOOGLE_PLAY_SERVICES_PACKAGE_NAME = "com.google.android.gms";
    private static final String PLAY_STORE_PACKAGE_NAME = "com.android.vending";
    private static final String PRODUCT_DETAILS_NOT_SUPPORTED_TYPE = "product_details_not_supported";
    private static final String TAG = "BillingManager";
    private String _currencyCode;
    private String countryCode;
    private final Activity mActivity;
    private BillingClient mBillingClient;
    private boolean mHasReportedPlayStoreVersion;
    private boolean mIsServiceConnected;
    private IHandlePurchase mIhandlePurchase = null;
    private Map<String, ProductDetails> mProductMap = new HashMap();
    private int mBillingClientResponseCode = -1;
    private String payInfo = "";
    private final Map<String, Boolean> mReportedUnsupportedFeatures = new HashMap();

    public interface IHandlePurchase {
        void OnCallPayConfig(String str);

        void OnCallPayConfigFail(String str);

        void OnExternalCheckoutAvailability(String str);

        void OnExternalCheckoutFail(String str);

        void OnExternalCheckoutLaunch(String str);

        void OnExternalCheckoutToken(String str);

        void OnGetFormattedPrice(String str);

        void onBillingClientSetupFinished();

        void onCallPayInfo(String str);

        void onCallPayInfoFail(String str);

        void onConsumeResponse(BillingResult billingResult, String str);

        void onPlayStoreVersionReady(String str);

        void onPostEvent(String str);

        void onPostEventData(String str, String str2);

        void onPostEventJsonData(String str, String str2);

        void onPurchasesBreak(String str, int i);

        void onPurchasesFail(String str, int i);

        void onPurchasesUpdated(List<Purchase> list);
    }

    public interface ServiceConnectedListener {
        void onServiceConnected(int i);
    }

    private enum ExternalCheckoutResultCode {
        UNKNOWN(0),
        USER_CANCELLED(1),
        CLOSED(2),
        LAUNCH_FAILED(3);

        private final int value;

        ExternalCheckoutResultCode(int i) {
            this.value = i;
        }
    }

    private enum ExternalCheckoutResultCategory {
        USER_CANCELLED(1),
        FAILED(2);

        private final int value;

        ExternalCheckoutResultCategory(int i) {
            this.value = i;
        }
    }

    private enum ExternalCheckoutResultSource {
        NATIVE_FAILED(1);

        private final int value;

        ExternalCheckoutResultSource(int i) {
            this.value = i;
        }
    }

    public void setHandlePurchaseInterface(IHandlePurchase iHandlePurchase) {
        this.mIhandlePurchase = iHandlePurchase;
    }

    public BillingManager(Activity activity) {
        Log.d(TAG, "Creating Billing client.");
        this.mActivity = activity;
        this.mBillingClient = BillingClient.newBuilder(activity).enablePendingPurchases(PendingPurchasesParams.newBuilder().enableOneTimeProducts().build()).enableAutoServiceReconnection().enableBillingProgram(1).setListener(this).build();
        Log.d(TAG, "Starting setup.");
        GoogleApiAvailability.getInstance().isGooglePlayServicesAvailable(activity);
        startServiceConnection(new Runnable() {
            @Override
            public void run() {
                if (BillingManager.this.mIhandlePurchase != null) {
                    BillingManager.this.mIhandlePurchase.onBillingClientSetupFinished();
                }
            }
        });
    }

    public void onPurchasesUpdated(BillingResult billingResult, List<Purchase> list) {
        if (billingResult.getResponseCode() == 0 && list != null) {
            IHandlePurchase iHandlePurchase = this.mIhandlePurchase;
            if (iHandlePurchase != null) {
                iHandlePurchase.onPurchasesUpdated(list);
            }
        } else if (billingResult.getResponseCode() == 1) {
            Log.i(TAG, "onPurchasesUpdated() - user cancelled the purchase flow - skipping");
            IHandlePurchase iHandlePurchase2 = this.mIhandlePurchase;
            if (iHandlePurchase2 != null) {
                iHandlePurchase2.onPurchasesBreak("canceled", billingResult.getResponseCode());
            }
        } else {
            IHandlePurchase iHandlePurchase3 = this.mIhandlePurchase;
            if (iHandlePurchase3 != null) {
                iHandlePurchase3.onPurchasesFail("fail", billingResult.getResponseCode());
            }
            Log.w(TAG, "onPurchasesUpdated() got unknown resultCode: " + billingResult.getResponseCode());
        }
        try {
            JSONObject jSONObject = new JSONObject();
            jSONObject.putOpt("code", Integer.valueOf(billingResult.getResponseCode()));
            if (list != null && list.size() > 0) {
                String str = "";
                for (Purchase purchase : list) {
                    str = (((((str + purchase.getOrderId()) + "|") + purchase.getPurchaseState()) + "|") + purchase.getPurchaseTime()) + ";";
                }
                jSONObject.putOpt("purchases", str);
            }
            String string = jSONObject.toString();
            IHandlePurchase iHandlePurchase4 = this.mIhandlePurchase;
            if (iHandlePurchase4 != null) {
                iHandlePurchase4.onPostEventData("on_purchase_update", string);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void acknowledgePurchaseParams(String str) {
        final AcknowledgePurchaseParams acknowledgePurchaseParamsBuild = AcknowledgePurchaseParams.newBuilder().setPurchaseToken(str).build();
        executeServiceRequest(new Runnable() {
            @Override
            public void run() {
                BillingManager.this.mBillingClient.acknowledgePurchase(acknowledgePurchaseParamsBuild, new AcknowledgePurchaseResponseListener() {
                    public void onAcknowledgePurchaseResponse(BillingResult billingResult) {
                        if (billingResult.getResponseCode() == 0) {
                            Log.d("", "");
                        } else {
                            Log.d("", "");
                        }
                        billingResult.getDebugMessage();
                    }
                });
            }
        });
    }

    public void showBuyGoldView(final String str, final String str2) {
        executeServiceRequest(new Runnable() {
            @Override
            public void run() {
                if (BillingManager.this.ensureProductDetailsSupported(true)) {
                    if (BillingManager.this.mProductMap.containsKey(str)) {
                        BillingManager billingManager = BillingManager.this;
                        billingManager.initiatePurchaseFlowV5((ProductDetails) billingManager.mProductMap.get(str), str2);
                    } else {
                        NativeLog.LogToServerInBill(NativeLog.PayLog.GoogleNoBill);
                        if (BillingManager.this.mIhandlePurchase != null) {
                            BillingManager.this.mIhandlePurchase.onBillingClientSetupFinished();
                        }
                    }
                }
            }
        });
    }

    public void consumeAsync(String str) {
        final ConsumeParams consumeParamsBuild = ConsumeParams.newBuilder().setPurchaseToken(str).build();
        executeServiceRequest(new Runnable() {
            @Override
            public void run() {
                BillingManager.this.mBillingClient.consumeAsync(consumeParamsBuild, new ConsumeResponseListener() {
                    public void onConsumeResponse(BillingResult billingResult, String str2) {
                        if (BillingManager.this.mIhandlePurchase != null) {
                            BillingManager.this.mIhandlePurchase.onConsumeResponse(billingResult, str2);
                        }
                    }
                });
            }
        });
        try {
            IHandlePurchase iHandlePurchase = this.mIhandlePurchase;
            if (iHandlePurchase != null) {
                iHandlePurchase.onPostEventData("on_purchase_call_consume", "token:" + str);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void initiatePurchaseFlowV5(ProductDetails productDetails, String str) {
        ArrayList arrayList = new ArrayList();
        arrayList.add(BillingFlowParams.ProductDetailsParams.newBuilder().setProductDetails(productDetails).build());
        ProductDetails.OneTimePurchaseOfferDetails oneTimePurchaseOfferDetails = productDetails.getOneTimePurchaseOfferDetails();
        final BillingFlowParams billingFlowParamsBuild = BillingFlowParams.newBuilder().setProductDetailsParamsList(arrayList).setObfuscatedAccountId(str).setObfuscatedProfileId(oneTimePurchaseOfferDetails.getPriceCurrencyCode() + "_" + Long.toString(oneTimePurchaseOfferDetails.getPriceAmountMicros())).build();
        executeServiceRequest(new Runnable() {
            @Override
            public void run() {
                Log.i(BillingManager.TAG, "启动支付界面V5 response=" + BillingManager.this.mBillingClient.launchBillingFlow(BillingManager.this.mActivity, billingFlowParamsBuild).getResponseCode());
            }
        });
    }

    public Context getContext() {
        return this.mActivity;
    }

    public void destroy() {
        Log.d(TAG, "Destroying the manager.");
        BillingClient billingClient = this.mBillingClient;
        if (billingClient == null || !billingClient.isReady()) {
            return;
        }
        this.mBillingClient.endConnection();
        this.mBillingClient = null;
    }

    public void querySkuDetailsAsync(String str, List<String> list) {
        addSkuToMapV5(this.mProductMap, list, str, null);
        Log.i(TAG, "addSkuToMapV5");
    }

    public void addSkuToMapV5(final Map<String, ProductDetails> map, List<String> list, String str, final Runnable runnable) {
        ArrayList arrayList = new ArrayList();
        for (int i = 0; i < list.size(); i++) {
            arrayList.add(QueryProductDetailsParams.Product.newBuilder().setProductId(list.get(i)).setProductType(str).build());
        }
        final QueryProductDetailsParams queryProductDetailsParamsBuild = QueryProductDetailsParams.newBuilder().setProductList(arrayList).build();
        executeServiceRequest(new Runnable() {
            @Override
            public void run() {
                if (BillingManager.this.ensureProductDetailsSupported(false)) {
                    BillingManager.this.mBillingClient.queryProductDetailsAsync(queryProductDetailsParamsBuild, new ProductDetailsResponseListener() {
                        public void onProductDetailsResponse(BillingResult billingResult, QueryProductDetailsResult queryProductDetailsResult) {
                            List<ProductDetails> productDetailsList = queryProductDetailsResult.getProductDetailsList();
                            String str2 = "";
                            if (billingResult.getResponseCode() != 0 || productDetailsList.size() == 0) {
                                Log.e("google bill", "get product error v5");
                                if (BillingManager.this.mIhandlePurchase != null) {
                                    str2 = billingResult.getResponseCode() != 0 ? "错误码 " + billingResult.getResponseCode() : "";
                                    if (productDetailsList.size() == 0) {
                                        str2 = str2 + " 订单列表为空";
                                    }
                                    BillingManager.this.mIhandlePurchase.onCallPayInfoFail(str2);
                                }
                            } else {
                                StringBuffer stringBuffer = new StringBuffer(20000);
                                String priceCurrencyCode = "";
                                for (ProductDetails productDetails : productDetailsList) {
                                    map.put(productDetails.getProductId(), productDetails);
                                    ProductDetails.OneTimePurchaseOfferDetails oneTimePurchaseOfferDetails = productDetails.getOneTimePurchaseOfferDetails();
                                    if (oneTimePurchaseOfferDetails != null) {
                                        priceCurrencyCode = oneTimePurchaseOfferDetails.getPriceCurrencyCode();
                                        stringBuffer.append(productDetails.getProductId());
                                        stringBuffer.append(":");
                                        stringBuffer.append(oneTimePurchaseOfferDetails.getFormattedPrice());
                                        stringBuffer.append(":");
                                        stringBuffer.append(oneTimePurchaseOfferDetails.getPriceAmountMicros());
                                        stringBuffer.append(";");
                                    } else {
                                        Log.e(BillingManager.TAG, "Google OneTimePurchaseOfferDetails:is null id:" + productDetails.getProductId());
                                    }
                                }
                                if (priceCurrencyCode != "") {
                                    str2 = priceCurrencyCode + "|" + stringBuffer.toString();
                                    Log.i(BillingManager.TAG, "google bill payInfo V5:" + str2);
                                    BillingManager.this._currencyCode = priceCurrencyCode;
                                }
                                if (BillingManager.this.mIhandlePurchase != null) {
                                    BillingManager.this.mIhandlePurchase.onCallPayInfo(str2);
                                }
                            }
                            if (runnable != null) {
                                runnable.run();
                            }
                        }
                    });
                    return;
                }
                Runnable runnable2 = runnable;
                if (runnable2 != null) {
                    runnable2.run();
                }
            }
        });
    }

    public void querySkuInApp(List<String> list, List<String> list2, List<String> list3) {
        addSkuToMapV5(this.mProductMap, list2, "inapp", null);
    }

    public int getBillingClientResponseCode() {
        return this.mBillingClientResponseCode;
    }

    public synchronized void onQueryPurchasesFinished(BillingResult billingResult, List<Purchase> list) {
        ArrayList arrayList;
        String str;
        String str2;
        int i;
        boolean z;
        boolean z2;
        IHandlePurchase iHandlePurchase = this.mIhandlePurchase;
        if (iHandlePurchase != null) {
            try {
                iHandlePurchase.onPostEventData("on_purchase_queryFinish", "result code: " + billingResult.getResponseCode());
            } catch (Exception e) {
                e.printStackTrace();
            }
            if (this.mBillingClient != null && billingResult.getResponseCode() == 0) {
                Log.d(TAG, "Query inventory was successful.");
                int size = list.size();
                Log.d(">>>pay QueryFinished", "return querylist length: " + size);
                arrayList = new ArrayList();
                for (Purchase purchase : list) {
                    if (purchase.getPurchaseState() == 1) {
                        arrayList.add(purchase);
                    }
                }
                onPurchasesUpdated(billingResult, arrayList);
                if (this.mIhandlePurchase != null && list != null && size > 0) {
                    try {
                        JSONObject jSONObject = new JSONObject();
                        jSONObject.putOpt("code", Integer.valueOf(billingResult.getResponseCode()));
                        str = "";
                        str2 = "";
                        if (billingResult.getResponseCode() == 0) {
                            z = true;
                        } else {
                            z = false;
                        }
                        z2 = false;
                        for (i = 0; i < list.size(); i++) {
                            str = (str + list.get(i).getOrderId()) + ",";
                            if (z && list.get(i).getPurchaseState() == 1 && !list.get(i).getSkus().isEmpty()) {
                                str2 = (str2 + list.get(i).getOrderId()) + ",";
                                z2 = true;
                            }
                        }
                        jSONObject.putOpt("orderIds", str);
                        this.mIhandlePurchase.onPostEventData("on_purchase_querySuccess", jSONObject.toString());
                        if (z2) {
                            this.mIhandlePurchase.onPostEventData("on_purchase_restore", str2);
                        }
                    } catch (Exception e2) {
                        e2.printStackTrace();
                    }
                }
                return;
            }
            Log.w(TAG, "Billing client was null or result code (" + billingResult.getResponseCode() + ") was bad - quitting");
            return;
        }
        if (this.mBillingClient != null) {
            Log.d(TAG, "Query inventory was successful.");
            int size2 = list.size();
            Log.d(">>>pay QueryFinished", "return querylist length: " + size2);
            arrayList = new ArrayList();
            while (r2.hasNext()) {
                if (purchase.getPurchaseState() == 1) {
                    arrayList.add(purchase);
                }
            }
            onPurchasesUpdated(billingResult, arrayList);
            if (this.mIhandlePurchase != null) {
                JSONObject jSONObject2 = new JSONObject();
                jSONObject2.putOpt("code", Integer.valueOf(billingResult.getResponseCode()));
                str = "";
                str2 = "";
                if (billingResult.getResponseCode() == 0) {
                    z = true;
                } else {
                    z = false;
                }
                z2 = false;
                while (i < list.size()) {
                    str = (str + list.get(i).getOrderId()) + ",";
                    if (z) {
                        str2 = (str2 + list.get(i).getOrderId()) + ",";
                        z2 = true;
                    }
                }
                jSONObject2.putOpt("orderIds", str);
                this.mIhandlePurchase.onPostEventData("on_purchase_querySuccess", jSONObject2.toString());
                if (z2) {
                    this.mIhandlePurchase.onPostEventData("on_purchase_restore", str2);
                }
            }
            return;
        }
        Log.w(TAG, "Billing client was null or result code (" + billingResult.getResponseCode() + ") was bad - quitting");
        return;
        throw th;
    }

    public boolean areSubscriptionsSupported() {
        BillingResult billingResultCheckFeatureSupported = checkFeatureSupported("subscriptions");
        if (billingResultCheckFeatureSupported.getResponseCode() != 0) {
            Log.w(TAG, "areSubscriptionsSupported() got an error response: " + billingResultCheckFeatureSupported);
        }
        return billingResultCheckFeatureSupported.getResponseCode() == 0;
    }

    public void queryPurchases(boolean z, boolean z2) {
        queryPurchasesV5(z, z2);
    }

    class RunnableC10287 implements Runnable {
        final boolean val$hasINApp;
        final boolean val$hasSUBS;

        RunnableC10287(boolean z, boolean z2) {
            this.val$hasINApp = z;
            this.val$hasSUBS = z2;
        }

        @Override
        public void run() {
            new Thread(new Runnable() {
                @Override
                public void run() {
                    System.currentTimeMillis();
                    if (RunnableC10287.this.val$hasINApp) {
                        BillingManager.this.mBillingClient.queryPurchasesAsync(QueryPurchasesParams.newBuilder().setProductType("inapp").build(), new PurchasesResponseListener() {
                            public void onQueryPurchasesResponse(BillingResult billingResult, List<Purchase> list) {
                                BillingManager.this.onQueryPurchasesFinished(billingResult, list);
                            }
                        });
                    }
                    if (RunnableC10287.this.val$hasSUBS && BillingManager.this.areSubscriptionsSupported()) {
                        BillingManager.this.mBillingClient.queryPurchasesAsync(QueryPurchasesParams.newBuilder().setProductType("subs").build(), new PurchasesResponseListener() {
                            public void onQueryPurchasesResponse(BillingResult billingResult, List<Purchase> list) {
                                BillingManager.this.onQueryPurchasesFinished(billingResult, list);
                            }
                        });
                    } else if (RunnableC10287.this.val$hasSUBS) {
                        Log.i(BillingManager.TAG, "Skipped subscription purchases query since they are not supported");
                    }
                }
            }).start();
        }
    }

    private void queryPurchasesV5(boolean z, boolean z2) {
        executeServiceRequest(new RunnableC10287(z, z2));
    }

    public int CheckPayEnv() {
        int iIsGooglePlayServicesAvailable = GoogleApiAvailability.getInstance().isGooglePlayServicesAvailable(this.mActivity);
        return iIsGooglePlayServicesAvailable != 0 ? iIsGooglePlayServicesAvailable : this.mBillingClientResponseCode * 100;
    }

    public boolean ensureProductDetailsSupported(boolean z) {
        int responseCode = this.mBillingClient.isFeatureSupported("fff").getResponseCode();
        if (responseCode == 0) {
            return true;
        }
        Log.w(TAG, "PRODUCT_DETAILS unsupported response=" + responseCode);
        IHandlePurchase iHandlePurchase = this.mIhandlePurchase;
        if (iHandlePurchase == null || !z) {
            return false;
        }
        iHandlePurchase.onPurchasesFail(PRODUCT_DETAILS_NOT_SUPPORTED_TYPE, responseCode);
        return false;
    }

    public void reportPlayStoreVersionIfNeeded() {
        if (this.mHasReportedPlayStoreVersion || this.mIhandlePurchase == null) {
            return;
        }
        try {
            JSONObject jSONObject = new JSONObject();
            jSONObject.putOpt("para1", getGooglePlayServicesVersionName());
            jSONObject.putOpt("para2", getPlayStoreVersionName());
            Log.i(TAG, "reportPlayStoreVersionIfNeeded success data=" + jSONObject.toString());
            this.mIhandlePurchase.onPlayStoreVersionReady(jSONObject.toString());
            this.mHasReportedPlayStoreVersion = true;
        } catch (Exception e) {
            Log.e(TAG, "reportPlayStoreVersionIfNeeded failed", e);
        }
    }

    private String getPlayStoreVersionName() {
        return getPackageVersionName("com.android.vending", "Play Store");
    }

    private String getGooglePlayServicesVersionName() {
        return getPackageVersionName("com.google.android.gms", "Google Play services");
    }

    private String getPackageVersionName(String str, String str2) {
        try {
            PackageInfo packageInfo = this.mActivity.getPackageManager().getPackageInfo(str, 0);
            return packageInfo.versionName == null ? "" : packageInfo.versionName;
        } catch (PackageManager.NameNotFoundException e) {
            Log.w(TAG, str2 + " package not found", e);
            return "";
        } catch (Exception e2) {
            Log.e(TAG, "getPackageVersionName failed for " + str2, e2);
            return "";
        }
    }

    public void startServiceConnection(final Runnable runnable) {
        this.mBillingClient.startConnection(new BillingClientStateListener() {
            public void onBillingSetupFinished(BillingResult billingResult) {
                Log.d(BillingManager.TAG, "onBillingSetupFinished: " + billingResult.getResponseCode());
                if (billingResult.getResponseCode() == 0) {
                    BillingManager.this.mIsServiceConnected = true;
                    BillingManager.this.reportPlayStoreVersionIfNeeded();
                    Runnable runnable2 = runnable;
                    if (runnable2 != null) {
                        runnable2.run();
                    }
                }
                BillingManager.this.mBillingClientResponseCode = billingResult.getResponseCode();
            }

            public void onBillingServiceDisconnected() {
                BillingManager.this.mIsServiceConnected = false;
            }
        });
    }

    private void executeServiceRequest(Runnable runnable) {
        if (this.mIsServiceConnected) {
            runnable.run();
        } else {
            startServiceConnection(runnable);
        }
    }

    public void queryPurchaseHistory() {
        try {
            queryPurchases(true, true);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void getBillingConfig() {
        if (this.mBillingClient == null) {
            return;
        }
        executeServiceRequest(new Runnable() {
            @Override
            public void run() {
                int responseCode = BillingManager.this.mBillingClient.isFeatureSupported("ggg").getResponseCode();
                if (responseCode != 0) {
                    Log.w(BillingManager.TAG, "[ExternalCheckout] getBillingConfig unsupported response=" + responseCode);
                    try {
                        BillingManager.this.mIhandlePurchase.onPostEventData("on_purchase_configFail", String.valueOf(responseCode));
                        BillingManager.this.mIhandlePurchase.OnCallPayConfigFail(String.valueOf(responseCode));
                        return;
                    } catch (Exception e) {
                        throw new RuntimeException(e);
                    }
                }
                BillingManager.this.mBillingClient.getBillingConfigAsync(GetBillingConfigParams.newBuilder().build(), new BillingConfigResponseListener() {
                    public void onBillingConfigResponse(BillingResult billingResult, BillingConfig billingConfig) {
                        int responseCode2 = billingResult.getResponseCode();
                        if (responseCode2 == 0 && billingConfig != null) {
                            BillingManager.this.countryCode = billingConfig.getCountryCode();
                            if (BillingManager.this.mIhandlePurchase != null) {
                                BillingManager.this.mIhandlePurchase.OnCallPayConfig(BillingManager.this.countryCode);
                                return;
                            }
                            return;
                        }
                        Log.w(BillingManager.TAG, "[ExternalCheckout] getBillingConfig failed response=" + responseCode2);
                        if (BillingManager.this.mIhandlePurchase != null) {
                            try {
                                BillingManager.this.mIhandlePurchase.onPostEventData("on_purchase_configFail", String.valueOf(responseCode2));
                                BillingManager.this.mIhandlePurchase.OnCallPayConfigFail(String.valueOf(responseCode2));
                            } catch (Exception e2) {
                                throw new RuntimeException(e2);
                            }
                        }
                    }
                });
            }
        });
    }

    public void checkBillingProgramAvailability(final int i) {
        executeServiceRequest(new Runnable() {
            @Override
            public void run() {
                BillingManager.this.mBillingClient.isBillingProgramAvailableAsync(i, new BillingProgramAvailabilityListener() {
                    public void onBillingProgramAvailabilityResponse(BillingResult billingResult, BillingProgramAvailabilityDetails billingProgramAvailabilityDetails) {
                        if (BillingManager.this.mIhandlePurchase == null) {
                            return;
                        }
                        if (billingResult.getResponseCode() == 0) {
                            BillingManager.this.mIhandlePurchase.OnExternalCheckoutAvailability("OK");
                            return;
                        }
                        Log.w(BillingManager.TAG, "[ExternalCheckout] availability failed program=" + i + " response=" + billingResult.getResponseCode());
                        BillingManager.this.mIhandlePurchase.OnExternalCheckoutAvailability(BillingManager.this.buildExternalCheckoutAvailabilityResult(billingResult.getResponseCode()));
                    }
                });
            }
        });
    }

    public void checkExternalContentLinkAvailability() {
        checkBillingProgramAvailability(1);
    }

    private int resolveBillingProgram(ExternalCheckoutProgram externalCheckoutProgram) {
        if (externalCheckoutProgram == ExternalCheckoutProgram.AndroidUsExternalContent) {
            return 1;
        }
        return externalCheckoutProgram == ExternalCheckoutProgram.AndroidJapanExternalPayments ? 4 : 0;
    }

    private String buildExternalCheckoutResult(ExternalCheckoutResultCode externalCheckoutResultCode, ExternalCheckoutResultCategory externalCheckoutResultCategory, String str, ExternalCheckoutResultSource externalCheckoutResultSource) {
        try {
            JSONObject jSONObject = new JSONObject();
            jSONObject.put("code", externalCheckoutResultCode.value);
            jSONObject.put("category", externalCheckoutResultCategory.value);
            jSONObject.put("message", str == null ? "" : str);
            jSONObject.put("source", externalCheckoutResultSource.value);
            return jSONObject.toString();
        } catch (JSONException e) {
            Log.e(TAG, "[ExternalCheckout] buildExternalCheckoutResult failed", e);
            return str == null ? "" : str;
        }
    }

    public String buildExternalCheckoutFailureResult(int i, String str) {
        if (i == 1) {
            return buildExternalCheckoutResult(ExternalCheckoutResultCode.USER_CANCELLED, ExternalCheckoutResultCategory.USER_CANCELLED, str, ExternalCheckoutResultSource.NATIVE_FAILED);
        }
        return buildExternalCheckoutResult(ExternalCheckoutResultCode.LAUNCH_FAILED, ExternalCheckoutResultCategory.FAILED, str, ExternalCheckoutResultSource.NATIVE_FAILED);
    }

    public String buildExternalCheckoutAvailabilityResult(int i) {
        if (i == 0) {
            return "OK";
        }
        if (i == -2) {
            return "UNSUPPORTED";
        }
        return "UNAVAILABLE";
    }

    public void checkExternalCheckoutAvailability(ExternalCheckoutProgram externalCheckoutProgram) {
        int iResolveBillingProgram = resolveBillingProgram(externalCheckoutProgram);
        if (iResolveBillingProgram == 0) {
            IHandlePurchase iHandlePurchase = this.mIhandlePurchase;
            if (iHandlePurchase != null) {
                iHandlePurchase.OnExternalCheckoutAvailability("UNSUPPORTED");
                return;
            }
            return;
        }
        checkBillingProgramAvailability(iResolveBillingProgram);
    }

    public void createBillingProgramToken(final int i) {
        executeServiceRequest(new Runnable() {
            @Override
            public void run() {
                BillingManager.this.mBillingClient.createBillingProgramReportingDetailsAsync(BillingProgramReportingDetailsParams.newBuilder().setBillingProgram(i).build(), new BillingProgramReportingDetailsListener() {
                    public void onCreateBillingProgramReportingDetailsResponse(BillingResult billingResult, BillingProgramReportingDetails billingProgramReportingDetails) {
                        if (BillingManager.this.mIhandlePurchase == null) {
                            return;
                        }
                        if (billingResult.getResponseCode() == 0 && billingProgramReportingDetails != null) {
                            BillingManager.this.mIhandlePurchase.OnExternalCheckoutToken(billingProgramReportingDetails.getExternalTransactionToken());
                            return;
                        }
                        Log.w(BillingManager.TAG, "[ExternalCheckout] token failed program=" + i + " response=" + billingResult.getResponseCode());
                        BillingManager.this.mIhandlePurchase.OnExternalCheckoutFail(BillingManager.this.buildExternalCheckoutFailureResult(billingResult.getResponseCode(), "token:" + billingResult.getResponseCode()));
                    }
                });
            }
        });
    }

    public void createExternalContentLinkToken() {
        createBillingProgramToken(1);
    }

    public void prepareExternalCheckoutToken(ExternalCheckoutProgram externalCheckoutProgram) {
        int iResolveBillingProgram = resolveBillingProgram(externalCheckoutProgram);
        if (iResolveBillingProgram == 0) {
            IHandlePurchase iHandlePurchase = this.mIhandlePurchase;
            if (iHandlePurchase != null) {
                iHandlePurchase.OnExternalCheckoutFail(buildExternalCheckoutFailureResult(-2, "token:unsupported_program"));
                return;
            }
            return;
        }
        createBillingProgramToken(iResolveBillingProgram);
    }

    public void launchBillingProgramLink(final int i, final String str, final boolean z) {
        executeServiceRequest(new Runnable() {
            @Override
            public void run() {
                BillingManager.this.mBillingClient.launchExternalLink(BillingManager.this.mActivity, LaunchExternalLinkParams.newBuilder().setBillingProgram(i).setLinkUri(Uri.parse(str)).setLinkType(1).setLaunchMode(z ? 2 : 1).build(), new LaunchExternalLinkResponseListener() {
                    public void onLaunchExternalLinkResponse(BillingResult billingResult) {
                        if (BillingManager.this.mIhandlePurchase == null) {
                            return;
                        }
                        if (billingResult.getResponseCode() == 0) {
                            BillingManager.this.mIhandlePurchase.OnExternalCheckoutLaunch(str);
                            return;
                        }
                        int responseCode = billingResult.getResponseCode();
                        Log.w(BillingManager.TAG, "[ExternalCheckout] launch failed program=" + i + " response=" + responseCode);
                        BillingManager.this.mIhandlePurchase.OnExternalCheckoutFail(BillingManager.this.buildExternalCheckoutFailureResult(responseCode, "launch:" + responseCode));
                    }
                });
            }
        });
    }

    public void launchExternalContentLink(String str, boolean z) {
        launchBillingProgramLink(1, str, z);
    }

    public void launchExternalCheckout(ExternalCheckoutProgram externalCheckoutProgram, String str, boolean z) {
        int iResolveBillingProgram = resolveBillingProgram(externalCheckoutProgram);
        if (iResolveBillingProgram == 0) {
            try {
                Intent intent = new Intent("android.intent.action.VIEW", Uri.parse(str));
                intent.addFlags(268435456);
                this.mActivity.startActivity(intent);
                IHandlePurchase iHandlePurchase = this.mIhandlePurchase;
                if (iHandlePurchase != null) {
                    iHandlePurchase.OnExternalCheckoutLaunch(str);
                    return;
                }
                return;
            } catch (Exception e) {
                Log.e(TAG, "[ExternalCheckout] fallback launch failed", e);
                IHandlePurchase iHandlePurchase2 = this.mIhandlePurchase;
                if (iHandlePurchase2 != null) {
                    iHandlePurchase2.OnExternalCheckoutFail(buildExternalCheckoutFailureResult(6, e.toString()));
                    return;
                }
                return;
            }
        }
        launchBillingProgramLink(iResolveBillingProgram, str, z);
    }

    private BillingResult checkFeatureSupported(String str) {
        BillingResult billingResultIsFeatureSupported = this.mBillingClient.isFeatureSupported(str);
        String str2 = str + "#" + billingResultIsFeatureSupported.getResponseCode();
        if (billingResultIsFeatureSupported.getResponseCode() != 0 && this.mIhandlePurchase != null && !this.mReportedUnsupportedFeatures.containsKey(str2)) {
            try {
                this.mReportedUnsupportedFeatures.put(str2, true);
                JSONObject jSONObject = new JSONObject();
                jSONObject.putOpt("para1", str);
                jSONObject.putOpt("para2", Integer.valueOf(billingResultIsFeatureSupported.getResponseCode()));
                this.mIhandlePurchase.onPostEventJsonData("google_feature_fail", jSONObject.toString());
            } catch (Exception e) {
                Log.e(TAG, "checkFeatureSupported post event failed, featureType: " + str, e);
            }
        }
        return billingResultIsFeatureSupported;
    }

    public void getFormattedPrice(String str) {
        String str2 = this._currencyCode;
        if (str2 == null || str2.isEmpty()) {
            IHandlePurchase iHandlePurchase = this.mIhandlePurchase;
            if (iHandlePurchase != null) {
                iHandlePurchase.OnGetFormattedPrice(str + ":");
            }
            Log.d(TAG, "getFormattedPrice _currencyCode empty");
            return;
        }
        try {
            Currency currency = Currency.getInstance(this._currencyCode);
            NumberFormat currencyInstance = NumberFormat.getCurrencyInstance();
            currencyInstance.setCurrency(currency);
            String str3 = currencyInstance.format(new BigDecimal(str));
            IHandlePurchase iHandlePurchase2 = this.mIhandlePurchase;
            if (iHandlePurchase2 != null) {
                iHandlePurchase2.OnGetFormattedPrice(String.format("%s:%s", str, str3));
            }
            Log.d(TAG, "getFormattedPrice: " + str3);
        } catch (Exception e) {
            IHandlePurchase iHandlePurchase3 = this.mIhandlePurchase;
            if (iHandlePurchase3 != null) {
                iHandlePurchase3.OnGetFormattedPrice(str + ":");
            }
            Log.d(TAG, "getFormattedPrice: " + e.getMessage());
        }
    }
}
