package zendesk.conversationkit.android.internal;

import android.content.Context;
import android.net.ConnectivityManager;
import androidx.core.content.ContextCompat;
import java.io.File;
import kotlin.Lazy;
import kotlin.LazyKt;
import kotlin.Metadata;
import kotlin.Pair;
import kotlin.TuplesKt;
import kotlin.collections.SetsKt;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.CoroutineScopeKt;
import kotlinx.coroutines.Job;
import kotlinx.coroutines.SupervisorKt;
import kotlinx.serialization.json.Json;
import okhttp3.MediaType;
import retrofit2.converter.kotlinx.serialization.KotlinSerializationConverterFactory;
import zendesk.conversationkit.android.BuildConfig;
import zendesk.conversationkit.android.ConversationKitSettings;
import zendesk.conversationkit.android.internal.app.AppActionProcessor;
import zendesk.conversationkit.android.internal.attachments.AttachmentDownloader;
import zendesk.conversationkit.android.internal.attachments.AttachmentsDownloadReceiver;
import zendesk.conversationkit.android.internal.faye.SunCoFayeClientFactory;
import zendesk.conversationkit.android.internal.metadata.MetadataFormatter;
import zendesk.conversationkit.android.internal.metadata.MetadataManager;
import zendesk.conversationkit.android.internal.rest.DefaultRestClientFiles;
import zendesk.conversationkit.android.internal.rest.RestClientFactory;
import zendesk.conversationkit.android.internal.serialization.SerializationProvider;
import zendesk.conversationkit.android.model.Config;
import zendesk.core.p017ui.android.internal.local.LocaleProvider;
import zendesk.storage.android.Serializer;

