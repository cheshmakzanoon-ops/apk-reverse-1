package net.aihelp.core.p004ui.glide;

import android.widget.AbsListView;
import java.util.List;
import java.util.Queue;
import net.aihelp.core.p004ui.glide.request.animation.GlideAnimation;
import net.aihelp.core.p004ui.glide.request.target.BaseTarget;
import net.aihelp.core.p004ui.glide.request.target.SizeReadyCallback;
import net.aihelp.core.p004ui.glide.util.Util;

public class ListPreloader<T> implements AbsListView.OnScrollListener {
    private boolean isIncreasing;
    private int lastEnd;
    private int lastFirstVisible;
    private int lastStart;
    private final int maxPreload;
    private final PreloadSizeProvider<T> preloadDimensionProvider;
    private final PreloadModelProvider<T> preloadModelProvider;
    private final PreloadTargetQueue preloadTargetQueue;
    private int totalItemCount;

    public interface PreloadModelProvider<U> {
        List<U> getPreloadItems(int i);

        GenericRequestBuilder getPreloadRequestBuilder(U u);
    }

    public interface PreloadSizeProvider<T> {
        int[] getPreloadSize(T t, int i, int i2);
    }

    @Override
    public void onScrollStateChanged(AbsListView absListView, int i) {
    }

    @Deprecated
    public ListPreloader(int i) {
        this.isIncreasing = true;
        this.preloadModelProvider = new PreloadModelProvider<T>() {
            @Override
            public List<T> getPreloadItems(int i2) {
                return ListPreloader.this.getItems(i2, i2 + 1);
            }

            @Override
            public GenericRequestBuilder getPreloadRequestBuilder(T t) {
                return ListPreloader.this.getRequestBuilder(t);
            }
        };
        this.preloadDimensionProvider = new PreloadSizeProvider<T>() {
            @Override
            public int[] getPreloadSize(T t, int i2, int i3) {
                return ListPreloader.this.getDimensions(t);
            }
        };
        this.maxPreload = i;
        this.preloadTargetQueue = new PreloadTargetQueue(i + 1);
    }

    public ListPreloader(PreloadModelProvider<T> preloadModelProvider, PreloadSizeProvider<T> preloadSizeProvider, int i) {
        this.isIncreasing = true;
        this.preloadModelProvider = preloadModelProvider;
        this.preloadDimensionProvider = preloadSizeProvider;
        this.maxPreload = i;
        this.preloadTargetQueue = new PreloadTargetQueue(i + 1);
    }

    @Override
    public void onScroll(AbsListView absListView, int i, int i2, int i3) {
        this.totalItemCount = i3;
        int i4 = this.lastFirstVisible;
        if (i > i4) {
            preload(i2 + i, true);
        } else if (i < i4) {
            preload(i, false);
        }
        this.lastFirstVisible = i;
    }

    @Deprecated
    protected int[] getDimensions(T t) {
        throw new IllegalStateException("You must either provide a PreloadDimensionProvider or override getDimensions()");
    }

    @Deprecated
    protected List<T> getItems(int i, int i2) {
        throw new IllegalStateException("You must either provide a PreloadModelProvider or override getItems()");
    }

    @Deprecated
    protected GenericRequestBuilder getRequestBuilder(T t) {
        throw new IllegalStateException("You must either provide a PreloadModelProvider, or override getRequestBuilder()");
    }

    private void preload(int i, boolean z) {
        if (this.isIncreasing != z) {
            this.isIncreasing = z;
            cancelAll();
        }
        preload(i, (z ? this.maxPreload : -this.maxPreload) + i);
    }

    private void preload(int i, int i2) {
        int iMin;
        int iMax;
        if (i < i2) {
            iMax = Math.max(this.lastEnd, i);
            iMin = i2;
        } else {
            iMin = Math.min(this.lastStart, i);
            iMax = i2;
        }
        int iMin2 = Math.min(this.totalItemCount, iMin);
        int iMin3 = Math.min(this.totalItemCount, Math.max(0, iMax));
        if (i < i2) {
            for (int i3 = iMin3; i3 < iMin2; i3++) {
                preloadAdapterPosition(this.preloadModelProvider.getPreloadItems(i3), i3, true);
            }
        } else {
            for (int i4 = iMin2 - 1; i4 >= iMin3; i4--) {
                preloadAdapterPosition(this.preloadModelProvider.getPreloadItems(i4), i4, false);
            }
        }
        this.lastStart = iMin3;
        this.lastEnd = iMin2;
    }

    private void preloadAdapterPosition(List<T> list, int i, boolean z) {
        int size = list.size();
        if (z) {
            for (int i2 = 0; i2 < size; i2++) {
                preloadItem(list.get(i2), i, i2);
            }
            return;
        }
        for (int i3 = size - 1; i3 >= 0; i3--) {
            preloadItem(list.get(i3), i, i3);
        }
    }

    private void preloadItem(T t, int i, int i2) {
        int[] preloadSize = this.preloadDimensionProvider.getPreloadSize(t, i, i2);
        if (preloadSize != null) {
            this.preloadModelProvider.getPreloadRequestBuilder(t).into(this.preloadTargetQueue.next(preloadSize[0], preloadSize[1]));
        }
    }

    private void cancelAll() {
        for (int i = 0; i < this.maxPreload; i++) {
            Glide.clear(this.preloadTargetQueue.next(0, 0));
        }
    }

    private static final class PreloadTargetQueue {
        private final Queue<PreloadTarget> queue;

        public PreloadTargetQueue(int i) {
            this.queue = Util.createQueue(i);
            for (int i2 = 0; i2 < i; i2++) {
                this.queue.offer(new PreloadTarget());
            }
        }

        public PreloadTarget next(int i, int i2) {
            PreloadTarget preloadTargetPoll = this.queue.poll();
            this.queue.offer(preloadTargetPoll);
            preloadTargetPoll.photoWidth = i;
            preloadTargetPoll.photoHeight = i2;
            return preloadTargetPoll;
        }
    }

    private static class PreloadTarget extends BaseTarget<Object> {
        private int photoHeight;
        private int photoWidth;

        @Override
        public void onResourceReady(Object obj, GlideAnimation<? super Object> glideAnimation) {
        }

        private PreloadTarget() {
        }

        @Override
        public void getSize(SizeReadyCallback sizeReadyCallback) {
            sizeReadyCallback.onSizeReady(this.photoWidth, this.photoHeight);
        }
    }
}
