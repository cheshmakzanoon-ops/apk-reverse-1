package zendesk.p026ui.android.conversation.actionbutton;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;
import android.util.TypedValue;
import android.view.ViewGroup;
import android.webkit.URLUtil;
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
import zendesk.p026ui.android.internal.ColorExtKt;
import zendesk.p026ui.android.internal.ThrottledOnClickListenerKt;
import zendesk.ui.android.R;
import zendesk.ui.android.Renderer;

@Metadata(m17d1 = {"\u0000B\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0007\u0018\u0000 \u00162\u00020\u00012\b\u0012\u0004\u0012\u00020\u00030\u0002:\u0001\u0016B%\b\u0007\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t¢\u0006\u0002\u0010\nJ\u001c\u0010\u0010\u001a\u00020\u00112\u0012\u0010\u0012\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00030\u0013H\u0016J\r\u0010\u0014\u001a\u00020\u0011H\u0001¢\u0006\u0002\b\u0015R\u000e\u0010\u000b\u001a\u00020\fX\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\r\u001a\u0004\u0018\u00010\u000eX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000f\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0017"}, m18d2 = {"Lzendesk/ui/android/conversation/actionbutton/ActionButtonView;", "Lcom/google/android/material/button/MaterialButton;", "Lzendesk/ui/android/Renderer;", "Lzendesk/ui/android/conversation/actionbutton/ActionButtonRendering;", "context", "Landroid/content/Context;", "attrs", "Landroid/util/AttributeSet;", "defStyleAttrs", "", "(Landroid/content/Context;Landroid/util/AttributeSet;I)V", "animationLoopCallback", "Landroidx/vectordrawable/graphics/drawable/Animatable2Compat$AnimationCallback;", "loadingAnimation", "Landroidx/vectordrawable/graphics/drawable/AnimatedVectorDrawableCompat;", "rendering", "render", "", "renderingUpdate", "Lkotlin/Function1;", "stopAnimation", "stopAnimation$zendesk_ui_ui_android", "Companion", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ActionButtonView extends MaterialButton implements Renderer<ActionButtonRendering> {
    private static final String WEBVIEW_MESSAGE_ACTION = "WEBVIEW_MESSAGE_ACTION";
    private final Animatable2Compat.AnimationCallback animationLoopCallback;
    private final AnimatedVectorDrawableCompat loadingAnimation;
    private ActionButtonRendering rendering;
    private static final Companion Companion = new Companion(null);
    public static final int $stable = 8;

    public ActionButtonView(Context context) {
        this(context, null, 0, 6, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ActionButtonView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0, 4, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ActionButtonView(Context context, AttributeSet attributeSet, int i, int i2, DefaultConstructorMarker defaultConstructorMarker) {
        this(context, (i2 & 2) != 0 ? null : attributeSet, (i2 & 4) != 0 ? R.attr.actionButtonStyle : i);
    }

    public ActionButtonView(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        Intrinsics.checkNotNullParameter(context, "context");
        this.loadingAnimation = AnimatedVectorDrawableCompat.create(context, R.drawable.zuia_animation_loading_juggle);
        this.animationLoopCallback = new ActionButtonView$animationLoopCallback$1(this);
        this.rendering = new ActionButtonRendering();
        setLayoutParams(new ViewGroup.LayoutParams(-1, -2));
        render(new Function1<ActionButtonRendering, ActionButtonRendering>() {
            @Override
            public final ActionButtonRendering invoke(ActionButtonRendering it) {
                Intrinsics.checkNotNullParameter(it, "it");
                return it;
            }
        });
    }

    public void render(Function1<? super ActionButtonRendering, ActionButtonRendering> renderingUpdate) {
        String text$zendesk_ui_ui_android;
        int iResolveColorAttr;
        Intrinsics.checkNotNullParameter(renderingUpdate, "renderingUpdate");
        ActionButtonRendering actionButtonRenderingInvoke = renderingUpdate.invoke(this.rendering);
        this.rendering = actionButtonRenderingInvoke;
        if (!actionButtonRenderingInvoke.getState().isLoading$zendesk_ui_ui_android()) {
            text$zendesk_ui_ui_android = this.rendering.getState().getText$zendesk_ui_ui_android();
        }
        setText(text$zendesk_ui_ui_android);
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
        if (this.rendering.getState().isSupported$zendesk_ui_ui_android()) {
            setOnClickListener(ThrottledOnClickListenerKt.throttledOnClickListener$default(0L, new Function0<Unit>() {
                {
                    super(0);
                }

                @Override
                public Unit invoke() {
                    invoke2();
                    return Unit.INSTANCE;
                }

                public final void invoke2() {
                    ActionButtonState state = ActionButtonView.this.rendering.getState();
                    ActionButtonView actionButtonView = ActionButtonView.this;
                    String uri$zendesk_ui_ui_android = state.getUri$zendesk_ui_ui_android();
                    if (uri$zendesk_ui_ui_android != null && uri$zendesk_ui_ui_android.length() != 0 && state.getUrlSource$zendesk_ui_ui_android() != null && !Intrinsics.areEqual(state.getUrlSource$zendesk_ui_ui_android(), ActionButtonView.WEBVIEW_MESSAGE_ACTION)) {
                        actionButtonView.rendering.getOnActionButtonClicked$zendesk_ui_ui_android().invoke(state.getUri$zendesk_ui_ui_android(), state.getUrlSource$zendesk_ui_ui_android());
                        return;
                    }
                    String uri$zendesk_ui_ui_android2 = state.getUri$zendesk_ui_ui_android();
                    if (uri$zendesk_ui_ui_android2 != null && uri$zendesk_ui_ui_android2.length() != 0 && Intrinsics.areEqual(state.getUrlSource$zendesk_ui_ui_android(), ActionButtonView.WEBVIEW_MESSAGE_ACTION) && URLUtil.isValidUrl(state.getUri$zendesk_ui_ui_android())) {
                        actionButtonView.rendering.getOnWebViewActionButtonClicked$zendesk_ui_ui_android().invoke(state.getUri$zendesk_ui_ui_android(), state.getSize$zendesk_ui_ui_android(), state.getUrlSource$zendesk_ui_ui_android());
                        return;
                    }
                    String actionId$zendesk_ui_ui_android = state.getActionId$zendesk_ui_ui_android();
                    if (actionId$zendesk_ui_ui_android == null || actionId$zendesk_ui_ui_android.length() == 0) {
                        return;
                    }
                    actionButtonView.rendering.getOnPostbackButtonClicked$zendesk_ui_ui_android().invoke(state.getActionId$zendesk_ui_ui_android(), state.getText$zendesk_ui_ui_android());
                }
            }, 1, null));
            if (this.loadingAnimation == null) {
                return;
            }
            Integer loadingColor$zendesk_ui_ui_android = this.rendering.getState().getLoadingColor$zendesk_ui_ui_android();
            if (loadingColor$zendesk_ui_ui_android != null) {
                final int iIntValue = loadingColor$zendesk_ui_ui_android.intValue();
                post(new Runnable() {
                    @Override
                    public final void run() {
                        ActionButtonView.render$lambda$2$lambda$1(this.f$0, iIntValue);
                    }
                });
            }
            if (this.rendering.getState().isLoading$zendesk_ui_ui_android()) {
                setMinimumWidth(getWidth());
                setContentDescription(getResources().getString(R.string.zuia_accessibility_loading_label));
                setIcon((Drawable) this.loadingAnimation);
                this.loadingAnimation.registerAnimationCallback(this.animationLoopCallback);
                this.loadingAnimation.start();
            } else {
                setMinimumWidth(0);
                setTextScaleX(1.0f);
                setContentDescription(null);
                setIcon(null);
                this.loadingAnimation.setCallback((Drawable.Callback) null);
                this.loadingAnimation.stop();
            }
        } else {
            setClickable(false);
        }
        TypedValue typedValue = new TypedValue();
        getContext().getResources().getValue(R.dimen.zuia_carousel_button_corner_size, typedValue, true);
        final float f = typedValue.getFloat();
        final int integer = getResources().getInteger(R.integer.zuia_button_line_count);
        post(new Runnable() {
            @Override
            public final void run() {
                ActionButtonView.render$lambda$4(this.f$0, integer, f);
            }
        });
    }

    public static final void render$lambda$2$lambda$1(ActionButtonView this$0, int i) {
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        this$0.loadingAnimation.setColorFilter(BlendModeColorFilterCompat.createBlendModeColorFilterCompat(i, BlendModeCompat.SRC_ATOP));
    }

    public static final void render$lambda$4(ActionButtonView this$0, int i, float f) {
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        if (this$0.getLineCount() >= i) {
            this$0.setShapeAppearanceModel(new ShapeAppearanceModel().withCornerSize(f));
        }
    }

    public final void stopAnimation$zendesk_ui_ui_android() {
        AnimatedVectorDrawableCompat animatedVectorDrawableCompat = this.loadingAnimation;
        if (animatedVectorDrawableCompat != null) {
            animatedVectorDrawableCompat.setCallback((Drawable.Callback) null);
        }
        AnimatedVectorDrawableCompat animatedVectorDrawableCompat2 = this.loadingAnimation;
        if (animatedVectorDrawableCompat2 != null) {
            animatedVectorDrawableCompat2.stop();
        }
    }

    @Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000¨\u0006\u0005"}, m18d2 = {"Lzendesk/ui/android/conversation/actionbutton/ActionButtonView$Companion;", "", "()V", ActionButtonView.WEBVIEW_MESSAGE_ACTION, "", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
