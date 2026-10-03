package androidx.compose.p000ui.unit;

import android.content.Context;
import androidx.compose.p000ui.unit.fontscaling.FontScaleConverterFactory;
import androidx.constraintlayout.widget.ConstraintLayout;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\u001a\u000e\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u0003¨\u0006\u0004"}, d2 = {"Density", "Landroidx/compose/ui/unit/Density;", "context", "Landroid/content/Context;", "ui-unit_release"}, k = 2, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class AndroidDensity_androidKt {
    public static final Density Density(Context context) {
        float f = context.getResources().getConfiguration().fontScale;
        float f2 = context.getResources().getDisplayMetrics().density;
        LinearFontScaleConverter linearFontScaleConverterForScale = FontScaleConverterFactory.INSTANCE.forScale(f);
        if (linearFontScaleConverterForScale == null) {
            linearFontScaleConverterForScale = new LinearFontScaleConverter(f);
        }
        return new DensityWithConverter(f2, f, linearFontScaleConverterForScale);
    }
}
