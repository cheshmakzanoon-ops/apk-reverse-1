package com.sdkmanager.notify;

import android.app.NotificationManager;
import android.content.Context;
import android.content.SharedPreferences;
import com.ishumei.smantifraud.l11l11I1111l;
import com.sdkmanager.SdkManager;
import org.json.JSONObject;

public class PushRecordManager {
    public static String ALL_PUSH_DATA = "All_Push_Data";
    public static String CACHE_RECORD = "Cache_Record";
    public static String LineSeperator = "|";
    public static String StarSeperator = "*";
    Context androidActivity;
    Context androidContext;
    NotificationManager notificationManager;

    public void RecordToHttp(String str, String str2, String str3, String str4, String str5) {
    }

    public void RecordToHttp2(String str) {
    }

    public PushRecordManager(Context context) {
        this.androidActivity = context;
        Context applicationContext = context.getApplicationContext();
        this.androidContext = applicationContext;
        this.notificationManager = (NotificationManager) applicationContext.getSystemService("notification");
    }

    public String GetCurRecord() {
        return this.androidContext.getSharedPreferences(CACHE_RECORD, 0).getString(ALL_PUSH_DATA, "");
    }

    public void ClearCurRecord() {
        SharedPreferences.Editor editorEdit = this.androidContext.getSharedPreferences(CACHE_RECORD, 0).edit();
        editorEdit.putString(ALL_PUSH_DATA, "");
        editorEdit.commit();
    }

    public void AddRecord(String str, String str2) {
        String strGetCurRecord = GetCurRecord();
        String str3 = String.format("%s%s%s", str, StarSeperator, str2);
        if (!strGetCurRecord.isEmpty()) {
            str3 = String.format("%s%s%s", strGetCurRecord, LineSeperator, str3);
        }
        SharedPreferences.Editor editorEdit = this.androidContext.getSharedPreferences(CACHE_RECORD, 0).edit();
        editorEdit.putString(ALL_PUSH_DATA, str3);
        editorEdit.commit();
    }

    public String getPushTag() {
        Context context = this.androidContext;
        return context == null ? "" : context.getSharedPreferences(LocalNotificationManager.CACHE_PUSH_TAG, 0).getString(LocalNotificationManager.PUSH_TAG_FOR_CLICK, "");
    }

    public void setPushTag(String str) {
        Context context = this.androidContext;
        if (context == null) {
            return;
        }
        SharedPreferences.Editor editorEdit = context.getSharedPreferences(LocalNotificationManager.CACHE_PUSH_TAG, 0).edit();
        editorEdit.putString(LocalNotificationManager.PUSH_TAG_FOR_CLICK, str);
        editorEdit.commit();
    }

    public void setPushIdToCache(String str) {
        Context context = this.androidContext;
        if (context == null) {
            return;
        }
        SharedPreferences.Editor editorEdit = context.getSharedPreferences(LocalNotificationManager.CACHE_PUSH_TAG, 0).edit();
        editorEdit.putString(LocalNotificationManager.PUSHID_FOR_CLICK, str);
        editorEdit.commit();
    }

    public String getPushIdFromCache() {
        Context context = this.androidContext;
        return context == null ? "" : context.getSharedPreferences(LocalNotificationManager.CACHE_PUSH_TAG, 0).getString(LocalNotificationManager.PUSHID_FOR_CLICK, "");
    }

    public String getPushTime() {
        Context context = this.androidContext;
        return context == null ? "" : context.getSharedPreferences(LocalNotificationManager.CACHE_PUSH_TIME, 0).getString(LocalNotificationManager.PUSH_TIME, "");
    }

    public void setPushTime(String str) {
        Context context = this.androidContext;
        if (context == null) {
            return;
        }
        SharedPreferences.Editor editorEdit = context.getSharedPreferences(LocalNotificationManager.CACHE_PUSH_TIME, 0).edit();
        editorEdit.putString(LocalNotificationManager.PUSH_TIME, str);
        editorEdit.commit();
    }

    public void ClearAllPushData() {
        if (this.androidContext == null) {
            return;
        }
        setPushTag("");
        setPushTime("");
        setPushIdToCache("");
        ClearCurRecord();
    }

    public String GetJsonStr(String str, String str2, String str3, String str4, String str5) {
        try {
            try {
                JSONObject jSONObject = new JSONObject();
                jSONObject.put("project", "aps");
                jSONObject.put("uid", str2);
                jSONObject.put("pushtag", str3);
                jSONObject.put("pushId", str5);
                jSONObject.put("playermark", str4);
                jSONObject.put("ispushget", true);
                jSONObject.put("ispushopen", false);
                jSONObject.put(l11l11I1111l.l111l1111l1Il, str);
                jSONObject.put("time", System.currentTimeMillis());
                jSONObject.put("versionCode", SdkManager.getInstance().getVersionCode());
                return jSONObject.toString();
            } catch (Exception e) {
                e.printStackTrace();
                return "";
            }
        } catch (Throwable unused) {
            return "";
        }
    }
}
