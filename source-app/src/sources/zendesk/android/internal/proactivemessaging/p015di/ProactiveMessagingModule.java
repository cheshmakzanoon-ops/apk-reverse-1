package zendesk.android.internal.proactivemessaging.p015di;

import android.content.Context;
import dagger.Module;
import dagger.Provides;
import javax.inject.Named;
import kotlin.Metadata;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.Intrinsics;
import retrofit2.Retrofit;
import zendesk.android.internal.p013di.ZendeskInitializedComponentScope;
import zendesk.android.internal.proactivemessaging.ProactiveMessagingService;
import zendesk.android.internal.storage.ZendeskStorageSerializer;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.storage.android.Storage;
import zendesk.storage.android.StorageFactory;
import zendesk.storage.android.StorageType;

@Metadata(m17d1 = {"\u00006\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\t\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0001\u0018\u0000 \u00102\u00020\u0001:\u0001\u0010B\u0005¢\u0006\u0002\u0010\u0002J\u0010\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u0006H\u0007J\u000e\u0010\u0007\u001a\b\u0012\u0004\u0012\u00020\t0\bH\u0007J\u0018\u0010\n\u001a\u00020\u000b2\u0006\u0010\f\u001a\u00020\r2\u0006\u0010\u000e\u001a\u00020\u000fH\u0007¨\u0006\u0011"}, m18d2 = {"Lzendesk/android/internal/proactivemessaging/di/ProactiveMessagingModule;", "", "()V", "providesCampaignTriggerService", "Lzendesk/android/internal/proactivemessaging/ProactiveMessagingService;", "retrofit", "Lretrofit2/Retrofit;", "providesCurrentTimeProvider", "Lkotlin/Function0;", "", "providesProactiveMessagingStorage", "Lzendesk/storage/android/Storage;", "context", "Landroid/content/Context;", "messagingSettings", "Lzendesk/android/messaging/model/MessagingSettings;", "Companion", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Module
public final class ProactiveMessagingModule {
    public static final String CURRENT_TIME_PROVIDER = "CURRENT_TIME_PROVIDER";
    public static final String PROACTIVE_MESSAGING_STORAGE = "PROACTIVE_MESSAGING_STORAGE";
    private static final String proactiveMessagingStorageNamespace = "zendesk.android.internal.proactivemessaging";

    @Provides
    @ZendeskInitializedComponentScope
    @Named(PROACTIVE_MESSAGING_STORAGE)
    public final Storage providesProactiveMessagingStorage(Context context, MessagingSettings messagingSettings) {
        Intrinsics.checkNotNullParameter(context, "context");
        Intrinsics.checkNotNullParameter(messagingSettings, "messagingSettings");
        return StorageFactory.INSTANCE.create(proactiveMessagingStorageNamespace, context, new StorageType.Complex(new ZendeskStorageSerializer(null, 1, 0 == true ? 1 : 0)), messagingSettings.getIntegrationId());
    }

    @Provides
    @ZendeskInitializedComponentScope
    public final ProactiveMessagingService providesCampaignTriggerService(Retrofit retrofit) {
        Intrinsics.checkNotNullParameter(retrofit, "retrofit");
        Object objCreate = retrofit.create(ProactiveMessagingService.class);
        Intrinsics.checkNotNullExpressionValue(objCreate, "create(...)");
        return (ProactiveMessagingService) objCreate;
    }

    @Provides
    @ZendeskInitializedComponentScope
    @Named(CURRENT_TIME_PROVIDER)
    public final Function0<Long> providesCurrentTimeProvider() {
        return new Function0<Long>() {
            @Override
            public final Long invoke() {
                return Long.valueOf(System.currentTimeMillis());
            }
        };
    }
}
