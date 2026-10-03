package net.aihelp.core.util.logger;

import android.os.Build;
import android.os.Looper;
import android.text.TextUtils;
import android.util.Log;
import java.net.InetAddress;
import java.util.Arrays;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.ThreadFactory;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import net.aihelp.common.Const;
import net.aihelp.core.util.bus.EventBus;
import net.aihelp.core.util.concurrent.ApiExecutorFactory;
import net.aihelp.core.util.logger.controller.LoggerDBController;
import net.aihelp.data.event.FatalErrorEvent;
import net.aihelp.utils.DeviceInfoUtil;
import org.json.JSONArray;
import org.json.JSONObject;

public enum AIHelpLogger {
    INSTANCE;

    public static final int LEVEL_ERROR = 2;
    public static final int LEVEL_FATAL = 1;
    public static final int LEVEL_WARN = 3;
    private final String TAG = "AIHelpLogger";
    private final LoggerDBController logStorage = LoggerDBController.getInstance();
    private ThreadPoolExecutor threadPoolExecutor;

    AIHelpLogger() {
        if (this.threadPoolExecutor == null) {
            this.threadPoolExecutor = new ThreadPoolExecutor(1, 1, 60L, TimeUnit.SECONDS, new LinkedBlockingQueue(), new ThreadFactory() {
                @Override
                public Thread newThread(Runnable runnable) {
                    return new Thread(runnable, "AIHelpLogger");
                }
            });
        }
    }

    public void log(int i, String str, Throwable th) {
        String stackTraceString = getStackTraceString(th);
        if (TextUtils.isEmpty(stackTraceString)) {
            return;
        }
        logMessageToDatabase(i, str, stackTraceString, System.currentTimeMillis());
    }

    public JSONArray getCachedLogs() {
        return this.logStorage.getCrashLog();
    }

    public void deleteAllCachedLogs() {
        this.logStorage.reset();
    }

    private void logMessageToDatabase(final int i, final String str, final String str2, final long j) {
        try {
            this.threadPoolExecutor.submit(new Runnable() {
                @Override
                public void run() {
                    AIHelpLogger.this.logStorage.saveCrashInfoFile(i, str, str2, j);
                }
            });
        } catch (Exception e) {
            Log.e(this.TAG, "Rejected execution of log message : " + str, e);
        }
    }

    private static String getStackTraceString(Throwable th) {
        if (th == null) {
            return "";
        }
        return Log.getStackTraceString(th);
    }

    public static void fatal(String str, Throwable th) {
        INSTANCE.log(1, str, th);
        if (Thread.currentThread() == Looper.getMainLooper().getThread()) {
            EventBus.getDefault().post(new FatalErrorEvent());
        }
    }

    public static void error(final String str, final Throwable th) {
        if (TextUtils.isEmpty(str) || str.endsWith("from-api.json")) {
            return;
        }
        final Matcher matcher = Pattern.compile("(?<=//).*?(?=/)").matcher(str);
        if (matcher.find()) {
            ApiExecutorFactory.getHandlerExecutor().runAsync(new Runnable() {
                @Override
                public void run() {
                    JSONObject messageObject = AIHelpLogger.getMessageObject(str);
                    try {
                        InetAddress[] allByName = InetAddress.getAllByName(matcher.group());
                        if (allByName == null || allByName.length <= 0) {
                            return;
                        }
                        String[] strArr = new String[allByName.length];
                        for (int i = 0; i < allByName.length; i++) {
                            strArr[i] = allByName[i].getHostAddress();
                        }
                        messageObject.put("inetAddress", Arrays.toString(strArr));
                        AIHelpLogger.INSTANCE.log(2, messageObject.toString(), th);
                    } catch (Exception e) {
                        e.printStackTrace();
                        AIHelpLogger.INSTANCE.log(2, messageObject.toString(), th);
                    }
                }
            });
        } else {
            INSTANCE.log(2, getMessageObject(str).toString(), th);
        }
    }

    public static JSONObject getMessageObject(String str) {
        JSONObject jSONObject = new JSONObject();
        try {
            jSONObject.put("origin", str);
            jSONObject.put("language", Const.ORIGINAL_LANGUAGE);
            jSONObject.put("OSVersion", Build.VERSION.RELEASE);
            jSONObject.put("deviceModel", Build.MODEL);
            jSONObject.put("networkType", DeviceInfoUtil.getInstance().getNetworkType());
            jSONObject.put("carrier", DeviceInfoUtil.getInstance().getCarrierName());
            jSONObject.put("countryCode", DeviceInfoUtil.getInstance().getSimCountryIso());
            jSONObject.put("proxyConfig", DeviceInfoUtil.getInstance().getProxyConfiguration());
            return jSONObject;
        } catch (Exception e) {
            e.printStackTrace();
            return jSONObject;
        }
    }
}
