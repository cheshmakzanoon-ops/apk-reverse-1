package zendesk.p009ui.android.common.buttonbanner;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.animation.AnimatorSet;
import android.animation.ObjectAnimator;
import android.content.Context;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.graphics.drawable.LayerDrawable;
import android.os.Parcel;
import android.os.Parcelable;
import android.util.AttributeSet;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.core.content.ContextCompat;
import com.facebook.internal.ServerProtocol;
import kotlin.Metadata;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.text.StringsKt;
import zendesk.ui.android.R;
import zendesk.ui.android.Renderer;
import zendesk.ui.android.internal.ColorExtKt;

@Metadata(d1 = {"\u0000Z\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\b\u0007\u0018\u0000 %2\u00020\u00012\b\u0012\u0004\u0012\u00020\u00030\u0002:\u0002%&B/\b\u0007\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t\u0012\b\b\u0002\u0010\n\u001a\u00020\t¢\u0006\u0002\u0010\u000bJ\b\u0010\u0019\u001a\u00020\u001aH\u0002J\b\u0010\u001b\u001a\u00020\u001aH\u0002J\u0012\u0010\u001c\u001a\u00020\u001a2\b\u0010\u001d\u001a\u0004\u0018\u00010\u001eH\u0014J\b\u0010\u001f\u001a\u00020\u001eH\u0014J\u001c\u0010 \u001a\u00020\u001a2\u0012\u0010!\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00030\"H\u0016J\b\u0010#\u001a\u00020\u001aH\u0002J\b\u0010$\u001a\u00020\u001aH\u0002R\u000e\u0010\f\u001a\u00020\rX\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u000e\u001a\u00020\u000fX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0010\u001a\u00020\u000fX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0011\u001a\u00020\u0012X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0013\u001a\u00020\u0014X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0015\u001a\u00020\u0012X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0016\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0017\u001a\u00020\u0001X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0018\u001a\u00020\u0001X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006'"}, d2 = {"Lzendesk/ui/android/common/buttonbanner/ButtonBannerView;", "Landroidx/constraintlayout/widget/ConstraintLayout;", "Lzendesk/ui/android/Renderer;", "Lzendesk/ui/android/common/buttonbanner/ButtonBannerRendering;", "context", "Landroid/content/Context;", "attrs", "Landroid/util/AttributeSet;", "defStyleAttrs", "", "defStyleRes", "(Landroid/content/Context;Landroid/util/AttributeSet;II)V", "animatorSet", "Landroid/animation/AnimatorSet;", "arrowDown", "Landroid/widget/ImageView;", "dismissButton", "dismissButtonAccessibility", "Landroid/view/View;", "label", "Landroid/widget/TextView;", "labelAccessibility", "rendering", "unreadMessagesView", "unreadMessagesViewAccessibility", "announceAccessibility", "", "hideUnreadMessagesView", "onRestoreInstanceState", ServerProtocol.DIALOG_PARAM_STATE, "Landroid/os/Parcelable;", "onSaveInstanceState", "render", "renderingUpdate", "Lkotlin/Function1;", "showUnreadMessagesView", "toastDismissAnimation", "Companion", "SavedState", "zendesk.ui_ui-android"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class ButtonBannerView extends ConstraintLayout implements Renderer<ButtonBannerRendering> {
    private static final String ALPHA_PROPERTY_NAME = "alpha";
    private static final float ALPHA_TRANSPARENT = 0.0f;
    private static final float ALPHA_VISIBLE = 1.0f;
    private AnimatorSet animatorSet;
    private final ImageView arrowDown;
    private final ImageView dismissButton;
    private final View dismissButtonAccessibility;
    private final TextView label;
    private final View labelAccessibility;
    private ButtonBannerRendering rendering;
    private final ConstraintLayout unreadMessagesView;
    private final ConstraintLayout unreadMessagesViewAccessibility;
    private static final Companion Companion = new Companion(null);
    public static final int $stable = 8;

    @Metadata(k = 3, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[ButtonBannerViewType.values().length];
            try {
                iArr[ButtonBannerViewType.NEW_MESSAGES.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[ButtonBannerViewType.SEE_LATEST.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                iArr[ButtonBannerViewType.FAILED_BANNER.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    public ButtonBannerView(Context context) {
        this(context, null, 0, 0, 14, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ButtonBannerView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0, 0, 12, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ButtonBannerView(Context context, AttributeSet attributeSet, int i) {
        this(context, attributeSet, i, 0, 8, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ButtonBannerView(Context context, AttributeSet attributeSet, int i, int i2, int i3, DefaultConstructorMarker defaultConstructorMarker) {
        this(context, (i3 & 2) != 0 ? null : attributeSet, (i3 & 4) != 0 ? 0 : i, (i3 & 8) != 0 ? 0 : i2);
    }

    public ButtonBannerView(Context context, AttributeSet attributeSet, int i, int i2) {
        super(context, attributeSet, i, i2);
        Intrinsics.checkNotNullParameter(context, "context");
        this.rendering = new ButtonBannerRendering();
        this.animatorSet = new AnimatorSet();
        context.getTheme().applyStyle(R.style.ThemeOverlay_ZendeskComponents_UnreadMessagesStyle, false);
        ConstraintLayout.inflate(context, R.layout.zuia_view_unread_messages, this);
        View viewFindViewById = findViewById(R.id.zuia_unread_messages_view);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById, "findViewById(...)");
        this.unreadMessagesView = (ConstraintLayout) viewFindViewById;
        View viewFindViewById2 = findViewById(R.id.zuia_unread_messages_accessibility);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById2, "findViewById(...)");
        this.unreadMessagesViewAccessibility = (ConstraintLayout) viewFindViewById2;
        View viewFindViewById3 = findViewById(R.id.zuia_unread_messages_label);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById3, "findViewById(...)");
        this.label = (TextView) viewFindViewById3;
        View viewFindViewById4 = findViewById(R.id.zuia_unread_messages_label_accessibility);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById4, "findViewById(...)");
        this.labelAccessibility = viewFindViewById4;
        View viewFindViewById5 = findViewById(R.id.zuia_dismiss);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById5, "findViewById(...)");
        this.dismissButton = (ImageView) viewFindViewById5;
        View viewFindViewById6 = findViewById(R.id.zuia_dismiss_accessibility);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById6, "findViewById(...)");
        this.dismissButtonAccessibility = viewFindViewById6;
        View viewFindViewById7 = findViewById(R.id.zuia_arrow_down);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById7, "findViewById(...)");
        this.arrowDown = (ImageView) viewFindViewById7;
        setVisibility(8);
        render(new Function1<ButtonBannerRendering, ButtonBannerRendering>() {
            public final ButtonBannerRendering invoke(ButtonBannerRendering buttonBannerRendering) {
                Intrinsics.checkNotNullParameter(buttonBannerRendering, "it");
                return buttonBannerRendering;
            }
        });
    }

    @Metadata(d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0007\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0003\u0018\u00002\u00020\u0001B\u0017\u0012\b\u0010\u0002\u001a\u0004\u0018\u00010\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\t\u0010\u000b\u001a\u00020\u0005HÖ\u0001J\u0019\u0010\f\u001a\u00020\r2\u0006\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\u0005HÖ\u0001R\u0013\u0010\u0002\u001a\u0004\u0018\u00010\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\bR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\n¨\u0006\u0011"}, d2 = {"Lzendesk/ui/android/common/buttonbanner/ButtonBannerView$SavedState;", "Landroid/view/View$BaseSavedState;", ServerProtocol.DIALOG_PARAM_STATE, "Landroid/os/Parcelable;", "visibility", "", "(Landroid/os/Parcelable;I)V", "getState", "()Landroid/os/Parcelable;", "getVisibility", "()I", "describeContents", "writeToParcel", "", "parcel", "Landroid/os/Parcel;", "flags", "zendesk.ui_ui-android"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    private static final class SavedState extends View.BaseSavedState {
        public static final Parcelable.Creator<SavedState> CREATOR = new Creator();
        private final Parcelable state;
        private final int visibility;

        @Metadata(k = 3, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
        public static final class Creator implements Parcelable.Creator<SavedState> {
            @Override
            public final SavedState createFromParcel(Parcel parcel) {
                Intrinsics.checkNotNullParameter(parcel, "parcel");
                return new SavedState(parcel.readParcelable(SavedState.class.getClassLoader()), parcel.readInt());
            }

            @Override
            public final SavedState[] newArray(int i) {
                return new SavedState[i];
            }
        }

        @Override
        public int describeContents() {
            return 0;
        }

        @Override
        public void writeToParcel(Parcel parcel, int flags) {
            Intrinsics.checkNotNullParameter(parcel, "out");
            parcel.writeParcelable(this.state, flags);
            parcel.writeInt(this.visibility);
        }

        public final Parcelable getState() {
            return this.state;
        }

        public final int getVisibility() {
            return this.visibility;
        }

        public SavedState(Parcelable parcelable, int i) {
            super(parcelable);
            this.state = parcelable;
            this.visibility = i;
        }
    }

    @Override
    protected Parcelable onSaveInstanceState() {
        return new SavedState(super.onSaveInstanceState(), getVisibility());
    }

    @Override
    protected void onRestoreInstanceState(Parcelable state) {
        if (!(state instanceof SavedState)) {
            super.onRestoreInstanceState(state);
            return;
        }
        SavedState savedState = (SavedState) state;
        super.onRestoreInstanceState(savedState.getSuperState());
        setVisibility(savedState.getVisibility());
    }

    public void render(Function1<? super ButtonBannerRendering, ButtonBannerRendering> renderingUpdate) {
        int iResolveColorAttr;
        int iResolveColorAttr2;
        int iResolveColorAttr3;
        int iResolveColorAttr4;
        int iResolveColorAttr5;
        int iResolveColorAttr6;
        Intrinsics.checkNotNullParameter(renderingUpdate, "renderingUpdate");
        this.rendering = (ButtonBannerRendering) renderingUpdate.invoke(this.rendering);
        this.labelAccessibility.setOnClickListener(new View.OnClickListener() {
            @Override
            public final void onClick(View view) {
                ButtonBannerView.render$lambda$0(this.f$0, view);
            }
        });
        ImageView imageView = this.dismissButton;
        Integer buttonsBackgroundColor$zendesk_ui_ui_android = this.rendering.getState().getButtonsBackgroundColor$zendesk_ui_ui_android();
        if (buttonsBackgroundColor$zendesk_ui_ui_android != null) {
            iResolveColorAttr = buttonsBackgroundColor$zendesk_ui_ui_android.intValue();
        } else {
            Context context = getContext();
            Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
            iResolveColorAttr = ColorExtKt.resolveColorAttr(context, R.attr.unreadMessagesButtonsBackgroundColor);
        }
        imageView.setColorFilter(iResolveColorAttr);
        this.dismissButtonAccessibility.setOnClickListener(new View.OnClickListener() {
            @Override
            public final void onClick(View view) {
                ButtonBannerView.render$lambda$1(this.f$0, view);
            }
        });
        Drawable drawable = ContextCompat.getDrawable(getContext(), R.drawable.zuia_unread_messages_background);
        Intrinsics.checkNotNull(drawable, "null cannot be cast to non-null type android.graphics.drawable.LayerDrawable");
        LayerDrawable layerDrawable = (LayerDrawable) drawable;
        Drawable drawableFindDrawableByLayerId = layerDrawable.findDrawableByLayerId(R.id.zuia_new_messages_second_background);
        Intrinsics.checkNotNull(drawableFindDrawableByLayerId, "null cannot be cast to non-null type android.graphics.drawable.GradientDrawable");
        GradientDrawable gradientDrawable = (GradientDrawable) drawableFindDrawableByLayerId;
        Integer backgroundColor$zendesk_ui_ui_android = this.rendering.getState().getBackgroundColor$zendesk_ui_ui_android();
        if (backgroundColor$zendesk_ui_ui_android != null) {
            iResolveColorAttr2 = backgroundColor$zendesk_ui_ui_android.intValue();
        } else {
            Context context2 = getContext();
            Intrinsics.checkNotNullExpressionValue(context2, "getContext(...)");
            iResolveColorAttr2 = ColorExtKt.resolveColorAttr(context2, R.attr.unreadMessagesBackgroundColor);
        }
        gradientDrawable.setColor(iResolveColorAttr2);
        this.unreadMessagesView.setBackground(layerDrawable);
        TextView textView = this.label;
        Integer textColor$zendesk_ui_ui_android = this.rendering.getState().getTextColor$zendesk_ui_ui_android();
        if (textColor$zendesk_ui_ui_android != null) {
            iResolveColorAttr3 = textColor$zendesk_ui_ui_android.intValue();
        } else {
            Context context3 = getContext();
            Intrinsics.checkNotNullExpressionValue(context3, "getContext(...)");
            iResolveColorAttr3 = ColorExtKt.resolveColorAttr(context3, R.attr.unreadMessagesLabelColor);
        }
        textView.setTextColor(iResolveColorAttr3);
        String text$zendesk_ui_ui_android = this.rendering.getState().getText$zendesk_ui_ui_android();
        if (text$zendesk_ui_ui_android != null && (!StringsKt.isBlank(text$zendesk_ui_ui_android))) {
            this.label.setText(this.rendering.getState().getText$zendesk_ui_ui_android());
        }
        ButtonBannerViewType viewType$zendesk_ui_ui_android = this.rendering.getState().getViewType$zendesk_ui_ui_android();
        if (viewType$zendesk_ui_ui_android != null) {
            int i = WhenMappings.$EnumSwitchMapping$0[viewType$zendesk_ui_ui_android.ordinal()];
            if (i == 1) {
                this.arrowDown.setVisibility(8);
                this.dismissButton.setVisibility(0);
                ImageView imageView2 = this.dismissButton;
                Integer iconColor$zendesk_ui_ui_android = this.rendering.getState().getIconColor$zendesk_ui_ui_android();
                if (iconColor$zendesk_ui_ui_android != null) {
                    iResolveColorAttr4 = iconColor$zendesk_ui_ui_android.intValue();
                } else {
                    Context context4 = getContext();
                    Intrinsics.checkNotNullExpressionValue(context4, "getContext(...)");
                    iResolveColorAttr4 = ColorExtKt.resolveColorAttr(context4, R.attr.unreadMessagesButtonsBackgroundColor);
                }
                imageView2.setColorFilter(iResolveColorAttr4);
                this.dismissButtonAccessibility.setVisibility(0);
                this.dismissButtonAccessibility.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public final void onClick(View view) {
                        ButtonBannerView.render$lambda$5$lambda$2(this.f$0, view);
                    }
                });
            } else if (i == 2) {
                this.arrowDown.setVisibility(0);
                ImageView imageView3 = this.arrowDown;
                Integer iconColor$zendesk_ui_ui_android2 = this.rendering.getState().getIconColor$zendesk_ui_ui_android();
                if (iconColor$zendesk_ui_ui_android2 != null) {
                    iResolveColorAttr5 = iconColor$zendesk_ui_ui_android2.intValue();
                } else {
                    Context context5 = getContext();
                    Intrinsics.checkNotNullExpressionValue(context5, "getContext(...)");
                    iResolveColorAttr5 = ColorExtKt.resolveColorAttr(context5, R.attr.unreadMessagesButtonsBackgroundColor);
                }
                imageView3.setColorFilter(iResolveColorAttr5);
                this.dismissButton.setVisibility(8);
                this.dismissButtonAccessibility.setVisibility(8);
            } else if (i == 3) {
                Drawable drawable2 = ContextCompat.getDrawable(getContext(), R.drawable.zuia_button_banner_background);
                Intrinsics.checkNotNull(drawable2, "null cannot be cast to non-null type android.graphics.drawable.LayerDrawable");
                LayerDrawable layerDrawable2 = (LayerDrawable) drawable2;
                Drawable drawableFindDrawableByLayerId2 = layerDrawable2.findDrawableByLayerId(R.id.zuia_banner_background);
                Intrinsics.checkNotNull(drawableFindDrawableByLayerId2, "null cannot be cast to non-null type android.graphics.drawable.GradientDrawable");
                GradientDrawable gradientDrawable2 = (GradientDrawable) drawableFindDrawableByLayerId2;
                Integer backgroundColor$zendesk_ui_ui_android2 = this.rendering.getState().getBackgroundColor$zendesk_ui_ui_android();
                if (backgroundColor$zendesk_ui_ui_android2 != null) {
                    iResolveColorAttr6 = backgroundColor$zendesk_ui_ui_android2.intValue();
                } else {
                    Context context6 = getContext();
                    Intrinsics.checkNotNullExpressionValue(context6, "getContext(...)");
                    iResolveColorAttr6 = ColorExtKt.resolveColorAttr(context6, R.attr.unreadMessagesBackgroundColor);
                }
                gradientDrawable2.setColor(iResolveColorAttr6);
                this.unreadMessagesView.setBackground(layerDrawable2);
                this.label.getLayoutParams().width = getContext().getResources().getDimensionPixelSize(R.dimen.zuia_postback_error_banner_width);
                this.label.setText(this.rendering.getState().getStyledText$zendesk_ui_ui_android());
                this.arrowDown.setVisibility(8);
                this.dismissButton.setVisibility(0);
                this.dismissButtonAccessibility.setVisibility(0);
                this.dismissButtonAccessibility.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public final void onClick(View view) {
                        ButtonBannerView.render$lambda$5$lambda$3(this.f$0, view);
                    }
                });
                this.dismissButton.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public final void onClick(View view) {
                        ButtonBannerView.render$lambda$5$lambda$4(this.f$0, view);
                    }
                });
                if (this.rendering.getState().getShouldAnimate$zendesk_ui_ui_android()) {
                    announceAccessibility();
                    toastDismissAnimation();
                }
            }
        }
        if (Intrinsics.areEqual(this.rendering.getState().isVisible$zendesk_ui_ui_android(), true)) {
            showUnreadMessagesView();
        } else {
            hideUnreadMessagesView();
        }
    }

    public static final void render$lambda$0(ButtonBannerView buttonBannerView, View view) {
        Intrinsics.checkNotNullParameter(buttonBannerView, "this$0");
        buttonBannerView.rendering.getOnViewClicked$zendesk_ui_ui_android().invoke();
        buttonBannerView.hideUnreadMessagesView();
    }

    public static final void render$lambda$1(ButtonBannerView buttonBannerView, View view) {
        Intrinsics.checkNotNullParameter(buttonBannerView, "this$0");
        buttonBannerView.hideUnreadMessagesView();
    }

    public static final void render$lambda$5$lambda$2(ButtonBannerView buttonBannerView, View view) {
        Intrinsics.checkNotNullParameter(buttonBannerView, "this$0");
        buttonBannerView.rendering.getOnViewDismissed$zendesk_ui_ui_android().invoke();
        buttonBannerView.hideUnreadMessagesView();
    }

    public static final void render$lambda$5$lambda$3(ButtonBannerView buttonBannerView, View view) {
        Intrinsics.checkNotNullParameter(buttonBannerView, "this$0");
        buttonBannerView.rendering.getOnViewDismissed$zendesk_ui_ui_android().invoke();
        buttonBannerView.animatorSet.cancel();
        buttonBannerView.hideUnreadMessagesView();
    }

    public static final void render$lambda$5$lambda$4(ButtonBannerView buttonBannerView, View view) {
        Intrinsics.checkNotNullParameter(buttonBannerView, "this$0");
        buttonBannerView.rendering.getOnViewDismissed$zendesk_ui_ui_android().invoke();
        buttonBannerView.animatorSet.cancel();
        buttonBannerView.hideUnreadMessagesView();
    }

    private final void hideUnreadMessagesView() {
        animate().alpha(0.0f).withEndAction(new Runnable() {
            @Override
            public final void run() {
                ButtonBannerView.hideUnreadMessagesView$lambda$6(this.f$0);
            }
        }).start();
    }

    public static final void hideUnreadMessagesView$lambda$6(ButtonBannerView buttonBannerView) {
        Intrinsics.checkNotNullParameter(buttonBannerView, "this$0");
        buttonBannerView.setVisibility(8);
    }

    private final void showUnreadMessagesView() {
        animate().alpha(1.0f).withStartAction(new Runnable() {
            @Override
            public final void run() {
                ButtonBannerView.showUnreadMessagesView$lambda$7(this.f$0);
            }
        }).start();
    }

    public static final void showUnreadMessagesView$lambda$7(ButtonBannerView buttonBannerView) {
        Intrinsics.checkNotNullParameter(buttonBannerView, "this$0");
        buttonBannerView.setVisibility(0);
    }

    private final void toastDismissAnimation() {
        long integer = getResources().getInteger(R.integer.zuia_button_banner_animation_delay);
        long integer2 = getResources().getInteger(R.integer.zuia_button_banner_animation_duration);
        ObjectAnimator objectAnimatorOfFloat = ObjectAnimator.ofFloat(this, "alpha", 1.0f, 0.0f);
        AnimatorSet animatorSet = new AnimatorSet();
        animatorSet.setStartDelay(integer);
        animatorSet.setDuration(integer2);
        animatorSet.play(objectAnimatorOfFloat);
        animatorSet.addListener(new AnimatorListenerAdapter() {
            @Override
            public void onAnimationEnd(Animator animation) {
                Intrinsics.checkNotNullParameter(animation, "animation");
                this.this$0.rendering.getOnViewDismissed$zendesk_ui_ui_android().invoke();
                this.this$0.setVisibility(8);
            }
        });
        animatorSet.start();
        this.animatorSet = animatorSet;
    }

    private final void announceAccessibility() {
        if (this.rendering.getState().getViewType$zendesk_ui_ui_android() == ButtonBannerViewType.FAILED_BANNER) {
            String string = getContext().getString(R.string.zuia_postback_error_banner_accessibility_label, String.valueOf(this.rendering.getState().getStyledText$zendesk_ui_ui_android()));
            Intrinsics.checkNotNullExpressionValue(string, "getString(...)");
            this.label.announceForAccessibility(string);
        }
    }

    @Metadata(d1 = {"\u0000\u001a\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u0007\n\u0002\b\u0002\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0006X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0007\u001a\u00020\u0006X\u0082T¢\u0006\u0002\n\u0000¨\u0006\b"}, d2 = {"Lzendesk/ui/android/common/buttonbanner/ButtonBannerView$Companion;", "", "()V", "ALPHA_PROPERTY_NAME", "", "ALPHA_TRANSPARENT", "", "ALPHA_VISIBLE", "zendesk.ui_ui-android"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
