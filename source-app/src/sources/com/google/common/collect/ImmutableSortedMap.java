package com.google.common.collect;

import com.google.common.base.Preconditions;
import j$.util.Map;
import j$.util.Objects;
import java.util.AbstractMap;
import java.util.Arrays;
import java.util.Comparator;
import java.util.NavigableMap;
import java.util.SortedMap;
import javax.annotation.CheckForNull;

@ElementTypesAreNonnullByDefault
public final class ImmutableSortedMap<K, V> extends ImmutableSortedMapFauxverideShim<K, V> implements NavigableMap<K, V>, Map {
    private static final long serialVersionUID = 0;

    @CheckForNull
    private transient ImmutableSortedMap<K, V> descendingMap;
    private final transient RegularImmutableSortedSet<K> keySet;
    private final transient ImmutableList<V> valueList;
    private static final Comparator<Comparable> NATURAL_ORDER = Ordering.natural();
    private static final ImmutableSortedMap<Comparable, Object> NATURAL_EMPTY_MAP = new ImmutableSortedMap<>(ImmutableSortedSet.emptySet(Ordering.natural()), ImmutableList.m160of());

    static <K, V> ImmutableSortedMap<K, V> emptyMap(Comparator<? super K> comparator) {
        if (Ordering.natural().equals(comparator)) {
            return m220of();
        }
        return new ImmutableSortedMap<>(ImmutableSortedSet.emptySet(comparator), ImmutableList.m160of());
    }

    public static <K, V> ImmutableSortedMap<K, V> m220of() {
        return (ImmutableSortedMap<K, V>) NATURAL_EMPTY_MAP;
    }

    public static ImmutableSortedMap m221of(Comparable comparable, Object obj) {
        return m231of(Ordering.natural(), comparable, obj);
    }

    public static <K, V> ImmutableSortedMap<K, V> m231of(Comparator<? super K> comparator, K k, V v) {
        return new ImmutableSortedMap<>(new RegularImmutableSortedSet(ImmutableList.m161of(k), (Comparator) Preconditions.checkNotNull(comparator)), ImmutableList.m161of(v));
    }

    public static ImmutableSortedMap m222of(Comparable comparable, Object obj, Comparable comparable2, Object obj2) {
        return fromEntries(entryOf(comparable, obj), entryOf(comparable2, obj2));
    }

    public static ImmutableSortedMap m223of(Comparable comparable, Object obj, Comparable comparable2, Object obj2, Comparable comparable3, Object obj3) {
        return fromEntries(entryOf(comparable, obj), entryOf(comparable2, obj2), entryOf(comparable3, obj3));
    }

    public static ImmutableSortedMap m224of(Comparable comparable, Object obj, Comparable comparable2, Object obj2, Comparable comparable3, Object obj3, Comparable comparable4, Object obj4) {
        return fromEntries(entryOf(comparable, obj), entryOf(comparable2, obj2), entryOf(comparable3, obj3), entryOf(comparable4, obj4));
    }

    public static ImmutableSortedMap m225of(Comparable comparable, Object obj, Comparable comparable2, Object obj2, Comparable comparable3, Object obj3, Comparable comparable4, Object obj4, Comparable comparable5, Object obj5) {
        return fromEntries(entryOf(comparable, obj), entryOf(comparable2, obj2), entryOf(comparable3, obj3), entryOf(comparable4, obj4), entryOf(comparable5, obj5));
    }

    public static ImmutableSortedMap m226of(Comparable comparable, Object obj, Comparable comparable2, Object obj2, Comparable comparable3, Object obj3, Comparable comparable4, Object obj4, Comparable comparable5, Object obj5, Comparable comparable6, Object obj6) {
        return fromEntries(entryOf(comparable, obj), entryOf(comparable2, obj2), entryOf(comparable3, obj3), entryOf(comparable4, obj4), entryOf(comparable5, obj5), entryOf(comparable6, obj6));
    }

