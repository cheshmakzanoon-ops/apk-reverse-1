package com.im30.aps.debug;

import android.content.Intent;
import android.content.SharedPreferences;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Process;
import android.os.SystemClock;
import android.util.Log;
import com.appsflyer.AppsFlyerController;
import com.example.updateandinstall.UpdateManager;
import com.google.android.material.card2.hr;
import com.rivergame.fm_mono.FMMonoBaseActivity;
import com.sdkmanager.FireBaseController;
import com.sdkmanager.PushUtilManager;
import com.sdkmanager.SdkListener;
import com.sdkmanager.SdkManager;
import com.sdkmanager.notify.PushRecordManager;
import com.unity3d.player.UnityPlayer;
import java.io.File;

public class UnityPlayerActivityCustom extends FMMonoBaseActivity {
    private static final String TAG = "UnityPlayerActivity";
    private static long gStartTime;
    private boolean delayPauseResume = false;
    protected String mUnitySdkProxy;
    private UpdateManager mUpdateManager;

    private void m369bl() {
        new hr().a(this);
    }

    public void GotoMarket(String str, String str2) {
    }

    @Override
    protected void onCreate(Bundle bundle) {
        beforeUnityPlayerCreate();
        super.onCreate(bundle);
        afterUnityPlayerCreate();
        try {
            UnityPlayer.currentActivity.getWindow().clearFlags(524288);
            UnityPlayer.currentActivity.getWindow().clearFlags(4194304);
            if (Build.VERSION.SDK_INT >= 27) {
                UnityPlayer.currentActivity.setShowWhenLocked(false);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    protected void beforeUnityPlayerCreate() {
        try {
            FireBaseController.getInstance().init(this);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    protected void afterUnityPlayerCreate() {
        try {
            SendLaunchLog();
            UnitySplashManager.getInstance().SetMainContext(this);
            UnitySplashManager.getInstance().onShowSplashView(this.mUnityPlayer);
            PushUtilManager.getInstance().Init(this);
            PushUtilManager.getInstance().initNotificationManager();
            AppsFlyerController.getInstance().init(this);
            AppsFlyerController.getInstance().InitSdk();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void SendLaunchLog() {
        SharedPreferences sharedPreferences = getSharedPreferences("APS", 0);
        if (sharedPreferences.getBoolean("not_new", false)) {
            return;
        }
        if (isNewInstall()) {
            new PushRecordManager(this).RecordToHttp2("first_launch");
        }
        SharedPreferences.Editor editorEdit = sharedPreferences.edit();
        editorEdit.putBoolean("not_new", true);
        editorEdit.commit();
    }

    private boolean isNewInstall() {
        String path = getExternalFilesDir(null).getPath();
        StringBuilder sb = new StringBuilder();
        sb.append(path);
        sb.append("/config1.db");
        return !new File(sb.toString()).isFile();
    }

    @Override
    protected void onNewIntent(Intent intent) {
        setIntent(intent);
    }

    @Override
    protected boolean DelayPauseResume() {
        Log.d("TAG.LWUnityPlayer", "DelayPauseResume");
        return this.delayPauseResume;
    }

    @Override
    protected void onPause() {
        super.onPause();
        SdkManager.getInstance().onPause();
    }

    @Override
    protected void onResume() {
        super.onResume();
        SdkManager.getInstance().onResume();
    }

    @Override
    protected void onStart() {
        super.onStart();
        Log.i(TAG, "onStart ok");
    }

    @Override
    protected void onStop() {
        super.onStop();
    }

    private void Log(String str) {
        Log.d(TAG, str);
    }

    public void ExitGame() {
        finish();
        Process.killProcess(Process.myPid());
        System.exit(0);
    }

    public void InitPlatform(String str, SdkListener sdkListener) {
        Log("InitPlatform called " + str);
        this.mUnitySdkProxy = str;
        Log("call SdkManager init ");
        SdkManager.getInstance().init(this, sdkListener);
    }

    public void SignIn(String str) {
        String strGetPackageName = UpdateManager.getInstance().GetPackageName();
        if (strGetPackageName.equals("com.fun.lastwar.debug") || strGetPackageName.equals("com.fun.lastwar.gp")) {
            Log("SignIn called " + str);
            SdkManager.getInstance().PostEvent("google_signin", "");
            SdkManager.getInstance().signIn(str);
        }
    }

    public void SetAccountFunc(String str) {
        String strGetPackageName = UpdateManager.getInstance().GetPackageName();
        if (strGetPackageName.equals("com.fun.lastwar.debug") || strGetPackageName.equals("com.fun.lastwar.gp")) {
            Log("Lastwar SignIn called " + str);
            SdkManager.getInstance().PostEvent("google_signin", "");
            SdkManager.getInstance().SetAccountFunc(str);
        }
    }

    public void SignOut() {
        Log("SignOut called");
        SdkManager.getInstance().signOut();
    }

    public void Pay(int i, String str) {
        Log("Pay called " + str);
        SdkManager.getInstance().pay(i, str);
    }

    public void ConsumeProduct(String str, int i) {
        Log("ConsumeProduct: orderId = " + str + ", status = " + i);
        SdkManager.getInstance().consumeProduct(str, i);
    }

    public void SendDataToNative(String str, String str2) throws Throwable {
        Log("SendDataToNative: funcName = " + str + ", data = " + str2);
        str.hashCode();
        switch (str) {
            case "ACT_AskForNotifyPermission":
                gotoNotificationSetting();
                break;
            case "SWITCH_DelayPauseResume":
                this.delayPauseResume = str2.equals("1");
                break;
            case "SetAccountFunc":
                SetAccountFunc(str2);
                break;
            default:
                SdkManager.getInstance().sendDataToNative(str, str2);
                break;
        }
    }

    public String GetDataFromNative(String str, String str2) {
        return SdkManager.getInstance().getDataFromNative(str, str2);
    }

    @Override
    protected void onActivityResult(int i, int i2, Intent intent) {
        Log("onActivityResult request = " + i + ", result = " + i2);
        SdkManager.getInstance().onActivityResult(i, i2, intent);
    }

    @Override
    public void onRequestPermissionsResult(int i, String[] strArr, int[] iArr) {
        SdkManager.getInstance().onRequestPermissionsResult(i, strArr, iArr);
    }

    public void HideSplash() {
        UnitySplashManager.getInstance().onHideSplashView();
    }

    public boolean IsShowLogoOk() {
        return UnitySplashManager.getInstance().showLogOk;
    }

    public void gotoNotificationSetting() {
        try {
            Intent intent = new Intent();
            intent.setAction("android.settings.APP_NOTIFICATION_SETTINGS");
            intent.putExtra("android.provider.extra.APP_PACKAGE", getPackageName());
            intent.putExtra("app_package", getPackageName());
            startActivity(intent);
        } catch (Exception e) {
            e.printStackTrace();
            Intent intent2 = new Intent();
            intent2.setAction("android.settings.APPLICATION_DETAILS_SETTINGS");
            intent2.setData(Uri.fromParts("package", getPackageName(), null));
            startActivity(intent2);
        }
    }

    public static long getElapsedRealtime() {
        if (gStartTime == 0) {
            gStartTime = SystemClock.elapsedRealtime();
        }
        return SystemClock.elapsedRealtime() - gStartTime;
    }
}
