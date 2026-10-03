package zendesk.p026ui.android.conversation.receipt;

import android.content.Context;
import android.graphics.PorterDuff;
import android.util.AttributeSet;
import android.view.View;
import android.view.animation.AccelerateDecelerateInterpolator;
import android.view.animation.AccelerateInterpolator;
import android.view.animation.DecelerateInterpolator;
import android.view.animation.LinearInterpolator;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.p026ui.android.internal.ColorExtKt;
import zendesk.ui.android.R;
import zendesk.ui.android.Renderer;

@Metadata(m17d1 = {"\u0000P\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\b\b\u0007\u0018\u0000 '2\u00020\u00012\b\u0012\u0004\u0012\u00020\u00030\u0002:\u0001'B/\b\u0007\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t\u0012\b\b\u0002\u0010\n\u001a\u00020\t¢\u0006\u0002\u0010\u000bJ\b\u0010\u0012\u001a\u00020\u0013H\u0002J\b\u0010\u0014\u001a\u00020\u0013H\u0002J\b\u0010\u0015\u001a\u00020\u0013H\u0002J\b\u0010\u0016\u001a\u00020\u0013H\u0002J\b\u0010\u0017\u001a\u00020\u0013H\u0002J\b\u0010\u0018\u001a\u00020\u0013H\u0002J-\u0010\u0019\u001a\u00020\u00132\b\b\u0001\u0010\u001a\u001a\u00020\t2\u0019\b\u0002\u0010\u001b\u001a\u0013\u0012\u0004\u0012\u00020\u0001\u0012\u0004\u0012\u00020\u00130\u001c¢\u0006\u0002\b\u001dH\u0002J\u0010\u0010\u001e\u001a\u00020\t2\u0006\u0010\u001f\u001a\u00020 H\u0003J\u001c\u0010!\u001a\u00020\u00132\u0012\u0010\"\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00030\u001cH\u0016J\b\u0010#\u001a\u00020\u0013H\u0002J\b\u0010$\u001a\u00020\u0013H\u0002J\r\u0010%\u001a\u00020\u0013H\u0001¢\u0006\u0002\b&R\u000e\u0010\f\u001a\u00020\u0001X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\r\u001a\u00020\u000eX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000f\u001a\u00020\u0010X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0011\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006("}, m18d2 = {"Lzendesk/ui/android/conversation/receipt/MessageReceiptView;", "Landroid/widget/LinearLayout;", "Lzendesk/ui/android/Renderer;", "Lzendesk/ui/android/conversation/receipt/MessageReceiptRendering;", "context", "Landroid/content/Context;", "attrs", "Landroid/util/AttributeSet;", "defStyleAttrs", "", "defStyleRes", "(Landroid/content/Context;Landroid/util/AttributeSet;II)V", "container", "iconImage", "Landroid/widget/ImageView;", "labelText", "Landroid/widget/TextView;", "rendering", "animateIconScaleDown", "", "animateIconScaleUp", "animateTailDrop", "animateTextFadeIn", "announceFailedStatusForAccessibility", "buildLabelAndIconViews", "formatIconView", "imageResource", "containerBlock", "Lkotlin/Function1;", "Lkotlin/ExtensionFunctionType;", "getLabelColor", "position", "Lzendesk/ui/android/conversation/receipt/MessageReceiptPosition;", "render", "renderingUpdate", "resetAnimation", "startAnimation", "stopAnimation", "stopAnimation$zendesk_ui_ui_android", "Companion", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class MessageReceiptView extends LinearLayout implements Renderer<MessageReceiptRendering> {
    private static final long ACCESSIBILITY_EVENT_DELAY = 500;
    private static final float DOWN_START_TRANSLATION = -12.0f;
    private static final float DOWN_TRANSLATION = 0.0f;
    private static final long FADE_DURATION = 300;
    private static final long OPACITY_ANIMATION_DELAY = 100;
    private static final long OPACITY_ANIMATION_DURATION = 200;
    private static final long PULSE_DURATION = 600;
    private static final float SCALE_DOWN = 1.0f;
    private static final float SCALE_UP = 1.5f;
    private static final long TRANSLATION_DELAY = 300;
    private static final long TRANSLATION_DURATION = 300;
    private final LinearLayout container;
    private final ImageView iconImage;
    private final TextView labelText;
    private MessageReceiptRendering rendering;
    private static final Companion Companion = new Companion(null);
    public static final int $stable = 8;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[MessageReceiptPosition.values().length];
            try {
                iArr[MessageReceiptPosition.NONE.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[MessageReceiptPosition.INBOUND.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                iArr[MessageReceiptPosition.OUTBOUND_SENT.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            try {
                iArr[MessageReceiptPosition.OUTBOUND_SENDING.ordinal()] = 4;
            } catch (NoSuchFieldError unused4) {
            }
            try {
                iArr[MessageReceiptPosition.OUTBOUND_FAILED.ordinal()] = 5;
            } catch (NoSuchFieldError unused5) {
            }
            try {
                iArr[MessageReceiptPosition.INBOUND_FAILED.ordinal()] = 6;
            } catch (NoSuchFieldError unused6) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    public MessageReceiptView(Context context) {
        this(context, null, 0, 0, 14, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public MessageReceiptView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0, 0, 12, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public MessageReceiptView(Context context, AttributeSet attributeSet, int i) {
        this(context, attributeSet, i, 0, 8, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public MessageReceiptView(Context context, AttributeSet attributeSet, int i, int i2, int i3, DefaultConstructorMarker defaultConstructorMarker) {
        this(context, (i3 & 2) != 0 ? null : attributeSet, (i3 & 4) != 0 ? 0 : i, (i3 & 8) != 0 ? 0 : i2);
    }

    public MessageReceiptView(Context context, AttributeSet attributeSet, int i, int i2) {
        super(context, attributeSet, i, i2);
        Intrinsics.checkNotNullParameter(context, "context");
        this.rendering = new MessageReceiptRendering();
        context.getTheme().applyStyle(R.style.ThemeOverlay_ZendeskComponents_MessageReceipt, false);
        LinearLayout.inflate(context, R.layout.zuia_view_message_receipt, this);
        View viewFindViewById = findViewById(R.id.zuia_message_receipt_container);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById, "findViewById(...)");
        this.container = (LinearLayout) viewFindViewById;
        View viewFindViewById2 = findViewById(R.id.zuia_icon_image);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById2, "findViewById(...)");
        this.iconImage = (ImageView) viewFindViewById2;
        View viewFindViewById3 = findViewById(R.id.zuia_label_text);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById3, "findViewById(...)");
        this.labelText = (TextView) viewFindViewById3;
        render(new Function1<MessageReceiptRendering, MessageReceiptRendering>() {
            @Override
            public final MessageReceiptRendering invoke(MessageReceiptRendering it) {
                Intrinsics.checkNotNullParameter(it, "it");
                return it;
            }
        });
    }

    public void render(Function1<? super MessageReceiptRendering, MessageReceiptRendering> renderingUpdate) {
        Intrinsics.checkNotNullParameter(renderingUpdate, "renderingUpdate");
        MessageReceiptRendering messageReceiptRenderingInvoke = renderingUpdate.invoke(this.rendering);
        this.rendering = messageReceiptRenderingInvoke;
        this.labelText.setVisibility(messageReceiptRenderingInvoke.getState().getShouldAnimateReceipt$zendesk_ui_ui_android() ? 4 : 0);
        this.labelText.setText(this.rendering.getState().getLabel$zendesk_ui_ui_android());
        TextView textView = this.labelText;
        Integer labelColor$zendesk_ui_ui_android = this.rendering.getState().getLabelColor$zendesk_ui_ui_android();
        textView.setTextColor(labelColor$zendesk_ui_ui_android != null ? labelColor$zendesk_ui_ui_android.intValue() : getLabelColor(this.rendering.getState().getMessageReceiptPosition$zendesk_ui_ui_android()));
        buildLabelAndIconViews();
        startAnimation();
    }

    private final void startAnimation() {
        int i = WhenMappings.$EnumSwitchMapping$0[this.rendering.getState().getMessageReceiptPosition$zendesk_ui_ui_android().ordinal()];
        if (i == 3 || i == 4) {
            animateTailDrop();
        } else if (i == 5 || i == 6) {
            this.labelText.setVisibility(0);
        }
    }

    private final void animateTailDrop() {
        if (this.rendering.getState().getShouldAnimateReceipt$zendesk_ui_ui_android()) {
            final ImageView imageView = this.iconImage;
            imageView.animate().cancel();
            imageView.setAlpha(DOWN_TRANSLATION);
            imageView.setVisibility(4);
            imageView.setTranslationY(DOWN_START_TRANSLATION);
            imageView.animate().translationY(DOWN_TRANSLATION).setStartDelay(300L).setDuration(300L).setInterpolator(new AccelerateDecelerateInterpolator()).withStartAction(new Runnable() {
                @Override
                public final void run() {
                    MessageReceiptView.animateTailDrop$lambda$3$lambda$0(imageView);
                }
            }).withEndAction(new Runnable() {
                @Override
                public final void run() {
                    MessageReceiptView.animateTailDrop$lambda$3$lambda$1(imageView, this);
                }
            }).start();
        }
    }

    public static final void animateTailDrop$lambda$3$lambda$0(ImageView this_apply) {
        Intrinsics.checkNotNullParameter(this_apply, "$this_apply");
        this_apply.animate().alpha(1.0f).setStartDelay(OPACITY_ANIMATION_DELAY).setDuration(OPACITY_ANIMATION_DURATION).setInterpolator(new LinearInterpolator()).start();
    }

    public static final void animateTailDrop$lambda$3$lambda$1(ImageView this_apply, MessageReceiptView this$0) {
        Intrinsics.checkNotNullParameter(this_apply, "$this_apply");
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        this_apply.setVisibility(0);
        this$0.animateTextFadeIn();
        if (this$0.rendering.getState().getMessageReceiptPosition$zendesk_ui_ui_android() == MessageReceiptPosition.OUTBOUND_SENDING) {
            this$0.animateIconScaleUp();
        } else {
            this$0.labelText.setVisibility(0);
        }
    }

    private final void animateIconScaleUp() {
        ImageView imageView = this.iconImage;
        imageView.setPivotX(SCALE_UP);
        imageView.setPivotY(1.0f);
        imageView.animate().scaleX(SCALE_UP).scaleY(SCALE_UP).setDuration(PULSE_DURATION).setInterpolator(new DecelerateInterpolator()).withEndAction(new Runnable() {
            @Override
            public final void run() {
                MessageReceiptView.animateIconScaleUp$lambda$5$lambda$4(this.f$0);
            }
        }).start();
    }

    public static final void animateIconScaleUp$lambda$5$lambda$4(MessageReceiptView this$0) {
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        if (this$0.rendering.getState().getShouldAnimateReceipt$zendesk_ui_ui_android()) {
            this$0.animateIconScaleDown();
        } else {
            this$0.resetAnimation();
        }
    }

    private final void animateIconScaleDown() {
        ImageView imageView = this.iconImage;
        imageView.setPivotX(SCALE_UP);
        imageView.setPivotY(1.0f);
        imageView.animate().scaleX(1.0f).scaleY(1.0f).setInterpolator(new AccelerateInterpolator()).setDuration(PULSE_DURATION).withEndAction(new Runnable() {
            @Override
            public final void run() {
                MessageReceiptView.animateIconScaleDown$lambda$7$lambda$6(this.f$0);
            }
        }).start();
    }

    public static final void animateIconScaleDown$lambda$7$lambda$6(MessageReceiptView this$0) {
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        if (this$0.rendering.getState().getShouldAnimateReceipt$zendesk_ui_ui_android()) {
            this$0.animateIconScaleUp();
        } else {
            this$0.resetAnimation();
        }
    }

    private final void resetAnimation() {
        ImageView imageView = this.iconImage;
        imageView.animate().scaleX(1.0f).scaleY(1.0f).start();
        imageView.clearAnimation();
    }

    private final void animateTextFadeIn() {
        final TextView textView = this.labelText;
        textView.animate().cancel();
        textView.setAlpha(DOWN_TRANSLATION);
        textView.setVisibility(4);
        textView.animate().alpha(1.0f).setDuration(300L).withEndAction(new Runnable() {
            @Override
            public final void run() {
                MessageReceiptView.animateTextFadeIn$lambda$10$lambda$9(textView);
            }
        }).start();
    }

    public static final void animateTextFadeIn$lambda$10$lambda$9(TextView this_apply) {
        Intrinsics.checkNotNullParameter(this_apply, "$this_apply");
        this_apply.setVisibility(0);
    }

    private final int getLabelColor(MessageReceiptPosition position) {
        switch (WhenMappings.$EnumSwitchMapping$0[position.ordinal()]) {
            case 1:
            case 2:
                Context context = getContext();
                Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
                return ColorExtKt.resolveColorAttr(context, R.attr.messageReceiptInboundLabelColor);
            case 3:
            case 4:
                Context context2 = getContext();
                Intrinsics.checkNotNullExpressionValue(context2, "getContext(...)");
                return ColorExtKt.resolveColorAttr(context2, R.attr.messageReceiptOutboundLabelColor);
            case 5:
            case 6:
                Context context3 = getContext();
                Intrinsics.checkNotNullExpressionValue(context3, "getContext(...)");
                return ColorExtKt.resolveColorAttr(context3, R.attr.messageReceiptOutboundFailedLabelColor);
            default:
                throw new NoWhenBranchMatchedException();
        }
    }

    private final void buildLabelAndIconViews() {
        this.container.removeAllViews();
        int i = WhenMappings.$EnumSwitchMapping$0[this.rendering.getState().getMessageReceiptPosition$zendesk_ui_ui_android().ordinal()];
        if (i == 2) {
            formatIconView(R.drawable.zuia_message_status_inbound, new Function1<LinearLayout, Unit>() {
                {
                    super(1);
                }

                @Override
                public Unit invoke(LinearLayout linearLayout) {
                    invoke2(linearLayout);
                    return Unit.INSTANCE;
                }

                public final void invoke2(LinearLayout formatIconView) {
                    Intrinsics.checkNotNullParameter(formatIconView, "$this$formatIconView");
                    if (MessageReceiptView.this.rendering.getState().getShowIcon$zendesk_ui_ui_android()) {
                        formatIconView.addView(MessageReceiptView.this.iconImage);
                    }
                    formatIconView.addView(MessageReceiptView.this.labelText);
                }
            });
            return;
        }
        if (i == 3) {
            formatIconView$default(this, R.drawable.zuia_message_status_outbound_sent, null, 2, null);
            return;
        }
        if (i == 4) {
            formatIconView$default(this, R.drawable.zuia_message_status_outbound_sending, null, 2, null);
            return;
        }
        if (i == 5) {
            formatIconView$default(this, R.drawable.zuia_message_status_outbound_failed, null, 2, null);
            announceFailedStatusForAccessibility();
        } else {
            if (i != 6) {
                return;
            }
            formatIconView(R.drawable.zuia_message_status_outbound_failed, new Function1<LinearLayout, Unit>() {
                {
                    super(1);
                }

                @Override
                public Unit invoke(LinearLayout linearLayout) {
                    invoke2(linearLayout);
                    return Unit.INSTANCE;
                }

                public final void invoke2(LinearLayout formatIconView) {
                    Intrinsics.checkNotNullParameter(formatIconView, "$this$formatIconView");
                    if (MessageReceiptView.this.rendering.getState().getShowIcon$zendesk_ui_ui_android()) {
                        formatIconView.addView(MessageReceiptView.this.iconImage);
                    }
                    formatIconView.addView(MessageReceiptView.this.labelText);
                }
            });
            announceFailedStatusForAccessibility();
        }
    }

    private final void announceFailedStatusForAccessibility() {
        this.labelText.postDelayed(new Runnable() {
            @Override
            public final void run() {
                MessageReceiptView.announceFailedStatusForAccessibility$lambda$11(this.f$0);
            }
        }, ACCESSIBILITY_EVENT_DELAY);
    }

    public static final void announceFailedStatusForAccessibility$lambda$11(MessageReceiptView this$0) {
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        this$0.labelText.sendAccessibilityEvent(8);
    }

    static void formatIconView$default(MessageReceiptView messageReceiptView, int i, Function1 function1, int i2, Object obj) {
        if ((i2 & 2) != 0) {
            function1 = new Function1<LinearLayout, Unit>() {
                {
                    super(1);
                }

                @Override
                public Unit invoke(LinearLayout linearLayout) {
                    invoke2(linearLayout);
                    return Unit.INSTANCE;
                }

                public final void invoke2(LinearLayout linearLayout) {
                    Intrinsics.checkNotNullParameter(linearLayout, "$this$null");
                    linearLayout.addView(MessageReceiptView.this.labelText);
                    if (MessageReceiptView.this.rendering.getState().getShowIcon$zendesk_ui_ui_android()) {
                        linearLayout.addView(MessageReceiptView.this.iconImage);
                    }
                }
            };
        }
        messageReceiptView.formatIconView(i, function1);
    }

    private final void formatIconView(int imageResource, Function1<? super LinearLayout, Unit> containerBlock) {
        this.iconImage.setImageResource(imageResource);
        Integer iconColor$zendesk_ui_ui_android = this.rendering.getState().getIconColor$zendesk_ui_ui_android();
        if (iconColor$zendesk_ui_ui_android != null) {
            this.iconImage.setColorFilter(iconColor$zendesk_ui_ui_android.intValue(), PorterDuff.Mode.SRC_IN);
        }
        containerBlock.invoke(this.container);
    }

    public final void stopAnimation$zendesk_ui_ui_android() {
        this.labelText.animate().cancel();
        this.labelText.setVisibility(0);
        this.iconImage.animate().cancel();
        this.iconImage.setVisibility(0);
    }

    @Metadata(m17d1 = {"\u0000\u001a\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\t\n\u0000\n\u0002\u0010\u0007\n\u0002\b\n\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0006X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0007\u001a\u00020\u0006X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\t\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\n\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u000b\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\f\u001a\u00020\u0006X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\r\u001a\u00020\u0006X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u000e\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u000f\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000¨\u0006\u0010"}, m18d2 = {"Lzendesk/ui/android/conversation/receipt/MessageReceiptView$Companion;", "", "()V", "ACCESSIBILITY_EVENT_DELAY", "", "DOWN_START_TRANSLATION", "", "DOWN_TRANSLATION", "FADE_DURATION", "OPACITY_ANIMATION_DELAY", "OPACITY_ANIMATION_DURATION", "PULSE_DURATION", "SCALE_DOWN", "SCALE_UP", "TRANSLATION_DELAY", "TRANSLATION_DURATION", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
