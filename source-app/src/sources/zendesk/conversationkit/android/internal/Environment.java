package zendesk.conversationkit.android.internal;

import android.content.Context;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.serialization.json.Json;
import zendesk.conversationkit.android.ConversationKitSettings;
import zendesk.conversationkit.android.internal.rest.RestClientFactory;
import zendesk.conversationkit.android.model.Config;
import zendesk.storage.android.Serializer;

@Metadata(m17d1 = {"\u0000V\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\b`\u0018\u0000 $2\u00020\u0001:\u0001$J\b\u0010\u001e\u001a\u00020\u001fH&J\b\u0010 \u001a\u00020!H&J\b\u0010\"\u001a\u00020#H&R\u0012\u0010\u0002\u001a\u00020\u0003X¦\u0004¢\u0006\u0006\u001a\u0004\b\u0004\u0010\u0005R\u0012\u0010\u0006\u001a\u00020\u0007X¦\u0004¢\u0006\u0006\u001a\u0004\b\b\u0010\tR\u0012\u0010\n\u001a\u00020\u000bX¦\u0004¢\u0006\u0006\u001a\u0004\b\f\u0010\rR\u0012\u0010\u000e\u001a\u00020\u000fX¦\u0004¢\u0006\u0006\u001a\u0004\b\u0010\u0010\u0011R\u0012\u0010\u0012\u001a\u00020\u0013X¦\u0004¢\u0006\u0006\u001a\u0004\b\u0014\u0010\u0015R\u0012\u0010\u0016\u001a\u00020\u0017X¦\u0004¢\u0006\u0006\u001a\u0004\b\u0018\u0010\u0019R\u0012\u0010\u001a\u001a\u00020\u001bX¦\u0004¢\u0006\u0006\u001a\u0004\b\u001c\u0010\u001d¨\u0006%"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Environment;", "", "clientDtoProvider", "Lzendesk/conversationkit/android/internal/ClientDtoProvider;", "getClientDtoProvider", "()Lzendesk/conversationkit/android/internal/ClientDtoProvider;", "hostAppInfo", "Lzendesk/conversationkit/android/internal/HostAppInfo;", "getHostAppInfo", "()Lzendesk/conversationkit/android/internal/HostAppInfo;", "json", "Lkotlinx/serialization/json/Json;", "getJson", "()Lkotlinx/serialization/json/Json;", "restClientFactory", "Lzendesk/conversationkit/android/internal/rest/RestClientFactory;", "getRestClientFactory", "()Lzendesk/conversationkit/android/internal/rest/RestClientFactory;", "sdkVersion", "", "getSdkVersion", "()Ljava/lang/String;", "serializer", "Lzendesk/storage/android/Serializer;", "getSerializer", "()Lzendesk/storage/android/Serializer;", "storageFactory", "Lzendesk/conversationkit/android/internal/StorageFactory;", "getStorageFactory", "()Lzendesk/conversationkit/android/internal/StorageFactory;", "createConnectivityObserver", "Lzendesk/conversationkit/android/internal/ConnectivityObserver;", "createConversationKitStore", "Lzendesk/conversationkit/android/internal/ConversationKitStore;", "createCoroutineScope", "Lkotlinx/coroutines/CoroutineScope;", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public interface Environment {

    public static final Companion INSTANCE = Companion.$$INSTANCE;

    ConnectivityObserver createConnectivityObserver();

    ConversationKitStore createConversationKitStore();

    CoroutineScope createCoroutineScope();

    ClientDtoProvider getClientDtoProvider();

    HostAppInfo getHostAppInfo();

    Json getJson();

    RestClientFactory getRestClientFactory();

    String getSdkVersion();

    Serializer getSerializer();

    StorageFactory getStorageFactory();

    @Metadata(m17d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u001e\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\n¨\u0006\u000b"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Environment$Companion;", "", "()V", "main", "Lzendesk/conversationkit/android/internal/Environment;", "context", "Landroid/content/Context;", "config", "Lzendesk/conversationkit/android/model/Config;", "settings", "Lzendesk/conversationkit/android/ConversationKitSettings;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        static final Companion $$INSTANCE = new Companion();

        private Companion() {
        }

        public final Environment main(Context context, Config config, ConversationKitSettings settings) {
            Intrinsics.checkNotNullParameter(context, "context");
            Intrinsics.checkNotNullParameter(config, "config");
            Intrinsics.checkNotNullParameter(settings, "settings");
            return new MainEnvironment(context, config, settings, null, 8, null);
        }
    }
}
