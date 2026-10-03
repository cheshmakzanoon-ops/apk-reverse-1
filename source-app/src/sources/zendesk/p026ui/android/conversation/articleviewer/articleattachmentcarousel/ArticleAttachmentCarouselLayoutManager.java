package zendesk.p026ui.android.conversation.articleviewer.articleattachmentcarousel;

import android.content.Context;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.recyclerview.widget.RecyclerView.Adapter;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u00002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0003\b\u0000\u0018\u0000*\u0010\b\u0000\u0010\u0001*\n\u0012\u0006\b\u0001\u0012\u00020\u00030\u00022\u00020\u0004B\u0015\u0012\u0006\u0010\u0005\u001a\u00020\u0006\u0012\u0006\u0010\u0007\u001a\u00028\u0000¢\u0006\u0002\u0010\bJ\b\u0010\u000e\u001a\u00020\rH\u0016J\u0010\u0010\u000f\u001a\u00020\r2\u0006\u0010\u0010\u001a\u00020\u0011H\u0016J\u0015\u0010\u0012\u001a\u00020\u00132\u0006\u0010\u0014\u001a\u00020\rH\u0000¢\u0006\u0002\b\u0015R\u0013\u0010\u0007\u001a\u00028\u0000¢\u0006\n\n\u0002\u0010\u000b\u001a\u0004\b\t\u0010\nR\u000e\u0010\f\u001a\u00020\rX\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0016"}, m18d2 = {"Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentCarouselLayoutManager;", "T", "Landroidx/recyclerview/widget/RecyclerView$Adapter;", "Landroidx/recyclerview/widget/RecyclerView$ViewHolder;", "Landroidx/recyclerview/widget/LinearLayoutManager;", "context", "Landroid/content/Context;", "adapter", "(Landroid/content/Context;Landroidx/recyclerview/widget/RecyclerView$Adapter;)V", "getAdapter", "()Landroidx/recyclerview/widget/RecyclerView$Adapter;", "Landroidx/recyclerview/widget/RecyclerView$Adapter;", "isScrollEnabled", "", "canScrollHorizontally", "checkLayoutParams", "lp", "Landroidx/recyclerview/widget/RecyclerView$LayoutParams;", "setScroll", "", "scrollEnabled", "setScroll$zendesk_ui_ui_android", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ArticleAttachmentCarouselLayoutManager<T extends RecyclerView.Adapter<? extends RecyclerView.ViewHolder>> extends LinearLayoutManager {
    public static final int $stable = 8;
    private final T adapter;
    private boolean isScrollEnabled;

    public final T getAdapter() {
        return this.adapter;
    }

    public ArticleAttachmentCarouselLayoutManager(Context context, T adapter) {
        super(context, 0, false);
        Intrinsics.checkNotNullParameter(context, "context");
        Intrinsics.checkNotNullParameter(adapter, "adapter");
        this.adapter = adapter;
        this.isScrollEnabled = true;
    }

    public boolean checkLayoutParams(RecyclerView.LayoutParams lp) {
        Intrinsics.checkNotNullParameter(lp, "lp");
        lp.width = -2;
        return true;
    }

    public boolean getIsScrollEnabled() {
        return this.isScrollEnabled;
    }

    public final void setScroll$zendesk_ui_ui_android(boolean scrollEnabled) {
        this.isScrollEnabled = scrollEnabled;
    }
}