    public static ImmutableSortedMap m227of(Comparable comparable, Object obj, Comparable comparable2, Object obj2, Comparable comparable3, Object obj3, Comparable comparable4, Object obj4, Comparable comparable5, Object obj5, Comparable comparable6, Object obj6, Comparable comparable7, Object obj7) {
        return fromEntries(entryOf(comparable, obj), entryOf(comparable2, obj2), entryOf(comparable3, obj3), entryOf(comparable4, obj4), entryOf(comparable5, obj5), entryOf(comparable6, obj6), entryOf(comparable7, obj7));
    }

    public static ImmutableSortedMap m228of(Comparable comparable, Object obj, Comparable comparable2, Object obj2, Comparable comparable3, Object obj3, Comparable comparable4, Object obj4, Comparable comparable5, Object obj5, Comparable comparable6, Object obj6, Comparable comparable7, Object obj7, Comparable comparable8, Object obj8) {
        return fromEntries(entryOf(comparable, obj), entryOf(comparable2, obj2), entryOf(comparable3, obj3), entryOf(comparable4, obj4), entryOf(comparable5, obj5), entryOf(comparable6, obj6), entryOf(comparable7, obj7), entryOf(comparable8, obj8));
    }

    public static ImmutableSortedMap m229of(Comparable comparable, Object obj, Comparable comparable2, Object obj2, Comparable comparable3, Object obj3, Comparable comparable4, Object obj4, Comparable comparable5, Object obj5, Comparable comparable6, Object obj6, Comparable comparable7, Object obj7, Comparable comparable8, Object obj8, Comparable comparable9, Object obj9) {
        return fromEntries(entryOf(comparable, obj), entryOf(comparable2, obj2), entryOf(comparable3, obj3), entryOf(comparable4, obj4), entryOf(comparable5, obj5), entryOf(comparable6, obj6), entryOf(comparable7, obj7), entryOf(comparable8, obj8), entryOf(comparable9, obj9));
    }

    public static ImmutableSortedMap m230of(Comparable comparable, Object obj, Comparable comparable2, Object obj2, Comparable comparable3, Object obj3, Comparable comparable4, Object obj4, Comparable comparable5, Object obj5, Comparable comparable6, Object obj6, Comparable comparable7, Object obj7, Comparable comparable8, Object obj8, Comparable comparable9, Object obj9, Comparable comparable10, Object obj10) {
        return fromEntries(entryOf(comparable, obj), entryOf(comparable2, obj2), entryOf(comparable3, obj3), entryOf(comparable4, obj4), entryOf(comparable5, obj5), entryOf(comparable6, obj6), entryOf(comparable7, obj7), entryOf(comparable8, obj8), entryOf(comparable9, obj9), entryOf(comparable10, obj10));
    }

    public static <K, V> ImmutableSortedMap<K, V> copyOf(java.util.Map<? extends K, ? extends V> map) {
        return copyOfInternal(map, (Ordering) NATURAL_ORDER);
    }

    public static <K, V> ImmutableSortedMap<K, V> copyOf(java.util.Map<? extends K, ? extends V> map, Comparator<? super K> comparator) {
        return copyOfInternal(map, (Comparator) Preconditions.checkNotNull(comparator));
    }

    public static <K, V> ImmutableSortedMap<K, V> copyOf(Iterable<? extends java.util.Map.Entry<? extends K, ? extends V>> iterable) {
        return copyOf(iterable, (Ordering) NATURAL_ORDER);
    }

    public static <K, V> ImmutableSortedMap<K, V> copyOf(Iterable<? extends java.util.Map.Entry<? extends K, ? extends V>> iterable, Comparator<? super K> comparator) {
        return fromEntries((Comparator) Preconditions.checkNotNull(comparator), false, iterable);
    }

    public static <K, V> ImmutableSortedMap<K, V> copyOfSorted(SortedMap<K, ? extends V> sortedMap) {
        Comparator<? super K> comparator = sortedMap.comparator();
        if (comparator == null) {
            comparator = NATURAL_ORDER;
        }
        if (sortedMap instanceof ImmutableSortedMap) {
            ImmutableSortedMap<K, V> immutableSortedMap = (ImmutableSortedMap) sortedMap;
            if (!immutableSortedMap.isPartialView()) {
                return immutableSortedMap;
            }
        }
        return fromEntries(comparator, true, sortedMap.entrySet());
    }

