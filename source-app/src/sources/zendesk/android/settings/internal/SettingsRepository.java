package zendesk.android.settings.internal;

import javax.inject.Inject;
import javax.inject.Singleton;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.serialization.SerializationException;
import retrofit2.HttpException;
import zendesk.android.Zendesk;
import zendesk.android.ZendeskResult;
import zendesk.android.internal.ZendeskError;
import zendesk.android.settings.internal.model.SettingsDto;
import zendesk.logger.Logger;

@Singleton
@Metadata(m17d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0003\n\u0002\b\u0003\b\u0001\u0018\u00002\u00020\u0001B\u000f\b\u0001\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\u001c\u0010\u0005\u001a\u000e\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\b0\u0006H\u0080@¢\u0006\u0004\b\t\u0010\nR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u000b"}, m18d2 = {"Lzendesk/android/settings/internal/SettingsRepository;", "", "settingsRestClient", "Lzendesk/android/settings/internal/SettingsRestClient;", "(Lzendesk/android/settings/internal/SettingsRestClient;)V", "fetchSettings", "Lzendesk/android/ZendeskResult;", "Lzendesk/android/settings/internal/model/SettingsDto;", "", "fetchSettings$zendesk_zendesk_android", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class SettingsRepository {
    private final SettingsRestClient settingsRestClient;

    @Inject
    public SettingsRepository(SettingsRestClient settingsRestClient) {
        Intrinsics.checkNotNullParameter(settingsRestClient, "settingsRestClient");
        this.settingsRestClient = settingsRestClient;
    }

    public final Object fetchSettings$zendesk_zendesk_android(Continuation<? super ZendeskResult<SettingsDto, ? extends Throwable>> continuation) throws Throwable {
        SettingsRepository$fetchSettings$1 settingsRepository$fetchSettings$1;
        ZendeskResult.Failure failure;
        if (continuation instanceof SettingsRepository$fetchSettings$1) {
            settingsRepository$fetchSettings$1 = (SettingsRepository$fetchSettings$1) continuation;
            if ((settingsRepository$fetchSettings$1.label & Integer.MIN_VALUE) != 0) {
                settingsRepository$fetchSettings$1.label -= Integer.MIN_VALUE;
            } else {
                settingsRepository$fetchSettings$1 = new SettingsRepository$fetchSettings$1(this, continuation);
            }
        } else {
            settingsRepository$fetchSettings$1 = new SettingsRepository$fetchSettings$1(this, continuation);
        }
        Object settings = settingsRepository$fetchSettings$1.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = settingsRepository$fetchSettings$1.label;
        try {
            if (i == 0) {
                ResultKt.throwOnFailure(settings);
                SettingsRestClient settingsRestClient = this.settingsRestClient;
                settingsRepository$fetchSettings$1.label = 1;
                settings = settingsRestClient.getSettings(settingsRepository$fetchSettings$1);
                if (settings == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(settings);
            }
            return new ZendeskResult.Success(settings);
        } catch (SerializationException e) {
            SerializationException serializationException = e;
            Logger.m218e(Zendesk.LOG_TAG, "GET request for Settings failed to decode malformed JSON response.", serializationException, new Object[0]);
            return new ZendeskResult.Failure(new ZendeskError.FailedToInitialize(serializationException));
        } catch (Throwable th) {
            Logger.m218e(Zendesk.LOG_TAG, "Zendesk failed to initialize.", th, new Object[0]);
            if ((th instanceof HttpException) && th.code() == 404) {
                failure = new ZendeskResult.Failure(ZendeskError.AccountNotFound.INSTANCE);
            } else {
                failure = new ZendeskResult.Failure(new ZendeskError.FailedToInitialize(th));
            }
            return failure;
        }
    }
}
