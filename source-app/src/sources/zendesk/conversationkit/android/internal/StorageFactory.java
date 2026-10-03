package zendesk.conversationkit.android.internal;

import android.content.Context;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.serialization.json.Json;
import zendesk.conversationkit.android.internal.app.AppStorage;
import zendesk.conversationkit.android.internal.metadata.MetadataStorage;
import zendesk.conversationkit.android.internal.proactivemessaging.ProactiveMessagingStorage;
import zendesk.conversationkit.android.internal.user.UserStorage;
import zendesk.storage.android.Serializer;
import zendesk.storage.android.StorageType;

@Metadata(m17d1 = {"\u0000F\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0000\u0018\u0000 \u00172\u00020\u0001:\u0001\u0017B%\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\t¢\u0006\u0002\u0010\nJ\u000e\u0010\u000b\u001a\u00020\f2\u0006\u0010\r\u001a\u00020\u0007J\u0006\u0010\u000e\u001a\u00020\u000fJ\u000e\u0010\u0010\u001a\u00020\u00112\u0006\u0010\r\u001a\u00020\u0007J\u0006\u0010\u0012\u001a\u00020\u0013J\u000e\u0010\u0014\u001a\u00020\u00152\u0006\u0010\u0016\u001a\u00020\u0007R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\tX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0018"}, m18d2 = {"Lzendesk/conversationkit/android/internal/StorageFactory;", "", "context", "Landroid/content/Context;", "serializer", "Lzendesk/storage/android/Serializer;", "integrationId", "", "json", "Lkotlinx/serialization/json/Json;", "(Landroid/content/Context;Lzendesk/storage/android/Serializer;Ljava/lang/String;Lkotlinx/serialization/json/Json;)V", "createAppStorage", "Lzendesk/conversationkit/android/internal/app/AppStorage;", "appId", "createConversationKitStorage", "Lzendesk/conversationkit/android/internal/ConversationKitStorage;", "createMetadataStorage", "Lzendesk/conversationkit/android/internal/metadata/MetadataStorage;", "createProactiveMessagingStorage", "Lzendesk/conversationkit/android/internal/proactivemessaging/ProactiveMessagingStorage;", "createUserStorage", "Lzendesk/conversationkit/android/internal/user/UserStorage;", "userId", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class StorageFactory {
    private static final Companion Companion = new Companion(null);

    @Deprecated
    public static final String PROACTIVE_MESSAGING_STORAGE_NAMESPACE = "zendesk.conversationkit.proactivemessaging";
    private final Context context;
    private final String integrationId;
    private final Json json;
    private final Serializer serializer;

    public StorageFactory(Context context, Serializer serializer, String integrationId, Json json) {
        Intrinsics.checkNotNullParameter(context, "context");
        Intrinsics.checkNotNullParameter(serializer, "serializer");
        Intrinsics.checkNotNullParameter(integrationId, "integrationId");
        Intrinsics.checkNotNullParameter(json, "json");
        this.context = context;
        this.serializer = serializer;
        this.integrationId = integrationId;
        this.json = json;
    }

    public final ConversationKitStorage createConversationKitStorage() {
        return new ConversationKitStorage(zendesk.storage.android.StorageFactory.INSTANCE.create("zendesk.conversationkit", this.context, StorageType.Basic.INSTANCE, this.integrationId));
    }

    public final AppStorage createAppStorage(String appId) {
        Intrinsics.checkNotNullParameter(appId, "appId");
        return new AppStorage(zendesk.storage.android.StorageFactory.INSTANCE.create("zendesk.conversationkit.app." + appId, this.context, new StorageType.Complex(this.serializer), this.integrationId));
    }

    public final UserStorage createUserStorage(String userId) {
        Intrinsics.checkNotNullParameter(userId, "userId");
        return new UserStorage(zendesk.storage.android.StorageFactory.INSTANCE.create("zendesk.conversationkit.user." + userId, this.context, new StorageType.Complex(this.serializer), this.integrationId));
    }

    public final ProactiveMessagingStorage createProactiveMessagingStorage() {
        return new ProactiveMessagingStorage(zendesk.storage.android.StorageFactory.INSTANCE.create(PROACTIVE_MESSAGING_STORAGE_NAMESPACE, this.context, new StorageType.Complex(this.serializer), this.integrationId));
    }

    public final MetadataStorage createMetadataStorage(String appId) {
        Intrinsics.checkNotNullParameter(appId, "appId");
        return new MetadataStorage(zendesk.storage.android.StorageFactory.INSTANCE.create("zendesk.conversationkit.app." + appId + ".metadata", this.context, new StorageType.Complex(this.serializer), this.integrationId), this.json);
    }

    @Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000¨\u0006\u0005"}, m18d2 = {"Lzendesk/conversationkit/android/internal/StorageFactory$Companion;", "", "()V", "PROACTIVE_MESSAGING_STORAGE_NAMESPACE", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
