package androidx.compose.foundation.gestures;

import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.SnapshotStateKt;
import androidx.compose.runtime.State;
import kotlin.Metadata;
import kotlin.jvm.functions.Function1;

@Metadata(d1 = {"\u0000\u0014\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0007\n\u0002\b\u0003\u001a\u001a\u0010\u0000\u001a\u00020\u00012\u0012\u0010\u0002\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00040\u0003\u001a!\u0010\u0005\u001a\u00020\u00012\u0012\u0010\u0002\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00040\u0003H\u0007¢\u0006\u0002\u0010\u0006¨\u0006\u0007"}, d2 = {"ScrollableState", "Landroidx/compose/foundation/gestures/ScrollableState;", "consumeScrollDelta", "Lkotlin/Function1;", "", "rememberScrollableState", "(Lkotlin/jvm/functions/Function1;Landroidx/compose/runtime/Composer;I)Landroidx/compose/foundation/gestures/ScrollableState;", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class ScrollableStateKt {
    public static final ScrollableState ScrollableState(Function1<? super Float, Float> function1) {
        return new DefaultScrollableState(function1);
    }

    public static final ScrollableState rememberScrollableState(Function1<? super Float, Float> function1, Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, -180460798, "C(rememberScrollableState)162@7610L40,163@7662L61:ScrollableState.kt#8bwon0");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-180460798, i, -1, "androidx.compose.foundation.gestures.rememberScrollableState (ScrollableState.kt:161)");
        }
        final State stateRememberUpdatedState = SnapshotStateKt.rememberUpdatedState(function1, composer, i & 14);
        ComposerKt.sourceInformationMarkerStart(composer, 2119060080, "CC(remember):ScrollableState.kt#9igjgp");
        Object objRememberedValue = composer.rememberedValue();
        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
            objRememberedValue = ScrollableState(new Function1<Float, Float>() {
                {
                    super(1);
                }

                public final Float invoke(float f) {
                    return (Float) stateRememberUpdatedState.getValue().invoke(Float.valueOf(f));
                }

                public Object invoke(Object obj) {
                    return invoke(((Number) obj).floatValue());
                }
            });
            composer.updateRememberedValue(objRememberedValue);
        }
        ScrollableState scrollableState = (ScrollableState) objRememberedValue;
        ComposerKt.sourceInformationMarkerEnd(composer);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return scrollableState;
    }
}
