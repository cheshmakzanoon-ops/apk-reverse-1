package zendesk.p026ui.android.conversation.imagecell;

import android.content.Context;
import android.content.res.ColorStateList;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.core.content.ContextCompat;
import androidx.vectordrawable.graphics.drawable.AnimatedVectorDrawableCompat;
import coil.ImageLoader;
import coil.request.Disposable;
import coil.request.ErrorResult;
import coil.request.ImageRequest;
import coil.request.SuccessResult;
import com.google.android.material.imageview.ShapeableImageView;
import com.google.android.material.shape.MaterialShapeDrawable;
import com.google.android.material.shape.ShapeAppearanceModel;
import java.util.List;
import kotlin.Lazy;
import kotlin.LazyKt;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.core.p017ui.android.internal.xml.AccessibilityExtKt;
import zendesk.p026ui.android.conversation.actionbutton.ActionButton;
import zendesk.p026ui.android.conversation.textcell.TextCellRendering;
import zendesk.p026ui.android.conversation.textcell.TextCellState;
import zendesk.p026ui.android.conversation.textcell.TextCellView;
import zendesk.p026ui.android.internal.ColorExtKt;
import zendesk.p026ui.android.internal.DimensionExtKt;
import zendesk.p026ui.android.internal.ImageLoaderFactory;
import zendesk.p026ui.android.internal.ThrottledOnClickListenerKt;
import zendesk.ui.android.R;
import zendesk.ui.android.Renderer;

