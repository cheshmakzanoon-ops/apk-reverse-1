package zendesk.messaging.android.internal.conversationslistscreen.conversation.cache;

import android.content.Context;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.CoroutineDispatcher;
import kotlinx.coroutines.Dispatchers;
import kotlinx.serialization.json.Json;
import zendesk.storage.android.StorageFactory;
import zendesk.storage.android.StorageType;

@Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\b\u0000\u0018\u00002\u00020\u0001B)\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\u0006\u0010\b\u001a\u00020\t¢\u0006\u0002\u0010\nJ\u0006\u0010\u000b\u001a\u00020\fR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\u0006\u001a\u0004\u0018\u00010\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\tX\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\r"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/conversation/cache/ConversationsListStorageBuilder;", "", "context", "Landroid/content/Context;", "dispatcher", "Lkotlinx/coroutines/CoroutineDispatcher;", "integrationId", "", "json", "Lkotlinx/serialization/json/Json;", "(Landroid/content/Context;Lkotlinx/coroutines/CoroutineDispatcher;Ljava/lang/String;Lkotlinx/serialization/json/Json;)V", "build", "Lzendesk/messaging/android/internal/conversationslistscreen/conversation/cache/ConversationsListLocalStorageCleaner;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationsListStorageBuilder {
    private final Context context;
    private final CoroutineDispatcher dispatcher;
    private final String integrationId;
    private final Json json;

    public ConversationsListStorageBuilder(Context context, CoroutineDispatcher dispatcher, String str, Json json) {
        Intrinsics.checkNotNullParameter(context, "context");
        Intrinsics.checkNotNullParameter(dispatcher, "dispatcher");
        Intrinsics.checkNotNullParameter(json, "json");
        this.context = context;
        this.dispatcher = dispatcher;
        this.integrationId = str;
        this.json = json;
    }

    public ConversationsListStorageBuilder(Context context, CoroutineDispatcher coroutineDispatcher, String str, Json json, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(context, (i & 2) != 0 ? Dispatchers.getIO() : coroutineDispatcher, str, json);
    }

    public final ConversationsListLocalStorageCleaner build() {
        return new ConversationsListLocalStorageCleanerImpl(this.dispatcher, StorageFactory.INSTANCE.create(ConversationsListLocalStorageIOKt.MULTICONVO_NAMESPACE, this.context, new StorageType.Complex(new ConversationsListLocalStorageSerializer(this.json)), this.integrationId));
    }
}
