package zendesk.guidekit.android.internal.p018di.module;

import dagger.Binds;
import dagger.Module;
import dagger.Provides;
import javax.inject.Named;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.guidekit.android.GuideKit;
import zendesk.guidekit.android.internal.DefaultGuideKit;
import zendesk.guidekit.android.internal.p018di.GuideKitScope;
import zendesk.guidekit.android.model.GuideKitSettings;

@Metadata(m17d1 = {"\u0000\u001a\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0001\u0018\u00002\u00020\u0001:\u0001\u0007B\u0005¢\u0006\u0002\u0010\u0002J\u0010\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u0006H\u0007¨\u0006\b"}, m18d2 = {"Lzendesk/guidekit/android/internal/di/module/GuideKitModule;", "", "()V", "providesBaseUrl", "", "settings", "Lzendesk/guidekit/android/model/GuideKitSettings;", "BindsModule", "zendesk.guidekit_guidekit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Module(includes = {BindsModule.class})
public final class GuideKitModule {

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\bg\u0018\u00002\u00020\u0001J\u0010\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u0005H'¨\u0006\u0006"}, m18d2 = {"Lzendesk/guidekit/android/internal/di/module/GuideKitModule$BindsModule;", "", "providesGuideKit", "Lzendesk/guidekit/android/GuideKit;", "defaultGuideKit", "Lzendesk/guidekit/android/internal/DefaultGuideKit;", "zendesk.guidekit_guidekit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    @Module
    public interface BindsModule {
        @GuideKitScope
        @Binds
        GuideKit providesGuideKit(DefaultGuideKit defaultGuideKit);
    }

    @Provides
    @GuideKitScope
    @Named("baseUrl")
    public final String providesBaseUrl(GuideKitSettings settings) {
        Intrinsics.checkNotNullParameter(settings, "settings");
        return settings.getBaseUrl$zendesk_guidekit_guidekit_android();
    }
}
