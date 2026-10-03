package zendesk.guidekit.android.internal.p018di;

import android.content.Context;
import dagger.internal.DoubleCheck;
import dagger.internal.InstanceFactory;
import dagger.internal.Preconditions;
import dagger.internal.Provider;
import java.io.File;
import kotlinx.coroutines.CoroutineDispatcher;
import kotlinx.coroutines.CoroutineScope;
import okhttp3.OkHttpClient;
import okhttp3.logging.HttpLoggingInterceptor;
import retrofit2.Converter;
import retrofit2.Retrofit;
import zendesk.core.android.internal.p016di.CoroutineDispatchersModule;
import zendesk.core.android.internal.p016di.CoroutineDispatchersModule_IoDispatcherFactory;
import zendesk.core.android.internal.p016di.KotlinxSerializationModule_ProvideJsonFactory;
import zendesk.core.p017ui.android.internal.local.LocaleProvider;
import zendesk.core.p017ui.android.internal.local.LocaleProvider_Factory;
import zendesk.guidekit.android.GuideKit;
import zendesk.guidekit.android.internal.DefaultGuideKit;
import zendesk.guidekit.android.internal.DefaultGuideKit_Factory;
import zendesk.guidekit.android.internal.data.ArticleInMemoryDataSource_Factory;
import zendesk.guidekit.android.internal.data.BrandsInMemoryDataSource_Factory;
import zendesk.guidekit.android.internal.data.GuideKitRepository;
import zendesk.guidekit.android.internal.data.GuideKitRepository_Factory;
import zendesk.guidekit.android.internal.p018di.module.BrandsModule;
import zendesk.guidekit.android.internal.p018di.module.BrandsModule_ProvidesBrandsApiFactory;
import zendesk.guidekit.android.internal.p018di.module.GuideKitModule;
import zendesk.guidekit.android.internal.p018di.module.GuideKitModule_ProvidesBaseUrlFactory;
import zendesk.guidekit.android.internal.p018di.module.HelpCenterModule;
import zendesk.guidekit.android.internal.p018di.module.HelpCenterModule_ProvidesFrontendEventsApiFactory;
import zendesk.guidekit.android.internal.p018di.module.NetworkModule;
import zendesk.guidekit.android.internal.p018di.module.NetworkModule_CacheDirFactory;
import zendesk.guidekit.android.internal.p018di.module.NetworkModule_ProvideKotlinSerializationFactory;
import zendesk.guidekit.android.internal.p018di.module.NetworkModule_ProvidesHeaderInterceptorFactory;
import zendesk.guidekit.android.internal.p018di.module.NetworkModule_ProvidesHttpLoggingInterceptorFactory;
import zendesk.guidekit.android.internal.p018di.module.NetworkModule_ProvidesOkHttpClientFactory;
import zendesk.guidekit.android.internal.p018di.module.NetworkModule_RetrofitFactory;
import zendesk.guidekit.android.internal.rest.BrandsApi;
import zendesk.guidekit.android.internal.rest.HelpCenterApi;
import zendesk.guidekit.android.model.GuideKitSettings;
import zendesk.okhttp.HeaderInterceptor;

public final class DaggerGuideKitComponent {
    private DaggerGuideKitComponent() {
    }

    public static GuideKitComponent.Factory factory() {
        return new Factory();
    }

    private static final class Factory implements GuideKitComponent.Factory {
        private Factory() {
        }

        @Override
        public GuideKitComponent create(GuideKitSettings guideKitSettings, Context context, CoroutineScope coroutineScope) {
            Preconditions.checkNotNull(guideKitSettings);
            Preconditions.checkNotNull(context);
            Preconditions.checkNotNull(coroutineScope);
            return new GuideKitComponentImpl(new CoroutineDispatchersModule(), new NetworkModule(), new HelpCenterModule(), new GuideKitModule(), new BrandsModule(), guideKitSettings, context, coroutineScope);
        }
    }

    private static final class GuideKitComponentImpl implements GuideKitComponent {
        private Provider<File> cacheDirProvider;
        private Provider<Context> contextProvider;
        private final CoroutineDispatchersModule coroutineDispatchersModule;
        private Provider<CoroutineScope> coroutineScopeProvider;
        private Provider<DefaultGuideKit> defaultGuideKitProvider;
        private final GuideKitComponentImpl guideKitComponentImpl;
        private Provider<GuideKitRepository> guideKitRepositoryProvider;
        private Provider<LocaleProvider> localeProvider;
        private Provider<Converter.Factory> provideKotlinSerializationProvider;
        private Provider<String> providesBaseUrlProvider;
        private Provider<BrandsApi> providesBrandsApiProvider;
        private Provider<HelpCenterApi> providesFrontendEventsApiProvider;
        private Provider<GuideKit> providesGuideKitProvider;
        private Provider<HeaderInterceptor> providesHeaderInterceptorProvider;
        private Provider<HttpLoggingInterceptor> providesHttpLoggingInterceptorProvider;
        private Provider<OkHttpClient> providesOkHttpClientProvider;
        private Provider<Retrofit> retrofitProvider;
        private Provider<GuideKitSettings> settingsProvider;

