package com.appsflyer.internal;

import com.appsflyer.AFLogger;
import j$.util.concurrent.ConcurrentHashMap;
import java.io.InterruptedIOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.NavigableSet;
import java.util.Set;
import java.util.Timer;
import java.util.concurrent.ConcurrentSkipListSet;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.concurrent.CopyOnWriteArraySet;
import java.util.concurrent.Executor;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import kotlin.jvm.internal.Intrinsics;

public final class AFe1dSDK {
    final ExecutorService AFInAppEventParameterName;
    final Set<AFe1bSDK> AFInAppEventType;
    public final List<AFe1eSDK> AFKeystoreWrapper;
    final NavigableSet<AFe1fSDK<?>> AFLogger;

    final Set<AFe1fSDK<?>> f336d;

    final List<AFe1fSDK<?>> f337e;
    final NavigableSet<AFe1fSDK<?>> registerClient;
    final Set<AFe1bSDK> unregisterClient;
    final Timer valueOf;
    public Executor values;

    public AFe1dSDK(ExecutorService executorService) {
        ExecutorService executorServiceNewSingleThreadExecutor = Executors.newSingleThreadExecutor();
        Intrinsics.checkNotNullExpressionValue(executorServiceNewSingleThreadExecutor, "");
        this.values = executorServiceNewSingleThreadExecutor;
        this.valueOf = new Timer(true);
        this.AFKeystoreWrapper = new CopyOnWriteArrayList();
        this.AFInAppEventType = new CopyOnWriteArraySet();
        this.unregisterClient = Collections.newSetFromMap(new ConcurrentHashMap());
        this.AFLogger = new ConcurrentSkipListSet();
        this.registerClient = new ConcurrentSkipListSet();
        this.f337e = new ArrayList();
        this.f336d = Collections.newSetFromMap(new ConcurrentHashMap());
        this.AFInAppEventParameterName = executorService;
    }

    public class RunnableC08534 implements Runnable {
        private AFe1fSDK AFKeystoreWrapper;

        public RunnableC08534(AFe1fSDK aFe1fSDK) {
            this.AFKeystoreWrapper = aFe1fSDK;
        }

