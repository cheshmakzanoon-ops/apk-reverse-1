package zendesk.guidekit.android;

import android.content.Context;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.CoroutineScope;
import zendesk.guidekit.android.internal.p018di.DaggerGuideKitComponent;
import zendesk.guidekit.android.model.GuideKitSettings;

@Metadata(m17d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u001e\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\n¨\u0006\u000b"}, m18d2 = {"Lzendesk/guidekit/android/GuideKitFactory;", "", "()V", "create", "Lzendesk/guidekit/android/GuideKit;", "settings", "Lzendesk/guidekit/android/model/GuideKitSettings;", "context", "Landroid/content/Context;", "coroutineScope", "Lkotlinx/coroutines/CoroutineScope;", "zendesk.guidekit_guidekit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class GuideKitFactory {
    public static final GuideKitFactory INSTANCE = new GuideKitFactory();

    private GuideKitFactory() {
    }

    public final GuideKit create(GuideKitSettings settings, Context context, CoroutineScope coroutineScope) {
        Intrinsics.checkNotNullParameter(settings, "settings");
        Intrinsics.checkNotNullParameter(context, "context");
        Intrinsics.checkNotNullParameter(coroutineScope, "coroutineScope");
        return DaggerGuideKitComponent.factory().create(settings, context, coroutineScope).guideKit();
    }
}
