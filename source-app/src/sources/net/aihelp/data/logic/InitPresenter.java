package net.aihelp.data.logic;

import android.content.Context;
import android.text.TextUtils;
import android.util.Log;
import net.aihelp.common.API;
import net.aihelp.common.Const;
import net.aihelp.common.SpKeys;
import net.aihelp.common.UserProfile;
import net.aihelp.config.AIHelpContext;
import net.aihelp.config.UserConfig;
import net.aihelp.core.mvp.AbsPresenter;
import net.aihelp.core.mvp.IView;
import net.aihelp.core.net.http.callback.ReqCallback;
import net.aihelp.data.local.InitRepository;
import net.aihelp.init.InitHelper;
import net.aihelp.p007ui.listener.OnMessageCountArrivedCallback;
import net.aihelp.p007ui.listener.OnNetworkCheckResultCallback;
import net.aihelp.p007ui.p009cs.util.TicketStatusTracker;
import net.aihelp.utils.DeviceUuidFactory;
import net.aihelp.utils.LocaleUtil;
import org.json.JSONException;
import org.json.JSONObject;

public class InitPresenter extends AbsPresenter<IView, InitRepository> {
    private UnreadMessagePoller unreadMsgPoller;

    public InitPresenter(Context context, String str, String str2, String str3, String str4) {
        super(context);
        ((InitRepository) this.mRepo).saveInitConfig(str, str2, str3, str4);
    }

    public void updateUserProfile(final UserConfig userConfig) {
        if (userConfig == null) {
            return;
        }
        ((InitRepository) this.mRepo).saveUserProfileConfig(userConfig);
        Const.TOGGLE_FETCH_MESSAGE = true;
        TicketStatusTracker.resetTicketStatusFlags();
        if (userConfig.isSyncCrmInfo()) {
            if (!String.format("%s|%s", userConfig.getUserId(), userConfig.getUserTags()).equals(this.mSp.getString(SpKeys.CRM_USER_INFO + userConfig.getUserId()))) {
                try {
                    JSONObject jSONObject = new JSONObject();
                    jSONObject.put("userName", userConfig.getUserName());
                    jSONObject.put("uId", userConfig.getUserId());
                    jSONObject.put("tags", userConfig.getUserTags());
                    post(API.SYNC_VIP_INFO, jSONObject, new ReqCallback<String>() {
                        @Override
                        public void onReqSuccess(String str) {
                            ((InitRepository) InitPresenter.this.mRepo).saveCrmInfo(userConfig.getUserId(), userConfig.getUserTags());
                        }
                    });
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        }
        postCrmPushTokenInfo();
    }

    public void postCrmPushTokenInfo() {
        String str = UserProfile.PUSH_TOKEN;
        int i = UserProfile.PUSH_PLATFORM;
        if (TextUtils.isEmpty(str) || i <= 0) {
            return;
        }
        ((InitRepository) this.mRepo).saveMqttPushInfo(str, i);
        if (Const.TOGGLE_CRM_TOKEN) {
            final String str2 = String.format("%s|%s|%s", UserProfile.USER_ID, str, Integer.valueOf(i));
            if (str2.equals(this.mSp.getString(SpKeys.PUSH_INFO_CRM))) {
                return;
            }
            try {
                JSONObject jSONObject = new JSONObject();
                jSONObject.put("token", str);
                jSONObject.put("pushTypeId", i);
                jSONObject.put("playerId", UserProfile.USER_ID);
                jSONObject.put("playerName", UserProfile.USER_NAME);
                jSONObject.put("language", Const.CORRECT_LANGUAGE);
                jSONObject.put("deviceId", DeviceUuidFactory.m137id(this.mContext));
                post(API.CRM_TOKEN_URL, jSONObject, new ReqCallback<String>() {
                    @Override
                    public void onReqSuccess(String str3) {
                        InitPresenter.this.mSp.put(SpKeys.PUSH_INFO_CRM, str2);
                    }
                });
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public void updateSDKLanguage(String str) {
        String formatLanguage = LocaleUtil.getFormatLanguage(str);
        if (!Const.ORIGINAL_LANGUAGE.equals(formatLanguage)) {
            AIHelpContext.successfullyInit.set(false);
            Const.ORIGINAL_LANGUAGE = formatLanguage;
            Const.CORRECT_LANGUAGE = Const.ORIGINAL_LANGUAGE;
            InitHelper.getInstance().requestInit(false);
            return;
        }
        Log.e("TAG", "AIHelp is using " + formatLanguage + " as global language already!");
    }

    public void setUploadLogPath(String str) {
        ((InitRepository) this.mRepo).setUploadLogPath(str);
    }

    public void setNetworkCheckHostAddress(String str, OnNetworkCheckResultCallback onNetworkCheckResultCallback) {
        String strReplace;
        if (TextUtils.isEmpty(str)) {
            strReplace = "aihelp.net";
        } else {
            strReplace = str.replace("http://", "").replace("https://", "");
        }
        ((InitRepository) this.mRepo).setNetworkCheckHostAddress(strReplace);
        Const.sCheckResultListener = onNetworkCheckResultCallback;
    }

    public void startUnreadMessagePolling(OnMessageCountArrivedCallback onMessageCountArrivedCallback) {
        if (onMessageCountArrivedCallback == null || this.unreadMsgPoller != null) {
            return;
        }
        Const.sMessageListener = onMessageCountArrivedCallback;
        UnreadMessagePoller unreadMessagePoller = new UnreadMessagePoller();
        this.unreadMsgPoller = unreadMessagePoller;
        unreadMessagePoller.start();
    }

    public void stopUnreadMessagePolling() {
        UnreadMessagePoller unreadMessagePoller;
        if (Const.sMessageListener == null || (unreadMessagePoller = this.unreadMsgPoller) == null) {
            return;
        }
        unreadMessagePoller.stop();
        Const.sMessageListener = null;
    }
}
