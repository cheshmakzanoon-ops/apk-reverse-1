package androidx.compose.foundation.text;

import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;

@Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
public final class ComposableSingletons$BasicTextFieldKt {
    public static final ComposableSingletons$BasicTextFieldKt INSTANCE = new ComposableSingletons$BasicTextFieldKt();

    public static Function3<Function2<? super Composer, ? super Integer, Unit>, Composer, Integer, Unit> f173lambda1 = ComposableLambdaKt.composableLambdaInstance(997835932, false, new Function3<Function2<? super Composer, ? super Integer, ? extends Unit>, Composer, Integer, Unit>() {
        public Object invoke(Object obj, Object obj2, Object obj3) {
            invoke((Function2<? super Composer, ? super Integer, Unit>) obj, (Composer) obj2, ((Number) obj3).intValue());
            return Unit.INSTANCE;
        }

        public final void invoke(Function2<? super Composer, ? super Integer, Unit> function2, Composer composer, int i) {
            ComposerKt.sourceInformation(composer, "C609@30998L16:BasicTextField.kt#423gt5");
            if ((i & 6) == 0) {
                i |= composer.changedInstance(function2) ? 4 : 2;
            }
            if ((i & 19) == 18 && composer.getSkipping()) {
                composer.skipToGroupEnd();
                return;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(997835932, i, -1, "androidx.compose.foundation.text.ComposableSingletons$BasicTextFieldKt.lambda-1.<anonymous> (BasicTextField.kt:609)");
            }
            function2.invoke(composer, Integer.valueOf(i & 14));
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        }
    });

    public static Function3<Function2<? super Composer, ? super Integer, Unit>, Composer, Integer, Unit> f174lambda2 = ComposableLambdaKt.composableLambdaInstance(2105616367, false, new Function3<Function2<? super Composer, ? super Integer, ? extends Unit>, Composer, Integer, Unit>() {
        public Object invoke(Object obj, Object obj2, Object obj3) {
            invoke((Function2<? super Composer, ? super Integer, Unit>) obj, (Composer) obj2, ((Number) obj3).intValue());
            return Unit.INSTANCE;
        }

        public final void invoke(Function2<? super Composer, ? super Integer, Unit> function2, Composer composer, int i) {
            ComposerKt.sourceInformation(composer, "C761@39892L16:BasicTextField.kt#423gt5");
            if ((i & 6) == 0) {
                i |= composer.changedInstance(function2) ? 4 : 2;
            }
            if ((i & 19) == 18 && composer.getSkipping()) {
                composer.skipToGroupEnd();
                return;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(2105616367, i, -1, "androidx.compose.foundation.text.ComposableSingletons$BasicTextFieldKt.lambda-2.<anonymous> (BasicTextField.kt:761)");
            }
            function2.invoke(composer, Integer.valueOf(i & 14));
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        }
    });

    public static Function3<Function2<? super Composer, ? super Integer, Unit>, Composer, Integer, Unit> f175lambda3 = ComposableLambdaKt.composableLambdaInstance(434140383, false, new Function3<Function2<? super Composer, ? super Integer, ? extends Unit>, Composer, Integer, Unit>() {
        public Object invoke(Object obj, Object obj2, Object obj3) {
            invoke((Function2<? super Composer, ? super Integer, Unit>) obj, (Composer) obj2, ((Number) obj3).intValue());
            return Unit.INSTANCE;
        }

        public final void invoke(Function2<? super Composer, ? super Integer, Unit> function2, Composer composer, int i) {
            ComposerKt.sourceInformation(composer, "C805@41562L16:BasicTextField.kt#423gt5");
            if ((i & 6) == 0) {
                i |= composer.changedInstance(function2) ? 4 : 2;
            }
            if ((i & 19) == 18 && composer.getSkipping()) {
                composer.skipToGroupEnd();
                return;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(434140383, i, -1, "androidx.compose.foundation.text.ComposableSingletons$BasicTextFieldKt.lambda-3.<anonymous> (BasicTextField.kt:805)");
            }
            function2.invoke(composer, Integer.valueOf(i & 14));
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        }
    });

    public static Function3<Function2<? super Composer, ? super Integer, Unit>, Composer, Integer, Unit> f176lambda4 = ComposableLambdaKt.composableLambdaInstance(-34833998, false, new Function3<Function2<? super Composer, ? super Integer, ? extends Unit>, Composer, Integer, Unit>() {
        public Object invoke(Object obj, Object obj2, Object obj3) {
            invoke((Function2<? super Composer, ? super Integer, Unit>) obj, (Composer) obj2, ((Number) obj3).intValue());
            return Unit.INSTANCE;
        }

        public final void invoke(Function2<? super Composer, ? super Integer, Unit> function2, Composer composer, int i) {
            ComposerKt.sourceInformation(composer, "C845@43087L16:BasicTextField.kt#423gt5");
            if ((i & 6) == 0) {
                i |= composer.changedInstance(function2) ? 4 : 2;
            }
            if ((i & 19) == 18 && composer.getSkipping()) {
                composer.skipToGroupEnd();
                return;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-34833998, i, -1, "androidx.compose.foundation.text.ComposableSingletons$BasicTextFieldKt.lambda-4.<anonymous> (BasicTextField.kt:845)");
            }
            function2.invoke(composer, Integer.valueOf(i & 14));
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        }
    });

    public final Function3<Function2<? super Composer, ? super Integer, Unit>, Composer, Integer, Unit> m1433getLambda1$foundation_release() {
        return f173lambda1;
    }

    public final Function3<Function2<? super Composer, ? super Integer, Unit>, Composer, Integer, Unit> m1434getLambda2$foundation_release() {
        return f174lambda2;
    }

    public final Function3<Function2<? super Composer, ? super Integer, Unit>, Composer, Integer, Unit> m1435getLambda3$foundation_release() {
        return f175lambda3;
    }

    public final Function3<Function2<? super Composer, ? super Integer, Unit>, Composer, Integer, Unit> m1436getLambda4$foundation_release() {
        return f176lambda4;
    }
}
