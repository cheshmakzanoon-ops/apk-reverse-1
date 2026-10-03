package com.google.common.reflect;

import com.google.common.base.Function;
import com.google.common.base.Preconditions;
import com.google.common.collect.ForwardingMap;
import com.google.common.collect.ForwardingMapEntry;
import com.google.common.collect.ForwardingSet;
import com.google.common.collect.Iterators;
import com.google.common.collect.Maps;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import javax.annotation.CheckForNull;

@ElementTypesAreNonnullByDefault
public final class MutableTypeToInstanceMap<B> extends ForwardingMap<TypeToken<? extends B>, B> implements TypeToInstanceMap<B> {
    private final Map<TypeToken<? extends B>, B> backingMap = Maps.newHashMap();

    @Override
    @CheckForNull
    public <T extends B> T getInstance(Class<T> cls) {
        return (T) trustedGet(TypeToken.m313of((Class) cls));
    }

    @Override
    @CheckForNull
    public <T extends B> T getInstance(TypeToken<T> typeToken) {
        return (T) trustedGet(typeToken.rejectTypeVariables());
    }

    @Override
    @CheckForNull
    public <T extends B> T putInstance(Class<T> cls, T t) {
        return (T) trustedPut(TypeToken.m313of((Class) cls), t);
    }

    @Override
    @CheckForNull
    public <T extends B> T putInstance(TypeToken<T> typeToken, T t) {
        return (T) trustedPut(typeToken.rejectTypeVariables(), t);
    }

    @Override
    @CheckForNull
    @Deprecated
    public B put(TypeToken<? extends B> typeToken, B b) {
        throw new UnsupportedOperationException("Please use putInstance() instead.");
    }

    @Override
    @Deprecated
    public void putAll(Map<? extends TypeToken<? extends B>, ? extends B> map) {
        throw new UnsupportedOperationException("Please use putInstance() instead.");
    }

    @Override
    public Set<Map.Entry<TypeToken<? extends B>, B>> entrySet() {
        return UnmodifiableEntry.transformEntries(super.entrySet());
    }

    @Override
    public Map<TypeToken<? extends B>, B> delegate() {
        return this.backingMap;
    }

    @CheckForNull
    private <T extends B> T trustedPut(TypeToken<T> typeToken, T t) {
        return this.backingMap.put(typeToken, t);
    }

    @CheckForNull
    private <T extends B> T trustedGet(TypeToken<T> typeToken) {
        return this.backingMap.get(typeToken);
    }

    static final class UnmodifiableEntry<K, V> extends ForwardingMapEntry<K, V> {
        private final Map.Entry<K, V> delegate;

        public static UnmodifiableEntry m767$r8$lambda$PXRRP_NYxQ7IKAyO13H8YX2pq0(Map.Entry entry) {
            return new UnmodifiableEntry(entry);
        }

        static <K, V> Set<Map.Entry<K, V>> transformEntries(final Set<Map.Entry<K, V>> set) {
            return new ForwardingSet<Map.Entry<K, V>>() {
                @Override
                public Set<Map.Entry<K, V>> delegate() {
                    return set;
                }

                @Override
                public Iterator<Map.Entry<K, V>> iterator() {
                    return UnmodifiableEntry.transformEntries(super.iterator());
                }

                @Override
                public Object[] toArray() {
                    return standardToArray();
                }

                @Override
                public <T> T[] toArray(T[] tArr) {
                    return (T[]) standardToArray(tArr);
                }
            };
        }

        public static <K, V> Iterator<Map.Entry<K, V>> transformEntries(Iterator<Map.Entry<K, V>> it) {
            return Iterators.transform(it, new Function() {
                @Override
                public final Object apply(Object obj) {
                    return MutableTypeToInstanceMap.UnmodifiableEntry.m767$r8$lambda$PXRRP_NYxQ7IKAyO13H8YX2pq0((Map.Entry) obj);
                }
            });
        }

        private UnmodifiableEntry(Map.Entry<K, V> entry) {
            this.delegate = (Map.Entry) Preconditions.checkNotNull(entry);
        }

        @Override
        public Map.Entry<K, V> delegate() {
            return this.delegate;
        }

        @Override
        public V setValue(V v) {
            throw new UnsupportedOperationException();
        }
    }
}
