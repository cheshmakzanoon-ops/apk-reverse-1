package com.google.firebase.sessions.settings;

import androidx.datastore.preferences.core.MutablePreferences;
import androidx.datastore.preferences.core.Preferences;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;

@Metadata(d1 = {"\u0000\f\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u0003H\u008a@"}, d2 = {"<anonymous>", "", "preferences", "Landroidx/datastore/preferences/core/MutablePreferences;"}, k = 3, mv = {1, 7, 1}, xi = 48)
@DebugMetadata(c = "com.google.firebase.sessions.settings.SettingsCache$removeConfigs$2", f = "SettingsCache.kt", i = {}, l = {}, m = "invokeSuspend", n = {}, s = {})
final class SettingsCache$removeConfigs$2 extends SuspendLambda implements Function2<MutablePreferences, Continuation<? super Unit>, Object> {
    Object L$0;
    int label;
    final SettingsCache this$0;

    SettingsCache$removeConfigs$2(SettingsCache settingsCache, Continuation<? super SettingsCache$removeConfigs$2> continuation) {
        super(2, continuation);
        this.this$0 = settingsCache;
    }

    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        Continuation<Unit> settingsCache$removeConfigs$2 = new SettingsCache$removeConfigs$2(this.this$0, continuation);
        settingsCache$removeConfigs$2.L$0 = obj;
        return settingsCache$removeConfigs$2;
    }

    public final Object invoke(MutablePreferences mutablePreferences, Continuation<? super Unit> continuation) {
        return create(mutablePreferences, continuation).invokeSuspend(Unit.INSTANCE);
    }

    public final Object invokeSuspend(Object obj) {
        IntrinsicsKt.getCOROUTINE_SUSPENDED();
        if (this.label != 0) {
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
        ResultKt.throwOnFailure(obj);
        Preferences preferences = (MutablePreferences) this.L$0;
        preferences.clear();
        this.this$0.updateSessionConfigs(preferences);
        return Unit.INSTANCE;
    }
}
