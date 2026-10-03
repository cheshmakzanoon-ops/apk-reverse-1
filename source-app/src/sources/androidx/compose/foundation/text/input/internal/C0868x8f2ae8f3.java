package androidx.compose.foundation.text.input.internal;

import androidx.compose.p002ui.graphics.Matrix;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.FunctionReferenceImpl;
import kotlin.jvm.internal.Intrinsics;

@Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
class C0868x8f2ae8f3 extends FunctionReferenceImpl implements Function1<Matrix, Unit> {
    final LegacyPlatformTextInputServiceAdapter.LegacyPlatformTextInputNode $node;

    C0868x8f2ae8f3(LegacyPlatformTextInputServiceAdapter.LegacyPlatformTextInputNode legacyPlatformTextInputNode) {
        super(1, Intrinsics.Kotlin.class, "localToScreen", "startInput$localToScreen(Landroidx/compose/foundation/text/input/internal/LegacyPlatformTextInputServiceAdapter$LegacyPlatformTextInputNode;[F)V", 0);
        this.$node = legacyPlatformTextInputNode;
    }

    public Object invoke(Object obj) {
        m1605invoke58bKbWc(((Matrix) obj).m4849unboximpl());
        return Unit.INSTANCE;
    }

    public final void m1605invoke58bKbWc(float[] fArr) {
        AndroidLegacyPlatformTextInputServiceAdapter.startInput$localToScreen(this.$node, fArr);
    }
}
