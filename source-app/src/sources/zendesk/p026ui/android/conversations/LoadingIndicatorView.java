package zendesk.p026ui.android.conversations;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.FrameLayout;
import com.google.android.material.progressindicator.CircularProgressIndicator;
import kotlin.Metadata;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.ui.android.R;
import zendesk.ui.android.Renderer;

@Metadata(m17d1 = {"\u0000:\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\b\u0007\u0018\u00002\u00020\u00012\b\u0012\u0004\u0012\u00020\u00030\u0002B/\b\u0007\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t\u0012\b\b\u0002\u0010\n\u001a\u00020\t¢\u0006\u0002\u0010\u000bJ\u001c\u0010\u000f\u001a\u00020\u00102\u0012\u0010\u0011\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00030\u0012H\u0016R\u000e\u0010\f\u001a\u00020\rX\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u000e\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0013"}, m18d2 = {"Lzendesk/ui/android/conversations/LoadingIndicatorView;", "Landroid/widget/FrameLayout;", "Lzendesk/ui/android/Renderer;", "Lzendesk/ui/android/conversations/LoadingIndicatorRendering;", "context", "Landroid/content/Context;", "attrs", "Landroid/util/AttributeSet;", "defStyleAttrs", "", "defStyleRes", "(Landroid/content/Context;Landroid/util/AttributeSet;II)V", "loadingIndicator", "Lcom/google/android/material/progressindicator/CircularProgressIndicator;", "rendering", "render", "", "renderingUpdate", "Lkotlin/Function1;", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class LoadingIndicatorView extends FrameLayout implements Renderer<LoadingIndicatorRendering> {
    public static final int $stable = 8;
    private CircularProgressIndicator loadingIndicator;
    private LoadingIndicatorRendering rendering;

    public LoadingIndicatorView(Context context) {
        this(context, null, 0, 0, 14, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public LoadingIndicatorView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0, 0, 12, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public LoadingIndicatorView(Context context, AttributeSet attributeSet, int i) {
        this(context, attributeSet, i, 0, 8, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public LoadingIndicatorView(Context context, AttributeSet attributeSet, int i, int i2, int i3, DefaultConstructorMarker defaultConstructorMarker) {
        this(context, (i3 & 2) != 0 ? null : attributeSet, (i3 & 4) != 0 ? 0 : i, (i3 & 8) != 0 ? 0 : i2);
    }

    public LoadingIndicatorView(Context context, AttributeSet attributeSet, int i, int i2) {
        super(context, attributeSet, i, i2);
        Intrinsics.checkNotNullParameter(context, "context");
        this.rendering = new LoadingIndicatorRendering();
        context.getTheme().applyStyle(R.style.ThemeOverlay_ZendeskComponents_LoadingIndicatorStyle, false);
        FrameLayout.inflate(context, R.layout.zuia_view_loading_indicator, this);
        CircularProgressIndicator circularProgressIndicatorFindViewById = findViewById(R.id.zuia_progress_indicator);
        Intrinsics.checkNotNullExpressionValue(circularProgressIndicatorFindViewById, "findViewById(...)");
        this.loadingIndicator = circularProgressIndicatorFindViewById;
    }

    public void render(Function1<? super LoadingIndicatorRendering, LoadingIndicatorRendering> renderingUpdate) {
        Intrinsics.checkNotNullParameter(renderingUpdate, "renderingUpdate");
        LoadingIndicatorRendering loadingIndicatorRenderingInvoke = renderingUpdate.invoke(this.rendering);
        this.rendering = loadingIndicatorRenderingInvoke;
        int indicatorColor = loadingIndicatorRenderingInvoke.getState().getIndicatorColor();
        this.loadingIndicator.setVisibility(this.rendering.getState().getShowLoadingIndicator() ? 0 : 8);
        this.loadingIndicator.setIndicatorColor(new int[]{indicatorColor});
    }
}
