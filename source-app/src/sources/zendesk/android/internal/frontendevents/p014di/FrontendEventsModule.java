package zendesk.android.internal.frontendevents.p014di;

import android.content.Context;
import dagger.Binds;
import dagger.Module;
import dagger.Provides;
import javax.inject.Named;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import retrofit2.Retrofit;
import zendesk.android.internal.frontendevents.FrontendEventsApi;
import zendesk.android.internal.frontendevents.pageviewevents.DefaultPageViewEvents;
import zendesk.android.internal.frontendevents.pageviewevents.PageViewEvents;
import zendesk.android.internal.p013di.ZendeskInitializedComponentScope;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.storage.android.Storage;
import zendesk.storage.android.StorageFactory;
import zendesk.storage.android.StorageType;

@Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0001\u0018\u0000 \u000e2\u00020\u0001:\u0002\r\u000eB\u0005¢\u0006\u0002\u0010\u0002J\u0010\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u0006H\u0007J\u0018\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\fH\u0007¨\u0006\u000f"}, m18d2 = {"Lzendesk/android/internal/frontendevents/di/FrontendEventsModule;", "", "()V", "providesFrontendEventsApi", "Lzendesk/android/internal/frontendevents/FrontendEventsApi;", "retrofit", "Lretrofit2/Retrofit;", "providesFrontendEventsStorage", "Lzendesk/storage/android/Storage;", "context", "Landroid/content/Context;", "messagingSettings", "Lzendesk/android/messaging/model/MessagingSettings;", "BindsModule", "Companion", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Module(includes = {BindsModule.class})
public final class FrontendEventsModule {
    public static final String FRONTEND_EVENTS_STORAGE = "FRONTEND_EVENTS_STORAGE";
    private static final String PAGEVIEWS_STORAGE_NAMESPACE = "pageviews";

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\bg\u0018\u00002\u00020\u0001J\u0010\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u0005H'¨\u0006\u0006"}, m18d2 = {"Lzendesk/android/internal/frontendevents/di/FrontendEventsModule$BindsModule;", "", "providesPageViewEvents", "Lzendesk/android/internal/frontendevents/pageviewevents/PageViewEvents;", "defaultPageViewEvents", "Lzendesk/android/internal/frontendevents/pageviewevents/DefaultPageViewEvents;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    @Module
    public interface BindsModule {
        @ZendeskInitializedComponentScope
        @Binds
        PageViewEvents providesPageViewEvents(DefaultPageViewEvents defaultPageViewEvents);
    }

    @Provides
    @ZendeskInitializedComponentScope
    public final FrontendEventsApi providesFrontendEventsApi(Retrofit retrofit) {
        Intrinsics.checkNotNullParameter(retrofit, "retrofit");
        Object objCreate = retrofit.create(FrontendEventsApi.class);
        Intrinsics.checkNotNullExpressionValue(objCreate, "create(...)");
        return (FrontendEventsApi) objCreate;
    }

    @Provides
    @ZendeskInitializedComponentScope
    @Named(FRONTEND_EVENTS_STORAGE)
    public final Storage providesFrontendEventsStorage(Context context, MessagingSettings messagingSettings) {
        Intrinsics.checkNotNullParameter(context, "context");
        Intrinsics.checkNotNullParameter(messagingSettings, "messagingSettings");
        return StorageFactory.INSTANCE.create(PAGEVIEWS_STORAGE_NAMESPACE, context, StorageType.Basic.INSTANCE, messagingSettings.getIntegrationId());
    }
}
