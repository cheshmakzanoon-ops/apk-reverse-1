package com.google.firebase.sessions.settings;

import android.util.Log;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.Boxing;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.Ref;
import org.json.JSONException;
import org.json.JSONObject;

@Metadata(d1 = {"\u0000\f\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u0003H\u008a@"}, d2 = {"<anonymous>", "", "it", "Lorg/json/JSONObject;"}, k = 3, mv = {1, 7, 1}, xi = 48)
@DebugMetadata(c = "com.google.firebase.sessions.settings.RemoteSettings$updateSettings$2$1", f = "RemoteSettings.kt", i = {0, 0, 0, 1, 1, 2}, l = {122, 125, 128, 130, 131, 133}, m = "invokeSuspend", n = {"sessionSamplingRate", "sessionTimeoutSeconds", "cacheDuration", "sessionSamplingRate", "cacheDuration", "cacheDuration"}, s = {"L$0", "L$1", "L$2", "L$0", "L$1", "L$0"})
final class RemoteSettings$updateSettings$2$1 extends SuspendLambda implements Function2<JSONObject, Continuation<? super Unit>, Object> {
    Object L$0;
    Object L$1;
    Object L$2;
    int label;
    final RemoteSettings this$0;

    RemoteSettings$updateSettings$2$1(RemoteSettings remoteSettings, Continuation<? super RemoteSettings$updateSettings$2$1> continuation) {
        super(2, continuation);
        this.this$0 = remoteSettings;
    }

    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        Continuation<Unit> remoteSettings$updateSettings$2$1 = new RemoteSettings$updateSettings$2$1(this.this$0, continuation);
        remoteSettings$updateSettings$2$1.L$0 = obj;
        return remoteSettings$updateSettings$2$1;
    }

    public final Object invoke(JSONObject jSONObject, Continuation<? super Unit> continuation) {
        return create(jSONObject, continuation).invokeSuspend(Unit.INSTANCE);
    }

    public final Object invokeSuspend(Object obj) throws JSONException {
        Ref.ObjectRef objectRef;
        Boolean bool;
        Ref.ObjectRef objectRef2;
        Ref.ObjectRef objectRef3;
        Ref.ObjectRef objectRef4;
        Ref.ObjectRef objectRef5;
        Integer num;
        SettingsCache settingsCache;
        Integer num2;
        Double d;
        SettingsCache settingsCache2;
        Double d2;
        Integer num3;
        Unit unit;
        SettingsCache settingsCache3;
        Integer num4;
        SettingsCache settingsCache4;
        Integer numBoxInt;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        switch (this.label) {
            case 0:
                ResultKt.throwOnFailure(obj);
                JSONObject jSONObject = (JSONObject) this.L$0;
                Ref.ObjectRef objectRef6 = new Ref.ObjectRef();
                objectRef = new Ref.ObjectRef();
                Ref.ObjectRef objectRef7 = new Ref.ObjectRef();
                if (jSONObject.has("app_quality")) {
                    Object obj2 = jSONObject.get("app_quality");
                    Intrinsics.checkNotNull(obj2, "null cannot be cast to non-null type org.json.JSONObject");
                    JSONObject jSONObject2 = (JSONObject) obj2;
                    try {
                        bool = jSONObject2.has("sessions_enabled") ? (Boolean) jSONObject2.get("sessions_enabled") : null;
                        try {
                            if (jSONObject2.has("sampling_rate")) {
                                objectRef6.element = (Double) jSONObject2.get("sampling_rate");
                            }
                            if (jSONObject2.has("session_timeout_seconds")) {
                                objectRef.element = (Integer) jSONObject2.get("session_timeout_seconds");
                            }
                            if (jSONObject2.has("cache_duration")) {
                                objectRef7.element = (Integer) jSONObject2.get("cache_duration");
                            }
                        } catch (JSONException e) {
                            e = e;
                            Log.e(RemoteSettings.TAG, "Error parsing the configs remotely fetched: ", e);
                        }
                    } catch (JSONException e2) {
                        e = e2;
                        bool = null;
                    }
                    break;
                } else {
                    bool = null;
                }
                if (bool != null) {
                    RemoteSettings remoteSettings = this.this$0;
                    bool.booleanValue();
                    SettingsCache settingsCache5 = remoteSettings.settingsCache;
                    this.L$0 = objectRef6;
                    this.L$1 = objectRef;
                    this.L$2 = objectRef7;
                    this.label = 1;
                    if (settingsCache5.updateSettingsEnabled(bool, this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    objectRef4 = objectRef6;
                    objectRef5 = objectRef;
                    objectRef3 = objectRef7;
                    objectRef = objectRef5;
                    objectRef2 = objectRef4;
                } else {
                    objectRef2 = objectRef6;
                    objectRef3 = objectRef7;
                }
                num = (Integer) objectRef.element;
                if (num != null) {
                    RemoteSettings remoteSettings2 = this.this$0;
                    num.intValue();
                    settingsCache = remoteSettings2.settingsCache;
                    num2 = (Integer) objectRef.element;
                    this.L$0 = objectRef2;
                    this.L$1 = objectRef3;
                    this.L$2 = null;
                    this.label = 2;
                    if (settingsCache.updateSessionRestartTimeout(num2, this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                }
                d = (Double) objectRef2.element;
                if (d != null) {
                    RemoteSettings remoteSettings3 = this.this$0;
                    d.doubleValue();
                    settingsCache2 = remoteSettings3.settingsCache;
                    d2 = (Double) objectRef2.element;
                    this.L$0 = objectRef3;
                    this.L$1 = null;
                    this.L$2 = null;
                    this.label = 3;
                    if (settingsCache2.updateSamplingRate(d2, this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                }
                num3 = (Integer) objectRef3.element;
                if (num3 != null) {
                    RemoteSettings remoteSettings4 = this.this$0;
                    num3.intValue();
                    settingsCache3 = remoteSettings4.settingsCache;
                    num4 = (Integer) objectRef3.element;
                    this.L$0 = null;
                    this.L$1 = null;
                    this.L$2 = null;
                    this.label = 4;
                    if (settingsCache3.updateSessionCacheDuration(num4, this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    unit = Unit.INSTANCE;
                } else {
                    unit = null;
                }
                if (unit == null) {
                    settingsCache4 = this.this$0.settingsCache;
                    numBoxInt = Boxing.boxInt(86400);
                    this.L$0 = null;
                    this.L$1 = null;
                    this.L$2 = null;
                    this.label = 5;
                    if (settingsCache4.updateSessionCacheDuration(numBoxInt, this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                }
                this.L$0 = null;
                this.L$1 = null;
                this.L$2 = null;
                this.label = 6;
                if (this.this$0.settingsCache.updateSessionCacheUpdatedTime(Boxing.boxLong(System.currentTimeMillis()), (Continuation) this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return Unit.INSTANCE;
            case 1:
                objectRef3 = (Ref.ObjectRef) this.L$2;
                objectRef5 = (Ref.ObjectRef) this.L$1;
                objectRef4 = (Ref.ObjectRef) this.L$0;
                ResultKt.throwOnFailure(obj);
                objectRef = objectRef5;
                objectRef2 = objectRef4;
                num = (Integer) objectRef.element;
                if (num != null) {
                    RemoteSettings remoteSettings5 = this.this$0;
                    num.intValue();
                    settingsCache = remoteSettings5.settingsCache;
                    num2 = (Integer) objectRef.element;
                    this.L$0 = objectRef2;
                    this.L$1 = objectRef3;
                    this.L$2 = null;
                    this.label = 2;
                    if (settingsCache.updateSessionRestartTimeout(num2, this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                }
                d = (Double) objectRef2.element;
                if (d != null) {
                    RemoteSettings remoteSettings6 = this.this$0;
                    d.doubleValue();
                    settingsCache2 = remoteSettings6.settingsCache;
                    d2 = (Double) objectRef2.element;
                    this.L$0 = objectRef3;
                    this.L$1 = null;
                    this.L$2 = null;
                    this.label = 3;
                    if (settingsCache2.updateSamplingRate(d2, this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                }
                num3 = (Integer) objectRef3.element;
                if (num3 != null) {
                    RemoteSettings remoteSettings7 = this.this$0;
                    num3.intValue();
                    settingsCache3 = remoteSettings7.settingsCache;
                    num4 = (Integer) objectRef3.element;
                    this.L$0 = null;
                    this.L$1 = null;
                    this.L$2 = null;
                    this.label = 4;
                    if (settingsCache3.updateSessionCacheDuration(num4, this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    unit = Unit.INSTANCE;
                } else {
                    unit = null;
                }
                if (unit == null) {
                    settingsCache4 = this.this$0.settingsCache;
                    numBoxInt = Boxing.boxInt(86400);
                    this.L$0 = null;
                    this.L$1 = null;
                    this.L$2 = null;
                    this.label = 5;
                    if (settingsCache4.updateSessionCacheDuration(numBoxInt, this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                }
                this.L$0 = null;
                this.L$1 = null;
                this.L$2 = null;
                this.label = 6;
                if (this.this$0.settingsCache.updateSessionCacheUpdatedTime(Boxing.boxLong(System.currentTimeMillis()), (Continuation) this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return Unit.INSTANCE;
            case 2:
                objectRef3 = (Ref.ObjectRef) this.L$1;
                objectRef2 = (Ref.ObjectRef) this.L$0;
                ResultKt.throwOnFailure(obj);
                d = (Double) objectRef2.element;
                if (d != null) {
                    RemoteSettings remoteSettings8 = this.this$0;
                    d.doubleValue();
                    settingsCache2 = remoteSettings8.settingsCache;
                    d2 = (Double) objectRef2.element;
                    this.L$0 = objectRef3;
                    this.L$1 = null;
                    this.L$2 = null;
                    this.label = 3;
                    if (settingsCache2.updateSamplingRate(d2, this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                }
                num3 = (Integer) objectRef3.element;
                if (num3 != null) {
                    RemoteSettings remoteSettings9 = this.this$0;
                    num3.intValue();
                    settingsCache3 = remoteSettings9.settingsCache;
                    num4 = (Integer) objectRef3.element;
                    this.L$0 = null;
                    this.L$1 = null;
                    this.L$2 = null;
                    this.label = 4;
                    if (settingsCache3.updateSessionCacheDuration(num4, this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    unit = Unit.INSTANCE;
                } else {
                    unit = null;
                }
                if (unit == null) {
                    settingsCache4 = this.this$0.settingsCache;
                    numBoxInt = Boxing.boxInt(86400);
                    this.L$0 = null;
                    this.L$1 = null;
                    this.L$2 = null;
                    this.label = 5;
                    if (settingsCache4.updateSessionCacheDuration(numBoxInt, this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                }
                this.L$0 = null;
                this.L$1 = null;
                this.L$2 = null;
                this.label = 6;
                if (this.this$0.settingsCache.updateSessionCacheUpdatedTime(Boxing.boxLong(System.currentTimeMillis()), (Continuation) this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return Unit.INSTANCE;
            case 3:
                objectRef3 = (Ref.ObjectRef) this.L$0;
                ResultKt.throwOnFailure(obj);
                num3 = (Integer) objectRef3.element;
                if (num3 != null) {
                    RemoteSettings remoteSettings10 = this.this$0;
                    num3.intValue();
                    settingsCache3 = remoteSettings10.settingsCache;
                    num4 = (Integer) objectRef3.element;
                    this.L$0 = null;
                    this.L$1 = null;
                    this.L$2 = null;
                    this.label = 4;
                    if (settingsCache3.updateSessionCacheDuration(num4, this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    unit = Unit.INSTANCE;
                } else {
                    unit = null;
                }
                if (unit == null) {
                    settingsCache4 = this.this$0.settingsCache;
                    numBoxInt = Boxing.boxInt(86400);
                    this.L$0 = null;
                    this.L$1 = null;
                    this.L$2 = null;
                    this.label = 5;
                    if (settingsCache4.updateSessionCacheDuration(numBoxInt, this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                }
                this.L$0 = null;
                this.L$1 = null;
                this.L$2 = null;
                this.label = 6;
                if (this.this$0.settingsCache.updateSessionCacheUpdatedTime(Boxing.boxLong(System.currentTimeMillis()), (Continuation) this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return Unit.INSTANCE;
            case 4:
                ResultKt.throwOnFailure(obj);
                unit = Unit.INSTANCE;
                if (unit == null) {
                    settingsCache4 = this.this$0.settingsCache;
                    numBoxInt = Boxing.boxInt(86400);
                    this.L$0 = null;
                    this.L$1 = null;
                    this.L$2 = null;
                    this.label = 5;
                    if (settingsCache4.updateSessionCacheDuration(numBoxInt, this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                }
                this.L$0 = null;
                this.L$1 = null;
                this.L$2 = null;
                this.label = 6;
                if (this.this$0.settingsCache.updateSessionCacheUpdatedTime(Boxing.boxLong(System.currentTimeMillis()), (Continuation) this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return Unit.INSTANCE;
            case 5:
                ResultKt.throwOnFailure(obj);
                this.L$0 = null;
                this.L$1 = null;
                this.L$2 = null;
                this.label = 6;
                if (this.this$0.settingsCache.updateSessionCacheUpdatedTime(Boxing.boxLong(System.currentTimeMillis()), (Continuation) this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return Unit.INSTANCE;
            case 6:
                ResultKt.throwOnFailure(obj);
                return Unit.INSTANCE;
            default:
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
    }
}
