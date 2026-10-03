package zendesk.messaging.android.internal.conversationscreen.guidearticleviewer.p021di;

import android.os.Bundle;
import androidx.savedstate.SavedStateRegistryOwner;
import dagger.BindsInstance;
import dagger.Subcomponent;
import kotlin.Metadata;
import zendesk.messaging.android.internal.conversationscreen.guidearticleviewer.GuideArticleViewerBottomSheetFragment;

@Subcomponent(modules = {GuideArticleViewerModule.class})
@GuideArticleFragmentScope
@Metadata(m17d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\ba\u0018\u00002\u00020\u0001:\u0001\u0006J\u0010\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u0005H&¨\u0006\u0007"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/di/GuideArticleFragmentComponent;", "", "inject", "", "guideArticleViewerBottomSheetFragment", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerBottomSheetFragment;", "Factory", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public interface GuideArticleFragmentComponent {
    void inject(GuideArticleViewerBottomSheetFragment guideArticleViewerBottomSheetFragment);

    @Metadata(m17d1 = {"\u0000\u001c\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\bg\u0018\u00002\u00020\u0001J\u001e\u0010\u0002\u001a\u00020\u00032\b\b\u0001\u0010\u0004\u001a\u00020\u00052\n\b\u0003\u0010\u0006\u001a\u0004\u0018\u00010\u0007H&¨\u0006\b"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/di/GuideArticleFragmentComponent$Factory;", "", "create", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/di/GuideArticleFragmentComponent;", "savedStateRegistryOwner", "Landroidx/savedstate/SavedStateRegistryOwner;", "defaultArgs", "Landroid/os/Bundle;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    @Subcomponent.Factory
    public interface Factory {
        GuideArticleFragmentComponent create(@BindsInstance SavedStateRegistryOwner savedStateRegistryOwner, @BindsInstance Bundle defaultArgs);

        @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class DefaultImpls {
            public static GuideArticleFragmentComponent create$default(Factory factory, SavedStateRegistryOwner savedStateRegistryOwner, Bundle bundle, int i, Object obj) {
                if (obj != null) {
                    throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: create");
                }
                if ((i & 2) != 0) {
                    bundle = null;
                }
                return factory.create(savedStateRegistryOwner, bundle);
            }
        }
    }
}
