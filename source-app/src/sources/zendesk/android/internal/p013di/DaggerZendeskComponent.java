package zendesk.android.internal.p013di;

import android.content.Context;
import dagger.internal.DoubleCheck;
import dagger.internal.Preconditions;
import dagger.internal.Provider;
import java.io.File;
import kotlin.jvm.functions.Function0;
import kotlinx.coroutines.CoroutineDispatcher;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.serialization.json.Json;
import okhttp3.OkHttpClient;
import retrofit2.Converter;
import retrofit2.Retrofit;
import zendesk.android.Zendesk;
import zendesk.android.Zendesk_Factory;
import zendesk.android.events.internal.ZendeskEventDispatcher;
import zendesk.android.events.internal.ZendeskEventDispatcher_Factory;
import zendesk.android.internal.frontendevents.FrontendEventsApi;
import zendesk.android.internal.frontendevents.FrontendEventsRepository;
import zendesk.android.internal.frontendevents.FrontendEventsRepository_Factory;
import zendesk.android.internal.frontendevents.FrontendEventsStorage;
import zendesk.android.internal.frontendevents.FrontendEventsStorage_Factory;
import zendesk.android.internal.frontendevents.analyticsevents.ProactiveMessagingAnalyticsManager;
import zendesk.android.internal.frontendevents.analyticsevents.ProactiveMessagingAnalyticsManager_Factory;
import zendesk.android.internal.frontendevents.p014di.FrontendEventsModule;
import zendesk.android.internal.frontendevents.p014di.FrontendEventsModule_ProvidesFrontendEventsApiFactory;
import zendesk.android.internal.frontendevents.p014di.FrontendEventsModule_ProvidesFrontendEventsStorageFactory;
import zendesk.android.internal.frontendevents.pageviewevents.DefaultPageViewEvents;
import zendesk.android.internal.frontendevents.pageviewevents.DefaultPageViewEvents_Factory;
import zendesk.android.internal.network.HeaderFactory;
import zendesk.android.internal.network.HeaderFactory_Factory;
import zendesk.android.internal.network.NetworkData;
import zendesk.android.internal.network.NetworkData_Factory;
import zendesk.android.internal.network.NetworkModule;
import zendesk.android.internal.network.NetworkModule_CacheDirFactory;
import zendesk.android.internal.network.NetworkModule_OkHttpClientFactory;
import zendesk.android.internal.network.NetworkModule_ProvideJsonFactory;
import zendesk.android.internal.network.NetworkModule_ProvideKotlinSerializationFactory;
import zendesk.android.internal.network.NetworkModule_RetrofitFactory;
import zendesk.android.internal.proactivemessaging.ProactiveMessagingManager;
import zendesk.android.internal.proactivemessaging.ProactiveMessagingManager_Factory;
import zendesk.android.internal.proactivemessaging.ProactiveMessagingRepository;
import zendesk.android.internal.proactivemessaging.ProactiveMessagingRepository_Factory;
import zendesk.android.internal.proactivemessaging.ProactiveMessagingService;
import zendesk.android.internal.proactivemessaging.ProactiveMessagingStorage;
import zendesk.android.internal.proactivemessaging.ProactiveMessagingStorage_Factory;
import zendesk.android.internal.proactivemessaging.VisitTypeProvider;
import zendesk.android.internal.proactivemessaging.VisitTypeProvider_Factory;
import zendesk.android.internal.proactivemessaging.campaigntriggerservice.model.jwt.ProactiveMessageJwtDecoder;
import zendesk.android.internal.proactivemessaging.campaigntriggerservice.model.jwt.ProactiveMessageJwtDecoder_Factory;
import zendesk.android.internal.proactivemessaging.p015di.C0976x86514eb4;
import zendesk.android.internal.proactivemessaging.p015di.ProactiveMessagingModule;
import zendesk.android.internal.proactivemessaging.p015di.ProactiveMessagingModule_ProvidesCampaignTriggerServiceFactory;
import zendesk.android.internal.proactivemessaging.p015di.ProactiveMessagingModule_ProvidesCurrentTimeProviderFactory;
import zendesk.android.messaging.Messaging;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.android.settings.internal.SettingsApi;
import zendesk.android.settings.internal.SettingsRepository;
import zendesk.android.settings.internal.SettingsRepository_Factory;
import zendesk.android.settings.internal.SettingsRestClient;
import zendesk.android.settings.internal.SettingsRestClient_Factory;
import zendesk.conversationkit.android.ConversationKit;
import zendesk.core.android.internal.app.FeatureFlagManager;
import zendesk.core.android.internal.p016di.CoroutineDispatchersModule;
import zendesk.core.android.internal.p016di.CoroutineDispatchersModule_IoDispatcherFactory;
import zendesk.core.android.internal.p016di.CoroutineDispatchersModule_MainDispatcherFactory;
import zendesk.core.android.internal.p016di.CoroutineDispatchersModule_PersistenceDispatcherFactory;
import zendesk.core.p017ui.android.internal.app.ProcessLifecycleEventObserver;
import zendesk.core.p017ui.android.internal.local.LocaleProvider;
import zendesk.core.p017ui.android.internal.local.LocaleProvider_Factory;
import zendesk.storage.android.Storage;

