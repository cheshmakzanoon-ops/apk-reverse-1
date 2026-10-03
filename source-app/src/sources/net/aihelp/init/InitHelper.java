package net.aihelp.init;

import android.content.Context;
import android.text.TextUtils;
import android.util.Log;
import cz.msebera.android.httpclient.cookie.ClientCookie;
import net.aihelp.common.API;
import net.aihelp.common.Const;
import net.aihelp.common.SpKeys;
import net.aihelp.config.AIHelpContext;
import net.aihelp.core.net.http.AIHelpRequest;
import net.aihelp.core.net.http.callback.ReqCallback;
import net.aihelp.core.net.json.JsonHelper;
import net.aihelp.core.util.concurrent.ApiExecutorFactory;
import net.aihelp.data.localize.LocalizeHelper;
import net.aihelp.data.logic.RequestRetryHandler;
import net.aihelp.data.model.init.InitEntity;
import net.aihelp.data.track.ResourceLoadTracker;
import net.aihelp.p007ui.helper.MessageSyncHelper;
import net.aihelp.utils.AppInfoUtil;
import net.aihelp.utils.DateFormatUtil;
import net.aihelp.utils.DeviceUuidFactory;
import net.aihelp.utils.SpUtil;
import org.json.JSONObject;

public class InitHelper implements RequestRetryHandler.OnRetryRequestListener {
    public static final int ERROR_INVALID_APP_ID = 4100;
    private static InitHelper sInstance;
    private final RequestRetryHandler mRetryHandler = new RequestRetryHandler(this, 5);
    private boolean requireCallback;

    private InitHelper() {
    }

    public static InitHelper getInstance() {
        if (sInstance == null) {
            sInstance = new InitHelper();
        }
        return sInstance;
    }

    public void runInitRelatedTask(final Context context) {
        ApiExecutorFactory.getHandlerExecutor().runAsync(new Runnable() {
            @Override
            public void run() {
                InitHelper.this.goLogDauStatus(context);
                InitHelper.this.requestInit(true);
                MessageSyncHelper.syncLogMessage();
            }
        });
    }

    public void onAIHelpInitializedCallback(final boolean z, final String str) {
        ApiExecutorFactory.getHandlerExecutor().runOnUiThreadDelayed(new Runnable() {
            @Override
            public void run() {
                AIHelpContext.successfullyInit.set(z);
                if (!InitHelper.this.requireCallback || Const.sInitializedListener == null) {
                    return;
                }
                Const.sInitializedListener.onAIHelpInitialized(z, str);
                Const.sInitializedListener = null;
            }
        }, 200L);
    }

