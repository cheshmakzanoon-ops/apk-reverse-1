package zendesk.p026ui.android.conversation.articleviewer.articleattachmentcarousel;

import android.content.Context;
import android.content.res.Configuration;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.util.AttributeSet;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.ImageView;
import androidx.core.content.ContextCompat;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import kotlin.Lazy;
import kotlin.Metadata;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.p026ui.android.conversation.carousel.CarouselSnapHelper;
import zendesk.p026ui.android.conversation.carousel.CenterSmoothScroller;
import zendesk.p026ui.android.internal.ViewKt;
import zendesk.ui.android.R;
import zendesk.ui.android.Renderer;

@Metadata(m17d1 = {"\u0000|\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0007\u0018\u00002\u00020\u00012\b\u0012\u0004\u0012\u00020\u00030\u0002B%\b\u0007\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t¢\u0006\u0002\u0010\nJ\b\u0010/\u001a\u000200H\u0002J\b\u00101\u001a\u000200H\u0002J\u001c\u00102\u001a\u0002002\u0012\u00103\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u000304H\u0016J\u0010\u00105\u001a\u0002002\u0006\u00106\u001a\u000207H\u0002J\u0010\u00108\u001a\u0002002\u0006\u00106\u001a\u000207H\u0002R\u000e\u0010\u000b\u001a\u00020\fX\u0082\u0004¢\u0006\u0002\n\u0000R\u0016\u0010\r\u001a\n \u000f*\u0004\u0018\u00010\u000e0\u000eX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0010\u001a\u00020\u0011X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u0012\u001a\b\u0012\u0004\u0012\u00020\f0\u0013X\u0082\u0004¢\u0006\u0002\n\u0000R\u001b\u0010\u0014\u001a\u00020\u00158BX\u0082\u0084\u0002¢\u0006\f\n\u0004\b\u0018\u0010\u0019\u001a\u0004\b\u0016\u0010\u0017R\u001b\u0010\u001a\u001a\u00020\u001b8BX\u0082\u0084\u0002¢\u0006\f\n\u0004\b\u001e\u0010\u0019\u001a\u0004\b\u001c\u0010\u001dR\u001b\u0010\u001f\u001a\u00020\u00158BX\u0082\u0084\u0002¢\u0006\f\n\u0004\b!\u0010\u0019\u001a\u0004\b \u0010\u0017R\u001b\u0010\"\u001a\u00020\u001b8BX\u0082\u0084\u0002¢\u0006\f\n\u0004\b$\u0010\u0019\u001a\u0004\b#\u0010\u001dR\u001b\u0010%\u001a\u00020&8BX\u0082\u0084\u0002¢\u0006\f\n\u0004\b)\u0010\u0019\u001a\u0004\b'\u0010(R\u000e\u0010*\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010+\u001a\u00020,X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010-\u001a\u00020.X\u0082\u0004¢\u0006\u0002\n\u0000¨\u00069"}, m18d2 = {"Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentCarouselCellView;", "Landroid/widget/FrameLayout;", "Lzendesk/ui/android/Renderer;", "Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentCarouselRendering;", "context", "Landroid/content/Context;", "attrs", "Landroid/util/AttributeSet;", "defStyleAttrs", "", "(Landroid/content/Context;Landroid/util/AttributeSet;I)V", "adapter", "Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentCarouselRecyclerViewAdapter;", "configuration", "Landroid/content/res/Configuration;", "kotlin.jvm.PlatformType", "itemDecoration", "Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentCarouselItemDecoration;", "layoutManager", "Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentCarouselLayoutManager;", "nextButton", "Landroid/view/View;", "getNextButton", "()Landroid/view/View;", "nextButton$delegate", "Lkotlin/Lazy;", "nextButtonIconView", "Landroid/widget/ImageView;", "getNextButtonIconView", "()Landroid/widget/ImageView;", "nextButtonIconView$delegate", "prevButton", "getPrevButton", "prevButton$delegate", "prevButtonIconView", "getPrevButtonIconView", "prevButtonIconView$delegate", "recyclerView", "Landroidx/recyclerview/widget/RecyclerView;", "getRecyclerView", "()Landroidx/recyclerview/widget/RecyclerView;", "recyclerView$delegate", "rendering", "smoothScroller", "Lzendesk/ui/android/conversation/carousel/CenterSmoothScroller;", "snapHelper", "Lzendesk/ui/android/conversation/carousel/CarouselSnapHelper;", "checkCarouselsScrollingAndButtonVisibility", "", "checkTheCarouselLayoutDirection", "render", "renderingUpdate", "Lkotlin/Function1;", "setUpNextAndPreviousButton", "state", "Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentCarouselCellState;", "setupButtonFocusStates", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ArticleAttachmentCarouselCellView extends FrameLayout implements Renderer<ArticleAttachmentCarouselRendering> {
    public static final int $stable = 8;
    private final ArticleAttachmentCarouselRecyclerViewAdapter adapter;
    private final Configuration configuration;
    private final ArticleAttachmentCarouselItemDecoration itemDecoration;
    private final ArticleAttachmentCarouselLayoutManager<ArticleAttachmentCarouselRecyclerViewAdapter> layoutManager;

    private final Lazy nextButton;

    private final Lazy nextButtonIconView;

    private final Lazy prevButton;

    private final Lazy prevButtonIconView;

    private final Lazy recyclerView;
    private ArticleAttachmentCarouselRendering rendering;
    private final CenterSmoothScroller smoothScroller;
    private final CarouselSnapHelper snapHelper;

    public ArticleAttachmentCarouselCellView(Context context) {
        this(context, null, 0, 6, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ArticleAttachmentCarouselCellView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0, 4, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ArticleAttachmentCarouselCellView(Context context, AttributeSet attributeSet, int i, int i2, DefaultConstructorMarker defaultConstructorMarker) {
        this(context, (i2 & 2) != 0 ? null : attributeSet, (i2 & 4) != 0 ? 0 : i);
    }

    public ArticleAttachmentCarouselCellView(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        Intrinsics.checkNotNullParameter(context, "context");
        this.rendering = new ArticleAttachmentCarouselRendering();
        ArticleAttachmentCarouselCellView articleAttachmentCarouselCellView = this;
        this.recyclerView = ViewKt.lazyViewById(articleAttachmentCarouselCellView, R.id.zuia_attachment_carousel_list);
        this.nextButton = ViewKt.lazyViewById(articleAttachmentCarouselCellView, R.id.zuia_attachment_carousel_next_button);
        this.prevButton = ViewKt.lazyViewById(articleAttachmentCarouselCellView, R.id.zuia_attachment_carousel_prev_button);
        this.nextButtonIconView = ViewKt.lazyViewById(articleAttachmentCarouselCellView, R.id.zuia_attachment_carousel_next_button_icon_view);
        this.prevButtonIconView = ViewKt.lazyViewById(articleAttachmentCarouselCellView, R.id.zuia_attachment_carousel_prev_button_icon_view);
        ArticleAttachmentCarouselRecyclerViewAdapter articleAttachmentCarouselRecyclerViewAdapter = new ArticleAttachmentCarouselRecyclerViewAdapter();
        this.adapter = articleAttachmentCarouselRecyclerViewAdapter;
        RecyclerView.LayoutManager articleAttachmentCarouselLayoutManager = new ArticleAttachmentCarouselLayoutManager(context, articleAttachmentCarouselRecyclerViewAdapter);
        this.layoutManager = articleAttachmentCarouselLayoutManager;
        ArticleAttachmentCarouselItemDecoration articleAttachmentCarouselItemDecoration = new ArticleAttachmentCarouselItemDecoration(context);
        this.itemDecoration = articleAttachmentCarouselItemDecoration;
        CarouselSnapHelper carouselSnapHelper = new CarouselSnapHelper((LinearLayoutManager) articleAttachmentCarouselLayoutManager);
        this.snapHelper = carouselSnapHelper;
        this.smoothScroller = new CenterSmoothScroller(context);
        this.configuration = getResources().getConfiguration();
        FrameLayout.inflate(context, R.layout.zuia_view_attachment_carousel_article, this);
        getRecyclerView().setAdapter(articleAttachmentCarouselRecyclerViewAdapter);
        getRecyclerView().setLayoutManager(articleAttachmentCarouselLayoutManager);
        getRecyclerView().addItemDecoration(articleAttachmentCarouselItemDecoration);
        getRecyclerView().setAdapter(articleAttachmentCarouselRecyclerViewAdapter);
        carouselSnapHelper.attachToRecyclerView(getRecyclerView());
        checkTheCarouselLayoutDirection();
    }

    private final RecyclerView getRecyclerView() {
        return (RecyclerView) this.recyclerView.getValue();
    }

    private final View getNextButton() {
        return (View) this.nextButton.getValue();
    }

    private final View getPrevButton() {
        return (View) this.prevButton.getValue();
    }

    private final ImageView getNextButtonIconView() {
        return (ImageView) this.nextButtonIconView.getValue();
    }

    private final ImageView getPrevButtonIconView() {
        return (ImageView) this.prevButtonIconView.getValue();
    }

    public void render(Function1<? super ArticleAttachmentCarouselRendering, ArticleAttachmentCarouselRendering> renderingUpdate) {
        Intrinsics.checkNotNullParameter(renderingUpdate, "renderingUpdate");
        ArticleAttachmentCarouselCellState state = this.rendering.getState();
        ArticleAttachmentCarouselRendering articleAttachmentCarouselRenderingInvoke = renderingUpdate.invoke(this.rendering);
        this.rendering = articleAttachmentCarouselRenderingInvoke;
        if (!Intrinsics.areEqual(state, articleAttachmentCarouselRenderingInvoke.getState())) {
            this.adapter.swapData(this.rendering.getState());
            getNextButton().getBackground().mutate().setTint(this.rendering.getState().getNavigationButtonBackgroundColor());
            getPrevButton().getBackground().mutate().setTint(this.rendering.getState().getNavigationButtonBackgroundColor());
            getNextButtonIconView().setColorFilter(this.rendering.getState().getTextColor());
            getPrevButtonIconView().setColorFilter(this.rendering.getState().getTextColor());
            setUpNextAndPreviousButton(this.rendering.getState());
        }
        this.adapter.setOnAttachmentItemClicked(this.rendering.getOnAttachmentItemClicked$zendesk_ui_ui_android());
    }

    private final void setUpNextAndPreviousButton(ArticleAttachmentCarouselCellState state) {
        checkCarouselsScrollingAndButtonVisibility();
        setupButtonFocusStates(state);
        getNextButton().setOnClickListener(new View.OnClickListener() {
            @Override
            public final void onClick(View view) {
                ArticleAttachmentCarouselCellView.setUpNextAndPreviousButton$lambda$0(this.f$0, view);
            }
        });
        getPrevButton().setOnClickListener(new View.OnClickListener() {
            @Override
            public final void onClick(View view) {
                ArticleAttachmentCarouselCellView.setUpNextAndPreviousButton$lambda$1(this.f$0, view);
            }
        });
        getRecyclerView().addOnScrollListener(new RecyclerView.OnScrollListener() {
            public void onScrolled(RecyclerView recyclerView, int dx, int dy) {
                Intrinsics.checkNotNullParameter(recyclerView, "recyclerView");
                ArticleAttachmentCarouselCellView.this.checkCarouselsScrollingAndButtonVisibility();
            }
        });
    }

    public static final void setUpNextAndPreviousButton$lambda$0(ArticleAttachmentCarouselCellView this$0, View view) {
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        int iFindLastCompletelyVisibleItemPosition = this$0.layoutManager.findLastCompletelyVisibleItemPosition();
        int iFindLastVisibleItemPosition = this$0.layoutManager.findLastVisibleItemPosition();
        if (iFindLastVisibleItemPosition == iFindLastCompletelyVisibleItemPosition) {
            iFindLastVisibleItemPosition = iFindLastCompletelyVisibleItemPosition + 1;
        }
        this$0.smoothScroller.setTargetPosition(iFindLastVisibleItemPosition);
        if (iFindLastVisibleItemPosition < this$0.adapter.getItemCount()) {
            this$0.layoutManager.startSmoothScroll(this$0.smoothScroller);
        }
    }

    public static final void setUpNextAndPreviousButton$lambda$1(ArticleAttachmentCarouselCellView this$0, View view) {
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        int iFindFirstCompletelyVisibleItemPosition = this$0.layoutManager.findFirstCompletelyVisibleItemPosition();
        int iFindFirstVisibleItemPosition = this$0.layoutManager.findFirstVisibleItemPosition();
        if (iFindFirstVisibleItemPosition == iFindFirstCompletelyVisibleItemPosition) {
            iFindFirstVisibleItemPosition = iFindFirstCompletelyVisibleItemPosition - 1;
        }
        this$0.smoothScroller.setTargetPosition(iFindFirstVisibleItemPosition);
        if (iFindFirstVisibleItemPosition >= 0) {
            this$0.layoutManager.startSmoothScroll(this$0.smoothScroller);
        }
    }

    public final void checkCarouselsScrollingAndButtonVisibility() {
        boolean z = true;
        boolean z2 = this.layoutManager.findFirstCompletelyVisibleItemPosition() == 0;
        boolean z3 = this.layoutManager.findLastCompletelyVisibleItemPosition() == this.layoutManager.getItemCount() - 1;
        getNextButton().setVisibility(!z3 ? 0 : 8);
        getPrevButton().setVisibility(z2 ? 8 : 0);
        if (z2 && z3) {
            z = false;
        }
        this.layoutManager.setScroll$zendesk_ui_ui_android(z);
    }

    private final void checkTheCarouselLayoutDirection() {
        if (this.configuration.getLayoutDirection() == 1) {
            this.itemDecoration.setLayoutDirectionToRTL$zendesk_ui_ui_android();
        }
    }

    private final void setupButtonFocusStates(ArticleAttachmentCarouselCellState state) {
        View nextButton = getNextButton();
        int i = R.drawable.zuia_ic_carousel_next_button_circle;
        int i2 = R.dimen.zuia_carousel_next_prev_stroke_width;
        int focusedStateBorderColor = state.getFocusedStateBorderColor();
        Drawable drawable = ContextCompat.getDrawable(getContext(), R.drawable.zuia_ic_carousel_next_button_circle);
        Intrinsics.checkNotNull(drawable, "null cannot be cast to non-null type android.graphics.drawable.GradientDrawable");
        ViewKt.addAccessibilityFocusedState(nextButton, i, i2, focusedStateBorderColor, (GradientDrawable) drawable);
        View prevButton = getPrevButton();
        int i3 = R.drawable.zuia_ic_carousel_prev_button_circle;
        int i4 = R.dimen.zuia_carousel_next_prev_stroke_width;
        int focusedStateBorderColor2 = state.getFocusedStateBorderColor();
        Drawable drawable2 = ContextCompat.getDrawable(getContext(), R.drawable.zuia_ic_carousel_prev_button_circle);
        Intrinsics.checkNotNull(drawable2, "null cannot be cast to non-null type android.graphics.drawable.GradientDrawable");
        ViewKt.addAccessibilityFocusedState(prevButton, i3, i4, focusedStateBorderColor2, (GradientDrawable) drawable2);
    }
}