    private static <K, V> ImmutableSortedMap<K, V> copyOfInternal(java.util.Map<? extends K, ? extends V> map, Comparator<? super K> comparator) {
        boolean zEquals;
        boolean z = false;
        if (map instanceof SortedMap) {
            Comparator<? super K> comparator2 = ((SortedMap) map).comparator();
            if (comparator2 != null) {
                zEquals = comparator.equals(comparator2);
            } else if (comparator == NATURAL_ORDER) {
                zEquals = true;
            }
            z = zEquals;
        }
        if (z && (map instanceof ImmutableSortedMap)) {
            ImmutableSortedMap<K, V> immutableSortedMap = (ImmutableSortedMap) map;
            if (!immutableSortedMap.isPartialView()) {
                return immutableSortedMap;
            }
        }
        return fromEntries(comparator, z, map.entrySet());
    }

    private static <K extends Comparable<? super K>, V> ImmutableSortedMap<K, V> fromEntries(java.util.Map.Entry<K, V>... entryArr) {
        return fromEntries(Ordering.natural(), false, entryArr, entryArr.length);
    }

    private static <K, V> ImmutableSortedMap<K, V> fromEntries(Comparator<? super K> comparator, boolean z, Iterable<? extends java.util.Map.Entry<? extends K, ? extends V>> iterable) {
        java.util.Map.Entry[] entryArr = (java.util.Map.Entry[]) Iterables.toArray(iterable, EMPTY_ENTRY_ARRAY);
        return fromEntries(comparator, z, entryArr, entryArr.length);
    }

    private static <K, V> ImmutableSortedMap<K, V> fromEntries(final Comparator<? super K> comparator, boolean z, java.util.Map.Entry<K, V>[] entryArr, int i) {
        if (i == 0) {
            return emptyMap(comparator);
        }
        if (i == 1) {
            java.util.Map.Entry entry = (java.util.Map.Entry) Objects.requireNonNull(entryArr[0]);
            return m231of(comparator, entry.getKey(), entry.getValue());
        }
        Object[] objArr = new Object[i];
        Object[] objArr2 = new Object[i];
        if (z) {
            for (int i2 = 0; i2 < i; i2++) {
                java.util.Map.Entry entry2 = (java.util.Map.Entry) Objects.requireNonNull(entryArr[i2]);
                Object key = entry2.getKey();
                Object value = entry2.getValue();
                CollectPreconditions.checkEntryNotNull(key, value);
                objArr[i2] = key;
                objArr2[i2] = value;
            }
        } else {
            Arrays.sort(entryArr, 0, i, new Comparator<java.util.Map.Entry<K, V>>() {
                @Override
                public int compare(@CheckForNull java.util.Map.Entry<K, V> entry3, @CheckForNull java.util.Map.Entry<K, V> entry4) {
                    Objects.requireNonNull(entry3);
                    Objects.requireNonNull(entry4);
                    return comparator.compare(entry3.getKey(), entry4.getKey());
                }
            });
            java.util.Map.Entry entry3 = (java.util.Map.Entry) Objects.requireNonNull(entryArr[0]);
            Object key2 = entry3.getKey();
            objArr[0] = key2;
            Object value2 = entry3.getValue();
            objArr2[0] = value2;
            CollectPreconditions.checkEntryNotNull(objArr[0], value2);
            int i3 = 1;
            while (i3 < i) {
                java.util.Map.Entry entry4 = (java.util.Map.Entry) Objects.requireNonNull(entryArr[i3 - 1]);
                java.util.Map.Entry entry5 = (java.util.Map.Entry) Objects.requireNonNull(entryArr[i3]);
                Object key3 = entry5.getKey();
                Object value3 = entry5.getValue();
                CollectPreconditions.checkEntryNotNull(key3, value3);
                objArr[i3] = key3;
                objArr2[i3] = value3;
                checkNoConflict(comparator.compare(key2, key3) != 0, "key", entry4, entry5);
                i3++;
                key2 = key3;
            }
        }
        return new ImmutableSortedMap<>(new RegularImmutableSortedSet(ImmutableList.asImmutableList(objArr), comparator), ImmutableList.asImmutableList(objArr2));
    }

