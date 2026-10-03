package zendesk.guidekit.android.internal.p018di.module;

import dagger.internal.Factory;
import dagger.internal.Preconditions;
import javax.inject.Provider;
import retrofit2.Retrofit;
import zendesk.guidekit.android.internal.rest.HelpCenterApi;

public final class HelpCenterModule_ProvidesFrontendEventsApiFactory implements Factory<HelpCenterApi> {
    private final HelpCenterModule module;
    private final Provider<Retrofit> retrofitProvider;

    public HelpCenterModule_ProvidesFrontendEventsApiFactory(HelpCenterModule helpCenterModule, Provider<Retrofit> provider) {
        this.module = helpCenterModule;
        this.retrofitProvider = provider;
    }

    @Override
    public HelpCenterApi get() {
        return providesFrontendEventsApi(this.module, this.retrofitProvider.get());
    }

    public static HelpCenterModule_ProvidesFrontendEventsApiFactory create(HelpCenterModule helpCenterModule, Provider<Retrofit> provider) {
        return new HelpCenterModule_ProvidesFrontendEventsApiFactory(helpCenterModule, provider);
    }

    public static HelpCenterApi providesFrontendEventsApi(HelpCenterModule helpCenterModule, Retrofit retrofit) {
        return (HelpCenterApi) Preconditions.checkNotNullFromProvides(helpCenterModule.providesFrontendEventsApi(retrofit));
    }
}
