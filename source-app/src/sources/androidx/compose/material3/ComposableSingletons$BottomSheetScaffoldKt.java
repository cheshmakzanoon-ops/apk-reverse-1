package androidx.compose.material3;

import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;

@Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
public final class ComposableSingletons$BottomSheetScaffoldKt {
    public static final ComposableSingletons$BottomSheetScaffoldKt INSTANCE = new ComposableSingletons$BottomSheetScaffoldKt();

    public static Function2<Composer, Integer, Unit> f196lambda1 = ComposableLambdaKt.composableLambdaInstance(-927355320, false, new Function2<Composer, Integer, Unit>() {
        public Object invoke(Object obj, Object obj2) {
            invoke((Composer) obj, ((Number) obj2).intValue());
            return Unit.INSTANCE;
        }

        public final void invoke(Composer composer, int i) {
            ComposerKt.sourceInformation(composer, "C120@6516L12:BottomSheetScaffold.kt#uh7d8r");
            if ((i & 3) == 2 && composer.getSkipping()) {
                composer.skipToGroupEnd();
                return;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-927355320, i, -1, "androidx.compose.material3.ComposableSingletons$BottomSheetScaffoldKt.lambda-1.<anonymous> (BottomSheetScaffold.kt:120)");
            }
            BottomSheetDefaults.INSTANCE.m2028DragHandlelgZ2HuY(null, 0.0f, 0.0f, null, 0L, composer, 196608, 31);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        }
    });

    public static Function3<SnackbarHostState, Composer, Integer, Unit> f197lambda2 = ComposableLambdaKt.composableLambdaInstance(923568898, false, new Function3<SnackbarHostState, Composer, Integer, Unit>() {
        public Object invoke(Object obj, Object obj2, Object obj3) {
            invoke((SnackbarHostState) obj, (Composer) obj2, ((Number) obj3).intValue());
            return Unit.INSTANCE;
        }

        public final void invoke(SnackbarHostState snackbarHostState, Composer composer, int i) {
            ComposerKt.sourceInformation(composer, "C123@6679L16:BottomSheetScaffold.kt#uh7d8r");
            if ((i & 6) == 0) {
                i |= composer.changed(snackbarHostState) ? 4 : 2;
            }
            if ((i & 19) == 18 && composer.getSkipping()) {
                composer.skipToGroupEnd();
                return;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(923568898, i, -1, "androidx.compose.material3.ComposableSingletons$BottomSheetScaffoldKt.lambda-2.<anonymous> (BottomSheetScaffold.kt:123)");
            }
            SnackbarHostKt.SnackbarHost(snackbarHostState, null, null, composer, i & 14, 6);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        }
    });

    public static Function2<Composer, Integer, Unit> f198lambda3 = ComposableLambdaKt.composableLambdaInstance(1800698411, false, new Function2<Composer, Integer, Unit>() {
        public Object invoke(Object obj, Object obj2) {
            invoke((Composer) obj, ((Number) obj2).intValue());
            return Unit.INSTANCE;
        }

        public final void invoke(Composer composer, int i) {
            ComposerKt.sourceInformation(composer, "C:BottomSheetScaffold.kt#uh7d8r");
            if ((i & 3) == 2 && composer.getSkipping()) {
                composer.skipToGroupEnd();
                return;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1800698411, i, -1, "androidx.compose.material3.ComposableSingletons$BottomSheetScaffoldKt.lambda-3.<anonymous> (BottomSheetScaffold.kt:358)");
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        }
    });

    public final Function2<Composer, Integer, Unit> m2203getLambda1$material3_release() {
        return f196lambda1;
    }

    public final Function3<SnackbarHostState, Composer, Integer, Unit> m2204getLambda2$material3_release() {
        return f197lambda2;
    }

    public final Function2<Composer, Integer, Unit> m2205getLambda3$material3_release() {
        return f198lambda3;
    }
}