    public static <K extends Comparable<?>, V> Builder<K, V> naturalOrder() {
        return new Builder<>(Ordering.natural());
    }

    public static <K, V> Builder<K, V> orderedBy(Comparator<K> comparator) {
        return new Builder<>(comparator);
    }

    public static <K extends Comparable<?>, V> Builder<K, V> reverseOrder() {
        return new Builder<>(Ordering.natural().reverse());
    }

    public static class Builder<K, V> extends ImmutableMap.Builder<K, V> {
        private final Comparator<? super K> comparator;
        private transient Object[] keys;
        private transient Object[] values;

        public Builder(Comparator<? super K> comparator) {
            this(comparator, 4);
        }

        private Builder(Comparator<? super K> comparator, int i) {
            this.comparator = (Comparator) Preconditions.checkNotNull(comparator);
            this.keys = new Object[i];
            this.values = new Object[i];
        }

        private void ensureCapacity(int i) {
            Object[] objArr = this.keys;
            if (i > objArr.length) {
                int iExpandedCapacity = ImmutableCollection.Builder.expandedCapacity(objArr.length, i);
                this.keys = Arrays.copyOf(this.keys, iExpandedCapacity);
                this.values = Arrays.copyOf(this.values, iExpandedCapacity);
            }
        }

        @Override
        public Builder<K, V> put(K k, V v) {
            ensureCapacity(this.size + 1);
            CollectPreconditions.checkEntryNotNull(k, v);
            this.keys[this.size] = k;
            this.values[this.size] = v;
            this.size++;
            return this;
        }

        @Override
        public Builder<K, V> put(java.util.Map.Entry<? extends K, ? extends V> entry) {
            super.put((java.util.Map.Entry) entry);
            return this;
        }

        @Override
        public Builder<K, V> putAll(java.util.Map<? extends K, ? extends V> map) {
            super.putAll((java.util.Map) map);
            return this;
        }

        @Override
        public Builder<K, V> putAll(Iterable<? extends java.util.Map.Entry<? extends K, ? extends V>> iterable) {
            super.putAll((Iterable) iterable);
            return this;
        }

        @Override
        @Deprecated
        public final Builder<K, V> orderEntriesByValue(Comparator<? super V> comparator) {
            throw new UnsupportedOperationException("Not available on ImmutableSortedMap.Builder");
        }

        Builder<K, V> combine(Builder<K, V> builder) {
            ensureCapacity(this.size + builder.size);
            System.arraycopy(builder.keys, 0, this.keys, this.size, builder.size);
            System.arraycopy(builder.values, 0, this.values, this.size, builder.size);
            this.size += builder.size;
            return this;
        }

        @Override
        public ImmutableSortedMap<K, V> build() {
            return buildOrThrow();
        }

        @Override
        public ImmutableSortedMap<K, V> buildOrThrow() {
            int i = this.size;
            if (i == 0) {
                return ImmutableSortedMap.emptyMap(this.comparator);
            }
            if (i == 1) {
                return ImmutableSortedMap.m231of(this.comparator, Objects.requireNonNull(this.keys[0]), Objects.requireNonNull(this.values[0]));
            }
            Object[] objArrCopyOf = Arrays.copyOf(this.keys, this.size);
            Arrays.sort(objArrCopyOf, this.comparator);
            Object[] objArr = new Object[this.size];
            for (int i2 = 0; i2 < this.size; i2++) {
                if (i2 > 0) {
                    int i3 = i2 - 1;
                    if (this.comparator.compare(objArrCopyOf[i3], objArrCopyOf[i2]) == 0) {
                        String strValueOf = String.valueOf(objArrCopyOf[i3]);
                        String strValueOf2 = String.valueOf(objArrCopyOf[i2]);
                        StringBuilder sb = new StringBuilder(String.valueOf(strValueOf).length() + 57 + String.valueOf(strValueOf2).length());
                        sb.append("keys required to be distinct but compared as equal: ");
                        sb.append(strValueOf);
                        sb.append(" and ");
                        sb.append(strValueOf2);
                        throw new IllegalArgumentException(sb.toString());
                    }
                }
                objArr[Arrays.binarySearch(objArrCopyOf, Objects.requireNonNull(this.keys[i2]), this.comparator)] = Objects.requireNonNull(this.values[i2]);
            }
            return new ImmutableSortedMap<>(new RegularImmutableSortedSet(ImmutableList.asImmutableList(objArrCopyOf), this.comparator), ImmutableList.asImmutableList(objArr));
        }

