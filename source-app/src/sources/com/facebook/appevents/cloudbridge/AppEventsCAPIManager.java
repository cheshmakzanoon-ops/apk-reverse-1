package com.facebook.appevents.cloudbridge;

import android.content.SharedPreferences;
import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.FacebookSdk;
import com.facebook.GraphRequest;
import com.facebook.GraphResponse;
import com.facebook.HttpMethod;
import com.facebook.LoggingBehavior;
import com.facebook.internal.Logger;
import com.facebook.internal.Utility;
import com.facebook.internal.instrument.crashshield.CrashShieldHandler;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import kotlin.ExceptionsKt;
import kotlin.Metadata;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.Intrinsics;
import kotlin.text.StringsKt;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

@Metadata(d1 = {"\u00004\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0005\n\u0002\u0010$\n\u0002\b\u0006\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\b\u0010\u0014\u001a\u00020\u0015H\u0007J\u0015\u0010\u0016\u001a\u00020\u00152\u0006\u0010\u0017\u001a\u00020\u0018H\u0000¢\u0006\u0002\b\u0019R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u0016\u0010\u0005\u001a\n \u0006*\u0004\u0018\u00010\u00040\u0004X\u0082\u0004¢\u0006\u0002\n\u0000R\u001a\u0010\u0007\u001a\u00020\bX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\t\u0010\n\"\u0004\b\u000b\u0010\fR@\u0010\u000f\u001a\u0010\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u0001\u0018\u00010\u000e2\u0014\u0010\r\u001a\u0010\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u0001\u0018\u00010\u000e8A@@X\u0080\u000e¢\u0006\f\u001a\u0004\b\u0010\u0010\u0011\"\u0004\b\u0012\u0010\u0013¨\u0006\u001a"}, d2 = {"Lcom/facebook/appevents/cloudbridge/AppEventsCAPIManager;", "", "()V", "SETTINGS_PATH", "", "TAG", "kotlin.jvm.PlatformType", "isEnabled", "", "isEnabled$facebook_core_release", "()Z", "setEnabled$facebook_core_release", "(Z)V", "valuesToSave", "", "savedCloudBridgeCredentials", "getSavedCloudBridgeCredentials$facebook_core_release", "()Ljava/util/Map;", "setSavedCloudBridgeCredentials$facebook_core_release", "(Ljava/util/Map;)V", "enable", "", "getCAPIGSettingsFromGraphResponse", "response", "Lcom/facebook/GraphResponse;", "getCAPIGSettingsFromGraphResponse$facebook_core_release", "facebook-core_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class AppEventsCAPIManager {
    private static final String SETTINGS_PATH = "/cloudbridge_settings";
    private static boolean isEnabled;
    public static final AppEventsCAPIManager INSTANCE = new AppEventsCAPIManager();
    private static final String TAG = AppEventsCAPIManager.class.getCanonicalName();

    private AppEventsCAPIManager() {
    }

    public final boolean isEnabled$facebook_core_release() {
        return isEnabled;
    }

    public final void setEnabled$facebook_core_release(boolean z) {
        isEnabled = z;
    }

    @JvmStatic
    public static final Map<String, Object> getSavedCloudBridgeCredentials$facebook_core_release() {
        String str;
        String str2;
        if (CrashShieldHandler.isObjectCrashing(AppEventsCAPIManager.class)) {
            return null;
        }
        try {
            FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
            SharedPreferences sharedPreferences = FacebookSdk.getApplicationContext().getSharedPreferences(FacebookSdk.CLOUDBRIDGE_SAVED_CREDENTIALS, 0);
            if (sharedPreferences == null) {
                return null;
            }
            String string = sharedPreferences.getString(SettingsAPIFields.DATASETID.getRawValue(), null);
            String string2 = sharedPreferences.getString(SettingsAPIFields.URL.getRawValue(), null);
            String string3 = sharedPreferences.getString(SettingsAPIFields.ACCESSKEY.getRawValue(), null);
            String str3 = string;
            if (str3 != null && !StringsKt.isBlank(str3) && (str = string2) != null && !StringsKt.isBlank(str) && (str2 = string3) != null && !StringsKt.isBlank(str2)) {
                LinkedHashMap linkedHashMap = new LinkedHashMap();
                linkedHashMap.put(SettingsAPIFields.URL.getRawValue(), string2);
                linkedHashMap.put(SettingsAPIFields.DATASETID.getRawValue(), string);
                linkedHashMap.put(SettingsAPIFields.ACCESSKEY.getRawValue(), string3);
                Logger.INSTANCE.log(LoggingBehavior.APP_EVENTS, TAG.toString(), " \n\nLoading Cloudbridge settings from saved Prefs: \n================\n DATASETID: %s\n URL: %s \n ACCESSKEY: %s \n\n ", string, string2, string3);
                return linkedHashMap;
            }
            return null;
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, AppEventsCAPIManager.class);
            return null;
        }
    }

    public final void setSavedCloudBridgeCredentials$facebook_core_release(Map<String, ? extends Object> map) {
        FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
        SharedPreferences sharedPreferences = FacebookSdk.getApplicationContext().getSharedPreferences(FacebookSdk.CLOUDBRIDGE_SAVED_CREDENTIALS, 0);
        if (sharedPreferences == null) {
            return;
        }
        if (map == null) {
            SharedPreferences.Editor editorEdit = sharedPreferences.edit();
            editorEdit.clear();
            editorEdit.apply();
            return;
        }
        Object obj = map.get(SettingsAPIFields.DATASETID.getRawValue());
        Object obj2 = map.get(SettingsAPIFields.URL.getRawValue());
        Object obj3 = map.get(SettingsAPIFields.ACCESSKEY.getRawValue());
        if (obj == null || obj2 == null || obj3 == null) {
            return;
        }
        SharedPreferences.Editor editorEdit2 = sharedPreferences.edit();
        editorEdit2.putString(SettingsAPIFields.DATASETID.getRawValue(), obj.toString());
        editorEdit2.putString(SettingsAPIFields.URL.getRawValue(), obj2.toString());
        editorEdit2.putString(SettingsAPIFields.ACCESSKEY.getRawValue(), obj3.toString());
        editorEdit2.apply();
        Logger.INSTANCE.log(LoggingBehavior.APP_EVENTS, TAG.toString(), " \n\nSaving Cloudbridge settings from saved Prefs: \n================\n DATASETID: %s\n URL: %s \n ACCESSKEY: %s \n\n ", obj, obj2, obj3);
    }

    @JvmStatic
    public static final void enable() {
        try {
            GraphRequest.Callback callback = new GraphRequest.Callback() {
                @Override
                public final void onCompleted(GraphResponse graphResponse) {
                    AppEventsCAPIManager.m2411enable$lambda0(graphResponse);
                }
            };
            FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
            GraphRequest graphRequest = new GraphRequest(null, Intrinsics.stringPlus(FacebookSdk.getApplicationId(), SETTINGS_PATH), null, HttpMethod.GET, callback, null, 32, null);
            Logger.Companion companion = Logger.INSTANCE;
            LoggingBehavior loggingBehavior = LoggingBehavior.APP_EVENTS;
            String str = TAG;
            if (str != null) {
                companion.log(loggingBehavior, str, " \n\nCreating Graph Request: \n=============\n%s\n\n ", graphRequest);
                graphRequest.executeAsync();
                return;
            }
            throw new NullPointerException("null cannot be cast to non-null type kotlin.String");
        } catch (JSONException e) {
            Logger.Companion companion2 = Logger.INSTANCE;
            LoggingBehavior loggingBehavior2 = LoggingBehavior.APP_EVENTS;
            String str2 = TAG;
            if (str2 != null) {
                companion2.log(loggingBehavior2, str2, " \n\nGraph Request Exception: \n=============\n%s\n\n ", ExceptionsKt.stackTraceToString(e));
                return;
            }
            throw new NullPointerException("null cannot be cast to non-null type kotlin.String");
        }
    }

    public static final void m2411enable$lambda0(GraphResponse graphResponse) {
        Intrinsics.checkNotNullParameter(graphResponse, "response");
        INSTANCE.getCAPIGSettingsFromGraphResponse$facebook_core_release(graphResponse);
    }

    public final void getCAPIGSettingsFromGraphResponse$facebook_core_release(GraphResponse response) {
        Intrinsics.checkNotNullParameter(response, "response");
        boolean zBooleanValue = false;
        if (response.getError() != null) {
            Logger.Companion companion = Logger.INSTANCE;
            LoggingBehavior loggingBehavior = LoggingBehavior.APP_EVENTS;
            String str = TAG;
            if (str != null) {
                companion.log(loggingBehavior, str, " \n\nGraph Response Error: \n================\nResponse Error: %s\nResponse Error Exception: %s\n\n ", response.getError().toString(), String.valueOf(response.getError().getException()));
                Map<String, Object> savedCloudBridgeCredentials$facebook_core_release = getSavedCloudBridgeCredentials$facebook_core_release();
                if (savedCloudBridgeCredentials$facebook_core_release != null) {
                    URL url = new URL(String.valueOf(savedCloudBridgeCredentials$facebook_core_release.get(SettingsAPIFields.URL.getRawValue())));
                    AppEventsConversionsAPITransformerWebRequests appEventsConversionsAPITransformerWebRequests = AppEventsConversionsAPITransformerWebRequests.INSTANCE;
                    AppEventsConversionsAPITransformerWebRequests.configure(String.valueOf(savedCloudBridgeCredentials$facebook_core_release.get(SettingsAPIFields.DATASETID.getRawValue())), url.getProtocol() + "://" + ((Object) url.getHost()), String.valueOf(savedCloudBridgeCredentials$facebook_core_release.get(SettingsAPIFields.ACCESSKEY.getRawValue())));
                    isEnabled = true;
                    return;
                }
                return;
            }
            throw new NullPointerException("null cannot be cast to non-null type kotlin.String");
        }
        Logger.Companion companion2 = Logger.INSTANCE;
        LoggingBehavior loggingBehavior2 = LoggingBehavior.APP_EVENTS;
        String str2 = TAG;
        if (str2 != null) {
            companion2.log(loggingBehavior2, str2, " \n\nGraph Response Received: \n================\n%s\n\n ", response);
            JSONObject graphObject = response.getGraphObject();
            try {
                Utility utility = Utility.INSTANCE;
                Object obj = graphObject == null ? null : graphObject.get("data");
                if (obj == null) {
                    throw new NullPointerException("null cannot be cast to non-null type org.json.JSONArray");
                }
                List<String> listConvertJSONArrayToList = Utility.convertJSONArrayToList((JSONArray) obj);
                Utility utility2 = Utility.INSTANCE;
                Map<String, ? extends Object> mapConvertJSONObjectToHashMap = Utility.convertJSONObjectToHashMap(new JSONObject((String) CollectionsKt.firstOrNull(listConvertJSONArrayToList)));
                String str3 = (String) mapConvertJSONObjectToHashMap.get(SettingsAPIFields.URL.getRawValue());
                String str4 = (String) mapConvertJSONObjectToHashMap.get(SettingsAPIFields.DATASETID.getRawValue());
                String str5 = (String) mapConvertJSONObjectToHashMap.get(SettingsAPIFields.ACCESSKEY.getRawValue());
                if (str3 == null || str4 == null || str5 == null) {
                    Logger.Companion companion3 = Logger.INSTANCE;
                    LoggingBehavior loggingBehavior3 = LoggingBehavior.APP_EVENTS;
                    Intrinsics.checkNotNullExpressionValue(str2, "TAG");
                    companion3.log(loggingBehavior3, str2, "CloudBridge Settings API response doesn't have valid data");
                    return;
                }
                try {
                    AppEventsConversionsAPITransformerWebRequests appEventsConversionsAPITransformerWebRequests2 = AppEventsConversionsAPITransformerWebRequests.INSTANCE;
                    AppEventsConversionsAPITransformerWebRequests.configure(str4, str3, str5);
                    setSavedCloudBridgeCredentials$facebook_core_release(mapConvertJSONObjectToHashMap);
                    if (mapConvertJSONObjectToHashMap.get(SettingsAPIFields.ENABLED.getRawValue()) != null) {
                        Object obj2 = mapConvertJSONObjectToHashMap.get(SettingsAPIFields.ENABLED.getRawValue());
                        if (obj2 == null) {
                            throw new NullPointerException("null cannot be cast to non-null type kotlin.Boolean");
                        }
                        zBooleanValue = ((Boolean) obj2).booleanValue();
                    }
                    isEnabled = zBooleanValue;
                    return;
                } catch (MalformedURLException e) {
                    Logger.Companion companion4 = Logger.INSTANCE;
                    LoggingBehavior loggingBehavior4 = LoggingBehavior.APP_EVENTS;
                    String str6 = TAG;
                    Intrinsics.checkNotNullExpressionValue(str6, "TAG");
                    companion4.log(loggingBehavior4, str6, "CloudBridge Settings API response doesn't have valid url\n %s ", ExceptionsKt.stackTraceToString(e));
                    return;
                }
            } catch (NullPointerException e2) {
                Logger.Companion companion5 = Logger.INSTANCE;
                LoggingBehavior loggingBehavior5 = LoggingBehavior.APP_EVENTS;
                String str7 = TAG;
                Intrinsics.checkNotNullExpressionValue(str7, "TAG");
                companion5.log(loggingBehavior5, str7, "CloudBridge Settings API response is not a valid json: \n%s ", ExceptionsKt.stackTraceToString(e2));
                return;
            } catch (JSONException e3) {
                Logger.Companion companion6 = Logger.INSTANCE;
                LoggingBehavior loggingBehavior6 = LoggingBehavior.APP_EVENTS;
                String str8 = TAG;
                Intrinsics.checkNotNullExpressionValue(str8, "TAG");
                companion6.log(loggingBehavior6, str8, "CloudBridge Settings API response is not a valid json: \n%s ", ExceptionsKt.stackTraceToString(e3));
                return;
            }
        }
        throw new NullPointerException("null cannot be cast to non-null type kotlin.String");
    }
}