        @Override
        public final void run() {
            boolean zAdd;
            synchronized (AFe1dSDK.this.AFLogger) {
                if (AFe1dSDK.this.f336d.contains(this.AFKeystoreWrapper)) {
                    AFLogger aFLogger = AFLogger.INSTANCE;
                    AFg1hSDK aFg1hSDK = AFg1hSDK.QUEUE;
                    StringBuilder sb = new StringBuilder("tried to add already running task: ");
                    sb.append(this.AFKeystoreWrapper);
                    aFLogger.m797d(aFg1hSDK, sb.toString());
                    return;
                }
                if (!AFe1dSDK.this.AFLogger.contains(this.AFKeystoreWrapper) && !AFe1dSDK.this.registerClient.contains(this.AFKeystoreWrapper)) {
                    AFe1dSDK aFe1dSDK = AFe1dSDK.this;
                    AFe1fSDK aFe1fSDK = this.AFKeystoreWrapper;
                    for (AFe1bSDK aFe1bSDK : aFe1fSDK.AFInAppEventParameterName) {
                        if (aFe1dSDK.unregisterClient.contains(aFe1bSDK)) {
                            aFe1fSDK.valueOf.add(aFe1bSDK);
                        }
                    }
                    if (AFe1dSDK.this.AFInAppEventType(this.AFKeystoreWrapper)) {
                        zAdd = AFe1dSDK.this.AFLogger.add(this.AFKeystoreWrapper);
                    } else {
                        zAdd = AFe1dSDK.this.registerClient.add(this.AFKeystoreWrapper);
                        if (zAdd) {
                            AFLogger aFLogger2 = AFLogger.INSTANCE;
                            AFg1hSDK aFg1hSDK2 = AFg1hSDK.QUEUE;
                            StringBuilder sb2 = new StringBuilder("new task was blocked: ");
                            sb2.append(this.AFKeystoreWrapper);
                            aFLogger2.m797d(aFg1hSDK2, sb2.toString());
                            this.AFKeystoreWrapper.AFInAppEventParameterName();
                        }
                    }
                    if (zAdd) {
                        AFe1dSDK.this.AFLogger.addAll(AFe1dSDK.this.f337e);
                        AFe1dSDK.this.f337e.clear();
                    } else {
                        AFLogger aFLogger3 = AFLogger.INSTANCE;
                        AFg1hSDK aFg1hSDK3 = AFg1hSDK.QUEUE;
                        StringBuilder sb3 = new StringBuilder("task not added, it's already in the queue: ");
                        sb3.append(this.AFKeystoreWrapper);
                        aFLogger3.m797d(aFg1hSDK3, sb3.toString());
                    }
                    if (zAdd) {
                        AFe1dSDK.this.unregisterClient.add(this.AFKeystoreWrapper.AFInAppEventType);
                        AFLogger aFLogger4 = AFLogger.INSTANCE;
                        AFg1hSDK aFg1hSDK4 = AFg1hSDK.QUEUE;
                        StringBuilder sb4 = new StringBuilder("new task added: ");
                        sb4.append(this.AFKeystoreWrapper);
                        aFLogger4.m797d(aFg1hSDK4, sb4.toString());
                        for (AFe1eSDK aFe1eSDK : AFe1dSDK.this.AFKeystoreWrapper) {
                        }
                        AFe1dSDK aFe1dSDK2 = AFe1dSDK.this;
                        aFe1dSDK2.AFInAppEventParameterName.submit(aFe1dSDK2.new RunnableC08522());
                        AFe1dSDK aFe1dSDK3 = AFe1dSDK.this;
                        synchronized (aFe1dSDK3.AFLogger) {
                            for (int size = (aFe1dSDK3.AFLogger.size() + aFe1dSDK3.registerClient.size()) - 40; size > 0; size--) {
                                boolean zIsEmpty = aFe1dSDK3.registerClient.isEmpty();
                                boolean zIsEmpty2 = aFe1dSDK3.AFLogger.isEmpty();
                                if (zIsEmpty2 || zIsEmpty) {
                                    if (!zIsEmpty2) {
                                        aFe1dSDK3.AFInAppEventParameterName(aFe1dSDK3.AFLogger);
                                    } else if (!zIsEmpty) {
                                        aFe1dSDK3.AFInAppEventParameterName(aFe1dSDK3.registerClient);
                                    }
                                } else if (aFe1dSDK3.AFLogger.first().compareTo(aFe1dSDK3.registerClient.first()) > 0) {
                                    aFe1dSDK3.AFInAppEventParameterName(aFe1dSDK3.AFLogger);
                                } else {
                                    aFe1dSDK3.AFInAppEventParameterName(aFe1dSDK3.registerClient);
                                }
                            }
                        }
                        return;
                    }
                    AFLogger aFLogger5 = AFLogger.INSTANCE;
                    AFg1hSDK aFg1hSDK5 = AFg1hSDK.QUEUE;
                    StringBuilder sb5 = new StringBuilder("QUEUE: tried to add already pending task: ");
                    sb5.append(this.AFKeystoreWrapper);
                    aFLogger5.m804w(aFg1hSDK5, sb5.toString());
                    return;
                }
                AFLogger aFLogger6 = AFLogger.INSTANCE;
                AFg1hSDK aFg1hSDK6 = AFg1hSDK.QUEUE;
                StringBuilder sb6 = new StringBuilder("tried to add already scheduled task: ");
                sb6.append(this.AFKeystoreWrapper);
                aFLogger6.m797d(aFg1hSDK6, sb6.toString());
            }
        }
    }

    final class RunnableC08522 implements Runnable {
        RunnableC08522() {
        }