        @Override
        @Deprecated
        public final ImmutableSortedMap<K, V> buildKeepingLast() {
            throw new UnsupportedOperationException("ImmutableSortedMap.Builder does not yet implement buildKeepingLast()");
        }
    }

    ImmutableSortedMap(RegularImmutableSortedSet<K> regularImmutableSortedSet, ImmutableList<V> immutableList) {
        this(regularImmutableSortedSet, immutableList, null);
    }

    ImmutableSortedMap(RegularImmutableSortedSet<K> regularImmutableSortedSet, ImmutableList<V> immutableList, @CheckForNull ImmutableSortedMap<K, V> immutableSortedMap) {
        this.keySet = regularImmutableSortedSet;
        this.valueList = immutableList;
        this.descendingMap = immutableSortedMap;
    }

    @Override
    public int size() {
        return this.valueList.size();
    }

    @Override
    @CheckForNull
    public V get(@CheckForNull Object obj) {
        int iIndexOf = this.keySet.indexOf(obj);
        if (iIndexOf == -1) {
            return null;
        }
        return this.valueList.get(iIndexOf);
    }

    @Override
    boolean isPartialView() {
        return this.keySet.isPartialView() || this.valueList.isPartialView();
    }

    @Override
    public ImmutableSet<java.util.Map.Entry<K, V>> entrySet() {
        return super.entrySet();
    }

    @Override
    ImmutableSet<java.util.Map.Entry<K, V>> createEntrySet() {
        return isEmpty() ? ImmutableSet.m207of() : new ImmutableMapEntrySet<K, V>() {
            @Override
            public UnmodifiableIterator<java.util.Map.Entry<K, V>> iterator() {
                return asList().iterator();
            }

            @Override
            ImmutableList<java.util.Map.Entry<K, V>> createAsList() {
                return new ImmutableList<java.util.Map.Entry<K, V>>() {
                    @Override
                    boolean isPartialView() {
                        return true;
                    }

                    @Override
                    public java.util.Map.Entry<K, V> get(int i) {
                        return new AbstractMap.SimpleImmutableEntry(ImmutableSortedMap.this.keySet.asList().get(i), ImmutableSortedMap.this.valueList.get(i));
                    }

                    @Override
                    public int size() {
                        return ImmutableSortedMap.this.size();
                    }
                };
            }

            @Override
            ImmutableMap<K, V> map() {
                return ImmutableSortedMap.this;
            }
        };
    }

    @Override
    public ImmutableSortedSet<K> keySet() {
        return this.keySet;
    }

    @Override
    ImmutableSet<K> createKeySet() {
        throw new AssertionError("should never be called");
    }

    @Override
    public ImmutableCollection<V> values() {
        return this.valueList;
    }

    @Override
    ImmutableCollection<V> createValues() {
        throw new AssertionError("should never be called");
    }

    @Override
    public Comparator<? super K> comparator() {
        return keySet().comparator();
    }

    @Override
    public K firstKey() {
        return keySet().first();
    }

    @Override
    public K lastKey() {
        return keySet().last();
    }

    private ImmutableSortedMap<K, V> getSubMap(int i, int i2) {
        if (i == 0 && i2 == size()) {
            return this;
        }
        if (i == i2) {
            return emptyMap(comparator());
        }
        return new ImmutableSortedMap<>(this.keySet.getSubSet(i, i2), this.valueList.subList(i, i2));
    }

    @Override
    public ImmutableSortedMap<K, V> headMap(K k) {
        return headMap((Object) k, false);
    }

    @Override
    public ImmutableSortedMap<K, V> headMap(K k, boolean z) {
        return getSubMap(0, this.keySet.headIndex((K) Preconditions.checkNotNull(k), z));
    }

