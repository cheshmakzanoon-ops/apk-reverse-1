package com.rivergame.fm_mono;

import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.os.Environment;
import android.util.Log;
import com.google.android.gms.measurement.api.AppMeasurementSdk;
import com.ishumei.smantifraud.l11l11l1lI1l;
import com.jakewharton.processphoenix.ProcessPhoenix;
import com.unity3d.player.UnityPlayer;
import com.unity3d.player.UnityPlayerActivity;
import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class FMMonoBaseActivity extends UnityPlayerActivity {
    private String _restartData = null;

    static {
        System.loadLibrary("il2cpp");
    }

    public static String[] getNoUpdateAssemblies(byte[] bArr) {
        String str;
        if (bArr == null) {
            return null;
        }
        Activity activity = UnityPlayer.currentActivity;
        try {
            str = activity.getPackageManager().getPackageInfo(activity.getPackageName(), 0).versionName;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
            str = "0";
        }
        try {
            ArrayList arrayList = new ArrayList();
            JSONArray jSONArray = new JSONArray(new String(bArr, l11l11l1lI1l.l11l111ll1Il));
            int length = jSONArray.length();
            for (int i = 0; i < length; i++) {
                JSONObject jSONObject = jSONArray.getJSONObject(i);
                String strOptString = jSONObject.optString(AppMeasurementSdk.ConditionalUserProperty.NAME);
                if (strOptString != null) {
                    JSONObject jSONObjectOptJSONObject = jSONObject.optJSONObject("exclude");
                    if (jSONObjectOptJSONObject != null) {
                        String strOptString2 = jSONObjectOptJSONObject.optString("minVer", null);
                        String strOptString3 = jSONObjectOptJSONObject.optString("maxVer", null);
                        Log.d("FM_Mono", "ver " + str + ", minVer " + strOptString2 + " maxVer " + strOptString3);
                        if ((!StringUtils.isNullOrEmpty(strOptString2) && StringUtils.versionCompare(str, strOptString2) < 0) || (!StringUtils.isNullOrEmpty(strOptString3) && StringUtils.versionCompare(str, strOptString3) > 0)) {
                            Log.d("FM_Mono", "force use package assembly " + strOptString);
                            arrayList.add(strOptString);
                        }
                    } else {
                        arrayList.add(strOptString);
                    }
                }
            }
            if (arrayList.size() > 0) {
                return (String[]) arrayList.toArray(new String[arrayList.size()]);
            }
        } catch (UnsupportedEncodingException e2) {
            e2.printStackTrace();
        } catch (JSONException e3) {
            e3.printStackTrace();
        }
        return null;
    }

    private static boolean createSpecialDir(File file) {
        if (file == null) {
            return false;
        }
        try {
            if (file.exists()) {
                return file.isDirectory();
            }
            return file.mkdirs();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static String getInternalPersistentDataPath() {
        File filesDir;
        if (Environment.getExternalStorageState().equals("mounted")) {
            filesDir = UnityPlayer.currentActivity.getExternalFilesDir(null);
            if (createSpecialDir(filesDir)) {
                try {
                    File fileCreateTempFile = File.createTempFile("fct", null);
                    if (fileCreateTempFile != null) {
                        fileCreateTempFile.delete();
                    } else {
                        filesDir = null;
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            } else {
                filesDir = null;
            }
        } else {
            filesDir = null;
        }
        if (filesDir == null) {
            filesDir = UnityPlayer.currentActivity.getFilesDir();
            if (!createSpecialDir(filesDir)) {
                filesDir = null;
            }
        }
        if (filesDir == null) {
            return null;
        }
        try {
            return filesDir.getCanonicalPath();
        } catch (IOException e2) {
            e2.printStackTrace();
            return null;
        }
    }

    public static String getFullVersion() {
        Activity activity = UnityPlayer.currentActivity;
        try {
            PackageInfo packageInfo = activity.getPackageManager().getPackageInfo(activity.getPackageName(), 0);
            return packageInfo.versionName + "." + packageInfo.versionCode;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
            return null;
        }
    }

    public String getRestartData() {
        return this._restartData;
    }

    public void restart(String str) {
        ProcessPhoenix.triggerRebirth(this, str);
    }

    @Override
    protected void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        Intent intent = getIntent();
        if (intent.hasExtra(ProcessPhoenix.KEY_RESTART_DATA)) {
            this._restartData = intent.getStringExtra(ProcessPhoenix.KEY_RESTART_DATA);
            intent.removeExtra(ProcessPhoenix.KEY_RESTART_DATA);
        }
    }
}
