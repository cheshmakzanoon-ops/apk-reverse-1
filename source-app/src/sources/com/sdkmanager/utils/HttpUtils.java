package com.sdkmanager.utils;

import android.app.Activity;
import com.sdkmanager.notify.PushRecordManager;
import java.util.ArrayList;

public class HttpUtils {
    private static volatile HttpUtils Instance;
    private boolean isInit = false;
    private Activity mActivity;

    public void sendHttpRecord(String str, ArrayList<String> arrayList) {
    }

    public static HttpUtils getInstance() {
        if (Instance == null) {
            synchronized (HttpUtils.class) {
                if (Instance == null) {
                    Instance = new HttpUtils();
                }
            }
        }
        return Instance;
    }

    public void init(Activity activity) {
        this.mActivity = activity;
    }

    public Activity getCurActivity() {
        return this.mActivity;
    }

    public void sendHttpRecord(String str, String str2) {
        try {
            new PushRecordManager(this.mActivity).RecordToHttp2(str);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public String getVersionName() {
        try {
            return this.mActivity.getPackageManager().getPackageInfo(this.mActivity.getPackageName(), 0).versionName;
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    public String getVersionCode() {
        try {
            return String.valueOf(this.mActivity.getPackageManager().getPackageInfo(this.mActivity.getPackageName(), 1).versionCode);
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        } catch (NoSuchMethodError e2) {
            e2.printStackTrace();
            return "";
        }
    }
}
