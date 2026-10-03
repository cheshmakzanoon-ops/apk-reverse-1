package net.aihelp.data.track;

import android.text.TextUtils;
import j$.util.concurrent.ConcurrentHashMap;
import net.aihelp.common.API;
import net.aihelp.common.Const;
import net.aihelp.common.UserProfile;
import net.aihelp.config.AIHelpContext;
import net.aihelp.core.net.http.AIHelpRequest;
import net.aihelp.core.net.http.callback.BaseCallback;
import net.aihelp.core.net.json.JsonHelper;
import net.aihelp.data.localize.util.LocalizeUtil;
import net.aihelp.utils.DeviceInfoUtil;
import net.aihelp.utils.DeviceUuidFactory;
import org.json.JSONObject;

public class ResourceLoadTracker {
    private static final int RESOURCE_REQUEST_THRESHOLD = 5000;
    private static ResourceLoadTracker sInstance;
    private long initDuration;
    private long initEndTime;
    private long initStartTime;
    private boolean isInitSuccess;
    private int resourceCount;
    private ConcurrentHashMap<String, Long> resourceLoadingMap = new ConcurrentHashMap<>();

    public void markInitStarted() {
        reset();
        this.initStartTime = System.currentTimeMillis();
    }

    public void markInitEnded(boolean z) {
        this.isInitSuccess = z;
        long jCurrentTimeMillis = System.currentTimeMillis();
        this.initEndTime = jCurrentTimeMillis;
        this.initDuration = jCurrentTimeMillis - this.initStartTime;
        if (z) {
            return;
        }
        AIHelpRequest.getInstance().requestPostByJson(API.TRACK_LOCALIZE_DURATION_EXTREME, getTrackData(-1L), (BaseCallback) null);
    }

    public void onResourceRequested(int i) {
        this.resourceCount = i;
    }

    public void onResourceRetrieved(int i, boolean z) {
        this.resourceCount--;
        String strReplace = LocalizeUtil.getFolderName(i).replace("/", "");
        long jCurrentTimeMillis = System.currentTimeMillis() - this.initEndTime;
        this.resourceLoadingMap.put(strReplace, Long.valueOf(z ? jCurrentTimeMillis : -1L));
        if (this.resourceCount <= 0) {
            AIHelpRequest aIHelpRequest = AIHelpRequest.getInstance();
            if (jCurrentTimeMillis >= 5000) {
                aIHelpRequest.requestPostByJson(API.TRACK_LOCALIZE_DURATION_EXTREME, getTrackData(jCurrentTimeMillis), (BaseCallback) null);
            } else {
                aIHelpRequest.requestPostByJson(API.TRACK_LOCALIZE_DURATION, getTrackData(jCurrentTimeMillis), (BaseCallback) null);
            }
        }
    }

    private JSONObject getTrackData(long j) {
        JSONObject commonParams = getCommonParams();
        JsonHelper.put(commonParams, "success", Boolean.valueOf(this.isInitSuccess));
        JsonHelper.put(commonParams, "initLoadingTime", Long.valueOf(this.initDuration));
        JsonHelper.put(commonParams, "sdkSettingLoadingTime", Long.valueOf(j));
        JSONObject jsonObject = JsonHelper.getJsonObject();
        for (String str : this.resourceLoadingMap.keySet()) {
            Long l = (Long) this.resourceLoadingMap.get(str);
            if (!TextUtils.isEmpty(str) && l != null) {
                JsonHelper.put(jsonObject, str, l);
            }
        }
        JsonHelper.put(commonParams, "sdkSettingDict", jsonObject);
        return commonParams;
    }

    private JSONObject getCommonParams() {
        JSONObject jSONObject = new JSONObject();
        try {
            jSONObject.put("time", String.valueOf(System.currentTimeMillis()));
            jSONObject.put("deviceId", DeviceUuidFactory.m137id(AIHelpContext.getInstance().getContext()));
            jSONObject.put("countryCode", DeviceInfoUtil.getInstance().getSimCountryIso());
            jSONObject.put("userId", UserProfile.USER_ID);
            jSONObject.put("platform", 2);
            jSONObject.put("lan", Const.CORRECT_LANGUAGE);
            jSONObject.put("appId", Const.APP_ID);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return jSONObject;
    }

    private void reset() {
        this.isInitSuccess = false;
        this.initStartTime = 0L;
        this.initEndTime = 0L;
        this.resourceLoadingMap = new ConcurrentHashMap<>();
    }

    private ResourceLoadTracker() {
        reset();
    }

    public static ResourceLoadTracker getInstance() {
        if (sInstance == null) {
            sInstance = new ResourceLoadTracker();
        }
        return sInstance;
    }
}
