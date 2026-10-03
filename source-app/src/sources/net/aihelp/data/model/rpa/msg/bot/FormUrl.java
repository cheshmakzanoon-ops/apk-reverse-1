package net.aihelp.data.model.rpa.msg.bot;

import android.text.TextUtils;
import net.aihelp.BuildConfig;
import net.aihelp.common.Const;
import net.aihelp.common.UserProfile;

public class FormUrl {
    private final String link;
    private final String title;

    public FormUrl(String str, String str2) {
        this.title = str;
        this.link = getFormattedFormUrl(str2);
    }

    public String getTitle() {
        return this.title;
    }

    public String getLink() {
        return this.link;
    }

    private static String getFormattedFormUrl(String str) {
        if (!TextUtils.isEmpty(str)) {
            return String.format("%s&appId=%s&userId=%s&serverId=%s&platform=%s&sdkVersion=%s&isTicket=1&hasPermission=%s&fromSdk=1&isCustom=1", str, Const.APP_ID, UserProfile.USER_ID, UserProfile.SERVER_ID, 2, BuildConfig.SDK_VERSION, 0);
        }
        return "";
    }
}
