package com.sdkmanager;

import android.app.Activity;
import android.content.ContentResolver;
import android.content.ContentUris;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.content.pm.Signature;
import android.database.Cursor;
import android.hardware.Sensor;
import android.hardware.SensorManager;
import android.net.Uri;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Environment;
import android.os.Handler;
import android.provider.CalendarContract;
import android.provider.MediaStore;
import android.telephony.TelephonyManager;
import android.text.TextUtils;
import android.util.Log;
import androidx.core.app.ActivityCompat;
import com.android.installreferrer.api.InstallReferrerClient;
import com.android.installreferrer.api.InstallReferrerStateListener;
import com.appsflyer.AppsFlyerController;
import com.aps.facebook.FacebookManager;
import com.example.updateandinstall.UpdateManager;
import com.google.android.gms.common.Scopes;
import com.google.android.gms.common.internal.ImagesContract;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.android.play.core.review.ReviewInfo;
import com.google.android.play.core.review.ReviewManager;
import com.google.android.play.core.review.ReviewManagerFactory;
import com.google.common.base.Ascii;
import com.google.firebase.analytics.FirebaseAnalytics;
import com.google.firebase.messaging.Constants;
import com.googleplayservice.GooglePlayManager;
import com.googleplayservice.PGSManager;
import com.googleplayservice.billing.ExternalCheckoutProgram;
import com.googleplayservice.billing.PayGoogle;
import com.googleplayservice.billing.Payment;
import com.head.TakePhotoController;
import com.ishumei.smantifraud.l111l1111llIl;
import com.ishumei.smantifraud.l11l11I1111l;
import com.ishumei.smantifraud.l11l11lI1lll;
import com.sdkmanager.utils.Device;
import com.sdkmanager.utils.Udid;
import com.sdkmanager.zendesk.ZendeskManager;
import com.unity3d.player.C1087R;
import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.util.ArrayList;
import java.util.Locale;
import java.util.TimeZone;
import java.util.concurrent.Executors;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import ru.mopsicus.common.IDataSender;

public class SdkManager implements IDataSender {
    private static final String APP_STORAGE_SIZE_FUNC = "LW_GetAppStorageSize";
    private static final int EXTERNAL_CHECKOUT_RESULT_CATEGORY_FAILED = 2;
    private static final int EXTERNAL_CHECKOUT_RESULT_CODE_LAUNCH_FAILED = 3;
    private static final int EXTERNAL_CHECKOUT_RESULT_SOURCE_NATIVE_FAILED = 1;
    public static final String IN_APP_REVIEW = "in_app_review";
    private static volatile SdkManager Instance = null;
    private static final String TAG = "SdkManager";
    private String _gaid;
    private int accountFuncType;
    private boolean changeAccount;
    private int currentPlatform;
    private boolean isBind;
    private Activity mActivity;
    private SdkListener mListener;
    private PayGoogle m_payGoogle;
    private ReviewInfo reviewInfo;
    private ReviewManager reviewManager;
    private boolean isAppInForeground = false;
    private String strVersionCode = "";

    public enum SignInPlatform {
        Defualt,
        GooglePlay,
        FaceBook
    }

    private void onGooglePayInitialized(int i) {
    }

    public static SdkManager getInstance() {
        SdkManager sdkManager = Instance;
        if (sdkManager == null) {
            synchronized (SdkManager.class) {
                sdkManager = Instance;
                if (sdkManager == null) {
                    sdkManager = new SdkManager();
                    Instance = sdkManager;
                }
            }
        }
        return sdkManager;
    }

    private void Log(String str) {
        Log.d(TAG, str);
    }

    public SdkListener getSdkListener() {
        return this.mListener;
    }

    public Context GetContext() {
        return this.mActivity;
    }

    public void onActivityResult(int i, int i2, Intent intent) {
        StringBuilder sb = new StringBuilder("onActivityResult: requestCode = ");
        sb.append(i);
        sb.append(", resultCode = ");
        sb.append(i2);
        sb.append(", intentData = ");
        sb.append(intent == null ? "null" : intent.getAction());
        Log(sb.toString());
        if (i == 9001) {
            GooglePlayManager.getInstance().checkSignInResultFromIntent(intent, new SdkManager$$ExternalSyntheticLambda4(this));
        } else {
            if (i == 9002) {
                GooglePlayManager.getInstance().checkSignInResultFromIntent(intent, new SdkManager$$ExternalSyntheticLambda5(this));
                return;
            }
            if (i == 10086) {
                UpdateManager.getInstance().downloadApk();
            }
            AppUtilManager.getInstance().onActivityResult(i, i2, intent);
        }
    }

