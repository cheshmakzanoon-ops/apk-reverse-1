package zendesk.android.internal.p013di;

import android.content.Context;
import dagger.Module;
import dagger.Provides;
import javax.inject.Singleton;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.CoroutineScope;
import retrofit2.Retrofit;
import zendesk.android.settings.internal.SettingsApi;
import zendesk.core.p017ui.android.internal.app.ProcessLifecycleEventObserver;

@Metadata(m17d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\b\u0001\u0018\u00002\u00020\u0001B\u001d\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\bJ\r\u0010\t\u001a\u00020\u0007H\u0001¢\u0006\u0002\b\nJ\r\u0010\u0002\u001a\u00020\u0003H\u0001¢\u0006\u0002\b\u000bJ\r\u0010\u0004\u001a\u00020\u0005H\u0001¢\u0006\u0002\b\fJ\r\u0010\r\u001a\u00020\u000eH\u0001¢\u0006\u0002\b\u000fJ\u0010\u0010\u0010\u001a\u00020\u00112\u0006\u0010\u0012\u001a\u00020\u0013H\u0007R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0014"}, m18d2 = {"Lzendesk/android/internal/di/ZendeskModule;", "", "context", "Landroid/content/Context;", "mainScope", "Lkotlinx/coroutines/CoroutineScope;", "componentConfig", "Lzendesk/android/internal/di/ZendeskComponentConfig;", "(Landroid/content/Context;Lkotlinx/coroutines/CoroutineScope;Lzendesk/android/internal/di/ZendeskComponentConfig;)V", "componentData", "componentData$zendesk_zendesk_android", "context$zendesk_zendesk_android", "mainScope$zendesk_zendesk_android", "provideProcessLifecycleEventObserver", "Lzendesk/core/ui/android/internal/app/ProcessLifecycleEventObserver;", "provideProcessLifecycleEventObserver$zendesk_zendesk_android", "settingsApi", "Lzendesk/android/settings/internal/SettingsApi;", "retrofit", "Lretrofit2/Retrofit;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Module(subcomponents = {ZendeskInitializedComponent.class})
public final class ZendeskModule {
    private final ZendeskComponentConfig componentConfig;
    private final Context context;
    private final CoroutineScope mainScope;

    public ZendeskModule(Context context, CoroutineScope mainScope, ZendeskComponentConfig componentConfig) {
        Intrinsics.checkNotNullParameter(context, "context");
        Intrinsics.checkNotNullParameter(mainScope, "mainScope");
        Intrinsics.checkNotNullParameter(componentConfig, "componentConfig");
        this.context = context;
        this.mainScope = mainScope;
        this.componentConfig = componentConfig;
    }

    @Provides
    @Singleton
    public final Context getContext() {
        return this.context;
    }

    @Provides
    @Singleton
    public final ZendeskComponentConfig getComponentConfig() {
        return this.componentConfig;
    }

    @Provides
    @Singleton
    public final CoroutineScope getMainScope() {
        return this.mainScope;
    }

    @Provides
    @Singleton
    public final ProcessLifecycleEventObserver provideProcessLifecycleEventObserver$zendesk_zendesk_android() {
        return ProcessLifecycleEventObserver.INSTANCE.newInstance();
    }

    @Provides
    @Singleton
    public final SettingsApi settingsApi(Retrofit retrofit) {
        Intrinsics.checkNotNullParameter(retrofit, "retrofit");
        Object objCreate = retrofit.create(SettingsApi.class);
        Intrinsics.checkNotNullExpressionValue(objCreate, "create(...)");
        return (SettingsApi) objCreate;
    }
}
