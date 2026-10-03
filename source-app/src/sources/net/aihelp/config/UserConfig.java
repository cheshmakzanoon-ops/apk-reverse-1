package net.aihelp.config;

import android.text.TextUtils;
import java.util.Arrays;
import java.util.Iterator;
import net.aihelp.common.UserProfile;
import net.aihelp.config.enums.PushPlatform;
import org.json.JSONObject;

public class UserConfig {
    private String formatCustomData;
    private boolean isSyncCrmInfo;
    private String serverId;
    private String userId;
    private String userName;
    private String userTags;

    public static class Builder {
        private boolean isSyncCrmInfo;
        private String userId = "";
        private String userName = "";
        private String serverId = "";
        private String userTags = "";
        private String customData = "";

        public Builder setUserId(String str) {
            if (!TextUtils.isEmpty(str) && !"0".equals(str) && !"-1".equals(str)) {
                this.userId = str.trim().replace("/", "%2F").replace("+", "%2B").replace("#", "%23").replace(" ", "%20").replace("|", "%7C");
            }
            return this;
        }

        public Builder setUserName(String str) {
            if (!TextUtils.isEmpty(str)) {
                this.userName = str;
            }
            return this;
        }

        public Builder setServerId(String str) {
            if (!TextUtils.isEmpty(str) && !"0".equals(str) && !"-1".equals(str)) {
                this.serverId = str;
            }
            return this;
        }

        public Builder setUserTags(String str) {
            if (!TextUtils.isEmpty(str)) {
                this.userTags = str;
            }
            return this;
        }

        public Builder setCustomData(String str) {
            if (!TextUtils.isEmpty(str)) {
                this.customData = str;
            }
            return this;
        }

        public Builder setSyncCrmInfo(boolean z) {
            this.isSyncCrmInfo = z;
            return this;
        }

        private String getFormattedCustomData() {
            JSONObject jSONObject = new JSONObject();
            try {
                JSONObject jSONObject2 = new JSONObject();
                if (!TextUtils.isEmpty(this.userTags)) {
                    String[] strArrSplit = this.userTags.trim().split(",");
                    if (strArrSplit.length > 0) {
                        jSONObject2.put("elva-tags", (Object) Arrays.asList(strArrSplit));
                        jSONObject2.put("hs-tags", this.userTags);
                    }
                }
                try {
                    if (!TextUtils.isEmpty(this.customData)) {
                        JSONObject jSONObject3 = new JSONObject(this.customData);
                        Iterator<String> itKeys = jSONObject3.keys();
                        while (itKeys.hasNext()) {
                            String next = itKeys.next();
                            jSONObject2.put(next, jSONObject3.opt(next));
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
                jSONObject.put("elva-custom-metadata", jSONObject2);
                jSONObject.put("hs-custom-metadata", new JSONObject(jSONObject2.toString()));
            } catch (Exception e2) {
                e2.printStackTrace();
            }
            return jSONObject.toString();
        }

        public UserConfig build(String str, String str2, String str3, String str4, String str5, boolean z) {
            return setUserId(str).setUserName(str2).setServerId(str3).setUserTags(str4).setCustomData(str5).setSyncCrmInfo(z).build();
        }

        public UserConfig build(String str, String str2, String str3, String str4, String str5, boolean z, String str6, PushPlatform pushPlatform) {
            return setUserId(str).setUserName(str2).setServerId(str3).setUserTags(str4).setCustomData(str5).setSyncCrmInfo(z).build();
        }

        public UserConfig build() {
            return new UserConfig(this.userId, this.userName, this.serverId, this.userTags, getFormattedCustomData(), this.isSyncCrmInfo, "", null);
        }
    }

    public boolean isSyncCrmInfo() {
        return this.isSyncCrmInfo;
    }

    public String getUserId() {
        if (TextUtils.isEmpty(this.userId)) {
            return UserProfile.USER_ID;
        }
        return this.userId;
    }

    public String getUserName() {
        if (TextUtils.isEmpty(this.userName)) {
            return UserProfile.USER_NAME;
        }
        return this.userName;
    }

    public String getServerId() {
        if (TextUtils.isEmpty(this.serverId)) {
            return UserProfile.SERVER_ID;
        }
        return this.serverId;
    }

    public String getUserTags() {
        return this.userTags;
    }

    public String getFormatCustomData() {
        if (TextUtils.isEmpty(this.formatCustomData)) {
            return UserProfile.CUSTOM_DATA;
        }
        return this.formatCustomData;
    }

    private UserConfig(String str, String str2, String str3, String str4, String str5, boolean z) {
        this.userId = str;
        this.userName = str2;
        this.serverId = str3;
        this.userTags = str4;
        this.formatCustomData = str5;
        this.isSyncCrmInfo = z;
    }

    private UserConfig(String str, String str2, String str3, String str4, String str5, boolean z, String str6, PushPlatform pushPlatform) {
        this.userId = str;
        this.userName = str2;
        this.serverId = str3;
        this.userTags = str4;
        this.formatCustomData = str5;
        this.isSyncCrmInfo = z;
    }
}