public final class DaggerZendeskComponent {
    private DaggerZendeskComponent() {
    }

    public static Builder builder() {
        return new Builder();
    }

    public static final class Builder {
        private CoroutineDispatchersModule coroutineDispatchersModule;
        private NetworkModule networkModule;
        private ZendeskModule zendeskModule;

        private Builder() {
        }

        public Builder zendeskModule(ZendeskModule zendeskModule) {
            this.zendeskModule = (ZendeskModule) Preconditions.checkNotNull(zendeskModule);
            return this;
        }

        public Builder networkModule(NetworkModule networkModule) {
            this.networkModule = (NetworkModule) Preconditions.checkNotNull(networkModule);
            return this;
        }

        public Builder coroutineDispatchersModule(CoroutineDispatchersModule coroutineDispatchersModule) {
            this.coroutineDispatchersModule = (CoroutineDispatchersModule) Preconditions.checkNotNull(coroutineDispatchersModule);
            return this;
        }

        public ZendeskComponent build() {
            Preconditions.checkBuilderRequirement(this.zendeskModule, ZendeskModule.class);
            if (this.networkModule == null) {
                this.networkModule = new NetworkModule();
            }
            if (this.coroutineDispatchersModule == null) {
                this.coroutineDispatchersModule = new CoroutineDispatchersModule();
            }
            return new ZendeskComponentImpl(this.zendeskModule, this.networkModule, this.coroutineDispatchersModule);
        }
    }

    private static final class ZendeskInitializedComponentBuilder implements ZendeskInitializedComponent.Builder {
        private final ZendeskComponentImpl zendeskComponentImpl;
        private ZendeskInitializedModule zendeskInitializedModule;

        private ZendeskInitializedComponentBuilder(ZendeskComponentImpl zendeskComponentImpl) {
            this.zendeskComponentImpl = zendeskComponentImpl;
        }

        @Override
        public ZendeskInitializedComponentBuilder zendeskInitializedModule(ZendeskInitializedModule zendeskInitializedModule) {
            this.zendeskInitializedModule = (ZendeskInitializedModule) Preconditions.checkNotNull(zendeskInitializedModule);
            return this;
        }

        @Override
        public ZendeskInitializedComponent build() {
            Preconditions.checkBuilderRequirement(this.zendeskInitializedModule, ZendeskInitializedModule.class);
            return new ZendeskInitializedComponentImpl(this.zendeskComponentImpl, this.zendeskInitializedModule, new ProactiveMessagingModule(), new FrontendEventsModule());
        }
    }

    private static final class ZendeskInitializedComponentImpl implements ZendeskInitializedComponent {
        private Provider<DefaultPageViewEvents> defaultPageViewEventsProvider;
        private Provider<FrontendEventsRepository> frontendEventsRepositoryProvider;
        private Provider<FrontendEventsStorage> frontendEventsStorageProvider;
        private Provider<ProactiveMessageJwtDecoder> proactiveMessageJwtDecoderProvider;
        private Provider<ProactiveMessagingAnalyticsManager> proactiveMessagingAnalyticsManagerProvider;
        private Provider<ProactiveMessagingManager> proactiveMessagingManagerProvider;
        private Provider<ProactiveMessagingRepository> proactiveMessagingRepositoryProvider;
        private Provider<ProactiveMessagingStorage> proactiveMessagingStorageProvider;
        private Provider<ProactiveMessagingService> providesCampaignTriggerServiceProvider;
        private Provider<ConversationKit> providesConversationKitProvider;
        private Provider<Function0<Long>> providesCurrentTimeProvider;
        private Provider<FeatureFlagManager> providesFeatureFlagManagerProvider;
        private Provider<FrontendEventsApi> providesFrontendEventsApiProvider;
        private Provider<Storage> providesFrontendEventsStorageProvider;
        private Provider<Messaging> providesMessagingProvider;
        private Provider<Storage> providesProactiveMessagingStorageProvider;
        private Provider<MessagingSettings> providesSettingsProvider;
        private Provider<VisitTypeProvider> visitTypeProvider;
        private final ZendeskComponentImpl zendeskComponentImpl;
        private final ZendeskInitializedComponentImpl zendeskInitializedComponentImpl;
        private Provider<Zendesk> zendeskProvider;

