package net.aihelp.data.track.data;

import net.aihelp.common.API;
import net.aihelp.common.Const;
import net.aihelp.common.UserProfile;
import net.aihelp.config.AIHelpContext;
import net.aihelp.core.net.http.AIHelpRequest;
import net.aihelp.core.net.http.callback.BaseCallback;
import net.aihelp.core.net.json.JsonHelper;
import net.aihelp.utils.DeviceInfoUtil;
import net.aihelp.utils.DeviceUuidFactory;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class TrackHelper {
    public static void syncTrack(JSONArray jSONArray) {
        if (jSONArray != null) {
            JSONArray jSONArrayGroupArray = groupArray(jSONArray, 50);
            for (int i = 0; i < jSONArrayGroupArray.length(); i++) {
                try {
                    AIHelpRequest.getInstance().requestPostByJson(API.TRACK_RPA, jSONArrayGroupArray.getJSONArray(i).toString(), (BaseCallback) null);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private static JSONArray groupArray(JSONArray jSONArray, int i) {
        JSONArray jSONArray2 = new JSONArray();
        if (jSONArray != null) {
            int length = (jSONArray.length() / i) + (jSONArray.length() % i > 0 ? 1 : 0);
            for (int i2 = 0; i2 < length; i2++) {
                JSONArray jSONArray3 = new JSONArray();
                int i3 = i * i2;
                for (int i4 = i3; i4 < Math.min(i3 + i, jSONArray.length()); i4++) {
                    jSONArray3.put(JsonHelper.getJsonObject(jSONArray, i4));
                }
                jSONArray2.put(jSONArray3);
            }
        }
        return jSONArray2;
    }

    public static void addTrackData(JSONObject jSONObject, String str, Object obj) {
        if (jSONObject != null) {
            try {
                jSONObject.put(str, obj);
            } catch (Exception unused) {
            }
        }
    }

    public static JSONObject getCommonParams(int i, TrackEntity trackEntity, JSONObject... jSONObjectArr) {
        JSONObject jSONObject = new JSONObject();
        try {
            jSONObject.put("time", String.valueOf(System.currentTimeMillis()));
            jSONObject.put("statsType", i);
            if (trackEntity != null) {
                jSONObject.put("entranceId", trackEntity.getEntranceId());
                jSONObject.put("activeId", trackEntity.getActiveId());
            }
            jSONObject.put("deviceId", DeviceUuidFactory.m137id(AIHelpContext.getInstance().getContext()));
            jSONObject.put("countryCode", DeviceInfoUtil.getInstance().getSimCountryIso());
            jSONObject.put("userId", UserProfile.USER_ID);
            jSONObject.put("platform", 2);
            jSONObject.put("lan", Const.CORRECT_LANGUAGE);
            jSONObject.put("appId", Const.APP_ID);
            if (jSONObjectArr != null && jSONObjectArr.length > 0) {
                jSONObject.put("extendData", jSONObjectArr[0]);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return jSONObject;
    }
}
