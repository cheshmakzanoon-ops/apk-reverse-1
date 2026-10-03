package zendesk.core.p017ui.android.internal.xml;

import android.graphics.Insets;
import android.os.Build;
import android.view.View;
import android.view.WindowInsets;
import androidx.activity.ComponentDialog$;
import androidx.core.util.HalfKt$;
import androidx.media.AudioAttributesImplApi21$;
import kotlin.Metadata;
import kotlin.comparisons.ComparisonsKt;
import kotlin.jvm.internal.Intrinsics;
import zendesk.core.p017ui.android.internal.InternalZendeskUIApi;

@Metadata(m17d1 = {"\u0000\u0018\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0011\n\u0002\u0018\u0002\n\u0002\b\u0002\u001a%\u0010\u0000\u001a\u00020\u0001*\u00020\u00022\u0012\u0010\u0003\u001a\n\u0012\u0006\b\u0001\u0012\u00020\u00050\u0004\"\u00020\u0005H\u0007¢\u0006\u0002\u0010\u0006¨\u0006\u0007"}, m18d2 = {"applyWindowInsets", "", "Landroid/view/View;", "insetType", "", "Lzendesk/core/ui/android/internal/xml/InsetType;", "(Landroid/view/View;[Lzendesk/core/ui/android/internal/xml/InsetType;)V", "zendesk.core.ui_core-ui"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class SystemWindowInsetsKt {

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[InsetType.values().length];
            try {
                iArr[InsetType.TOP.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[InsetType.BOTTOM.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                iArr[InsetType.HORIZONTAL.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    @InternalZendeskUIApi
    public static final void applyWindowInsets(View view, final InsetType... insetType) {
        Intrinsics.checkNotNullParameter(view, "<this>");
        Intrinsics.checkNotNullParameter(insetType, "insetType");
        if (Build.VERSION.SDK_INT >= 35) {
            view.setOnApplyWindowInsetsListener(new View.OnApplyWindowInsetsListener() {
                @Override
                public final WindowInsets onApplyWindowInsets(View view2, WindowInsets windowInsets) {
                    return SystemWindowInsetsKt.applyWindowInsets$lambda$1(insetType, view2, windowInsets);
                }
            });
        }
    }

    public static final WindowInsets applyWindowInsets$lambda$1(InsetType[] insetType, View view, WindowInsets windowInsets) {
        Insets insetsM$1;
        Intrinsics.checkNotNullParameter(insetType, "$insetType");
        Intrinsics.checkNotNullParameter(view, "view");
        Intrinsics.checkNotNullParameter(windowInsets, "windowInsets");
        boolean zM = HalfKt$.ExternalSyntheticApiModelOutline0.m(windowInsets, HalfKt$.ExternalSyntheticApiModelOutline0.m());
        for (InsetType insetType2 : insetType) {
            int i = WhenMappings.$EnumSwitchMapping$0[insetType2.ordinal()];
            if (i == 1) {
                view.setPadding(view.getPaddingLeft(), ComponentDialog$.ExternalSyntheticApiModelOutline0.m$1(HalfKt$.ExternalSyntheticApiModelOutline0.m$1(windowInsets, AudioAttributesImplApi21$.ExternalSyntheticApiModelOutline0.m())), view.getPaddingRight(), view.getPaddingBottom());
            } else if (i == 2) {
                if (zM) {
                    insetsM$1 = HalfKt$.ExternalSyntheticApiModelOutline0.m$1(windowInsets, HalfKt$.ExternalSyntheticApiModelOutline0.m());
                } else {
                    insetsM$1 = HalfKt$.ExternalSyntheticApiModelOutline0.m$1(windowInsets, WindowInsets.Type.systemBars());
                }
                Intrinsics.checkNotNull(insetsM$1);
                view.setPadding(view.getPaddingLeft(), view.getPaddingTop(), view.getPaddingRight(), ComponentDialog$.ExternalSyntheticApiModelOutline0.m$3(insetsM$1));
            } else if (i == 3) {
                Insets insetsM$2 = HalfKt$.ExternalSyntheticApiModelOutline0.m$1(windowInsets, WindowInsets.Type.systemBars());
                Intrinsics.checkNotNullExpressionValue(insetsM$2, "getInsets(...)");
                Insets insetsM$3 = HalfKt$.ExternalSyntheticApiModelOutline0.m$1(windowInsets, AudioAttributesImplApi21$.ExternalSyntheticApiModelOutline0.m$6());
                Intrinsics.checkNotNullExpressionValue(insetsM$3, "getInsets(...)");
                int iMaxOf = ComparisonsKt.maxOf(ComponentDialog$.ExternalSyntheticApiModelOutline0.m$2(insetsM$2), ComponentDialog$.ExternalSyntheticApiModelOutline0.m$2(insetsM$3), ComponentDialog$.ExternalSyntheticApiModelOutline0.m(insetsM$2), ComponentDialog$.ExternalSyntheticApiModelOutline0.m(insetsM$3));
                view.setPaddingRelative(iMaxOf, view.getPaddingTop(), iMaxOf, view.getPaddingBottom());
            }
        }
        return windowInsets;
    }
}
