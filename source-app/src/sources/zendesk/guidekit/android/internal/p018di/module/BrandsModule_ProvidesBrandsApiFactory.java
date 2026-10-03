package zendesk.guidekit.android.internal.p018di.module;

import dagger.internal.Factory;
import dagger.internal.Preconditions;
import javax.inject.Provider;
import retrofit2.Retrofit;
import zendesk.guidekit.android.internal.rest.BrandsApi;

public final class BrandsModule_ProvidesBrandsApiFactory implements Factory<BrandsApi> {
    private final BrandsModule module;
    private final Provider<Retrofit> retrofitProvider;

    public BrandsModule_ProvidesBrandsApiFactory(BrandsModule brandsModule, Provider<Retrofit> provider) {
        this.module = brandsModule;
        this.retrofitProvider = provider;
    }

    @Override
    public BrandsApi get() {
        return providesBrandsApi(this.module, this.retrofitProvider.get());
    }

    public static BrandsModule_ProvidesBrandsApiFactory create(BrandsModule brandsModule, Provider<Retrofit> provider) {
        return new BrandsModule_ProvidesBrandsApiFactory(brandsModule, provider);
    }

    public static BrandsApi providesBrandsApi(BrandsModule brandsModule, Retrofit retrofit) {
        return (BrandsApi) Preconditions.checkNotNullFromProvides(brandsModule.providesBrandsApi(retrofit));
    }
}
