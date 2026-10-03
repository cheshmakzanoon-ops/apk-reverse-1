package androidx.compose.p002ui.platform;

import androidx.compose.p002ui.draganddrop.DragAndDropTransferData;
import androidx.compose.p002ui.geometry.Size;
import androidx.compose.p002ui.graphics.drawscope.DrawScope;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.FunctionReferenceImpl;

@Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
class AndroidComposeView$dragAndDropModifierOnDragListener$1 extends FunctionReferenceImpl implements Function3<DragAndDropTransferData, Size, Function1<? super DrawScope, ? extends Unit>, Boolean> {
    AndroidComposeView$dragAndDropModifierOnDragListener$1(Object obj) {
        super(3, obj, AndroidComposeView.class, "startDrag", "startDrag-12SF9DM(Landroidx/compose/ui/draganddrop/DragAndDropTransferData;JLkotlin/jvm/functions/Function1;)Z", 0);
    }

    public Object invoke(Object obj, Object obj2, Object obj3) {
        return m6462invoke12SF9DM((DragAndDropTransferData) obj, ((Size) obj2).getPackedValue(), (Function1) obj3);
    }

    public final Boolean m6462invoke12SF9DM(DragAndDropTransferData dragAndDropTransferData, long j, Function1<? super DrawScope, Unit> function1) {
        return Boolean.valueOf(((AndroidComposeView) this.receiver).m6456startDrag12SF9DM(dragAndDropTransferData, j, function1));
    }
}
