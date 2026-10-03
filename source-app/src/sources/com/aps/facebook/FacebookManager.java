package com.aps.facebook;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Environment;
import android.util.Log;
import com.facebook.AccessToken;
import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.FacebookRequestError;
import com.facebook.FacebookSdk;
import com.facebook.GraphRequest;
import com.facebook.GraphResponse;
import com.facebook.LoggingBehavior;
import com.facebook.appevents.AppEventsConstants;
import com.facebook.appevents.AppEventsLogger;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import com.facebook.login.LoginManager;
import com.facebook.login.LoginResult;
import java.math.BigDecimal;
import java.util.Arrays;
import java.util.Currency;
import java.util.Locale;
import org.json.JSONException;
import org.json.JSONObject;

public class FacebookManager {
    public static final int FB_RESULT_HAS_NOT_SIGNED_IN = -2;
    public static final int FB_RESULT_UNKNOWN = -1;
    public static final int FB_SIGN_IN = 64206;
    public static final int FB_SIGN_IN_CANCEL = 2;
    public static final int FB_SIGN_IN_SUCCESS = 0;
    public static final int FB_SIGN_OUT_SUCCESS = 1;
    private static volatile FacebookManager Instance = null;
    private static final String TAG = "FacebookManager";
    private AccessToken accessToken;
    private CallbackManager callbackManager;
    private JSONObject graphJson;
    private AppEventsLogger logger;
    private Activity mActivity;
    private FacabookSignInDelegate signInDelegate;
    private FacebookSignOutDelegate signOutDelegate;

    public interface FacabookSignInDelegate {
        void invoke(int i);
    }

    public interface FacebookSignOutDelegate {
        void invoke(int i);
    }

    public static FacebookManager getInstance() {
        FacebookManager facebookManager = Instance;
        if (facebookManager == null) {
            synchronized (FacebookManager.class) {
                facebookManager = Instance;
                if (facebookManager == null) {
                    facebookManager = new FacebookManager();
                    Instance = facebookManager;
                }
            }
        }
        return facebookManager;
    }

    public void Log(String str) {
        Log.d(TAG, str);
    }

    public void onActivityResult(int i, int i2, Intent intent) {
        CallbackManager callbackManager = this.callbackManager;
        if (callbackManager != null) {
            callbackManager.onActivityResult(i, i2, intent);
        }
    }

    public String getUserId() {
        AccessToken accessToken = this.accessToken;
        if (accessToken != null && !accessToken.isExpired()) {
            return this.accessToken.getUserId();
        }
        return "";
    }

    public String getToken() {
        AccessToken accessToken = this.accessToken;
        if (accessToken != null && !accessToken.isExpired()) {
            return this.accessToken.getToken();
        }
        return "";
    }

    public JSONObject getGraphUserAsJson() {
        return this.graphJson;
    }

    public void init(Activity activity) {
        this.mActivity = activity;
        Log("Facebook init");
    }

