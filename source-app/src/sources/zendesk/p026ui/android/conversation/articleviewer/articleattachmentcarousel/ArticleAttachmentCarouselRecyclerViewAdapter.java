package zendesk.p026ui.android.conversation.articleviewer.articleattachmentcarousel;

import android.view.LayoutInflater;
import android.view.ViewGroup;
import androidx.recyclerview.widget.RecyclerView;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u00008\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0000\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0003J\b\u0010\u000b\u001a\u00020\fH\u0016J\u0018\u0010\r\u001a\u00020\u00072\u0006\u0010\u000e\u001a\u00020\u00022\u0006\u0010\u000f\u001a\u00020\fH\u0016J\u0018\u0010\u0010\u001a\u00020\u00022\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\fH\u0016J\"\u0010\u0014\u001a\u00020\u00072\u001a\u0010\u0004\u001a\u0016\u0012\u0004\u0012\u00020\u0006\u0012\u0004\u0012\u00020\u0007\u0018\u00010\u0005j\u0004\u0018\u0001`\bJ\u000e\u0010\u0015\u001a\u00020\u00072\u0006\u0010\t\u001a\u00020\nR\"\u0010\u0004\u001a\u0016\u0012\u0004\u0012\u00020\u0006\u0012\u0004\u0012\u00020\u0007\u0018\u00010\u0005j\u0004\u0018\u0001`\bX\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\t\u001a\u00020\nX\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0016"}, m18d2 = {"Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentCarouselRecyclerViewAdapter;", "Landroidx/recyclerview/widget/RecyclerView$Adapter;", "Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentCarouselViewHolder;", "()V", "onAttachmentItemClicked", "Lkotlin/Function1;", "Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentItem;", "", "Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/OnAttachmentItemClicked;", "state", "Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentCarouselCellState;", "getItemCount", "", "onBindViewHolder", "holder", "position", "onCreateViewHolder", "parent", "Landroid/view/ViewGroup;", "viewType", "setOnAttachmentItemClicked", "swapData", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ArticleAttachmentCarouselRecyclerViewAdapter extends RecyclerView.Adapter<ArticleAttachmentCarouselViewHolder> {
    public static final int $stable = 8;
    private Function1<? super ArticleAttachmentItem, Unit> onAttachmentItemClicked;
    private ArticleAttachmentCarouselCellState state = new ArticleAttachmentCarouselCellState(null, 0, 0, 0, 15, null);

    public ArticleAttachmentCarouselViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        Intrinsics.checkNotNullParameter(parent, "parent");
        ArticleAttachmentCarouselViewHolder.Companion companion = ArticleAttachmentCarouselViewHolder.INSTANCE;
        LayoutInflater layoutInflaterFrom = LayoutInflater.from(parent.getContext());
        Intrinsics.checkNotNullExpressionValue(layoutInflaterFrom, "from(...)");
        return companion.create(layoutInflaterFrom, parent);
    }

    public int getItemCount() {
        return this.state.getAttachmentListData().size();
    }

    public void onBindViewHolder(ArticleAttachmentCarouselViewHolder holder, int position) {
        Intrinsics.checkNotNullParameter(holder, "holder");
        holder.bind(this.state.getAttachmentListData().get(position), this.state.getTextColor(), new Function1<ArticleAttachmentItem, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(ArticleAttachmentItem articleAttachmentItem) {
                invoke2(articleAttachmentItem);
                return Unit.INSTANCE;
            }

            public final void invoke2(ArticleAttachmentItem it) {
                Intrinsics.checkNotNullParameter(it, "it");
                Function1 function1 = ArticleAttachmentCarouselRecyclerViewAdapter.this.onAttachmentItemClicked;
                if (function1 != null) {
                    function1.invoke(it);
                }
            }
        });
    }

    public final void setOnAttachmentItemClicked(Function1<? super ArticleAttachmentItem, Unit> onAttachmentItemClicked) {
        this.onAttachmentItemClicked = onAttachmentItemClicked;
    }

    public final void swapData(ArticleAttachmentCarouselCellState state) {
        Intrinsics.checkNotNullParameter(state, "state");
        this.state = state;
        notifyDataSetChanged();
    }
}