    public void goLogDauStatus(Context context) {
        if (DateFormatUtil.isToday(SpUtil.getInstance().getLong(SpKeys.LOG_DAU_TIME))) {
            return;
        }
        try {
            JSONObject jSONObject = new JSONObject();
            jSONObject.put("deviceid", DeviceUuidFactory.m137id(context));
            AIHelpRequest.getInstance().requestPostByJson(API.LOG_DAU_URL, jSONObject, new ReqCallback<String>() {
                @Override
                public void onReqSuccess(String str) {
                    SpUtil.getInstance().put(SpKeys.LOG_DAU_TIME, Long.valueOf(System.currentTimeMillis()));
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void requestInit(boolean z) {
        this.requireCallback = z;
        String str = String.format("%s_%s_", Const.APP_ID, Const.ORIGINAL_LANGUAGE);
        final long j = SpUtil.getInstance().getLong(str + SpKeys.LAST_INIT_TIME, System.currentTimeMillis());
        int i = SpUtil.getInstance().getInt(str + SpKeys.INIT_REQUEST_LIMIT);
        final String string = SpUtil.getInstance().getString(str + SpKeys.CACHE_INIT_RESPONSE);
        LocalizeHelper.resetLocalizeData();
        if (TextUtils.isEmpty(string) || i < 0 || System.currentTimeMillis() - j > i) {
            ResourceLoadTracker.getInstance().markInitStarted();
            try {
                JSONObject jSONObject = new JSONObject();
                jSONObject.put(ClientCookie.DOMAIN_ATTR, API.HOST_URL);
                AIHelpRequest.getInstance().requestGetByAsync(API.INIT_URL, jSONObject, new ReqCallback<String>() {
                    @Override
                    public void onAsyncReqSuccess(String str2) {
                        if (InitHelper.this.mRetryHandler != null) {
                            InitHelper.this.mRetryHandler.removeCallbacksAndMessages(null);
                        }
                        InitHelper.this.cacheInitResponse(str2, System.currentTimeMillis());
                    }

                    @Override
                    public void onAsyncFailure(String str2, int i2, String str3) {
                        if (i2 == 4100) {
                            InitHelper.this.onAIHelpInitializedCallback(false, "Invalid init parameters");
                            return;
                        }
                        ResourceLoadTracker.getInstance().markInitEnded(false);
                        if (TextUtils.isEmpty(string)) {
                            if (InitHelper.this.mRetryHandler != null) {
                                InitHelper.this.mRetryHandler.handleRetryRequest(i2, str3);
                                return;
                            }
                            return;
                        }
                        InitHelper.this.cacheInitResponse(string, j);
                    }
                });
                return;
            } catch (Exception e) {
                e.printStackTrace();
                return;
            }
        }
        cacheInitResponse(string, j);
    }

    public void cacheInitResponse(String str, long j) {
        InitEntity initEntity = (InitEntity) JsonHelper.toJavaObject(str, InitEntity.class);
        if (initEntity != null) {
            int requestLimit = initEntity.getRequestLimit();
            String str2 = String.format("%s_%s_", Const.APP_ID, Const.ORIGINAL_LANGUAGE);
            SpUtil spUtil = SpUtil.getInstance();
            String str3 = str2 + SpKeys.INIT_REQUEST_LIMIT;
            if (requestLimit >= 0) {
                requestLimit *= 60000;
            }
            spUtil.put(str3, Integer.valueOf(requestLimit));
            SpUtil.getInstance().put(str2 + SpKeys.CACHE_INIT_RESPONSE, str);
            SpUtil.getInstance().put(str2 + SpKeys.LAST_INIT_TIME, Long.valueOf(j));
            API.CDN_URL = initEntity.getCdnUrl();
            API.FAQ_URL = initEntity.getFaqdata();
            API.OP_URL = initEntity.getFaqYYdata();
            API.UPLOAD_IMAGE_URL = initEntity.getUpload();
            API.UPLOAD_VIDEO_URL = initEntity.getUploadVideo();
            API.UPLOAD_LOG_URL = initEntity.getUploadLog();
            API.UPLOAD_ATTACHMENT_URL = initEntity.getUploadFile();
            API.M_FAQ_URL = initEntity.getShowfaq();
            API.LOG_COUNT_URL = initEntity.getPoint();
            API.LOCALE_FILE_URL = initEntity.getLocaleFile();
            API.CONFIG_STYLE_SHEET_URL = initEntity.getConfigStyle();
            API.CONFIG_BUSINESS_LOGIC_URL = initEntity.getConfigBusiness();
            API.CONFIG_OPINION_URL = initEntity.getSatisfyFeedback();
            API.CONFIG_FAQ_HOT_TOPIC_URL = initEntity.getConfigFaq();
            API.CONFIG_PROCESS_URL = initEntity.getConfigProcess();
            API.CONFIG_TEXT_URL = initEntity.getConfigText();
            API.CONFIG_UPLOAD_LIMIT_URL = initEntity.getSdkCustomUpload();
            API.MQTT_IP = initEntity.getSvrip();
            API.MQTT_PORT = initEntity.getSvrport();
            API.MQTT_TOPIC = initEntity.getTopic();
            if (!TextUtils.isEmpty(initEntity.getPushServer())) {
                String[] strArrSplit = initEntity.getPushServer().split(":");
                if (strArrSplit.length == 2) {
                    API.MQTT_FAQ_IP = strArrSplit[0];
                    API.MQTT_FAQ_PORT = strArrSplit[1];
                }
            }
            Const.TOGGLE_UPLOAD_VIDEO = initEntity.isOpenVideoUpload();
            Const.TOGGLE_CRM_TOKEN = initEntity.isSetCrmToken();
            Const.TOGGLE_OPEN_FAQ_NOTIFICATION = initEntity.isOpenPushServer();
            Const.TOGGLE_OPEN_UNREAD_MSG = initEntity.isUnreadMessage();
            Const.TOGGLE_UPLOAD_LOG = initEntity.isOpenUploadLogFile();
            Const.TOGGLE_LOCALIZE_VIA_INIT = initEntity.isLocalizeFAQViaInit();
            Const.TOGGLE_MQTT_TLS = initEntity.isTls();
            Const.TOGGLE_TRANSLATE_CS_MESSAGE = initEntity.isTranslates();
            Const.TOGGLE_DISTINGUISH_USER_BY_DEVICE = initEntity.isDistinguishUserByDevice();
            Const.FAQ_FILE = initEntity.getFaqFileName();
            Const.STORY_FILE = initEntity.getStoryAimlFileName();
            Const.OP_FILE = initEntity.getOperateFileName();
            Const.LIMIT_CHECKING_UNREAD = initEntity.getUnreadMessageTime();
            Const.APP_SHOW_NAME = AppInfoUtil.getAppName(AIHelpContext.getInstance().getContext());
            if (!TextUtils.isEmpty(initEntity.getCorrectLanguage())) {
                Const.CORRECT_LANGUAGE = initEntity.getCorrectLanguage();
            }
            if (initEntity.getNetworkCheckSetting() != null) {
                Const.TOGGLE_NET_CHECK = true;
                Const.NET_TRACE_ROUTE = initEntity.getNetworkCheckSetting().getTraceroute();
                Const.NET_PING = initEntity.getNetworkCheckSetting().getPing();
            }
            ResourceLoadTracker.getInstance().markInitEnded(true);
            LocalizeHelper.goFetchLocalizeData();
            if (this.requireCallback) {
                Log.e("AIHelp", "AIHelp is now ready to help you have conversations with your users!");
            }
        }
    }

    @Override
    public void onRetryRequest() {
        requestInit(true);
    }

    @Override
    public void onRetryUpToMaxCount(int i, String str) {
        onAIHelpInitializedCallback(false, str);
    }
}
