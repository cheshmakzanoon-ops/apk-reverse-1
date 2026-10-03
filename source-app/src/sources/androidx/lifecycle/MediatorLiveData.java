package androidx.lifecycle;

import androidx.arch.core.internal.SafeIterableMap;
import java.util.Iterator;
import java.util.Map;

public class MediatorLiveData<T> extends MutableLiveData<T> {
    private SafeIterableMap<LiveData<?>, Source<?>> mSources;

    public MediatorLiveData() {
        this.mSources = new SafeIterableMap<>();
    }

    public MediatorLiveData(T t) {
        super(t);
        this.mSources = new SafeIterableMap<>();
    }

    public <S> void addSource(LiveData<S> liveData, Observer<? super S> observer) {
        if (liveData == null) {
            throw new NullPointerException("source cannot be null");
        }
        Source source = new Source(liveData, observer);
        Source source2 = (Source) this.mSources.putIfAbsent(liveData, source);
        if (source2 != null && source2.mObserver != observer) {
            throw new IllegalArgumentException("This source was already added with the different observer");
        }
        if (source2 == null && hasActiveObservers()) {
            source.plug();
        }
    }

    public <S> void removeSource(LiveData<S> liveData) {
        Source source = (Source) this.mSources.remove(liveData);
        if (source != null) {
            source.unplug();
        }
    }

    @Override
    protected void onActive() {
        Iterator it = this.mSources.iterator();
        while (it.hasNext()) {
            ((Source) ((Map.Entry) it.next()).getValue()).plug();
        }
    }

    @Override
    protected void onInactive() {
        Iterator it = this.mSources.iterator();
        while (it.hasNext()) {
            ((Source) ((Map.Entry) it.next()).getValue()).unplug();
        }
    }

    private static class Source<V> implements Observer<V> {
        final LiveData<V> mLiveData;
        final Observer<? super V> mObserver;
        int mVersion = -1;

        Source(LiveData<V> liveData, Observer<? super V> observer) {
            this.mLiveData = liveData;
            this.mObserver = observer;
        }

        void plug() {
            this.mLiveData.observeForever(this);
        }

        void unplug() {
            this.mLiveData.removeObserver(this);
        }

        @Override
        public void onChanged(V v) {
            if (this.mVersion != this.mLiveData.getVersion()) {
                this.mVersion = this.mLiveData.getVersion();
                this.mObserver.onChanged(v);
            }
        }
    }
}
