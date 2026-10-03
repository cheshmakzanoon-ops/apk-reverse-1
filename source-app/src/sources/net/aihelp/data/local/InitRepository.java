package net.aihelp.data.local;

import android.content.Context;
import android.text.TextUtils;
import net.aihelp.common.API;
import net.aihelp.common.Const;
import net.aihelp.common.SpKeys;
import net.aihelp.common.UserProfile;
import net.aihelp.config.UserConfig;
import net.aihelp.core.mvp.AbsRepository;
import net.aihelp.utils.DeviceUuidFactory;
import net.aihelp.utils.DomainSupportHelper;
import net.aihelp.utils.LocaleUtil;

public class InitRepository extends AbsRepository {
    public InitRepository(Context context) {
        super(context);
    }

    public void saveInitConfig(String str, String str2, String str3, String str4) {
        Const.APP_KEY = str;
        API.HOST_URL = DomainSupportHelper.getOptimizedDomain(str2);
        Const.APP_ID = str3;
        if (!TextUtils.isEmpty(str4)) {
            Const.ORIGINAL_LANGUAGE = LocaleUtil.getFormatLanguage(str4);
        }
        Const.CORRECT_LANGUAGE = Const.ORIGINAL_LANGUAGE;
        UserProfile.resetUserProfile(this.mContext);
    }

    public void saveUserProfileConfig(UserConfig userConfig) {
        if (Const.TOGGLE_DISTINGUISH_USER_BY_DEVICE) {
            UserProfile.USER_ID = String.format("%s|%s", DeviceUuidFactory.m137id(this.mContext), userConfig.getUserId());
        } else {
            UserProfile.USER_ID = userConfig.getUserId();
        }
        UserProfile.USER_NAME = userConfig.getUserName();
        UserProfile.SERVER_ID = userConfig.getServerId();
        UserProfile.CUSTOM_DATA = userConfig.getFormatCustomData();
    }

    public void setUploadLogPath(String str) {
        Const.LOG_UPLOAD_PATH = str;
    }

    public void setNetworkCheckHostAddress(String str) {
        Const.NET_CHECK_HOST = str;
    }

    public void saveCrmInfo(String str, String str2) {
        doSave(SpKeys.CRM_USER_INFO + str, String.format("%s|%s", str, str2));
    }

    public void saveMqttPushInfo(String str, int i) {
        Const.PUSH_INFO = String.format("%s|%s", str, Integer.valueOf(i));
    }
}
