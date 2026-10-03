package zendesk.messaging.android.internal.extension;

import android.graphics.Color;
import android.view.View;
import android.widget.LinearLayout;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;
import kotlin.math.MathKt;

@Metadata(m17d1 = {"\u0000*\n\u0000\n\u0002\u0010\u0007\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\u001a\u0016\u0010\u0002\u001a\u00020\u0003*\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u0001H\u0001\u001a\f\u0010\u0005\u001a\u00020\u0006*\u00020\u0007H\u0000\u001a%\u0010\u0005\u001a\u00020\u0006*\u00020\u00072\u0017\u0010\b\u001a\u0013\u0012\u0004\u0012\u00020\n\u0012\u0004\u0012\u00020\u00060\t¢\u0006\u0002\b\u000bH\u0000\u001a%\u0010\f\u001a\u00020\u0006*\u00020\u00072\u0017\u0010\b\u001a\u0013\u0012\u0004\u0012\u00020\n\u0012\u0004\u0012\u00020\u00060\t¢\u0006\u0002\b\u000bH\u0000\"\u000e\u0010\u0000\u001a\u00020\u0001X\u0082T¢\u0006\u0002\n\u0000¨\u0006\r"}, m18d2 = {"DEFAULT_ALPHA_FACTOR", "", "adjustAlpha", "", "factor", "edgeToEdge", "", "Landroid/view/View;", "block", "Lkotlin/Function1;", "Landroid/widget/LinearLayout$LayoutParams;", "Lkotlin/ExtensionFunctionType;", "wrap", "zendesk.messaging_messaging-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class ViewKtxKt {
    private static final float DEFAULT_ALPHA_FACTOR = 0.5f;

    public static final void edgeToEdge(View view, Function1<? super LinearLayout.LayoutParams, Unit> block) {
        Intrinsics.checkNotNullParameter(view, "<this>");
        Intrinsics.checkNotNullParameter(block, "block");
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(-1, -2);
        block.invoke(layoutParams);
        view.setLayoutParams(layoutParams);
    }

    public static final void edgeToEdge(View view) {
        Intrinsics.checkNotNullParameter(view, "<this>");
        view.setLayoutParams(new LinearLayout.LayoutParams(-1, -2));
    }

    public static final void wrap(View view, Function1<? super LinearLayout.LayoutParams, Unit> block) {
        Intrinsics.checkNotNullParameter(view, "<this>");
        Intrinsics.checkNotNullParameter(block, "block");
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(-2, -2);
        block.invoke(layoutParams);
        view.setLayoutParams(layoutParams);
    }

    public static int adjustAlpha$default(int i, float f, int i2, Object obj) {
        if ((i2 & 1) != 0) {
            f = DEFAULT_ALPHA_FACTOR;
        }
        return adjustAlpha(i, f);
    }

    public static final int adjustAlpha(int i, float f) {
        return Color.argb(MathKt.roundToInt(Color.alpha(i) * f), Color.red(i), Color.green(i), Color.blue(i));
    }
}
