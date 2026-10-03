package net.aihelp.p007ui.helper;

import android.os.Build;
import net.aihelp.BuildConfig;
import net.aihelp.common.API;
import net.aihelp.common.Const;
import net.aihelp.common.UserProfile;
import net.aihelp.config.AIHelpContext;
import net.aihelp.core.net.http.AIHelpRequest;
import net.aihelp.core.net.http.callback.ReqCallback;
import net.aihelp.core.util.logger.AIHelpLogger;
import net.aihelp.utils.AppInfoUtil;
import net.aihelp.utils.DeviceUuidFactory;
import org.json.JSONArray;
import org.json.JSONObject;

public class MessageSyncHelper {
    public static void syncLogMessage() {
        try {
            JSONArray cachedLogs = AIHelpLogger.INSTANCE.getCachedLogs();
            if (cachedLogs.length() > 0) {
                JSONObject jSONObject = new JSONObject();
                jSONObject.put("deviceModel", Build.MODEL);
                jSONObject.put("language", Const.ORIGINAL_LANGUAGE);
                jSONObject.put("OSVersion", Build.VERSION.RELEASE);
                jSONObject.put("gameVersion", AppInfoUtil.getAppVersion(AIHelpContext.getInstance().getContext()));
                jSONObject.put("userId", UserProfile.USER_ID);
                jSONObject.put("deviceId", DeviceUuidFactory.m137id(AIHelpContext.getInstance().getContext()));
                jSONObject.put("sdkVersion", BuildConfig.SDK_VERSION);
                jSONObject.put("logs", cachedLogs);
                AIHelpRequest.getInstance().requestPostByJson(API.TRACK_EXCEPTION, jSONObject, new ReqCallback<String>() {
                    @Override
                    public void onAsyncReqSuccess(String str) {
                        AIHelpLogger.INSTANCE.deleteAllCachedLogs();
                    }
                });
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
