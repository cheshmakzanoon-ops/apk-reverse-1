package net.aihelp.init;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.Intent;
import android.text.TextUtils;
import android.util.Log;
import java.lang.ref.WeakReference;
import net.aihelp.common.Const;
import net.aihelp.common.IntentValues;
import net.aihelp.common.SpKeys;
import net.aihelp.common.UserProfile;
import net.aihelp.config.AIHelpContext;
import net.aihelp.config.ApiConfig;
import net.aihelp.config.UserConfig;
import net.aihelp.config.enums.PublishCountryOrRegion;
import net.aihelp.config.enums.PushPlatform;
import net.aihelp.config.enums.ShowConversationMoment;
import net.aihelp.core.net.http.config.HttpConfig;
import net.aihelp.core.net.monitor.NetworkMonitorManager;
import net.aihelp.core.p004ui.ActivityManager;
import net.aihelp.core.util.concurrent.ApiExecutorFactory;
import net.aihelp.core.util.crash.AIHelpCrashHandler;
import net.aihelp.data.localize.config.ProcessEntranceHelper;
import net.aihelp.data.logic.InitPresenter;
import net.aihelp.data.model.config.ProcessEntity;
import net.aihelp.exception.AIHelpInitException;
import net.aihelp.p007ui.listener.OnAIHelpInitializedCallback;
import net.aihelp.p007ui.listener.OnAIHelpSessionCloseCallback;
import net.aihelp.p007ui.listener.OnAIHelpSessionOpenCallback;
import net.aihelp.p007ui.listener.OnMessageCountArrivedCallback;
import net.aihelp.p007ui.listener.OnNetworkCheckResultCallback;
import net.aihelp.p007ui.listener.OnSpecificFormSubmittedCallback;
import net.aihelp.p007ui.listener.OnSpecificUrlClickedCallback;
import net.aihelp.p007ui.webkit.WebViewUtil;
import net.aihelp.utils.AppInfoUtil;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.SchemaUtil;
import net.aihelp.utils.SpUtil;
import net.aihelp.utils.TLog;
import net.aihelp.utils.ToastUtil;

class AIHelpCore {
    private WeakReference<Activity> mActivity;
    private Context mAppContext;
    private InitPresenter mInitPresenter;
    private Object refWatcher;

    private void installLeakCanary(Application application) {
    }