    public void dmaPrivacyAllowed() {
        if (this.mActivity == null) {
            return;
        }
        Log("Facebook dmaPrivacyAllowed start!");
        FacebookSdk.addLoggingBehavior(LoggingBehavior.APP_EVENTS);
        FacebookSdk.setAutoLogAppEventsEnabled(false);
        FacebookSdk.setAutoInitEnabled(true);
        FacebookSdk.fullyInitialize();
        this.logger = AppEventsLogger.newLogger(this.mActivity);
        this.callbackManager = CallbackManager.Factory.create();
        LoginManager.getInstance().registerCallback(this.callbackManager, new FacebookCallback<LoginResult>() {
            @Override
            public void onSuccess(LoginResult loginResult) {
                FacebookManager.this.Log("Facebook Login Success!");
                FacebookManager.this.accessToken = loginResult.getAccessToken();
                if (FacebookManager.this.accessToken == null || FacebookManager.this.accessToken.isExpired()) {
                    return;
                }
                GraphRequest graphRequestNewMeRequest = GraphRequest.newMeRequest(FacebookManager.this.accessToken, new GraphRequest.GraphJSONObjectCallback() {
                    @Override
                    public void onCompleted(JSONObject jSONObject, GraphResponse graphResponse) {
                        FacebookManager.this.Log("Facebook GraphRequest Complete!");
                        FacebookRequestError error = graphResponse.getError();
                        if (error != null) {
                            if (FacebookManager.this.signInDelegate != null) {
                                FacebookManager.this.signInDelegate.invoke(error.getErrorCode());
                            }
                        } else {
                            FacebookManager.this.graphJson = jSONObject;
                            if (FacebookManager.this.signInDelegate != null) {
                                FacebookManager.this.signInDelegate.invoke(0);
                            }
                        }
                    }
                });
                Bundle bundle = new Bundle();
                bundle.putString("field", "id,name,link,gender,birthday,email,picture,locale,updated_time,timezone,age_range,first_name,last_name");
                graphRequestNewMeRequest.setParameters(bundle);
                graphRequestNewMeRequest.executeAsync();
            }

            @Override
            public void onCancel() {
                FacebookManager.this.Log("Facebook Login Cancel!");
                if (FacebookManager.this.signInDelegate != null) {
                    FacebookManager.this.signInDelegate.invoke(2);
                }
            }

            @Override
            public void onError(FacebookException facebookException) {
                Log.w(FacebookManager.TAG, facebookException.getMessage());
                facebookException.printStackTrace();
                if (FacebookManager.this.signInDelegate != null) {
                    FacebookManager.this.signInDelegate.invoke(-1);
                }
            }
        });
        if (checkSDCardAvailable()) {
            return;
        }
        appEventSdCardUnAvailable(Environment.getExternalStorageState());
    }

    public boolean hasSignedIn() {
        AccessToken accessToken = this.accessToken;
        return (accessToken == null || accessToken.isExpired()) ? false : true;
    }

    public void signIn(FacabookSignInDelegate facabookSignInDelegate) {
        this.signInDelegate = facabookSignInDelegate;
        LoginManager.getInstance().logInWithReadPermissions(this.mActivity, Arrays.asList("public_profile"));
    }

    public void signOut(FacebookSignOutDelegate facebookSignOutDelegate) {
        if (hasSignedIn()) {
            LoginManager.getInstance().logOut();
            if (facebookSignOutDelegate != null) {
                facebookSignOutDelegate.invoke(1);
                return;
            }
            return;
        }
        Log.w(TAG, "Has not signed in");
        if (facebookSignOutDelegate != null) {
            facebookSignOutDelegate.invoke(-2);
        }
    }

    private void appEventSdCardUnAvailable(String str) {
        Log("appEventSdCardUnAvailable: type = " + str);
        if (this.logger != null) {
            Bundle bundle = new Bundle();
            bundle.putString("type", str);
            this.logger.logEvent("SdCardUnavailable", bundle);
        }
    }

    private boolean checkSDCardAvailable() {
        return Environment.getExternalStorageState().equals("mounted");
    }

