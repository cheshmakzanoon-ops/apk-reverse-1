package com.google.android.datatransport.runtime.scheduling.jobscheduling;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import com.google.android.datatransport.Encoding;
import com.google.android.datatransport.runtime.EncodedPayload;
import com.google.android.datatransport.runtime.EventInternal;
import com.google.android.datatransport.runtime.TransportContext;
import com.google.android.datatransport.runtime.backends.BackendRegistry;
import com.google.android.datatransport.runtime.backends.BackendRequest;
import com.google.android.datatransport.runtime.backends.BackendResponse;
import com.google.android.datatransport.runtime.backends.TransportBackend;
import com.google.android.datatransport.runtime.firebase.transport.ClientMetrics;
import com.google.android.datatransport.runtime.firebase.transport.LogEventDropped;
import com.google.android.datatransport.runtime.logging.Logging;
import com.google.android.datatransport.runtime.scheduling.persistence.ClientHealthMetricsStore;
import com.google.android.datatransport.runtime.scheduling.persistence.EventStore;
import com.google.android.datatransport.runtime.scheduling.persistence.PersistedEvent;
import com.google.android.datatransport.runtime.synchronization.SynchronizationException;
import com.google.android.datatransport.runtime.synchronization.SynchronizationGuard;
import com.google.android.datatransport.runtime.time.Clock;
import j$.util.Objects;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.concurrent.Executor;
import javax.inject.Inject;

public class Uploader {
    private static final String CLIENT_HEALTH_METRICS_LOG_SOURCE = "GDT_CLIENT_METRICS";
    private static final String LOG_TAG = "Uploader";
    private final BackendRegistry backendRegistry;
    private final ClientHealthMetricsStore clientHealthMetricsStore;
    private final Clock clock;
    private final Context context;
    private final EventStore eventStore;
    private final Executor executor;
    private final SynchronizationGuard guard;
    private final Clock uptimeClock;
    private final WorkScheduler workScheduler;

    @Inject
    public Uploader(Context context, BackendRegistry backendRegistry, EventStore eventStore, WorkScheduler workScheduler, Executor executor, SynchronizationGuard synchronizationGuard, Clock clock, Clock clock2, ClientHealthMetricsStore clientHealthMetricsStore) {
        this.context = context;
        this.backendRegistry = backendRegistry;
        this.eventStore = eventStore;
        this.workScheduler = workScheduler;
        this.executor = executor;
        this.guard = synchronizationGuard;
        this.clock = clock;
        this.uptimeClock = clock2;
        this.clientHealthMetricsStore = clientHealthMetricsStore;
    }

    boolean isNetworkAvailable() {
        NetworkInfo activeNetworkInfo = ((ConnectivityManager) this.context.getSystemService("connectivity")).getActiveNetworkInfo();
        return activeNetworkInfo != null && activeNetworkInfo.isConnected();
    }

    public void upload(final TransportContext transportContext, final int i, final Runnable runnable) {
        this.executor.execute(new Runnable() {
            @Override
            public final void run() {
                this.f$0.m1080x80c37673(transportContext, i, runnable);
            }
        });
    }

    void m1080x80c37673(final TransportContext transportContext, final int i, Runnable runnable) {
        try {
            try {
                SynchronizationGuard synchronizationGuard = this.guard;
                final EventStore eventStore = this.eventStore;
                Objects.requireNonNull(eventStore);
                synchronizationGuard.runCriticalSection(new SynchronizationGuard.CriticalSection() {
                    @Override
                    public final Object execute() {
                        return Integer.valueOf(eventStore.cleanUp());
                    }
                });
                if (!isNetworkAvailable()) {
                    this.guard.runCriticalSection(new SynchronizationGuard.CriticalSection() {
                        @Override
                        public final Object execute() {
                            return this.f$0.m1079x3eac4914(transportContext, i);
                        }
                    });
                } else {
                    logAndUpdateState(transportContext, i);
                }
            } catch (SynchronizationException unused) {
                this.workScheduler.schedule(transportContext, i + 1);
            }
        } finally {
            runnable.run();
        }
    }

    Object m1079x3eac4914(TransportContext transportContext, int i) {
        this.workScheduler.schedule(transportContext, i + 1);
        return null;
    }