    public void onRequestPermissionsResult(int i, String[] strArr, int[] iArr) {
        AppUtilManager.getInstance().onRequestPermissionsResult(i, strArr, iArr);
        try {
            JSONObject jSONObject = new JSONObject();
            jSONObject.put("requestCode", i);
            JSONArray jSONArray = new JSONArray();
            for (String str : strArr) {
                jSONArray.put(str);
            }
            jSONObject.put("permissions", jSONArray);
            JSONArray jSONArray2 = new JSONArray();
            for (int i2 : iArr) {
                jSONArray2.put(i2);
            }
            jSONObject.put("grantResults", jSONArray2);
            JSONArray jSONArray3 = new JSONArray();
            for (int i3 = 0; i3 < strArr.length; i3++) {
                String str2 = strArr[i3];
                if (iArr[i3] == -1) {
                    jSONArray3.put(ActivityCompat.shouldShowRequestPermissionRationale(this.mActivity, str2) ? 1 : 0);
                } else {
                    jSONArray3.put(1);
                }
            }
            jSONObject.put("shouldShowRationale", jSONArray3);
            jSONObject.toString();
            this.mListener.SendDataToGame("onRequestPermissionsResult", jSONObject.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void onResume() {
        this.isAppInForeground = true;
    }

    public void onPause() {
        this.isAppInForeground = false;
    }

    public void init(Activity activity, SdkListener sdkListener) {
        this.mActivity = activity;
        this.mListener = sdkListener;
        Log("init begin");
        try {
            String country = Locale.getDefault().getCountry();
            String property = System.getProperty("user.region");
            Log("user.region = " + property);
            String networkCountryIso = "";
            try {
                TelephonyManager telephonyManager = (TelephonyManager) this.mActivity.getSystemService("phone");
                if (telephonyManager != null && telephonyManager.getSimState() == 5 && (networkCountryIso = telephonyManager.getNetworkCountryIso()) != null) {
                    networkCountryIso = networkCountryIso.toUpperCase();
                    Log("countryISO = " + networkCountryIso);
                }
            } catch (Exception unused) {
                Log.d(">>>> TelephonyManager ", ">>>> TelephonyManager Exception");
            }
            if (country != null && !country.isEmpty()) {
                JSONObject jSONObject = new JSONObject();
                jSONObject.put("1", country);
                if (property != null && !property.isEmpty()) {
                    jSONObject.put("2", property);
                }
                if (networkCountryIso != null && !networkCountryIso.isEmpty()) {
                    jSONObject.put("3", networkCountryIso);
                }
                Log("fromCountry = " + country);
                this.mListener.SendDataToGame("setFromCountry", jSONObject.toString());
            }
            Device.init(this.mActivity);
            PackageInfo packageInfo = this.mActivity.getPackageManager().getPackageInfo(this.mActivity.getPackageName(), 16384);
            if (packageInfo != null) {
                String str = packageInfo.versionName;
                int i = packageInfo.versionCode;
                JSONObject jSONObject2 = new JSONObject();
                jSONObject2.put("1", str);
                jSONObject2.put("2", String.valueOf(i));
                this.mListener.SendDataToGame("setVersionAndCode", jSONObject2.toString());
            }
            GooglePlayManager.getInstance().init(this.mActivity);
            AppUtilManager.getInstance().init(this.mActivity);
            Log("AppUtilManager init ok");
            TakePhotoController.getInstance().init(this.mActivity);
            FireBaseController.getInstance().init(this.mActivity);
            SmSdkManager.getInstance().init(this.mActivity);
            PGSManager.init(this.mActivity, this);
            FacebookManager.getInstance().init(this.mActivity);
            ZendeskManager.getInstance().init(this.mActivity);
            try {
                UpdateManager.getInstance().InitContext(this.mActivity, AppUtilManager.getInstance().getPublishChannel());
            } catch (Exception unused2) {
                Log.d(">>>> lsz CheckCn ", ">>>> lsz CheckCnApkDownloa Empire: 4444");
            }
            JSONObject jSONObject3 = new JSONObject();
            jSONObject3.put("1", GooglePlayManager.getInstance().isAvailable);
            this.mListener.SendDataToGame("onSDKInit", jSONObject3.toString());
        } catch (Exception e) {
            Log.d(">>>> lsz init error ", e.getMessage());
            e.printStackTrace();
        }
        new GetGAIDTask().execute(new String[0]);
    }

    public void InitGooglePay() {
        getInstance().PostEvent("gp_pay_init", "");
        if (GooglePlayManager.getInstance().isAvailable) {
            getInstance().PostEvent("gp_pay_init_env_ok", "");
            PayGoogle payGoogle = new PayGoogle();
            this.m_payGoogle = payGoogle;
            payGoogle.init(this.mActivity);
            this.m_payGoogle.setIGamePurchaseInterface(new Payment.IGamePurchase() {
                @Override
                public void onPurchasesFail(String str) {
                    SdkManager.this.mListener.SendDataToGame("onPurchaseCallback", str);
                }

                @Override
                public void callPaySuccess(String str) {
                    SdkManager.getInstance().PostEvent("gp_pay_callinfo_success", "");
                    SdkManager.this.mListener.SendDataToGame("onPurchaseCallback", str);
                }

                @Override
                public void onCallPayInfo(String str) {
                    SdkManager.this.mListener.SendDataToGame("onPurchaseQueried", str);
                }

                @Override
                public void onCallPayInfoFail(String str) {
                    SdkManager.this.mListener.SendDataToGame("onCallPayInfoFail", str);
                }

                @Override
                public void onCallPayConfig(String str) {
                    SdkManager.this.mListener.SendDataToGame("onCallPayConfig", str);
                }

                @Override
                public void onCallPayConfigFail(String str) {
                    SdkManager.this.mListener.SendDataToGame("onCallPayConfigFail", str);
                }

                @Override
                public void onGetFormattedPrice(String str) {
                    SdkManager.this.mListener.SendDataToGame("onGetFormattedPrice", str);
                }

                @Override
                public void onExternalCheckoutAvailability(String str) {
                    SdkManager.this.mListener.SendDataToGame("onExternalCheckoutAvailability", str);
                }

                @Override
                public void onExternalCheckoutToken(String str) {
                    SdkManager.this.mListener.SendDataToGame("onExternalCheckoutToken", str);
                }

                @Override
                public void onExternalCheckoutLaunch(String str) {
                    SdkManager.this.mListener.SendDataToGame("onExternalCheckoutLaunchApproved", str);
                }

                @Override
                public void onExternalCheckoutFail(String str) {
                    SdkManager.this.mListener.SendDataToGame("onExternalCheckoutFailed", str);
                }
            });
            this.m_payGoogle.setIPostEventInterface(new Payment.IPostEventHandler() {
                @Override
                public void onPostEvent(String str) {
                    SdkManager.getInstance().PostEvent(str, "");
                }

                @Override
                public void onPostEventData(String str, String str2) {
                    SdkManager.getInstance().PostEvent(str, str2);
                }

                @Override
                public void onPostEventJsonData(String str, String str2) {
                    SdkManager.getInstance().PostEventJsonData(str, str2);
                }
            });
            this.m_payGoogle.doInit();
            return;
        }
        getInstance().PostEvent("gp_pay_init_env_error", "");
    }

    public void signIn(String str) {
        try {
            JSONObject jSONObject = new JSONObject(str);
            this.currentPlatform = jSONObject.getInt("platform");
            this.isBind = jSONObject.getBoolean("isBind");
            this.changeAccount = jSONObject.getBoolean("changeAccount");
            if (this.currentPlatform == SignInPlatform.GooglePlay.ordinal()) {
                getInstance().PostEvent("google_signin_google", "");
                if (GooglePlayManager.getInstance().hasSignedIn()) {
                    getInstance().PostEvent("google_signin_nativelogined", "");
                    if (!this.changeAccount) {
                        getInstance().PostEvent("google_signin_tosendgame", "");
                        onSignInCallback(0);
                    } else {
                        GooglePlayManager.getInstance().signOut(new GooglePlayManager.GooglePlaySignOutDelegate() {
                            @Override
                            public final void invoke(int i) {
                                this.f$0.m798lambda$signIn$0$comsdkmanagerSdkManager(i);
                            }
                        });
                    }
                } else {
                    getInstance().PostEvent("google_signin_torequest", "");
                    GooglePlayManager.getInstance().signIn(new SdkManager$$ExternalSyntheticLambda4(this), GooglePlayManager.GP_SIGN_IN);
                }
            }
        } catch (Exception e) {
            getInstance().PostEvent("google_signin_exception", "");
            Log("Error JsonData = " + str);
            e.printStackTrace();
        }
    }

    void m798lambda$signIn$0$comsdkmanagerSdkManager(int i) {
        GooglePlayManager.getInstance().signIn(new SdkManager$$ExternalSyntheticLambda4(this), GooglePlayManager.GP_SIGN_IN);
    }

    public void SetAccountFunc(String str) {
        try {
            JSONObject jSONObject = new JSONObject(str);
            this.currentPlatform = jSONObject.getInt("platform");
            this.accountFuncType = jSONObject.getInt("accountFuncType");
            if (this.currentPlatform == SignInPlatform.GooglePlay.ordinal()) {
                getInstance().PostEvent("google_signin_google", "");
                int i = this.accountFuncType;
                if (i == 1 || i == 2 || i == 3 || i == 4) {
                    GooglePlayManager.getInstance().signOut(new GooglePlayManager.GooglePlaySignOutDelegate() {
                        @Override
                        public final void invoke(int i2) {
                            this.f$0.m795lambda$SetAccountFunc$1$comsdkmanagerSdkManager(i2);
                        }
                    });
                }
            }
        } catch (Exception e) {
            getInstance().PostEvent("google_signin_exception", "");
            Log("Error JsonData = " + str);
            e.printStackTrace();
        }
    }

    void m795lambda$SetAccountFunc$1$comsdkmanagerSdkManager(int i) {
        GooglePlayManager.getInstance().signIn(new SdkManager$$ExternalSyntheticLambda5(this), GooglePlayManager.GP_SET_ACCOUNT_FUNC);
    }

    public void PostEvent(String str, String str2) {
        try {
            JSONObject jSONObject = new JSONObject();
            jSONObject.put("eventName", str);
            jSONObject.put("data", str2);
            this.mListener.SendDataToGame("PostEventData", jSONObject.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void PostEventJsonData(String str, String str2) {
        try {
            JSONObject jSONObject = new JSONObject();
            jSONObject.put("eventName", str);
            jSONObject.put("data", str2);
            this.mListener.SendDataToGame("PostEventJsonData", jSONObject.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void onSignInCallback(int i) {
        JSONObject jSONObject = new JSONObject();
        try {
            getInstance().PostEvent("google_signin_recv", "");
            if (this.currentPlatform == SignInPlatform.GooglePlay.ordinal()) {
                if (i != 0) {
                    getInstance().PostEvent("google_signin_loginfail", "");
                    jSONObject.put("errorNo", String.valueOf(i));
                } else {
                    String displayName = GooglePlayManager.getInstance().getDisplayName();
                    getInstance().PostEvent("google_signin_loginsuccess", "");
                    jSONObject.put("displayName", displayName);
                    jSONObject.put("uid", GooglePlayManager.getInstance().getId());
                    jSONObject.put(Scopes.EMAIL, GooglePlayManager.getInstance().getEmail());
                    jSONObject.put("idToken", GooglePlayManager.getInstance().getToken());
                }
            }
            jSONObject.put("isBind", this.isBind);
        } catch (Exception e) {
            e.toString();
        }
        if (getInstance().getSdkListener() != null) {
            getInstance().getSdkListener().SendDataToGame("onSignInCallback", jSONObject.toString());
        }
    }

    public void OnSetAccountFuncCallback(int i) {
        JSONObject jSONObject = new JSONObject();
        try {
            getInstance().PostEvent("google_signin_recv", "");
            if (this.currentPlatform == SignInPlatform.GooglePlay.ordinal()) {
                if (i != 0) {
                    getInstance().PostEvent("google_signin_loginfail", "");
                    jSONObject.put("errorNo", String.valueOf(i));
                } else {
                    String displayName = GooglePlayManager.getInstance().getDisplayName();
                    getInstance().PostEvent("google_signin_loginsuccess", "");
                    jSONObject.put("displayName", displayName);
                    jSONObject.put("uid", GooglePlayManager.getInstance().getId());
                    jSONObject.put(Scopes.EMAIL, GooglePlayManager.getInstance().getEmail());
                    jSONObject.put("idToken", GooglePlayManager.getInstance().getToken());
                }
            }
            jSONObject.put("accountFuncType", this.accountFuncType);
        } catch (Exception e) {
            e.toString();
        }
        if (getInstance().getSdkListener() != null) {
            getInstance().getSdkListener().SendDataToGame("OnSetAccountFuncCallback", jSONObject.toString());
        }
    }

    public void signOut() {
        if (this.currentPlatform == SignInPlatform.GooglePlay.ordinal()) {
            GooglePlayManager.getInstance().signOut(new GooglePlayManager.GooglePlaySignOutDelegate() {
                @Override
                public final void invoke(int i) {
                    this.f$0.onSignOutCallback(i);
                }
            });
        } else {
            Log("Has not signed in");
            onSignOutCallback(-2);
        }
    }

    public void onSignOutCallback(int i) {
        JSONObject jSONObject = new JSONObject();
        try {
            jSONObject.put("code", String.valueOf(i));
            this.mListener.SendDataToGame("onSignOutCallback", jSONObject.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void pay(int i, String str) {
        if (str == null || str.isEmpty()) {
            Log.e(TAG, "jsonData is null in payment");
            return;
        }
        Log("Start Purchase Flow..." + str);
        try {
            JSONObject jSONObject = new JSONObject(str);
            if (i == 1) {
                this.m_payGoogle.buyGold(jSONObject.optString("skuId"), jSONObject.optString("itemId"), jSONObject.optBoolean("bRegister"));
            }
            getInstance().PostEvent("on_purchase_nativePay", str);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void consumeProduct(String str, int i) {
        PayGoogle payGoogle = this.m_payGoogle;
        if (payGoogle != null) {
            payGoogle.consumeCallback(str, i);
        }
    }

    private void onPurchaseQueried(String str) {
        this.mListener.SendDataToGame("onPurchaseQueried", str);
    }

    private void onPurchaseSuccess(String str) {
        this.mListener.SendDataToGame("onPurchaseCallback", str);
    }

    private void onConsumeSuccess(String str) {
        this.mListener.SendDataToGame("onConsumeSuccess", str);
    }

    public String getVersionCode() {
        if (this.mActivity == null) {
            return "";
        }
        try {
            if (!this.strVersionCode.isEmpty()) {
                return this.strVersionCode;
            }
            try {
                try {
                    String strValueOf = String.valueOf(this.mActivity.getPackageManager().getPackageInfo(this.mActivity.getPackageName(), 1).versionCode);
                    this.strVersionCode = strValueOf;
                    return strValueOf;
                } catch (Exception e) {
                    e.printStackTrace();
                    return this.strVersionCode;
                }
            } catch (NoSuchMethodError e2) {
                e2.printStackTrace();
                return this.strVersionCode;
            }
        } catch (Throwable unused) {
            return this.strVersionCode;
        }
    }

    public void sendDataToNative(String str, String str2) throws Throwable {
        Log("sendDataToNative: funcName = " + str + ", data = " + str2);
        if (str.equals("RequestStoreReview")) {
            RequestInAppReview();
            return;
        }
        if (str.startsWith("AIHelp_")) {
            return;
        }
        if (str.startsWith("PM_")) {
            AppUtilManager.getInstance().SendDataToNative(str, str2);
            AppsFlyerController.getInstance().SendDataToNative(str, str2);
            return;
        }
        if (str.startsWith("Zendesk_")) {
            ZendeskManager.getInstance().SendDataToNative(str, str2);
            return;
        }
        if (str.startsWith("PUSH_")) {
            PushUtilManager.getInstance().sendDataToNative(str, str2);
            return;
        }
        if (str.startsWith("FB_")) {
            FacebookManager.getInstance().sendDataToNative(str, str2);
            return;
        }
        if (str.startsWith("PGS_")) {
            PGSManager.sendDataToNative(str, str2);
            return;
        }
        byte b = 6;
        if (str.startsWith("Pay_")) {
            try {
                switch (str.hashCode()) {
                    case -898713998:
                        if (str.equals("Pay_queryPurchase")) {
                            b = 1;
                        } else {
                            b = -1;
                        }
                        break;
                    case -795237416:
                        if (str.equals("Pay_prepareExternalCheckoutToken")) {
                            b = 5;
                        } else {
                            b = -1;
                        }
                        break;
                    case 473516443:
                        if (!str.equals("Pay_launchExternalCheckout")) {
                            b = -1;
                        }
                        break;
                    case 1495734158:
                        if (str.equals("Pay_getFormattedCurrency")) {
                            b = 3;
                        } else {
                            b = -1;
                        }
                        break;
                    case 1552909446:
                        if (str.equals("Pay_querySkuDetailsAsync")) {
                            b = 0;
                        } else {
                            b = -1;
                        }
                        break;
                    case 1615084893:
                        if (str.equals("Pay_checkExternalCheckoutAvailability")) {
                            b = 4;
                        } else {
                            b = -1;
                        }
                        break;
                    case 1863618750:
                        if (str.equals("Pay_getBillingConfig")) {
                            b = 2;
                        } else {
                            b = -1;
                        }
                        break;
                    default:
                        b = -1;
                        break;
                }
                switch (b) {
                    case 0:
                        JSONObject jSONObject = new JSONObject(str2);
                        String strOptString = jSONObject.optString(l11l11I1111l.l111l1111l1Il);
                        JSONArray jSONArrayOptJSONArray = jSONObject.optJSONArray("list");
                        ArrayList arrayList = new ArrayList();
                        for (int i = 0; i < jSONArrayOptJSONArray.length(); i++) {
                            arrayList.add(jSONArrayOptJSONArray.optString(i));
                        }
                        PayGoogle payGoogle = this.m_payGoogle;
                        if (payGoogle != null) {
                            payGoogle.querySkuDetailsAsync(strOptString, arrayList);
                        }
                        break;
                    case 1:
                        PayGoogle payGoogle2 = this.m_payGoogle;
                        if (payGoogle2 != null) {
                            payGoogle2.queryPurchaseOrder();
                        }
                        try {
                            getInstance().PostEvent("on_purchase_check", "");
                        } catch (Exception unused) {
                            return;
                        }
                        break;
                    case 2:
                        PayGoogle payGoogle3 = this.m_payGoogle;
                        if (payGoogle3 != null) {
                            payGoogle3.getBillingConfig();
                        }
                        break;
                    case 3:
                        PayGoogle payGoogle4 = this.m_payGoogle;
                        if (payGoogle4 != null) {
                            payGoogle4.getFormattedPrice(str2);
                        }
                        break;
                    case 4:
                        if (canHandleExternalCheckoutRequest()) {
                            this.m_payGoogle.checkExternalCheckoutAvailability(parseExternalCheckoutProgram(str2));
                        } else {
                            notifyExternalCheckoutAvailability("UNAVAILABLE");
                        }
                        break;
                    case 5:
                        if (canHandleExternalCheckoutRequest()) {
                            this.m_payGoogle.prepareExternalCheckoutToken(parseExternalCheckoutProgram(str2));
                        } else {
                            notifyExternalCheckoutUnavailable("external_checkout_unavailable:prepare_token");
                        }
                        break;
                    case 6:
                        launchExternalCheckout(str2);
                        break;
                    default:
                        Log.e(TAG, "No sendDataToNative func implemented: funcName = " + str + ", data = " + str2);
                        break;
                }
            } catch (Exception e) {
                e.printStackTrace();
                return;
            }
        }
        str.hashCode();
        switch (str.hashCode()) {
            case -1851723259:
                b = str.equals("saveImageToAlbumFromPath") ? (byte) 0 : (byte) -1;
                break;
            case -1427863370:
                b = str.equals("GetInstallRefererInfo") ? (byte) 1 : (byte) -1;
                break;
            case -764253967:
                b = str.equals("LW_ShumeiSdkCreate") ? (byte) 2 : (byte) -1;
                break;
            case -332888057:
                b = str.equals("FireBase_getFCMToken") ? (byte) 3 : (byte) -1;
                break;
            case 77329245:
                b = str.equals(APP_STORAGE_SIZE_FUNC) ? (byte) 4 : (byte) -1;
                break;
            case 103915575:
                b = str.equals("RefreshPhoto") ? (byte) 5 : (byte) -1;
                break;
            case 390344094:
                if (!str.equals("RequestPermission")) {
                    b = -1;
                }
                break;
            case 500446588:
                b = str.equals("RequestCalendarEventPermission") ? (byte) 7 : (byte) -1;
                break;
            case 664827764:
                b = str.equals("LW_SetUserId") ? (byte) 8 : (byte) -1;
                break;
            case 685971662:
                b = str.equals("RequestWriteAlbumPermission") ? (byte) 9 : (byte) -1;
                break;
            case 776657541:
                b = str.equals("RequestRecordAudioPermission") ? (byte) 10 : (byte) -1;
                break;
            case 1033283323:
                b = str.equals("AddCalendarEvent") ? Ascii.f93VT : (byte) -1;
                break;
            case 1696148665:
                b = str.equals("InitAIHelp") ? Ascii.f82FF : (byte) -1;
                break;
            case 1935224388:
                b = str.equals("LW_DMAPrivacyAllowed") ? Ascii.f80CR : (byte) -1;
                break;
            default:
                b = -1;
                break;
        }
        switch (b) {
            case 0:
                try {
                    saveImageToAlbumFromPath(str2);
                } catch (Exception e2) {
                    e2.printStackTrace();
                }
                break;
            case 1:
                CheckInstallRefererInfo();
                break;
            case 2:
                SmSdkManager.getInstance().callCreate();
                break;
            case 3:
                FireBaseController.getInstance().getFcmToken();
                FireBaseController.getInstance().initFirebaseAppId();
                break;
            case 4:
                Device.requestAppStorageSizeAsync(str2, null);
                break;
            case 5:
                try {
                    Log.d(TAG, "RefreshPhoto:" + str2);
                    this.mActivity.sendBroadcast(new Intent("android.intent.action.MEDIA_SCANNER_SCAN_FILE", Uri.fromFile(new File(str2))));
                } catch (Exception e3) {
                    e3.printStackTrace();
                    return;
                }
                break;
            case 6:
                try {
                    JSONObject jSONObject2 = new JSONObject(str2);
                    String strOptString2 = jSONObject2.optString("permission");
                    int iOptInt = jSONObject2.optInt("requestCode");
                    if (Build.VERSION.SDK_INT > 23 && this.mActivity.checkSelfPermission(strOptString2) != 0) {
                        this.mActivity.requestPermissions(new String[]{strOptString2}, iOptInt);
                        break;
                    }
                } catch (Exception e4) {
                    e4.printStackTrace();
                    return;
                }
                break;
            case 7:
                try {
                    RequestCalendarEventPermission(Integer.parseInt(str2));
                } catch (Exception e5) {
                    e5.printStackTrace();
                    return;
                }
                break;
            case 8:
            case 12:
                break;
            case 9:
                try {
                    RequestWriteAlbumPermission(Integer.parseInt(str2));
                } catch (Exception e6) {
                    e6.printStackTrace();
                    return;
                }
                break;
            case 10:
                try {
                    RequestRecordAudioPermission(Integer.parseInt(str2));
                } catch (Exception e7) {
                    e7.printStackTrace();
                    return;
                }
                break;
            case 11:
                try {
                    AddCalendarEvent(str2);
                } catch (Exception e8) {
                    e8.printStackTrace();
                    return;
                }
                break;
            case 13:
                dmaPrivacyAllowed();
                break;
            default:
                Log.e(TAG, "No sendDataToNative func implemented: funcName = " + str + ", data = " + str2);
                break;
        }
    }

    private void launchExternalCheckout(String str) {
        try {
            try {
                JSONObject jSONObject = new JSONObject(str);
                String strOptString = jSONObject.optString(ImagesContract.URL);
                ExternalCheckoutProgram externalCheckoutProgramFromValue = ExternalCheckoutProgram.fromValue(jSONObject.optInt("program", 0));
                boolean zOptBoolean = jSONObject.optBoolean("callerWillLaunchLink", false);
                if (!TextUtils.isEmpty(strOptString) && this.mActivity != null) {
                    if (this.m_payGoogle != null && externalCheckoutProgramFromValue.requiresAndroidBillingApproval()) {
                        this.m_payGoogle.launchExternalCheckout(externalCheckoutProgramFromValue, strOptString, zOptBoolean);
                        return;
                    }
                    Intent intent = new Intent("android.intent.action.VIEW", Uri.parse(strOptString));
                    intent.addFlags(268435456);
                    this.mActivity.startActivity(intent);
                    this.mListener.SendDataToGame("onExternalCheckoutOpened", strOptString);
                    return;
                }
                Log.w(TAG, "[ExternalCheckout] launchExternalCheckout aborted empty url or activity");
            } catch (Exception e) {
                Log.e(TAG, "launchExternalCheckout failed", e);
                this.mListener.SendDataToGame("onExternalCheckoutFailed", buildExternalCheckoutResult(3, 2, e.toString(), 1));
            }
        } catch (Exception unused) {
        }
    }

    private String buildExternalCheckoutResult(int i, int i2, String str, int i3) {
        try {
            JSONObject jSONObject = new JSONObject();
            jSONObject.put("code", i);
            jSONObject.put("category", i2);
            jSONObject.put("message", str == null ? "" : str);
            jSONObject.put("source", i3);
            return jSONObject.toString();
        } catch (JSONException e) {
            Log.e(TAG, "buildExternalCheckoutResult failed", e);
            return str == null ? "" : str;
        }
    }

    private boolean canHandleExternalCheckoutRequest() {
        return this.m_payGoogle != null && GooglePlayManager.getInstance().isAvailable;
    }

    private void notifyExternalCheckoutAvailability(String str) {
        SdkListener sdkListener = this.mListener;
        if (sdkListener == null) {
            return;
        }
        if (str == null) {
            str = "UNAVAILABLE";
        }
        try {
            sdkListener.SendDataToGame("onExternalCheckoutAvailability", str);
        } catch (Exception unused) {
        }
    }

    private void notifyExternalCheckoutUnavailable(String str) {
        SdkListener sdkListener = this.mListener;
        if (sdkListener == null) {
            return;
        }
        try {
            sdkListener.SendDataToGame("onExternalCheckoutFailed", buildExternalCheckoutResult(3, 2, str, 1));
        } catch (Exception unused) {
        }
    }

    private ExternalCheckoutProgram parseExternalCheckoutProgram(String str) {
        try {
            if (TextUtils.isEmpty(str)) {
                return ExternalCheckoutProgram.None;
            }
            if (str.startsWith("{")) {
                return ExternalCheckoutProgram.fromValue(new JSONObject(str).optInt("program", 0));
            }
            return ExternalCheckoutProgram.fromValue(Integer.parseInt(str));
        } catch (Exception e) {
            Log.e(TAG, "parseExternalCheckoutProgram failed", e);
            return ExternalCheckoutProgram.None;
        }
    }

    public void dmaPrivacyAllowed() {
        Log.d(TAG, "dmaPrivacyAllowed called");
        try {
            FireBaseController.getInstance().dmaPrivacyAllowed();
        } catch (Exception e) {
            Log.e(TAG, "dmaPrivacyAllowed FireBaseController Exception " + e.toString());
        }
        try {
            AppsFlyerController.getInstance().dmaPrivacyAllowed();
        } catch (Exception e2) {
            Log.e(TAG, "dmaPrivacyAllowed AppsFlyerController Exception " + e2.toString());
        }
        try {
            FacebookManager.getInstance().dmaPrivacyAllowed();
        } catch (Exception e3) {
            Log.e(TAG, "dmaPrivacyAllowed FacebookManager Exception " + e3.toString());
        }
    }

    public boolean HasLightSensorManager() {
        Sensor defaultSensor;
        try {
            defaultSensor = ((SensorManager) GetContext().getSystemService(l111l1111llIl.l11l111ll11l)).getDefaultSensor(5);
        } catch (Exception unused) {
            defaultSensor = null;
        }
        return defaultSensor != null;
    }

    public boolean HasIllegalDeviceFeature() {
        try {
            Intent intent = new Intent();
            intent.setData(Uri.parse("tel:112113"));
            intent.setAction("android.intent.action.DIAL");
            Context contextGetContext = GetContext();
            boolean z = intent.resolveActivity(contextGetContext.getPackageManager()) != null;
            TelephonyManager telephonyManager = (TelephonyManager) contextGetContext.getSystemService("phone");
            return Build.FINGERPRINT.startsWith("generic") || Build.FINGERPRINT.toLowerCase().contains("vbox") || Build.FINGERPRINT.toLowerCase().contains("test-keys") || Build.MODEL.contains("google_sdk") || Build.MODEL.contains("Emulator") || Build.SERIAL.equalsIgnoreCase("unknown") || Build.SERIAL.equalsIgnoreCase(l11l11lI1lll.l111l1111l1Il) || Build.MODEL.contains("Android SDK built for x86") || Build.MANUFACTURER.contains("Genymotion") || (Build.BRAND.startsWith("generic") && Build.DEVICE.startsWith("generic")) || "google_sdk".equals(Build.PRODUCT) || ((telephonyManager != null && telephonyManager.getNetworkOperatorName().toLowerCase().equals(l11l11lI1lll.l111l1111l1Il)) || !z);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public String getDataFromNative(String str, String str2) {
        if (str.startsWith("PM_")) {
            return AppUtilManager.getInstance().GetDataFromNative(str, str2);
        }
        if (str.startsWith("PUSH_")) {
            return PushUtilManager.getInstance().GetDataFromNative(str, str2);
        }
        if (str.startsWith("AF_")) {
            return AppsFlyerController.getInstance().GetDataFromNative(str, str2);
        }
        if (str.equals("PAY_CheckPayEnv")) {
            PayGoogle payGoogle = this.m_payGoogle;
            if (payGoogle != null) {
                return Integer.toString(payGoogle.CheckPayEnv());
            }
        } else {
            if (str.equals("PF_DisplayName")) {
                return GooglePlayManager.getInstance().getDisplayName();
            }
            if (str.equals("IsSimulator")) {
                boolean zHasIllegalDeviceFeature = getInstance().HasIllegalDeviceFeature();
                boolean zHasLightSensorManager = getInstance().HasLightSensorManager();
                Log.d(TAG, "HasIllegalDeviceFeature:" + zHasIllegalDeviceFeature);
                Log.d(TAG, "HasLightSensorManager:" + zHasLightSensorManager);
                if (zHasIllegalDeviceFeature || !zHasLightSensorManager) {
                    return "True";
                }
                return "False";
            }
            if (str.equals("LW_GetBuildInfo")) {
                return GetBuildInfo();
            }
            if (str.equals("LW_PSH")) {
                return LW_PSH(str2);
            }
            if (str.equals("LW_GetShumeiSdkDeviceId")) {
                return SmSdkManager.getInstance().getDeviceId();
            }
            if (str.equals("LW_GetStaticAndroidRuntimeInfo")) {
                return GetStaticAndroidRuntimeInfo();
            }
            if (str.equals(APP_STORAGE_SIZE_FUNC)) {
                return Device.getAppStorageSizeData(str2);
            }
            if (str.equals("HasWriteAlbumPermission")) {
                return HasWriteAlbumPermission();
            }
            if (str.equals("HasCalendarEventPermission")) {
                return HasCalendarEventPermission();
            }
            Log.e(TAG, "No getDataFromNative func implemented: funcName = " + str + ", data = " + str2);
        }
        return "";
    }

    public String HasWriteAlbumPermission() {
        JSONObject jSONObject = new JSONObject();
        try {
            jSONObject.put("SDK_INIT", Build.VERSION.SDK_INT);
            int i = 0;
            if (Build.VERSION.SDK_INT < 29 && ActivityCompat.checkSelfPermission(this.mActivity, "android.permission.WRITE_EXTERNAL_STORAGE") != 0) {
                Log.d(TAG, "HasWriteAlbumPermission false");
            } else {
                i = 1;
            }
            jSONObject.put("canWrite", i);
        } catch (JSONException unused) {
        }
        return jSONObject.toString();
    }

    public boolean saveImageToAlbumFromPath(String str) throws Throwable {
        OutputStream outputStreamOpenOutputStream;
        Uri uriInsert;
        FileInputStream fileInputStream;
        FileInputStream fileInputStream2 = null;
        try {
            try {
                try {
                    File file = new File(str);
                    String name = file.getName();
                    if (!file.exists()) {
                        Log.e("MediaStoreUtil", "Source file not exist: " + str);
                        return false;
                    }
                    ContentValues contentValues = new ContentValues();
                    contentValues.put("_display_name", name);
                    contentValues.put("mime_type", "image/jpeg");
                    contentValues.put("relative_path", Environment.DIRECTORY_PICTURES + "/LastWar");
                    contentValues.put("is_pending", (Integer) 1);
                    ContentResolver contentResolver = this.mActivity.getContentResolver();
                    uriInsert = contentResolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, contentValues);
                    if (uriInsert == null) {
                        return false;
                    }
                    try {
                        fileInputStream = new FileInputStream(file);
                        try {
                            outputStreamOpenOutputStream = contentResolver.openOutputStream(uriInsert);
                            try {
                                byte[] bArr = new byte[8192];
                                while (true) {
                                    int i = fileInputStream.read(bArr);
                                    if (i == -1) {
                                        break;
                                    }
                                    outputStreamOpenOutputStream.write(bArr, 0, i);
                                }
                                outputStreamOpenOutputStream.flush();
                                contentValues.clear();
                                contentValues.put("is_pending", (Integer) 0);
                                contentResolver.update(uriInsert, contentValues, null, null);
                                try {
                                    fileInputStream.close();
                                } catch (Exception unused) {
                                }
                                if (outputStreamOpenOutputStream != null) {
                                    try {
                                        outputStreamOpenOutputStream.close();
                                    } catch (Exception unused2) {
                                    }
                                }
                                return true;
                            } catch (Exception e) {
                                e = e;
                                Log.e("MediaStoreUtil", "saveImageToAlbumFromPath error", e);
                                if (uriInsert != null) {
                                    this.mActivity.getContentResolver().delete(uriInsert, null, null);
                                }
                                if (fileInputStream != null) {
                                    try {
                                        fileInputStream.close();
                                    } catch (Exception unused3) {
                                    }
                                }
                                if (outputStreamOpenOutputStream != null) {
                                    try {
                                        outputStreamOpenOutputStream.close();
                                    } catch (Exception unused4) {
                                    }
                                }
                                return false;
                            }
                        } catch (Exception e2) {
                            e = e2;
                            outputStreamOpenOutputStream = null;
                        } catch (Throwable th) {
                            th = th;
                            fileInputStream2 = fileInputStream;
                            if (fileInputStream2 != null) {
                                try {
                                    fileInputStream2.close();
                                } catch (Exception unused5) {
                                }
                            }
                            if (fileInputStream2 != 0) {
                                throw th;
                            }
                            try {
                                fileInputStream2.close();
                                throw th;
                            } catch (Exception unused6) {
                                throw th;
                            }
                        }
                    } catch (Exception e3) {
                        e = e3;
                        outputStreamOpenOutputStream = null;
                        fileInputStream = null;
                    }
                } catch (Throwable th2) {
                    th = th2;
                    if (fileInputStream2 != null) {
                        fileInputStream2.close();
                    }
                    if (fileInputStream2 != 0) {
                        throw th;
                    }
                    fileInputStream2.close();
                    throw th;
                }
            } catch (Exception e4) {
                e = e4;
                outputStreamOpenOutputStream = null;
                uriInsert = null;
                fileInputStream = null;
            }
        } catch (Throwable th3) {
            th = th3;
        }
    }

    public String HasCalendarEventPermission() {
        if (ActivityCompat.checkSelfPermission(this.mActivity, "android.permission.WRITE_CALENDAR") != 0 || ActivityCompat.checkSelfPermission(this.mActivity, "android.permission.READ_CALENDAR") != 0) {
            Log.d(TAG, "HasCalendarEventPermission false");
            return "false";
        }
        return "true";
    }

    public void RequestWriteAlbumPermission(int i) {
        ActivityCompat.requestPermissions(this.mActivity, new String[]{"android.permission.WRITE_EXTERNAL_STORAGE", "android.permission.READ_EXTERNAL_STORAGE"}, i);
    }

    public void RequestCalendarEventPermission(int i) {
        ActivityCompat.requestPermissions(this.mActivity, new String[]{"android.permission.WRITE_CALENDAR", "android.permission.READ_CALENDAR"}, i);
    }

    public void RequestRecordAudioPermission(int i) {
        ActivityCompat.requestPermissions(this.mActivity, new String[]{"android.permission.RECORD_AUDIO"}, i);
    }

    private static int CheckCalendarAccount(Context context) {
        Cursor cursorQuery = context.getContentResolver().query(CalendarContract.Calendars.CONTENT_URI, null, null, null, null);
        int i = -1;
        if (cursorQuery == null) {
            if (cursorQuery != null) {
                cursorQuery.close();
            }
            return -1;
        }
        try {
            if (cursorQuery.getCount() <= 0) {
                return -1;
            }
            while (cursorQuery.moveToNext()) {
                int columnIndexOrThrow = cursorQuery.getColumnIndexOrThrow("_id");
                if (cursorQuery.getInt(cursorQuery.getColumnIndex("calendar_access_level")) >= 500) {
                    i = cursorQuery.getInt(columnIndexOrThrow);
                    break;
                }
            }
            return i;
        } finally {
            if (cursorQuery != null) {
                cursorQuery.close();
            }
        }
    }

    public void AddCalendarEvent(String str) {
        try {
            JSONObject jSONObject = new JSONObject(str);
            String strOptString = jSONObject.optString("title");
            String strOptString2 = jSONObject.optString(FirebaseAnalytics.Param.LOCATION);
            long jOptLong = jSONObject.optLong("startTime");
            long jOptLong2 = jSONObject.optLong("endTime");
            long jOptLong3 = jSONObject.optLong("haveAlarm");
            long jOptLong4 = jSONObject.optLong("alarmTime");
            if (jOptLong == 0 || jOptLong2 == 0) {
                getInstance().getSdkListener().SendDataToGame("AddCalendarEventFail", "startTime == 0 || endTime == 0");
                return;
            }
            Context contextGetContext = GetContext();
            if (contextGetContext == null) {
                getInstance().getSdkListener().SendDataToGame("AddCalendarEventFail", "context == null");
                return;
            }
            int iCheckCalendarAccount = CheckCalendarAccount(contextGetContext);
            if (iCheckCalendarAccount < 0) {
                getInstance().getSdkListener().SendDataToGame("AddCalendarEventCalIdNull", str);
                return;
            }
            ContentValues contentValues = new ContentValues();
            contentValues.put("title", strOptString);
            contentValues.put("description", strOptString2);
            contentValues.put("calendar_id", Integer.valueOf(iCheckCalendarAccount));
            contentValues.put("dtstart", Long.valueOf(jOptLong * 1000));
            contentValues.put("dtend", Long.valueOf(jOptLong2 * 1000));
            contentValues.put("eventTimezone", TimeZone.getDefault().getID());
            if (jOptLong3 > 0) {
                contentValues.put("hasAlarm", (Integer) 1);
            } else {
                contentValues.put("hasAlarm", (Integer) 0);
            }
            Uri uriInsert = contextGetContext.getContentResolver().insert(CalendarContract.Events.CONTENT_URI, contentValues);
            if (uriInsert == null) {
                getInstance().getSdkListener().SendDataToGame("AddCalendarEventFail", "eUri == null");
                return;
            }
            if (jOptLong3 > 0) {
                ContentValues contentValues2 = new ContentValues();
                contentValues2.put("event_id", Long.valueOf(ContentUris.parseId(uriInsert)));
                contentValues2.put("minutes", Long.valueOf((jOptLong4 * (-1)) / 60));
                contentValues2.put(FirebaseAnalytics.Param.METHOD, (Integer) 1);
                if (contextGetContext.getContentResolver().insert(CalendarContract.Reminders.CONTENT_URI, contentValues2) == null) {
                    getInstance().getSdkListener().SendDataToGame("AddCalendarEventFail", "uri == null");
                    return;
                }
            }
            getInstance().getSdkListener().SendDataToGame("AddCalendarEventBackFunc", str);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private String LW_PSH(String str) {
        try {
            for (Signature signature : this.mActivity.getPackageManager().getPackageInfo("com.fun.lastwar.gp", 64).signatures) {
                str = str + signature.toCharsString();
            }
            return Udid.MD5.getMD5Str(str);
        } catch (Exception e) {
            return e.toString();
        }
    }

    public String GetGaid() {
        return this._gaid;
    }

    public void SetGaid(String str) {
        if (str == null || str.isEmpty() || str.matches("[0-]+")) {
            str = "";
        }
        this._gaid = str;
    }

    static class GetGAIDTask extends AsyncTask<String, Integer, String> {
        private String gaid;
        private boolean lat;

        private GetGAIDTask() {
        }

        @Override
        public String doInBackground(String... strArr) {
            try {
                this.gaid = GooglePlayManager.getInstance().getAdvertisingId();
                this.lat = GooglePlayManager.getInstance().isLimitAdTrackingEnabled();
                Log.d("GetGAIDTask", "gaid = " + this.gaid);
                if (this.lat) {
                    this.gaid = "";
                    return "did not found GAID... sorry";
                }
                SdkManager.getInstance().SetGaid(this.gaid);
                this.gaid = SdkManager.getInstance().GetGaid();
                return "";
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        @Override
        public void onPostExecute(String str) {
            new Handler().postDelayed(new Runnable() {
                @Override
                public final void run() {
                    this.f$0.m799lambda$onPostExecute$0$comsdkmanagerSdkManager$GetGAIDTask();
                }
            }, 30000L);
        }

        void m799lambda$onPostExecute$0$comsdkmanagerSdkManager$GetGAIDTask() {
            try {
                JSONObject jSONObject = new JSONObject();
                jSONObject.put("1", this.gaid);
                jSONObject.put("2", this.lat ? "true" : "false");
                SdkManager.getInstance().getSdkListener().SendDataToGame("setGaid", jSONObject.toString());
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public void SendDataToGame(final String str, final String str2) {
        SdkListener sdkListener = this.mListener;
        if (sdkListener != null) {
            if (str == "getMultiUserInfo") {
                Activity activity = this.mActivity;
                if (activity != null) {
                    activity.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            SdkManager.this.mListener.SendDataToGame(str, str2);
                        }
                    });
                    return;
                }
                return;
            }
            sdkListener.SendDataToGame(str, str2);
        }
    }

    public void CheckInstallRefererInfo() {
        Log("checkInstallRefererInfo");
        try {
            final InstallReferrerClient installReferrerClientBuild = InstallReferrerClient.newBuilder(GetContext()).build();
            installReferrerClientBuild.startConnection(new InstallReferrerStateListener() {
                public void onInstallReferrerServiceDisconnected() {
                }

                public void onInstallReferrerSetupFinished(int i) {
                    if (i != 0) {
                        return;
                    }
                    try {
                        String installReferrer = installReferrerClientBuild.getInstallReferrer().getInstallReferrer();
                        if (installReferrer == null) {
                            SdkManager.this.getFaceBookAdInfo(null);
                        } else if (installReferrer.indexOf("utm_content") < 0) {
                            SdkManager.this.getFaceBookAdInfo(installReferrer);
                        } else {
                            SdkManager.this.syncGPInstallRefer(installReferrer);
                        }
                        installReferrerClientBuild.endConnection();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            });
        } catch (Exception e) {
            Log.e("InstallReferrerHelper", e.toString());
        }
    }

    public void syncGPInstallRefer(final String str) {
        Activity activity;
        if (this.mListener == null || (activity = this.mActivity) == null || str == null) {
            return;
        }
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                SdkManager.this.mListener.SendDataToGame("Get_Install_Referrer", str);
            }
        });
    }

    public void getFaceBookAdInfo(final String str) {
        new Handler().post(new Runnable() {
            @Override
            public final void run() {
                this.f$0.m796lambda$getFaceBookAdInfo$2$comsdkmanagerSdkManager(str);
            }
        });
    }

    void m796lambda$getFaceBookAdInfo$2$comsdkmanagerSdkManager(final String str) {
        Executors.newSingleThreadExecutor().submit(new Runnable() {
            @Override
            public void run() {
                Uri uri;
                String string = SdkManager.this.mActivity.getResources().getString(C1087R.string.facebook_app_id);
                String[] strArr = {"install_referrer", "is_ct", "actual_timestamp"};
                String str2 = str;
                if (SdkManager.this.GetContext().getPackageManager().resolveContentProvider("com.facebook.katana.provider.InstallReferrerProvider", 0) != null) {
                    uri = Uri.parse("content://com.facebook.katana.provider.InstallReferrerProvider/" + string);
                } else if (SdkManager.this.GetContext().getPackageManager().resolveContentProvider("com.instagram.contentprovider.InstallReferrerProvider", 0) == null) {
                    SdkManager.this.syncGPInstallRefer(str2);
                    return;
                } else {
                    uri = Uri.parse("content://com.instagram.contentprovider.InstallReferrerProvider/" + string);
                }
                Uri uri2 = uri;
                Cursor cursorQuery = null;
                try {
                    try {
                        cursorQuery = SdkManager.this.GetContext().getContentResolver().query(uri2, strArr, null, null, null);
                        if (cursorQuery != null && cursorQuery.moveToFirst()) {
                            String string2 = cursorQuery.getString(cursorQuery.getColumnIndex("install_referrer"));
                            if (string2 == null) {
                                SdkManager.this.syncGPInstallRefer(str2);
                                if (cursorQuery != null) {
                                    cursorQuery.close();
                                    return;
                                }
                                return;
                            }
                            SdkManager.this.syncGPInstallRefer(string2 + "&client=1");
                            if (cursorQuery != null) {
                                cursorQuery.close();
                                return;
                            }
                            return;
                        }
                        SdkManager.this.syncGPInstallRefer(str2);
                        if (cursorQuery != null) {
                            cursorQuery.close();
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        if (0 == 0) {
                        }
                    }
                } catch (Throwable th) {
                    if (0 != 0) {
                        cursorQuery.close();
                    }
                    throw th;
                }
            }
        });
    }

    public static boolean hasInAppReviewed(Context context) {
        return context.getSharedPreferences(TAG, 0).getBoolean(IN_APP_REVIEW, false);
    }

    public static void setInAppReviewed(Context context) {
        SharedPreferences.Editor editorEdit = context.getSharedPreferences(TAG, 0).edit();
        editorEdit.putBoolean(IN_APP_REVIEW, true);
        editorEdit.commit();
    }

    public void RequestInAppReview() {
        Log.d(TAG, "RequestInAppReview");
        if (hasInAppReviewed(GetContext())) {
            return;
        }
        ReviewManager reviewManagerCreate = ReviewManagerFactory.create(this.mActivity);
        this.reviewManager = reviewManagerCreate;
        reviewManagerCreate.requestReviewFlow().addOnCompleteListener(new OnCompleteListener() {
            @Override
            public final void onComplete(Task task) {
                this.f$0.m794lambda$RequestInAppReview$3$comsdkmanagerSdkManager(task);
            }
        });
    }

    void m794lambda$RequestInAppReview$3$comsdkmanagerSdkManager(Task task) {
        Log.d(TAG, "RequestInAppReview Complete");
        if (task.isSuccessful()) {
            this.reviewInfo = (ReviewInfo) task.getResult();
            launchReviewFlow();
        }
    }

    String GetBuildInfo() {
        JSONObject jSONObject = new JSONObject();
        try {
            jSONObject.put("board", Build.BOARD);
            jSONObject.put("bootLoader", Build.BOOTLOADER);
            jSONObject.put("brand", Build.BRAND);
            jSONObject.put("device", Build.DEVICE);
            jSONObject.put(Constants.ScionAnalytics.MessageType.DISPLAY_NOTIFICATION, Build.DISPLAY);
            jSONObject.put("fingerPrint", Build.FINGERPRINT);
            jSONObject.put("hardware", Build.HARDWARE);
            jSONObject.put("host", Build.HOST);
            jSONObject.put("id", Build.ID);
            jSONObject.put("manufacturer", Build.MANUFACTURER);
            jSONObject.put("model", Build.MODEL);
            jSONObject.put("product", Build.PRODUCT);
            jSONObject.put("tags", Build.TAGS);
            jSONObject.put("time", Build.TIME);
            jSONObject.put(l11l11I1111l.l111l1111l1Il, Build.TYPE);
            jSONObject.put("user", Build.USER);
            String deviceMacAddr = getDeviceMacAddr(GetContext());
            if (deviceMacAddr != null && !deviceMacAddr.equals("")) {
                jSONObject.put("macAddr", deviceMacAddr);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return jSONObject.toString();
    }

    static String getDeviceMacAddr(Context context) {
        return getLocalMac(context);
    }

    static String getMacDefault(Context context) {
        if (context == null) {
            return null;
        }
        try {
            WifiInfo connectionInfo = ((WifiManager) context.getSystemService("wifi")).getConnectionInfo();
            if (connectionInfo == null) {
                return null;
            }
            String macAddress = connectionInfo.getMacAddress();
            return !TextUtils.isEmpty(macAddress) ? macAddress.toUpperCase(Locale.ENGLISH) : macAddress;
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    private static String getLocalMac(Context context) {
        StringBuffer stringBuffer = new StringBuffer();
        try {
            NetworkInterface byName = NetworkInterface.getByName("eth1");
            if (byName == null) {
                byName = NetworkInterface.getByName("wlan0");
            }
            if (byName == null) {
                return "";
            }
            for (byte b : byName.getHardwareAddress()) {
                stringBuffer.append(String.format("%02X:", Byte.valueOf(b)));
            }
            if (stringBuffer.length() > 0) {
                stringBuffer.deleteCharAt(stringBuffer.length() - 1);
            }
            return stringBuffer.toString();
        } catch (SocketException e) {
            e.printStackTrace();
            return null;
        }
    }

    private String GetStaticAndroidRuntimeInfo() {
        JSONObject jSONObject = new JSONObject();
        try {
            jSONObject.put("model", Build.MODEL);
            long totalMemory = Device.getTotalMemory();
            int cPUMaxFreqKHz = Device.getCPUMaxFreqKHz();
            jSONObject.put("totalMemory", totalMemory);
            jSONObject.put("freq", cPUMaxFreqKHz);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return jSONObject.toString();
    }

    void launchReviewFlow() {
        Log.d(TAG, "launchReviewFlow");
        ReviewInfo reviewInfo = this.reviewInfo;
        if (reviewInfo != null) {
            this.reviewManager.launchReviewFlow(this.mActivity, reviewInfo).addOnCompleteListener(new OnCompleteListener() {
                @Override
                public final void onComplete(Task task) {
                    this.f$0.m797lambda$launchReviewFlow$4$comsdkmanagerSdkManager(task);
                }
            });
        }
    }

    void m797lambda$launchReviewFlow$4$comsdkmanagerSdkManager(Task task) {
        Log.d(TAG, "launchReviewFlow Complete");
        setInAppReviewed(GetContext());
    }

    public boolean IsAppInForeGround() {
        return this.isAppInForeground;
    }
}
