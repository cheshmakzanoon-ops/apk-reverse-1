package net.aihelp.init;

import android.content.Context;
import net.aihelp.BuildConfig;
import net.aihelp.common.Const;
import net.aihelp.config.AIHelpContext;
import net.aihelp.config.ApiConfig;
import net.aihelp.config.UserConfig;
import net.aihelp.config.enums.PublishCountryOrRegion;
import net.aihelp.config.enums.PushPlatform;
import net.aihelp.config.enums.ShowConversationMoment;
import net.aihelp.core.util.concurrent.ApiExecutorFactory;
import net.aihelp.exception.AIHelpInitException;
import net.aihelp.p007ui.listener.OnAIHelpInitializedCallback;
import net.aihelp.p007ui.listener.OnAIHelpSessionCloseCallback;
import net.aihelp.p007ui.listener.OnAIHelpSessionOpenCallback;
import net.aihelp.p007ui.listener.OnMessageCountArrivedCallback;
import net.aihelp.p007ui.listener.OnNetworkCheckResultCallback;
import net.aihelp.p007ui.listener.OnSpecificFormSubmittedCallback;
import net.aihelp.p007ui.listener.OnSpecificUrlClickedCallback;
import net.aihelp.utils.DeviceUuidFactory;

public class AIHelpSupport {
    public static void init(Context context, String str, String str2, String str3) {
        init(context, str, str2, str3, Const.CORRECT_LANGUAGE);
    }

    public static void init(Context context, String str, String str2, String str3, String str4) throws AIHelpInitException {
        AIHelpCore.getInstance().init(context, str, str2, str3, str4);
    }

    public static void setOnAIHelpInitializedCallback(final OnAIHelpInitializedCallback onAIHelpInitializedCallback) {
        ApiExecutorFactory.getHandlerExecutor().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                AIHelpCore.getInstance().setOnAIHelpInitializedCallback(onAIHelpInitializedCallback);
            }
        });
    }

    public static boolean show(String str) {
        return AIHelpCore.getInstance().show(new ApiConfig.Builder().setEntranceId(str).build());
    }

    public static boolean show(ApiConfig apiConfig) {
        return AIHelpCore.getInstance().show(apiConfig);
    }

    public static void showSingleFAQ(final String str, final ShowConversationMoment showConversationMoment) {
        ApiExecutorFactory.getHandlerExecutor().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                AIHelpCore.getInstance().showSingleFAQ(str, showConversationMoment);
            }
        });
    }

    public static void showUrl(final String str) {
        ApiExecutorFactory.getHandlerExecutor().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                AIHelpCore.getInstance().showUrl(str);
            }
        });
    }

    public static void updateUserInfo(final UserConfig userConfig) {
        ApiExecutorFactory.getHandlerExecutor().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                AIHelpCore.getInstance().updateUserInfo(userConfig);
            }
        });
    }

    public static void resetUserInfo() {
        Context context = AIHelpContext.getInstance().getContext();
        if (context != null) {
            updateUserInfo(new UserConfig.Builder().setUserId(DeviceUuidFactory.m137id(context)).setServerId("-1").setUserName("anonymous").build());
        }
    }

    public static void updateSDKLanguage(final String str) {
        ApiExecutorFactory.getHandlerExecutor().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                AIHelpCore.getInstance().updateSDKLanguage(str);
            }
        });
    }

    public static void startUnreadMessageCountPolling(final OnMessageCountArrivedCallback onMessageCountArrivedCallback) {
        ApiExecutorFactory.getHandlerExecutor().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                AIHelpCore.getInstance().startUnreadMessageCountPolling(onMessageCountArrivedCallback);
            }
        });
    }

    public static void stopUnreadMessageCountPolling() {
        ApiExecutorFactory.getHandlerExecutor().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                AIHelpCore.getInstance().stopUnreadMessageCountPolling();
            }
        });
    }

    public static void setUploadLogPath(final String str) {
        ApiExecutorFactory.getHandlerExecutor().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                AIHelpCore.getInstance().setUploadLogPath(str);
            }
        });
    }

    public static void setPushTokenAndPlatform(final String str, final PushPlatform pushPlatform) {
        ApiExecutorFactory.getHandlerExecutor().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                AIHelpCore.getInstance().setPushTokenAndPlatform(str, pushPlatform);
            }
        });
    }

    public static void setNetworkCheckHostAddress(String str) {
        setNetworkCheckHostAddress(str, null);
    }

    public static void setNetworkCheckHostAddress(final String str, final OnNetworkCheckResultCallback onNetworkCheckResultCallback) {
        ApiExecutorFactory.getHandlerExecutor().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                AIHelpCore.getInstance().setNetworkCheckHostAddress(str, onNetworkCheckResultCallback);
            }
        });
    }

    public static void setOnSpecificFormSubmittedCallback(final OnSpecificFormSubmittedCallback onSpecificFormSubmittedCallback) {
        ApiExecutorFactory.getHandlerExecutor().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                AIHelpCore.getInstance().setOnSpecificFormSubmittedCallback(onSpecificFormSubmittedCallback);
            }
        });
    }

    public static void setOnAIHelpSessionOpenCallback(final OnAIHelpSessionOpenCallback onAIHelpSessionOpenCallback) {
        ApiExecutorFactory.getHandlerExecutor().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                AIHelpCore.getInstance().setOnAIHelpSessionOpenCallback(onAIHelpSessionOpenCallback);
            }
        });
    }

    public static void setOnAIHelpSessionCloseCallback(final OnAIHelpSessionCloseCallback onAIHelpSessionCloseCallback) {
        ApiExecutorFactory.getHandlerExecutor().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                AIHelpCore.getInstance().setOnAIHelpSessionCloseCallback(onAIHelpSessionCloseCallback);
            }
        });
    }

    public static void setOnSpecificUrlClickedCallback(final OnSpecificUrlClickedCallback onSpecificUrlClickedCallback) {
        ApiExecutorFactory.getHandlerExecutor().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                AIHelpCore.getInstance().setOnSpecificUrlClickedCallback(onSpecificUrlClickedCallback);
            }
        });
    }

    public static void additionalSupportFor(final PublishCountryOrRegion publishCountryOrRegion) {
        ApiExecutorFactory.getHandlerExecutor().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                AIHelpCore.getInstance().additionalSupportFor(publishCountryOrRegion);
            }
        });
    }

    public static String getSDKVersion() {
        return BuildConfig.SDK_VERSION;
    }

    public static boolean isAIHelpShowing() {
        return Const.IS_SDK_SHOWING;
    }

    public static void enableLogging(boolean z) {
        AIHelpCore.getInstance().enableLogging(z);
    }

    public static void close() {
        AIHelpCore.getInstance().close();
    }
}
