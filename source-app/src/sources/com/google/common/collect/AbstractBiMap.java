package com.google.common.collect;

import com.google.common.base.Objects;
import com.google.common.base.Preconditions;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.util.Collection;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import javax.annotation.CheckForNull;

@ElementTypesAreNonnullByDefault
abstract class AbstractBiMap<K, V> extends ForwardingMap<K, V> implements BiMap<K, V>, Serializable {
    private static final long serialVersionUID = 0;
    private transient Map<K, V> delegate;

    @CheckForNull
    private transient Set<Map.Entry<K, V>> entrySet;
    transient AbstractBiMap<V, K> inverse;

    @CheckForNull
    private transient Set<K> keySet;

    @CheckForNull
    private transient Set<V> valueSet;

    @ParametricNullness
    K checkKey(@ParametricNullness K k) {
        return k;
    }

    @ParametricNullness
    V checkValue(@ParametricNullness V v) {
        return v;
    }

    AbstractBiMap(Map<K, V> map, Map<V, K> map2) {
        setDelegates(map, map2);
    }

    private AbstractBiMap(Map<K, V> map, AbstractBiMap<V, K> abstractBiMap) {
        this.delegate = map;
        this.inverse = abstractBiMap;
    }

    @Override
    public Map<K, V> delegate() {
        return this.delegate;
    }

    void setDelegates(Map<K, V> map, Map<V, K> map2) {
        Preconditions.checkState(this.delegate == null);
        Preconditions.checkState(this.inverse == null);
        Preconditions.checkArgument(map.isEmpty());
        Preconditions.checkArgument(map2.isEmpty());
        Preconditions.checkArgument(map != map2);
        this.delegate = map;
        this.inverse = makeInverse(map2);
    }

    AbstractBiMap<V, K> makeInverse(Map<V, K> map) {
        return new Inverse(map, this);
    }

    void setInverse(AbstractBiMap<V, K> abstractBiMap) {
        this.inverse = abstractBiMap;
    }

    @Override
    public boolean containsValue(@CheckForNull Object obj) {
        return this.inverse.containsKey(obj);
    }

    @Override
    @CheckForNull
    public V put(@ParametricNullness K k, @ParametricNullness V v) {
        return putInBothMaps(k, v, false);
    }

    @Override
    @CheckForNull
    public V forcePut(@ParametricNullness K k, @ParametricNullness V v) {
        return putInBothMaps(k, v, true);
    }

    @CheckForNull
    private V putInBothMaps(@ParametricNullness K k, @ParametricNullness V v, boolean z) {
        checkKey(k);
        checkValue(v);
        boolean zContainsKey = containsKey(k);
        if (zContainsKey && Objects.equal(v, get(k))) {
            return v;
        }
        if (z) {
            inverse().remove(v);
        } else {
            Preconditions.checkArgument(!containsValue(v), "value already present: %s", v);
        }
        V vPut = this.delegate.put(k, v);
        updateInverseMap(k, zContainsKey, vPut, v);
        return vPut;
    }

    public void updateInverseMap(@ParametricNullness K k, boolean z, @CheckForNull V v, @ParametricNullness V v2) {
        if (z) {
            removeFromInverseMap(NullnessCasts.uncheckedCastNullableTToT(v));
        }
        this.inverse.delegate.put(v2, k);
    }

    @Override
    @CheckForNull
    public V remove(@CheckForNull Object obj) {
        if (containsKey(obj)) {
            return removeFromBothMaps(obj);
        }
        return null;
    }

    @ParametricNullness
    public V removeFromBothMaps(@CheckForNull Object obj) {
        V v = (V) NullnessCasts.uncheckedCastNullableTToT(this.delegate.remove(obj));
        removeFromInverseMap(v);
        return v;
    }

    public void removeFromInverseMap(@ParametricNullness V v) {
        this.inverse.delegate.remove(v);
    }

    @Override
    public void putAll(Map<? extends K, ? extends V> map) {
        for (Map.Entry<? extends K, ? extends V> entry : map.entrySet()) {
            put(entry.getKey(), entry.getValue());
        }
    }

    @Override
    public void clear() {
        this.delegate.clear();
        this.inverse.delegate.clear();
    }

    @Override
    public BiMap<V, K> inverse() {
        return this.inverse;
    }

    @Override
    public Set<K> keySet() {
        Set<K> set = this.keySet;
        if (set != null) {
            return set;
        }
        KeySet keySet = new KeySet();
        this.keySet = keySet;
        return keySet;
    }

    private class KeySet extends ForwardingSet<K> {
        private KeySet() {
        }

        @Override
        public Set<K> delegate() {
            return AbstractBiMap.this.delegate.keySet();
        }

        @Override
        public void clear() {
            AbstractBiMap.this.clear();
        }

        @Override
        public boolean remove(@CheckForNull Object obj) {
            if (!contains(obj)) {
                return false;
            }
            AbstractBiMap.this.removeFromBothMaps(obj);
            return true;
        }

        @Override
        public boolean removeAll(Collection<?> collection) {
            return standardRemoveAll(collection);
        }

        @Override
        public boolean retainAll(Collection<?> collection) {
            return standardRetainAll(collection);
        }

        @Override
        public Iterator<K> iterator() {
            return Maps.keyIterator(AbstractBiMap.this.entrySet().iterator());
        }
    }

    @Override
    public Set<V> values() {
        Set<V> set = this.valueSet;
        if (set != null) {
            return set;
        }
        ValueSet valueSet = new ValueSet();
        this.valueSet = valueSet;
        return valueSet;
    }

