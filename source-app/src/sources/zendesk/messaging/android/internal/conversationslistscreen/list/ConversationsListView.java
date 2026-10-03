package zendesk.messaging.android.internal.conversationslistscreen.list;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.FrameLayout;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import java.util.concurrent.atomic.AtomicInteger;
import kotlin.Lazy;
import kotlin.LazyKt;
import kotlin.Metadata;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.messaging.C1256R;
import zendesk.ui.android.Renderer;

@Metadata(m17d1 = {"\u0000P\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0000\u0018\u0000 !2\u00020\u00012\b\u0012\u0004\u0012\u00020\u00030\u0002:\u0001!B/\b\u0007\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t\u0012\b\b\u0002\u0010\n\u001a\u00020\t¢\u0006\u0002\u0010\u000bJ\u001c\u0010\u001d\u001a\u00020\u001e2\u0012\u0010\u001f\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00030 H\u0016R\u000e\u0010\f\u001a\u00020\rX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000e\u001a\u00020\u000fX\u0082\u0004¢\u0006\u0002\n\u0000R\u001b\u0010\u0010\u001a\u00020\u00118BX\u0082\u0084\u0002¢\u0006\f\n\u0004\b\u0014\u0010\u0015\u001a\u0004\b\u0012\u0010\u0013R\u000e\u0010\u0016\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000R\u001a\u0010\u0017\u001a\u00020\u0018X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0019\u0010\u001a\"\u0004\b\u001b\u0010\u001c¨\u0006\""}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/list/ConversationsListView;", "Landroid/widget/FrameLayout;", "Lzendesk/ui/android/Renderer;", "Lzendesk/messaging/android/internal/conversationslistscreen/list/ConversationsListViewRendering;", "context", "Landroid/content/Context;", "attrs", "Landroid/util/AttributeSet;", "defStyleAttrs", "", "defStyleRes", "(Landroid/content/Context;Landroid/util/AttributeSet;II)V", "conversationsListAdapter", "Lzendesk/messaging/android/internal/conversationslistscreen/list/ConversationsListAdapter;", "layoutManager", "Landroidx/recyclerview/widget/LinearLayoutManager;", "recyclerView", "Landroidx/recyclerview/widget/RecyclerView;", "getRecyclerView", "()Landroidx/recyclerview/widget/RecyclerView;", "recyclerView$delegate", "Lkotlin/Lazy;", "rendering", "state", "Ljava/util/concurrent/atomic/AtomicInteger;", "getState", "()Ljava/util/concurrent/atomic/AtomicInteger;", "setState", "(Ljava/util/concurrent/atomic/AtomicInteger;)V", "render", "", "renderingUpdate", "Lkotlin/Function1;", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationsListView extends FrameLayout implements Renderer<ConversationsListViewRendering> {
    private static final int FIRST_POSITION = 0;
    private final ConversationsListAdapter conversationsListAdapter;
    private final LinearLayoutManager layoutManager;

    private final Lazy recyclerView;
    private ConversationsListViewRendering rendering;
    private AtomicInteger state;

    public ConversationsListView(Context context) {
        this(context, null, 0, 0, 14, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ConversationsListView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0, 0, 12, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ConversationsListView(Context context, AttributeSet attributeSet, int i) {
        this(context, attributeSet, i, 0, 8, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ConversationsListView(Context context, AttributeSet attributeSet, int i, int i2, int i3, DefaultConstructorMarker defaultConstructorMarker) {
        this(context, (i3 & 2) != 0 ? null : attributeSet, (i3 & 4) != 0 ? 0 : i, (i3 & 8) != 0 ? 0 : i2);
    }

    public ConversationsListView(Context context, AttributeSet attributeSet, int i, int i2) {
        super(context, attributeSet, i, i2);
        Intrinsics.checkNotNullParameter(context, "context");
        this.recyclerView = LazyKt.lazy(new Function0<RecyclerView>() {
            {
                super(0);
            }

            @Override
            public final RecyclerView invoke() {
                return this.this$0.findViewById(C1256R.id.zma_conversations_list_screen_recycler_view);
            }
        });
        RecyclerView.Adapter conversationsListAdapter = new ConversationsListAdapter();
        this.conversationsListAdapter = conversationsListAdapter;
        RecyclerView.LayoutManager linearLayoutManager = new LinearLayoutManager(context, 1, false);
        this.layoutManager = linearLayoutManager;
        this.rendering = new ConversationsListViewRendering();
        this.state = new AtomicInteger(0);
        FrameLayout.inflate(context, C1256R.layout.zma_view_conversations_list, this);
        getRecyclerView().setAdapter(conversationsListAdapter);
        getRecyclerView().setLayoutManager(linearLayoutManager);
        getRecyclerView().addOnScrollListener(new RecyclerView.OnScrollListener() {
            public void onScrollStateChanged(RecyclerView recyclerView, int newState) {
                Intrinsics.checkNotNullParameter(recyclerView, "recyclerView");
                ConversationsListView.this.getState().compareAndSet(0, newState);
                if (newState == 0) {
                    if (ConversationsListView.this.getState().compareAndSet(2, newState)) {
                        return;
                    }
                    ConversationsListView.this.getState().compareAndSet(1, newState);
                } else if (newState == 1) {
                    ConversationsListView.this.getState().compareAndSet(0, newState);
                } else {
                    if (newState != 2) {
                        return;
                    }
                    ConversationsListView.this.getState().compareAndSet(1, newState);
                }
            }

            public void onScrolled(RecyclerView recyclerView, int dx, int dy) {
                Intrinsics.checkNotNullParameter(recyclerView, "recyclerView");
                if (ConversationsListView.this.layoutManager.findLastCompletelyVisibleItemPosition() == ConversationsListView.this.rendering.getState().getConversations$zendesk_messaging_messaging_android().size() - 1) {
                    ConversationsListView.this.rendering.getOnLoadMoreListener$zendesk_messaging_messaging_android().invoke();
                }
            }
        });
        render(new Function1<ConversationsListViewRendering, ConversationsListViewRendering>() {
            @Override
            public final ConversationsListViewRendering invoke(ConversationsListViewRendering it) {
                Intrinsics.checkNotNullParameter(it, "it");
                return it;
            }
        });
    }

    private final RecyclerView getRecyclerView() {
        Object value = this.recyclerView.getValue();
        Intrinsics.checkNotNullExpressionValue(value, "getValue(...)");
        return (RecyclerView) value;
    }

    public final AtomicInteger getState() {
        return this.state;
    }

    public final void setState(AtomicInteger atomicInteger) {
        Intrinsics.checkNotNullParameter(atomicInteger, "<set-?>");
        this.state = atomicInteger;
    }

    public void render(Function1<? super ConversationsListViewRendering, ConversationsListViewRendering> renderingUpdate) {
        Intrinsics.checkNotNullParameter(renderingUpdate, "renderingUpdate");
        ConversationsListViewRendering conversationsListViewRenderingInvoke = renderingUpdate.invoke(this.rendering);
        this.rendering = conversationsListViewRenderingInvoke;
        this.conversationsListAdapter.submitList(conversationsListViewRenderingInvoke.getState().getConversations$zendesk_messaging_messaging_android(), new Runnable() {
            @Override
            public final void run() {
                ConversationsListView.render$lambda$0(this.f$0);
            }
        });
        this.conversationsListAdapter.setOnListItemClickListener(this.rendering.getOnListItemClickLambda$zendesk_messaging_messaging_android());
        this.conversationsListAdapter.setOnRetryClickListener(this.rendering.getOnRetryClickLambda$zendesk_messaging_messaging_android());
    }

    public static final void render$lambda$0(ConversationsListView this$0) {
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        LinearLayoutManager layoutManager = this$0.getRecyclerView().getLayoutManager();
        LinearLayoutManager linearLayoutManager = layoutManager instanceof LinearLayoutManager ? layoutManager : null;
        if (linearLayoutManager == null || linearLayoutManager.findFirstCompletelyVisibleItemPosition() != 0) {
            return;
        }
        this$0.getRecyclerView().smoothScrollToPosition(0);
    }
}
