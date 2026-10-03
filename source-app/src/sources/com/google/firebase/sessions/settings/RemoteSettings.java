package com.google.firebase.sessions.settings;

import android.os.Build;
import android.util.Log;
import androidx.datastore.core.DataStore;
import androidx.datastore.preferences.core.Preferences;
import com.google.android.gms.tasks.Task;
import com.google.firebase.installations.FirebaseInstallationsApi;
import com.google.firebase.sessions.ApplicationInfo;
import com.ishumei.smantifraud.l111l111lIlll;
import java.util.Arrays;
import java.util.Map;
import kotlin.Metadata;
import kotlin.Pair;
import kotlin.ResultKt;
import kotlin.TuplesKt;
import kotlin.Unit;
import kotlin.collections.MapsKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.StringCompanionObject;
import kotlin.text.Regex;
import kotlin.time.Duration;
import kotlin.time.DurationKt;
import kotlin.time.DurationUnit;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineScopeKt;
import kotlinx.coroutines.CoroutineStart;
import kotlinx.coroutines.sync.Mutex;
import kotlinx.coroutines.sync.MutexKt;
import kotlinx.coroutines.tasks.TasksKt;

@Metadata(d1 = {"\u0000b\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0006\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0002\b\u0005\b\u0000\u0018\u0000 '2\u00020\u0001:\u0001'B3\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\t\u0012\f\u0010\n\u001a\b\u0012\u0004\u0012\u00020\f0\u000b¢\u0006\u0002\u0010\rJ\r\u0010\u001e\u001a\u00020\u001fH\u0001¢\u0006\u0002\b J\b\u0010!\u001a\u00020\u0015H\u0016J\u0010\u0010\"\u001a\u00020#2\u0006\u0010$\u001a\u00020#H\u0002J\u0011\u0010%\u001a\u00020\u001fH\u0096@ø\u0001\u0000¢\u0006\u0002\u0010&R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\tX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000e\u001a\u00020\u000fX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u0016\u0010\u0010\u001a\u0004\u0018\u00010\u00118VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u0012\u0010\u0013R\u0016\u0010\u0014\u001a\u0004\u0018\u00010\u00158VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u0016\u0010\u0017R\u001f\u0010\u0018\u001a\u0004\u0018\u00010\u00198VX\u0096\u0004ø\u0001\u0000ø\u0001\u0001ø\u0001\u0002¢\u0006\u0006\u001a\u0004\b\u001a\u0010\u001bR\u000e\u0010\u001c\u001a\u00020\u001dX\u0082\u0004¢\u0006\u0002\n\u0000\u0082\u0002\u000f\n\u0002\b\u0019\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006("}, d2 = {"Lcom/google/firebase/sessions/settings/RemoteSettings;", "Lcom/google/firebase/sessions/settings/SettingsProvider;", "backgroundDispatcher", "Lkotlin/coroutines/CoroutineContext;", "firebaseInstallationsApi", "Lcom/google/firebase/installations/FirebaseInstallationsApi;", "appInfo", "Lcom/google/firebase/sessions/ApplicationInfo;", "configsFetcher", "Lcom/google/firebase/sessions/settings/CrashlyticsSettingsFetcher;", "dataStore", "Landroidx/datastore/core/DataStore;", "Landroidx/datastore/preferences/core/Preferences;", "(Lkotlin/coroutines/CoroutineContext;Lcom/google/firebase/installations/FirebaseInstallationsApi;Lcom/google/firebase/sessions/ApplicationInfo;Lcom/google/firebase/sessions/settings/CrashlyticsSettingsFetcher;Landroidx/datastore/core/DataStore;)V", "fetchInProgress", "Lkotlinx/coroutines/sync/Mutex;", "samplingRate", "", "getSamplingRate", "()Ljava/lang/Double;", "sessionEnabled", "", "getSessionEnabled", "()Ljava/lang/Boolean;", "sessionRestartTimeout", "Lkotlin/time/Duration;", "getSessionRestartTimeout-FghU774", "()Lkotlin/time/Duration;", "settingsCache", "Lcom/google/firebase/sessions/settings/SettingsCache;", "clearCachedSettings", "", "clearCachedSettings$com_google_firebase_firebase_sessions", "isSettingsStale", "removeForwardSlashesIn", "", l111l111lIlll.l11l111l1Il, "updateSettings", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "Companion", "com.google.firebase-firebase-sessions"}, k = 1, mv = {1, 7, 1}, xi = 48)
public final class RemoteSettings implements SettingsProvider {
    private static final Companion Companion = new Companion(null);

