package zendesk.p026ui.android.conversation.carousel;

import android.content.Context;
import android.content.res.Configuration;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.ImageView;
import androidx.core.content.ContextCompat;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.NoSuchElementException;
import kotlin.Lazy;
import kotlin.Metadata;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.p026ui.android.internal.ViewKt;
import zendesk.ui.android.R;
import zendesk.ui.android.Renderer;

@Metadata(m17d1 = {"\u0000x\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0007\u0018\u00002\u00020\u00012\b\u0012\u0004\u0012\u00020\u00030\u0002B%\b\u0007\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t¢\u0006\u0002\u0010\nJ\u0010\u00100\u001a\u0002012\u0006\u0010/\u001a\u00020\u0003H\u0002J\b\u00102\u001a\u000201H\u0002J\b\u00103\u001a\u000201H\u0002J\u001c\u00104\u001a\u0002012\u0012\u00105\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u000306H\u0016J\u0010\u00107\u001a\u0002012\u0006\u0010/\u001a\u00020\u0003H\u0002J\u0010\u00108\u001a\u0002012\u0006\u0010/\u001a\u00020\u0003H\u0002R\u000e\u0010\u000b\u001a\u00020\fX\u0082\u0004¢\u0006\u0002\n\u0000R\u0016\u0010\r\u001a\n \u000f*\u0004\u0018\u00010\u000e0\u000eX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0010\u001a\u00020\u0011X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0012\u001a\u00020\u0013X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0014\u001a\u00020\tX\u0082D¢\u0006\u0002\n\u0000R\u001b\u0010\u0015\u001a\u00020\u00168BX\u0082\u0084\u0002¢\u0006\f\n\u0004\b\u0019\u0010\u001a\u001a\u0004\b\u0017\u0010\u0018R\u001b\u0010\u001b\u001a\u00020\u001c8BX\u0082\u0084\u0002¢\u0006\f\n\u0004\b\u001f\u0010\u001a\u001a\u0004\b\u001d\u0010\u001eR\u001b\u0010 \u001a\u00020\u00168BX\u0082\u0084\u0002¢\u0006\f\n\u0004\b\"\u0010\u001a\u001a\u0004\b!\u0010\u0018R\u001b\u0010#\u001a\u00020\u001c8BX\u0082\u0084\u0002¢\u0006\f\n\u0004\b%\u0010\u001a\u001a\u0004\b$\u0010\u001eR\u001b\u0010&\u001a\u00020'8BX\u0082\u0084\u0002¢\u0006\f\n\u0004\b*\u0010\u001a\u001a\u0004\b(\u0010)R\u000e\u0010+\u001a\u00020,X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010-\u001a\u00020.X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010/\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u00069"}, m18d2 = {"Lzendesk/ui/android/conversation/carousel/CarouselCellView;", "Landroid/widget/FrameLayout;", "Lzendesk/ui/android/Renderer;", "Lzendesk/ui/android/conversation/carousel/CarouselCellState;", "context", "Landroid/content/Context;", "attrs", "Landroid/util/AttributeSet;", "defStyleAttrs", "", "(Landroid/content/Context;Landroid/util/AttributeSet;I)V", "adapter", "Lzendesk/ui/android/conversation/carousel/CarouselRecyclerViewAdapter;", "configuration", "Landroid/content/res/Configuration;", "kotlin.jvm.PlatformType", "itemDecoration", "Lzendesk/ui/android/conversation/carousel/CarouselItemDecoration;", "layoutManager", "Lzendesk/ui/android/conversation/carousel/CarouselLayoutManager;", "marginCount", "nextButton", "Landroid/view/View;", "getNextButton", "()Landroid/view/View;", "nextButton$delegate", "Lkotlin/Lazy;", "nextButtonIconView", "Landroid/widget/ImageView;", "getNextButtonIconView", "()Landroid/widget/ImageView;", "nextButtonIconView$delegate", "prevButton", "getPrevButton", "prevButton$delegate", "prevButtonIconView", "getPrevButtonIconView", "prevButtonIconView$delegate", "recyclerView", "Landroidx/recyclerview/widget/RecyclerView;", "getRecyclerView", "()Landroidx/recyclerview/widget/RecyclerView;", "recyclerView$delegate", "smoothScroller", "Lzendesk/ui/android/conversation/carousel/CenterSmoothScroller;", "snapHelper", "Lzendesk/ui/android/conversation/carousel/CarouselSnapHelper;", "state", "calculateAndSetListHeight", "", "checkCarouselsScrollingAndButtonVisibility", "checkTheCarouselLayoutDirection", "render", "renderingUpdate", "Lkotlin/Function1;", "setUpNextAndPreviousButton", "setupButtonFocusStates", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class CarouselCellView extends FrameLayout implements Renderer<CarouselCellState> {
    public static final int $stable = 8;
    private final CarouselRecyclerViewAdapter adapter;
    private final Configuration configuration;
    private final CarouselItemDecoration itemDecoration;
    private final CarouselLayoutManager layoutManager;
    private final int marginCount;

    private final Lazy nextButton;

    private final Lazy nextButtonIconView;

    private final Lazy prevButton;

    private final Lazy prevButtonIconView;

    private final Lazy recyclerView;
    private final CenterSmoothScroller smoothScroller;
    private final CarouselSnapHelper snapHelper;
    private CarouselCellState state;

    public CarouselCellView(Context context) {
        this(context, null, 0, 6, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public CarouselCellView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0, 4, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public CarouselCellView(Context context, AttributeSet attributeSet, int i, int i2, DefaultConstructorMarker defaultConstructorMarker) {
        this(context, (i2 & 2) != 0 ? null : attributeSet, (i2 & 4) != 0 ? 0 : i);
    }

    public CarouselCellView(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        Intrinsics.checkNotNullParameter(context, "context");
        this.marginCount = 2;
        this.state = new CarouselCellState(null, null, null, 7, null);
        CarouselCellView carouselCellView = this;
        this.recyclerView = ViewKt.lazyViewById(carouselCellView, R.id.zuia_carousel_list);
        this.nextButton = ViewKt.lazyViewById(carouselCellView, R.id.zuia_carousel_next_button);
        this.prevButton = ViewKt.lazyViewById(carouselCellView, R.id.zuia_carousel_prev_button);
        this.nextButtonIconView = ViewKt.lazyViewById(carouselCellView, R.id.zuia_carousel_next_button_icon_view);
        this.prevButtonIconView = ViewKt.lazyViewById(carouselCellView, R.id.zuia_carousel_prev_button_icon_view);
        CarouselRecyclerViewAdapter carouselRecyclerViewAdapter = new CarouselRecyclerViewAdapter(context);
        this.adapter = carouselRecyclerViewAdapter;
        RecyclerView.LayoutManager carouselLayoutManager = new CarouselLayoutManager(context, carouselRecyclerViewAdapter);
        this.layoutManager = carouselLayoutManager;
        CarouselItemDecoration carouselItemDecoration = new CarouselItemDecoration(context);
        this.itemDecoration = carouselItemDecoration;
        CarouselSnapHelper carouselSnapHelper = new CarouselSnapHelper((LinearLayoutManager) carouselLayoutManager);
        this.snapHelper = carouselSnapHelper;
        this.smoothScroller = new CenterSmoothScroller(context);
        this.configuration = getResources().getConfiguration();
        context.getTheme().applyStyle(R.style.ThemeOverlay_ZendeskComponents_TextCellStyle, false);
        FrameLayout.inflate(context, R.layout.zuia_view_carousel_cell, this);
        getRecyclerView().setAdapter(carouselRecyclerViewAdapter);
        getRecyclerView().setLayoutManager(carouselLayoutManager);
        getRecyclerView().addItemDecoration(carouselItemDecoration);
        carouselSnapHelper.attachToRecyclerView(getRecyclerView());
        checkTheCarouselLayoutDirection();
    }

    private final RecyclerView getRecyclerView() {
        return (RecyclerView) this.recyclerView.getValue();
    }

    public final View getNextButton() {
        return (View) this.nextButton.getValue();
    }

    public final View getPrevButton() {
        return (View) this.prevButton.getValue();
    }

    private final ImageView getNextButtonIconView() {
        return (ImageView) this.nextButtonIconView.getValue();
    }

    private final ImageView getPrevButtonIconView() {
        return (ImageView) this.prevButtonIconView.getValue();
    }

    public void render(Function1<? super CarouselCellState, CarouselCellState> renderingUpdate) {
        Intrinsics.checkNotNullParameter(renderingUpdate, "renderingUpdate");
        this.state = renderingUpdate.invoke(this.state);
        CarouselCellState carouselCellStateCopy$default = CarouselCellState.copy$default(this.state, CollectionsKt.plus((Collection) CollectionsKt.listOf(new CarouselCellData.Avatar(this.state.getAvatarImageState())), (Iterable) this.state.getCellData()), null, null, 6, null);
        this.state = carouselCellStateCopy$default;
        this.layoutManager.setItemMargin$zendesk_ui_ui_android(carouselCellStateCopy$default.getRendering().getMargin());
        this.adapter.swapData(this.state);
        getNextButton().getBackground().mutate().setTint(this.state.getRendering().getNavigationButtonColor());
        getPrevButton().getBackground().mutate().setTint(this.state.getRendering().getNavigationButtonColor());
        getNextButtonIconView().setColorFilter(this.state.getRendering().getNavigationIconColor());
        getPrevButtonIconView().setColorFilter(this.state.getRendering().getNavigationIconColor());
        calculateAndSetListHeight(this.state);
        setUpNextAndPreviousButton(this.state);
    }

    private final void calculateAndSetListHeight(CarouselCellState state) {
        int dimensionPixelSize;
        Iterator it = CollectionsKt.filterIsInstance(state.getCellData(), CarouselCellData.Item.class).iterator();
        if (!it.hasNext()) {
            throw new NoSuchElementException();
        }
        int size = ((CarouselCellData.Item) it.next()).getActions().size();
        while (it.hasNext()) {
            int size2 = ((CarouselCellData.Item) it.next()).getActions().size();
            if (size < size2) {
                size = size2;
            }
        }
        List listFilterIsInstance = CollectionsKt.filterIsInstance(state.getCellData(), CarouselCellData.Item.class);
        if ((listFilterIsInstance instanceof Collection) && listFilterIsInstance.isEmpty()) {
            dimensionPixelSize = getResources().getDimensionPixelSize(R.dimen.zuia_carousel_height) - getResources().getDimensionPixelSize(R.dimen.zuia_carousel_image_height);
        } else {
            Iterator it2 = listFilterIsInstance.iterator();
            while (it2.hasNext()) {
                String mediaUrl = ((CarouselCellData.Item) it2.next()).getMediaUrl();
                if (mediaUrl != null && mediaUrl.length() != 0) {
                    dimensionPixelSize = getResources().getDimensionPixelSize(R.dimen.zuia_carousel_height);
                }
            }
            dimensionPixelSize = getResources().getDimensionPixelSize(R.dimen.zuia_carousel_height) - getResources().getDimensionPixelSize(R.dimen.zuia_carousel_image_height);
        }
        int dimensionPixelSize2 = dimensionPixelSize + (size * ((getResources().getDimensionPixelSize(R.dimen.zuia_carousel_button_margin) * this.marginCount) + getResources().getDimensionPixelSize(R.dimen.zuia_carousel_text_size)));
        ViewGroup.LayoutParams layoutParams = getRecyclerView().getLayoutParams();
        layoutParams.height = dimensionPixelSize2;
        getRecyclerView().setLayoutParams(layoutParams);
    }

    private final void setUpNextAndPreviousButton(CarouselCellState state) {
        setupButtonFocusStates(state);
        getNextButton().setOnClickListener(new View.OnClickListener() {
            @Override
            public final void onClick(View view) {
                CarouselCellView.setUpNextAndPreviousButton$lambda$3(this.f$0, view);
            }
        });
        getPrevButton().setOnClickListener(new View.OnClickListener() {
            @Override
            public final void onClick(View view) {
                CarouselCellView.setUpNextAndPreviousButton$lambda$4(this.f$0, view);
            }
        });
        getRecyclerView().addOnScrollListener(new RecyclerView.OnScrollListener() {
            public void onScrolled(RecyclerView recyclerView, int dx, int dy) {
                Intrinsics.checkNotNullParameter(recyclerView, "recyclerView");
                boolean z = CarouselCellView.this.layoutManager.findFirstCompletelyVisibleItemPosition() == 0 || CarouselCellView.this.layoutManager.findFirstCompletelyVisibleItemPosition() == 1;
                boolean z2 = CarouselCellView.this.layoutManager.findLastCompletelyVisibleItemPosition() == CarouselCellView.this.adapter.getItemCount() - 1;
                CarouselCellView.this.getPrevButton().setVisibility(!z ? 0 : 8);
                CarouselCellView.this.getNextButton().setVisibility(z2 ? 8 : 0);
                CarouselCellView.this.checkCarouselsScrollingAndButtonVisibility();
            }
        });
    }

    public static final void setUpNextAndPreviousButton$lambda$3(CarouselCellView this$0, View view) {
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        int iFindLastCompletelyVisibleItemPosition = this$0.layoutManager.findLastCompletelyVisibleItemPosition();
        int iFindLastVisibleItemPosition = this$0.layoutManager.findLastVisibleItemPosition();
        if (iFindLastVisibleItemPosition == iFindLastCompletelyVisibleItemPosition) {
            iFindLastVisibleItemPosition = iFindLastCompletelyVisibleItemPosition + 1;
        }
        this$0.smoothScroller.setTargetPosition(iFindLastVisibleItemPosition);
        if (iFindLastVisibleItemPosition < this$0.adapter.getItemCount()) {
            this$0.layoutManager.startSmoothScroll((RecyclerView.SmoothScroller) this$0.smoothScroller);
        }
    }

    public static final void setUpNextAndPreviousButton$lambda$4(CarouselCellView this$0, View view) {
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        int iFindFirstCompletelyVisibleItemPosition = this$0.layoutManager.findFirstCompletelyVisibleItemPosition();
        int iFindFirstVisibleItemPosition = this$0.layoutManager.findFirstVisibleItemPosition();
        if (iFindFirstVisibleItemPosition == iFindFirstCompletelyVisibleItemPosition) {
            iFindFirstVisibleItemPosition = iFindFirstCompletelyVisibleItemPosition - 1;
        }
        this$0.smoothScroller.setTargetPosition(iFindFirstVisibleItemPosition);
        if (iFindFirstVisibleItemPosition >= 0 || (this$0.adapter.hasAvatar() && iFindFirstVisibleItemPosition >= 1)) {
            this$0.layoutManager.startSmoothScroll((RecyclerView.SmoothScroller) this$0.smoothScroller);
        }
    }

    public final void checkCarouselsScrollingAndButtonVisibility() {
        if (this.layoutManager.getItemCount() - 1 == 1) {
            getNextButton().setVisibility(8);
            getPrevButton().setVisibility(8);
            this.layoutManager.setScroll$zendesk_ui_ui_android(false);
        }
    }

    private final void checkTheCarouselLayoutDirection() {
        if (this.configuration.getLayoutDirection() == 1) {
            this.itemDecoration.setLayoutDirectionToRTL$zendesk_ui_ui_android();
        }
    }

    private final void setupButtonFocusStates(CarouselCellState state) {
        View nextButton = getNextButton();
        int i = R.drawable.zuia_ic_carousel_next_button_circle;
        int i2 = R.dimen.zuia_carousel_next_prev_stroke_width;
        int focusedStateBorderColor = state.getRendering().getFocusedStateBorderColor();
        Drawable drawable = ContextCompat.getDrawable(getContext(), R.drawable.zuia_ic_carousel_next_button_circle);
        Intrinsics.checkNotNull(drawable, "null cannot be cast to non-null type android.graphics.drawable.GradientDrawable");
        ViewKt.addAccessibilityFocusedState(nextButton, i, i2, focusedStateBorderColor, (GradientDrawable) drawable);
        View prevButton = getPrevButton();
        int i3 = R.drawable.zuia_ic_carousel_prev_button_circle;
        int i4 = R.dimen.zuia_carousel_next_prev_stroke_width;
        int focusedStateBorderColor2 = state.getRendering().getFocusedStateBorderColor();
        Drawable drawable2 = ContextCompat.getDrawable(getContext(), R.drawable.zuia_ic_carousel_prev_button_circle);
        Intrinsics.checkNotNull(drawable2, "null cannot be cast to non-null type android.graphics.drawable.GradientDrawable");
        ViewKt.addAccessibilityFocusedState(prevButton, i3, i4, focusedStateBorderColor2, (GradientDrawable) drawable2);
    }
}
