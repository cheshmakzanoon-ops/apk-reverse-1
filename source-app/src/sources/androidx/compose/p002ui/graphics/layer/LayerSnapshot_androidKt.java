package androidx.compose.p002ui.graphics.layer;

import android.graphics.Bitmap;
import android.media.Image;
import androidx.compose.foundation.text.input.internal.PartialGapBuffer;
import androidx.compose.p002ui.graphics.ColorKt;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000\f\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\u001a\f\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u0002¨\u0006\u0003"}, d2 = {"toBitmap", "Landroid/graphics/Bitmap;", "Landroid/media/Image;", "ui-graphics_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class LayerSnapshot_androidKt {
    public static final Bitmap toBitmap(Image image) {
        Image.Plane[] planes = image.getPlanes();
        Intrinsics.checkNotNull(planes);
        Image.Plane plane = planes[0];
        int width = image.getWidth() * image.getHeight();
        int[] iArr = new int[width];
        plane.getBuffer().asIntBuffer().get(iArr);
        for (int i = 0; i < width; i++) {
            int i2 = iArr[i];
            iArr[i] = ColorKt.m4644toArgb8_81llA(ColorKt.Color(i2 & PartialGapBuffer.BUF_SIZE, (i2 >> 8) & PartialGapBuffer.BUF_SIZE, (i2 >> 16) & PartialGapBuffer.BUF_SIZE, (i2 >> 24) & PartialGapBuffer.BUF_SIZE));
        }
        return Bitmap.createBitmap(iArr, image.getWidth(), image.getHeight(), Bitmap.Config.ARGB_8888);
    }
}
