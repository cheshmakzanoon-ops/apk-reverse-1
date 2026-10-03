package androidx.compose.foundation;

import android.graphics.Matrix;
import android.graphics.SurfaceTexture;
import android.view.Surface;
import android.view.TextureView;
import androidx.compose.ui.unit.IntSize;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.CoroutineScope;

@Metadata(d1 = {"\u0000H\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0004\b\u0002\u0018\u00002\u00020\u00012\u00020\u0002B\r\u0012\u0006\u0010\u0003\u001a\u00020\u0004¢\u0006\u0002\u0010\u0005J \u0010\u0013\u001a\u00020\u00142\u0006\u0010\u0015\u001a\u00020\u00162\u0006\u0010\u0017\u001a\u00020\u00182\u0006\u0010\u0019\u001a\u00020\u0018H\u0016J\u0010\u0010\u001a\u001a\u00020\u001b2\u0006\u0010\u0015\u001a\u00020\u0016H\u0016J \u0010\u001c\u001a\u00020\u00142\u0006\u0010\u0015\u001a\u00020\u00162\u0006\u0010\u0017\u001a\u00020\u00182\u0006\u0010\u0019\u001a\u00020\u0018H\u0016J\u0010\u0010\u001d\u001a\u00020\u00142\u0006\u0010\u001e\u001a\u00020\u0016H\u0016R\u0011\u0010\u0006\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\tR\"\u0010\n\u001a\u00020\u000bX\u0086\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\u0010\u001a\u0004\b\f\u0010\r\"\u0004\b\u000e\u0010\u000fR\u0010\u0010\u0011\u001a\u0004\u0018\u00010\u0012X\u0082\u000e¢\u0006\u0002\n\u0000\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u001f"}, d2 = {"Landroidx/compose/foundation/AndroidEmbeddedExternalSurfaceState;", "Landroidx/compose/foundation/BaseAndroidExternalSurfaceState;", "Landroid/view/TextureView$SurfaceTextureListener;", "scope", "Lkotlinx/coroutines/CoroutineScope;", "(Lkotlinx/coroutines/CoroutineScope;)V", "matrix", "Landroid/graphics/Matrix;", "getMatrix", "()Landroid/graphics/Matrix;", "surfaceSize", "Landroidx/compose/ui/unit/IntSize;", "getSurfaceSize-YbymL2g", "()J", "setSurfaceSize-ozmzZPI", "(J)V", "J", "surfaceTextureSurface", "Landroid/view/Surface;", "onSurfaceTextureAvailable", "", "surfaceTexture", "Landroid/graphics/SurfaceTexture;", "width", "", "height", "onSurfaceTextureDestroyed", "", "onSurfaceTextureSizeChanged", "onSurfaceTextureUpdated", "surface", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
final class AndroidEmbeddedExternalSurfaceState extends BaseAndroidExternalSurfaceState implements TextureView.SurfaceTextureListener {
    private final Matrix matrix;
    private long surfaceSize;
    private Surface surfaceTextureSurface;

    @Override
    public void onSurfaceTextureUpdated(SurfaceTexture surface) {
    }

    public AndroidEmbeddedExternalSurfaceState(CoroutineScope coroutineScope) {
        super(coroutineScope);
        this.surfaceSize = IntSize.Companion.getZero-YbymL2g();
        this.matrix = new Matrix();
    }

    public final long getSurfaceSize() {
        return this.surfaceSize;
    }

    public final void m505setSurfaceSizeozmzZPI(long j) {
        this.surfaceSize = j;
    }

    public final Matrix getMatrix() {
        return this.matrix;
    }

    @Override
    public void onSurfaceTextureAvailable(SurfaceTexture surfaceTexture, int width, int height) {
        if (!IntSize.equals-impl0(this.surfaceSize, IntSize.Companion.getZero-YbymL2g())) {
            width = IntSize.getWidth-impl(this.surfaceSize);
            height = IntSize.getHeight-impl(this.surfaceSize);
            surfaceTexture.setDefaultBufferSize(width, height);
        }
        Surface surface = new Surface(surfaceTexture);
        this.surfaceTextureSurface = surface;
        dispatchSurfaceCreated(surface, width, height);
    }

    @Override
    public void onSurfaceTextureSizeChanged(SurfaceTexture surfaceTexture, int width, int height) {
        if (!IntSize.equals-impl0(this.surfaceSize, IntSize.Companion.getZero-YbymL2g())) {
            width = IntSize.getWidth-impl(this.surfaceSize);
            height = IntSize.getHeight-impl(this.surfaceSize);
            surfaceTexture.setDefaultBufferSize(width, height);
        }
        Surface surface = this.surfaceTextureSurface;
        Intrinsics.checkNotNull(surface);
        dispatchSurfaceChanged(surface, width, height);
    }

    @Override
    public boolean onSurfaceTextureDestroyed(SurfaceTexture surfaceTexture) {
        Surface surface = this.surfaceTextureSurface;
        Intrinsics.checkNotNull(surface);
        dispatchSurfaceDestroyed(surface);
        this.surfaceTextureSurface = null;
        return true;
    }
}
