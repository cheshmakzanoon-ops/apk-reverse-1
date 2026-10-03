package ru.mopsicus.common;

import android.app.Activity;
import android.util.Log;
import android.view.WindowManager;
import com.unity3d.player.UnityPlayer;
import okhttp3.internal.http2.Http2Connection;
import org.json.JSONException;
import org.json.JSONObject;
import zendesk.faye.internal.Bayeux;

public class Common {
    String object = "Plugins";
    String receiver = "OnDataReceive";

    public void sendData(String str, String str2) {
        JSONObject jSONObject = new JSONObject();
        try {
            jSONObject.put("name", str);
            jSONObject.put(Bayeux.KEY_DATA, str2);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        UnityPlayer.UnitySendMessage(this.object, this.receiver, jSONObject.toString());
    }

    public void sendError(String str, String str2) {
        sendError(str, str2, "");
    }

    public void sendError(String str, String str2, String str3) {
        JSONObject jSONObject = new JSONObject();
        JSONObject jSONObject2 = new JSONObject();
        try {
            jSONObject.put("code", str2);
            jSONObject.put("message", str3);
            jSONObject2.put("name", str);
            jSONObject2.put("error", jSONObject);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        UnityPlayer.UnitySendMessage(this.object, this.receiver, jSONObject2.toString());
    }

    public static void DebugWindowFlag(Activity activity, String str) {
        WindowManager.LayoutParams attributes = activity.getWindow().getAttributes();
        int[] iArr = {1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768, 65536, 131072, 262144, 524288, 1048576, 2097152, 4194304, 8388608, Http2Connection.OKHTTP_CLIENT_WINDOW_SIZE, 33554432, 67108864, 134217728, 268435456, 536870912, 1073741824, Integer.MIN_VALUE};
        String[] strArr = {"ALLOW_LOCK_WHILE_SCREEN_ON", "DIM_BEHIND", "BLUR_BEHIND", "NOT_FOCUSABLE", "NOT_TOUCHABLE", "NOT_TOUCH_MODAL", "TOUCHABLE_WHEN_WAKING", "KEEP_SCREEN_ON", "LAYOUT_IN_SCREEN", "LAYOUT_NO_LIMITS", "FULLSCREEN", "FORCE_NOT_FULLSCREEN", "DITHER", "SECURE", "SCALED", "IGNORE_CHEEK_PRESSES", "LAYOUT_INSET_DECOR", "ALT_FOCUSABLE_IM", "WATCH_OUTSIDE_TOUCH", "SHOW_WHEN_LOCKED", "SHOW_WALLPAPER", "TURN_SCREEN_ON", "DISMISS_KEYGUARD", "SPLIT_TOUCH", "HARDWARE_ACCELERATED", "LOCAL_FOCUS_MODE", "TRANSLUCENT_STATUS", "TRANSLUCENT_NAVIGATION", "LOCAL_FOCUS_MODE", "FLAG_SLIPPERY", "FLAG_LAYOUT_ATTACHED_IN_DECOR", "DRAWS_SYSTEM_BAR_BACKGROUNDS"};
        int i = attributes.flags;
        String str2 = "";
        for (int i2 = 0; i2 < 32; i2++) {
            int i3 = iArr[i2];
            if ((i & i3) == i3) {
                str2 = str2 + "[" + strArr[i2] + "]";
            }
        }
        Log.d("WindowFlags", str + ": " + UnityPlayer.currentActivity.getLocalClassName() + ", params.flags = " + str2);
    }
}
