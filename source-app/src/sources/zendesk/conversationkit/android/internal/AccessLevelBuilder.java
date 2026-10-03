package zendesk.conversationkit.android.internal;

import android.content.Context;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.serialization.json.Json;
import zendesk.conversationkit.android.ConversationKitSettings;
import zendesk.conversationkit.android.internal.app.AppActionProcessor;
import zendesk.conversationkit.android.internal.attachments.AttachmentDownloader;
import zendesk.conversationkit.android.internal.attachments.AttachmentsDownloadReceiver;
import zendesk.conversationkit.android.internal.faye.SunCoFayeClient;
import zendesk.conversationkit.android.internal.faye.SunCoFayeClientFactory;
import zendesk.conversationkit.android.internal.metadata.MetadataManager;
import zendesk.conversationkit.android.internal.rest.RestClientFactory;
import zendesk.conversationkit.android.internal.rest.RestClientFiles;
import zendesk.conversationkit.android.internal.user.AuthenticationErrorHandler;
import zendesk.conversationkit.android.internal.user.UserActionProcessor;
import zendesk.conversationkit.android.internal.user.data.UserActionProcessorInMemoryDataSource;
import zendesk.conversationkit.android.internal.user.data.UserActionProcessorLocalDataSource;
import zendesk.conversationkit.android.internal.user.data.UserActionProcessorRemoteDataSource;
import zendesk.conversationkit.android.internal.user.data.UserActionProcessorRepository;
import zendesk.conversationkit.android.model.Config;
import zendesk.conversationkit.android.model.User;

