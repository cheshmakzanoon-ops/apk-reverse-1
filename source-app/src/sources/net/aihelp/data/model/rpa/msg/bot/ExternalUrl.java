package net.aihelp.data.model.rpa.msg.bot;

import android.os.Build;
import android.text.TextUtils;
import net.aihelp.common.API;
import net.aihelp.common.UserProfile;
import net.aihelp.core.net.http.AIHelpRequest;
import net.aihelp.core.net.http.callback.ReqCallback;
import net.aihelp.core.net.json.JsonHelper;
import net.aihelp.utils.DeviceInfoUtil;
import org.json.JSONObject;

public class ExternalUrl {
    private String link;
    private final String title;

    public ExternalUrl(String str, String str2) {
        this.title = str;
        this.link = str2;
        getFormattedUrl(str2);
    }

    public String getTitle() {
        return this.title;
    }

    public String getLink() {
        return this.link;
    }

    private void getFormattedUrl(final String str) {
        if (TextUtils.isEmpty(str) || !str.contains("type=login")) {
            return;
        }
        try {
            JSONObject jSONObject = new JSONObject();
            jSONObject.put("modelInfo", String.format("%s %s", Build.MANUFACTURER, Build.MODEL));
            jSONObject.put("userId", UserProfile.USER_ID);
            jSONObject.put("serverId", UserProfile.SERVER_ID);
            jSONObject.put("country", DeviceInfoUtil.getInstance().getSimCountryIso());
            AIHelpRequest.getInstance().requestPostByJson(API.GET_USER_TOKEN, jSONObject, new ReqCallback<String>() {
                @Override
                public void onReqSuccess(String str2) {
                    try {
                        ExternalUrl.this.link = String.format("%s&clientparam=%s", str, JsonHelper.optString(new JSONObject(str2), "userToken"));
                    } catch (Exception unused) {
                    }
                }
            });
        } catch (Exception unused) {
        }
    }
}
