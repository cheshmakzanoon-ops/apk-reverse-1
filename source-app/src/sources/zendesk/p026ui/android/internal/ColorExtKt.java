package zendesk.p026ui.android.internal;

import android.content.Context;
import android.graphics.Color;
import android.util.TypedValue;
import androidx.core.content.ContextCompat;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import kotlin.math.MathKt;

@Metadata(m17d1 = {"\u0000\u0016\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u0007\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\u001a\u0014\u0010\u0000\u001a\u00020\u0001*\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u0003H\u0001\u001a\u0016\u0010\u0004\u001a\u00020\u0001*\u00020\u00052\b\b\u0001\u0010\u0006\u001a\u00020\u0001H\u0001\u001a\u0016\u0010\u0007\u001a\u00020\u0001*\u00020\u00052\b\b\u0001\u0010\b\u001a\u00020\u0001H\u0001¨\u0006\t"}, m18d2 = {"adjustAlpha", "", "factor", "", "getColorCompat", "Landroid/content/Context;", "colorRes", "resolveColorAttr", "colorAttr", "zendesk.ui_ui-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class ColorExtKt {
    public static final int resolveColorAttr(Context context, int i) {
        Intrinsics.checkNotNullParameter(context, "<this>");
        TypedValue typedValue = new TypedValue();
        context.getTheme().resolveAttribute(i, typedValue, true);
        return typedValue.data;
    }

    public static final int getColorCompat(Context context, int i) {
        Intrinsics.checkNotNullParameter(context, "<this>");
        return ContextCompat.getColor(context, i);
    }

    public static final int adjustAlpha(int i, float f) {
        return Color.argb(MathKt.roundToInt(Color.alpha(i) * f), Color.red(i), Color.green(i), Color.blue(i));
    }
}
