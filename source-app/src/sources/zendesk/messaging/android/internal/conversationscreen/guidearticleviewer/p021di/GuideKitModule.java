package zendesk.messaging.android.internal.conversationscreen.guidearticleviewer.p021di;

import android.content.Context;
import dagger.Module;
import dagger.Provides;
import javax.inject.Named;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.CoroutineScope;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.guidekit.android.GuideKit;
import zendesk.guidekit.android.GuideKitFactory;
import zendesk.guidekit.android.model.GuideKitSettings;
import zendesk.messaging.android.internal.p023di.MessagingScope;

@Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\b\u0001\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J*\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\b\b\u0001\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\fH\u0007¨\u0006\r"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/di/GuideKitModule;", "", "()V", "providesGuideKit", "Lzendesk/guidekit/android/GuideKit;", "context", "Landroid/content/Context;", "baseUrl", "", "messagingSettings", "Lzendesk/android/messaging/model/MessagingSettings;", "coroutineScope", "Lkotlinx/coroutines/CoroutineScope;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Module
public final class GuideKitModule {
    @Provides
    @MessagingScope
    public final GuideKit providesGuideKit(Context context, @Named("baseUrl") String baseUrl, MessagingSettings messagingSettings, CoroutineScope coroutineScope) {
        Intrinsics.checkNotNullParameter(context, "context");
        Intrinsics.checkNotNullParameter(baseUrl, "baseUrl");
        Intrinsics.checkNotNullParameter(messagingSettings, "messagingSettings");
        Intrinsics.checkNotNullParameter(coroutineScope, "coroutineScope");
        return GuideKitFactory.INSTANCE.create(new GuideKitSettings(baseUrl, messagingSettings.getIdentifier()), context, coroutineScope);
    }
}