    @Deprecated
    public static final String FORWARD_SLASH_STRING = "/";

    @Deprecated
    public static final String TAG = "SessionConfigFetcher";
    private final ApplicationInfo appInfo;
    private final CoroutineContext backgroundDispatcher;
    private final CrashlyticsSettingsFetcher configsFetcher;
    private final Mutex fetchInProgress;
    private final FirebaseInstallationsApi firebaseInstallationsApi;
    private final SettingsCache settingsCache;

    @Metadata(k = 3, mv = {1, 7, 1}, xi = 48)
    @DebugMetadata(c = "com.google.firebase.sessions.settings.RemoteSettings", f = "RemoteSettings.kt", i = {0, 0, 1, 1, 2}, l = {167, 75, 92}, m = "updateSettings", n = {"this", "$this$withLock_u24default$iv", "this", "$this$withLock_u24default$iv", "$this$withLock_u24default$iv"}, s = {"L$0", "L$1", "L$0", "L$1", "L$0"})
    static final class C09011 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C09011(Continuation<? super C09011> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return RemoteSettings.this.updateSettings((Continuation) this);
        }
    }

    public RemoteSettings(CoroutineContext coroutineContext, FirebaseInstallationsApi firebaseInstallationsApi, ApplicationInfo applicationInfo, CrashlyticsSettingsFetcher crashlyticsSettingsFetcher, DataStore<Preferences> dataStore) {
        Intrinsics.checkNotNullParameter(coroutineContext, "backgroundDispatcher");
        Intrinsics.checkNotNullParameter(firebaseInstallationsApi, "firebaseInstallationsApi");
        Intrinsics.checkNotNullParameter(applicationInfo, "appInfo");
        Intrinsics.checkNotNullParameter(crashlyticsSettingsFetcher, "configsFetcher");
        Intrinsics.checkNotNullParameter(dataStore, "dataStore");
        this.backgroundDispatcher = coroutineContext;
        this.firebaseInstallationsApi = firebaseInstallationsApi;
        this.appInfo = applicationInfo;
        this.configsFetcher = crashlyticsSettingsFetcher;
        this.settingsCache = new SettingsCache(dataStore);
        this.fetchInProgress = MutexKt.Mutex$default(false, 1, (Object) null);
    }

    @Override
    public Boolean getSessionEnabled() {
        return this.settingsCache.sessionsEnabled();
    }

    @Override
    public Duration mo786getSessionRestartTimeoutFghU774() {
        Integer numSessionRestartTimeout = this.settingsCache.sessionRestartTimeout();
        if (numSessionRestartTimeout == null) {
            return null;
        }
        Duration.Companion companion = Duration.Companion;
        return Duration.box-impl(DurationKt.toDuration(numSessionRestartTimeout.intValue(), DurationUnit.SECONDS));
    }

    @Override
    public Double getSamplingRate() {
        return this.settingsCache.sessionSamplingRate();
    }

    @Override
    public Object updateSettings(Continuation<? super Unit> continuation) throws Throwable {
        C09011 c09011;
        Mutex mutex;
        RemoteSettings remoteSettings;
        Mutex mutex2;
        Throwable th;
        Mutex mutex3;
        String str;
        Map<String, String> mapMapOf;
        CrashlyticsSettingsFetcher crashlyticsSettingsFetcher;
        RemoteSettings$updateSettings$2$1 remoteSettings$updateSettings$2$1;
        RemoteSettings$updateSettings$2$2 remoteSettings$updateSettings$2$2;
        if (continuation instanceof C09011) {
            c09011 = (C09011) continuation;
            if ((c09011.label & Integer.MIN_VALUE) != 0) {
                c09011.label -= Integer.MIN_VALUE;
            } else {
                c09011 = new C09011(continuation);
            }
        } else {
            c09011 = new C09011(continuation);
        }
        Object obj = c09011.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c09011.label;
        try {
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                if (!this.fetchInProgress.isLocked() && !this.settingsCache.hasCacheExpired$com_google_firebase_firebase_sessions()) {
                    return Unit.INSTANCE;
                }
                mutex = this.fetchInProgress;
                c09011.L$0 = this;
                c09011.L$1 = mutex;
                c09011.label = 1;
                if (mutex.lock((Object) null, c09011) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                remoteSettings = this;
            } else {
                if (i != 1) {
                    if (i != 2) {
                        if (i == 3) {
                            mutex2 = (Mutex) c09011.L$0;
                            try {
                                ResultKt.throwOnFailure(obj);
                                Unit unit = Unit.INSTANCE;
                                mutex2.unlock((Object) null);
                                return Unit.INSTANCE;
                            } catch (Throwable th2) {
                                th = th2;
                                mutex2.unlock((Object) null);
                                throw th;
                            }
                        }
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    mutex3 = (Mutex) c09011.L$1;
                    remoteSettings = (RemoteSettings) c09011.L$0;
                    try {
                        ResultKt.throwOnFailure(obj);
                        str = (String) obj;
                        if (str == null) {
                            Log.w(TAG, "Error getting Firebase Installation ID. Skipping this Session Event.");
                            Unit unit2 = Unit.INSTANCE;
                            mutex3.unlock((Object) null);
                            return unit2;
                        }
                        StringCompanionObject stringCompanionObject = StringCompanionObject.INSTANCE;
                        String str2 = String.format("%s/%s", Arrays.copyOf(new Object[]{Build.MANUFACTURER, Build.MODEL}, 2));
                        Intrinsics.checkNotNullExpressionValue(str2, "format(format, *args)");
                        String str3 = Build.VERSION.INCREMENTAL;
                        Intrinsics.checkNotNullExpressionValue(str3, "INCREMENTAL");
                        String str4 = Build.VERSION.RELEASE;
                        Intrinsics.checkNotNullExpressionValue(str4, "RELEASE");
                        mapMapOf = MapsKt.mapOf(new Pair[]{TuplesKt.to("X-Crashlytics-Installation-ID", str), TuplesKt.to("X-Crashlytics-Device-Model", remoteSettings.removeForwardSlashesIn(str2)), TuplesKt.to("X-Crashlytics-OS-Build-Version", remoteSettings.removeForwardSlashesIn(str3)), TuplesKt.to("X-Crashlytics-OS-Display-Version", remoteSettings.removeForwardSlashesIn(str4)), TuplesKt.to("X-Crashlytics-API-Client-Version", remoteSettings.appInfo.getSessionSdkVersion())});
                        crashlyticsSettingsFetcher = remoteSettings.configsFetcher;
                        remoteSettings$updateSettings$2$1 = new RemoteSettings$updateSettings$2$1(remoteSettings, null);
                        remoteSettings$updateSettings$2$2 = new RemoteSettings$updateSettings$2$2(null);
                        c09011.L$0 = mutex3;
                        c09011.L$1 = null;
                        c09011.label = 3;
                        if (crashlyticsSettingsFetcher.doConfigFetch(mapMapOf, remoteSettings$updateSettings$2$1, remoteSettings$updateSettings$2$2, c09011) == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        mutex2 = mutex3;
                        Unit unit3 = Unit.INSTANCE;
                        mutex2.unlock((Object) null);
                        return Unit.INSTANCE;
                    } catch (Throwable th3) {
                        th = th3;
                        mutex2 = mutex3;
                        mutex2.unlock((Object) null);
                        throw th;
                    }
                }
                Mutex mutex4 = (Mutex) c09011.L$1;
                remoteSettings = (RemoteSettings) c09011.L$0;
                ResultKt.throwOnFailure(obj);
                mutex = mutex4;
            }
            if (!remoteSettings.settingsCache.hasCacheExpired$com_google_firebase_firebase_sessions()) {
                Unit unit4 = Unit.INSTANCE;
                mutex.unlock((Object) null);
                return unit4;
            }
            Task<String> id = remoteSettings.firebaseInstallationsApi.getId();
            Intrinsics.checkNotNullExpressionValue(id, "firebaseInstallationsApi.id");
            c09011.L$0 = remoteSettings;
            c09011.L$1 = mutex;
            c09011.label = 2;
            Object objAwait = TasksKt.await(id, c09011);
            if (objAwait == coroutine_suspended) {
                return coroutine_suspended;
            }
            mutex3 = mutex;
            obj = objAwait;
            str = (String) obj;
            if (str == null) {
                Log.w(TAG, "Error getting Firebase Installation ID. Skipping this Session Event.");
                Unit unit5 = Unit.INSTANCE;
                mutex3.unlock((Object) null);
                return unit5;
            }
            StringCompanionObject stringCompanionObject2 = StringCompanionObject.INSTANCE;
            String str5 = String.format("%s/%s", Arrays.copyOf(new Object[]{Build.MANUFACTURER, Build.MODEL}, 2));
            Intrinsics.checkNotNullExpressionValue(str5, "format(format, *args)");
            String str6 = Build.VERSION.INCREMENTAL;
            Intrinsics.checkNotNullExpressionValue(str6, "INCREMENTAL");
            String str7 = Build.VERSION.RELEASE;
            Intrinsics.checkNotNullExpressionValue(str7, "RELEASE");
            mapMapOf = MapsKt.mapOf(new Pair[]{TuplesKt.to("X-Crashlytics-Installation-ID", str), TuplesKt.to("X-Crashlytics-Device-Model", remoteSettings.removeForwardSlashesIn(str5)), TuplesKt.to("X-Crashlytics-OS-Build-Version", remoteSettings.removeForwardSlashesIn(str6)), TuplesKt.to("X-Crashlytics-OS-Display-Version", remoteSettings.removeForwardSlashesIn(str7)), TuplesKt.to("X-Crashlytics-API-Client-Version", remoteSettings.appInfo.getSessionSdkVersion())});
            crashlyticsSettingsFetcher = remoteSettings.configsFetcher;
            remoteSettings$updateSettings$2$1 = new RemoteSettings$updateSettings$2$1(remoteSettings, null);
            remoteSettings$updateSettings$2$2 = new RemoteSettings$updateSettings$2$2(null);
            c09011.L$0 = mutex3;
            c09011.L$1 = null;
            c09011.label = 3;
            if (crashlyticsSettingsFetcher.doConfigFetch(mapMapOf, remoteSettings$updateSettings$2$1, remoteSettings$updateSettings$2$2, c09011) == coroutine_suspended) {
                return coroutine_suspended;
            }
            mutex2 = mutex3;
            Unit unit6 = Unit.INSTANCE;
            mutex2.unlock((Object) null);
            return Unit.INSTANCE;
        } catch (Throwable th4) {
            mutex2 = mutex;
            th = th4;
            mutex2.unlock((Object) null);
            throw th;
        }
    }

    @Override
    public boolean isSettingsStale() {
        return this.settingsCache.hasCacheExpired$com_google_firebase_firebase_sessions();
    }

    public final void clearCachedSettings$com_google_firebase_firebase_sessions() {
        BuildersKt.launch$default(CoroutineScopeKt.CoroutineScope(this.backgroundDispatcher), (CoroutineContext) null, (CoroutineStart) null, new RemoteSettings$clearCachedSettings$1(this, null), 3, (Object) null);
    }

    private final String removeForwardSlashesIn(String s) {
        return new Regex(FORWARD_SLASH_STRING).replace(s, "");
    }

    @Metadata(d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0002\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000¨\u0006\u0006"}, d2 = {"Lcom/google/firebase/sessions/settings/RemoteSettings$Companion;", "", "()V", "FORWARD_SLASH_STRING", "", "TAG", "com.google.firebase-firebase-sessions"}, k = 1, mv = {1, 7, 1}, xi = 48)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
