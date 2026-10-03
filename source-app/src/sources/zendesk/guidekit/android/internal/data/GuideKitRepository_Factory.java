package zendesk.guidekit.android.internal.data;

import dagger.internal.Factory;
import javax.inject.Provider;
import kotlinx.coroutines.CoroutineScope;
import zendesk.guidekit.android.internal.rest.BrandsApi;
import zendesk.guidekit.android.internal.rest.HelpCenterApi;
import zendesk.guidekit.android.model.GuideKitSettings;

public final class GuideKitRepository_Factory implements Factory<GuideKitRepository> {
    private final Provider<ArticleInMemoryDataSource> articleInMemoryDataSourceProvider;
    private final Provider<BrandsApi> brandsApiProvider;
    private final Provider<BrandsInMemoryDataSource> brandsInMemoryDataSourceProvider;
    private final Provider<CoroutineScope> coroutineScopeProvider;
    private final Provider<GuideKitSettings> guideKitSettingsProvider;
    private final Provider<HelpCenterApi> helpCenterApiProvider;

    public GuideKitRepository_Factory(Provider<HelpCenterApi> provider, Provider<BrandsApi> provider2, Provider<ArticleInMemoryDataSource> provider3, Provider<BrandsInMemoryDataSource> provider4, Provider<GuideKitSettings> provider5, Provider<CoroutineScope> provider6) {
        this.helpCenterApiProvider = provider;
        this.brandsApiProvider = provider2;
        this.articleInMemoryDataSourceProvider = provider3;
        this.brandsInMemoryDataSourceProvider = provider4;
        this.guideKitSettingsProvider = provider5;
        this.coroutineScopeProvider = provider6;
    }

    @Override
    public GuideKitRepository get() {
        return newInstance(this.helpCenterApiProvider.get(), this.brandsApiProvider.get(), this.articleInMemoryDataSourceProvider.get(), this.brandsInMemoryDataSourceProvider.get(), this.guideKitSettingsProvider.get(), this.coroutineScopeProvider.get());
    }

    public static GuideKitRepository_Factory create(Provider<HelpCenterApi> provider, Provider<BrandsApi> provider2, Provider<ArticleInMemoryDataSource> provider3, Provider<BrandsInMemoryDataSource> provider4, Provider<GuideKitSettings> provider5, Provider<CoroutineScope> provider6) {
        return new GuideKitRepository_Factory(provider, provider2, provider3, provider4, provider5, provider6);
    }

    public static GuideKitRepository newInstance(HelpCenterApi helpCenterApi, BrandsApi brandsApi, ArticleInMemoryDataSource articleInMemoryDataSource, BrandsInMemoryDataSource brandsInMemoryDataSource, GuideKitSettings guideKitSettings, CoroutineScope coroutineScope) {
        return new GuideKitRepository(helpCenterApi, brandsApi, articleInMemoryDataSource, brandsInMemoryDataSource, guideKitSettings, coroutineScope);
    }
}
