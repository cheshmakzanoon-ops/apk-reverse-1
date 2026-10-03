package zendesk.p009ui.android.common.button;

import android.content.Context;
import android.util.AttributeSet;
import android.util.TypedValue;
import android.view.View;
import android.view.ViewGroup;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.core.graphics.BlendModeColorFilterCompat;
import androidx.core.graphics.BlendModeCompat;
import androidx.vectordrawable.graphics.drawable.Animatable2Compat;
import androidx.vectordrawable.graphics.drawable.AnimatedVectorDrawableCompat;
import com.google.android.material.button.MaterialButton;
import com.google.android.material.shape.ShapeAppearanceModel;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.ui.android.R;
import zendesk.ui.android.Renderer;
import zendesk.ui.android.internal.ColorExtKt;
import zendesk.ui.android.internal.ThrottledOnClickListenerKt;

@Metadata(d1 = {"\u0000B\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0007\u0018\u00002\u00020\u00012\b\u0012\u0004\u0012\u00020\u00030\u0002B%\b\u0007\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t¢\u0006\u0002\u0010\nJ\u001c\u0010\u0010\u001a\u00020\u00112\u0012\u0010\u0012\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00030\u0013H\u0016J\r\u0010\u0014\u001a\u00020\u0011H\u0001¢\u0006\u0002\b\u0015R\u000e\u0010\u000b\u001a\u00020\fX\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\r\u001a\u0004\u0018\u00010\u000eX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000f\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0016"}, d2 = {"Lzendesk/ui/android/common/button/ButtonView;", "Lcom/google/android/material/button/MaterialButton;", "Lzendesk/ui/android/Renderer;", "Lzendesk/ui/android/common/button/ButtonRendering;", "context", "Landroid/content/Context;", "attrs", "Landroid/util/AttributeSet;", "defStyleAttrs", "", "(Landroid/content/Context;Landroid/util/AttributeSet;I)V", "animationLoopCallback", "Landroidx/vectordrawable/graphics/drawable/Animatable2Compat$AnimationCallback;", "loadingAnimation", "Landroidx/vectordrawable/graphics/drawable/AnimatedVectorDrawableCompat;", "rendering", "render", "", "renderingUpdate", "Lkotlin/Function1;", "stopAnimation", "stopAnimation$zendesk_ui_ui_android", "zendesk.ui_ui-android"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class ButtonView extends MaterialButton implements Renderer<ButtonRendering> {
    public static final int $stable = 8;
    private final Animatable2Compat.AnimationCallback animationLoopCallback;
    private final AnimatedVectorDrawableCompat loadingAnimation;
    private ButtonRendering rendering;

    public ButtonView(Context context) {
        this(context, null, 0, 6, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ButtonView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0, 4, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ButtonView(Context context, AttributeSet attributeSet, int i, int i2, DefaultConstructorMarker defaultConstructorMarker) {
        this(context, (i2 & 2) != 0 ? null : attributeSet, (i2 & 4) != 0 ? R.attr.formButtonStyle : i);
    }

    public ButtonView(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        Intrinsics.checkNotNullParameter(context, "context");
        this.loadingAnimation = AnimatedVectorDrawableCompat.create(context, R.drawable.zuia_animation_loading_juggle);
        this.animationLoopCallback = new ButtonView$animationLoopCallback$1(this);
        this.rendering = new ButtonRendering();
        setLayoutParams(new ViewGroup.LayoutParams(-2, -2));
        render(new Function1<ButtonRendering, ButtonRendering>() {
            public final ButtonRendering invoke(ButtonRendering buttonRendering) {
                Intrinsics.checkNotNullParameter(buttonRendering, "it");
                return buttonRendering;
            }
        });
    }

    public void render(Function1<? super ButtonRendering, ButtonRendering> renderingUpdate) {
        String text$zendesk_ui_ui_android;
        int iResolveColorAttr;
        Intrinsics.checkNotNullParameter(renderingUpdate, "renderingUpdate");
        ButtonRendering buttonRendering = (ButtonRendering) renderingUpdate.invoke(this.rendering);
        this.rendering = buttonRendering;
        if (!buttonRendering.getState().isLoading$zendesk_ui_ui_android()) {
            text$zendesk_ui_ui_android = this.rendering.getState().getText$zendesk_ui_ui_android();
        }
        setText(text$zendesk_ui_ui_android);
        setOnClickListener((View.OnClickListener) ThrottledOnClickListenerKt.throttledOnClickListener$default(0L, new Function0<Unit>() {
            {
                super(0);
            }

            public Object invoke() {
                m2630invoke();
                return Unit.INSTANCE;
            }

            public final void m2630invoke() {
                ButtonView.this.rendering.getOnButtonClicked$zendesk_ui_ui_android().invoke();
            }
        }, 1, (Object) null));
        Integer backgroundColor$zendesk_ui_ui_android = this.rendering.getState().getBackgroundColor$zendesk_ui_ui_android();
        if (backgroundColor$zendesk_ui_ui_android != null) {
            iResolveColorAttr = backgroundColor$zendesk_ui_ui_android.intValue();
        } else {
            Context context = getContext();
            Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
            iResolveColorAttr = ColorExtKt.resolveColorAttr(context, androidx.appcompat.R.attr.colorAccent);
        }
        setBackgroundColor(iResolveColorAttr);
        Integer textColor$zendesk_ui_ui_android = this.rendering.getState().getTextColor$zendesk_ui_ui_android();
        if (textColor$zendesk_ui_ui_android != null) {
            setTextColor(textColor$zendesk_ui_ui_android.intValue());
        }
        setElevation(0.0f);
        setClickable(!this.rendering.getState().isLoading$zendesk_ui_ui_android());
        if (this.loadingAnimation == null) {
            return;
        }
        if (this.rendering.getState().isLoading$zendesk_ui_ui_android() && this.loadingAnimation.isRunning()) {
            return;
        }
        Integer loadingColor$zendesk_ui_ui_android = this.rendering.getState().getLoadingColor$zendesk_ui_ui_android();
        if (loadingColor$zendesk_ui_ui_android != null) {
            final int iIntValue = loadingColor$zendesk_ui_ui_android.intValue();
            post(new Runnable() {
                @Override
                public final void run() {
                    ButtonView.render$lambda$2$lambda$1(this.f$0, iIntValue);
                }
            });
        }
        if (this.rendering.getState().isLoading$zendesk_ui_ui_android()) {
            setMinimumWidth(getWidth());
            setContentDescription(getResources().getString(R.string.zuia_accessibility_loading_label));
            setIcon(this.loadingAnimation);
            this.loadingAnimation.registerAnimationCallback(this.animationLoopCallback);
            this.loadingAnimation.start();
        } else {
            setMinimumWidth(0);
            setTextScaleX(1.0f);
            setContentDescription(null);
            setIcon(null);
            this.loadingAnimation.setCallback(null);
            this.loadingAnimation.stop();
        }
        setClickable(this.rendering.getState().isClickable$zendesk_ui_ui_android());
        TypedValue typedValue = new TypedValue();
        getContext().getResources().getValue(R.dimen.zuia_carousel_button_corner_size, typedValue, true);
        final float f = typedValue.getFloat();
        final int integer = getResources().getInteger(R.integer.zuia_button_line_count);
        post(new Runnable() {
            @Override
            public final void run() {
                ButtonView.render$lambda$4(this.f$0, integer, f);
            }
        });
    }

    public static final void render$lambda$2$lambda$1(ButtonView buttonView, int i) {
        Intrinsics.checkNotNullParameter(buttonView, "this$0");
        buttonView.loadingAnimation.setColorFilter(BlendModeColorFilterCompat.createBlendModeColorFilterCompat(i, BlendModeCompat.SRC_ATOP));
    }

    public static final void render$lambda$4(ButtonView buttonView, int i, float f) {
        Intrinsics.checkNotNullParameter(buttonView, "this$0");
        if (buttonView.getLineCount() >= i) {
            buttonView.setShapeAppearanceModel(new ShapeAppearanceModel().withCornerSize(f));
        }
    }

    public final void stopAnimation$zendesk_ui_ui_android() {
        AnimatedVectorDrawableCompat animatedVectorDrawableCompat = this.loadingAnimation;
        if (animatedVectorDrawableCompat != null) {
            animatedVectorDrawableCompat.setCallback(null);
        }
        AnimatedVectorDrawableCompat animatedVectorDrawableCompat2 = this.loadingAnimation;
        if (animatedVectorDrawableCompat2 != null) {
            animatedVectorDrawableCompat2.stop();
        }
    }
}
