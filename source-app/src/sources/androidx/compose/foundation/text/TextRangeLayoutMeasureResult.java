package androidx.compose.foundation.text;

import androidx.compose.ui.unit.IntOffset;
import kotlin.Metadata;
import kotlin.jvm.functions.Function0;

@Metadata(d1 = {"\u0000\u001e\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0007\b\u0000\u0018\u00002\u00020\u0001B%\b\u0000\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003\u0012\f\u0010\u0005\u001a\b\u0012\u0004\u0012\u00020\u00070\u0006¢\u0006\u0002\u0010\bR\u0011\u0010\u0004\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\nR\u0017\u0010\u0005\u001a\b\u0012\u0004\u0012\u00020\u00070\u0006¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\fR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\n¨\u0006\u000e"}, d2 = {"Landroidx/compose/foundation/text/TextRangeLayoutMeasureResult;", "", "width", "", "height", "place", "Lkotlin/Function0;", "Landroidx/compose/ui/unit/IntOffset;", "(IILkotlin/jvm/functions/Function0;)V", "getHeight", "()I", "getPlace", "()Lkotlin/jvm/functions/Function0;", "getWidth", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class TextRangeLayoutMeasureResult {
    public static final int $stable = 0;
    private final int height;
    private final Function0<IntOffset> place;
    private final int width;

    public TextRangeLayoutMeasureResult(int i, int i2, Function0<IntOffset> function0) {
        this.width = i;
        this.height = i2;
        this.place = function0;
    }

    public final int getWidth() {
        return this.width;
    }

    public final int getHeight() {
        return this.height;
    }

    public final Function0<IntOffset> getPlace() {
        return this.place;
    }
}
