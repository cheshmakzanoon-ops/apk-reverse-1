package zendesk.p009ui.android.common.retryerror;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;
import android.view.View;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.core.content.ContextCompat;
import androidx.core.graphics.drawable.DrawableCompat;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.core.ui.android.internal.xml.AccessibilityExtKt;
import zendesk.ui.android.R;
import zendesk.ui.android.Renderer;
import zendesk.ui.android.internal.ThrottledOnClickListenerKt;

@Metadata(d1 = {"\u0000B\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0007\u0018\u0000 \u00152\u00020\u00012\b\u0012\u0004\u0012\u00020\u00030\u0002:\u0001\u0015B%\b\u0007\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t¢\u0006\u0002\u0010\nJ\u001c\u0010\u0011\u001a\u00020\u00122\u0012\u0010\u0013\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00030\u0014H\u0016R\u000e\u0010\u000b\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\f\u001a\u00020\rX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000e\u001a\u00020\u000fX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0010\u001a\u00020\rX\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0016"}, d2 = {"Lzendesk/ui/android/common/retryerror/RetryErrorView;", "Landroid/widget/FrameLayout;", "Lzendesk/ui/android/Renderer;", "Lzendesk/ui/android/common/retryerror/RetryErrorRendering;", "context", "Landroid/content/Context;", "attrs", "Landroid/util/AttributeSet;", "defStyleAttrs", "", "(Landroid/content/Context;Landroid/util/AttributeSet;I)V", "rendering", "retryButton", "Landroid/widget/TextView;", "retryContainer", "Landroid/widget/LinearLayout;", "retryText", "render", "", "renderingUpdate", "Lkotlin/Function1;", "Companion", "zendesk.ui_ui-android"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class RetryErrorView extends FrameLayout implements Renderer<RetryErrorRendering> {
    private static final long ACCESSIBILITY_EVENT_DELAY = 500;
    private RetryErrorRendering rendering;
    private final TextView retryButton;
    private final LinearLayout retryContainer;
    private final TextView retryText;
    private static final Companion Companion = new Companion(null);
    public static final int $stable = 8;

    public RetryErrorView(Context context) {
        this(context, null, 0, 6, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public RetryErrorView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0, 4, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public RetryErrorView(Context context, AttributeSet attributeSet, int i, int i2, DefaultConstructorMarker defaultConstructorMarker) {
        this(context, (i2 & 2) != 0 ? null : attributeSet, (i2 & 4) != 0 ? 0 : i);
    }

    public RetryErrorView(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        Intrinsics.checkNotNullParameter(context, "context");
        this.rendering = new RetryErrorRendering();
        context.getTheme().applyStyle(R.style.ThemeOverlay_ZendeskComponents_ConversationsListRetryErrorStyle, false);
        FrameLayout.inflate(context, R.layout.zuia_view_retry_error_view, this);
        View viewFindViewById = findViewById(R.id.zuia_error_view);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById, "findViewById(...)");
        this.retryContainer = (LinearLayout) viewFindViewById;
        View viewFindViewById2 = findViewById(R.id.zuia_error_retry_message_text);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById2, "findViewById(...)");
        this.retryText = (TextView) viewFindViewById2;
        View viewFindViewById3 = findViewById(R.id.zuia_error_retry_button);
        TextView textView = (TextView) viewFindViewById3;
        Intrinsics.checkNotNull(textView);
        String name = Button.class.getName();
        Intrinsics.checkNotNullExpressionValue(name, "getName(...)");
        AccessibilityExtKt.overrideAccessibilityNodeClassNameInfo(textView, name);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById3, "apply(...)");
        this.retryButton = textView;
    }

    public void render(Function1<? super RetryErrorRendering, RetryErrorRendering> renderingUpdate) {
        Intrinsics.checkNotNullParameter(renderingUpdate, "renderingUpdate");
        this.rendering = (RetryErrorRendering) renderingUpdate.invoke(this.rendering);
        this.retryContainer.setOnClickListener((View.OnClickListener) ThrottledOnClickListenerKt.throttledOnClickListener$default(0L, new Function0<Unit>() {
            {
                super(0);
            }

            public Object invoke() {
                m2641invoke();
                return Unit.INSTANCE;
            }

            public final void m2641invoke() {
                RetryErrorView.this.rendering.getOnButtonClicked$zendesk_ui_ui_android().invoke();
            }
        }, 1, (Object) null));
        this.retryButton.setTextColor(this.rendering.getState().getRetryButtonTextColor$zendesk_ui_ui_android());
        this.retryButton.setText(this.rendering.getState().getRetryButtonText$zendesk_ui_ui_android());
        Drawable drawable = ContextCompat.getDrawable(getContext(), R.drawable.zuia_reload_icon);
        int retryButtonTextColor$zendesk_ui_ui_android = this.rendering.getState().getRetryButtonTextColor$zendesk_ui_ui_android();
        if (drawable != null) {
            Drawable drawableWrap = DrawableCompat.wrap(drawable);
            Intrinsics.checkNotNullExpressionValue(drawableWrap, "wrap(...)");
            DrawableCompat.setTint(drawableWrap, retryButtonTextColor$zendesk_ui_ui_android);
            this.retryButton.setCompoundDrawablesRelativeWithIntrinsicBounds((Drawable) null, (Drawable) null, drawableWrap, (Drawable) null);
        }
        this.retryText.setTextColor(this.rendering.getState().getRetryMessageTextColor$zendesk_ui_ui_android());
        this.retryText.setText(this.rendering.getState().getRetryMessageText$zendesk_ui_ui_android());
        LinearLayout linearLayout = this.retryContainer;
        Context context = getContext();
        Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
        AccessibilityExtKt.postDelayRequestFocusByAccessibilityEventWhenAccessibilityRunning(linearLayout, context, ACCESSIBILITY_EVENT_DELAY);
    }

    @Metadata(d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\t\n\u0000\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000¨\u0006\u0005"}, d2 = {"Lzendesk/ui/android/common/retryerror/RetryErrorView$Companion;", "", "()V", "ACCESSIBILITY_EVENT_DELAY", "", "zendesk.ui_ui-android"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
