package androidx.compose.p002ui.graphics;

import android.graphics.Shader;
import androidx.compose.p002ui.geometry.Size;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u00004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0007\n\u0002\b\u0006\b'\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J(\u0010\t\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\u00042\u0006\u0010\f\u001a\u00020\r2\u0006\u0010\u000e\u001a\u00020\u000fø\u0001\u0000¢\u0006\u0004\b\u0010\u0010\u0011J\u001e\u0010\u0012\u001a\u00060\u0007j\u0002`\b2\u0006\u0010\u000b\u001a\u00020\u0004H&ø\u0001\u0000¢\u0006\u0004\b\u0013\u0010\u0014R\u0016\u0010\u0003\u001a\u00020\u0004X\u0082\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\n\u0002\u0010\u0005R\u0016\u0010\u0006\u001a\n\u0018\u00010\u0007j\u0004\u0018\u0001`\bX\u0082\u000e¢\u0006\u0002\n\u0000\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u0015"}, d2 = {"Landroidx/compose/ui/graphics/ShaderBrush;", "Landroidx/compose/ui/graphics/Brush;", "()V", "createdSize", "Landroidx/compose/ui/geometry/Size;", "J", "internalShader", "Landroid/graphics/Shader;", "Landroidx/compose/ui/graphics/Shader;", "applyTo", "", "size", "p", "Landroidx/compose/ui/graphics/Paint;", "alpha", "", "applyTo-Pq9zytI", "(JLandroidx/compose/ui/graphics/Paint;F)V", "createShader", "createShader-uvyYCjk", "(J)Landroid/graphics/Shader;", "ui-graphics_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public abstract class ShaderBrush extends Brush {
    private long createdSize;
    private Shader internalShader;

    public abstract Shader mo4559createShaderuvyYCjk(long size);

    public ShaderBrush() {
        super(null);
        this.createdSize = Size.INSTANCE.m4423getUnspecifiedNHjbRc();
    }

    @Override
    public final void mo4537applyToPq9zytI(long size, Paint p, float alpha) {
        Shader shaderMo4559createShaderuvyYCjk = this.internalShader;
        if (shaderMo4559createShaderuvyYCjk == null || !Size.m4411equalsimpl0(this.createdSize, size)) {
            if (Size.m4417isEmptyimpl(size)) {
                shaderMo4559createShaderuvyYCjk = null;
                this.internalShader = null;
                this.createdSize = Size.INSTANCE.m4423getUnspecifiedNHjbRc();
            } else {
                shaderMo4559createShaderuvyYCjk = mo4559createShaderuvyYCjk(size);
                this.internalShader = shaderMo4559createShaderuvyYCjk;
                this.createdSize = size;
            }
        }
        if (!Color.m4591equalsimpl0(p.mo4461getColor0d7_KjU(), Color.INSTANCE.m4616getBlack0d7_KjU())) {
            p.mo4467setColor8_81llA(Color.INSTANCE.m4616getBlack0d7_KjU());
        }
        if (!Intrinsics.areEqual(p.getShader(), shaderMo4559createShaderuvyYCjk)) {
            p.setShader(shaderMo4559createShaderuvyYCjk);
        }
        if (p.getAlpha() == alpha) {
            return;
        }
        p.setAlpha(alpha);
    }
}
