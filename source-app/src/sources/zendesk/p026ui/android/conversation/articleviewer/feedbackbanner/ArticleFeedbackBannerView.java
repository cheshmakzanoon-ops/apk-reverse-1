package zendesk.p026ui.android.conversation.articleviewer.feedbackbanner;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.constraintlayout.widget.ConstraintLayout;
import java.util.List;
import kotlin.Metadata;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.p026ui.android.conversation.quickreply.QuickReplyOption;
import zendesk.p026ui.android.conversation.quickreply.QuickReplyRendering;
import zendesk.p026ui.android.conversation.quickreply.QuickReplyState;
import zendesk.p026ui.android.conversation.quickreply.QuickReplyView;
import zendesk.ui.android.R;
import zendesk.ui.android.Renderer;

@Metadata(m17d1 = {"\u0000@\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\b\u0007\u0018\u00002\u00020\u00012\b\u0012\u0004\u0012\u00020\u00030\u0002B/\b\u0007\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t\u0012\b\b\u0002\u0010\n\u001a\u00020\t¢\u0006\u0002\u0010\u000bJ\u001c\u0010\u0012\u001a\u00020\u00132\u0012\u0010\u0014\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00030\u0015H\u0016R\u000e\u0010\f\u001a\u00020\rX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000e\u001a\u00020\u000fX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0010\u001a\u00020\u0001X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0011\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0016"}, m18d2 = {"Lzendesk/ui/android/conversation/articleviewer/feedbackbanner/ArticleFeedbackBannerView;", "Landroid/widget/LinearLayout;", "Lzendesk/ui/android/Renderer;", "Lzendesk/ui/android/conversation/articleviewer/feedbackbanner/ArticleFeedbackBannerRendering;", "context", "Landroid/content/Context;", "attrs", "Landroid/util/AttributeSet;", "defStyleAttrs", "", "defStyleRes", "(Landroid/content/Context;Landroid/util/AttributeSet;II)V", "feedbackBannerContainer", "Landroidx/constraintlayout/widget/ConstraintLayout;", "feedbackBannerText", "Landroid/widget/TextView;", "optionContainer", "rendering", "render", "", "renderingUpdate", "Lkotlin/Function1;", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ArticleFeedbackBannerView extends LinearLayout implements Renderer<ArticleFeedbackBannerRendering> {
    public static final int $stable = 8;
    private final ConstraintLayout feedbackBannerContainer;
    private final TextView feedbackBannerText;
    private final LinearLayout optionContainer;
    private ArticleFeedbackBannerRendering rendering;

    public ArticleFeedbackBannerView(Context context) {
        this(context, null, 0, 0, 14, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ArticleFeedbackBannerView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0, 0, 12, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ArticleFeedbackBannerView(Context context, AttributeSet attributeSet, int i) {
        this(context, attributeSet, i, 0, 8, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ArticleFeedbackBannerView(Context context, AttributeSet attributeSet, int i, int i2, int i3, DefaultConstructorMarker defaultConstructorMarker) {
        this(context, (i3 & 2) != 0 ? null : attributeSet, (i3 & 4) != 0 ? 0 : i, (i3 & 8) != 0 ? 0 : i2);
    }

    public ArticleFeedbackBannerView(Context context, AttributeSet attributeSet, int i, int i2) {
        super(context, attributeSet, i, i2);
        Intrinsics.checkNotNullParameter(context, "context");
        this.rendering = new ArticleFeedbackBannerRendering();
        LinearLayout.inflate(context, R.layout.zuia_view_article_feedback_banner, this);
        ConstraintLayout constraintLayoutFindViewById = findViewById(R.id.zuia_feedback_banner_container);
        Intrinsics.checkNotNullExpressionValue(constraintLayoutFindViewById, "findViewById(...)");
        this.feedbackBannerContainer = constraintLayoutFindViewById;
        View viewFindViewById = findViewById(R.id.zuia_feedback_banner_options);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById, "findViewById(...)");
        this.optionContainer = (LinearLayout) viewFindViewById;
        View viewFindViewById2 = findViewById(R.id.zuia_feedback_banner_label);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById2, "findViewById(...)");
        this.feedbackBannerText = (TextView) viewFindViewById2;
    }

    public void render(Function1<? super ArticleFeedbackBannerRendering, ArticleFeedbackBannerRendering> renderingUpdate) {
        Intrinsics.checkNotNullParameter(renderingUpdate, "renderingUpdate");
        ArticleFeedbackBannerRendering articleFeedbackBannerRenderingInvoke = renderingUpdate.invoke(this.rendering);
        this.rendering = articleFeedbackBannerRenderingInvoke;
        this.feedbackBannerContainer.setBackgroundColor(articleFeedbackBannerRenderingInvoke.getState().getBackgroundColor$zendesk_ui_ui_android());
        this.feedbackBannerText.setTextColor(this.rendering.getState().getTextColor$zendesk_ui_ui_android());
        final List<QuickReplyOption> options$zendesk_ui_ui_android = this.rendering.getState().getOptions$zendesk_ui_ui_android();
        if (options$zendesk_ui_ui_android != null) {
            this.optionContainer.removeAllViews();
            LinearLayout linearLayout = this.optionContainer;
            Context context = getContext();
            Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
            QuickReplyView quickReplyView = new QuickReplyView(context, null, 0, 0, 14, null);
            quickReplyView.render(new Function1<QuickReplyRendering, QuickReplyRendering>() {
                {
                    super(1);
                }

                @Override
                public final QuickReplyRendering invoke(QuickReplyRendering it) {
                    Intrinsics.checkNotNullParameter(it, "it");
                    QuickReplyRendering.Builder builder = it.toBuilder();
                    final List<QuickReplyOption> list = options$zendesk_ui_ui_android;
                    final ArticleFeedbackBannerView articleFeedbackBannerView = this.this$0;
                    return builder.state(new Function1<QuickReplyState, QuickReplyState>() {
                        {
                            super(1);
                        }

                        @Override
                        public final QuickReplyState invoke(QuickReplyState state) {
                            Intrinsics.checkNotNullParameter(state, "state");
                            return QuickReplyState.copy$default(state, list, articleFeedbackBannerView.rendering.getState().getButtonColor$zendesk_ui_ui_android(), 0, 4, null);
                        }
                    }).onOptionClicked(this.this$0.rendering.getOnFeedbackBannerOptionClicked$zendesk_ui_ui_android()).build();
                }
            });
            linearLayout.addView(quickReplyView, new LinearLayout.LayoutParams(-1, -2));
        }
    }
}