        private GuideKitComponentImpl(CoroutineDispatchersModule coroutineDispatchersModule, NetworkModule networkModule, HelpCenterModule helpCenterModule, GuideKitModule guideKitModule, BrandsModule brandsModule, GuideKitSettings guideKitSettings, Context context, CoroutineScope coroutineScope) {
            this.guideKitComponentImpl = this;
            this.coroutineDispatchersModule = coroutineDispatchersModule;
            initialize(coroutineDispatchersModule, networkModule, helpCenterModule, guideKitModule, brandsModule, guideKitSettings, context, coroutineScope);
        }

        private void initialize(CoroutineDispatchersModule coroutineDispatchersModule, NetworkModule networkModule, HelpCenterModule helpCenterModule, GuideKitModule guideKitModule, BrandsModule brandsModule, GuideKitSettings guideKitSettings, Context context, CoroutineScope coroutineScope) {
            dagger.internal.Factory factoryCreate = InstanceFactory.create(guideKitSettings);
            this.settingsProvider = factoryCreate;
            this.providesBaseUrlProvider = DoubleCheck.provider(GuideKitModule_ProvidesBaseUrlFactory.create(guideKitModule, factoryCreate));
            this.providesHttpLoggingInterceptorProvider = DoubleCheck.provider(NetworkModule_ProvidesHttpLoggingInterceptorFactory.create(networkModule));
            dagger.internal.Factory factoryCreate2 = InstanceFactory.create(context);
            this.contextProvider = factoryCreate2;
            LocaleProvider_Factory localeProvider_FactoryCreate = LocaleProvider_Factory.create(factoryCreate2);
            this.localeProvider = localeProvider_FactoryCreate;
            this.providesHeaderInterceptorProvider = DoubleCheck.provider(NetworkModule_ProvidesHeaderInterceptorFactory.create(networkModule, localeProvider_FactoryCreate));
            Provider<File> provider = DoubleCheck.provider(NetworkModule_CacheDirFactory.create(networkModule, this.contextProvider));
            this.cacheDirProvider = provider;
            this.providesOkHttpClientProvider = DoubleCheck.provider(NetworkModule_ProvidesOkHttpClientFactory.create(networkModule, this.providesHttpLoggingInterceptorProvider, this.providesHeaderInterceptorProvider, provider));
            Provider<Converter.Factory> provider2 = DoubleCheck.provider(NetworkModule_ProvideKotlinSerializationFactory.create(networkModule, KotlinxSerializationModule_ProvideJsonFactory.create()));
            this.provideKotlinSerializationProvider = provider2;
            Provider<Retrofit> provider3 = DoubleCheck.provider(NetworkModule_RetrofitFactory.create(networkModule, this.providesBaseUrlProvider, this.providesOkHttpClientProvider, provider2));
            this.retrofitProvider = provider3;
            this.providesFrontendEventsApiProvider = DoubleCheck.provider(HelpCenterModule_ProvidesFrontendEventsApiFactory.create(helpCenterModule, provider3));
            this.providesBrandsApiProvider = DoubleCheck.provider(BrandsModule_ProvidesBrandsApiFactory.create(brandsModule, this.retrofitProvider));
            this.coroutineScopeProvider = InstanceFactory.create(coroutineScope);
            GuideKitRepository_Factory guideKitRepository_FactoryCreate = GuideKitRepository_Factory.create(this.providesFrontendEventsApiProvider, this.providesBrandsApiProvider, ArticleInMemoryDataSource_Factory.create(), BrandsInMemoryDataSource_Factory.create(), this.settingsProvider, this.coroutineScopeProvider);
            this.guideKitRepositoryProvider = guideKitRepository_FactoryCreate;
            DefaultGuideKit_Factory defaultGuideKit_FactoryCreate = DefaultGuideKit_Factory.create(guideKitRepository_FactoryCreate);
            this.defaultGuideKitProvider = defaultGuideKit_FactoryCreate;
            this.providesGuideKitProvider = DoubleCheck.provider(defaultGuideKit_FactoryCreate);
        }

        @Override
        public GuideKit guideKit() {
            return this.providesGuideKitProvider.get();
        }

        @Override
        public CoroutineDispatcher ioDispatcher() {
            return CoroutineDispatchersModule_IoDispatcherFactory.ioDispatcher(this.coroutineDispatchersModule);
        }
    }
}