    public BackendResponse logAndUpdateState(final TransportContext transportContext, int i) {
        BackendResponse backendResponseSend;
        TransportBackend transportBackend = this.backendRegistry.get(transportContext.getBackendName());
        long jMax = 0;
        BackendResponse backendResponseM1061ok = BackendResponse.m1061ok(0L);
        while (true) {
            final long j = jMax;
            while (true) {
                if (((Boolean) this.guard.runCriticalSection(new SynchronizationGuard.CriticalSection() {
                    @Override
                    public final Object execute() {
                        return this.f$0.m1072x65f78bd8(transportContext);
                    }
                })).booleanValue()) {
                    final Iterable iterable = (Iterable) this.guard.runCriticalSection(new SynchronizationGuard.CriticalSection() {
                        @Override
                        public final Object execute() {
                            return this.f$0.m1073xa80eb937(transportContext);
                        }
                    });
                    if (!iterable.iterator().hasNext()) {
                        return backendResponseM1061ok;
                    }
                    if (transportBackend == null) {
                        Logging.m1063d(LOG_TAG, "Unknown backend for %s, deleting event batch for it...", transportContext);
                        backendResponseSend = BackendResponse.fatalError();
                    } else {
                        ArrayList arrayList = new ArrayList();
                        Iterator it = iterable.iterator();
                        while (it.hasNext()) {
                            arrayList.add(((PersistedEvent) it.next()).getEvent());
                        }
                        if (transportContext.shouldUploadClientHealthMetrics()) {
                            arrayList.add(createMetricsEvent(transportBackend));
                        }
                        backendResponseSend = transportBackend.send(BackendRequest.builder().setEvents(arrayList).setExtras(transportContext.getExtras()).build());
                    }
                    backendResponseM1061ok = backendResponseSend;
                    if (backendResponseM1061ok.getStatus() == BackendResponse.Status.TRANSIENT_ERROR) {
                        this.guard.runCriticalSection(new SynchronizationGuard.CriticalSection() {
                            @Override
                            public final Object execute() {
                                return this.f$0.m1074xea25e696(iterable, transportContext, j);
                            }
                        });
                        this.workScheduler.schedule(transportContext, i + 1, true);
                        return backendResponseM1061ok;
                    }
                    this.guard.runCriticalSection(new SynchronizationGuard.CriticalSection() {
                        @Override
                        public final Object execute() {
                            return this.f$0.m1075x2c3d13f5(iterable);
                        }
                    });
                    if (backendResponseM1061ok.getStatus() == BackendResponse.Status.OK) {
                        break;
                    }
                    if (backendResponseM1061ok.getStatus() == BackendResponse.Status.INVALID_PAYLOAD) {
                        final HashMap map = new HashMap();
                        Iterator it2 = iterable.iterator();
                        while (it2.hasNext()) {
                            String transportName = ((PersistedEvent) it2.next()).getEvent().getTransportName();
                            if (!map.containsKey(transportName)) {
                                map.put(transportName, 1);
                            } else {
                                map.put(transportName, Integer.valueOf(((Integer) map.get(transportName)).intValue() + 1));
                            }
                        }
                        this.guard.runCriticalSection(new SynchronizationGuard.CriticalSection() {
                            @Override
                            public final Object execute() {
                                return this.f$0.m1077xb06b6eb3(map);
                            }
                        });
                    }
                } else {
                    this.guard.runCriticalSection(new SynchronizationGuard.CriticalSection() {
                        @Override
                        public final Object execute() {
                            return this.f$0.m1078xf2829c12(transportContext, j);
                        }
                    });
                    return backendResponseM1061ok;
                }
            }
            jMax = Math.max(j, backendResponseM1061ok.getNextRequestWaitMillis());
            if (transportContext.shouldUploadClientHealthMetrics()) {
                this.guard.runCriticalSection(new SynchronizationGuard.CriticalSection() {
                    @Override
                    public final Object execute() {
                        return this.f$0.m1076x6e544154();
                    }
                });
            }
        }
    }

    Boolean m1072x65f78bd8(TransportContext transportContext) {
        return Boolean.valueOf(this.eventStore.hasPendingEventsFor(transportContext));
    }

    Iterable m1073xa80eb937(TransportContext transportContext) {
        return this.eventStore.loadBatch(transportContext);
    }

    Object m1074xea25e696(Iterable iterable, TransportContext transportContext, long j) {
        this.eventStore.recordFailure(iterable);
        this.eventStore.recordNextCallTime(transportContext, this.clock.getTime() + j);
        return null;
    }

    Object m1075x2c3d13f5(Iterable iterable) {
        this.eventStore.recordSuccess(iterable);
        return null;
    }

    Object m1076x6e544154() {
        this.clientHealthMetricsStore.resetClientMetrics();
        return null;
    }

    Object m1077xb06b6eb3(Map map) {
        for (Map.Entry entry : map.entrySet()) {
            this.clientHealthMetricsStore.recordLogEventDropped(((Integer) entry.getValue()).intValue(), LogEventDropped.Reason.INVALID_PAYLOD, (String) entry.getKey());
        }
        return null;
    }

    Object m1078xf2829c12(TransportContext transportContext, long j) {
        this.eventStore.recordNextCallTime(transportContext, this.clock.getTime() + j);
        return null;
    }

    public EventInternal createMetricsEvent(TransportBackend transportBackend) {
        SynchronizationGuard synchronizationGuard = this.guard;
        final ClientHealthMetricsStore clientHealthMetricsStore = this.clientHealthMetricsStore;
        Objects.requireNonNull(clientHealthMetricsStore);
        return transportBackend.decorate(EventInternal.builder().setEventMillis(this.clock.getTime()).setUptimeMillis(this.uptimeClock.getTime()).setTransportName(CLIENT_HEALTH_METRICS_LOG_SOURCE).setEncodedPayload(new EncodedPayload(Encoding.m1060of("proto"), ((ClientMetrics) synchronizationGuard.runCriticalSection(new SynchronizationGuard.CriticalSection() {
            @Override
            public final Object execute() {
                return clientHealthMetricsStore.loadClientMetrics();
            }
        })).toByteArray())).build());
    }
}