        @Override
        public final void run() {
            synchronized (AFe1dSDK.this.AFLogger) {
                final AFe1fSDK<?> aFe1fSDKPollFirst = AFe1dSDK.this.AFLogger.pollFirst();
                if (aFe1fSDKPollFirst == null) {
                    return;
                }
                AFe1dSDK.this.f336d.add(aFe1fSDKPollFirst);
                long jAFKeystoreWrapper = aFe1fSDKPollFirst.AFKeystoreWrapper();
                AFe1aSDK aFe1aSDK = new AFe1aSDK(Thread.currentThread());
                if (jAFKeystoreWrapper > 0) {
                    AFe1dSDK.this.valueOf.schedule(aFe1aSDK, jAFKeystoreWrapper);
                }
                final AFe1dSDK aFe1dSDK = AFe1dSDK.this;
                aFe1dSDK.values.execute(new Runnable() {
                    @Override
                    public final void run() {
                        Iterator<AFe1eSDK> it = AFe1dSDK.this.AFKeystoreWrapper.iterator();
                        while (it.hasNext()) {
                            it.next().values(aFe1fSDKPollFirst);
                        }
                    }
                });
                if (!AFe1dSDK.this.AFLogger.isEmpty()) {
                    AFe1dSDK aFe1dSDK2 = AFe1dSDK.this;
                    aFe1dSDK2.AFInAppEventParameterName.submit(aFe1dSDK2.new RunnableC08522());
                }
                try {
                    AFLogger.INSTANCE.m797d(AFg1hSDK.QUEUE, "starting task execution: ".concat(String.valueOf(aFe1fSDKPollFirst)));
                    final AFe1cSDK aFe1cSDKCall = aFe1fSDKPollFirst.call();
                    aFe1aSDK.cancel();
                    final AFe1dSDK aFe1dSDK3 = AFe1dSDK.this;
                    aFe1dSDK3.values.execute(new Runnable() {
                        @Override
                        public final void run() {
                            AFLogger aFLogger = AFLogger.INSTANCE;
                            AFg1hSDK aFg1hSDK = AFg1hSDK.QUEUE;
                            StringBuilder sb = new StringBuilder("execution finished for ");
                            sb.append(aFe1fSDKPollFirst);
                            sb.append(", result: ");
                            sb.append(aFe1cSDKCall);
                            aFLogger.m797d(aFg1hSDK, sb.toString());
                            AFe1dSDK.this.f336d.remove(aFe1fSDKPollFirst);
                            Iterator<AFe1eSDK> it = AFe1dSDK.this.AFKeystoreWrapper.iterator();
                            while (it.hasNext()) {
                                it.next().AFKeystoreWrapper(aFe1fSDKPollFirst, aFe1cSDKCall);
                            }
                            if (aFe1cSDKCall == AFe1cSDK.SUCCESS) {
                                AFe1dSDK.this.AFInAppEventType.add(aFe1fSDKPollFirst.AFInAppEventType);
                                AFe1dSDK.valueOf(AFe1dSDK.this);
                                return;
                            }
                            if (aFe1fSDKPollFirst.values()) {
                                if (AFe1dSDK.AFInAppEventParameterName((AFe1fSDK<?>) aFe1fSDKPollFirst)) {
                                    synchronized (AFe1dSDK.this.AFLogger) {
                                        AFe1dSDK.this.f337e.add(aFe1fSDKPollFirst);
                                        for (AFe1eSDK aFe1eSDK : AFe1dSDK.this.AFKeystoreWrapper) {
                                        }
                                    }
                                    return;
                                }
                                return;
                            }
                            AFe1dSDK.this.AFInAppEventType.add(aFe1fSDKPollFirst.AFInAppEventType);
                            AFe1dSDK.valueOf(AFe1dSDK.this);
                        }
                    });
                } catch (InterruptedIOException | InterruptedException unused) {
                    AFLogger.INSTANCE.m797d(AFg1hSDK.QUEUE, "task was interrupted: ".concat(String.valueOf(aFe1fSDKPollFirst)));
                    aFe1fSDKPollFirst.AFKeystoreWrapper = AFe1cSDK.TIMEOUT;
                    final AFe1dSDK aFe1dSDK4 = AFe1dSDK.this;
                    final AFe1cSDK aFe1cSDK = AFe1cSDK.TIMEOUT;
                    aFe1dSDK4.values.execute(new Runnable() {
                        @Override
                        public final void run() {
                            AFLogger aFLogger = AFLogger.INSTANCE;
                            AFg1hSDK aFg1hSDK = AFg1hSDK.QUEUE;
                            StringBuilder sb = new StringBuilder("execution finished for ");
                            sb.append(aFe1fSDKPollFirst);
                            sb.append(", result: ");
                            sb.append(aFe1cSDK);
                            aFLogger.m797d(aFg1hSDK, sb.toString());
                            AFe1dSDK.this.f336d.remove(aFe1fSDKPollFirst);
                            Iterator<AFe1eSDK> it = AFe1dSDK.this.AFKeystoreWrapper.iterator();
                            while (it.hasNext()) {
                                it.next().AFKeystoreWrapper(aFe1fSDKPollFirst, aFe1cSDK);
                            }
                            if (aFe1cSDK == AFe1cSDK.SUCCESS) {
                                AFe1dSDK.this.AFInAppEventType.add(aFe1fSDKPollFirst.AFInAppEventType);
                                AFe1dSDK.valueOf(AFe1dSDK.this);
                                return;
                            }
                            if (aFe1fSDKPollFirst.values()) {
                                if (AFe1dSDK.AFInAppEventParameterName((AFe1fSDK<?>) aFe1fSDKPollFirst)) {
                                    synchronized (AFe1dSDK.this.AFLogger) {
                                        AFe1dSDK.this.f337e.add(aFe1fSDKPollFirst);
                                        for (AFe1eSDK aFe1eSDK : AFe1dSDK.this.AFKeystoreWrapper) {
                                        }
                                    }
                                    return;
                                }
                                return;
                            }
                            AFe1dSDK.this.AFInAppEventType.add(aFe1fSDKPollFirst.AFInAppEventType);
                            AFe1dSDK.valueOf(AFe1dSDK.this);
                        }
                    });
                } catch (Throwable unused2) {
                    aFe1aSDK.cancel();
                    final AFe1dSDK aFe1dSDK5 = AFe1dSDK.this;
                    final AFe1cSDK aFe1cSDK2 = AFe1cSDK.FAILURE;
                    aFe1dSDK5.values.execute(new Runnable() {
                        @Override
                        public final void run() {
                            AFLogger aFLogger = AFLogger.INSTANCE;
                            AFg1hSDK aFg1hSDK = AFg1hSDK.QUEUE;
                            StringBuilder sb = new StringBuilder("execution finished for ");
                            sb.append(aFe1fSDKPollFirst);
                            sb.append(", result: ");
                            sb.append(aFe1cSDK2);
                            aFLogger.m797d(aFg1hSDK, sb.toString());
                            AFe1dSDK.this.f336d.remove(aFe1fSDKPollFirst);
                            Iterator<AFe1eSDK> it = AFe1dSDK.this.AFKeystoreWrapper.iterator();
                            while (it.hasNext()) {
                                it.next().AFKeystoreWrapper(aFe1fSDKPollFirst, aFe1cSDK2);
                            }
                            if (aFe1cSDK2 == AFe1cSDK.SUCCESS) {
                                AFe1dSDK.this.AFInAppEventType.add(aFe1fSDKPollFirst.AFInAppEventType);
                                AFe1dSDK.valueOf(AFe1dSDK.this);
                                return;
                            }
                            if (aFe1fSDKPollFirst.values()) {
                                if (AFe1dSDK.AFInAppEventParameterName((AFe1fSDK<?>) aFe1fSDKPollFirst)) {
                                    synchronized (AFe1dSDK.this.AFLogger) {
                                        AFe1dSDK.this.f337e.add(aFe1fSDKPollFirst);
                                        for (AFe1eSDK aFe1eSDK : AFe1dSDK.this.AFKeystoreWrapper) {
                                        }
                                    }
                                    return;
                                }
                                return;
                            }
                            AFe1dSDK.this.AFInAppEventType.add(aFe1fSDKPollFirst.AFInAppEventType);
                            AFe1dSDK.valueOf(AFe1dSDK.this);
                        }
                    });
                }
            }
        }
    }

