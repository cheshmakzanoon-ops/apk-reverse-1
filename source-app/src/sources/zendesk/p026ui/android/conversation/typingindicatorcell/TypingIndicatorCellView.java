package zendesk.p026ui.android.conversation.typingindicatorcell;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.util.AttributeSet;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.ImageView;
import androidx.vectordrawable.graphics.drawable.AnimatedVectorDrawableCompat;
import kotlin.Metadata;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.p026ui.android.internal.ImageViewExtensionKt;
import zendesk.ui.android.R;
import zendesk.ui.android.Renderer;

@Metadata(m17d1 = {"\u0000>\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0007\u0018\u00002\u00020\u00012\b\u0012\u0004\u0012\u00020\u00030\u0002B/\b\u0007\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t\u0012\b\b\u0002\u0010\n\u001a\u00020\t¢\u0006\u0002\u0010\u000bJ\b\u0010\u000f\u001a\u00020\u0010H\u0002J\u001c\u0010\u0011\u001a\u00020\u00102\u0012\u0010\u0012\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00030\u0013H\u0016J\r\u0010\u0014\u001a\u00020\u0010H\u0001¢\u0006\u0002\b\u0015R\u0010\u0010\f\u001a\u0004\u0018\u00010\rX\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u000e\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0016"}, m18d2 = {"Lzendesk/ui/android/conversation/typingindicatorcell/TypingIndicatorCellView;", "Landroid/widget/FrameLayout;", "Lzendesk/ui/android/Renderer;", "Lzendesk/ui/android/conversation/typingindicatorcell/TypingIndicatorCellRendering;", "context", "Landroid/content/Context;", "attrs", "Landroid/util/AttributeSet;", "defStyleAttrs", "", "defStyleRes", "(Landroid/content/Context;Landroid/util/AttributeSet;II)V", "animatedVectorDrawable", "Landroidx/vectordrawable/graphics/drawable/AnimatedVectorDrawableCompat;", "rendering", "configureAnimation", "", "render", "renderingUpdate", "Lkotlin/Function1;", "stopAnimation", "stopAnimation$zendesk_ui_ui_android", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class TypingIndicatorCellView extends FrameLayout implements Renderer<TypingIndicatorCellRendering> {
    public static final int $stable = 8;
    private AnimatedVectorDrawableCompat animatedVectorDrawable;
    private TypingIndicatorCellRendering rendering;

    public TypingIndicatorCellView(Context context) {
        this(context, null, 0, 0, 14, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public TypingIndicatorCellView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0, 0, 12, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public TypingIndicatorCellView(Context context, AttributeSet attributeSet, int i) {
        this(context, attributeSet, i, 0, 8, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public TypingIndicatorCellView(Context context, AttributeSet attributeSet, int i, int i2, int i3, DefaultConstructorMarker defaultConstructorMarker) {
        this(context, (i3 & 2) != 0 ? null : attributeSet, (i3 & 4) != 0 ? 0 : i, (i3 & 8) != 0 ? 0 : i2);
    }

    public TypingIndicatorCellView(Context context, AttributeSet attributeSet, int i, int i2) {
        super(context, attributeSet, i, i2);
        Intrinsics.checkNotNullParameter(context, "context");
        this.rendering = new TypingIndicatorCellRendering();
        context.getTheme().applyStyle(R.style.ThemeOverlay_ZendeskComponents_TypingIndicatorCellStyle, false);
        FrameLayout.inflate(context, R.layout.zuia_view_typing_indicator_cell, this);
        render(new Function1<TypingIndicatorCellRendering, TypingIndicatorCellRendering>() {
            @Override
            public final TypingIndicatorCellRendering invoke(TypingIndicatorCellRendering it) {
                Intrinsics.checkNotNullParameter(it, "it");
                return it;
            }
        });
    }

    public void render(Function1<? super TypingIndicatorCellRendering, TypingIndicatorCellRendering> renderingUpdate) {
        Integer backgroundColor$zendesk_ui_ui_android;
        Intrinsics.checkNotNullParameter(renderingUpdate, "renderingUpdate");
        this.rendering = renderingUpdate.invoke(this.rendering);
        setBackgroundResource(R.drawable.zuia_message_cell_inbound_shape_single);
        if (getBackground() != null && (backgroundColor$zendesk_ui_ui_android = this.rendering.getState().getBackgroundColor$zendesk_ui_ui_android()) != null) {
            int iIntValue = backgroundColor$zendesk_ui_ui_android.intValue();
            Drawable background = getBackground();
            GradientDrawable gradientDrawable = background instanceof GradientDrawable ? (GradientDrawable) background : null;
            if (gradientDrawable != null) {
                gradientDrawable.setColor(iIntValue);
            }
        }
        configureAnimation();
    }

    private final void configureAnimation() {
        View viewFindViewById = findViewById(R.id.zuia_typing_indicator);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById, "findViewById(...)");
        ImageView imageView = (ImageView) viewFindViewById;
        AnimatedVectorDrawableCompat animatedVectorDrawableCompat = this.animatedVectorDrawable;
        if (animatedVectorDrawableCompat != null) {
            animatedVectorDrawableCompat.stop();
        }
        this.animatedVectorDrawable = ImageViewExtensionKt.applyLoopingAnimatedVectorDrawable(imageView, R.drawable.zuia_animation_typing_indicator);
        Integer dotColor$zendesk_ui_ui_android = this.rendering.getState().getDotColor$zendesk_ui_ui_android();
        if (dotColor$zendesk_ui_ui_android != null) {
            int iIntValue = dotColor$zendesk_ui_ui_android.intValue();
            AnimatedVectorDrawableCompat animatedVectorDrawableCompat2 = this.animatedVectorDrawable;
            if (animatedVectorDrawableCompat2 != null) {
                animatedVectorDrawableCompat2.setTint(iIntValue);
            }
        }
    }

    public final void stopAnimation$zendesk_ui_ui_android() {
        AnimatedVectorDrawableCompat animatedVectorDrawableCompat = this.animatedVectorDrawable;
        if (animatedVectorDrawableCompat != null) {
            animatedVectorDrawableCompat.clearAnimationCallbacks();
        }
        AnimatedVectorDrawableCompat animatedVectorDrawableCompat2 = this.animatedVectorDrawable;
        if (animatedVectorDrawableCompat2 != null) {
            animatedVectorDrawableCompat2.stop();
        }
    }
}
