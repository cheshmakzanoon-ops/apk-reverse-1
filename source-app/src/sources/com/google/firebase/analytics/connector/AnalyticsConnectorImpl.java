package com.google.firebase.analytics.connector;

import android.content.Context;
import android.os.Bundle;
import com.google.android.gms.common.internal.Preconditions;
import com.google.android.gms.internal.measurement.zzdf;
import com.google.android.gms.measurement.AppMeasurement;
import com.google.android.gms.measurement.api.AppMeasurementSdk;
import com.google.firebase.DataCollectionDefaultChange;
import com.google.firebase.FirebaseApp;
import com.google.firebase.analytics.connector.internal.zze;
import com.google.firebase.analytics.connector.internal.zzg;
import com.google.firebase.events.Event;
import com.google.firebase.events.EventHandler;
import com.google.firebase.events.Subscriber;
import j$.util.concurrent.ConcurrentHashMap;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.Executor;

public class AnalyticsConnectorImpl implements AnalyticsConnector {
    private static volatile AnalyticsConnector zzb;
    final Map<String, com.google.firebase.analytics.connector.internal.zza> zza;
    private final AppMeasurementSdk zzc;

    @Override
    public int getMaxUserProperties(String str) {
        return this.zzc.getMaxUserProperties(str);
    }

    @Override
    public AnalyticsConnector.AnalyticsConnectorHandle registerAnalyticsConnectorListener(final String str, AnalyticsConnector.AnalyticsConnectorListener analyticsConnectorListener) {
        com.google.firebase.analytics.connector.internal.zza zzgVar;
        Preconditions.checkNotNull(analyticsConnectorListener);
        if (!com.google.firebase.analytics.connector.internal.zzb.zzf(str) || zza(str)) {
            return null;
        }
        AppMeasurementSdk appMeasurementSdk = this.zzc;
        if (AppMeasurement.FIAM_ORIGIN.equals(str)) {
            zzgVar = new zze(appMeasurementSdk, analyticsConnectorListener);
        } else {
            zzgVar = "clx".equals(str) ? new zzg(appMeasurementSdk, analyticsConnectorListener) : null;
        }
        if (zzgVar == null) {
            return null;
        }
        this.zza.put(str, zzgVar);
        return new AnalyticsConnector.AnalyticsConnectorHandle() {
            @Override
            public void registerEventNames(Set<String> set) {
                if (!AnalyticsConnectorImpl.this.zza(str) || !str.equals(AppMeasurement.FIAM_ORIGIN) || set == null || set.isEmpty()) {
                    return;
                }
                AnalyticsConnectorImpl.this.zza.get(str).zza(set);
            }

            @Override
            public void unregister() {
                if (AnalyticsConnectorImpl.this.zza(str)) {
                    AnalyticsConnector.AnalyticsConnectorListener analyticsConnectorListenerZza = AnalyticsConnectorImpl.this.zza.get(str).zza();
                    if (analyticsConnectorListenerZza != null) {
                        analyticsConnectorListenerZza.onMessageTriggered(0, null);
                    }
                    AnalyticsConnectorImpl.this.zza.remove(str);
                }
            }

            @Override
            public void unregisterEventNames() {
                if (AnalyticsConnectorImpl.this.zza(str) && str.equals(AppMeasurement.FIAM_ORIGIN)) {
                    AnalyticsConnectorImpl.this.zza.get(str).zzb();
                }
            }
        };
    }

    public static AnalyticsConnector getInstance() {
        return getInstance(FirebaseApp.getInstance());
    }

    public static AnalyticsConnector getInstance(FirebaseApp firebaseApp) {
        return (AnalyticsConnector) firebaseApp.get(AnalyticsConnector.class);
    }

