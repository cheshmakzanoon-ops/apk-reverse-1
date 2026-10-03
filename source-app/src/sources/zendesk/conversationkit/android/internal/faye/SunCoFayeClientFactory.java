package zendesk.conversationkit.android.internal.faye;

import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.serialization.json.Json;
import zendesk.conversationkit.android.internal.ActionDispatcher;
import zendesk.conversationkit.android.internal.StubActionDispatcher;
import zendesk.conversationkit.android.model.AuthenticationType;
import zendesk.conversationkit.android.model.RealtimeSettings;
import zendesk.faye.FayeClientBuilder;

@Metadata(m17d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\b\u0000\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\u001e\u0010\u000b\u001a\u00020\f2\u0006\u0010\r\u001a\u00020\u000e2\u0006\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u0012R\u001a\u0010\u0005\u001a\u00020\u0006X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0007\u0010\b\"\u0004\b\t\u0010\nR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0013"}, m18d2 = {"Lzendesk/conversationkit/android/internal/faye/SunCoFayeClientFactory;", "", "coroutineScope", "Lkotlinx/coroutines/CoroutineScope;", "(Lkotlinx/coroutines/CoroutineScope;)V", "actionDispatcher", "Lzendesk/conversationkit/android/internal/ActionDispatcher;", "getActionDispatcher", "()Lzendesk/conversationkit/android/internal/ActionDispatcher;", "setActionDispatcher", "(Lzendesk/conversationkit/android/internal/ActionDispatcher;)V", "create", "Lzendesk/conversationkit/android/internal/faye/SunCoFayeClient;", "realtimeSettings", "Lzendesk/conversationkit/android/model/RealtimeSettings;", "authenticationType", "Lzendesk/conversationkit/android/model/AuthenticationType;", "json", "Lkotlinx/serialization/json/Json;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class SunCoFayeClientFactory {
    private ActionDispatcher actionDispatcher;
    private final CoroutineScope coroutineScope;

    public SunCoFayeClientFactory(CoroutineScope coroutineScope) {
        Intrinsics.checkNotNullParameter(coroutineScope, "coroutineScope");
        this.coroutineScope = coroutineScope;
        this.actionDispatcher = new StubActionDispatcher();
    }

    public final ActionDispatcher getActionDispatcher() {
        return this.actionDispatcher;
    }

    public final void setActionDispatcher(ActionDispatcher actionDispatcher) {
        Intrinsics.checkNotNullParameter(actionDispatcher, "<set-?>");
        this.actionDispatcher = actionDispatcher;
    }

    public final SunCoFayeClient create(RealtimeSettings realtimeSettings, AuthenticationType authenticationType, Json json) {
        Intrinsics.checkNotNullParameter(realtimeSettings, "realtimeSettings");
        Intrinsics.checkNotNullParameter(authenticationType, "authenticationType");
        Intrinsics.checkNotNullParameter(json, "json");
        return new DefaultSunCoFayeClient(new FayeClientBuilder(realtimeSettings.getBaseUrl()).build(), realtimeSettings, authenticationType, this.actionDispatcher, this.coroutineScope, json);
    }
}
