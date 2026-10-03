package androidx.compose.foundation.lazy.layout;

import android.os.Build;
import android.view.View;
import androidx.compose.p002ui.platform.AndroidCompositionLocals_androidKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.ProvidableCompositionLocal;
import java.util.Locale;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000\u0011\n\u0000\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0002*\u0001\u0001\u001a\r\u0010\u0005\u001a\u00020\u0006H\u0001¢\u0006\u0002\u0010\u0007\"\u001a\u0010\u0000\u001a\u0004\u0018\u00010\u00018\u0002X\u0083\u0004¢\u0006\n\n\u0002\u0010\u0004\u0012\u0004\b\u0002\u0010\u0003¨\u0006\b"}, d2 = {"RobolectricImpl", "androidx/compose/foundation/lazy/layout/PrefetchScheduler_androidKt$RobolectricImpl$1", "getRobolectricImpl$annotations", "()V", "Landroidx/compose/foundation/lazy/layout/PrefetchScheduler_androidKt$RobolectricImpl$1;", "rememberDefaultPrefetchScheduler", "Landroidx/compose/foundation/lazy/layout/PrefetchScheduler;", "(Landroidx/compose/runtime/Composer;I)Landroidx/compose/foundation/lazy/layout/PrefetchScheduler;", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class PrefetchScheduler_androidKt {
    private static final PrefetchScheduler_androidKt$RobolectricImpl$1 RobolectricImpl;

    private static void getRobolectricImpl$annotations() {
    }

    public static final PrefetchScheduler rememberDefaultPrefetchScheduler(Composer composer, int i) {
        AndroidPrefetchScheduler androidPrefetchScheduler;
        ComposerKt.sourceInformationMarkerStart(composer, 1141871251, "C(rememberDefaultPrefetchScheduler):PrefetchScheduler.android.kt#wow0x6");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1141871251, i, -1, "androidx.compose.foundation.lazy.layout.rememberDefaultPrefetchScheduler (PrefetchScheduler.android.kt:32)");
        }
        PrefetchScheduler_androidKt$RobolectricImpl$1 prefetchScheduler_androidKt$RobolectricImpl$1 = RobolectricImpl;
        if (prefetchScheduler_androidKt$RobolectricImpl$1 != null) {
            composer.startReplaceGroup(1213893039);
            composer.endReplaceGroup();
            androidPrefetchScheduler = prefetchScheduler_androidKt$RobolectricImpl$1;
        } else {
            composer.startReplaceGroup(1213931944);
            ComposerKt.sourceInformation(composer, "36@1323L7,37@1339L49");
            ProvidableCompositionLocal<View> localView = AndroidCompositionLocals_androidKt.getLocalView();
            ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume = composer.consume(localView);
            ComposerKt.sourceInformationMarkerEnd(composer);
            View view = (View) objConsume;
            ComposerKt.sourceInformationMarkerStart(composer, -930670779, "CC(remember):PrefetchScheduler.android.kt#9igjgp");
            boolean zChanged = composer.changed(view);
            Object objRememberedValue = composer.rememberedValue();
            if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                objRememberedValue = new AndroidPrefetchScheduler(view);
                composer.updateRememberedValue(objRememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composer);
            composer.endReplaceGroup();
            androidPrefetchScheduler = (AndroidPrefetchScheduler) objRememberedValue;
        }
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return androidPrefetchScheduler;
    }

    static {
        String lowerCase = Build.FINGERPRINT.toLowerCase(Locale.ROOT);
        Intrinsics.checkNotNullExpressionValue(lowerCase, "this as java.lang.String).toLowerCase(Locale.ROOT)");
        RobolectricImpl = Intrinsics.areEqual(lowerCase, "robolectric") ? new PrefetchScheduler() {
            @Override
            public void schedulePrefetch(PrefetchRequest prefetchRequest) {
            }
        } : 0;
    }
}
