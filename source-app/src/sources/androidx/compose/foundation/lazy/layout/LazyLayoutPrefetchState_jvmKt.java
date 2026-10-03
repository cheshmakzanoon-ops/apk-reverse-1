package androidx.compose.foundation.lazy.layout;

import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;

@Metadata(d1 = {"\u0000\u0012\n\u0000\n\u0002\u0010\t\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0000\u001a\u0017\u0010\u0000\u001a\u00020\u00012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003H\u0080\b¨\u0006\u0005"}, d2 = {"measureNanoTime", "", "doMeasure", "Lkotlin/Function0;", "", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class LazyLayoutPrefetchState_jvmKt {
    public static final long measureNanoTime(Function0<Unit> function0) {
        long jNanoTime = System.nanoTime();
        function0.invoke();
        return System.nanoTime() - jNanoTime;
    }
}
