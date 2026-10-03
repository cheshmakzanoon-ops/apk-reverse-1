package zendesk.messaging.android.internal.conversationscreen.guidearticleviewer.p021di;

import android.os.Bundle;
import androidx.savedstate.SavedStateRegistryOwner;
import dagger.Module;
import dagger.Provides;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.guidekit.android.GuideKit;
import zendesk.messaging.android.internal.conversationscreen.guidearticleviewer.GuideArticleViewerViewModelFactory;

@Metadata(m17d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\b\u0001\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J\"\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\b2\b\u0010\t\u001a\u0004\u0018\u00010\nH\u0007¨\u0006\u000b"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/di/GuideArticleViewerModule;", "", "()V", "providesGuideArticleViewerViewModelFactory", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerViewModelFactory;", "guideKit", "Lzendesk/guidekit/android/GuideKit;", "savedStateRegistryOwner", "Landroidx/savedstate/SavedStateRegistryOwner;", "defaultArgs", "Landroid/os/Bundle;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Module
public final class GuideArticleViewerModule {
    @Provides
    public final GuideArticleViewerViewModelFactory providesGuideArticleViewerViewModelFactory(GuideKit guideKit, SavedStateRegistryOwner savedStateRegistryOwner, Bundle defaultArgs) {
        Intrinsics.checkNotNullParameter(guideKit, "guideKit");
        Intrinsics.checkNotNullParameter(savedStateRegistryOwner, "savedStateRegistryOwner");
        return new GuideArticleViewerViewModelFactory(guideKit, savedStateRegistryOwner, defaultArgs);
    }
}
