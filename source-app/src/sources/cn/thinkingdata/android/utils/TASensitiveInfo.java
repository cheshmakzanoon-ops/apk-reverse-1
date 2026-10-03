package cn.thinkingdata.android.utils;

import android.content.Context;
import android.provider.Settings;

public class TASensitiveInfo {
    public String getAndroidID(Context context) {
        try {
            return Settings.Secure.getString(context.getContentResolver(), "android_id");
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }
}
