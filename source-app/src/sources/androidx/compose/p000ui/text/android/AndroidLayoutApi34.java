package androidx.compose.p000ui.text.android;

import android.graphics.RectF;
import android.text.Layout;
import android.text.SegmentFinder;
import androidx.compose.p000ui.text.android.selection.Api34SegmentFinder;
import androidx.compose.p000ui.text.android.selection.WordSegmentFinder;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.core.app.NotificationCompat$$ExternalSyntheticApiModelOutline0;
import kotlin.Metadata;
import kotlin.jvm.functions.Function2;

@Metadata(d1 = {"\u00000\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u0015\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u000b\n\u0002\b\u0002\bÁ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002JA\u0010\u0003\u001a\u0004\u0018\u00010\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\n2\u0018\u0010\u000b\u001a\u0014\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\r0\fH\u0001¢\u0006\u0002\b\u000e¨\u0006\u000f"}, d2 = {"Landroidx/compose/ui/text/android/AndroidLayoutApi34;", "", "()V", "getRangeForRect", "", "layout", "Landroidx/compose/ui/text/android/TextLayout;", "rectF", "Landroid/graphics/RectF;", "granularity", "", "inclusionStrategy", "Lkotlin/Function2;", "", "getRangeForRect$ui_text_release", "ui-text_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class AndroidLayoutApi34 {
    public static final int $stable = 0;
    public static final AndroidLayoutApi34 INSTANCE = new AndroidLayoutApi34();

    private AndroidLayoutApi34() {
    }

    public final int[] getRangeForRect$ui_text_release(TextLayout layout, RectF rectF, int granularity, final Function2<? super RectF, ? super RectF, Boolean> inclusionStrategy) {
        SegmentFinder segmentFinderM31m;
        if (granularity == 1) {
            segmentFinderM31m = Api34SegmentFinder.INSTANCE.toAndroidSegmentFinder$ui_text_release(new WordSegmentFinder(layout.getText(), layout.getWordIterator()));
        } else {
            NotificationCompat$$ExternalSyntheticApiModelOutline0.m43m();
            segmentFinderM31m = NotificationCompat$$ExternalSyntheticApiModelOutline0.m31m((Object) NotificationCompat$$ExternalSyntheticApiModelOutline0.m30m(layout.getText(), layout.getTextPaint()));
        }
        return layout.getLayout().getRangeForRect(rectF, segmentFinderM31m, new Layout.TextInclusionStrategy() {
            @Override
            public final boolean isSegmentInside(RectF rectF2, RectF rectF3) {
                return AndroidLayoutApi34.getRangeForRect$lambda$0(inclusionStrategy, rectF2, rectF3);
            }
        });
    }

    public static final boolean getRangeForRect$lambda$0(Function2 function2, RectF rectF, RectF rectF2) {
        return ((Boolean) function2.invoke(rectF, rectF2)).booleanValue();
    }
}
