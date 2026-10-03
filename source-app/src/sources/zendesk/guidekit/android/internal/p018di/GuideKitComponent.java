package zendesk.guidekit.android.internal.p018di;

import android.content.Context;
import dagger.BindsInstance;
import dagger.Component;
import javax.inject.Named;
import kotlin.Metadata;
import kotlinx.coroutines.CoroutineDispatcher;
import kotlinx.coroutines.CoroutineScope;
import zendesk.core.android.internal.p016di.CoroutineDispatchersModule;
import zendesk.core.android.internal.p016di.KotlinxSerializationModule;
import zendesk.guidekit.android.GuideKit;
import zendesk.guidekit.android.internal.p018di.module.BrandsModule;
import zendesk.guidekit.android.internal.p018di.module.GuideKitModule;
import zendesk.guidekit.android.internal.p018di.module.HelpCenterModule;
import zendesk.guidekit.android.internal.p018di.module.NetworkModule;
import zendesk.guidekit.android.model.GuideKitSettings;

@Component(modules = {CoroutineDispatchersModule.class, NetworkModule.class, HelpCenterModule.class, GuideKitModule.class, KotlinxSerializationModule.class, BrandsModule.class})
@GuideKitScope
@Metadata(m17d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\ba\u0018\u00002\u00020\u0001:\u0001\u0006J\b\u0010\u0002\u001a\u00020\u0003H&J\b\u0010\u0004\u001a\u00020\u0005H'¨\u0006\u0007"}, m18d2 = {"Lzendesk/guidekit/android/internal/di/GuideKitComponent;", "", "guideKit", "Lzendesk/guidekit/android/GuideKit;", "ioDispatcher", "Lkotlinx/coroutines/CoroutineDispatcher;", "Factory", "zendesk.guidekit_guidekit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public interface GuideKitComponent {

    @Component.Factory
    @Metadata(m17d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\bg\u0018\u00002\u00020\u0001J&\u0010\u0002\u001a\u00020\u00032\b\b\u0001\u0010\u0004\u001a\u00020\u00052\b\b\u0001\u0010\u0006\u001a\u00020\u00072\b\b\u0001\u0010\b\u001a\u00020\tH&¨\u0006\n"}, m18d2 = {"Lzendesk/guidekit/android/internal/di/GuideKitComponent$Factory;", "", "create", "Lzendesk/guidekit/android/internal/di/GuideKitComponent;", "settings", "Lzendesk/guidekit/android/model/GuideKitSettings;", "context", "Landroid/content/Context;", "coroutineScope", "Lkotlinx/coroutines/CoroutineScope;", "zendesk.guidekit_guidekit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public interface Factory {
        GuideKitComponent create(@BindsInstance GuideKitSettings settings, @BindsInstance Context context, @BindsInstance CoroutineScope coroutineScope);
    }

    GuideKit guideKit();

    @Named(CoroutineDispatchersModule.IO_DISPATCHER)
    CoroutineDispatcher ioDispatcher();
}
