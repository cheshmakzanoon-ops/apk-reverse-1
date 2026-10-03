package androidx.compose.p000ui.text.android;

import android.os.Build;
import android.text.StaticLayout;
import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.internal.NativeProtocol;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000 \n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0003\b\u0003\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J\u0010\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u0006H\u0017J\u0018\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\u00042\u0006\u0010\n\u001a\u00020\bH\u0016¨\u0006\u000b"}, d2 = {"Landroidx/compose/ui/text/android/StaticLayoutFactory23;", "Landroidx/compose/ui/text/android/StaticLayoutFactoryImpl;", "()V", "create", "Landroid/text/StaticLayout;", NativeProtocol.WEB_DIALOG_PARAMS, "Landroidx/compose/ui/text/android/StaticLayoutParams;", "isFallbackLineSpacingEnabled", "", "layout", "useFallbackLineSpacing", "ui-text_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
final class StaticLayoutFactory23 implements StaticLayoutFactoryImpl {
    @Override
    public StaticLayout create(StaticLayoutParams params) {
        StaticLayout.Builder builderObtain = StaticLayout.Builder.obtain(params.getText(), params.getStart(), params.getEnd(), params.getPaint(), params.getWidth());
        builderObtain.setTextDirection(params.getTextDir());
        builderObtain.setAlignment(params.getAlignment());
        builderObtain.setMaxLines(params.getMaxLines());
        builderObtain.setEllipsize(params.getEllipsize());
        builderObtain.setEllipsizedWidth(params.getEllipsizedWidth());
        builderObtain.setLineSpacing(params.getLineSpacingExtra(), params.getLineSpacingMultiplier());
        builderObtain.setIncludePad(params.getIncludePadding());
        builderObtain.setBreakStrategy(params.getBreakStrategy());
        builderObtain.setHyphenationFrequency(params.getHyphenationFrequency());
        builderObtain.setIndents(params.getLeftIndents(), params.getRightIndents());
        if (Build.VERSION.SDK_INT >= 26) {
            StaticLayoutFactory26.setJustificationMode(builderObtain, params.getJustificationMode());
        }
        if (Build.VERSION.SDK_INT >= 28) {
            StaticLayoutFactory28.setUseLineSpacingFromFallbacks(builderObtain, params.getUseFallbackLineSpacing());
        }
        if (Build.VERSION.SDK_INT >= 33) {
            StaticLayoutFactory33.setLineBreakConfig(builderObtain, params.getLineBreakStyle(), params.getLineBreakWordStyle());
        }
        return builderObtain.build();
    }

    @Override
    public boolean isFallbackLineSpacingEnabled(StaticLayout layout, boolean useFallbackLineSpacing) {
        if (Build.VERSION.SDK_INT >= 33) {
            return StaticLayoutFactory33.isFallbackLineSpacingEnabled(layout);
        }
        if (Build.VERSION.SDK_INT >= 28) {
            return useFallbackLineSpacing;
        }
        return false;
    }
}
