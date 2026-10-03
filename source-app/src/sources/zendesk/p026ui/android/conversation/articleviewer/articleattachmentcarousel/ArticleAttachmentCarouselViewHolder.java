package zendesk.p026ui.android.conversation.articleviewer.articleattachmentcarousel;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.os.Build;
import android.text.format.Formatter;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import androidx.recyclerview.widget.RecyclerView;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.math.MathKt;
import zendesk.core.p017ui.android.internal.xml.AccessibilityExtKt;
import zendesk.p026ui.android.internal.ColorExtKt;
import zendesk.ui.android.R;

@Metadata(m17d1 = {"\u0000\\\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0007\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\t\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\b\u0000\u0018\u0000 \"2\u00020\u0001:\u0001\"B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J0\u0010\u0010\u001a\u00020\u00112\u0006\u0010\u0012\u001a\u00020\u00132\b\b\u0001\u0010\u0014\u001a\u00020\u00152\u0016\u0010\u0016\u001a\u0012\u0012\u0004\u0012\u00020\u0013\u0012\u0004\u0012\u00020\u00110\u0017j\u0002`\u0018J\u0018\u0010\u0019\u001a\u00020\u001a2\u0006\u0010\u001b\u001a\u00020\u001c2\u0006\u0010\u001d\u001a\u00020\u001eH\u0002J\b\u0010\u001f\u001a\u00020\u0011H\u0002J\u0010\u0010 \u001a\u00020\u001a2\u0006\u0010!\u001a\u00020\u001aH\u0002R\u000e\u0010\u0005\u001a\u00020\u0006X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0007\u001a\u00020\bX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\t\u001a\u00020\nX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000b\u001a\u00020\fX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\r\u001a\u00020\nX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000e\u001a\u00020\nX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000f\u001a\u00020\nX\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006#"}, m18d2 = {"Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentCarouselViewHolder;", "Landroidx/recyclerview/widget/RecyclerView$ViewHolder;", "view", "Landroid/view/View;", "(Landroid/view/View;)V", "borderAlpha", "", "carouselContainer", "Landroid/widget/RelativeLayout;", "detailSeparator", "Landroid/widget/TextView;", "image", "Landroid/widget/ImageView;", "size", "title", "type", "bind", "", "item", "Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentItem;", "textColor", "", "onAttachmentItemClicked", "Lkotlin/Function1;", "Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/OnAttachmentItemClicked;", "getFormattedFileSize", "", "fileSize", "", "context", "Landroid/content/Context;", "getTheArticleAttachmentCarouselBorderAlpha", "setCharacterLimit", "fileType", "Companion", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ArticleAttachmentCarouselViewHolder extends RecyclerView.ViewHolder {
    private float borderAlpha;
    private final RelativeLayout carouselContainer;
    private final TextView detailSeparator;
    private final ImageView image;
    private final TextView size;
    private final TextView title;
    private TextView type;
    private final View view;

    public static final Companion INSTANCE = new Companion(null);
    public static final int $stable = 8;

    public ArticleAttachmentCarouselViewHolder(View view) {
        super(view);
        Intrinsics.checkNotNullParameter(view, "view");
        this.view = view;
        View viewFindViewById = view.findViewById(R.id.zuia_attachment_carousel_list_item_container);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById, "findViewById(...)");
        this.carouselContainer = (RelativeLayout) viewFindViewById;
        View viewFindViewById2 = view.findViewById(R.id.zuia_attachment_carousel_title);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById2, "findViewById(...)");
        this.title = (TextView) viewFindViewById2;
        View viewFindViewById3 = view.findViewById(R.id.zuia_attachment_carousel_list_item_type);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById3, "findViewById(...)");
        this.type = (TextView) viewFindViewById3;
        View viewFindViewById4 = view.findViewById(R.id.zuia_attachment_carousel_list_item_size);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById4, "findViewById(...)");
        this.size = (TextView) viewFindViewById4;
        View viewFindViewById5 = view.findViewById(R.id.zuia_attachment_carousel_list_item_separator);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById5, "findViewById(...)");
        this.detailSeparator = (TextView) viewFindViewById5;
        View viewFindViewById6 = view.findViewById(R.id.zuia_attachment_carousel_list_item_image);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById6, "findViewById(...)");
        this.image = (ImageView) viewFindViewById6;
        getTheArticleAttachmentCarouselBorderAlpha();
    }

    public final void bind(final ArticleAttachmentItem item, int textColor, final Function1<? super ArticleAttachmentItem, Unit> onAttachmentItemClicked) {
        Intrinsics.checkNotNullParameter(item, "item");
        Intrinsics.checkNotNullParameter(onAttachmentItemClicked, "onAttachmentItemClicked");
        Drawable background = this.carouselContainer.getBackground();
        GradientDrawable gradientDrawable = background instanceof GradientDrawable ? (GradientDrawable) background : null;
        if (gradientDrawable != null) {
            gradientDrawable.mutate();
        }
        if (gradientDrawable != null) {
            gradientDrawable.setStroke(MathKt.roundToInt(this.carouselContainer.getResources().getDimension(R.dimen.zuia_inner_stroke_width)), ColorExtKt.adjustAlpha(textColor, this.borderAlpha));
        }
        this.title.setText(item.getTitle());
        this.type.setText(setCharacterLimit(item.getType()));
        TextView textView = this.size;
        long size = item.getSize();
        Context context = this.view.getContext();
        Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
        textView.setText(getFormattedFileSize(size, context));
        this.detailSeparator.setText("•");
        this.image.setImageResource(R.drawable.zuia_ic_article_attachment_carousel);
        this.title.setTextColor(textColor);
        this.type.setTextColor(textColor);
        this.size.setTextColor(textColor);
        this.detailSeparator.setTextColor(textColor);
        this.image.setColorFilter(textColor);
        this.carouselContainer.setOnClickListener(new View.OnClickListener() {
            @Override
            public final void onClick(View view) {
                ArticleAttachmentCarouselViewHolder.bind$lambda$0(onAttachmentItemClicked, item, view);
            }
        });
        TextView textView2 = this.title;
        Context context2 = this.view.getContext();
        int i = R.string.zuia_guide_article_view_attachment_carousel_accessibility_value;
        String title = item.getTitle();
        String type = item.getType();
        long size2 = item.getSize();
        Context context3 = this.view.getContext();
        Intrinsics.checkNotNullExpressionValue(context3, "getContext(...)");
        textView2.setContentDescription(context2.getString(i, title, type, getFormattedFileSize(size2, context3)));
        String string = this.view.getContext().getString(R.string.zuia_guide_article_view_attachment_carousel_accessibility_label);
        Intrinsics.checkNotNullExpressionValue(string, "getString(...)");
        Context context4 = this.view.getContext();
        int i2 = R.string.zuia_guide_article_view_attachment_carousel_accessibility_value;
        String title2 = item.getTitle();
        String type2 = item.getType();
        long size3 = item.getSize();
        Context context5 = this.view.getContext();
        Intrinsics.checkNotNullExpressionValue(context5, "getContext(...)");
        String string2 = context4.getString(i2, title2, type2, getFormattedFileSize(size3, context5));
        Intrinsics.checkNotNullExpressionValue(string2, "getString(...)");
        String string3 = this.view.getContext().getString(R.string.zuia_guide_article_view_attachment_carousel_accessibility_action);
        Intrinsics.checkNotNullExpressionValue(string3, "getString(...)");
        this.view.setContentDescription(string + ". " + string2 + '.');
        AccessibilityExtKt.overrideAccessibilityNodeActionInfo(this.view, string3, 16);
    }

    public static final void bind$lambda$0(Function1 onAttachmentItemClicked, ArticleAttachmentItem item, View view) {
        Intrinsics.checkNotNullParameter(onAttachmentItemClicked, "$onAttachmentItemClicked");
        Intrinsics.checkNotNullParameter(item, "$item");
        onAttachmentItemClicked.invoke(item);
    }

    private final String getFormattedFileSize(long fileSize, Context context) {
        if (Build.VERSION.SDK_INT >= 26) {
            long j = 1000;
            long j2 = fileSize * j * j;
            long j3 = 1024;
            fileSize = (j2 / j3) / j3;
        }
        String fileSize2 = Formatter.formatFileSize(context, fileSize);
        Intrinsics.checkNotNullExpressionValue(fileSize2, "formatFileSize(...)");
        return fileSize2;
    }

    private final String setCharacterLimit(String fileType) {
        if (fileType.length() <= 4) {
            return fileType;
        }
        StringBuilder sb = new StringBuilder();
        String strSubstring = fileType.substring(0, 4);
        Intrinsics.checkNotNullExpressionValue(strSubstring, "substring(...)");
        sb.append(strSubstring);
        sb.append("...");
        return sb.toString();
    }

    private final void getTheArticleAttachmentCarouselBorderAlpha() {
        TypedValue typedValue = new TypedValue();
        this.view.getContext().getResources().getValue(R.dimen.zuia_article_attachment_border_alpha, typedValue, true);
        this.borderAlpha = typedValue.getFloat();
    }

    @Metadata(m17d1 = {"\u0000\u001e\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0016\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\b¨\u0006\t"}, m18d2 = {"Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentCarouselViewHolder$Companion;", "", "()V", "create", "Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentCarouselViewHolder;", "layoutInflater", "Landroid/view/LayoutInflater;", "parent", "Landroid/view/ViewGroup;", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final ArticleAttachmentCarouselViewHolder create(LayoutInflater layoutInflater, ViewGroup parent) {
            Intrinsics.checkNotNullParameter(layoutInflater, "layoutInflater");
            Intrinsics.checkNotNullParameter(parent, "parent");
            View viewInflate = layoutInflater.inflate(R.layout.zuia_view_attachment_item_article_cell, parent, false);
            Intrinsics.checkNotNull(viewInflate);
            return new ArticleAttachmentCarouselViewHolder(viewInflate);
        }
    }
}
