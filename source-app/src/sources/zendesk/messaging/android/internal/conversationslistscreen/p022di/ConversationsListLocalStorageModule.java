package zendesk.messaging.android.internal.conversationslistscreen.p022di;

import android.content.Context;
import dagger.Binds;
import dagger.Module;
import dagger.Provides;
import javax.inject.Named;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.messaging.android.internal.conversationslistscreen.conversation.cache.ConversationsListLocalStorageIO;
import zendesk.messaging.android.internal.conversationslistscreen.conversation.cache.ConversationsListLocalStorageIOImpl;
import zendesk.messaging.android.internal.conversationslistscreen.conversation.cache.ConversationsListLocalStorageIOKt;
import zendesk.messaging.android.internal.conversationslistscreen.conversation.cache.ConversationsListLocalStorageSerializer;
import zendesk.storage.android.Storage;
import zendesk.storage.android.StorageFactory;
import zendesk.storage.android.StorageType;

@Metadata(m17d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0001\u0018\u00002\u00020\u0001:\u0001\u000eB\u0005¢\u0006\u0002\u0010\u0002J\"\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\b\b\u0001\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\nH\u0007J\u0010\u0010\u000b\u001a\u00020\b2\u0006\u0010\f\u001a\u00020\rH\u0007¨\u0006\u000f"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/di/ConversationsListLocalStorageModule;", "", "()V", "providesConversationsListStorage", "Lzendesk/storage/android/Storage;", "context", "Landroid/content/Context;", "storageType", "Lzendesk/storage/android/StorageType;", "messagingSettings", "Lzendesk/android/messaging/model/MessagingSettings;", "providesConversationsListStorageType", "conversationsListLocalStorageSerializer", "Lzendesk/messaging/android/internal/conversationslistscreen/conversation/cache/ConversationsListLocalStorageSerializer;", "BindsModule", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Module(includes = {BindsModule.class})
public final class ConversationsListLocalStorageModule {

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\bg\u0018\u00002\u00020\u0001J\u0010\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u0005H'¨\u0006\u0006"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/di/ConversationsListLocalStorageModule$BindsModule;", "", "providesConversationsListLocalStorage", "Lzendesk/messaging/android/internal/conversationslistscreen/conversation/cache/ConversationsListLocalStorageIO;", "conversationsListLocalStorageIOImpl", "Lzendesk/messaging/android/internal/conversationslistscreen/conversation/cache/ConversationsListLocalStorageIOImpl;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    @Module
    public interface BindsModule {
        @ConversationListActivityScope
        @Binds
        ConversationsListLocalStorageIO providesConversationsListLocalStorage(ConversationsListLocalStorageIOImpl conversationsListLocalStorageIOImpl);
    }

    @Provides
    @ConversationListActivityScope
    @Named(ConversationsListLocalStorageIOKt.MULTICONVO_LOCAL_STORAGE_TYPE)
    public final StorageType providesConversationsListStorageType(ConversationsListLocalStorageSerializer conversationsListLocalStorageSerializer) {
        Intrinsics.checkNotNullParameter(conversationsListLocalStorageSerializer, "conversationsListLocalStorageSerializer");
        return new StorageType.Complex(conversationsListLocalStorageSerializer);
    }

    @Provides
    @ConversationListActivityScope
    @Named(ConversationsListLocalStorageIOKt.MULTICONVO_LOCAL_STORAGE)
    public final Storage providesConversationsListStorage(Context context, @Named(ConversationsListLocalStorageIOKt.MULTICONVO_LOCAL_STORAGE_TYPE) StorageType storageType, MessagingSettings messagingSettings) {
        Intrinsics.checkNotNullParameter(context, "context");
        Intrinsics.checkNotNullParameter(storageType, "storageType");
        Intrinsics.checkNotNullParameter(messagingSettings, "messagingSettings");
        return StorageFactory.INSTANCE.create(ConversationsListLocalStorageIOKt.MULTICONVO_NAMESPACE, context, storageType, messagingSettings.getIntegrationId());
    }
}