@Metadata(m17d1 = {"\u0000j\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0000\u0018\u00002\u00020\u0001Bm\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\t\u0012\u0006\u0010\n\u001a\u00020\u000b\u0012\u0006\u0010\f\u001a\u00020\r\u0012\u0006\u0010\u000e\u001a\u00020\u000f\u0012\u0006\u0010\u0010\u001a\u00020\u0011\u0012\u0006\u0010\u0012\u001a\u00020\u0013\u0012\u0006\u0010\u0014\u001a\u00020\u0015\u0012\u0006\u0010\u0016\u001a\u00020\u0017\u0012\u0006\u0010\u0018\u001a\u00020\u0019\u0012\u0006\u0010\u001a\u001a\u00020\u001b¢\u0006\u0002\u0010\u001cJ\u0006\u0010\u001d\u001a\u00020\u001eJ\u0016\u0010\u001f\u001a\u00020\u001e2\u0006\u0010 \u001a\u00020!H\u0086@¢\u0006\u0002\u0010\"R\u000e\u0010\u0010\u001a\u00020\u0011X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0012\u001a\u00020\u0013X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\tX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0018\u001a\u00020\u0019X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\f\u001a\u00020\rX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0014\u001a\u00020\u0015X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0016\u001a\u00020\u0017X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u001a\u001a\u00020\u001bX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000e\u001a\u00020\u000fX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\n\u001a\u00020\u000bX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006#"}, m18d2 = {"Lzendesk/conversationkit/android/internal/AccessLevelBuilder;", "", "restClientFactory", "Lzendesk/conversationkit/android/internal/rest/RestClientFactory;", "sunCoFayeClientFactory", "Lzendesk/conversationkit/android/internal/faye/SunCoFayeClientFactory;", "storageFactory", "Lzendesk/conversationkit/android/internal/StorageFactory;", "clientDtoProvider", "Lzendesk/conversationkit/android/internal/ClientDtoProvider;", "restClientFiles", "Lzendesk/conversationkit/android/internal/rest/RestClientFiles;", "connectivityObserver", "Lzendesk/conversationkit/android/internal/ConnectivityObserver;", "metadataManager", "Lzendesk/conversationkit/android/internal/metadata/MetadataManager;", "attachmentDownloader", "Lzendesk/conversationkit/android/internal/attachments/AttachmentDownloader;", "attachmentsDownloadReceiver", "Lzendesk/conversationkit/android/internal/attachments/AttachmentsDownloadReceiver;", "context", "Landroid/content/Context;", "conversationKitSettings", "Lzendesk/conversationkit/android/ConversationKitSettings;", "config", "Lzendesk/conversationkit/android/model/Config;", "json", "Lkotlinx/serialization/json/Json;", "(Lzendesk/conversationkit/android/internal/rest/RestClientFactory;Lzendesk/conversationkit/android/internal/faye/SunCoFayeClientFactory;Lzendesk/conversationkit/android/internal/StorageFactory;Lzendesk/conversationkit/android/internal/ClientDtoProvider;Lzendesk/conversationkit/android/internal/rest/RestClientFiles;Lzendesk/conversationkit/android/internal/ConnectivityObserver;Lzendesk/conversationkit/android/internal/metadata/MetadataManager;Lzendesk/conversationkit/android/internal/attachments/AttachmentDownloader;Lzendesk/conversationkit/android/internal/attachments/AttachmentsDownloadReceiver;Landroid/content/Context;Lzendesk/conversationkit/android/ConversationKitSettings;Lzendesk/conversationkit/android/model/Config;Lkotlinx/serialization/json/Json;)V", "buildAppAccess", "Lzendesk/conversationkit/android/internal/AccessLevel;", "buildUserAccess", "user", "Lzendesk/conversationkit/android/model/User;", "(Lzendesk/conversationkit/android/model/User;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class AccessLevelBuilder {
    private final AttachmentDownloader attachmentDownloader;
    private final AttachmentsDownloadReceiver attachmentsDownloadReceiver;
    private final ClientDtoProvider clientDtoProvider;
    private final Config config;
    private final ConnectivityObserver connectivityObserver;
    private final Context context;
    private final ConversationKitSettings conversationKitSettings;
    private final Json json;
    private final MetadataManager metadataManager;
    private final RestClientFactory restClientFactory;
    private final RestClientFiles restClientFiles;
    private final StorageFactory storageFactory;
    private final SunCoFayeClientFactory sunCoFayeClientFactory;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.AccessLevelBuilder", m37f = "AccessLevelBuilder.kt", m38i = {0, 0, 0, 0, 0}, m39l = {115}, m40m = "buildUserAccess", m41n = {"this", "conversationKitStorage", "sunCoFayeClient", "userActionProcessorInMemoryDataSource", "userActionProcessorLocalDataSource"}, m42s = {"L$0", "L$1", "L$2", "L$3", "L$4"})
    static final class C09961 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        Object L$4;
        Object L$5;
        Object L$6;
        Object L$7;
        Object L$8;
        Object L$9;
        int label;
        Object result;

        C09961(Continuation<? super C09961> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return AccessLevelBuilder.this.buildUserAccess(null, this);
        }
    }

    public AccessLevelBuilder(RestClientFactory restClientFactory, SunCoFayeClientFactory sunCoFayeClientFactory, StorageFactory storageFactory, ClientDtoProvider clientDtoProvider, RestClientFiles restClientFiles, ConnectivityObserver connectivityObserver, MetadataManager metadataManager, AttachmentDownloader attachmentDownloader, AttachmentsDownloadReceiver attachmentsDownloadReceiver, Context context, ConversationKitSettings conversationKitSettings, Config config, Json json) {
        Intrinsics.checkNotNullParameter(restClientFactory, "restClientFactory");
        Intrinsics.checkNotNullParameter(sunCoFayeClientFactory, "sunCoFayeClientFactory");
        Intrinsics.checkNotNullParameter(storageFactory, "storageFactory");
        Intrinsics.checkNotNullParameter(clientDtoProvider, "clientDtoProvider");
        Intrinsics.checkNotNullParameter(restClientFiles, "restClientFiles");
        Intrinsics.checkNotNullParameter(connectivityObserver, "connectivityObserver");
        Intrinsics.checkNotNullParameter(metadataManager, "metadataManager");
        Intrinsics.checkNotNullParameter(attachmentDownloader, "attachmentDownloader");
        Intrinsics.checkNotNullParameter(attachmentsDownloadReceiver, "attachmentsDownloadReceiver");
        Intrinsics.checkNotNullParameter(context, "context");
        Intrinsics.checkNotNullParameter(conversationKitSettings, "conversationKitSettings");
        Intrinsics.checkNotNullParameter(config, "config");
        Intrinsics.checkNotNullParameter(json, "json");
        this.restClientFactory = restClientFactory;
        this.sunCoFayeClientFactory = sunCoFayeClientFactory;
        this.storageFactory = storageFactory;
        this.clientDtoProvider = clientDtoProvider;
        this.restClientFiles = restClientFiles;
        this.connectivityObserver = connectivityObserver;
        this.metadataManager = metadataManager;
        this.attachmentDownloader = attachmentDownloader;
        this.attachmentsDownloadReceiver = attachmentsDownloadReceiver;
        this.context = context;
        this.conversationKitSettings = conversationKitSettings;
        this.config = config;
        this.json = json;
    }

    public final AccessLevel buildAppAccess() {
        this.attachmentsDownloadReceiver.m212xa9906493(this.context);
        ConversationKitStorage conversationKitStorageCreateConversationKitStorage = this.storageFactory.createConversationKitStorage();
        ConversationKitSettings conversationKitSettings = this.conversationKitSettings;
        Config config = this.config;
        return new AppAccess(new AppActionProcessor(conversationKitSettings, config, this.restClientFactory.createAppRestClient(config.getApp().getId(), this.config.getBaseUrl()), this.clientDtoProvider, this.storageFactory.createAppStorage(this.config.getApp().getId()), conversationKitStorageCreateConversationKitStorage, this.storageFactory.createProactiveMessagingStorage(), this.metadataManager, null, 256, null), conversationKitStorageCreateConversationKitStorage);
    }

    public final Object buildUserAccess(User user, Continuation<? super AccessLevel> continuation) {
        C09961 c09961;
        ConversationKitStorage conversationKitStorage;
        SunCoFayeClient sunCoFayeClient;
        String str;
        RestClientFactory restClientFactory;
        String str2;
        String str3;
        String str4;
        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource;
        UserActionProcessorLocalDataSource userActionProcessorLocalDataSource;
        AccessLevelBuilder accessLevelBuilder;
        if (continuation instanceof C09961) {
            c09961 = (C09961) continuation;
            if ((c09961.label & Integer.MIN_VALUE) != 0) {
                c09961.label -= Integer.MIN_VALUE;
            } else {
                c09961 = new C09961(continuation);
            }
        } else {
            c09961 = new C09961(continuation);
        }
        Object obj = c09961.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c09961.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            this.attachmentsDownloadReceiver.m211xe53b14cc(this.context);
            ConversationKitStorage conversationKitStorageCreateConversationKitStorage = this.storageFactory.createConversationKitStorage();
            SunCoFayeClient sunCoFayeClientCreate = this.sunCoFayeClientFactory.create(user.getRealtimeSettings(), user.getAuthenticationType(), this.json);
            UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource2 = new UserActionProcessorInMemoryDataSource(user, null, 2, 0 == true ? 1 : 0);
            UserActionProcessorLocalDataSource userActionProcessorLocalDataSource2 = new UserActionProcessorLocalDataSource(this.storageFactory.createUserStorage(user.getId()), this.storageFactory.createAppStorage(this.config.getApp().getId()), conversationKitStorageCreateConversationKitStorage, this.storageFactory.createProactiveMessagingStorage(), this.restClientFiles);
            RestClientFactory restClientFactory2 = this.restClientFactory;
            String id = this.config.getApp().getId();
            String id2 = user.getId();
            String baseUrl = this.config.getBaseUrl();
            String settingsBaseUrl = this.config.getSettingsBaseUrl();
            c09961.L$0 = this;
            c09961.L$1 = conversationKitStorageCreateConversationKitStorage;
            c09961.L$2 = sunCoFayeClientCreate;
            c09961.L$3 = userActionProcessorInMemoryDataSource2;
            c09961.L$4 = userActionProcessorLocalDataSource2;
            c09961.L$5 = restClientFactory2;
            c09961.L$6 = id;
            c09961.L$7 = id2;
            c09961.L$8 = baseUrl;
            c09961.L$9 = settingsBaseUrl;
            c09961.label = 1;
            Object clientId = conversationKitStorageCreateConversationKitStorage.getClientId(c09961);
            if (clientId == coroutine_suspended) {
                return coroutine_suspended;
            }
            conversationKitStorage = conversationKitStorageCreateConversationKitStorage;
            obj = clientId;
            sunCoFayeClient = sunCoFayeClientCreate;
            str = id;
            restClientFactory = restClientFactory2;
            str2 = id2;
            str3 = baseUrl;
            str4 = settingsBaseUrl;
            userActionProcessorInMemoryDataSource = userActionProcessorInMemoryDataSource2;
            userActionProcessorLocalDataSource = userActionProcessorLocalDataSource2;
            accessLevelBuilder = this;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            String str5 = (String) c09961.L$9;
            String str6 = (String) c09961.L$8;
            str2 = (String) c09961.L$7;
            String str7 = (String) c09961.L$6;
            RestClientFactory restClientFactory3 = (RestClientFactory) c09961.L$5;
            UserActionProcessorLocalDataSource userActionProcessorLocalDataSource3 = (UserActionProcessorLocalDataSource) c09961.L$4;
            userActionProcessorInMemoryDataSource = (UserActionProcessorInMemoryDataSource) c09961.L$3;
            SunCoFayeClient sunCoFayeClient2 = (SunCoFayeClient) c09961.L$2;
            ConversationKitStorage conversationKitStorage2 = (ConversationKitStorage) c09961.L$1;
            accessLevelBuilder = (AccessLevelBuilder) c09961.L$0;
            ResultKt.throwOnFailure(obj);
            sunCoFayeClient = sunCoFayeClient2;
            conversationKitStorage = conversationKitStorage2;
            userActionProcessorLocalDataSource = userActionProcessorLocalDataSource3;
            str4 = str5;
            restClientFactory = restClientFactory3;
            str3 = str6;
            str = str7;
        }
        ConversationKitStorage conversationKitStorage3 = conversationKitStorage;
        UserActionProcessorRepository userActionProcessorRepository = new UserActionProcessorRepository(userActionProcessorInMemoryDataSource, userActionProcessorLocalDataSource, new UserActionProcessorRemoteDataSource(accessLevelBuilder.conversationKitSettings, accessLevelBuilder.config, sunCoFayeClient, restClientFactory.createUserRestClient(str, str2, str3, str4, (String) obj), accessLevelBuilder.clientDtoProvider, null, 32, null), accessLevelBuilder.config, accessLevelBuilder.connectivityObserver);
        SunCoFayeClient sunCoFayeClient3 = sunCoFayeClient;
        return new UserAccess(new UserActionProcessor(userActionProcessorRepository, sunCoFayeClient3, accessLevelBuilder.metadataManager, accessLevelBuilder.attachmentDownloader, new AuthenticationErrorHandler(userActionProcessorRepository, sunCoFayeClient3, null, 4, null), null, accessLevelBuilder.connectivityObserver, 32, null), conversationKitStorage3);
    }
}
