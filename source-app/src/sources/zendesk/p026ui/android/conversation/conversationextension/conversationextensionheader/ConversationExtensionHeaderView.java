package zendesk.p026ui.android.conversation.conversationextension.conversationextensionheader;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewGroup;
import android.view.accessibility.AccessibilityNodeInfo;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.TextView;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.core.content.ContextCompat;
import kotlin.Lazy;
import kotlin.Metadata;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.p026ui.android.internal.ViewKt;
import zendesk.ui.android.R;
import zendesk.ui.android.Renderer;

@Metadata(m17d1 = {"\u0000Z\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u000b\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\b\u0007\u0018\u00002\u00020\u00012\b\u0012\u0004\u0012\u00020\u00030\u0002B/\b\u0007\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t\u0012\b\b\u0002\u0010\n\u001a\u00020\t¢\u0006\u0002\u0010\u000bJ\u001c\u0010#\u001a\u00020$2\u0012\u0010%\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00030&H\u0016J\u0010\u0010'\u001a\u00020$2\u0006\u0010(\u001a\u00020)H\u0002J\u0010\u0010*\u001a\u00020$2\u0006\u0010+\u001a\u00020,H\u0002R\u001b\u0010\f\u001a\u00020\r8BX\u0082\u0084\u0002¢\u0006\f\n\u0004\b\u0010\u0010\u0011\u001a\u0004\b\u000e\u0010\u000fR\u001b\u0010\u0012\u001a\u00020\u00138BX\u0082\u0084\u0002¢\u0006\f\n\u0004\b\u0016\u0010\u0011\u001a\u0004\b\u0014\u0010\u0015R\u001b\u0010\u0017\u001a\u00020\r8BX\u0082\u0084\u0002¢\u0006\f\n\u0004\b\u0019\u0010\u0011\u001a\u0004\b\u0018\u0010\u000fR\u001b\u0010\u001a\u001a\u00020\u00138BX\u0082\u0084\u0002¢\u0006\f\n\u0004\b\u001c\u0010\u0011\u001a\u0004\b\u001b\u0010\u0015R\u000e\u0010\u001d\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000R\u001b\u0010\u001e\u001a\u00020\u001f8BX\u0082\u0084\u0002¢\u0006\f\n\u0004\b\"\u0010\u0011\u001a\u0004\b \u0010!¨\u0006-"}, m18d2 = {"Lzendesk/ui/android/conversation/conversationextension/conversationextensionheader/ConversationExtensionHeaderView;", "Landroidx/constraintlayout/widget/ConstraintLayout;", "Lzendesk/ui/android/Renderer;", "Lzendesk/ui/android/conversation/conversationextension/conversationextensionheader/ConversationExtensionHeaderRendering;", "context", "Landroid/content/Context;", "attrs", "Landroid/util/AttributeSet;", "defStyleAttrs", "", "defStyleRes", "(Landroid/content/Context;Landroid/util/AttributeSet;II)V", "backButton", "Landroid/widget/FrameLayout;", "getBackButton", "()Landroid/widget/FrameLayout;", "backButton$delegate", "Lkotlin/Lazy;", "backButtonIconView", "Landroid/widget/ImageView;", "getBackButtonIconView", "()Landroid/widget/ImageView;", "backButtonIconView$delegate", "closeButton", "getCloseButton", "closeButton$delegate", "closeButtonIconView", "getCloseButtonIconView", "closeButtonIconView$delegate", "rendering", "title", "Landroid/widget/TextView;", "getTitle", "()Landroid/widget/TextView;", "title$delegate", "render", "", "renderingUpdate", "Lkotlin/Function1;", "setupButtonFocusStates", "state", "Lzendesk/ui/android/conversation/conversationextension/conversationextensionheader/ConversationExtensionHeaderState;", "updateAccessibilityNodeInfo", "view", "Landroid/view/View;", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationExtensionHeaderView extends ConstraintLayout implements Renderer<ConversationExtensionHeaderRendering> {
    public static final int $stable = 8;

    private final Lazy backButton;

    private final Lazy backButtonIconView;

    private final Lazy closeButton;

    private final Lazy closeButtonIconView;
    private ConversationExtensionHeaderRendering rendering;

    private final Lazy title;

    public ConversationExtensionHeaderView(Context context) {
        this(context, null, 0, 0, 14, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ConversationExtensionHeaderView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0, 0, 12, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ConversationExtensionHeaderView(Context context, AttributeSet attributeSet, int i) {
        this(context, attributeSet, i, 0, 8, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ConversationExtensionHeaderView(Context context, AttributeSet attributeSet, int i, int i2, int i3, DefaultConstructorMarker defaultConstructorMarker) {
        this(context, (i3 & 2) != 0 ? null : attributeSet, (i3 & 4) != 0 ? 0 : i, (i3 & 8) != 0 ? 0 : i2);
    }

    public ConversationExtensionHeaderView(Context context, AttributeSet attributeSet, int i, int i2) {
        super(context, attributeSet, i, i2);
        Intrinsics.checkNotNullParameter(context, "context");
        View view = (View) this;
        this.backButton = ViewKt.lazyViewById(view, R.id.zuia_conversation_extension_back_button);
        this.closeButton = ViewKt.lazyViewById(view, R.id.zuia_conversation_extension_close_button);
        this.backButtonIconView = ViewKt.lazyViewById(view, R.id.zuia_back_button_icon_view);
        this.closeButtonIconView = ViewKt.lazyViewById(view, R.id.zuia_close_button_icon_view);
        this.title = ViewKt.lazyViewById(view, R.id.zuia_conversation_extension_title);
        this.rendering = new ConversationExtensionHeaderRendering();
        ConstraintLayout.inflate(context, R.layout.zuia_view_conversation_extension_header, (ViewGroup) this);
    }

    private final FrameLayout getBackButton() {
        return (FrameLayout) this.backButton.getValue();
    }

    private final FrameLayout getCloseButton() {
        return (FrameLayout) this.closeButton.getValue();
    }

    private final ImageView getBackButtonIconView() {
        return (ImageView) this.backButtonIconView.getValue();
    }

    private final ImageView getCloseButtonIconView() {
        return (ImageView) this.closeButtonIconView.getValue();
    }

    private final TextView getTitle() {
        return (TextView) this.title.getValue();
    }

    public void render(Function1<? super ConversationExtensionHeaderRendering, ConversationExtensionHeaderRendering> renderingUpdate) {
        Intrinsics.checkNotNullParameter(renderingUpdate, "renderingUpdate");
        ConversationExtensionHeaderState state = this.rendering.getState();
        ConversationExtensionHeaderRendering conversationExtensionHeaderRenderingInvoke = renderingUpdate.invoke(this.rendering);
        this.rendering = conversationExtensionHeaderRenderingInvoke;
        if (!Intrinsics.areEqual(state, conversationExtensionHeaderRenderingInvoke.getState())) {
            setupButtonFocusStates(this.rendering.getState());
            setBackgroundColor(this.rendering.getState().getBackgroundColor$zendesk_ui_ui_android());
            getBackButtonIconView().setColorFilter(this.rendering.getState().getIconColor$zendesk_ui_ui_android());
            getCloseButtonIconView().setColorFilter(this.rendering.getState().getIconColor$zendesk_ui_ui_android());
            getBackButton().getBackground().mutate().setTint(this.rendering.getState().getButtonBackgroundColor$zendesk_ui_ui_android());
            getCloseButton().getBackground().mutate().setTint(this.rendering.getState().getButtonBackgroundColor$zendesk_ui_ui_android());
            updateAccessibilityNodeInfo(getBackButton());
            updateAccessibilityNodeInfo(getCloseButton());
            View view = (View) this;
            ViewKt.expandTouchArea$default(getBackButton(), view, 0, 0, 0, 0, 30, null);
            ViewKt.expandTouchArea$default(getCloseButton(), view, 0, 0, 0, 0, 30, null);
            if (!this.rendering.getState().getShowBackButton$zendesk_ui_ui_android()) {
                getBackButton().setVisibility(4);
            } else {
                getBackButton().setVisibility(0);
            }
            TextView title = getTitle();
            title.setText(this.rendering.getState().getTitle$zendesk_ui_ui_android());
            title.setTextColor(this.rendering.getState().getTitleColor$zendesk_ui_ui_android());
        }
        getBackButton().setOnClickListener(new View.OnClickListener() {
            @Override
            public final void onClick(View view2) {
                ConversationExtensionHeaderView.render$lambda$1(this.f$0, view2);
            }
        });
        getCloseButton().setOnClickListener(new View.OnClickListener() {
            @Override
            public final void onClick(View view2) {
                ConversationExtensionHeaderView.render$lambda$2(this.f$0, view2);
            }
        });
    }

    public static final void render$lambda$1(ConversationExtensionHeaderView this$0, View view) {
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        this$0.rendering.getOnMenuItemClicked$zendesk_ui_ui_android().invoke(ConversationExtensionHeaderState.ButtonName.BACK);
    }

    public static final void render$lambda$2(ConversationExtensionHeaderView this$0, View view) {
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        this$0.rendering.getOnMenuItemClicked$zendesk_ui_ui_android().invoke(ConversationExtensionHeaderState.ButtonName.CLOSE);
    }

    private final void updateAccessibilityNodeInfo(View view) {
        view.setAccessibilityDelegate(new View.AccessibilityDelegate() {
            @Override
            public void onInitializeAccessibilityNodeInfo(View host, AccessibilityNodeInfo info) {
                Intrinsics.checkNotNullParameter(host, "host");
                Intrinsics.checkNotNullParameter(info, "info");
                super.onInitializeAccessibilityNodeInfo(host, info);
                info.setClassName("android.widget.Button");
            }
        });
    }

    private final void setupButtonFocusStates(ConversationExtensionHeaderState state) {
        FrameLayout backButton = getBackButton();
        int i = R.drawable.zuia_ic_carousel_next_button_circle;
        int i2 = R.dimen.zuia_carousel_next_prev_stroke_width;
        int focusedBorderColor$zendesk_ui_ui_android = state.getFocusedBorderColor$zendesk_ui_ui_android();
        Drawable drawable = ContextCompat.getDrawable(getContext(), R.drawable.zuia_ic_carousel_next_button_circle);
        Intrinsics.checkNotNull(drawable, "null cannot be cast to non-null type android.graphics.drawable.GradientDrawable");
        ViewKt.addAccessibilityFocusedState(backButton, i, i2, focusedBorderColor$zendesk_ui_ui_android, (GradientDrawable) drawable);
        FrameLayout closeButton = getCloseButton();
        int i3 = R.drawable.zuia_ic_carousel_prev_button_circle;
        int i4 = R.dimen.zuia_carousel_next_prev_stroke_width;
        int focusedBorderColor$zendesk_ui_ui_android2 = state.getFocusedBorderColor$zendesk_ui_ui_android();
        Drawable drawable2 = ContextCompat.getDrawable(getContext(), R.drawable.zuia_ic_carousel_prev_button_circle);
        Intrinsics.checkNotNull(drawable2, "null cannot be cast to non-null type android.graphics.drawable.GradientDrawable");
        ViewKt.addAccessibilityFocusedState(closeButton, i3, i4, focusedBorderColor$zendesk_ui_ui_android2, (GradientDrawable) drawable2);
    }
}
