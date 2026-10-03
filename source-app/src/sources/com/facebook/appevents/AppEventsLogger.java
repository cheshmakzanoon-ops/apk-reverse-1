package com.facebook.appevents;

import android.app.Application;
import android.content.Context;
import android.os.Bundle;
import android.webkit.WebView;
import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.AccessToken;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import com.facebook.internal.ServerProtocol;
import java.math.BigDecimal;
import java.util.Arrays;
import java.util.Currency;
import kotlin.Metadata;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000\\\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0006\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\r\u0018\u0000 -2\u00020\u0001:\u0004-./0B#\b\u0002\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007¢\u0006\u0002\u0010\bJ\u0006\u0010\r\u001a\u00020\u000eJ\u000e\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0006\u001a\u00020\u0007J\u0010\u0010\u0011\u001a\u00020\u000e2\b\u0010\u0012\u001a\u0004\u0018\u00010\u0005J\u001a\u0010\u0011\u001a\u00020\u000e2\b\u0010\u0012\u001a\u0004\u0018\u00010\u00052\b\u0010\u0013\u001a\u0004\u0018\u00010\u0014J\u0018\u0010\u0011\u001a\u00020\u000e2\b\u0010\u0012\u001a\u0004\u0018\u00010\u00052\u0006\u0010\u0015\u001a\u00020\u0016J\"\u0010\u0011\u001a\u00020\u000e2\b\u0010\u0012\u001a\u0004\u0018\u00010\u00052\u0006\u0010\u0015\u001a\u00020\u00162\b\u0010\u0013\u001a\u0004\u0018\u00010\u0014J\u0088\u0001\u0010\u0017\u001a\u00020\u000e2\b\u0010\u0018\u001a\u0004\u0018\u00010\u00052\b\u0010\u0019\u001a\u0004\u0018\u00010\u001a2\b\u0010\u001b\u001a\u0004\u0018\u00010\u001c2\b\u0010\u001d\u001a\u0004\u0018\u00010\u00052\b\u0010\u001e\u001a\u0004\u0018\u00010\u00052\b\u0010\u001f\u001a\u0004\u0018\u00010\u00052\b\u0010 \u001a\u0004\u0018\u00010\u00052\b\u0010!\u001a\u0004\u0018\u00010\"2\b\u0010#\u001a\u0004\u0018\u00010$2\b\u0010%\u001a\u0004\u0018\u00010\u00052\b\u0010&\u001a\u0004\u0018\u00010\u00052\b\u0010'\u001a\u0004\u0018\u00010\u00052\b\u0010\u0013\u001a\u0004\u0018\u00010\u0014J\u001a\u0010(\u001a\u00020\u000e2\b\u0010)\u001a\u0004\u0018\u00010\"2\b\u0010#\u001a\u0004\u0018\u00010$J$\u0010(\u001a\u00020\u000e2\b\u0010)\u001a\u0004\u0018\u00010\"2\b\u0010#\u001a\u0004\u0018\u00010$2\b\u0010\u0013\u001a\u0004\u0018\u00010\u0014J\u000e\u0010*\u001a\u00020\u000e2\u0006\u0010+\u001a\u00020\u0014J\u0018\u0010*\u001a\u00020\u000e2\u0006\u0010+\u001a\u00020\u00142\b\u0010,\u001a\u0004\u0018\u00010\u0005R\u0011\u0010\u0004\u001a\u00020\u00058F¢\u0006\u0006\u001a\u0004\b\t\u0010\nR\u000e\u0010\u000b\u001a\u00020\fX\u0082\u0004¢\u0006\u0002\n\u0000¨\u00061"}, d2 = {"Lcom/facebook/appevents/AppEventsLogger;", "", "context", "Landroid/content/Context;", "applicationId", "", SDKConstants.PARAM_ACCESS_TOKEN, "Lcom/facebook/AccessToken;", "(Landroid/content/Context;Ljava/lang/String;Lcom/facebook/AccessToken;)V", "getApplicationId", "()Ljava/lang/String;", "loggerImpl", "Lcom/facebook/appevents/AppEventsLoggerImpl;", "flush", "", "isValidForAccessToken", "", "logEvent", "eventName", "parameters", "Landroid/os/Bundle;", "valueToSum", "", "logProductItem", "itemID", "availability", "Lcom/facebook/appevents/AppEventsLogger$ProductAvailability;", "condition", "Lcom/facebook/appevents/AppEventsLogger$ProductCondition;", "description", "imageLink", "link", "title", "priceAmount", "Ljava/math/BigDecimal;", "currency", "Ljava/util/Currency;", "gtin", "mpn", "brand", "logPurchase", "purchaseAmount", "logPushNotificationOpen", "payload", "action", "Companion", "FlushBehavior", "ProductAvailability", "ProductCondition", "facebook-core_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class AppEventsLogger {
    public static final String ACTION_APP_EVENTS_FLUSHED = "com.facebook.sdk.APP_EVENTS_FLUSHED";
    public static final String APP_EVENTS_EXTRA_FLUSH_RESULT = "com.facebook.sdk.APP_EVENTS_FLUSH_RESULT";
    public static final String APP_EVENTS_EXTRA_NUM_EVENTS_FLUSHED = "com.facebook.sdk.APP_EVENTS_NUM_EVENTS_FLUSHED";

    public static final Companion INSTANCE = new Companion(null);
    private static final String TAG = AppEventsLogger.class.getCanonicalName();
    private final AppEventsLoggerImpl loggerImpl;

    public AppEventsLogger(Context context, String str, AccessToken accessToken, DefaultConstructorMarker defaultConstructorMarker) {
        this(context, str, accessToken);
    }

    @JvmStatic
    public static final void activateApp(Application application) {
        INSTANCE.activateApp(application);
    }

    @JvmStatic
    public static final void activateApp(Application application, String str) {
        INSTANCE.activateApp(application, str);
    }

    @JvmStatic
    public static final void augmentWebView(WebView webView, Context context) {
        INSTANCE.augmentWebView(webView, context);
    }

    @JvmStatic
    public static final void clearUserData() {
        INSTANCE.clearUserData();
    }

    @JvmStatic
    public static final void clearUserID() {
        INSTANCE.clearUserID();
    }

    @JvmStatic
    public static final String getAnonymousAppDeviceGUID(Context context) {
        return INSTANCE.getAnonymousAppDeviceGUID(context);
    }

    @JvmStatic
    public static final FlushBehavior getFlushBehavior() {
        return INSTANCE.getFlushBehavior();
    }

    @JvmStatic
    public static final String getUserData() {
        return INSTANCE.getUserData();
    }

    @JvmStatic
    public static final String getUserID() {
        return INSTANCE.getUserID();
    }

    @JvmStatic
    public static final void initializeLib(Context context, String str) {
        INSTANCE.initializeLib(context, str);
    }

    @JvmStatic
    public static final AppEventsLogger newLogger(Context context) {
        return INSTANCE.newLogger(context);
    }

    @JvmStatic
    public static final AppEventsLogger newLogger(Context context, AccessToken accessToken) {
        return INSTANCE.newLogger(context, accessToken);
    }

    @JvmStatic
    public static final AppEventsLogger newLogger(Context context, String str) {
        return INSTANCE.newLogger(context, str);
    }

    @JvmStatic
    public static final AppEventsLogger newLogger(Context context, String str, AccessToken accessToken) {
        return INSTANCE.newLogger(context, str, accessToken);
    }

    @JvmStatic
    public static final void onContextStop() {
        INSTANCE.onContextStop();
    }

    @JvmStatic
    public static final void setFlushBehavior(FlushBehavior flushBehavior) {
        INSTANCE.setFlushBehavior(flushBehavior);
    }

    @JvmStatic
    public static final void setInstallReferrer(String str) {
        INSTANCE.setInstallReferrer(str);
    }

    @JvmStatic
    public static final void setPushNotificationsRegistrationId(String str) {
        INSTANCE.setPushNotificationsRegistrationId(str);
    }

    @JvmStatic
    public static final void setUserData(String str, String str2, String str3, String str4, String str5, String str6, String str7, String str8, String str9, String str10) {
        INSTANCE.setUserData(str, str2, str3, str4, str5, str6, str7, str8, str9, str10);
    }

    @JvmStatic
    public static final void setUserID(String str) {
        INSTANCE.setUserID(str);
    }

    private AppEventsLogger(Context context, String str, AccessToken accessToken) {
        this.loggerImpl = new AppEventsLoggerImpl(context, str, accessToken);
    }

    @Metadata(d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0002\b\u0004\b\u0086\u0001\u0018\u00002\b\u0012\u0004\u0012\u00020\u00000\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002j\u0002\b\u0003j\u0002\b\u0004¨\u0006\u0005"}, d2 = {"Lcom/facebook/appevents/AppEventsLogger$FlushBehavior;", "", "(Ljava/lang/String;I)V", "AUTO", "EXPLICIT_ONLY", "facebook-core_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public enum FlushBehavior {
        AUTO,
        EXPLICIT_ONLY;

        public static FlushBehavior[] valuesCustom() {
            FlushBehavior[] flushBehaviorArrValuesCustom = values();
            return (FlushBehavior[]) Arrays.copyOf(flushBehaviorArrValuesCustom, flushBehaviorArrValuesCustom.length);
        }
    }

    @Metadata(d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0002\b\u0007\b\u0086\u0001\u0018\u00002\b\u0012\u0004\u0012\u00020\u00000\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002j\u0002\b\u0003j\u0002\b\u0004j\u0002\b\u0005j\u0002\b\u0006j\u0002\b\u0007¨\u0006\b"}, d2 = {"Lcom/facebook/appevents/AppEventsLogger$ProductAvailability;", "", "(Ljava/lang/String;I)V", "IN_STOCK", "OUT_OF_STOCK", "PREORDER", "AVALIABLE_FOR_ORDER", "DISCONTINUED", "facebook-core_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public enum ProductAvailability {
        IN_STOCK,
        OUT_OF_STOCK,
        PREORDER,
        AVALIABLE_FOR_ORDER,
        DISCONTINUED;

        public static ProductAvailability[] valuesCustom() {
            ProductAvailability[] productAvailabilityArrValuesCustom = values();
            return (ProductAvailability[]) Arrays.copyOf(productAvailabilityArrValuesCustom, productAvailabilityArrValuesCustom.length);
        }
    }

    @Metadata(d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0002\b\u0005\b\u0086\u0001\u0018\u00002\b\u0012\u0004\u0012\u00020\u00000\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002j\u0002\b\u0003j\u0002\b\u0004j\u0002\b\u0005¨\u0006\u0006"}, d2 = {"Lcom/facebook/appevents/AppEventsLogger$ProductCondition;", "", "(Ljava/lang/String;I)V", "NEW", "REFURBISHED", "USED", "facebook-core_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public enum ProductCondition {
        NEW,
        REFURBISHED,
        USED;

        public static ProductCondition[] valuesCustom() {
            ProductCondition[] productConditionArrValuesCustom = values();
            return (ProductCondition[]) Arrays.copyOf(productConditionArrValuesCustom, productConditionArrValuesCustom.length);
        }
    }

    public final void logEvent(String eventName) {
        this.loggerImpl.logEvent(eventName);
    }

    public final void logEvent(String eventName, double valueToSum) {
        this.loggerImpl.logEvent(eventName, valueToSum);
    }

    public final void logEvent(String eventName, Bundle parameters) {
        this.loggerImpl.logEvent(eventName, parameters);
    }

    public final void logEvent(String eventName, double valueToSum, Bundle parameters) {
        this.loggerImpl.logEvent(eventName, valueToSum, parameters);
    }

    public final void logPurchase(BigDecimal purchaseAmount, Currency currency) {
        this.loggerImpl.logPurchase(purchaseAmount, currency);
    }

    public final void logPurchase(BigDecimal purchaseAmount, Currency currency, Bundle parameters) {
        this.loggerImpl.logPurchase(purchaseAmount, currency, parameters);
    }

    public final void logPushNotificationOpen(Bundle payload) {
        Intrinsics.checkNotNullParameter(payload, "payload");
        this.loggerImpl.logPushNotificationOpen(payload, null);
    }

    public final void logPushNotificationOpen(Bundle payload, String action) {
        Intrinsics.checkNotNullParameter(payload, "payload");
        this.loggerImpl.logPushNotificationOpen(payload, action);
    }

    public final void logProductItem(String itemID, ProductAvailability availability, ProductCondition condition, String description, String imageLink, String link, String title, BigDecimal priceAmount, Currency currency, String gtin, String mpn, String brand, Bundle parameters) {
        this.loggerImpl.logProductItem(itemID, availability, condition, description, imageLink, link, title, priceAmount, currency, gtin, mpn, brand, parameters);
    }

    public final void flush() {
        this.loggerImpl.flush();
    }

    public final boolean isValidForAccessToken(AccessToken accessToken) {
        Intrinsics.checkNotNullParameter(accessToken, SDKConstants.PARAM_ACCESS_TOKEN);
        return this.loggerImpl.isValidForAccessToken(accessToken);
    }

    public final String getApplicationId() {
        return this.loggerImpl.getApplicationId();
    }

    @Metadata(d1 = {"\u0000F\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0005\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0015\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0010\u0010\t\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\fH\u0007J\u001a\u0010\t\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\f2\b\u0010\r\u001a\u0004\u0018\u00010\u0004H\u0007J\u001a\u0010\u000e\u001a\u00020\n2\u0006\u0010\u000f\u001a\u00020\u00102\b\u0010\u0011\u001a\u0004\u0018\u00010\u0012H\u0007J\b\u0010\u0013\u001a\u00020\nH\u0007J\b\u0010\u0014\u001a\u00020\nH\u0007J\u0010\u0010\u0015\u001a\u00020\u00042\u0006\u0010\u0011\u001a\u00020\u0012H\u0007J\n\u0010\u0016\u001a\u0004\u0018\u00010\u0017H\u0007J\b\u0010\u0018\u001a\u00020\u0004H\u0007J\n\u0010\u0019\u001a\u0004\u0018\u00010\u0004H\u0007J\u001a\u0010\u001a\u001a\u00020\n2\u0006\u0010\u0011\u001a\u00020\u00122\b\u0010\r\u001a\u0004\u0018\u00010\u0004H\u0007J\u0010\u0010\u001b\u001a\u00020\u001c2\u0006\u0010\u0011\u001a\u00020\u0012H\u0007J\u001a\u0010\u001b\u001a\u00020\u001c2\u0006\u0010\u0011\u001a\u00020\u00122\b\u0010\u001d\u001a\u0004\u0018\u00010\u001eH\u0007J\u001a\u0010\u001b\u001a\u00020\u001c2\u0006\u0010\u0011\u001a\u00020\u00122\b\u0010\r\u001a\u0004\u0018\u00010\u0004H\u0007J$\u0010\u001b\u001a\u00020\u001c2\u0006\u0010\u0011\u001a\u00020\u00122\b\u0010\r\u001a\u0004\u0018\u00010\u00042\b\u0010\u001d\u001a\u0004\u0018\u00010\u001eH\u0007J\b\u0010\u001f\u001a\u00020\nH\u0007J\u0010\u0010 \u001a\u00020\n2\u0006\u0010!\u001a\u00020\u0017H\u0007J\u0012\u0010\"\u001a\u00020\n2\b\u0010#\u001a\u0004\u0018\u00010\u0004H\u0007J\u0012\u0010$\u001a\u00020\n2\b\u0010%\u001a\u0004\u0018\u00010\u0004H\u0007Jl\u0010&\u001a\u00020\n2\b\u0010'\u001a\u0004\u0018\u00010\u00042\b\u0010(\u001a\u0004\u0018\u00010\u00042\b\u0010)\u001a\u0004\u0018\u00010\u00042\b\u0010*\u001a\u0004\u0018\u00010\u00042\b\u0010+\u001a\u0004\u0018\u00010\u00042\b\u0010,\u001a\u0004\u0018\u00010\u00042\b\u0010-\u001a\u0004\u0018\u00010\u00042\b\u0010.\u001a\u0004\u0018\u00010\u00042\b\u0010/\u001a\u0004\u0018\u00010\u00042\b\u00100\u001a\u0004\u0018\u00010\u0004H\u0007J\u0012\u00101\u001a\u00020\n2\b\u00102\u001a\u0004\u0018\u00010\u0004H\u0007R\u000e\u0010\u0003\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u0016\u0010\u0007\u001a\n \b*\u0004\u0018\u00010\u00040\u0004X\u0082\u0004¢\u0006\u0002\n\u0000¨\u00063"}, d2 = {"Lcom/facebook/appevents/AppEventsLogger$Companion;", "", "()V", "ACTION_APP_EVENTS_FLUSHED", "", "APP_EVENTS_EXTRA_FLUSH_RESULT", "APP_EVENTS_EXTRA_NUM_EVENTS_FLUSHED", "TAG", "kotlin.jvm.PlatformType", "activateApp", "", "application", "Landroid/app/Application;", "applicationId", "augmentWebView", "webView", "Landroid/webkit/WebView;", "context", "Landroid/content/Context;", "clearUserData", "clearUserID", "getAnonymousAppDeviceGUID", "getFlushBehavior", "Lcom/facebook/appevents/AppEventsLogger$FlushBehavior;", "getUserData", "getUserID", "initializeLib", "newLogger", "Lcom/facebook/appevents/AppEventsLogger;", SDKConstants.PARAM_ACCESS_TOKEN, "Lcom/facebook/AccessToken;", "onContextStop", "setFlushBehavior", "flushBehavior", "setInstallReferrer", "referrer", "setPushNotificationsRegistrationId", "registrationId", "setUserData", "email", "firstName", "lastName", "phone", "dateOfBirth", "gender", "city", ServerProtocol.DIALOG_PARAM_STATE, "zip", UserDataStore.COUNTRY, "setUserID", SDKConstants.PARAM_USER_ID, "facebook-core_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        @JvmStatic
        public final void activateApp(Application application) {
            Intrinsics.checkNotNullParameter(application, "application");
            AppEventsLoggerImpl.INSTANCE.activateApp(application, null);
        }

        @JvmStatic
        public final void activateApp(Application application, String applicationId) {
            Intrinsics.checkNotNullParameter(application, "application");
            AppEventsLoggerImpl.INSTANCE.activateApp(application, applicationId);
        }

        @JvmStatic
        public final void initializeLib(Context context, String applicationId) {
            Intrinsics.checkNotNullParameter(context, "context");
            AppEventsLoggerImpl.INSTANCE.initializeLib(context, applicationId);
        }

        @JvmStatic
        public final AppEventsLogger newLogger(Context context) {
            Intrinsics.checkNotNullParameter(context, "context");
            return new AppEventsLogger(context, null, 0 == true ? 1 : 0, 0 == true ? 1 : 0);
        }

        @JvmStatic
        public final AppEventsLogger newLogger(Context context, AccessToken accessToken) {
            Intrinsics.checkNotNullParameter(context, "context");
            String str = null;
            return new AppEventsLogger(context, str, accessToken, str);
        }

        @JvmStatic
        public final AppEventsLogger newLogger(Context context, String applicationId, AccessToken accessToken) {
            Intrinsics.checkNotNullParameter(context, "context");
            return new AppEventsLogger(context, applicationId, accessToken, null);
        }

        @JvmStatic
        public final AppEventsLogger newLogger(Context context, String applicationId) {
            Intrinsics.checkNotNullParameter(context, "context");
            AccessToken accessToken = null;
            return new AppEventsLogger(context, applicationId, accessToken, accessToken);
        }

        @JvmStatic
        public final FlushBehavior getFlushBehavior() {
            return AppEventsLoggerImpl.INSTANCE.getFlushBehavior();
        }

        @JvmStatic
        public final void setFlushBehavior(FlushBehavior flushBehavior) {
            Intrinsics.checkNotNullParameter(flushBehavior, "flushBehavior");
            AppEventsLoggerImpl.INSTANCE.setFlushBehavior(flushBehavior);
        }

        @JvmStatic
        public final void onContextStop() {
            AppEventsLoggerImpl.INSTANCE.onContextStop();
        }

        @JvmStatic
        public final void setPushNotificationsRegistrationId(String registrationId) {
            AppEventsLoggerImpl.INSTANCE.setPushNotificationsRegistrationId(registrationId);
        }

        @JvmStatic
        public final void augmentWebView(WebView webView, Context context) {
            Intrinsics.checkNotNullParameter(webView, "webView");
            AppEventsLoggerImpl.INSTANCE.augmentWebView(webView, context);
        }

        @JvmStatic
        public final String getUserID() {
            AnalyticsUserIDStore analyticsUserIDStore = AnalyticsUserIDStore.INSTANCE;
            return AnalyticsUserIDStore.getUserID();
        }

        @JvmStatic
        public final void setUserID(String userID) {
            AnalyticsUserIDStore analyticsUserIDStore = AnalyticsUserIDStore.INSTANCE;
            AnalyticsUserIDStore.setUserID(userID);
        }

        @JvmStatic
        public final void clearUserID() {
            AnalyticsUserIDStore analyticsUserIDStore = AnalyticsUserIDStore.INSTANCE;
            AnalyticsUserIDStore.setUserID(null);
        }

        @JvmStatic
        public final void setUserData(String email, String firstName, String lastName, String phone, String dateOfBirth, String gender, String city, String state, String zip, String country) {
            UserDataStore userDataStore = UserDataStore.INSTANCE;
            UserDataStore.setUserDataAndHash(email, firstName, lastName, phone, dateOfBirth, gender, city, state, zip, country);
        }

        @JvmStatic
        public final String getUserData() {
            UserDataStore userDataStore = UserDataStore.INSTANCE;
            return UserDataStore.getHashedUserData$facebook_core_release();
        }

        @JvmStatic
        public final void clearUserData() {
            UserDataStore userDataStore = UserDataStore.INSTANCE;
            UserDataStore.clear();
        }

        @JvmStatic
        public final String getAnonymousAppDeviceGUID(Context context) {
            Intrinsics.checkNotNullParameter(context, "context");
            return AppEventsLoggerImpl.INSTANCE.getAnonymousAppDeviceGUID(context);
        }

        @JvmStatic
        public final void setInstallReferrer(String referrer) {
            AppEventsLoggerImpl.INSTANCE.setInstallReferrer(referrer);
        }
    }
}