    public static AnalyticsConnector getInstance(FirebaseApp firebaseApp, Context context, Subscriber subscriber) {
        Preconditions.checkNotNull(firebaseApp);
        Preconditions.checkNotNull(context);
        Preconditions.checkNotNull(subscriber);
        Preconditions.checkNotNull(context.getApplicationContext());
        if (zzb == null) {
            synchronized (AnalyticsConnectorImpl.class) {
                if (zzb == null) {
                    Bundle bundle = new Bundle(1);
                    if (firebaseApp.isDefaultApp()) {
                        subscriber.subscribe(DataCollectionDefaultChange.class, new Executor() {
                            @Override
                            public final void execute(Runnable runnable) {
                                runnable.run();
                            }
                        }, new EventHandler() {
                            @Override
                            public final void handle(Event event) {
                                AnalyticsConnectorImpl.zza(event);
                            }
                        });
                        bundle.putBoolean("dataCollectionDefaultEnabled", firebaseApp.isDataCollectionDefaultEnabled());
                    }
                    zzb = new AnalyticsConnectorImpl(zzdf.zza(context, (String) null, (String) null, (String) null, bundle).zzb());
                }
            }
        }
        return zzb;
    }

    @Override
    public List<AnalyticsConnector.ConditionalUserProperty> getConditionalUserProperties(String str, String str2) {
        ArrayList arrayList = new ArrayList();
        Iterator<Bundle> it = this.zzc.getConditionalUserProperties(str, str2).iterator();
        while (it.hasNext()) {
            arrayList.add(com.google.firebase.analytics.connector.internal.zzb.zza(it.next()));
        }
        return arrayList;
    }

    @Override
    public Map<String, Object> getUserProperties(boolean z) {
        return this.zzc.getUserProperties(null, null, z);
    }

    private AnalyticsConnectorImpl(AppMeasurementSdk appMeasurementSdk) {
        Preconditions.checkNotNull(appMeasurementSdk);
        this.zzc = appMeasurementSdk;
        this.zza = new ConcurrentHashMap();
    }

    @Override
    public void clearConditionalUserProperty(String str, String str2, Bundle bundle) {
        if (str2 == null || com.google.firebase.analytics.connector.internal.zzb.zza(str2, bundle)) {
            this.zzc.clearConditionalUserProperty(str, str2, bundle);
        }
    }

    static void zza(Event event) {
        boolean z = ((DataCollectionDefaultChange) event.getPayload()).enabled;
        synchronized (AnalyticsConnectorImpl.class) {
            ((AnalyticsConnectorImpl) Preconditions.checkNotNull(zzb)).zzc.zza(z);
        }
    }

    @Override
    public void logEvent(String str, String str2, Bundle bundle) {
        if (bundle == null) {
            bundle = new Bundle();
        }
        if (com.google.firebase.analytics.connector.internal.zzb.zzf(str) && com.google.firebase.analytics.connector.internal.zzb.zza(str2, bundle) && com.google.firebase.analytics.connector.internal.zzb.zzb(str, str2, bundle)) {
            com.google.firebase.analytics.connector.internal.zzb.zza(str, str2, bundle);
            this.zzc.logEvent(str, str2, bundle);
        }
    }

    @Override
    public void setConditionalUserProperty(AnalyticsConnector.ConditionalUserProperty conditionalUserProperty) {
        if (com.google.firebase.analytics.connector.internal.zzb.zzb(conditionalUserProperty)) {
            this.zzc.setConditionalUserProperty(com.google.firebase.analytics.connector.internal.zzb.zza(conditionalUserProperty));
        }
    }

    @Override
    public void setUserProperty(String str, String str2, Object obj) {
        if (com.google.firebase.analytics.connector.internal.zzb.zzf(str) && com.google.firebase.analytics.connector.internal.zzb.zza(str, str2)) {
            this.zzc.setUserProperty(str, str2, obj);
        }
    }

    public final boolean zza(String str) {
        return (str.isEmpty() || !this.zza.containsKey(str) || this.zza.get(str) == null) ? false : true;
    }
}
