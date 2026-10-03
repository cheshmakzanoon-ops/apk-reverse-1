package com.google.common.collect;

import com.google.common.base.Preconditions;
import com.google.common.base.Predicate;
import java.util.Collection;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import javax.annotation.CheckForNull;

@ElementTypesAreNonnullByDefault
class FilteredKeyMultimap<K, V> extends AbstractMultimap<K, V> implements FilteredMultimap<K, V> {
    final Predicate<? super K> keyPredicate;
    final Multimap<K, V> unfiltered;

    FilteredKeyMultimap(Multimap<K, V> multimap, Predicate<? super K> predicate) {
        this.unfiltered = (Multimap) Preconditions.checkNotNull(multimap);
        this.keyPredicate = (Predicate) Preconditions.checkNotNull(predicate);
    }

    public Multimap<K, V> unfiltered() {
        return this.unfiltered;
    }

    @Override
    public Predicate<? super Map.Entry<K, V>> entryPredicate() {
        return Maps.keyPredicateOnEntries(this.keyPredicate);
    }

    @Override
    public int size() {
        Iterator<Collection<V>> it = asMap().values().iterator();
        int size = 0;
        while (it.hasNext()) {
            size += it.next().size();
        }
        return size;
    }

    @Override
    public boolean containsKey(@CheckForNull Object obj) {
        if (this.unfiltered.containsKey(obj)) {
            return this.keyPredicate.apply(obj);
        }
        return false;
    }

    @Override
    public Collection<V> removeAll(@CheckForNull Object obj) {
        return containsKey(obj) ? this.unfiltered.removeAll(obj) : unmodifiableEmptyCollection();
    }

    Collection<V> unmodifiableEmptyCollection() {
        if (this.unfiltered instanceof SetMultimap) {
            return Collections.emptySet();
        }
        return Collections.emptyList();
    }

    @Override
    public void clear() {
        keySet().clear();
    }

    @Override
    Set<K> createKeySet() {
        return Sets.filter(this.unfiltered.keySet(), this.keyPredicate);
    }

    @Override
    public Collection<V> get(@ParametricNullness K k) {
        if (this.keyPredicate.apply(k)) {
            return this.unfiltered.get(k);
        }
        if (this.unfiltered instanceof SetMultimap) {
            return new AddRejectingSet(k);
        }
        return new AddRejectingList(k);
    }

    static class AddRejectingSet<K, V> extends ForwardingSet<V> {

        @ParametricNullness
        final K key;

        AddRejectingSet(@ParametricNullness K k) {
            this.key = k;
        }

        @Override
        public boolean add(@ParametricNullness V v) {
            String strValueOf = String.valueOf(this.key);
            StringBuilder sb = new StringBuilder(String.valueOf(strValueOf).length() + 32);
            sb.append("Key does not satisfy predicate: ");
            sb.append(strValueOf);
            throw new IllegalArgumentException(sb.toString());
        }

        @Override
        public boolean addAll(Collection<? extends V> collection) {
            Preconditions.checkNotNull(collection);
            String strValueOf = String.valueOf(this.key);
            StringBuilder sb = new StringBuilder(String.valueOf(strValueOf).length() + 32);
            sb.append("Key does not satisfy predicate: ");
            sb.append(strValueOf);
            throw new IllegalArgumentException(sb.toString());
        }

        @Override
        public Set<V> delegate() {
            return Collections.emptySet();
        }
    }

    static class AddRejectingList<K, V> extends ForwardingList<V> {

        @ParametricNullness
        final K key;

        AddRejectingList(@ParametricNullness K k) {
            this.key = k;
        }

        @Override
        public boolean add(@ParametricNullness V v) {
            add(0, v);
            return true;
        }

        @Override
        public void add(int i, @ParametricNullness V v) {
            Preconditions.checkPositionIndex(i, 0);
            String strValueOf = String.valueOf(this.key);
            StringBuilder sb = new StringBuilder(String.valueOf(strValueOf).length() + 32);
            sb.append("Key does not satisfy predicate: ");
            sb.append(strValueOf);
            throw new IllegalArgumentException(sb.toString());
        }

        @Override
        public boolean addAll(Collection<? extends V> collection) {
            addAll(0, collection);
            return true;
        }

        @Override
        public boolean addAll(int i, Collection<? extends V> collection) {
            Preconditions.checkNotNull(collection);
            Preconditions.checkPositionIndex(i, 0);
            String strValueOf = String.valueOf(this.key);
            StringBuilder sb = new StringBuilder(String.valueOf(strValueOf).length() + 32);
            sb.append("Key does not satisfy predicate: ");
            sb.append(strValueOf);
            throw new IllegalArgumentException(sb.toString());
        }

        @Override
        public List<V> delegate() {
            return Collections.emptyList();
        }
    }

    @Override
    Iterator<Map.Entry<K, V>> entryIterator() {
        throw new AssertionError("should never be called");
    }

    @Override
    Collection<Map.Entry<K, V>> createEntries() {
        return new Entries();
    }

    class Entries extends ForwardingCollection<Map.Entry<K, V>> {
        Entries() {
        }

        @Override
        public Collection<Map.Entry<K, V>> delegate() {
            return Collections2.filter(FilteredKeyMultimap.this.unfiltered.entries(), FilteredKeyMultimap.this.entryPredicate());
        }

        @Override
        public boolean remove(@CheckForNull Object obj) {
            if (!(obj instanceof Map.Entry)) {
                return false;
            }
            Map.Entry entry = (Map.Entry) obj;
            if (FilteredKeyMultimap.this.unfiltered.containsKey(entry.getKey()) && FilteredKeyMultimap.this.keyPredicate.apply((Object) entry.getKey())) {
                return FilteredKeyMultimap.this.unfiltered.remove(entry.getKey(), entry.getValue());
            }
            return false;
        }
    }

    @Override
    Collection<V> createValues() {
        return new FilteredMultimapValues(this);
    }

    @Override
    Map<K, Collection<V>> createAsMap() {
        return Maps.filterKeys(this.unfiltered.asMap(), this.keyPredicate);
    }

    @Override
    Multiset<K> createKeys() {
        return Multisets.filter(this.unfiltered.keys(), this.keyPredicate);
    }
}
