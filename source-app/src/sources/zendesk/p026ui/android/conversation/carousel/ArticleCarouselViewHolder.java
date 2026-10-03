package zendesk.p026ui.android.conversation.carousel;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.util.AttributeSet;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import coil.ImageLoader;
import coil.request.Disposable;
import coil.request.ImageRequest;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.math.MathKt;
import kotlin.text.StringsKt;
import zendesk.p026ui.android.internal.ColorExtKt;
import zendesk.p026ui.android.internal.DimensionExtKt;
import zendesk.ui.android.R;
import zendesk.ui.android.common.button.ButtonRendering;
import zendesk.ui.android.common.button.ButtonState;
import zendesk.ui.android.common.button.ButtonView;

@Metadata(m17d1 = {"\u0000d\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0007\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0002\b\u0000\u0018\u0000 \"2\u00020\u0001:\u0001\"B\u0017\b\u0002\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\u0016\u0010\u0013\u001a\u00020\u00142\u0006\u0010\u0015\u001a\u00020\u00162\u0006\u0010\u0017\u001a\u00020\u0018J\b\u0010\u0019\u001a\u00020\u0014H\u0002J*\u0010\u001a\u001a\u00020\u00142\u0006\u0010\u001b\u001a\u00020\u001c2\u0006\u0010\u001d\u001a\u00020\u001e2\u0006\u0010\u001f\u001a\u00020\u001e2\b\b\u0002\u0010 \u001a\u00020!H\u0002R\u000e\u0010\u0007\u001a\u00020\bX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\t\u001a\u00020\nX\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u000b\u001a\u00020\bX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\f\u001a\u00020\rX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000e\u001a\u00020\u000fX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\u0010\u001a\u0004\u0018\u00010\u0011X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0012\u001a\u00020\rX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006#"}, m18d2 = {"Lzendesk/ui/android/conversation/carousel/ArticleCarouselViewHolder;", "Lzendesk/ui/android/conversation/carousel/CarouselViewHolder;", "view", "Landroid/view/View;", "imageLoader", "Lcoil/ImageLoader;", "(Landroid/view/View;Lcoil/ImageLoader;)V", "actionButtonContainer", "Landroid/widget/LinearLayout;", "borderAlpha", "", "carouselContainer", "desc", "Landroid/widget/TextView;", "image", "Landroid/widget/ImageView;", "imageLoadingDisposable", "Lcoil/request/Disposable;", "title", "bind", "", "rendering", "Lzendesk/ui/android/conversation/carousel/CarouselRendering;", "cellData", "Lzendesk/ui/android/conversation/carousel/CarouselCellData$Item;", "getTheArticleAttachmentCarouselBorderAlpha", "renderButton", "action", "Lzendesk/ui/android/conversation/carousel/CarouselAction;", "textColor", "", "backgroundColor", "isEnabled", "", "Companion", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ArticleCarouselViewHolder extends CarouselViewHolder {
    private static final int BUTTON_MARGIN_BOTTOM = 10;
    private static final int BUTTON_MARGIN_TOP = 2;
    private final LinearLayout actionButtonContainer;
    private float borderAlpha;
    private final LinearLayout carouselContainer;
    private final TextView desc;
    private final ImageView image;
    private final ImageLoader imageLoader;
    private Disposable imageLoadingDisposable;
    private final TextView title;
    private final View view;

    public static final Companion INSTANCE = new Companion(null);
    public static final int $stable = 8;

    public ArticleCarouselViewHolder(View view, ImageLoader imageLoader, DefaultConstructorMarker defaultConstructorMarker) {
        this(view, imageLoader);
    }

    private ArticleCarouselViewHolder(View view, ImageLoader imageLoader) {
        super(view);
        this.view = view;
        this.imageLoader = imageLoader;
        View viewFindViewById = view.findViewById(R.id.zuia_carousel_list_item_container);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById, "findViewById(...)");
        this.carouselContainer = (LinearLayout) viewFindViewById;
        View viewFindViewById2 = view.findViewById(R.id.zuia_carousel_list_item_title);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById2, "findViewById(...)");
        this.title = (TextView) viewFindViewById2;
        View viewFindViewById3 = view.findViewById(R.id.zuia_carousel_list_item_description);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById3, "findViewById(...)");
        this.desc = (TextView) viewFindViewById3;
        View viewFindViewById4 = view.findViewById(R.id.zuia_carousel_list_item_image);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById4, "findViewById(...)");
        this.image = (ImageView) viewFindViewById4;
        View viewFindViewById5 = view.findViewById(R.id.zuia_carousel_list_item_article_button_container);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById5, "findViewById(...)");
        this.actionButtonContainer = (LinearLayout) viewFindViewById5;
        getTheArticleAttachmentCarouselBorderAlpha();
    }

    public final void bind(CarouselRendering rendering, CarouselCellData.Item cellData) {
        String mediaType;
        Intrinsics.checkNotNullParameter(rendering, "rendering");
        Intrinsics.checkNotNullParameter(cellData, "cellData");
        Drawable background = this.carouselContainer.getBackground();
        GradientDrawable gradientDrawable = background instanceof GradientDrawable ? (GradientDrawable) background : null;
        if (gradientDrawable != null) {
            gradientDrawable.mutate();
        }
        if (gradientDrawable != null) {
            gradientDrawable.setColor(rendering.getSystemMessageColor());
        }
        if (gradientDrawable != null) {
            gradientDrawable.setStroke(MathKt.roundToInt(this.carouselContainer.getResources().getDimension(R.dimen.zuia_inner_stroke_width)), ColorExtKt.adjustAlpha(rendering.getTextColor(), this.borderAlpha));
        }
        this.title.setText(cellData.getTitle());
        this.desc.setText(cellData.getDescription());
        this.title.setTextColor(rendering.getTextColor());
        this.desc.setTextColor(rendering.getTextColor());
        this.actionButtonContainer.removeAllViews();
        for (CarouselAction carouselAction : cellData.getActions()) {
            if (carouselAction instanceof CarouselAction.Unsupported) {
                renderButton(carouselAction, rendering.getActionDisabledTextColor(), rendering.getActionDisabledBackgroundColor(), false);
            } else {
                renderButton$default(this, carouselAction, rendering.getActionTextColor(), rendering.getActionBackgroundColor(), false, 8, null);
            }
        }
        Disposable disposable = this.imageLoadingDisposable;
        if (disposable != null) {
            disposable.dispose();
        }
        if (cellData.getMediaUrl() != null && (mediaType = cellData.getMediaType()) != null && true == StringsKt.contains$default((CharSequence) mediaType, (CharSequence) "image", false, 2, (Object) null)) {
            this.image.setVisibility(0);
            Context context = this.itemView.getContext();
            Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
            this.imageLoadingDisposable = this.imageLoader.enqueue(new ImageRequest.Builder(context).data(cellData.getMediaUrl()).target(this.image).build());
            return;
        }
        this.image.setVisibility(8);
    }

    static void renderButton$default(ArticleCarouselViewHolder articleCarouselViewHolder, CarouselAction carouselAction, int i, int i2, boolean z, int i3, Object obj) {
        if ((i3 & 8) != 0) {
            z = true;
        }
        articleCarouselViewHolder.renderButton(carouselAction, i, i2, z);
    }

    private final void renderButton(final CarouselAction action, final int textColor, final int backgroundColor, final boolean isEnabled) {
        Context context = this.itemView.getContext();
        Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
        View buttonView = new ButtonView(context, (AttributeSet) null, 0, 6, (DefaultConstructorMarker) null);
        buttonView.setId(R.id.zuia_button);
        buttonView.render(new Function1<ButtonRendering, ButtonRendering>() {
            {
                super(1);
            }

            @Override
            public final ButtonRendering invoke(ButtonRendering render) {
                Intrinsics.checkNotNullParameter(render, "render");
                ButtonRendering.Builder builder = render.toBuilder();
                final CarouselAction carouselAction = action;
                ButtonRendering.Builder builderOnButtonClicked = builder.onButtonClicked(new Function0<Unit>() {
                    {
                        super(0);
                    }

                    @Override
                    public Unit invoke() {
                        invoke2();
                        return Unit.INSTANCE;
                    }

                    public final void invoke2() {
                        carouselAction.getClickListener().invoke(carouselAction);
                    }
                });
                final CarouselAction carouselAction2 = action;
                final int i = backgroundColor;
                final int i2 = textColor;
                final boolean z = isEnabled;
                return builderOnButtonClicked.state(new Function1<ButtonState, ButtonState>() {
                    {
                        super(1);
                    }

                    @Override
                    public final ButtonState invoke(ButtonState state) {
                        Intrinsics.checkNotNullParameter(state, "state");
                        return ButtonState.copy$default(state, carouselAction2.getText(), carouselAction2.getIsLoading(), Integer.valueOf(i), Integer.valueOf(i2), (Integer) null, z, 16, (Object) null);
                    }
                }).build();
            }
        });
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(-1, -2);
        Context context2 = this.view.getContext();
        Intrinsics.checkNotNullExpressionValue(context2, "getContext(...)");
        DimensionExtKt.resolveDimensionAttr(context2, new int[]{R.attr.messageCellRadiusSize});
        layoutParams.setMargins(0, DimensionExtKt.getPx(2), 0, DimensionExtKt.getPx(10));
        this.actionButtonContainer.addView(buttonView, layoutParams);
    }

    private final void getTheArticleAttachmentCarouselBorderAlpha() {
        TypedValue typedValue = new TypedValue();
        this.view.getContext().getResources().getValue(R.dimen.zuia_article_attachment_border_alpha, typedValue, true);
        this.borderAlpha = typedValue.getFloat();
    }

    @Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u001e\u0010\u0006\u001a\u00020\u00072\u0006\u0010\b\u001a\u00020\t2\u0006\u0010\n\u001a\u00020\u000b2\u0006\u0010\f\u001a\u00020\rR\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000¨\u0006\u000e"}, m18d2 = {"Lzendesk/ui/android/conversation/carousel/ArticleCarouselViewHolder$Companion;", "", "()V", "BUTTON_MARGIN_BOTTOM", "", "BUTTON_MARGIN_TOP", "create", "Lzendesk/ui/android/conversation/carousel/ArticleCarouselViewHolder;", "layoutInflater", "Landroid/view/LayoutInflater;", "parent", "Landroid/view/ViewGroup;", "imageLoader", "Lcoil/ImageLoader;", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final ArticleCarouselViewHolder create(LayoutInflater layoutInflater, ViewGroup parent, ImageLoader imageLoader) {
            Intrinsics.checkNotNullParameter(layoutInflater, "layoutInflater");
            Intrinsics.checkNotNullParameter(parent, "parent");
            Intrinsics.checkNotNullParameter(imageLoader, "imageLoader");
            View viewInflate = layoutInflater.inflate(R.layout.zuia_view_carousel_item_article, parent, false);
            Intrinsics.checkNotNull(viewInflate);
            return new ArticleCarouselViewHolder(viewInflate, imageLoader, null);
        }
    }
}