    @Override
    public ImmutableSortedMap<K, V> subMap(K k, K k2) {
        return subMap((Object) k, true, (Object) k2, false);
    }

    @Override
    public ImmutableSortedMap<K, V> subMap(K k, boolean z, K k2, boolean z2) {
        Preconditions.checkNotNull(k);
        Preconditions.checkNotNull(k2);
        Preconditions.checkArgument(comparator().compare(k, k2) <= 0, "expected fromKey <= toKey but %s > %s", k, k2);
        return headMap((Object) k2, z2).tailMap((Object) k, z);
    }

    @Override
    public ImmutableSortedMap<K, V> tailMap(K k) {
        return tailMap((Object) k, true);
    }

    @Override
    public ImmutableSortedMap<K, V> tailMap(K k, boolean z) {
        return getSubMap(this.keySet.tailIndex((K) Preconditions.checkNotNull(k), z), size());
    }

    @Override
    @CheckForNull
    public java.util.Map.Entry<K, V> lowerEntry(K k) {
        return headMap((Object) k, false).lastEntry();
    }

    @Override
    @CheckForNull
    public K lowerKey(K k) {
        return (K) Maps.keyOrNull(lowerEntry(k));
    }

    @Override
    @CheckForNull
    public java.util.Map.Entry<K, V> floorEntry(K k) {
        return headMap((Object) k, true).lastEntry();
    }

    @Override
    @CheckForNull
    public K floorKey(K k) {
        return (K) Maps.keyOrNull(floorEntry(k));
    }

    @Override
    @CheckForNull
    public java.util.Map.Entry<K, V> ceilingEntry(K k) {
        return tailMap((Object) k, true).firstEntry();
    }

    @Override
    @CheckForNull
    public K ceilingKey(K k) {
        return (K) Maps.keyOrNull(ceilingEntry(k));
    }

    @Override
    @CheckForNull
    public java.util.Map.Entry<K, V> higherEntry(K k) {
        return tailMap((Object) k, false).firstEntry();
    }

    @Override
    @CheckForNull
    public K higherKey(K k) {
        return (K) Maps.keyOrNull(higherEntry(k));
    }

    @Override
    @CheckForNull
    public java.util.Map.Entry<K, V> firstEntry() {
        if (isEmpty()) {
            return null;
        }
        return entrySet().asList().get(0);
    }

    @Override
    @CheckForNull
    public java.util.Map.Entry<K, V> lastEntry() {
        if (isEmpty()) {
            return null;
        }
        return entrySet().asList().get(size() - 1);
    }

    @Override
    @CheckForNull
    @Deprecated
    public final java.util.Map.Entry<K, V> pollFirstEntry() {
        throw new UnsupportedOperationException();
    }

    @Override
    @CheckForNull
    @Deprecated
    public final java.util.Map.Entry<K, V> pollLastEntry() {
        throw new UnsupportedOperationException();
    }

    @Override
    public ImmutableSortedMap<K, V> descendingMap() {
        ImmutableSortedMap<K, V> immutableSortedMap = this.descendingMap;
        if (immutableSortedMap != null) {
            return immutableSortedMap;
        }
        if (isEmpty()) {
            return emptyMap(Ordering.from(comparator()).reverse());
        }
        return new ImmutableSortedMap<>((RegularImmutableSortedSet) this.keySet.descendingSet(), this.valueList.reverse(), this);
    }

    @Override
    public ImmutableSortedSet<K> navigableKeySet() {
        return this.keySet;
    }

    @Override
    public ImmutableSortedSet<K> descendingKeySet() {
        return this.keySet.descendingSet();
    }

    private static class SerializedForm<K, V> extends ImmutableMap.SerializedForm<K, V> {
        private static final long serialVersionUID = 0;
        private final Comparator<? super K> comparator;

        SerializedForm(ImmutableSortedMap<K, V> immutableSortedMap) {
            super(immutableSortedMap);
            this.comparator = immutableSortedMap.comparator();
        }

        @Override
        public Builder<K, V> makeBuilder(int i) {
            return new Builder<>(this.comparator);
        }
    }

    @Override
    Object writeReplace() {
        return new SerializedForm(this);
    }
}