    final void AFInAppEventParameterName(NavigableSet<AFe1fSDK<?>> navigableSet) {
        AFe1fSDK<?> aFe1fSDKPollFirst = navigableSet.pollFirst();
        this.AFInAppEventType.add(aFe1fSDKPollFirst.AFInAppEventType);
        Iterator<AFe1eSDK> it = this.AFKeystoreWrapper.iterator();
        while (it.hasNext()) {
            it.next().AFKeystoreWrapper(aFe1fSDKPollFirst);
        }
    }

    public boolean AFInAppEventType(AFe1fSDK<?> aFe1fSDK) {
        return this.AFInAppEventType.containsAll(aFe1fSDK.valueOf);
    }

    public static boolean AFInAppEventParameterName(AFe1fSDK<?> aFe1fSDK) {
        return ((aFe1fSDK instanceof AFf1qSDK) && aFe1fSDK.AFInAppEventType == AFe1bSDK.ARS_VALIDATE) ? false : true;
    }

    static void valueOf(AFe1dSDK aFe1dSDK) {
        synchronized (aFe1dSDK.AFLogger) {
            Iterator<AFe1fSDK<?>> it = aFe1dSDK.registerClient.iterator();
            boolean z = false;
            while (it.hasNext()) {
                AFe1fSDK<?> next = it.next();
                if (aFe1dSDK.AFInAppEventType(next)) {
                    it.remove();
                    aFe1dSDK.AFLogger.add(next);
                    z = true;
                }
            }
            if (z) {
                aFe1dSDK.AFInAppEventParameterName.submit(aFe1dSDK.new RunnableC08522());
            }
        }
    }
}
