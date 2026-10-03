package com.google.android.gms.common.api;

import android.os.Bundle;
import com.google.android.gms.common.api.Result;
import com.google.android.gms.common.data.AbstractDataBuffer;
import com.google.android.gms.common.data.DataBuffer;
import java.util.Iterator;

public class DataBufferResponse<T, R extends AbstractDataBuffer<T> & Result> extends Response<R> implements DataBuffer<T> {
    public DataBufferResponse() {
    }

    @Override
    public final void close() {
        ((AbstractDataBuffer) getResult()).close();
    }

    @Override
    public final T get(int i) {
        return (T) ((AbstractDataBuffer) getResult()).get(i);
    }

    @Override
    public final int getCount() {
        return ((AbstractDataBuffer) getResult()).getCount();
    }

    @Override
    public final Bundle getMetadata() {
        return ((AbstractDataBuffer) getResult()).getMetadata();
    }

    @Override
    public final boolean isClosed() {
        return ((AbstractDataBuffer) getResult()).isClosed();
    }

    @Override
    public final Iterator<T> iterator() {
        return ((AbstractDataBuffer) getResult()).iterator();
    }

    @Override
    public final void release() {
        ((AbstractDataBuffer) getResult()).release();
    }

    @Override
    public final Iterator<T> singleRefIterator() {
        return ((AbstractDataBuffer) getResult()).singleRefIterator();
    }

    public DataBufferResponse(AbstractDataBuffer abstractDataBuffer) {
        super(abstractDataBuffer);
    }
}