@Metadata(m17d1 = {"\u0000 \u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\b\u0000\u0018\u00002\u00020\u0001B'\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t¢\u0006\u0002\u0010\nJ\b\u00104\u001a\u000205H\u0002J\u0010\u00106\u001a\u0002072\u0006\u00108\u001a\u000209H\u0002J\b\u0010:\u001a\u00020;H\u0016J\b\u0010<\u001a\u00020=H\u0016J\b\u0010>\u001a\u00020?H\u0016J\b\u0010@\u001a\u00020AH\u0002R\u000e\u0010\u000b\u001a\u00020\fX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\r\u001a\u00020\u000eX\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u001d\u0010\u0011\u001a\u0004\u0018\u00010\u00128BX\u0082\u0084\u0002¢\u0006\f\n\u0004\b\u0015\u0010\u0016\u001a\u0004\b\u0013\u0010\u0014R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\tX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u0017\u001a\u00020\u0018X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0019\u0010\u001aR\u0014\u0010\u001b\u001a\u00020\u001cX\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001d\u0010\u001eR\u000e\u0010\u001f\u001a\u00020 X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010!\u001a\u00020\"X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b#\u0010$R\u000e\u0010%\u001a\u00020&X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010'\u001a\u00020(X\u0082D¢\u0006\u0002\n\u0000R\u0014\u0010)\u001a\u00020(X\u0096D¢\u0006\b\n\u0000\u001a\u0004\b*\u0010+R\u0014\u0010,\u001a\u00020-X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b.\u0010/R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u00100\u001a\u000201X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b2\u00103¨\u0006B"}, m18d2 = {"Lzendesk/conversationkit/android/internal/MainEnvironment;", "Lzendesk/conversationkit/android/internal/Environment;", "context", "Landroid/content/Context;", "config", "Lzendesk/conversationkit/android/model/Config;", "settings", "Lzendesk/conversationkit/android/ConversationKitSettings;", "dispatchers", "Lzendesk/conversationkit/android/internal/ConversationKitDispatchers;", "(Landroid/content/Context;Lzendesk/conversationkit/android/model/Config;Lzendesk/conversationkit/android/ConversationKitSettings;Lzendesk/conversationkit/android/internal/ConversationKitDispatchers;)V", "cacheDir", "Ljava/io/File;", "clientDtoProvider", "Lzendesk/conversationkit/android/internal/ClientDtoProvider;", "getClientDtoProvider", "()Lzendesk/conversationkit/android/internal/ClientDtoProvider;", "connectivityManager", "Landroid/net/ConnectivityManager;", "getConnectivityManager", "()Landroid/net/ConnectivityManager;", "connectivityManager$delegate", "Lkotlin/Lazy;", "hostAppInfo", "Lzendesk/conversationkit/android/internal/HostAppInfo;", "getHostAppInfo", "()Lzendesk/conversationkit/android/internal/HostAppInfo;", "json", "Lkotlinx/serialization/json/Json;", "getJson", "()Lkotlinx/serialization/json/Json;", "localeProvider", "Lzendesk/core/ui/android/internal/local/LocaleProvider;", "restClientFactory", "Lzendesk/conversationkit/android/internal/rest/RestClientFactory;", "getRestClientFactory", "()Lzendesk/conversationkit/android/internal/rest/RestClientFactory;", "restClientFiles", "Lzendesk/conversationkit/android/internal/rest/DefaultRestClientFiles;", "sdkVendor", "", "sdkVersion", "getSdkVersion", "()Ljava/lang/String;", "serializer", "Lzendesk/storage/android/Serializer;", "getSerializer", "()Lzendesk/storage/android/Serializer;", "storageFactory", "Lzendesk/conversationkit/android/internal/StorageFactory;", "getStorageFactory", "()Lzendesk/conversationkit/android/internal/StorageFactory;", "createAppAccessLevel", "Lzendesk/conversationkit/android/internal/AppAccess;", "createAttachmentDownloader", "Lzendesk/conversationkit/android/internal/attachments/AttachmentDownloader;", "attachmentsDownloadReceiver", "Lzendesk/conversationkit/android/internal/attachments/AttachmentsDownloadReceiver;", "createConnectivityObserver", "Lzendesk/conversationkit/android/internal/ConnectivityObserver;", "createConversationKitStore", "Lzendesk/conversationkit/android/internal/ConversationKitStore;", "createCoroutineScope", "Lkotlinx/coroutines/CoroutineScope;", "createMetadataManager", "Lzendesk/conversationkit/android/internal/metadata/MetadataManager;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class MainEnvironment implements Environment {
    private final File cacheDir;
    private final ClientDtoProvider clientDtoProvider;
    private final Config config;

    private final Lazy connectivityManager;
    private final Context context;
    private final ConversationKitDispatchers dispatchers;
    private final HostAppInfo hostAppInfo;
    private final Json json;
    private final LocaleProvider localeProvider;
    private final RestClientFactory restClientFactory;
    private final DefaultRestClientFiles restClientFiles;
    private final String sdkVendor;
    private final String sdkVersion;
    private final Serializer serializer;
    private final ConversationKitSettings settings;
    private final StorageFactory storageFactory;

    public MainEnvironment(Context context, Config config, ConversationKitSettings settings, ConversationKitDispatchers dispatchers) {
        Intrinsics.checkNotNullParameter(context, "context");
        Intrinsics.checkNotNullParameter(config, "config");
        Intrinsics.checkNotNullParameter(settings, "settings");
        Intrinsics.checkNotNullParameter(dispatchers, "dispatchers");
        this.context = context;
        this.config = config;
        this.settings = settings;
        this.dispatchers = dispatchers;
        this.sdkVendor = "conversation-kit";
        File file = new File(context.getCacheDir(), "zendesk.conversationkit");
        this.cacheDir = file;
        LocaleProvider localeProvider = new LocaleProvider(context);
        this.localeProvider = localeProvider;
        this.sdkVersion = BuildConfig.VERSION_NAME;
        this.hostAppInfo = HostAppInfo.INSTANCE.from(context);
        this.json = SerializationProvider.INSTANCE.getJson();
        this.serializer = new DefaultSerializer(getJson());
        this.storageFactory = new StorageFactory(context, getSerializer(), config.getIntegration().getId(), getJson());
        this.clientDtoProvider = new ClientDtoProvider("conversation-kit", getSdkVersion(), getHostAppInfo(), localeProvider);
        DefaultRestClientFiles defaultRestClientFiles = new DefaultRestClientFiles(context);
        this.restClientFiles = defaultRestClientFiles;
        this.restClientFactory = new RestClientFactory(SetsKt.setOf((Object[]) new Pair[]{TuplesKt.m25to("x-smooch-appname", new MainEnvironment$restClientFactory$1(this, null)), TuplesKt.m25to("x-smooch-sdk", new MainEnvironment$restClientFactory$2(this, null)), TuplesKt.m25to("User-Agent", new MainEnvironment$restClientFactory$3(this, null))}), defaultRestClientFiles, file, KotlinSerializationConverterFactory.create(getJson(), MediaType.INSTANCE.get("application/json")));
        this.connectivityManager = LazyKt.lazy(new Function0<ConnectivityManager>() {
            {
                super(0);
            }

            @Override
            public final ConnectivityManager invoke() {
                return (ConnectivityManager) ContextCompat.getSystemService(this.this$0.context, ConnectivityManager.class);
            }
        });
    }

    public MainEnvironment(Context context, Config config, ConversationKitSettings conversationKitSettings, DefaultConversationKitDispatchers defaultConversationKitDispatchers, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(context, config, conversationKitSettings, (i & 8) != 0 ? new DefaultConversationKitDispatchers() : defaultConversationKitDispatchers);
    }

    @Override
    public String getSdkVersion() {
        return this.sdkVersion;
    }

    @Override
    public HostAppInfo getHostAppInfo() {
        return this.hostAppInfo;
    }

    @Override
    public Json getJson() {
        return this.json;
    }

    @Override
    public Serializer getSerializer() {
        return this.serializer;
    }

    @Override
    public StorageFactory getStorageFactory() {
        return this.storageFactory;
    }

    @Override
    public ClientDtoProvider getClientDtoProvider() {
        return this.clientDtoProvider;
    }

    @Override
    public RestClientFactory getRestClientFactory() {
        return this.restClientFactory;
    }

    private final ConnectivityManager getConnectivityManager() {
        return (ConnectivityManager) this.connectivityManager.getValue();
    }

    @Override
    public ConnectivityObserver createConnectivityObserver() {
        return new ConnectivityObserver(getConnectivityManager());
    }

    @Override
    public ConversationKitStore createConversationKitStore() {
        SunCoFayeClientFactory sunCoFayeClientFactory = new SunCoFayeClientFactory(createCoroutineScope());
        AttachmentsDownloadReceiver attachmentsDownloadReceiver = new AttachmentsDownloadReceiver(createCoroutineScope());
        AttachmentDownloader attachmentDownloaderCreateAttachmentDownloader = createAttachmentDownloader(attachmentsDownloadReceiver);
        ConnectivityObserver connectivityObserverCreateConnectivityObserver = createConnectivityObserver();
        EffectMapper effectMapper = new EffectMapper();
        RestClientFactory restClientFactory = getRestClientFactory();
        StorageFactory storageFactory = getStorageFactory();
        ClientDtoProvider clientDtoProvider = getClientDtoProvider();
        DefaultRestClientFiles defaultRestClientFiles = this.restClientFiles;
        DefaultRestClientFiles defaultRestClientFiles2 = defaultRestClientFiles;
        ConversationKitStore conversationKitStore = new ConversationKitStore(this.settings, this.config, new EffectProcessor(effectMapper, new AccessLevelBuilder(restClientFactory, sunCoFayeClientFactory, storageFactory, clientDtoProvider, defaultRestClientFiles2, connectivityObserverCreateConnectivityObserver, createMetadataManager(), attachmentDownloaderCreateAttachmentDownloader, attachmentsDownloadReceiver, this.context, this.settings, this.config, getJson()), this.localeProvider), createCoroutineScope(), null, createAppAccessLevel(), connectivityObserverCreateConnectivityObserver, attachmentDownloaderCreateAttachmentDownloader, 16, null);
        sunCoFayeClientFactory.setActionDispatcher(conversationKitStore);
        return conversationKitStore;
    }

    private final AppAccess createAppAccessLevel() {
        ConversationKitStorage conversationKitStorageCreateConversationKitStorage = getStorageFactory().createConversationKitStorage();
        return new AppAccess(new AppActionProcessor(this.settings, this.config, getRestClientFactory().createAppRestClient(this.config.getApp().getId(), this.config.getBaseUrl()), getClientDtoProvider(), getStorageFactory().createAppStorage(this.config.getApp().getId()), conversationKitStorageCreateConversationKitStorage, getStorageFactory().createProactiveMessagingStorage(), createMetadataManager(), null, 256, null), conversationKitStorageCreateConversationKitStorage);
    }

    private final MetadataManager createMetadataManager() {
        return new MetadataManager(getStorageFactory().createMetadataStorage(this.config.getApp().getId()), new MetadataFormatter());
    }

    @Override
    public CoroutineScope createCoroutineScope() {
        return CoroutineScopeKt.CoroutineScope(this.dispatchers.mo2103default().plus(SupervisorKt.SupervisorJob$default((Job) null, 1, (Object) null)));
    }

    private final AttachmentDownloader createAttachmentDownloader(AttachmentsDownloadReceiver attachmentsDownloadReceiver) {
        return new AttachmentDownloader(this.context, createCoroutineScope(), attachmentsDownloadReceiver);
    }
}
