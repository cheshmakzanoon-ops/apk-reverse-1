package androidx.compose.p002ui.graphics.vector;

import androidx.autofill.HintConstants;
import androidx.compose.p002ui.graphics.AndroidPath_androidKt;
import androidx.compose.p002ui.graphics.Brush;
import androidx.compose.p002ui.graphics.Color;
import androidx.compose.p002ui.graphics.Matrix;
import androidx.compose.p002ui.graphics.Path;
import androidx.compose.p002ui.graphics.SolidColor;
import androidx.compose.p002ui.graphics.drawscope.DrawContext;
import androidx.compose.p002ui.graphics.drawscope.DrawScope;
import androidx.compose.p002ui.graphics.drawscope.DrawTransform;
import java.util.ArrayList;
import java.util.List;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;

@Metadata(d1 = {"\u0000n\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010!\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\u0005\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010\u0007\n\u0002\b\u0011\n\u0002\u0018\u0002\n\u0002\b\u0013\n\u0002\u0018\u0002\n\u0002\b\u000f\n\u0002\u0018\u0002\n\u0000\b\u0000\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J\u0016\u0010I\u001a\u00020\u00142\u0006\u0010J\u001a\u00020&2\u0006\u0010K\u001a\u00020\u0001J\b\u0010L\u001a\u00020\u0014H\u0002J\u0012\u0010M\u001a\u00020\u00142\b\u0010N\u001a\u0004\u0018\u00010OH\u0002J\u001a\u0010P\u001a\u00020\u00142\u0006\u0010Q\u001a\u00020;H\u0002ø\u0001\u0000¢\u0006\u0004\bR\u0010SJ\u0010\u0010T\u001a\u00020\u00142\u0006\u0010U\u001a\u00020\u0001H\u0002J\u001e\u0010V\u001a\u00020\u00142\u0006\u0010W\u001a\u00020&2\u0006\u0010X\u001a\u00020&2\u0006\u0010Y\u001a\u00020&J\u0016\u0010Z\u001a\u00020\u00142\u0006\u0010J\u001a\u00020&2\u0006\u0010Y\u001a\u00020&J\b\u0010[\u001a\u00020\u001fH\u0016J\b\u0010\\\u001a\u00020\u0014H\u0002J\b\u0010]\u001a\u00020\u0014H\u0002J\f\u0010^\u001a\u00020\u0014*\u00020_H\u0016R\u0014\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00010\u0004X\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\u0005\u001a\u0004\u0018\u00010\u0006X\u0082\u000e¢\u0006\u0002\n\u0000R0\u0010\n\u001a\b\u0012\u0004\u0012\u00020\t0\b2\f\u0010\u0007\u001a\b\u0012\u0004\u0012\u00020\t0\b@FX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u000b\u0010\f\"\u0004\b\r\u0010\u000eR\u0018\u0010\u000f\u001a\u0004\u0018\u00010\u0010X\u0082\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\n\u0002\u0010\u0011R(\u0010\u0012\u001a\u0010\u0012\u0004\u0012\u00020\u0001\u0012\u0004\u0012\u00020\u0014\u0018\u00010\u0013X\u0090\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0015\u0010\u0016\"\u0004\b\u0017\u0010\u0018R\u000e\u0010\u0019\u001a\u00020\u001aX\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u001b\u001a\u00020\u001aX\u0082\u000e¢\u0006\u0002\n\u0000R\u001e\u0010\u001d\u001a\u00020\u001a2\u0006\u0010\u001c\u001a\u00020\u001a@BX\u0086\u000e¢\u0006\b\n\u0000\u001a\u0004\b\u001d\u0010\u001eR$\u0010 \u001a\u00020\u001f2\u0006\u0010\u0007\u001a\u00020\u001f@FX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b!\u0010\"\"\u0004\b#\u0010$R\u0011\u0010%\u001a\u00020&8F¢\u0006\u0006\u001a\u0004\b'\u0010(R$\u0010*\u001a\u00020)2\u0006\u0010\u0007\u001a\u00020)@FX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b+\u0010,\"\u0004\b-\u0010.R$\u0010/\u001a\u00020)2\u0006\u0010\u0007\u001a\u00020)@FX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b0\u0010,\"\u0004\b1\u0010.R$\u00102\u001a\u00020)2\u0006\u0010\u0007\u001a\u00020)@FX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b3\u0010,\"\u0004\b4\u0010.R$\u00105\u001a\u00020)2\u0006\u0010\u0007\u001a\u00020)@FX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b6\u0010,\"\u0004\b7\u0010.R$\u00108\u001a\u00020)2\u0006\u0010\u0007\u001a\u00020)@FX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b9\u0010,\"\u0004\b:\u0010.R&\u0010<\u001a\u00020;2\u0006\u0010\u001c\u001a\u00020;@BX\u0086\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010?\u001a\u0004\b=\u0010>R$\u0010@\u001a\u00020)2\u0006\u0010\u0007\u001a\u00020)@FX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bA\u0010,\"\u0004\bB\u0010.R$\u0010C\u001a\u00020)2\u0006\u0010\u0007\u001a\u00020)@FX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bD\u0010,\"\u0004\bE\u0010.R\u0014\u0010F\u001a\u00020\u001a8BX\u0082\u0004¢\u0006\u0006\u001a\u0004\bG\u0010\u001eR\u001a\u0010H\u001a\u000e\u0012\u0004\u0012\u00020\u0001\u0012\u0004\u0012\u00020\u00140\u0013X\u0082\u0004¢\u0006\u0002\n\u0000\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006`"}, d2 = {"Landroidx/compose/ui/graphics/vector/GroupComponent;", "Landroidx/compose/ui/graphics/vector/VNode;", "()V", "children", "", "clipPath", "Landroidx/compose/ui/graphics/Path;", "value", "", "Landroidx/compose/ui/graphics/vector/PathNode;", "clipPathData", "getClipPathData", "()Ljava/util/List;", "setClipPathData", "(Ljava/util/List;)V", "groupMatrix", "Landroidx/compose/ui/graphics/Matrix;", "[F", "invalidateListener", "Lkotlin/Function1;", "", "getInvalidateListener$ui_release", "()Lkotlin/jvm/functions/Function1;", "setInvalidateListener$ui_release", "(Lkotlin/jvm/functions/Function1;)V", "isClipPathDirty", "", "isMatrixDirty", "<set-?>", "isTintable", "()Z", "", HintConstants.AUTOFILL_HINT_NAME, "getName", "()Ljava/lang/String;", "setName", "(Ljava/lang/String;)V", "numChildren", "", "getNumChildren", "()I", "", "pivotX", "getPivotX", "()F", "setPivotX", "(F)V", "pivotY", "getPivotY", "setPivotY", "rotation", "getRotation", "setRotation", "scaleX", "getScaleX", "setScaleX", "scaleY", "getScaleY", "setScaleY", "Landroidx/compose/ui/graphics/Color;", "tintColor", "getTintColor-0d7_KjU", "()J", "J", "translationX", "getTranslationX", "setTranslationX", "translationY", "getTranslationY", "setTranslationY", "willClipPath", "getWillClipPath", "wrappedListener", "insertAt", "index", "instance", "markNotTintable", "markTintForBrush", "brush", "Landroidx/compose/ui/graphics/Brush;", "markTintForColor", "color", "markTintForColor-8_81llA", "(J)V", "markTintForVNode", "node", "move", "from", "to", "count", "remove", "toString", "updateClipPath", "updateMatrix", "draw", "Landroidx/compose/ui/graphics/drawscope/DrawScope;", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class GroupComponent extends VNode {
    public static final int $stable = 8;
    private final List<VNode> children;
    private Path clipPath;
    private List<? extends PathNode> clipPathData;
    private float[] groupMatrix;
    private Function1<? super VNode, Unit> invalidateListener;
    private boolean isClipPathDirty;
    private boolean isMatrixDirty;
    private boolean isTintable;
    private String name;
    private float pivotX;
    private float pivotY;
    private float rotation;
    private float scaleX;
    private float scaleY;
    private long tintColor;
    private float translationX;
    private float translationY;
    private final Function1<VNode, Unit> wrappedListener;

    public GroupComponent() {
        super(null);
        this.children = new ArrayList();
        this.isTintable = true;
        this.tintColor = Color.INSTANCE.m4626getUnspecified0d7_KjU();
        this.clipPathData = VectorKt.getEmptyPath();
        this.isClipPathDirty = true;
        this.wrappedListener = new Function1<VNode, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((VNode) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(VNode vNode) {
                this.this$0.markTintForVNode(vNode);
                Function1<VNode, Unit> invalidateListener$ui_release = this.this$0.getInvalidateListener$ui_release();
                if (invalidateListener$ui_release != null) {
                    invalidateListener$ui_release.invoke(vNode);
                }
            }
        };
        this.name = "";
        this.scaleX = 1.0f;
        this.scaleY = 1.0f;
        this.isMatrixDirty = true;
    }

    public final boolean getIsTintable() {
        return this.isTintable;
    }

    public final long getTintColor() {
        return this.tintColor;
    }

    private final void markTintForBrush(Brush brush) {
        if (this.isTintable && brush != null) {
            if (brush instanceof SolidColor) {
                m5312markTintForColor8_81llA(((SolidColor) brush).getValue());
            } else {
                markNotTintable();
            }
        }
    }

    private final void m5312markTintForColor8_81llA(long color) {
        if (this.isTintable && color != 16) {
            long j = this.tintColor;
            if (j == 16) {
                this.tintColor = color;
            } else {
                if (VectorKt.m5339rgbEqualOWjLjI(j, color)) {
                    return;
                }
                markNotTintable();
            }
        }
    }

    public final void markTintForVNode(VNode node) {
        if (node instanceof PathComponent) {
            PathComponent pathComponent = (PathComponent) node;
            markTintForBrush(pathComponent.getFill());
            markTintForBrush(pathComponent.getStroke());
        } else if (node instanceof GroupComponent) {
            GroupComponent groupComponent = (GroupComponent) node;
            if (groupComponent.isTintable && this.isTintable) {
                m5312markTintForColor8_81llA(groupComponent.tintColor);
            } else {
                markNotTintable();
            }
        }
    }

    private final void markNotTintable() {
        this.isTintable = false;
        this.tintColor = Color.INSTANCE.m4626getUnspecified0d7_KjU();
    }

    public final List<PathNode> getClipPathData() {
        return this.clipPathData;
    }

    public final void setClipPathData(List<? extends PathNode> list) {
        this.clipPathData = list;
        this.isClipPathDirty = true;
        invalidate();
    }

    private final boolean getWillClipPath() {
        return !this.clipPathData.isEmpty();
    }

    @Override
    public Function1<VNode, Unit> getInvalidateListener$ui_release() {
        return this.invalidateListener;
    }

    @Override
    public void setInvalidateListener$ui_release(Function1<? super VNode, Unit> function1) {
        this.invalidateListener = function1;
    }

    private final void updateClipPath() {
        if (getWillClipPath()) {
            Path Path = this.clipPath;
            if (Path == null) {
                Path = AndroidPath_androidKt.Path();
                this.clipPath = Path;
            }
            PathParserKt.toPath(this.clipPathData, Path);
        }
    }

    public final String getName() {
        return this.name;
    }

    public final void setName(String str) {
        this.name = str;
        invalidate();
    }

    public final float getRotation() {
        return this.rotation;
    }

    public final void setRotation(float f) {
        this.rotation = f;
        this.isMatrixDirty = true;
        invalidate();
    }

    public final float getPivotX() {
        return this.pivotX;
    }

    public final void setPivotX(float f) {
        this.pivotX = f;
        this.isMatrixDirty = true;
        invalidate();
    }

    public final float getPivotY() {
        return this.pivotY;
    }

    public final void setPivotY(float f) {
        this.pivotY = f;
        this.isMatrixDirty = true;
        invalidate();
    }

    public final float getScaleX() {
        return this.scaleX;
    }

    public final void setScaleX(float f) {
        this.scaleX = f;
        this.isMatrixDirty = true;
        invalidate();
    }

    public final float getScaleY() {
        return this.scaleY;
    }

    public final void setScaleY(float f) {
        this.scaleY = f;
        this.isMatrixDirty = true;
        invalidate();
    }

    public final float getTranslationX() {
        return this.translationX;
    }

    public final void setTranslationX(float f) {
        this.translationX = f;
        this.isMatrixDirty = true;
        invalidate();
    }

    public final float getTranslationY() {
        return this.translationY;
    }

    public final void setTranslationY(float f) {
        this.translationY = f;
        this.isMatrixDirty = true;
        invalidate();
    }

    public final int getNumChildren() {
        return this.children.size();
    }

    private final void updateMatrix() {
        float[] fArrM4828constructorimpl$default = this.groupMatrix;
        if (fArrM4828constructorimpl$default == null) {
            fArrM4828constructorimpl$default = Matrix.m4828constructorimpl$default(null, 1, null);
            this.groupMatrix = fArrM4828constructorimpl$default;
        } else {
            Matrix.m4837resetimpl(fArrM4828constructorimpl$default);
        }
        Matrix.m4848translateimpl$default(fArrM4828constructorimpl$default, this.pivotX + this.translationX, this.pivotY + this.translationY, 0.0f, 4, null);
        Matrix.m4840rotateZimpl(fArrM4828constructorimpl$default, this.rotation);
        Matrix.m4841scaleimpl(fArrM4828constructorimpl$default, this.scaleX, this.scaleY, 1.0f);
        Matrix.m4848translateimpl$default(fArrM4828constructorimpl$default, -this.pivotX, -this.pivotY, 0.0f, 4, null);
    }

    public final void insertAt(int index, VNode instance) {
        if (index < getNumChildren()) {
            this.children.set(index, instance);
        } else {
            this.children.add(instance);
        }
        markTintForVNode(instance);
        instance.setInvalidateListener$ui_release(this.wrappedListener);
        invalidate();
    }

    public final void move(int from, int to, int count) {
        int i = 0;
        if (from > to) {
            while (i < count) {
                VNode vNode = this.children.get(from);
                this.children.remove(from);
                this.children.add(to, vNode);
                to++;
                i++;
            }
        } else {
            while (i < count) {
                VNode vNode2 = this.children.get(from);
                this.children.remove(from);
                this.children.add(to - 1, vNode2);
                i++;
            }
        }
        invalidate();
    }

    public final void remove(int index, int count) {
        for (int i = 0; i < count; i++) {
            if (index < this.children.size()) {
                this.children.get(index).setInvalidateListener$ui_release(null);
                this.children.remove(index);
            }
        }
        invalidate();
    }

    @Override
    public void draw(DrawScope drawScope) {
        if (this.isMatrixDirty) {
            updateMatrix();
            this.isMatrixDirty = false;
        }
        if (this.isClipPathDirty) {
            updateClipPath();
            this.isClipPathDirty = false;
        }
        DrawContext drawContext = drawScope.getDrawContext();
        long jMo5102getSizeNHjbRc = drawContext.mo5102getSizeNHjbRc();
        drawContext.getCanvas().save();
        try {
            DrawTransform transform = drawContext.getTransform();
            float[] fArr = this.groupMatrix;
            if (fArr != null) {
                transform.mo5110transform58bKbWc((fArr != null ? Matrix.m4826boximpl(fArr) : null).m4849unboximpl());
            }
            Path path = this.clipPath;
            if (getWillClipPath() && path != null) {
                DrawTransform.CC.m5239clipPathmtrdDE$default(transform, path, 0, 2, null);
            }
            List<VNode> list = this.children;
            int size = list.size();
            for (int i = 0; i < size; i++) {
                list.get(i).draw(drawScope);
            }
        } finally {
            drawContext.getCanvas().restore();
            drawContext.mo5103setSizeuvyYCjk(jMo5102getSizeNHjbRc);
        }
    }

    public String toString() {
        StringBuilder sb = new StringBuilder("VGroup: ");
        sb.append(this.name);
        List<VNode> list = this.children;
        int size = list.size();
        for (int i = 0; i < size; i++) {
            VNode vNode = list.get(i);
            sb.append("\t");
            sb.append(vNode.toString());
            sb.append("\n");
        }
        return sb.toString();
    }
}
