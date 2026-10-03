package zendesk.p009ui.android.common.loadmore;

import android.content.Context;
import android.content.res.ColorStateList;
import android.os.Build;
import android.util.AttributeSet;
import android.view.View;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ProgressBar;
import androidx.appcompat.widget.AppCompatImageView;
import androidx.appcompat.widget.AppCompatTextView;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.core.graphics.BlendModeColorFilterCompat;
import androidx.core.graphics.BlendModeCompat;
import kotlin.Metadata;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.core.ui.android.internal.xml.AccessibilityExtKt;
import zendesk.ui.android.R;
import zendesk.ui.android.Renderer;

@Metadata(d1 = {"\u0000N\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0007\u0018\u0000 \u00192\u00020\u00012\b\u0012\u0004\u0012\u00020\u00030\u0002:\u0001\u0019B/\b\u0007\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t\u0012\b\b\u0002\u0010\n\u001a\u00020\t¢\u0006\u0002\u0010\u000bJ\u001c\u0010\u0015\u001a\u00020\u00162\u0012\u0010\u0017\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00030\u0018H\u0016R\u000e\u0010\f\u001a\u00020\rX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000e\u001a\u00020\u000fX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0010\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0011\u001a\u00020\u0012X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0013\u001a\u00020\u0014X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u001a"}, d2 = {"Lzendesk/ui/android/common/loadmore/LoadMoreView;", "Landroid/widget/FrameLayout;", "Lzendesk/ui/android/Renderer;", "Lzendesk/ui/android/common/loadmore/LoadMoreRendering;", "context", "Landroid/content/Context;", "attrs", "Landroid/util/AttributeSet;", "defStyleAttrs", "", "defStyleRes", "(Landroid/content/Context;Landroid/util/AttributeSet;II)V", "failedRetryText", "Landroidx/appcompat/widget/AppCompatTextView;", "progressBar", "Landroid/widget/ProgressBar;", "rendering", "retryButton", "Landroidx/appcompat/widget/AppCompatImageView;", "retryContainerView", "Landroidx/constraintlayout/widget/ConstraintLayout;", "render", "", "renderingUpdate", "Lkotlin/Function1;", "Companion", "zendesk.ui_ui-android"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class LoadMoreView extends FrameLayout implements Renderer<LoadMoreRendering> {
    private static final long ACCESSIBILITY_EVENT_DELAY = 500;
    private final AppCompatTextView failedRetryText;
    private final ProgressBar progressBar;
    private LoadMoreRendering rendering;
    private final AppCompatImageView retryButton;
    private final ConstraintLayout retryContainerView;
    private static final Companion Companion = new Companion(null);
    public static final int $stable = 8;

    @Metadata(k = 3, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[LoadMoreState.LoadMoreStatus.values().length];
            try {
                iArr[LoadMoreState.LoadMoreStatus.LOADING.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[LoadMoreState.LoadMoreStatus.FAILED.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                iArr[LoadMoreState.LoadMoreStatus.NONE.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    public LoadMoreView(Context context) {
        this(context, null, 0, 0, 14, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public LoadMoreView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0, 0, 12, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public LoadMoreView(Context context, AttributeSet attributeSet, int i) {
        this(context, attributeSet, i, 0, 8, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public LoadMoreView(Context context, AttributeSet attributeSet, int i, int i2, int i3, DefaultConstructorMarker defaultConstructorMarker) {
        this(context, (i3 & 2) != 0 ? null : attributeSet, (i3 & 4) != 0 ? 0 : i, (i3 & 8) != 0 ? 0 : i2);
    }

    public LoadMoreView(Context context, AttributeSet attributeSet, int i, int i2) {
        super(context, attributeSet, i, i2);
        Intrinsics.checkNotNullParameter(context, "context");
        this.rendering = new LoadMoreRendering();
        context.getTheme().applyStyle(R.style.ThemeOverlay_ZendeskComponents_MessageLoadMoreStyle, false);
        FrameLayout.inflate(context, R.layout.zuia_view_message_load_more, this);
        View viewFindViewById = findViewById(R.id.zuia_message_load_more_progress_indicator);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById, "findViewById(...)");
        this.progressBar = (ProgressBar) viewFindViewById;
        View viewFindViewById2 = findViewById(R.id.zuia_message_load_retry_container_view);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById2, "findViewById(...)");
        this.retryContainerView = (ConstraintLayout) viewFindViewById2;
        AppCompatTextView appCompatTextViewFindViewById = findViewById(R.id.zuia_message_load_retry_label);
        Intrinsics.checkNotNullExpressionValue(appCompatTextViewFindViewById, "findViewById(...)");
        this.failedRetryText = appCompatTextViewFindViewById;
        View viewFindViewById3 = findViewById(R.id.zuia_message_load_retry_button);
        View view = (AppCompatImageView) viewFindViewById3;
        Intrinsics.checkNotNull(view);
        String name = Button.class.getName();
        Intrinsics.checkNotNullExpressionValue(name, "getName(...)");
        AccessibilityExtKt.overrideAccessibilityNodeClassNameInfo(view, name);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById3, "apply(...)");
        this.retryButton = view;
        render(new Function1<LoadMoreRendering, LoadMoreRendering>() {
            public final LoadMoreRendering invoke(LoadMoreRendering loadMoreRendering) {
                Intrinsics.checkNotNullParameter(loadMoreRendering, "it");
                return loadMoreRendering;
            }
        });
    }

    public void render(Function1<? super LoadMoreRendering, LoadMoreRendering> renderingUpdate) {
        String text;
        Intrinsics.checkNotNullParameter(renderingUpdate, "renderingUpdate");
        LoadMoreRendering loadMoreRendering = (LoadMoreRendering) renderingUpdate.invoke(this.rendering);
        this.rendering = loadMoreRendering;
        int progressBarColor$zendesk_ui_ui_android = loadMoreRendering.getState().getProgressBarColor$zendesk_ui_ui_android();
        int failedRetryTextColor$zendesk_ui_ui_android = this.rendering.getState().getFailedRetryTextColor$zendesk_ui_ui_android();
        String failedRetryText$zendesk_ui_ui_android = this.rendering.getState().getFailedRetryText$zendesk_ui_ui_android();
        if (failedRetryText$zendesk_ui_ui_android == null || failedRetryText$zendesk_ui_ui_android.length() == 0) {
            text = getContext().getText(R.string.zuia_load_more_messages_failed_to_load);
        } else {
            text = this.rendering.getState().getFailedRetryText$zendesk_ui_ui_android();
        }
        int i = WhenMappings.$EnumSwitchMapping$0[this.rendering.getState().getStatus$zendesk_ui_ui_android().ordinal()];
        if (i == 1) {
            ProgressBar progressBar = this.progressBar;
            if (Build.VERSION.SDK_INT >= 29) {
                progressBar.getIndeterminateDrawable().setColorFilter(BlendModeColorFilterCompat.createBlendModeColorFilterCompat(progressBarColor$zendesk_ui_ui_android, BlendModeCompat.SRC_ATOP));
            } else {
                progressBar.setProgressTintList(ColorStateList.valueOf(progressBarColor$zendesk_ui_ui_android));
            }
            progressBar.setVisibility(0);
            this.retryContainerView.setVisibility(8);
            return;
        }
        if (i != 2) {
            return;
        }
        this.failedRetryText.setTextColor(failedRetryTextColor$zendesk_ui_ui_android);
        this.failedRetryText.setText(text);
        this.retryButton.getDrawable().setTint(failedRetryTextColor$zendesk_ui_ui_android);
        this.retryContainerView.setOnClickListener(new View.OnClickListener() {
            @Override
            public final void onClick(View view) {
                LoadMoreView.render$lambda$2(this.f$0, view);
            }
        });
        this.progressBar.setVisibility(8);
        this.retryContainerView.setVisibility(0);
        ConstraintLayout constraintLayout = this.retryContainerView;
        Context context = getContext();
        Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
        AccessibilityExtKt.postDelayRequestFocusByAccessibilityEventWhenAccessibilityRunning(constraintLayout, context, ACCESSIBILITY_EVENT_DELAY);
    }

    public static final void render$lambda$2(LoadMoreView loadMoreView, View view) {
        Intrinsics.checkNotNullParameter(loadMoreView, "this$0");
        loadMoreView.rendering.getOnRetryClicked$zendesk_ui_ui_android().invoke();
    }

    @Metadata(d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\t\n\u0000\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000¨\u0006\u0005"}, d2 = {"Lzendesk/ui/android/common/loadmore/LoadMoreView$Companion;", "", "()V", "ACCESSIBILITY_EVENT_DELAY", "", "zendesk.ui_ui-android"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
