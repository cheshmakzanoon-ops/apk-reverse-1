package androidx.compose.foundation.text.handwriting;

import androidx.compose.foundation.layout.PaddingKt;
import androidx.compose.p002ui.Modifier;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;

@Metadata(d1 = {"\u0000\u0012\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0000\u001a\u0018\u0010\u0000\u001a\u00020\u0001*\u00020\u00012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¨\u0006\u0005"}, d2 = {"handwritingDetector", "Landroidx/compose/ui/Modifier;", "callback", "Lkotlin/Function0;", "", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class HandwritingDetector_androidKt {
    public static final Modifier handwritingDetector(Modifier modifier, Function0<Unit> function0) {
        return StylusHandwriting_androidKt.isStylusHandwritingSupported() ? PaddingKt.m1036paddingVpY3zN4(modifier.then(new HandwritingDetectorElement(function0)), StylusHandwritingKt.getHandwritingBoundsHorizontalOffset(), StylusHandwritingKt.getHandwritingBoundsVerticalOffset()) : modifier;
    }
}
