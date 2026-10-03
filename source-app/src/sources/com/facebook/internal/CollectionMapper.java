package com.facebook.internal;

import com.facebook.FacebookException;
import java.util.Iterator;
import java.util.LinkedList;

public class CollectionMapper {

    public interface Collection<T> {
        Object get(T key);

        Iterator<T> keyIterator();

        void set(T key, Object value, OnErrorListener onErrorListener);
    }

    public interface OnErrorListener {
        void onError(FacebookException exception);
    }

    public interface OnMapValueCompleteListener extends OnErrorListener {
        void onComplete(Object mappedValue);
    }

    public interface OnMapperCompleteListener extends OnErrorListener {
        void onComplete();
    }

    public interface ValueMapper {
        void mapValue(Object value, OnMapValueCompleteListener onMapValueCompleteListener);
    }

    public static <T> void iterate(final Collection<T> collection, ValueMapper valueMapper, final OnMapperCompleteListener onMapperCompleteListener) {
        final Mutable mutable = new Mutable(false);
        final Mutable mutable2 = new Mutable(1);
        final OnMapperCompleteListener onMapperCompleteListener2 = new OnMapperCompleteListener() {
            @Override
            public void onComplete() {
                if (((Boolean) mutable.value).booleanValue()) {
                    return;
                }
                Mutable mutable3 = mutable2;
                int iIntValue = ((Integer) mutable3.value).intValue() - 1;
                ?? ValueOf = Integer.valueOf(iIntValue);
                mutable3.value = ValueOf;
                ValueOf.getClass();
                if (iIntValue == 0) {
                    onMapperCompleteListener.onComplete();
                }
            }

            @Override
            public void onError(FacebookException exception) {
                if (((Boolean) mutable.value).booleanValue()) {
                    return;
                }
                mutable.value = true;
                onMapperCompleteListener.onError(exception);
            }
        };
        Iterator itKeyIterator = collection.keyIterator();
        LinkedList linkedList = new LinkedList();
        while (itKeyIterator.hasNext()) {
            linkedList.add(itKeyIterator.next());
        }
        for (final Object obj : linkedList) {
            Object obj2 = collection.get(obj);
            OnMapValueCompleteListener onMapValueCompleteListener = new OnMapValueCompleteListener() {
                @Override
                public void onComplete(Object mappedValue) {
                    collection.set(obj, mappedValue, onMapperCompleteListener2);
                    onMapperCompleteListener2.onComplete();
                }

                @Override
                public void onError(FacebookException exception) {
                    onMapperCompleteListener2.onError(exception);
                }
            };
            mutable2.value = (T) Integer.valueOf(((Integer) mutable2.value).intValue() + 1);
            valueMapper.mapValue(obj2, onMapValueCompleteListener);
        }
        onMapperCompleteListener2.onComplete();
    }

    private CollectionMapper() {
    }
}