        private ZendeskInitializedComponentImpl(ZendeskComponentImpl zendeskComponentImpl, ZendeskInitializedModule zendeskInitializedModule, ProactiveMessagingModule proactiveMessagingModule, FrontendEventsModule frontendEventsModule) {
            this.zendeskInitializedComponentImpl = this;
            this.zendeskComponentImpl = zendeskComponentImpl;
            initialize(zendeskInitializedModule, proactiveMessagingModule, frontendEventsModule);
        }

        private void initialize(ZendeskInitializedModule zendeskInitializedModule, ProactiveMessagingModule proactiveMessagingModule, FrontendEventsModule frontendEventsModule) {
            this.providesConversationKitProvider = DoubleCheck.provider(ZendeskInitializedModule_ProvidesConversationKitFactory.create(zendeskInitializedModule));
            this.providesMessagingProvider = DoubleCheck.provider(ZendeskInitializedModule_ProvidesMessagingFactory.create(zendeskInitializedModule));
            this.providesFrontendEventsApiProvider = DoubleCheck.provider(FrontendEventsModule_ProvidesFrontendEventsApiFactory.create(frontendEventsModule, this.zendeskComponentImpl.retrofitProvider));
            this.providesSettingsProvider = DoubleCheck.provider(ZendeskInitializedModule_ProvidesSettingsFactory.create(zendeskInitializedModule));
            Provider<Storage> provider = DoubleCheck.provider(FrontendEventsModule_ProvidesFrontendEventsStorageFactory.create(frontendEventsModule, this.zendeskComponentImpl.context$zendesk_zendesk_androidProvider, this.providesSettingsProvider));
            this.providesFrontendEventsStorageProvider = provider;
            this.frontendEventsStorageProvider = DoubleCheck.provider(FrontendEventsStorage_Factory.create(provider, this.zendeskComponentImpl.persistenceDispatcherProvider));
            this.frontendEventsRepositoryProvider = DoubleCheck.provider(FrontendEventsRepository_Factory.create(this.providesFrontendEventsApiProvider, this.zendeskComponentImpl.componentData$zendesk_zendesk_androidProvider, this.frontendEventsStorageProvider, this.providesConversationKitProvider, this.zendeskComponentImpl.networkDataProvider, this.zendeskComponentImpl.localeProvider));
            this.visitTypeProvider = DoubleCheck.provider(VisitTypeProvider_Factory.create(this.providesConversationKitProvider, this.zendeskComponentImpl.mainScope$zendesk_zendesk_androidProvider));
            Provider<Storage> provider2 = DoubleCheck.provider(C0976x86514eb4.create(proactiveMessagingModule, this.zendeskComponentImpl.context$zendesk_zendesk_androidProvider, this.providesSettingsProvider));
            this.providesProactiveMessagingStorageProvider = provider2;
            this.proactiveMessagingStorageProvider = DoubleCheck.provider(ProactiveMessagingStorage_Factory.create(provider2, this.zendeskComponentImpl.persistenceDispatcherProvider));
            this.proactiveMessageJwtDecoderProvider = ProactiveMessageJwtDecoder_Factory.create(this.zendeskComponentImpl.provideJsonProvider);
            this.providesCampaignTriggerServiceProvider = DoubleCheck.provider(ProactiveMessagingModule_ProvidesCampaignTriggerServiceFactory.create(proactiveMessagingModule, this.zendeskComponentImpl.retrofitProvider));
            this.proactiveMessagingRepositoryProvider = DoubleCheck.provider(ProactiveMessagingRepository_Factory.create(this.zendeskComponentImpl.settingsRepositoryProvider, this.proactiveMessagingStorageProvider, this.proactiveMessageJwtDecoderProvider, this.providesCampaignTriggerServiceProvider, this.zendeskComponentImpl.mainScope$zendesk_zendesk_androidProvider));
            this.providesCurrentTimeProvider = DoubleCheck.provider(ProactiveMessagingModule_ProvidesCurrentTimeProviderFactory.create(proactiveMessagingModule));
            this.proactiveMessagingAnalyticsManagerProvider = DoubleCheck.provider(ProactiveMessagingAnalyticsManager_Factory.create(this.frontendEventsRepositoryProvider, this.zendeskComponentImpl.mainScope$zendesk_zendesk_androidProvider, this.providesConversationKitProvider));
            this.proactiveMessagingManagerProvider = DoubleCheck.provider(ProactiveMessagingManager_Factory.create(this.zendeskComponentImpl.f145x7059954a, this.zendeskComponentImpl.mainScope$zendesk_zendesk_androidProvider, this.zendeskComponentImpl.localeProvider, this.visitTypeProvider, this.providesConversationKitProvider, this.proactiveMessagingRepositoryProvider, this.providesCurrentTimeProvider, this.proactiveMessagingAnalyticsManagerProvider));
            this.defaultPageViewEventsProvider = DoubleCheck.provider(DefaultPageViewEvents_Factory.create(this.frontendEventsRepositoryProvider, this.zendeskComponentImpl.ioDispatcherProvider, this.proactiveMessagingManagerProvider));
            this.zendeskProvider = DoubleCheck.provider(Zendesk_Factory.create(this.providesMessagingProvider, this.zendeskComponentImpl.mainScope$zendesk_zendesk_androidProvider, this.zendeskComponentImpl.zendeskEventDispatcherProvider, this.providesConversationKitProvider, this.defaultPageViewEventsProvider));
            this.providesFeatureFlagManagerProvider = DoubleCheck.provider(ZendeskInitializedModule_ProvidesFeatureFlagManagerFactory.create(zendeskInitializedModule));
        }

