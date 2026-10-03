package androidx.compose.foundation;

import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.layout.LayoutCoordinates;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;

@Metadata(d1 = {"\u0000\u0016\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0000\u001a\"\u0010\u0000\u001a\u00020\u0001*\u00020\u00012\u0014\u0010\u0002\u001a\u0010\u0012\u0006\u0012\u0004\u0018\u00010\u0004\u0012\u0004\u0012\u00020\u00050\u0003H\u0007¨\u0006\u0006"}, d2 = {"onFocusedBoundsChanged", "Landroidx/compose/ui/Modifier;", "onPositioned", "Lkotlin/Function1;", "Landroidx/compose/ui/layout/LayoutCoordinates;", "", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class FocusedBoundsKt {
    public static final Modifier onFocusedBoundsChanged(Modifier modifier, Function1<? super LayoutCoordinates, Unit> function1) {
        return modifier.then(new FocusedBoundsObserverElement(function1));
    }
}
