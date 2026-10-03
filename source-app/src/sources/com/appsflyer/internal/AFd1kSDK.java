package com.appsflyer.internal;

import android.content.Context;
import com.appsflyer.AFLogger;
import com.appsflyer.AppsFlyerProperties;
import com.appsflyer.PurchaseHandler;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.RejectedExecutionHandler;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.SynchronousQueue;
import java.util.concurrent.ThreadFactory;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;
import kotlin.jvm.internal.Intrinsics;

public final class AFd1kSDK implements AFd1nSDK {
    private static final int valueOf = (int) TimeUnit.SECONDS.toMillis(30);
    public final AFd1lSDK AFInAppEventParameterName = new AFd1lSDK();
    private ExecutorService AFInAppEventType;
    private ScheduledExecutorService AFKeystoreWrapper;
    private AFe1vSDK AFLogger;
    private AFc1jSDK AFLogger$LogLevel;
    private AFd1vSDK AFVersionDeclaration;
    private AFh1aSDK AppsFlyer2dXConversionCallback;
    private AFb1rSDK afDebugLog;
    private AFg1zSDK afErrorLog;
    private AFd1ySDK afErrorLogForExcManagerOnly;
    private AFi1fSDK afInfoLog;
    private AFc1eSDK afLogForce;
    private AFd1fSDK afRDLog;
    private AFi1xSDK afVerboseLog;
    private AFe1jSDK afWarnLog;

    private AFg1bSDK f321d;

    private AFd1rSDK f322e;
    private AFi1kSDK force;
    private AFh1gSDK getLevel;

    private AFb1cSDK f323i;
    private AFb1zSDK init;
    private AFg1xSDK onAppOpenAttributionNative;
    private AFd1sSDK onConversionDataSuccess;
    private AFg1sSDK onDeepLinkingNative;
    private AFg1gSDK onInstallConversionDataLoadedNative;
    private AFc1kSDK onInstallConversionFailureNative;
    private PurchaseHandler registerClient;
    private AFf1eSDK unregisterClient;

    private AFe1dSDK f324v;
    private ExecutorService values;

    private AFg1qSDK f325w;

    @Override
    public final AFe1zSDK AFInAppEventParameterName() {
        return new AFe1zSDK(onAppOpenAttributionNative(), AFInAppEventType(), AppsFlyerProperties.getInstance(), afVerboseLog());
    }

    private synchronized AFe1vSDK onAppOpenAttributionNative() {
        if (this.AFLogger == null) {
            this.AFLogger = new AFe1vSDK(new AFe1sSDK(valueOf), values());
        }
        return this.AFLogger;
    }

    @Override
    public final synchronized ExecutorService values() {
        if (this.values == null) {
            this.values = new ThreadPoolExecutor(0, Integer.MAX_VALUE, 60L, TimeUnit.SECONDS, new SynchronousQueue());
        }
        return this.values;
    }

    private synchronized ExecutorService onInstallConversionFailureNative() {
        if (this.AFInAppEventType == null) {
            ExecutorService executorServiceNewSingleThreadExecutor = Executors.newSingleThreadExecutor();
            Intrinsics.checkNotNullExpressionValue(executorServiceNewSingleThreadExecutor, "");
            this.AFInAppEventType = executorServiceNewSingleThreadExecutor;
        }
        return this.AFInAppEventType;
    }

    @Override
    public final synchronized ScheduledExecutorService valueOf() {
        if (this.AFKeystoreWrapper == null) {
            ScheduledExecutorService scheduledExecutorServiceNewScheduledThreadPool = Executors.newScheduledThreadPool(2);
            Intrinsics.checkNotNullExpressionValue(scheduledExecutorServiceNewScheduledThreadPool, "");
            this.AFKeystoreWrapper = scheduledExecutorServiceNewScheduledThreadPool;
        }
        return this.AFKeystoreWrapper;
    }