    public void init(final Context context, String str, String str2, String str3, final String str4) throws AIHelpInitException {
        try {
            final String strTrim = !TextUtils.isEmpty(str) ? str.trim() : str;
            final String strTrim2 = !TextUtils.isEmpty(str2) ? str2.trim() : str2;
            final String strGenerateAppIdFromAppKey = generateAppIdFromAppKey(str, str2, str3);
            SchemaUtil.validateInitializeCredentials(context, strTrim, strTrim2, strGenerateAppIdFromAppKey);
            ApiExecutorFactory.getHandlerExecutor().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    if (context instanceof Activity) {
                        AIHelpCore.this.mActivity = new WeakReference((Activity) context);
                    }
                    AIHelpCore.this.mAppContext = context.getApplicationContext();
                    AIHelpContext.getInstance().setContext(AIHelpCore.this.mAppContext);
                    AIHelpCrashHandler.INSTANCE.init(AIHelpCore.this.mAppContext);
                    WebViewUtil.prepareDataDirectorySuffix(AIHelpCore.this.mAppContext);
                    AIHelpCore.this.mInitPresenter = new InitPresenter(AIHelpCore.this.mAppContext, strTrim, strTrim2, strGenerateAppIdFromAppKey, str4);
                    if (SpUtil.getInstance().getBoolean(SpKeys.TOGGLE_LOG)) {
                        TLog.initLog(true);
                    }
                    NetworkMonitorManager.getInstance().init(AIHelpCore.this.mAppContext);
                    InitHelper.getInstance().runInitRelatedTask(AIHelpCore.this.mAppContext);
                }
            });
        } catch (AIHelpInitException e) {
            throw e;
        } catch (Exception e2) {
            e2.printStackTrace();
        }
    }

    private String generateAppIdFromAppKey(String str, String str2, String str3) {
        if (TextUtils.isEmpty(str3) && !TextUtils.isEmpty(str) && !TextUtils.isEmpty(str2)) {
            String strReplace = str2.replace("https://", "").replace("http://", "");
            String strMd5 = HttpConfig.md5(str.toLowerCase() + "AIHelpSDKToAndroidAppId");
            return strReplace.toLowerCase().substring(0, strReplace.indexOf(".")) + "_platform_" + strMd5;
        }
        return str3.trim();
    }

    boolean show(ApiConfig apiConfig) {
        if (isInitStillInProgress()) {
            return false;
        }
        ProcessEntity process = ProcessEntranceHelper.INSTANCE.getProcess(apiConfig.getEntranceId());
        Const.CUSTOM_WELCOME_MSG = apiConfig.getWelcomeMessage();
        int intent = process.getIntent();
        if (intent == 1) {
            showHelpCenter(process);
        } else if (intent == 2) {
            showFAQSection(process);
        } else if (intent == 3) {
            showSingleFAQ(process);
        } else if (intent == 4) {
            showCustomerService();
        } else {
            showErrorEntrancePage();
        }
        return true;
    }

    private void showErrorEntrancePage() {
        Intent showErrorEntranceIntent = IntentValues.getShowErrorEntranceIntent(this.mAppContext);
        WeakReference<Activity> weakReference = this.mActivity;
        if (weakReference != null && weakReference.get() != null) {
            this.mActivity.get().startActivity(showErrorEntranceIntent);
        } else {
            this.mAppContext.startActivity(IntentValues.wrapForApplicationContext(showErrorEntranceIntent));
        }
    }

    void showHelpCenter(ProcessEntity processEntity) {
        Intent showFAQIntent = IntentValues.getShowFAQIntent(this.mAppContext, processEntity);
        WeakReference<Activity> weakReference = this.mActivity;
        if (weakReference != null && weakReference.get() != null) {
            this.mActivity.get().startActivity(showFAQIntent);
        } else {
            this.mAppContext.startActivity(IntentValues.wrapForApplicationContext(showFAQIntent));
        }
    }

    void showFAQSection(ProcessEntity processEntity) {
        Intent showFAQSectionIntent = IntentValues.getShowFAQSectionIntent(this.mAppContext, processEntity);
        WeakReference<Activity> weakReference = this.mActivity;
        if (weakReference != null && weakReference.get() != null) {
            this.mActivity.get().startActivity(showFAQSectionIntent);
        } else {
            this.mAppContext.startActivity(IntentValues.wrapForApplicationContext(showFAQSectionIntent));
        }
    }

    void showSingleFAQ(ProcessEntity processEntity) {
        Intent showSingleFAQIntent = IntentValues.getShowSingleFAQIntent(this.mAppContext, processEntity);
        WeakReference<Activity> weakReference = this.mActivity;
        if (weakReference != null && weakReference.get() != null) {
            this.mActivity.get().startActivity(showSingleFAQIntent);
        } else {
            this.mAppContext.startActivity(IntentValues.wrapForApplicationContext(showSingleFAQIntent));
        }
    }

    void showSingleFAQ(String str, ShowConversationMoment showConversationMoment) {
        Intent showSingleFAQIntent = IntentValues.getShowSingleFAQIntent(this.mAppContext, str, showConversationMoment);
        WeakReference<Activity> weakReference = this.mActivity;
        if (weakReference != null && weakReference.get() != null) {
            this.mActivity.get().startActivity(showSingleFAQIntent);
        } else {
            this.mAppContext.startActivity(IntentValues.wrapForApplicationContext(showSingleFAQIntent));
        }
    }

    void showCustomerService() {
        Intent showCustomerServiceIntent = IntentValues.getShowCustomerServiceIntent(this.mAppContext);
        WeakReference<Activity> weakReference = this.mActivity;
        if (weakReference != null && weakReference.get() != null) {
            this.mActivity.get().startActivity(showCustomerServiceIntent);
        } else {
            this.mAppContext.startActivity(IntentValues.wrapForApplicationContext(showCustomerServiceIntent));
        }
    }

    void updateSDKLanguage(String str) {
        try {
            if (isInitStillInProgress()) {
                return;
            }
            this.mInitPresenter.updateSDKLanguage(str);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    void showUrl(String str) {
        if (this.mAppContext != null && !TextUtils.isEmpty(str)) {
            Intent urlIntent = IntentValues.getUrlIntent(this.mAppContext, str);
            WeakReference<Activity> weakReference = this.mActivity;
            if (weakReference != null && weakReference.get() != null) {
                this.mActivity.get().startActivity(urlIntent);
                return;
            } else {
                this.mAppContext.startActivity(IntentValues.wrapForApplicationContext(urlIntent));
                return;
            }
        }
        TLog.m139d("AIHelp", "AIHelpSupport showUrl illegal argument");
    }

    void updateUserInfo(UserConfig userConfig) {
        if (isPresenterStillNull()) {
            return;
        }
        this.mInitPresenter.updateUserProfile(userConfig);
    }

    void setUploadLogPath(String str) {
        if (isPresenterStillNull()) {
            return;
        }
        this.mInitPresenter.setUploadLogPath(str);
    }

    void setNetworkCheckHostAddress(String str, OnNetworkCheckResultCallback onNetworkCheckResultCallback) {
        if (isPresenterStillNull()) {
            return;
        }
        this.mInitPresenter.setNetworkCheckHostAddress(str, onNetworkCheckResultCallback);
    }

    void setPushTokenAndPlatform(String str, PushPlatform pushPlatform) {
        if (isPresenterStillNull() || pushPlatform == null) {
            return;
        }
        UserProfile.PUSH_TOKEN = str;
        UserProfile.PUSH_PLATFORM = pushPlatform.getValue();
        this.mInitPresenter.postCrmPushTokenInfo();
    }

    void additionalSupportFor(PublishCountryOrRegion publishCountryOrRegion) {
        Const.countryOrRegion = publishCountryOrRegion;
    }

    void startUnreadMessageCountPolling(OnMessageCountArrivedCallback onMessageCountArrivedCallback) {
        if (isPresenterStillNull()) {
            return;
        }
        this.mInitPresenter.startUnreadMessagePolling(onMessageCountArrivedCallback);
    }

    void stopUnreadMessageCountPolling() {
        if (isPresenterStillNull()) {
            return;
        }
        this.mInitPresenter.stopUnreadMessagePolling();
    }

    void setOnSpecificFormSubmittedCallback(OnSpecificFormSubmittedCallback onSpecificFormSubmittedCallback) {
        Const.sSpecificFormSubmittedListener = onSpecificFormSubmittedCallback;
    }

    void setOnAIHelpSessionOpenCallback(OnAIHelpSessionOpenCallback onAIHelpSessionOpenCallback) {
        Const.sSessionOpenListener = onAIHelpSessionOpenCallback;
    }

    void setOnAIHelpSessionCloseCallback(OnAIHelpSessionCloseCallback onAIHelpSessionCloseCallback) {
        Const.sSessionCloseListener = onAIHelpSessionCloseCallback;
    }

    void setOnAIHelpInitializedCallback(OnAIHelpInitializedCallback onAIHelpInitializedCallback) {
        Const.sInitializedListener = onAIHelpInitializedCallback;
    }

    void setOnSpecificUrlClickedCallback(OnSpecificUrlClickedCallback onSpecificUrlClickedCallback) {
        Const.sOnSpecificUrlClickedListener = onSpecificUrlClickedCallback;
    }

    void close() {
        ActivityManager.INSTANCE.finishAll();
    }

    void enableLogging(boolean z) {
        TLog.initLog(z);
    }

    private boolean isInitStillInProgress() {
        if (!AIHelpContext.successfullyInit.get()) {
            Log.e("AIHelp", "AIHelp is during initialization process at this time, the API you called is not available, please try again later.");
            return true;
        }
        if (AppInfoUtil.isNetworkAvailable(this.mAppContext)) {
            return false;
        }
        ToastUtil.INSTANCE.makeRawToast(this.mAppContext, ResResolver.getString("aihelp_network_no_connect"));
        return true;
    }

    private boolean isPresenterStillNull() {
        if (this.mInitPresenter != null) {
            return false;
        }
        Log.e("AIHelp", "Please ensure AIHelpSupport#init is called at the very first place before you call any other API.");
        return true;
    }

    public static AIHelpCore getInstance() {
        return Holder.INSTANCE;
    }

    private AIHelpCore() {
    }

    private static class Holder {
        private static final AIHelpCore INSTANCE = new AIHelpCore();

        private Holder() {
        }
    }
}