@Metadata(m17d1 = {"\u0000~\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010\u0007\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0007\u0018\u0000 32\u00020\u00012\b\u0012\u0004\u0012\u00020\u00030\u0002:\u00013B%\b\u0007\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t¢\u0006\u0002\u0010\nJ\u0010\u0010$\u001a\u00020%2\u0006\u0010&\u001a\u00020\u0015H\u0002J \u0010'\u001a\u00020(2\u0006\u0010)\u001a\u00020\u00152\u0006\u0010*\u001a\u00020+2\u0006\u0010,\u001a\u00020%H\u0002J\b\u0010-\u001a\u00020\tH\u0002J\b\u0010.\u001a\u00020/H\u0014J\u001c\u00100\u001a\u00020/2\u0012\u00101\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u000302H\u0016R\u000e\u0010\u000b\u001a\u00020\fX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\r\u001a\u00020\u000eX\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\u000f\u001a\u0004\u0018\u00010\u0010X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0011\u001a\u00020\u0012X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0013\u001a\u00020\u0012X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0014\u001a\u00020\u0015X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0016\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000R\u0010\u0010\u0017\u001a\u0004\u0018\u00010\u0018X\u0082\u000e¢\u0006\u0002\n\u0000R\u001d\u0010\u0019\u001a\u0004\u0018\u00010\u00188BX\u0082\u0084\u0002¢\u0006\f\n\u0004\b\u001c\u0010\u001d\u001a\u0004\b\u001a\u0010\u001bR\u001d\u0010\u001e\u001a\u0004\u0018\u00010\u00188BX\u0082\u0084\u0002¢\u0006\f\n\u0004\b \u0010\u001d\u001a\u0004\b\u001f\u0010\u001bR\u000e\u0010!\u001a\u00020\fX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\"\u001a\u00020#X\u0082\u0004¢\u0006\u0002\n\u0000¨\u00064"}, m18d2 = {"Lzendesk/ui/android/conversation/imagecell/ImageCellView;", "Landroidx/constraintlayout/widget/ConstraintLayout;", "Lzendesk/ui/android/Renderer;", "Lzendesk/ui/android/conversation/imagecell/ImageCellRendering;", "context", "Landroid/content/Context;", "attrs", "Landroid/util/AttributeSet;", "defStyleAttrs", "", "(Landroid/content/Context;Landroid/util/AttributeSet;I)V", "cellRadius", "", "errorTextView", "Landroid/widget/TextView;", "imageLoaderDisposable", "Lcoil/request/Disposable;", "imageView", "Lcom/google/android/material/imageview/ShapeableImageView;", "imageViewOverlay", "isLayoutDirectionLtr", "", "rendering", "skeletonLoaderDrawable", "Landroidx/vectordrawable/graphics/drawable/AnimatedVectorDrawableCompat;", "skeletonLoaderInboundAnimation", "getSkeletonLoaderInboundAnimation", "()Landroidx/vectordrawable/graphics/drawable/AnimatedVectorDrawableCompat;", "skeletonLoaderInboundAnimation$delegate", "Lkotlin/Lazy;", "skeletonLoaderOutboundAnimation", "getSkeletonLoaderOutboundAnimation", "skeletonLoaderOutboundAnimation$delegate", "smallCellRadius", "textCellView", "Lzendesk/ui/android/conversation/textcell/TextCellView;", "buildShapeAppearanceModel", "Lcom/google/android/material/shape/ShapeAppearanceModel;", "isMessageTextViewVisible", "getImageBackground", "Lcom/google/android/material/shape/MaterialShapeDrawable;", "onStart", "state", "Lzendesk/ui/android/conversation/imagecell/ImageCellState;", "shapeAppearance", "getTextCellViewBackgroundResource", "onDetachedFromWindow", "", "render", "renderingUpdate", "Lkotlin/Function1;", "Companion", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ImageCellView extends ConstraintLayout implements Renderer<ImageCellRendering> {
    private static final float DEFAULT_ALPHA = 1.0f;
    private static final float PENDING_ALPHA = 0.5f;
    private static final int ROUNDED_CORNER = 0;
    private final float cellRadius;
    private final TextView errorTextView;
    private Disposable imageLoaderDisposable;
    private final ShapeableImageView imageView;
    private final ShapeableImageView imageViewOverlay;
    private final boolean isLayoutDirectionLtr;
    private ImageCellRendering rendering;
    private AnimatedVectorDrawableCompat skeletonLoaderDrawable;

    private final Lazy skeletonLoaderInboundAnimation;

    private final Lazy skeletonLoaderOutboundAnimation;
    private final float smallCellRadius;
    private final TextCellView textCellView;
    private static final Companion Companion = new Companion(null);
    public static final int $stable = 8;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[ImageCellDirection.values().length];
            try {
                iArr[ImageCellDirection.INBOUND_SINGLE.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[ImageCellDirection.INBOUND_BOTTOM.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                iArr[ImageCellDirection.INBOUND_TOP.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            try {
                iArr[ImageCellDirection.INBOUND_MIDDLE.ordinal()] = 4;
            } catch (NoSuchFieldError unused4) {
            }
            try {
                iArr[ImageCellDirection.OUTBOUND_SINGLE.ordinal()] = 5;
            } catch (NoSuchFieldError unused5) {
            }
            try {
                iArr[ImageCellDirection.OUTBOUND_BOTTOM.ordinal()] = 6;
            } catch (NoSuchFieldError unused6) {
            }
            try {
                iArr[ImageCellDirection.OUTBOUND_TOP.ordinal()] = 7;
            } catch (NoSuchFieldError unused7) {
            }
            try {
                iArr[ImageCellDirection.OUTBOUND_MIDDLE.ordinal()] = 8;
            } catch (NoSuchFieldError unused8) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    public ImageCellView(Context context) {
        this(context, null, 0, 6, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ImageCellView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0, 4, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ImageCellView(Context context, AttributeSet attributeSet, int i, int i2, DefaultConstructorMarker defaultConstructorMarker) {
        this(context, (i2 & 2) != 0 ? null : attributeSet, (i2 & 4) != 0 ? 0 : i);
    }

    public ImageCellView(final Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        Intrinsics.checkNotNullParameter(context, "context");
        this.rendering = new ImageCellRendering();
        this.isLayoutDirectionLtr = getResources().getConfiguration().getLayoutDirection() == 0;
        this.skeletonLoaderInboundAnimation = LazyKt.lazy(new Function0<AnimatedVectorDrawableCompat>() {
            {
                super(0);
            }

            @Override
            public final AnimatedVectorDrawableCompat invoke() {
                return AnimatedVectorDrawableCompat.create(context, R.drawable.zuia_skeleton_loader_inbound);
            }
        });
        this.skeletonLoaderOutboundAnimation = LazyKt.lazy(new Function0<AnimatedVectorDrawableCompat>() {
            {
                super(0);
            }

            @Override
            public final AnimatedVectorDrawableCompat invoke() {
                return AnimatedVectorDrawableCompat.create(context, R.drawable.zuia_skeleton_loader_outbound);
            }
        });
        context.getTheme().applyStyle(R.style.ThemeOverlay_ZendeskComponents_TextCellStyle, false);
        ConstraintLayout.inflate(context, R.layout.zuia_view_image_cell, (ViewGroup) this);
        View viewFindViewById = findViewById(R.id.zuia_text_cell_view);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById, "findViewById(...)");
        this.textCellView = (TextCellView) viewFindViewById;
        View viewFindViewById2 = findViewById(R.id.zuia_image_view);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById2, "findViewById(...)");
        View view = (ShapeableImageView) viewFindViewById2;
        this.imageView = view;
        ShapeableImageView shapeableImageViewFindViewById = findViewById(R.id.zuia_image_view_overlay);
        Intrinsics.checkNotNullExpressionValue(shapeableImageViewFindViewById, "findViewById(...)");
        this.imageViewOverlay = shapeableImageViewFindViewById;
        View viewFindViewById3 = findViewById(R.id.zuia_error_text);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById3, "findViewById(...)");
        this.errorTextView = (TextView) viewFindViewById3;
        this.cellRadius = DimensionExtKt.resolveDimensionAttr(context, new int[]{R.attr.messageCellRadiusSize});
        this.smallCellRadius = DimensionExtKt.resolveDimensionAttr(context, new int[]{R.attr.messageCellSmallRadiusSize});
        view.setContentDescription(getResources().getString(R.string.zuia_image_thumbnail_accessibility_label));
        String string = getResources().getString(R.string.zuia_image_thumbnail_accessibility_action_label);
        Intrinsics.checkNotNull(string);
        AccessibilityExtKt.overrideAccessibilityNodeActionInfo(view, string, 16);
        render(new Function1<ImageCellRendering, ImageCellRendering>() {
            @Override
            public final ImageCellRendering invoke(ImageCellRendering it) {
                Intrinsics.checkNotNullParameter(it, "it");
                return it;
            }
        });
    }

    private final AnimatedVectorDrawableCompat getSkeletonLoaderInboundAnimation() {
        return (AnimatedVectorDrawableCompat) this.skeletonLoaderInboundAnimation.getValue();
    }

    private final AnimatedVectorDrawableCompat getSkeletonLoaderOutboundAnimation() {
        return (AnimatedVectorDrawableCompat) this.skeletonLoaderOutboundAnimation.getValue();
    }

    public void render(Function1<? super ImageCellRendering, ImageCellRendering> renderingUpdate) {
        List<ActionButton> actions$zendesk_ui_ui_android;
        AnimatedVectorDrawableCompat skeletonLoaderOutboundAnimation;
        Intrinsics.checkNotNullParameter(renderingUpdate, "renderingUpdate");
        ImageCellState state = this.rendering.getState();
        ImageCellRendering imageCellRenderingInvoke = renderingUpdate.invoke(this.rendering);
        this.rendering = imageCellRenderingInvoke;
        if (Intrinsics.areEqual(state, imageCellRenderingInvoke.getState())) {
            return;
        }
        final ImageCellState state2 = this.rendering.getState();
        TextCellView textCellView = this.textCellView;
        String messageText$zendesk_ui_ui_android = state2.getMessageText$zendesk_ui_ui_android();
        textCellView.setVisibility((messageText$zendesk_ui_ui_android != null && messageText$zendesk_ui_ui_android.length() != 0) || ((actions$zendesk_ui_ui_android = this.rendering.getState().getActions$zendesk_ui_ui_android()) != null && !actions$zendesk_ui_ui_android.isEmpty()) ? 0 : 8);
        if (this.textCellView.getVisibility() == 0) {
            this.textCellView.render(new Function1<TextCellRendering, TextCellRendering>() {
                {
                    super(1);
                }

                @Override
                public final TextCellRendering invoke(TextCellRendering textCellRendering) {
                    Intrinsics.checkNotNullParameter(textCellRendering, "textCellRendering");
                    TextCellRendering.Builder builder = textCellRendering.toBuilder();
                    final ImageCellState imageCellState = state2;
                    final ImageCellView imageCellView = this.this$0;
                    return builder.state(new Function1<TextCellState, TextCellState>() {
                        {
                            super(1);
                        }

                        @Override
                        public final TextCellState invoke(TextCellState state3) {
                            Intrinsics.checkNotNullParameter(state3, "state");
                            String messageText$zendesk_ui_ui_android2 = imageCellState.getMessageText$zendesk_ui_ui_android();
                            if (messageText$zendesk_ui_ui_android2 == null) {
                                messageText$zendesk_ui_ui_android2 = "";
                            }
                            String str = messageText$zendesk_ui_ui_android2;
                            int textColor$zendesk_ui_ui_android = imageCellState.getTextColor$zendesk_ui_ui_android();
                            int backgroundColor$zendesk_ui_ui_android = imageCellState.getBackgroundColor$zendesk_ui_ui_android();
                            int textCellViewBackgroundResource = imageCellView.getTextCellViewBackgroundResource();
                            return TextCellState.copy$default(state3, str, imageCellView.rendering.getState().getActions$zendesk_ui_ui_android(), null, false, null, null, null, Integer.valueOf(textColor$zendesk_ui_ui_android), Integer.valueOf(backgroundColor$zendesk_ui_ui_android), Integer.valueOf(textCellViewBackgroundResource), Integer.valueOf(imageCellView.rendering.getState().getActionColor$zendesk_ui_ui_android()), Integer.valueOf(imageCellView.rendering.getState().getActionTextColor$zendesk_ui_ui_android()), null, null, 12412, null);
                        }
                    }).onActionButtonClicked(this.this$0.rendering.getOnActionButtonClicked$zendesk_ui_ui_android()).onPostbackButtonClicked(this.this$0.rendering.getOnPostbackButtonClicked$zendesk_ui_ui_android()).onWebViewActionButtonClicked(this.this$0.rendering.getOnWebViewActionButtonClicked$zendesk_ui_ui_android()).build();
                }
            });
            this.textCellView.setMessageTextGravity$zendesk_ui_ui_android(8388611);
        }
        this.errorTextView.setText(state2.getErrorText$zendesk_ui_ui_android());
        this.errorTextView.setTextColor(state2.getErrorColor$zendesk_ui_ui_android());
        final ColorDrawable colorDrawable = new ColorDrawable(state2.getErrorBackgroundColor$zendesk_ui_ui_android());
        ShapeAppearanceModel shapeAppearanceModelBuildShapeAppearanceModel = buildShapeAppearanceModel(this.textCellView.getVisibility() == 0);
        this.imageView.setShapeAppearanceModel(shapeAppearanceModelBuildShapeAppearanceModel);
        this.imageViewOverlay.setShapeAppearanceModel(shapeAppearanceModelBuildShapeAppearanceModel);
        final Drawable materialShapeDrawable = new MaterialShapeDrawable(shapeAppearanceModelBuildShapeAppearanceModel);
        materialShapeDrawable.setFillColor(ColorStateList.valueOf(ContextCompat.getColor(getContext(), R.color.zuia_color_transparent)));
        materialShapeDrawable.setStrokeWidth(getResources().getDimension(R.dimen.zuia_inner_stroke_width));
        materialShapeDrawable.setStrokeColor(ColorStateList.valueOf(state2.getBackgroundColor$zendesk_ui_ui_android()));
        ColorDrawable colorDrawable2 = new ColorDrawable(state2.getBackgroundColor$zendesk_ui_ui_android());
        ColorDrawable colorDrawable3 = new ColorDrawable(ColorExtKt.adjustAlpha(state2.getErrorColor$zendesk_ui_ui_android(), 0.3f));
        if (ImageCellDirection.INSTANCE.isInbound(state2.getImageCellDirection$zendesk_ui_ui_android())) {
            skeletonLoaderOutboundAnimation = getSkeletonLoaderInboundAnimation();
        } else {
            skeletonLoaderOutboundAnimation = getSkeletonLoaderOutboundAnimation();
        }
        this.skeletonLoaderDrawable = skeletonLoaderOutboundAnimation;
        this.imageView.setImageDrawable((Drawable) skeletonLoaderOutboundAnimation);
        this.imageView.setBackground(getImageBackground(true, state2, shapeAppearanceModelBuildShapeAppearanceModel));
        AnimatedVectorDrawableCompat animatedVectorDrawableCompat = this.skeletonLoaderDrawable;
        if (animatedVectorDrawableCompat != null) {
            animatedVectorDrawableCompat.start();
        }
        this.imageView.setOnClickListener(ThrottledOnClickListenerKt.throttledOnClickListener(600L, new Function0<Unit>() {
            {
                super(0);
            }

            @Override
            public Unit invoke() {
                invoke2();
                return Unit.INSTANCE;
            }

            public final void invoke2() {
                Function1<String, Unit> onImageCellClicked$zendesk_ui_ui_android;
                Uri localUri$zendesk_ui_ui_android = state2.getLocalUri$zendesk_ui_ui_android();
                if (localUri$zendesk_ui_ui_android == null) {
                    localUri$zendesk_ui_ui_android = state2.getUri$zendesk_ui_ui_android();
                }
                if (localUri$zendesk_ui_ui_android == null || (onImageCellClicked$zendesk_ui_ui_android = this.rendering.getOnImageCellClicked$zendesk_ui_ui_android()) == null) {
                    return;
                }
                onImageCellClicked$zendesk_ui_ui_android.invoke(String.valueOf(state2.getUri$zendesk_ui_ui_android()));
            }
        }));
        if (state2.isError$zendesk_ui_ui_android()) {
            this.imageViewOverlay.setVisibility(0);
            this.imageViewOverlay.setImageDrawable(colorDrawable3);
        } else {
            this.imageViewOverlay.setVisibility(8);
            this.imageViewOverlay.setImageDrawable((Drawable) null);
        }
        if (state2.isPending$zendesk_ui_ui_android()) {
            this.imageView.setAlpha(PENDING_ALPHA);
        } else {
            this.imageView.setAlpha(1.0f);
        }
        ImageLoaderFactory imageLoaderFactory = ImageLoaderFactory.INSTANCE;
        Context context = getContext();
        Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
        ImageLoader imageLoader = imageLoaderFactory.getImageLoader(context);
        Uri localUri$zendesk_ui_ui_android = state2.getLocalUri$zendesk_ui_ui_android();
        if (localUri$zendesk_ui_ui_android == null) {
            localUri$zendesk_ui_ui_android = state2.getUri$zendesk_ui_ui_android();
        }
        if (ImageType.INSTANCE.isSupported(state2.getImageType$zendesk_ui_ui_android())) {
            Context context2 = getContext();
            Intrinsics.checkNotNullExpressionValue(context2, "getContext(...)");
            ImageRequest.Builder builderTarget = new ImageRequest.Builder(context2).fallback(this.skeletonLoaderDrawable).placeholder(this.skeletonLoaderDrawable).listener(new ImageRequest.Listener(materialShapeDrawable, this, this, colorDrawable, this) {
                final MaterialShapeDrawable $backgroundDrawable$inlined;
                final ColorDrawable $errorDrawable$inlined;

                {
                    this.$errorDrawable$inlined = colorDrawable;
                }

                public void onStart(ImageRequest request) {
                    this.this$0.imageView.setBackground(this.$backgroundDrawable$inlined);
                    this.this$0.errorTextView.setVisibility(8);
                }

                public void onSuccess(ImageRequest request, SuccessResult result) {
                    this.this$0.imageView.setBackground((Drawable) null);
                    this.this$0.errorTextView.setVisibility(8);
                }

                public void onError(ImageRequest request, ErrorResult result) {
                    this.this$0.imageView.setImageDrawable(this.$errorDrawable$inlined);
                    this.this$0.errorTextView.setVisibility(0);
                }

                public void onCancel(ImageRequest request) {
                    this.this$0.errorTextView.setVisibility(0);
                }
            }).placeholder(colorDrawable2).crossfade(true).data(localUri$zendesk_ui_ui_android).target(this.imageView);
            String authorizationToken$zendesk_ui_ui_android = state2.getAuthorizationToken$zendesk_ui_ui_android();
            if (authorizationToken$zendesk_ui_ui_android != null) {
                builderTarget.addHeader("Authorization", authorizationToken$zendesk_ui_ui_android);
            }
            this.imageLoaderDisposable = imageLoader.enqueue(builderTarget.build());
            return;
        }
        this.imageView.setBackground(materialShapeDrawable);
        this.imageView.setImageDrawable(colorDrawable);
        this.errorTextView.setVisibility(0);
    }

    private final ShapeAppearanceModel buildShapeAppearanceModel(boolean isMessageTextViewVisible) {
        ShapeAppearanceModel.Builder bottomLeftCorner;
        ImageRoundedCorner imageRoundedCornerBuild = new ImageRoundedCorner.Builder(this.cellRadius, this.smallCellRadius, this.rendering.getState().getImageCellDirection$zendesk_ui_ui_android(), this.isLayoutDirectionLtr).build();
        ShapeAppearanceModel.Builder topRightCorner = new ShapeAppearanceModel().toBuilder().setTopLeftCorner(0, imageRoundedCornerBuild.getTopLeft()).setTopRightCorner(0, imageRoundedCornerBuild.getTopRight());
        Intrinsics.checkNotNullExpressionValue(topRightCorner, "setTopRightCorner(...)");
        if (isMessageTextViewVisible) {
            bottomLeftCorner = topRightCorner.setBottomRightCorner(0, 0.0f).setBottomLeftCorner(0, 0.0f);
        } else {
            bottomLeftCorner = topRightCorner.setBottomRightCorner(0, imageRoundedCornerBuild.getBottomRight()).setBottomLeftCorner(0, imageRoundedCornerBuild.getBottomLeft());
        }
        ShapeAppearanceModel shapeAppearanceModelBuild = bottomLeftCorner.build();
        Intrinsics.checkNotNullExpressionValue(shapeAppearanceModelBuild, "build(...)");
        return shapeAppearanceModelBuild;
    }

    public final int getTextCellViewBackgroundResource() {
        switch (WhenMappings.$EnumSwitchMapping$0[this.rendering.getState().getImageCellDirection$zendesk_ui_ui_android().ordinal()]) {
            case 1:
            case 2:
                return R.drawable.zuia_image_cell_message_inbound_shape_single;
            case 3:
            case 4:
                return R.drawable.zuia_image_cell_message_inbound_shape_middle;
            case 5:
            case 6:
                return R.drawable.zuia_image_cell_message_outbound_shape_single;
            case 7:
            case 8:
                return R.drawable.zuia_image_cell_message_outbound_shape_middle;
            default:
                throw new NoWhenBranchMatchedException();
        }
    }

    private final MaterialShapeDrawable getImageBackground(boolean onStart, ImageCellState state, ShapeAppearanceModel shapeAppearance) {
        int backgroundColor$zendesk_ui_ui_android = state.getBackgroundColor$zendesk_ui_ui_android();
        int color = onStart ? backgroundColor$zendesk_ui_ui_android : ContextCompat.getColor(getContext(), R.color.zuia_color_transparent);
        MaterialShapeDrawable materialShapeDrawable = new MaterialShapeDrawable(shapeAppearance);
        materialShapeDrawable.setFillColor(ColorStateList.valueOf(color));
        if (!onStart) {
            materialShapeDrawable.setStrokeWidth(getResources().getDimension(R.dimen.zuia_inner_stroke_width));
            materialShapeDrawable.setStrokeColor(ColorStateList.valueOf(backgroundColor$zendesk_ui_ui_android));
        }
        return materialShapeDrawable;
    }

    protected void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        Disposable disposable = this.imageLoaderDisposable;
        if (disposable != null) {
            disposable.dispose();
        }
        AnimatedVectorDrawableCompat animatedVectorDrawableCompat = this.skeletonLoaderDrawable;
        if (animatedVectorDrawableCompat != null) {
            animatedVectorDrawableCompat.stop();
        }
    }

    @Metadata(m17d1 = {"\u0000\u001a\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u0007\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082T¢\u0006\u0002\n\u0000¨\u0006\b"}, m18d2 = {"Lzendesk/ui/android/conversation/imagecell/ImageCellView$Companion;", "", "()V", "DEFAULT_ALPHA", "", "PENDING_ALPHA", "ROUNDED_CORNER", "", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
