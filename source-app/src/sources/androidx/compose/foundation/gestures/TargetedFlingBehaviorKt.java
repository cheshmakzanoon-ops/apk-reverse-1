package androidx.compose.foundation.gestures;

import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;

@Metadata(d1 = {"\u0000\u0010\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0007\n\u0002\u0010\u0002\n\u0000\"\u001a\u0010\u0000\u001a\u000e\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u00030\u0001X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0004"}, d2 = {"NoOnReport", "Lkotlin/Function1;", "", "", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class TargetedFlingBehaviorKt {
    private static final Function1<Float, Unit> NoOnReport = new Function1<Float, Unit>() {
        public final void invoke(float f) {
        }

        public Object invoke(Object obj) {
            invoke(((Number) obj).floatValue());
            return Unit.INSTANCE;
        }
    };
}
