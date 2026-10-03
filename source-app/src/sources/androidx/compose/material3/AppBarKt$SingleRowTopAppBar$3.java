package androidx.compose.material3;

import androidx.compose.foundation.layout.Arrangement;
import androidx.compose.foundation.layout.SizeKt;
import androidx.compose.foundation.layout.WindowInsets;
import androidx.compose.foundation.layout.WindowInsetsPaddingKt;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.draw.ClipKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.ui.text.TextStyle;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Lambda;

@Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\u0010\u0000\u001a\u00020\u0001H\u000b¢\u0006\u0004\b\u0002\u0010\u0003"}, d2 = {"<anonymous>", "", "invoke", "(Landroidx/compose/runtime/Composer;I)V"}, k = 3, mv = {1, 8, 0}, xi = 48)
final class AppBarKt$SingleRowTopAppBar$3 extends Lambda implements Function2<Composer, Integer, Unit> {
    final Function2<Composer, Integer, Unit> $actionsRow;
    final boolean $centeredTitle;
    final TopAppBarColors $colors;
    final float $expandedHeight;
    final Function2<Composer, Integer, Unit> $navigationIcon;
    final TopAppBarScrollBehavior $scrollBehavior;
    final Function2<Composer, Integer, Unit> $title;
    final TextStyle $titleTextStyle;
    final WindowInsets $windowInsets;

    AppBarKt$SingleRowTopAppBar$3(WindowInsets windowInsets, float f, TopAppBarScrollBehavior topAppBarScrollBehavior, TopAppBarColors topAppBarColors, Function2<? super Composer, ? super Integer, Unit> function2, TextStyle textStyle, boolean z, Function2<? super Composer, ? super Integer, Unit> function3, Function2<? super Composer, ? super Integer, Unit> function4) {
        super(2);
        this.$windowInsets = windowInsets;
        this.$expandedHeight = f;
        this.$scrollBehavior = topAppBarScrollBehavior;
        this.$colors = topAppBarColors;
        this.$title = function2;
        this.$titleTextStyle = textStyle;
        this.$centeredTitle = z;
        this.$navigationIcon = function3;
        this.$actionsRow = function4;
    }

    public Object invoke(Object obj, Object obj2) {
        invoke((Composer) obj, ((Number) obj2).intValue());
        return Unit.INSTANCE;
    }

    public final void invoke(Composer composer, int i) {
        ComposerKt.sourceInformation(composer, "C1933@88685L45,1927@88379L998:AppBar.kt#uh7d8r");
        if ((i & 3) != 2 || !composer.getSkipping()) {
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1943739546, i, -1, "androidx.compose.material3.SingleRowTopAppBar.<anonymous> (AppBar.kt:1927)");
            }
            Modifier modifierM1068heightInVpY3zN4$default = SizeKt.m1068heightInVpY3zN4$default(ClipKt.clipToBounds(WindowInsetsPaddingKt.windowInsetsPadding(Modifier.INSTANCE, this.$windowInsets)), 0.0f, this.$expandedHeight, 1, null);
            ComposerKt.sourceInformationMarkerStart(composer, 660708484, "CC(remember):AppBar.kt#9igjgp");
            boolean zChanged = composer.changed(this.$scrollBehavior);
            final TopAppBarScrollBehavior topAppBarScrollBehavior = this.$scrollBehavior;
            Object objRememberedValue = composer.rememberedValue();
            if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                objRememberedValue = new ScrolledOffset() {
                    @Override
                    public final float offset() {
                        return AppBarKt$SingleRowTopAppBar$3.invoke$lambda$1$lambda$0(topAppBarScrollBehavior);
                    }
                };
                composer.updateRememberedValue(objRememberedValue);
            }
            ScrolledOffset scrolledOffset = (ScrolledOffset) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composer);
            AppBarKt.m2005TopAppBarLayoutkXwM9vE(modifierM1068heightInVpY3zN4$default, scrolledOffset, this.$colors.getNavigationIconContentColor(), this.$colors.getTitleContentColor(), this.$colors.getActionIconContentColor(), this.$title, this.$titleTextStyle, 1.0f, Arrangement.INSTANCE.getCenter(), this.$centeredTitle ? Arrangement.INSTANCE.getCenter() : Arrangement.INSTANCE.getStart(), 0, false, this.$navigationIcon, this.$actionsRow, composer, 113246208, 3126);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
                return;
            }
            return;
        }
        composer.skipToGroupEnd();
    }

    public static final float invoke$lambda$1$lambda$0(TopAppBarScrollBehavior topAppBarScrollBehavior) {
        TopAppBarState state;
        if (topAppBarScrollBehavior == null || (state = topAppBarScrollBehavior.getState()) == null) {
            return 0.0f;
        }
        return state.getHeightOffset();
    }
}
