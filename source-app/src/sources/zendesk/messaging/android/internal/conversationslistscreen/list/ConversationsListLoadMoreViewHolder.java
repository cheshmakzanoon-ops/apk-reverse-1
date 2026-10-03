package zendesk.messaging.android.internal.conversationslistscreen.list;

import android.view.View;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;
import zendesk.core.p017ui.android.internal.model.ConversationEntry;
import zendesk.ui.android.common.loadmore.LoadMoreRendering;
import zendesk.ui.android.common.loadmore.LoadMoreState;
import zendesk.ui.android.common.loadmore.LoadMoreView;

@Metadata(m17d1 = {"\u0000 \n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\u0006\b\u0000\u0018\u00002\u00020\u0001B%\b\u0000\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0014\u0010\u0004\u001a\u0010\u0012\u0004\u0012\u00020\u0006\u0012\u0004\u0012\u00020\u0007\u0018\u00010\u0005¢\u0006\u0002\u0010\bJ\u000e\u0010\u000b\u001a\u00020\u00072\u0006\u0010\f\u001a\u00020\u0006R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u001f\u0010\u0004\u001a\u0010\u0012\u0004\u0012\u00020\u0006\u0012\u0004\u0012\u00020\u0007\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\n¨\u0006\r"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/list/ConversationsListLoadMoreViewHolder;", "Lzendesk/messaging/android/internal/conversationslistscreen/list/ConversationsListViewHolder;", "loadMoreView", "Lzendesk/ui/android/common/loadmore/LoadMoreView;", "onRetryClicked", "Lkotlin/Function1;", "Lzendesk/core/ui/android/internal/model/ConversationEntry$LoadMore;", "", "(Lzendesk/ui/android/common/loadmore/LoadMoreView;Lkotlin/jvm/functions/Function1;)V", "getOnRetryClicked", "()Lkotlin/jvm/functions/Function1;", "onBind", "loadMoreEntry", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationsListLoadMoreViewHolder extends ConversationsListViewHolder {
    private final LoadMoreView loadMoreView;
    private final Function1<ConversationEntry.LoadMore, Unit> onRetryClicked;

    public final Function1<ConversationEntry.LoadMore, Unit> getOnRetryClicked() {
        return this.onRetryClicked;
    }

    public ConversationsListLoadMoreViewHolder(LoadMoreView loadMoreView, Function1<? super ConversationEntry.LoadMore, Unit> function1) {
        super((View) loadMoreView);
        Intrinsics.checkNotNullParameter(loadMoreView, "loadMoreView");
        this.loadMoreView = loadMoreView;
        this.onRetryClicked = function1;
    }

    public final void onBind(final ConversationEntry.LoadMore loadMoreEntry) {
        Intrinsics.checkNotNullParameter(loadMoreEntry, "loadMoreEntry");
        this.loadMoreView.render(new Function1<LoadMoreRendering, LoadMoreRendering>() {
            {
                super(1);
            }

            @Override
            public final LoadMoreRendering invoke(LoadMoreRendering loadMoreRendering) {
                Intrinsics.checkNotNullParameter(loadMoreRendering, "loadMoreRendering");
                LoadMoreRendering.Builder builder = loadMoreRendering.toBuilder();
                final ConversationsListLoadMoreViewHolder conversationsListLoadMoreViewHolder = ConversationsListLoadMoreViewHolder.this;
                final ConversationEntry.LoadMore loadMore = loadMoreEntry;
                LoadMoreRendering.Builder builderOnRetryClicked = builder.onRetryClicked(new Function0<Unit>() {
                    {
                        super(0);
                    }

                    @Override
                    public Unit invoke() {
                        invoke2();
                        return Unit.INSTANCE;
                    }

                    public final void invoke2() {
                        Function1<ConversationEntry.LoadMore, Unit> onRetryClicked = conversationsListLoadMoreViewHolder.getOnRetryClicked();
                        if (onRetryClicked != null) {
                            onRetryClicked.invoke(loadMore);
                        }
                    }
                });
                final ConversationEntry.LoadMore loadMore2 = loadMoreEntry;
                return builderOnRetryClicked.state(new Function1<LoadMoreState, LoadMoreState>() {

                    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
                    public class WhenMappings {
                        public static final int[] $EnumSwitchMapping$0;

                        static {
                            int[] iArr = new int[ConversationEntry.LoadMoreStatus.values().length];
                            try {
                                iArr[ConversationEntry.LoadMoreStatus.LOADING.ordinal()] = 1;
                            } catch (NoSuchFieldError unused) {
                            }
                            try {
                                iArr[ConversationEntry.LoadMoreStatus.FAILED.ordinal()] = 2;
                            } catch (NoSuchFieldError unused2) {
                            }
                            try {
                                iArr[ConversationEntry.LoadMoreStatus.NONE.ordinal()] = 3;
                            } catch (NoSuchFieldError unused3) {
                            }
                            $EnumSwitchMapping$0 = iArr;
                        }
                    }

                    {
                        super(1);
                    }

                    @Override
                    public final LoadMoreState invoke(LoadMoreState state) {
                        LoadMoreState.LoadMoreStatus loadMoreStatus;
                        Intrinsics.checkNotNullParameter(state, "state");
                        String retryText = loadMore2.getRetryText();
                        int failedRetryTextColor = loadMore2.getFailedRetryTextColor();
                        int progressBarColor = loadMore2.getProgressBarColor();
                        int i = WhenMappings.$EnumSwitchMapping$0[loadMore2.getStatus().ordinal()];
                        if (i == 1) {
                            loadMoreStatus = LoadMoreState.LoadMoreStatus.LOADING;
                        } else if (i == 2) {
                            loadMoreStatus = LoadMoreState.LoadMoreStatus.FAILED;
                        } else {
                            if (i != 3) {
                                throw new NoWhenBranchMatchedException();
                            }
                            loadMoreStatus = LoadMoreState.LoadMoreStatus.NONE;
                        }
                        return state.copy(retryText, progressBarColor, failedRetryTextColor, loadMoreStatus);
                    }
                }).build();
            }
        });
    }
}
