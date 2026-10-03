package zendesk.p026ui.android.conversation.waittimebanner;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.widget.FrameLayout;
import androidx.compose.runtime.MutableState;
import androidx.compose.runtime.SnapshotMutationPolicy;
import androidx.compose.runtime.SnapshotStateKt;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import androidx.compose.ui.graphics.Color;
import androidx.compose.ui.graphics.ColorKt;
import androidx.compose.ui.platform.ComposeView;
import androidx.core.content.ContextCompat;
import kotlin.Metadata;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.ui.android.R;
import zendesk.ui.android.Renderer;

@Metadata(m17d1 = {"\u0000J\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\b\u0007\u0018\u00002\u00020\u00012\b\u0012\u0004\u0012\u00020\u00030\u0002B/\b\u0007\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t\u0012\b\b\u0002\u0010\n\u001a\u00020\t¢\u0006\u0002\u0010\u000bJ\u001c\u0010\u0015\u001a\u00020\u00162\u0012\u0010\u0017\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00030\u0018H\u0016R\u0014\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u000e0\rX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u000f\u001a\b\u0012\u0004\u0012\u00020\u00100\rX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0011\u001a\u00020\tX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u0012\u001a\b\u0012\u0004\u0012\u00020\u00100\rX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0013\u001a\u00020\tX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0014\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0019²\u0006\n\u0010\u001a\u001a\u00020\u001bX\u008a\u008e\u0002"}, m18d2 = {"Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerView;", "Landroid/widget/FrameLayout;", "Lzendesk/ui/android/Renderer;", "Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerRendering;", "context", "Landroid/content/Context;", "attrs", "Landroid/util/AttributeSet;", "defStyleAttrs", "", "defStyleRes", "(Landroid/content/Context;Landroid/util/AttributeSet;II)V", "bannerType", "Landroidx/compose/runtime/MutableState;", "Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerType;", "focusedBorderColor", "Landroidx/compose/ui/graphics/Color;", "focusedBorderDefaultColor", "onBackgroundColor", "onBackgroundDefaultColor", "rendering", "render", "", "renderingUpdate", "Lkotlin/Function1;", "zendesk.ui_ui-android", "isFocused", ""}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class WaitTimeBannerView extends FrameLayout implements Renderer<WaitTimeBannerRendering> {
    public static final int $stable = 8;
    private final MutableState<WaitTimeBannerType> bannerType;
    private final MutableState<Color> focusedBorderColor;
    private final int focusedBorderDefaultColor;
    private final MutableState<Color> onBackgroundColor;
    private final int onBackgroundDefaultColor;
    private WaitTimeBannerRendering rendering;

    public WaitTimeBannerView(Context context) {
        this(context, null, 0, 0, 14, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public WaitTimeBannerView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0, 0, 12, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public WaitTimeBannerView(Context context, AttributeSet attributeSet, int i) {
        this(context, attributeSet, i, 0, 8, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public WaitTimeBannerView(Context context, AttributeSet attributeSet, int i, int i2, int i3, DefaultConstructorMarker defaultConstructorMarker) {
        this(context, (i3 & 2) != 0 ? null : attributeSet, (i3 & 4) != 0 ? 0 : i, (i3 & 8) != 0 ? 0 : i2);
    }

    public WaitTimeBannerView(Context context, AttributeSet attributeSet, int i, int i2) {
        super(context, attributeSet, i, i2);
        Intrinsics.checkNotNullParameter(context, "context");
        this.rendering = new WaitTimeBannerRendering();
        int color = ContextCompat.getColor(context, R.color.default_color_on_background);
        this.onBackgroundDefaultColor = color;
        this.onBackgroundColor = SnapshotStateKt.mutableStateOf$default(Color.box-impl(ColorKt.Color(color)), (SnapshotMutationPolicy) null, 2, (Object) null);
        int color2 = ContextCompat.getColor(context, R.color.default_color_on_action_background);
        this.focusedBorderDefaultColor = color2;
        this.focusedBorderColor = SnapshotStateKt.mutableStateOf$default(Color.box-impl(ColorKt.Color(color2)), (SnapshotMutationPolicy) null, 2, (Object) null);
        this.bannerType = SnapshotStateKt.mutableStateOf$default(WaitTimeBannerType.Cleared.INSTANCE, (SnapshotMutationPolicy) null, 2, (Object) null);
        ComposeView composeView = new ComposeView(context, (AttributeSet) null, 0, 6, (DefaultConstructorMarker) null);
        composeView.setId(FrameLayout.generateViewId());
        composeView.setLayoutParams(new FrameLayout.LayoutParams(-1, -2));
        composeView.setContent(ComposableLambdaKt.composableLambdaInstance(219617718, true, new WaitTimeBannerView$composeView$1$1(this)));
        addView((View) composeView);
        render(new Function1<WaitTimeBannerRendering, WaitTimeBannerRendering>() {
            @Override
            public final WaitTimeBannerRendering invoke(WaitTimeBannerRendering it) {
                Intrinsics.checkNotNullParameter(it, "it");
                return it;
            }
        });
    }

    public void render(Function1<? super WaitTimeBannerRendering, WaitTimeBannerRendering> renderingUpdate) {
        Intrinsics.checkNotNullParameter(renderingUpdate, "renderingUpdate");
        WaitTimeBannerRendering waitTimeBannerRenderingInvoke = renderingUpdate.invoke(this.rendering);
        this.rendering = waitTimeBannerRenderingInvoke;
        this.onBackgroundColor.setValue(Color.box-impl(ColorKt.Color(waitTimeBannerRenderingInvoke.getState().getOnBackgroundColor$zendesk_ui_ui_android())));
        this.focusedBorderColor.setValue(Color.box-impl(ColorKt.Color(this.rendering.getState().getFocusedBorderColor$zendesk_ui_ui_android())));
        this.bannerType.setValue(this.rendering.getState().getType$zendesk_ui_ui_android());
    }
}