    @Override
    public final synchronized AFd1rSDK AFInAppEventType() {
        if (this.f322e == null) {
            AFd1lSDK aFd1lSDKMo786v = mo786v();
            Context context = this.AFInAppEventParameterName.AFInAppEventParameterName;
            if (context != null) {
                this.f322e = new AFd1rSDK(aFd1lSDKMo786v, new AFd1pSDK(AFb1vSDK.AFInAppEventParameterName(context)));
            } else {
                throw new IllegalStateException("Context must be set via setContext method before calling this dependency.");
            }
        }
        return this.f322e;
    }

    @Override
    public final AFd1xSDK AFKeystoreWrapper() {
        Context context = this.AFInAppEventParameterName.AFInAppEventParameterName;
        if (context != null) {
            return new AFd1pSDK(AFb1vSDK.AFInAppEventParameterName(context));
        }
        throw new IllegalStateException("Context must be set via setContext method before calling this dependency.");
    }

    @Override
    public final synchronized PurchaseHandler registerClient() {
        if (this.registerClient == null) {
            this.registerClient = new PurchaseHandler(this);
        }
        return this.registerClient;
    }

    @Override
    public final synchronized AFf1eSDK mo784e() {
        if (this.unregisterClient == null) {
            AFf1gSDK aFf1gSDK = new AFf1gSDK(AFKeystoreWrapper());
            this.unregisterClient = new AFf1eSDK(new AFf1cSDK(), AFInAppEventType(), mo785i(), aFf1gSDK, new AFe1zSDK(onAppOpenAttributionNative(), AFInAppEventType(), AppsFlyerProperties.getInstance(), afVerboseLog()), new AFf1dSDK(AFInAppEventType(), aFf1gSDK), mo787w());
        }
        return this.unregisterClient;
    }

    private synchronized AFg1sSDK onResponseNative() {
        if (this.onDeepLinkingNative == null) {
            this.onDeepLinkingNative = new AFg1sSDK(mo786v(), AFInAppEventType());
        }
        return this.onDeepLinkingNative;
    }

    @Override
    public final synchronized AFg1bSDK unregisterClient() {
        if (this.f321d == null) {
            this.f321d = new AFg1bSDK(AFKeystoreWrapper());
        }
        return this.f321d;
    }

    @Override
    public final AFg1qSDK mo783d() {
        if (this.f325w == null) {
            Context context = this.AFInAppEventParameterName.AFInAppEventParameterName;
            if (context == null) {
                throw new IllegalStateException("Context must be set via setContext method before calling this dependency.");
            }
            if (this.afVerboseLog == null) {
                this.afVerboseLog = new AFi1vSDK();
            }
            AFi1xSDK aFi1xSDK = this.afVerboseLog;
            if (this.AFVersionDeclaration == null) {
                this.AFVersionDeclaration = new AFa1tSDK();
            }
            AFd1vSDK aFd1vSDK = this.AFVersionDeclaration;
            if (this.afInfoLog == null) {
                Context context2 = this.AFInAppEventParameterName.AFInAppEventParameterName;
                if (context2 != null) {
                    this.afInfoLog = new AFi1hSDK(context2, onInstallConversionFailureNative());
                } else {
                    throw new IllegalStateException("Context must be set via setContext method before calling this dependency.");
                }
            }
            AFi1fSDK aFi1fSDK = this.afInfoLog;
            if (this.init == null) {
                this.init = new AFa1bSDK();
            }
            AFb1zSDK aFb1zSDK = this.init;
            AFg1bSDK aFg1bSDKUnregisterClient = unregisterClient();
            AFd1xSDK aFd1xSDKAFKeystoreWrapper = AFKeystoreWrapper();
            AFd1rSDK aFd1rSDKAFInAppEventType = AFInAppEventType();
            if (this.getLevel == null) {
                Context context3 = this.AFInAppEventParameterName.AFInAppEventParameterName;
                if (context3 != null) {
                    this.getLevel = new AFh1gSDK(context3);
                } else {
                    throw new IllegalStateException("Context must be set via setContext method before calling this dependency.");
                }
            }
            AFh1gSDK aFh1gSDK = this.getLevel;
            AFg1zSDK aFg1zSDKMo785i = mo785i();
            AFb1gSDK aFb1gSDK = new AFb1gSDK();
            AFd1lSDK aFd1lSDKMo786v = mo786v();
            AFg1sSDK aFg1sSDKOnResponseNative = onResponseNative();
            if (this.onConversionDataSuccess == null) {
                this.onConversionDataSuccess = new AFd1sSDK();
            }
            this.f325w = new AFg1nSDK(context, aFi1xSDK, aFd1vSDK, aFi1fSDK, aFb1zSDK, aFg1bSDKUnregisterClient, aFd1xSDKAFKeystoreWrapper, aFd1rSDKAFInAppEventType, aFh1gSDK, aFg1zSDKMo785i, aFb1gSDK, aFd1lSDKMo786v, aFg1sSDKOnResponseNative, this.onConversionDataSuccess);
        }
        return this.f325w;
    }

