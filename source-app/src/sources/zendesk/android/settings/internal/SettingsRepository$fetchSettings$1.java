package zendesk.android.settings.internal;

import kotlin.Metadata;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;

@Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
@DebugMetadata(m36c = "zendesk.android.settings.internal.SettingsRepository", m37f = "SettingsRepository.kt", m38i = {}, m39l = {27}, m40m = "fetchSettings$zendesk_zendesk_android", m41n = {}, m42s = {})
final class SettingsRepository$fetchSettings$1 extends ContinuationImpl {
    int label;
    Object result;
    final SettingsRepository this$0;

    SettingsRepository$fetchSettings$1(SettingsRepository settingsRepository, Continuation<? super SettingsRepository$fetchSettings$1> continuation) {
        super(continuation);
        this.this$0 = settingsRepository;
    }

    @Override
    public final Object invokeSuspend(Object obj) {
        this.result = obj;
        this.label |= Integer.MIN_VALUE;
        return this.this$0.fetchSettings$zendesk_zendesk_android(this);
    }
}
