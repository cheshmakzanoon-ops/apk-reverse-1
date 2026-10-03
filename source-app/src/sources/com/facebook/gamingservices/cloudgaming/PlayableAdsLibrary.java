package com.facebook.gamingservices.cloudgaming;

import android.content.Context;
import com.facebook.gamingservices.cloudgaming.internal.SDKMessageEnum;
import org.json.JSONObject;

public class PlayableAdsLibrary {
    public static void openAppStore(Context context, JSONObject parameters, DaemonRequest.Callback callback) {
        DaemonRequest.executeAsync(context, parameters, callback, SDKMessageEnum.OPEN_APP_STORE);
    }

    public static void markGameLoaded(Context context, JSONObject parameters, DaemonRequest.Callback callback) {
        DaemonRequest.executeAsync(context, parameters, callback, SDKMessageEnum.MARK_GAME_LOADED);
    }
}
