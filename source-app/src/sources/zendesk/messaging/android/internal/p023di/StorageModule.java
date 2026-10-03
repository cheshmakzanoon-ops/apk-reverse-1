package zendesk.messaging.android.internal.p023di;

import android.content.Context;
import dagger.Module;
import dagger.Provides;
import javax.inject.Named;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.messaging.android.internal.DefaultMessaging;
import zendesk.messaging.android.internal.conversationscreen.cache.MessagingStorageSerializer;
import zendesk.storage.android.Storage;
import zendesk.storage.android.StorageFactory;
import zendesk.storage.android.StorageType;

@Metadata(m17d1 = {"\u00004\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0001\u0018\u0000 \u00112\u00020\u0001:\u0001\u0011B\u0005¢\u0006\u0002\u0010\u0002J\u0012\u0010\u0003\u001a\u0004\u0018\u00010\u00042\u0006\u0010\u0005\u001a\u00020\u0006H\u0007J$\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\f2\n\b\u0001\u0010\r\u001a\u0004\u0018\u00010\u0004H\u0007J\u0010\u0010\u000e\u001a\u00020\f2\u0006\u0010\u000f\u001a\u00020\u0010H\u0007¨\u0006\u0012"}, m18d2 = {"Lzendesk/messaging/android/internal/di/StorageModule;", "", "()V", "providesIdentifier", "", "messagingSettings", "Lzendesk/android/messaging/model/MessagingSettings;", "providesStorage", "Lzendesk/storage/android/Storage;", "context", "Landroid/content/Context;", "storageType", "Lzendesk/storage/android/StorageType;", "identifier", "providesStorageType", "messagingStorageSerializer", "Lzendesk/messaging/android/internal/conversationscreen/cache/MessagingStorageSerializer;", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Module
public final class StorageModule {
    private static final String STORAGE_IDENTIFIER = "STORAGE_IDENTIFIER";

    @Provides
    @MessagingScope
    public final StorageType providesStorageType(MessagingStorageSerializer messagingStorageSerializer) {
        Intrinsics.checkNotNullParameter(messagingStorageSerializer, "messagingStorageSerializer");
        return new StorageType.Complex(messagingStorageSerializer);
    }

    @Provides
    @MessagingScope
    @Named(STORAGE_IDENTIFIER)
    public final String providesIdentifier(MessagingSettings messagingSettings) {
        Intrinsics.checkNotNullParameter(messagingSettings, "messagingSettings");
        return messagingSettings.getIntegrationId();
    }

    @Provides
    @MessagingScope
    public final Storage providesStorage(Context context, StorageType storageType, @Named(STORAGE_IDENTIFIER) String identifier) {
        Intrinsics.checkNotNullParameter(context, "context");
        Intrinsics.checkNotNullParameter(storageType, "storageType");
        return StorageFactory.INSTANCE.create(DefaultMessaging.MESSAGING_NAMESPACE, context, storageType, identifier);
    }
}