    private class ValueSet extends ForwardingSet<V> {
        final Set<V> valuesDelegate;

        private ValueSet() {
            this.valuesDelegate = AbstractBiMap.this.inverse.keySet();
        }

        @Override
        public Set<V> delegate() {
            return this.valuesDelegate;
        }

        @Override
        public Iterator<V> iterator() {
            return Maps.valueIterator(AbstractBiMap.this.entrySet().iterator());
        }

        @Override
        public Object[] toArray() {
            return standardToArray();
        }

        @Override
        public <T> T[] toArray(T[] tArr) {
            return (T[]) standardToArray(tArr);
        }

        @Override
        public String toString() {
            return standardToString();
        }
    }

    @Override
    public Set<Map.Entry<K, V>> entrySet() {
        Set<Map.Entry<K, V>> set = this.entrySet;
        if (set != null) {
            return set;
        }
        EntrySet entrySet = new EntrySet();
        this.entrySet = entrySet;
        return entrySet;
    }

    class BiMapEntry extends ForwardingMapEntry<K, V> {
        private final Map.Entry<K, V> delegate;

        BiMapEntry(Map.Entry<K, V> entry) {
            this.delegate = entry;
        }

        @Override
        public Map.Entry<K, V> delegate() {
            return this.delegate;
        }

        @Override
        public V setValue(V v) {
            AbstractBiMap.this.checkValue(v);
            Preconditions.checkState(AbstractBiMap.this.entrySet().contains(this), "entry no longer in map");
            if (Objects.equal(v, getValue())) {
                return v;
            }
            Preconditions.checkArgument(!AbstractBiMap.this.containsValue(v), "value already present: %s", v);
            V value = this.delegate.setValue(v);
            Preconditions.checkState(Objects.equal(v, AbstractBiMap.this.get(getKey())), "entry no longer in map");
            AbstractBiMap.this.updateInverseMap(getKey(), true, value, v);
            return value;
        }
    }

    Iterator<Map.Entry<K, V>> entrySetIterator() {
        final Iterator<Map.Entry<K, V>> it = this.delegate.entrySet().iterator();
        return new Iterator<Map.Entry<K, V>>() {

            @CheckForNull
            Map.Entry<K, V> entry;

            @Override
            public boolean hasNext() {
                return it.hasNext();
            }

            @Override
            public Map.Entry<K, V> next() {
                this.entry = (Map.Entry) it.next();
                return new BiMapEntry(this.entry);
            }

            @Override
            public void remove() {
                Map.Entry<K, V> entry = this.entry;
                if (entry == null) {
                    throw new IllegalStateException("no calls to next() since the last call to remove()");
                }
                V value = entry.getValue();
                it.remove();
                AbstractBiMap.this.removeFromInverseMap(value);
                this.entry = null;
            }
        };
    }

    private class EntrySet extends ForwardingSet<Map.Entry<K, V>> {
        final Set<Map.Entry<K, V>> esDelegate;

        private EntrySet() {
            this.esDelegate = AbstractBiMap.this.delegate.entrySet();
        }

        @Override
        public Set<Map.Entry<K, V>> delegate() {
            return this.esDelegate;
        }

        @Override
        public void clear() {
            AbstractBiMap.this.clear();
        }

        @Override
        public boolean remove(@CheckForNull Object obj) {
            if (!this.esDelegate.contains(obj) || !(obj instanceof Map.Entry)) {
                return false;
            }
            Map.Entry entry = (Map.Entry) obj;
            ((AbstractBiMap) AbstractBiMap.this.inverse).delegate.remove(entry.getValue());
            this.esDelegate.remove(entry);
            return true;
        }

        @Override
        public Iterator<Map.Entry<K, V>> iterator() {
            return AbstractBiMap.this.entrySetIterator();
        }

        @Override
        public Object[] toArray() {
            return standardToArray();
        }

        @Override
        public <T> T[] toArray(T[] tArr) {
            return (T[]) standardToArray(tArr);
        }

        @Override
        public boolean contains(@CheckForNull Object obj) {
            return Maps.containsEntryImpl(delegate(), obj);
        }

        @Override
        public boolean containsAll(Collection<?> collection) {
            return standardContainsAll(collection);
        }

        @Override
        public boolean removeAll(Collection<?> collection) {
            return standardRemoveAll(collection);
        }

        @Override
        public boolean retainAll(Collection<?> collection) {
            return standardRetainAll(collection);
        }
    }

    static class Inverse<K, V> extends AbstractBiMap<K, V> {
        private static final long serialVersionUID = 0;

        @Override
        protected Object delegate() {
            return super.delegate();
        }

        @Override
        public Collection values() {
            return super.values();
        }

        Inverse(Map<K, V> map, AbstractBiMap<V, K> abstractBiMap) {
            super(map, abstractBiMap);
        }

        @Override
        @ParametricNullness
        K checkKey(@ParametricNullness K k) {
            return this.inverse.checkValue(k);
        }

        @Override
        @ParametricNullness
        V checkValue(@ParametricNullness V v) {
            return this.inverse.checkKey(v);
        }

        private void writeObject(ObjectOutputStream objectOutputStream) throws IOException {
            objectOutputStream.defaultWriteObject();
            objectOutputStream.writeObject(inverse());
        }

        private void readObject(ObjectInputStream objectInputStream) throws ClassNotFoundException, IOException {
            objectInputStream.defaultReadObject();
            setInverse((AbstractBiMap) objectInputStream.readObject());
        }

        Object readResolve() {
            return inverse().inverse();
        }
    }
}