        @Override
        public ConversationKit conversationKit() {
            return this.providesConversationKitProvider.get();
        }

        @Override
        public Messaging messaging() {
            return this.providesMessagingProvider.get();
        }

        @Override
        public Zendesk zendesk() {
            return this.zendeskProvider.get();
        }

        @Override
        public MessagingSettings settings() {
            return this.providesSettingsProvider.get();
        }

        @Override
        public FeatureFlagManager featureFlagManager() {
            return this.providesFeatureFlagManagerProvider.get();
        }
    }

    private static final class ZendeskComponentImpl implements ZendeskComponent {
        private Provider<File> cacheDirProvider;
        private Provider<ZendeskComponentConfig> componentData$zendesk_zendesk_androidProvider;
        private Provider<Context> context$zendesk_zendesk_androidProvider;
        private Provider<HeaderFactory> headerFactoryProvider;
        private Provider<CoroutineDispatcher> ioDispatcherProvider;
        private Provider<LocaleProvider> localeProvider;
        private Provider<CoroutineDispatcher> mainDispatcherProvider;
        private Provider<CoroutineScope> mainScope$zendesk_zendesk_androidProvider;
        private Provider<NetworkData> networkDataProvider;
        private Provider<OkHttpClient> okHttpClientProvider;
        private Provider<CoroutineDispatcher> persistenceDispatcherProvider;
        private Provider<Json> provideJsonProvider;
        private Provider<Converter.Factory> provideKotlinSerializationProvider;

        private Provider<ProcessLifecycleEventObserver> f145x7059954a;
        private Provider<Retrofit> retrofitProvider;
        private Provider<SettingsApi> settingsApiProvider;
        private Provider<SettingsRepository> settingsRepositoryProvider;
        private Provider<SettingsRestClient> settingsRestClientProvider;
        private final ZendeskComponentImpl zendeskComponentImpl;
        private Provider<ZendeskEventDispatcher> zendeskEventDispatcherProvider;

        private ZendeskComponentImpl(ZendeskModule zendeskModule, NetworkModule networkModule, CoroutineDispatchersModule coroutineDispatchersModule) {
            this.zendeskComponentImpl = this;
            initialize(zendeskModule, networkModule, coroutineDispatchersModule);
        }

