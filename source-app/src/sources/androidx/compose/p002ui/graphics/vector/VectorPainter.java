package androidx.compose.p002ui.graphics.vector;

import androidx.autofill.HintConstants;
import androidx.compose.p002ui.geometry.Size;
import androidx.compose.p002ui.graphics.ColorFilter;
import androidx.compose.p002ui.graphics.drawscope.DrawContext;
import androidx.compose.p002ui.graphics.drawscope.DrawScope;
import androidx.compose.p002ui.graphics.painter.Painter;
import androidx.compose.runtime.Composition;
import androidx.compose.runtime.MutableIntState;
import androidx.compose.runtime.MutableState;
import androidx.compose.runtime.SnapshotIntStateKt;
import androidx.compose.runtime.SnapshotStateKt__SnapshotStateKt;
import androidx.compose.ui.unit.LayoutDirection;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u0000`\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u0007\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0010\u000e\n\u0002\b\u000b\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\b\u0007\u0018\u00002\u00020\u0001B\u0011\b\u0000\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\u0010\u0010@\u001a\u00020\u00062\u0006\u0010A\u001a\u00020\u0019H\u0014J\u0012\u0010B\u001a\u00020\u00062\b\u0010C\u001a\u0004\u0018\u00010\u001bH\u0014J\f\u0010D\u001a\u00020E*\u00020FH\u0014R+\u0010\u0007\u001a\u00020\u00062\u0006\u0010\u0005\u001a\u00020\u00068@@@X\u0080\u008e\u0002¢\u0006\u0012\n\u0004\b\f\u0010\r\u001a\u0004\b\b\u0010\t\"\u0004\b\n\u0010\u000bR\u001a\u0010\u000e\u001a\u00020\u000f8@X\u0080\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\u0010\u0010\u0011R\u001c\u0010\u0012\u001a\u0004\u0018\u00010\u0013X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0014\u0010\u0015\"\u0004\b\u0016\u0010\u0017R\u000e\u0010\u0018\u001a\u00020\u0019X\u0082\u000e¢\u0006\u0002\n\u0000R\u0010\u0010\u001a\u001a\u0004\u0018\u00010\u001bX\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u001c\u001a\u00020\u001dX\u0082\u000e¢\u0006\u0002\n\u0000R(\u0010\u001f\u001a\u0004\u0018\u00010\u001b2\b\u0010\u001e\u001a\u0004\u0018\u00010\u001b8@@@X\u0080\u000e¢\u0006\f\u001a\u0004\b \u0010!\"\u0004\b\"\u0010#R\u001a\u0010$\u001a\u00020%8VX\u0096\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b&\u0010'R+\u0010(\u001a\u00020\u001d2\u0006\u0010\u0005\u001a\u00020\u001d8B@BX\u0082\u008e\u0002¢\u0006\u0012\n\u0004\b,\u0010-\u001a\u0004\b)\u0010\u0011\"\u0004\b*\u0010+R$\u0010/\u001a\u00020.2\u0006\u0010\u001e\u001a\u00020.8@@@X\u0080\u000e¢\u0006\f\u001a\u0004\b0\u00101\"\u0004\b2\u00103R1\u00104\u001a\u00020%2\u0006\u0010\u0005\u001a\u00020%8@@@X\u0080\u008e\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0012\n\u0004\b8\u0010\r\u001a\u0004\b5\u0010'\"\u0004\b6\u00107R\u0014\u00109\u001a\u00020:X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b;\u0010<R*\u0010=\u001a\u00020%2\u0006\u0010\u001e\u001a\u00020%8@@@X\u0080\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\f\u001a\u0004\b>\u0010'\"\u0004\b?\u00107\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006G"}, d2 = {"Landroidx/compose/ui/graphics/vector/VectorPainter;", "Landroidx/compose/ui/graphics/painter/Painter;", "root", "Landroidx/compose/ui/graphics/vector/GroupComponent;", "(Landroidx/compose/ui/graphics/vector/GroupComponent;)V", "<set-?>", "", "autoMirror", "getAutoMirror$ui_release", "()Z", "setAutoMirror$ui_release", "(Z)V", "autoMirror$delegate", "Landroidx/compose/runtime/MutableState;", "bitmapConfig", "Landroidx/compose/ui/graphics/ImageBitmapConfig;", "getBitmapConfig-_sVssgQ$ui_release", "()I", "composition", "Landroidx/compose/runtime/Composition;", "getComposition$ui_release", "()Landroidx/compose/runtime/Composition;", "setComposition$ui_release", "(Landroidx/compose/runtime/Composition;)V", "currentAlpha", "", "currentColorFilter", "Landroidx/compose/ui/graphics/ColorFilter;", "drawCount", "", "value", "intrinsicColorFilter", "getIntrinsicColorFilter$ui_release", "()Landroidx/compose/ui/graphics/ColorFilter;", "setIntrinsicColorFilter$ui_release", "(Landroidx/compose/ui/graphics/ColorFilter;)V", "intrinsicSize", "Landroidx/compose/ui/geometry/Size;", "getIntrinsicSize-NH-jbRc", "()J", "invalidateCount", "getInvalidateCount", "setInvalidateCount", "(I)V", "invalidateCount$delegate", "Landroidx/compose/runtime/MutableIntState;", "", HintConstants.AUTOFILL_HINT_NAME, "getName$ui_release", "()Ljava/lang/String;", "setName$ui_release", "(Ljava/lang/String;)V", "size", "getSize-NH-jbRc$ui_release", "setSize-uvyYCjk$ui_release", "(J)V", "size$delegate", "vector", "Landroidx/compose/ui/graphics/vector/VectorComponent;", "getVector$ui_release", "()Landroidx/compose/ui/graphics/vector/VectorComponent;", "viewportSize", "getViewportSize-NH-jbRc$ui_release", "setViewportSize-uvyYCjk$ui_release", "applyAlpha", "alpha", "applyColorFilter", "colorFilter", "onDraw", "", "Landroidx/compose/ui/graphics/drawscope/DrawScope;", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class VectorPainter extends Painter {
    public static final int $stable = 8;

    private final MutableState autoMirror;
    private Composition composition;
    private float currentAlpha;
    private ColorFilter currentColorFilter;
    private int drawCount;

    private final MutableIntState invalidateCount;

    private final MutableState size;
    private final VectorComponent vector;

    public VectorPainter() {
        GroupComponent groupComponent = null;
        this(groupComponent, 1, groupComponent);
    }

    public VectorPainter(GroupComponent groupComponent) {
        this.size = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(Size.m4403boximpl(Size.INSTANCE.m4424getZeroNHjbRc()), null, 2, null);
        this.autoMirror = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(false, null, 2, null);
        VectorComponent vectorComponent = new VectorComponent(groupComponent);
        vectorComponent.setInvalidateCallback$ui_release(new Function0<Unit>() {
            {
                super(0);
            }

            public Object invoke() {
                m5345invoke();
                return Unit.INSTANCE;
            }

            public final void m5345invoke() {
                if (this.this$0.drawCount == this.this$0.getInvalidateCount()) {
                    VectorPainter vectorPainter = this.this$0;
                    vectorPainter.setInvalidateCount(vectorPainter.getInvalidateCount() + 1);
                }
            }
        });
        this.vector = vectorComponent;
        this.invalidateCount = SnapshotIntStateKt.mutableIntStateOf(0);
        this.currentAlpha = 1.0f;
        this.drawCount = -1;
    }

    public VectorPainter(GroupComponent groupComponent, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? new GroupComponent() : groupComponent);
    }

    public final long m5341getSizeNHjbRc$ui_release() {
        return ((Size) this.size.getValue()).getPackedValue();
    }

    public final void m5343setSizeuvyYCjk$ui_release(long j) {
        this.size.setValue(Size.m4403boximpl(j));
    }

    public final boolean getAutoMirror$ui_release() {
        return ((Boolean) this.autoMirror.getValue()).booleanValue();
    }

    public final void setAutoMirror$ui_release(boolean z) {
        this.autoMirror.setValue(Boolean.valueOf(z));
    }

    public final ColorFilter getIntrinsicColorFilter$ui_release() {
        return this.vector.getIntrinsicColorFilter$ui_release();
    }

    public final void setIntrinsicColorFilter$ui_release(ColorFilter colorFilter) {
        this.vector.setIntrinsicColorFilter$ui_release(colorFilter);
    }

    public final long m5342getViewportSizeNHjbRc$ui_release() {
        return this.vector.m5330getViewportSizeNHjbRc$ui_release();
    }

    public final void m5344setViewportSizeuvyYCjk$ui_release(long j) {
        this.vector.m5331setViewportSizeuvyYCjk$ui_release(j);
    }

    public final String getName$ui_release() {
        return this.vector.getName();
    }

    public final void setName$ui_release(String str) {
        this.vector.setName(str);
    }

    public final VectorComponent getVector() {
        return this.vector;
    }

    public final int m5340getBitmapConfig_sVssgQ$ui_release() {
        return this.vector.m5329getCacheBitmapConfig_sVssgQ$ui_release();
    }

    public final Composition getComposition() {
        return this.composition;
    }

    public final void setComposition$ui_release(Composition composition) {
        this.composition = composition;
    }

    public final int getInvalidateCount() {
        return this.invalidateCount.getIntValue();
    }

    public final void setInvalidateCount(int i) {
        this.invalidateCount.setIntValue(i);
    }

    @Override
    public long getIntrinsicSize() {
        return m5341getSizeNHjbRc$ui_release();
    }

    @Override
    protected void onDraw(DrawScope drawScope) {
        VectorComponent vectorComponent = this.vector;
        ColorFilter intrinsicColorFilter$ui_release = this.currentColorFilter;
        if (intrinsicColorFilter$ui_release == null) {
            intrinsicColorFilter$ui_release = vectorComponent.getIntrinsicColorFilter$ui_release();
        }
        if (!getAutoMirror$ui_release() || drawScope.getLayoutDirection() != LayoutDirection.Rtl) {
            vectorComponent.draw(drawScope, this.currentAlpha, intrinsicColorFilter$ui_release);
        } else {
            long jMo5082getCenterF1C5BW0 = drawScope.mo5082getCenterF1C5BW0();
            DrawContext drawContext = drawScope.getDrawContext();
            long jMo5102getSizeNHjbRc = drawContext.mo5102getSizeNHjbRc();
            drawContext.getCanvas().save();
            try {
                drawContext.getTransform().mo5109scale0AR0LA0(-1.0f, 1.0f, jMo5082getCenterF1C5BW0);
                vectorComponent.draw(drawScope, this.currentAlpha, intrinsicColorFilter$ui_release);
                drawContext.getCanvas().restore();
                drawContext.mo5103setSizeuvyYCjk(jMo5102getSizeNHjbRc);
            } catch (Throwable th) {
                drawContext.getCanvas().restore();
                drawContext.mo5103setSizeuvyYCjk(jMo5102getSizeNHjbRc);
                throw th;
            }
        }
        this.drawCount = getInvalidateCount();
    }

    @Override
    protected boolean applyAlpha(float alpha) {
        this.currentAlpha = alpha;
        return true;
    }

    @Override
    protected boolean applyColorFilter(ColorFilter colorFilter) {
        this.currentColorFilter = colorFilter;
        return true;
    }
}
