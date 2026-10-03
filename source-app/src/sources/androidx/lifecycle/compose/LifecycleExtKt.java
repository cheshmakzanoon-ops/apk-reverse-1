package androidx.lifecycle.compose;

import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.SnapshotStateKt;
import androidx.compose.runtime.State;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.lifecycle.Lifecycle;
import kotlin.Metadata;
import kotlin.coroutines.CoroutineContext;

@Metadata(d1 = {"\u0000\u0012\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\u001a\u0017\u0010\u0000\u001a\b\u0012\u0004\u0012\u00020\u00020\u0001*\u00020\u0003H\u0007¢\u0006\u0002\u0010\u0004¨\u0006\u0005"}, d2 = {"currentStateAsState", "Landroidx/compose/runtime/State;", "Landroidx/lifecycle/Lifecycle$State;", "Landroidx/lifecycle/Lifecycle;", "(Landroidx/lifecycle/Lifecycle;Landroidx/compose/runtime/Composer;I)Landroidx/compose/runtime/State;", "lifecycle-runtime-compose_release"}, k = 2, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class LifecycleExtKt {
    public static final State<Lifecycle.State> currentStateAsState(Lifecycle lifecycle, Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, -1892357376, "C(currentStateAsState)31@1273L16:LifecycleExt.kt#2vxrgp");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-1892357376, i, -1, "androidx.lifecycle.compose.currentStateAsState (LifecycleExt.kt:31)");
        }
        State<Lifecycle.State> stateCollectAsState = SnapshotStateKt.collectAsState(lifecycle.getCurrentStateFlow(), (CoroutineContext) null, composer, 0, 1);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return stateCollectAsState;
    }
}