        private void initialize(ZendeskModule zendeskModule, NetworkModule networkModule, CoroutineDispatchersModule coroutineDispatchersModule) {
            Provider<ZendeskComponentConfig> provider = DoubleCheck.provider(ZendeskModule_ComponentData$zendesk_zendesk_androidFactory.create(zendeskModule));
            this.componentData$zendesk_zendesk_androidProvider = provider;
            this.networkDataProvider = NetworkData_Factory.create(provider);
            Provider<Context> provider2 = DoubleCheck.provider(ZendeskModule_Context$zendesk_zendesk_androidFactory.create(zendeskModule));
            this.context$zendesk_zendesk_androidProvider = provider2;
            LocaleProvider_Factory localeProvider_FactoryCreate = LocaleProvider_Factory.create(provider2);
            this.localeProvider = localeProvider_FactoryCreate;
            this.headerFactoryProvider = DoubleCheck.provider(HeaderFactory_Factory.create(this.componentData$zendesk_zendesk_androidProvider, this.networkDataProvider, localeProvider_FactoryCreate));
            Provider<File> provider3 = DoubleCheck.provider(NetworkModule_CacheDirFactory.create(networkModule, this.context$zendesk_zendesk_androidProvider));
            this.cacheDirProvider = provider3;
            this.okHttpClientProvider = DoubleCheck.provider(NetworkModule_OkHttpClientFactory.create(networkModule, this.headerFactoryProvider, provider3));
            Provider<Json> provider4 = DoubleCheck.provider(NetworkModule_ProvideJsonFactory.create(networkModule));
            this.provideJsonProvider = provider4;
            Provider<Converter.Factory> provider5 = DoubleCheck.provider(NetworkModule_ProvideKotlinSerializationFactory.create(networkModule, provider4));
            this.provideKotlinSerializationProvider = provider5;
            Provider<Retrofit> provider6 = DoubleCheck.provider(NetworkModule_RetrofitFactory.create(networkModule, this.componentData$zendesk_zendesk_androidProvider, this.okHttpClientProvider, provider5));
            this.retrofitProvider = provider6;
            Provider<SettingsApi> provider7 = DoubleCheck.provider(ZendeskModule_SettingsApiFactory.create(zendeskModule, provider6));
            this.settingsApiProvider = provider7;
            Provider<SettingsRestClient> provider8 = DoubleCheck.provider(SettingsRestClient_Factory.create(provider7, this.provideJsonProvider, this.componentData$zendesk_zendesk_androidProvider));
            this.settingsRestClientProvider = provider8;
            this.settingsRepositoryProvider = DoubleCheck.provider(SettingsRepository_Factory.create(provider8));
            CoroutineDispatchersModule_MainDispatcherFactory coroutineDispatchersModule_MainDispatcherFactoryCreate = CoroutineDispatchersModule_MainDispatcherFactory.create(coroutineDispatchersModule);
            this.mainDispatcherProvider = coroutineDispatchersModule_MainDispatcherFactoryCreate;
            this.zendeskEventDispatcherProvider = DoubleCheck.provider(ZendeskEventDispatcher_Factory.create(coroutineDispatchersModule_MainDispatcherFactoryCreate));
            this.mainScope$zendesk_zendesk_androidProvider = DoubleCheck.provider(ZendeskModule_MainScope$zendesk_zendesk_androidFactory.create(zendeskModule));
            this.persistenceDispatcherProvider = CoroutineDispatchersModule_PersistenceDispatcherFactory.create(coroutineDispatchersModule);
            this.ioDispatcherProvider = CoroutineDispatchersModule_IoDispatcherFactory.create(coroutineDispatchersModule);
            this.f145x7059954a = DoubleCheck.provider(C0950xd9bebeda.create(zendeskModule));
        }

        @Override
        public ZendeskInitializedComponent.Builder getZendeskInitializedComponent() {
            return new ZendeskInitializedComponentBuilder(this.zendeskComponentImpl);
        }

        @Override
        public SettingsRepository settingsRepository() {
            return this.settingsRepositoryProvider.get();
        }

        @Override
        public ZendeskEventDispatcher zendeskEventDispatcher() {
            return this.zendeskEventDispatcherProvider.get();
        }

        @Override
        public CoroutineScope mainScope() {
            return this.mainScope$zendesk_zendesk_androidProvider.get();
        }

        @Override
        public Context context() {
            return this.context$zendesk_zendesk_androidProvider.get();
        }

        @Override
        public ZendeskComponentConfig componentData() {
            return this.componentData$zendesk_zendesk_androidProvider.get();
        }
    }
}
