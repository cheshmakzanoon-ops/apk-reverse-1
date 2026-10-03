package zendesk.p026ui.android.conversation.articleviewer.articleattachmentcarousel;

import android.content.Context;
import android.graphics.Rect;
import android.view.View;
import androidx.recyclerview.widget.RecyclerView;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.ui.android.R;

@Metadata(m17d1 = {"\u0000@\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0000\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J(\u0010\u000b\u001a\u00020\f2\u0006\u0010\r\u001a\u00020\u000e2\u0006\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0014H\u0016J\r\u0010\u0015\u001a\u00020\fH\u0000¢\u0006\u0002\b\u0016R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0006X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0007\u001a\u00020\bX\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\t\u001a\u00020\u0006X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\n\u001a\u00020\u0006X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0017"}, m18d2 = {"Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentCarouselItemDecoration;", "Landroidx/recyclerview/widget/RecyclerView$ItemDecoration;", "context", "Landroid/content/Context;", "(Landroid/content/Context;)V", "endMargin", "", "isDefaultLayoutDirection", "", "middleMargin", "startMargin", "getItemOffsets", "", "outRect", "Landroid/graphics/Rect;", "view", "Landroid/view/View;", "parent", "Landroidx/recyclerview/widget/RecyclerView;", "state", "Landroidx/recyclerview/widget/RecyclerView$State;", "setLayoutDirectionToRTL", "setLayoutDirectionToRTL$zendesk_ui_ui_android", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ArticleAttachmentCarouselItemDecoration extends RecyclerView.ItemDecoration {
    public static final int $stable = 8;
    private final Context context;
    private int endMargin;
    private boolean isDefaultLayoutDirection;
    private int middleMargin;
    private int startMargin;

    public ArticleAttachmentCarouselItemDecoration(Context context) {
        Intrinsics.checkNotNullParameter(context, "context");
        this.context = context;
        this.middleMargin = context.getResources().getDimensionPixelSize(R.dimen.zuia_attachment_item_margin);
        this.startMargin = context.getResources().getDimensionPixelSize(R.dimen.zuia_carousel_button_margin);
        this.endMargin = context.getResources().getDimensionPixelSize(R.dimen.zuia_carousel_button_margin);
        this.isDefaultLayoutDirection = true;
    }

    public void getItemOffsets(Rect outRect, View view, RecyclerView parent, RecyclerView.State state) {
        Intrinsics.checkNotNullParameter(outRect, "outRect");
        Intrinsics.checkNotNullParameter(view, "view");
        Intrinsics.checkNotNullParameter(parent, "parent");
        Intrinsics.checkNotNullParameter(state, "state");
        RecyclerView.Adapter adapter = parent.getAdapter();
        if (adapter == null) {
            return;
        }
        outRect.left = this.middleMargin;
        if (parent.getChildAdapterPosition(view) == 0) {
            if (this.isDefaultLayoutDirection) {
                outRect.left = this.startMargin;
            } else {
                outRect.right = this.endMargin;
            }
        }
        if (parent.getChildAdapterPosition(view) == adapter.getItemCount() - 1) {
            if (this.isDefaultLayoutDirection) {
                outRect.right = this.endMargin;
            } else {
                outRect.left = this.startMargin;
            }
        }
    }

    public final void setLayoutDirectionToRTL$zendesk_ui_ui_android() {
        this.isDefaultLayoutDirection = false;
    }
}
