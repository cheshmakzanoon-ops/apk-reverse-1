package com.google.common.collect;

import com.google.common.base.Preconditions;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.Collection;
import java.util.Map;
import java.util.Set;
import javax.annotation.CheckForNull;

@ElementTypesAreNonnullByDefault
public final class HashMultimap<K, V> extends HashMultimapGwtSerializationDependencies<K, V> {
    private static final int DEFAULT_VALUES_PER_KEY = 2;
    private static final long serialVersionUID = 0;
    transient int expectedValuesPerKey;

    @Override
    public Map asMap() {
        return super.asMap();
    }

    @Override
    public void clear() {
        super.clear();
    }

    @Override
    public boolean containsEntry(@CheckForNull Object obj, @CheckForNull Object obj2) {
        return super.containsEntry(obj, obj2);
    }

    @Override
    public boolean containsKey(@CheckForNull Object obj) {
        return super.containsKey(obj);
    }

    @Override
    public boolean containsValue(@CheckForNull Object obj) {
        return super.containsValue(obj);
    }

    @Override
    public Set entries() {
        return super.entries();
    }

    @Override
    public boolean equals(@CheckForNull Object obj) {
        return super.equals(obj);
    }

    @Override
    public Set get(@ParametricNullness Object obj) {
        return super.get(obj);
    }

    @Override
    public int hashCode() {
        return super.hashCode();
    }

    @Override
    public boolean isEmpty() {
        return super.isEmpty();
    }

    @Override
    public Set keySet() {
        return super.keySet();
    }

    @Override
    public Multiset keys() {
        return super.keys();
    }

    @Override
    public boolean put(@ParametricNullness Object obj, @ParametricNullness Object obj2) {
        return super.put(obj, obj2);
    }

    @Override
    public boolean putAll(Multimap multimap) {
        return super.putAll(multimap);
    }

    @Override
    public boolean putAll(@ParametricNullness Object obj, Iterable iterable) {
        return super.putAll(obj, iterable);
    }

    @Override
    public boolean remove(@CheckForNull Object obj, @CheckForNull Object obj2) {
        return super.remove(obj, obj2);
    }

    @Override
    public Set removeAll(@CheckForNull Object obj) {
        return super.removeAll(obj);
    }

    @Override
    public Set replaceValues(@ParametricNullness Object obj, Iterable iterable) {
        return super.replaceValues(obj, iterable);
    }

    @Override
    public int size() {
        return super.size();
    }

    @Override
    public String toString() {
        return super.toString();
    }

    @Override
    public Collection values() {
        return super.values();
    }

    public static <K, V> HashMultimap<K, V> create() {
        return new HashMultimap<>();
    }

    public static <K, V> HashMultimap<K, V> create(int i, int i2) {
        return new HashMultimap<>(i, i2);
    }

    public static <K, V> HashMultimap<K, V> create(Multimap<? extends K, ? extends V> multimap) {
        return new HashMultimap<>(multimap);
    }

    private HashMultimap() {
        this(12, 2);
    }

    private HashMultimap(int i, int i2) {
        super(Platform.newHashMapWithExpectedSize(i));
        this.expectedValuesPerKey = 2;
        Preconditions.checkArgument(i2 >= 0);
        this.expectedValuesPerKey = i2;
    }

    private HashMultimap(Multimap<? extends K, ? extends V> multimap) {
        super(Platform.newHashMapWithExpectedSize(multimap.keySet().size()));
        this.expectedValuesPerKey = 2;
        putAll(multimap);
    }

    @Override
    public Set<V> createCollection() {
        return Platform.newHashSetWithExpectedSize(this.expectedValuesPerKey);
    }

    private void writeObject(ObjectOutputStream objectOutputStream) throws IOException {
        objectOutputStream.defaultWriteObject();
        Serialization.writeMultimap(this, objectOutputStream);
    }

    private void readObject(ObjectInputStream objectInputStream) throws ClassNotFoundException, IOException {
        objectInputStream.defaultReadObject();
        this.expectedValuesPerKey = 2;
        int count = Serialization.readCount(objectInputStream);
        setMap(Platform.newHashMapWithExpectedSize(12));
        Serialization.populateMultimap(this, objectInputStream, count);
    }
}