    @Override
    public final AFi1fSDK AFLogger() {
        if (this.afInfoLog == null) {
            Context context = this.AFInAppEventParameterName.AFInAppEventParameterName;
            if (context != null) {
                this.afInfoLog = new AFi1hSDK(context, onInstallConversionFailureNative());
            } else {
                throw new IllegalStateException("Context must be set via setContext method before calling this dependency.");
            }
        }
        return this.afInfoLog;
    }

    @Override
    public final synchronized AFe1dSDK mo787w() {
        if (this.f324v == null) {
            ThreadPoolExecutor threadPoolExecutor = new ThreadPoolExecutor(2, 6, 300L, TimeUnit.SECONDS, new LinkedBlockingQueue<Runnable>() {
                @Override
                public boolean offer(Runnable runnable) {
                    if (isEmpty()) {
                        return super.offer(runnable);
                    }
                    return false;
                }
            }, new AFa1zSDK());
            threadPoolExecutor.setRejectedExecutionHandler(new RejectedExecutionHandler() {
                @Override
                public final void rejectedExecution(Runnable runnable, ThreadPoolExecutor threadPoolExecutor2) {
                    AFd1kSDK.valueOf(runnable, threadPoolExecutor2);
                }
            });
            this.f324v = new AFe1dSDK(threadPoolExecutor);
        }
        return this.f324v;
    }

    @Override
    public final synchronized AFb1cSDK afInfoLog() {
        if (this.f323i == null) {
            this.f323i = new AFb1hSDK(this);
        }
        return this.f323i;
    }

    @Override
    public final synchronized AFi1kSDK force() {
        if (this.force == null) {
            this.force = new AFi1kSDK(this);
        }
        return this.force;
    }

    @Override
    public final synchronized AFg1zSDK mo785i() {
        if (this.afErrorLog == null) {
            this.afErrorLog = new AFg1zSDK(mo786v(), new AFf1bSDK());
        }
        return this.afErrorLog;
    }

    @Override
    public final synchronized AFd1lSDK mo786v() {
        return this.AFInAppEventParameterName;
    }

    @Override
    public final synchronized AFb1rSDK afRDLog() {
        if (this.afDebugLog == null) {
            this.afDebugLog = new AFb1iSDK(mo786v());
        }
        return this.afDebugLog;
    }

    @Override
    public synchronized AFd1fSDK init() {
        if (this.afRDLog == null) {
            this.afRDLog = new AFd1fSDK(this);
        }
        return this.afRDLog;
    }

    @Override
    public final synchronized AFe1jSDK afVerboseLog() {
        if (this.afWarnLog == null) {
            this.afWarnLog = new AFe1jSDK(AFInAppEventType(), AFKeystoreWrapper());
        }
        return this.afWarnLog;
    }

    @Override
    public final AFi1xSDK afWarnLog() {
        if (this.afVerboseLog == null) {
            this.afVerboseLog = new AFi1vSDK();
        }
        return this.afVerboseLog;
    }

    @Override
    public final synchronized AFc1jSDK afErrorLog() {
        if (this.AFLogger$LogLevel == null) {
            this.AFLogger$LogLevel = new AFc1jSDK(this);
        }
        return this.AFLogger$LogLevel;
    }

    @Override
    public final synchronized AFc1eSDK afDebugLog() {
        if (this.afLogForce == null) {
            this.afLogForce = new AFc1gSDK(mo786v());
        }
        return this.afLogForce;
    }

