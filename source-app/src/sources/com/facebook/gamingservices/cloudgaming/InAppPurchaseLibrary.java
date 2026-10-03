package com.facebook.gamingservices.cloudgaming;

import android.content.Context;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import com.facebook.gamingservices.cloudgaming.internal.SDKLogger;
import com.facebook.gamingservices.cloudgaming.internal.SDKMessageEnum;
import org.json.JSONException;
import org.json.JSONObject;

public class InAppPurchaseLibrary {
    public static void onReady(Context context, DaemonRequest.Callback callback) {
        DaemonRequest.executeAsync(context, (JSONObject) null, callback, SDKMessageEnum.ON_READY);
    }

    public static void getCatalog(Context context, DaemonRequest.Callback callback) {
        DaemonRequest.executeAsync(context, (JSONObject) null, callback, SDKMessageEnum.GET_CATALOG);
    }

    public static void getPurchases(Context context, DaemonRequest.Callback callback) {
        DaemonRequest.executeAsync(context, (JSONObject) null, callback, SDKMessageEnum.GET_PURCHASES);
    }

    public static void purchase(Context context, String productID, String developerPayload, DaemonRequest.Callback callback) {
        try {
            DaemonRequest.executeAsync(context, new JSONObject().put(SDKConstants.PARAM_PRODUCT_ID, productID).put(SDKConstants.PARAM_DEVELOPER_PAYLOAD, developerPayload), callback, SDKMessageEnum.PURCHASE);
        } catch (JSONException e) {
            SDKLogger.logInternalError(context, SDKMessageEnum.PURCHASE, e);
        }
    }

    public static void consumePurchase(Context context, String purchaseToken, DaemonRequest.Callback callback) {
        try {
            DaemonRequest.executeAsync(context, new JSONObject().put(SDKConstants.PARAM_PURCHASE_TOKEN, purchaseToken), callback, SDKMessageEnum.CONSUME_PURCHASE);
        } catch (JSONException e) {
            SDKLogger.logInternalError(context, SDKMessageEnum.CONSUME_PURCHASE, e);
        }
    }

    public static void getSubscribableCatalog(Context context, DaemonRequest.Callback callback) {
        DaemonRequest.executeAsync(context, (JSONObject) null, callback, SDKMessageEnum.GET_SUBSCRIBABLE_CATALOG);
    }

    public static void purchaseSubscription(Context context, String productID, DaemonRequest.Callback callback) {
        try {
            DaemonRequest.executeAsync(context, new JSONObject().put(SDKConstants.PARAM_PRODUCT_ID, productID), callback, SDKMessageEnum.PURCHASE_SUBSCRIPTION);
        } catch (JSONException e) {
            SDKLogger.logInternalError(context, SDKMessageEnum.PURCHASE_SUBSCRIPTION, e);
        }
    }

    public static void getSubscriptions(Context context, DaemonRequest.Callback callback) {
        DaemonRequest.executeAsync(context, (JSONObject) null, callback, SDKMessageEnum.GET_SUBSCRIPTIONS);
    }

    public static void cancelSubscription(Context context, String purchaseToken, DaemonRequest.Callback callback) {
        try {
            DaemonRequest.executeAsync(context, new JSONObject().put(SDKConstants.PARAM_PURCHASE_TOKEN, purchaseToken), callback, SDKMessageEnum.CANCEL_SUBSCRIPTION);
        } catch (JSONException e) {
            SDKLogger.logInternalError(context, SDKMessageEnum.CANCEL_SUBSCRIPTION, e);
        }
    }
}
