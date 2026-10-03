package zendesk.android.settings.internal;

import javax.inject.Inject;
import javax.inject.Singleton;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.serialization.json.Json;
import zendesk.android.ZendeskCredentialsKt;
import zendesk.android.internal.ChannelKeyFields;
import zendesk.android.internal.ZendeskError;
import zendesk.android.internal.p013di.ZendeskComponentConfig;
import zendesk.android.settings.internal.model.SettingsDto;
import zendesk.android.settings.internal.model.SettingsResponseDto;

@Singleton
@Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0001\u0018\u00002\u00020\u0001B\u001f\b\u0001\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\bJ\u000e\u0010\t\u001a\u00020\nH\u0086@¢\u0006\u0002\u0010\u000bR\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\f"}, m18d2 = {"Lzendesk/android/settings/internal/SettingsRestClient;", "", "settingsApi", "Lzendesk/android/settings/internal/SettingsApi;", "json", "Lkotlinx/serialization/json/Json;", "zendeskComponentConfig", "Lzendesk/android/internal/di/ZendeskComponentConfig;", "(Lzendesk/android/settings/internal/SettingsApi;Lkotlinx/serialization/json/Json;Lzendesk/android/internal/di/ZendeskComponentConfig;)V", "getSettings", "Lzendesk/android/settings/internal/model/SettingsDto;", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class SettingsRestClient {
    private final Json json;
    private final SettingsApi settingsApi;
    private final ZendeskComponentConfig zendeskComponentConfig;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.android.settings.internal.SettingsRestClient", m37f = "SettingsRestClient.kt", m38i = {}, m39l = {34}, m40m = "getSettings", m41n = {}, m42s = {})
    static final class C09901 extends ContinuationImpl {
        int label;
        Object result;

        C09901(Continuation<? super C09901> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return SettingsRestClient.this.getSettings(this);
        }
    }

    @Inject
    public SettingsRestClient(SettingsApi settingsApi, Json json, ZendeskComponentConfig zendeskComponentConfig) {
        Intrinsics.checkNotNullParameter(settingsApi, "settingsApi");
        Intrinsics.checkNotNullParameter(json, "json");
        Intrinsics.checkNotNullParameter(zendeskComponentConfig, "zendeskComponentConfig");
        this.settingsApi = settingsApi;
        this.json = json;
        this.zendeskComponentConfig = zendeskComponentConfig;
    }

    public final Object getSettings(Continuation<? super SettingsDto> continuation) throws Throwable {
        C09901 c09901;
        if (continuation instanceof C09901) {
            c09901 = (C09901) continuation;
            if ((c09901.label & Integer.MIN_VALUE) != 0) {
                c09901.label -= Integer.MIN_VALUE;
            } else {
                c09901 = new C09901(continuation);
            }
        } else {
            c09901 = new C09901(continuation);
        }
        Object settings = c09901.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c09901.label;
        if (i == 0) {
            ResultKt.throwOnFailure(settings);
            ChannelKeyFields channelKeyFields = ZendeskCredentialsKt.toChannelKeyFields(this.zendeskComponentConfig.getChannelKey(), this.json);
            if (channelKeyFields == null) {
                throw ZendeskError.InvalidChannelKey.INSTANCE;
            }
            SettingsApi settingsApi = this.settingsApi;
            String settingsUrl = channelKeyFields.getSettingsUrl();
            c09901.label = 1;
            settings = settingsApi.getSettings(settingsUrl, c09901);
            if (settings == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(settings);
        }
        return ((SettingsResponseDto) settings).getSettings();
    }
}