    @Override
    public final AFh1gSDK AFLogger$LogLevel() {
        if (this.getLevel == null) {
            Context context = this.AFInAppEventParameterName.AFInAppEventParameterName;
            if (context != null) {
                this.getLevel = new AFh1gSDK(context);
            } else {
                throw new IllegalStateException("Context must be set via setContext method before calling this dependency.");
            }
        }
        return this.getLevel;
    }

    @Override
    public final AFh1aSDK afErrorLogForExcManagerOnly() {
        if (this.AppsFlyer2dXConversionCallback == null) {
            this.AppsFlyer2dXConversionCallback = new AFi1uSDK();
        }
        return this.AppsFlyer2dXConversionCallback;
    }

    @Override
    public final AFd1sSDK getLevel() {
        if (this.onConversionDataSuccess == null) {
            this.onConversionDataSuccess = new AFd1sSDK();
        }
        return this.onConversionDataSuccess;
    }

    @Override
    public final AFd1ySDK afLogForce() {
        if (this.afErrorLogForExcManagerOnly == null) {
            ExecutorService executorServiceOnInstallConversionFailureNative = onInstallConversionFailureNative();
            ScheduledExecutorService scheduledExecutorServiceValueOf = valueOf();
            AFc1jSDK aFc1jSDKAfErrorLog = afErrorLog();
            if (this.AppsFlyer2dXConversionCallback == null) {
                this.AppsFlyer2dXConversionCallback = new AFi1uSDK();
            }
            this.afErrorLogForExcManagerOnly = new AFd1uSDK(executorServiceOnInstallConversionFailureNative, scheduledExecutorServiceValueOf, aFc1jSDKAfErrorLog, this.AppsFlyer2dXConversionCallback);
        }
        return this.afErrorLogForExcManagerOnly;
    }

    @Override
    public final AFg1gSDK AFVersionDeclaration() {
        if (this.onInstallConversionDataLoadedNative == null) {
            this.onInstallConversionDataLoadedNative = new AFg1eSDK(this);
        }
        return this.onInstallConversionDataLoadedNative;
    }

    @Override
    public final AFg1xSDK onInstallConversionDataLoadedNative() {
        if (this.onAppOpenAttributionNative == null) {
            Context context = this.AFInAppEventParameterName.AFInAppEventParameterName;
            if (context != null) {
                AFg1wSDK aFg1wSDK = new AFg1wSDK(context, AppsFlyerProperties.getInstance());
                if (this.onConversionDataSuccess == null) {
                    this.onConversionDataSuccess = new AFd1sSDK();
                }
                this.onAppOpenAttributionNative = new AFg1ySDK(aFg1wSDK, this.onConversionDataSuccess, AppsFlyerProperties.getInstance());
            } else {
                throw new IllegalStateException("Context must be set via setContext method before calling this dependency.");
            }
        }
        return this.onAppOpenAttributionNative;
    }

    @Override
    public final AFc1kSDK AppsFlyer2dXConversionCallback() {
        if (this.onInstallConversionFailureNative == null) {
            this.onInstallConversionFailureNative = new AFc1pSDK(AFKeystoreWrapper());
        }
        return this.onInstallConversionFailureNative;
    }

    public static void valueOf(Runnable runnable, ThreadPoolExecutor threadPoolExecutor) {
        try {
            threadPoolExecutor.getQueue().put(runnable);
        } catch (InterruptedException e) {
            AFLogger.afErrorLogForExcManagerOnly("could not create executor for queue", e);
            Thread.currentThread().interrupt();
        }
    }

    static class AFa1zSDK implements ThreadFactory {
        private static final AtomicInteger valueOf = new AtomicInteger();
        private final AtomicInteger AFKeystoreWrapper = new AtomicInteger();

        public AFa1zSDK() {
            valueOf.incrementAndGet();
        }

        @Override
        public final Thread newThread(Runnable runnable) {
            int i = valueOf.get();
            int iIncrementAndGet = this.AFKeystoreWrapper.incrementAndGet();
            StringBuilder sb = new StringBuilder("queue-");
            sb.append(i);
            sb.append("-");
            sb.append(iIncrementAndGet);
            return new Thread(runnable, sb.toString());
        }
    }
}