    private String getVersionName() {
        try {
            return this.mActivity.getPackageManager().getPackageInfo(this.mActivity.getPackageName(), 0).versionName;
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    private void appEventException(String str, String str2, String str3, String str4) {
        if (this.logger != null) {
            Log("appEventException " + str + " " + str2);
            Bundle bundle = new Bundle();
            bundle.putString("function", getVersionName() + " " + str2);
            bundle.putString("cause", str3);
            bundle.putString("message", str4);
            this.logger.logEvent("Exception_" + str, bundle);
        }
    }

    public void TrackPurchase(String str, String str2) {
        try {
            JSONObject jSONObject = new JSONObject();
            jSONObject.put("itemId", str2);
            jSONObject.put("cost", str);
            Bundle bundle = new Bundle();
            bundle.putString(AppEventsConstants.EVENT_PARAM_CURRENCY, "USD");
            bundle.putString(AppEventsConstants.EVENT_PARAM_CONTENT_TYPE, "product");
            bundle.putString(AppEventsConstants.EVENT_PARAM_CONTENT, jSONObject.toString());
            this.logger.logPurchase(new BigDecimal(str), Currency.getInstance(Locale.US), bundle);
        } catch (Exception unused) {
        }
    }

    public void sendDataToNative(String str, String str2) {
        JSONObject jSONObject;
        if (str == null || str.equals("")) {
            return;
        }
        if (str2 != null) {
            try {
                if (str2.equals("")) {
                    jSONObject = null;
                } else {
                    jSONObject = new JSONObject(str2);
                }
            } catch (JSONException e) {
                appEventException(e.getClass().getName(), str, e.getCause().toString(), e.getMessage());
                e.printStackTrace();
                return;
            } catch (Exception e2) {
                appEventException(e2.getClass().getName(), str, e2.getCause().toString(), e2.getMessage());
                e2.printStackTrace();
                return;
            }
        } else {
            jSONObject = null;
        }
        if (this.logger == null) {
            Log("========facebook====SendDataToNative faild==not logger instance=");
            return;
        }
        if (str.equals("FB_" + GameEvent.setCustomerUserID)) {
            String string = jSONObject.getString("uid");
            Bundle bundle = new Bundle();
            bundle.putString("uid", string);
            this.logger.logEvent(GameEvent.setCustomerUserID, bundle);
            return;
        }
        if (str.equals("FB_" + GameEvent.app_launch)) {
            return;
        }
        if (str.equals("FB_RecordEvent")) {
            String string2 = jSONObject.getString("uid");
            String string3 = jSONObject.getString(SDKConstants.PARAM_KEY);
            Bundle bundle2 = new Bundle();
            bundle2.putString("uid", string2);
            this.logger.logEvent(string3, bundle2);
            return;
        }
        if (str.equals("FB_" + GameEvent.trackAppLaunch)) {
            this.logger.logEvent(GameEvent.trackAppLaunch);
            return;
        }
        if (str.equals("FB_" + GameEvent.click_buy_car_in_60m)) {
            String string4 = jSONObject.getString("uid");
            String string5 = jSONObject.getString("id");
            String string6 = jSONObject.getString("name");
            Bundle bundle3 = new Bundle();
            bundle3.putString("uid", string4);
            bundle3.putString(AppEventsConstants.EVENT_PARAM_CONTENT_ID, string5);
            bundle3.putString("fb_name", string6);
            bundle3.putString(AppEventsConstants.EVENT_PARAM_CONTENT_TYPE, "GiftPackage");
            this.logger.logEvent(AppEventsConstants.EVENT_NAME_ADDED_TO_CART, bundle3);
            return;
        }
        if (str.equals("FB_" + GameEvent.triggerEventLoginComplete)) {
            String string7 = jSONObject.getString("uid");
            String string8 = jSONObject.getString("uName");
            Bundle bundle4 = new Bundle();
            bundle4.putString("uid", string7);
            bundle4.putString("uName", string8);
            this.logger.logEvent(GameEvent.triggerEventLoginComplete, bundle4);
            return;
        }
        if (str.equals("FB_" + GameEvent.EventCompletedRegistration)) {
            String string9 = jSONObject.getString("uid");
            String string10 = jSONObject.getString("uName");
            Bundle bundle5 = new Bundle();
            bundle5.putString("uid", string9);
            bundle5.putString("uName", string10);
            this.logger.logEvent(AppEventsConstants.EVENT_NAME_COMPLETED_REGISTRATION, bundle5);
            return;
        }
        if (str.equals("FB_" + GameEvent.fbEventCompletedTutorial)) {
            String string11 = jSONObject.getString("uid");
            Bundle bundle6 = new Bundle();
            bundle6.putString("uid", string11);
            this.logger.logEvent(GameEvent.fbEventCompletedTutorial, bundle6);
            return;
        }
        if (str.equals("FB_" + GameEvent.EventLevelUp)) {
            String string12 = jSONObject.getString("lv");
            Bundle bundle7 = new Bundle();
            bundle7.putString(AppEventsConstants.EVENT_PARAM_LEVEL, string12);
            this.logger.logEvent(AppEventsConstants.EVENT_NAME_ACHIEVED_LEVEL, bundle7);
            return;
        }
        if (str.equals("FB_" + GameEvent.EventPurchase)) {
            String string13 = jSONObject.getString("cost");
            Bundle bundle8 = new Bundle();
            bundle8.putString(AppEventsConstants.EVENT_PARAM_CURRENCY, "USD");
            bundle8.putString(AppEventsConstants.EVENT_PARAM_CONTENT_TYPE, "product");
            bundle8.putString(AppEventsConstants.EVENT_PARAM_CONTENT, str2);
            this.logger.logPurchase(new BigDecimal(string13), Currency.getInstance(Locale.US), bundle8);
            return;
        }
        if (str.equals("FB_" + GameEvent.EventSpeedUp)) {
            String string14 = jSONObject.getString("user_level");
            String string15 = jSONObject.getString("castle_level");
            String string16 = jSONObject.getString("type");
            String string17 = jSONObject.getString("spend");
            Bundle bundle9 = new Bundle();
            bundle9.putString("user_level", string14);
            bundle9.putString("castle_level", string15);
            bundle9.putString("type", string16);
            bundle9.putString("spend", string17);
            this.logger.logEvent(GameEvent.EventSpeedUp, bundle9);
            return;
        }
        if (str.equals("FB_" + GameEvent.EventGiftPackage)) {
            String string18 = jSONObject.getString("package_entracnce");
            String string19 = jSONObject.getString("package_name");
            String string20 = jSONObject.getString("package_id");
            String string21 = jSONObject.getString("user_level");
            String string22 = jSONObject.getString("user_castle");
            Bundle bundle10 = new Bundle();
            bundle10.putString("package_entracnce", string18);
            bundle10.putString("package_name", string19);
            bundle10.putString("package_id", string20);
            bundle10.putString("user_level", string21);
            bundle10.putString("user_castle", string22);
            this.logger.logEvent(GameEvent.EventGiftPackage, bundle10);
            return;
        }
        if (str.equals("FB_" + GameEvent.EventAllianceHonorExchange)) {
            String string23 = jSONObject.getString("alliance_item_name");
            String string24 = jSONObject.getString("alliance_item_id");
            String string25 = jSONObject.getString("user_level");
            String string26 = jSONObject.getString("user_castle");
            String string27 = jSONObject.getString("user_alliance_level");
            Bundle bundle11 = new Bundle();
            bundle11.putString("alliance_item_name", string23);
            bundle11.putString("alliance_item_id", string24);
            bundle11.putString("user_level", string25);
            bundle11.putString("user_castle", string26);
            bundle11.putString("user_alliance_level", string27);
            this.logger.logEvent(GameEvent.EventAllianceHonorExchange, bundle11);
            return;
        }
        if (str.equals("FB_" + GameEvent.EventAllianceTalkMore)) {
            String string28 = jSONObject.getString("uid");
            Bundle bundle12 = new Bundle();
            bundle12.putString("uid", string28);
            this.logger.logEvent(GameEvent.EventAllianceTalkMore, bundle12);
            return;
        }
        if (str.equals("FB_" + GameEvent.FBEventDone)) {
            String string29 = jSONObject.getString("uid");
            String string30 = jSONObject.getString("eventName");
            Bundle bundle13 = new Bundle();
            bundle13.putString("uid", string29);
            this.logger.logEvent(string30, bundle13);
        }
    }
}
