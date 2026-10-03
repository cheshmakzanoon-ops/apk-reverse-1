package com.google.common.collect;

import com.google.common.base.Preconditions;
import com.google.common.base.Predicate;
import com.google.common.base.Predicates;
import com.google.common.math.IntMath;
import j$.util.concurrent.ConcurrentHashMap;
import java.io.Serializable;
import java.util.AbstractSet;
import java.util.Arrays;
import java.util.BitSet;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.EnumSet;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.NavigableSet;
import java.util.NoSuchElementException;
import java.util.Set;
import java.util.SortedSet;
import java.util.TreeSet;
import java.util.concurrent.CopyOnWriteArraySet;
import javax.annotation.CheckForNull;

@ElementTypesAreNonnullByDefault
public final class Sets {
    private Sets() {
    }

    static abstract class ImprovedAbstractSet<E> extends AbstractSet<E> {
        ImprovedAbstractSet() {
        }

        @Override
        public boolean removeAll(Collection<?> collection) {
            return Sets.removeAllImpl(this, collection);
        }

        @Override
        public boolean retainAll(Collection<?> collection) {
            return super.retainAll((Collection) Preconditions.checkNotNull(collection));
        }
    }

    public static <E extends Enum<E>> ImmutableSet<E> immutableEnumSet(E e, E... eArr) {
        return ImmutableEnumSet.asImmutable(EnumSet.of((Enum) e, (Enum[]) eArr));
    }

    public static <E extends Enum<E>> ImmutableSet<E> immutableEnumSet(Iterable<E> iterable) {
        if (iterable instanceof ImmutableEnumSet) {
            return (ImmutableEnumSet) iterable;
        }
        if (iterable instanceof Collection) {
            Collection collection = (Collection) iterable;
            if (collection.isEmpty()) {
                return ImmutableSet.m207of();
            }
            return ImmutableEnumSet.asImmutable(EnumSet.copyOf(collection));
        }
        Iterator<E> it = iterable.iterator();
        if (it.hasNext()) {
            EnumSet enumSetOf = EnumSet.of((Enum) it.next());
            Iterators.addAll(enumSetOf, it);
            return ImmutableEnumSet.asImmutable(enumSetOf);
        }
        return ImmutableSet.m207of();
    }

    public static <E extends Enum<E>> EnumSet<E> newEnumSet(Iterable<E> iterable, Class<E> cls) {
        EnumSet<E> enumSetNoneOf = EnumSet.noneOf(cls);
        Iterables.addAll(enumSetNoneOf, iterable);
        return enumSetNoneOf;
    }

    public static <E> HashSet<E> newHashSet() {
        return new HashSet<>();
    }

    public static <E> HashSet<E> newHashSet(E... eArr) {
        HashSet<E> hashSetNewHashSetWithExpectedSize = newHashSetWithExpectedSize(eArr.length);
        Collections.addAll(hashSetNewHashSetWithExpectedSize, eArr);
        return hashSetNewHashSetWithExpectedSize;
    }

    public static <E> HashSet<E> newHashSet(Iterable<? extends E> iterable) {
        if (iterable instanceof Collection) {
            return new HashSet<>((Collection) iterable);
        }
        return newHashSet(iterable.iterator());
    }

    public static <E> HashSet<E> newHashSet(Iterator<? extends E> it) {
        HashSet<E> hashSetNewHashSet = newHashSet();
        Iterators.addAll(hashSetNewHashSet, it);
        return hashSetNewHashSet;
    }

    public static <E> HashSet<E> newHashSetWithExpectedSize(int i) {
        return new HashSet<>(Maps.capacity(i));
    }

    public static <E> Set<E> newConcurrentHashSet() {
        return Collections.newSetFromMap(new ConcurrentHashMap());
    }

    public static <E> Set<E> newConcurrentHashSet(Iterable<? extends E> iterable) {
        Set<E> setNewConcurrentHashSet = newConcurrentHashSet();
        Iterables.addAll(setNewConcurrentHashSet, iterable);
        return setNewConcurrentHashSet;
    }

    public static <E> LinkedHashSet<E> newLinkedHashSet() {
        return new LinkedHashSet<>();
    }

    public static <E> LinkedHashSet<E> newLinkedHashSet(Iterable<? extends E> iterable) {
        if (iterable instanceof Collection) {
            return new LinkedHashSet<>((Collection) iterable);
        }
        LinkedHashSet<E> linkedHashSetNewLinkedHashSet = newLinkedHashSet();
        Iterables.addAll(linkedHashSetNewLinkedHashSet, iterable);
        return linkedHashSetNewLinkedHashSet;
    }

    public static <E> LinkedHashSet<E> newLinkedHashSetWithExpectedSize(int i) {
        return new LinkedHashSet<>(Maps.capacity(i));
    }

    public static <E extends Comparable> TreeSet<E> newTreeSet() {
        return new TreeSet<>();
    }

    public static <E extends Comparable> TreeSet<E> newTreeSet(Iterable<? extends E> iterable) {
        TreeSet<E> treeSetNewTreeSet = newTreeSet();
        Iterables.addAll(treeSetNewTreeSet, iterable);
        return treeSetNewTreeSet;
    }

    public static <E> TreeSet<E> newTreeSet(Comparator<? super E> comparator) {
        return new TreeSet<>((Comparator) Preconditions.checkNotNull(comparator));
    }

    public static <E> Set<E> newIdentityHashSet() {
        return Collections.newSetFromMap(Maps.newIdentityHashMap());
    }

    public static <E> CopyOnWriteArraySet<E> newCopyOnWriteArraySet() {
        return new CopyOnWriteArraySet<>();
    }

    public static <E> CopyOnWriteArraySet<E> newCopyOnWriteArraySet(Iterable<? extends E> iterable) {
        Collection collectionNewArrayList;
        if (iterable instanceof Collection) {
            collectionNewArrayList = (Collection) iterable;
        } else {
            collectionNewArrayList = Lists.newArrayList(iterable);
        }
        return new CopyOnWriteArraySet<>(collectionNewArrayList);
    }

    public static <E extends Enum<E>> EnumSet<E> complementOf(Collection<E> collection) {
        if (collection instanceof EnumSet) {
            return EnumSet.complementOf((EnumSet) collection);
        }
        Preconditions.checkArgument(!collection.isEmpty(), "collection is empty; use the other version of this method");
        return makeComplementByHand(collection, collection.iterator().next().getDeclaringClass());
    }

    public static <E extends Enum<E>> EnumSet<E> complementOf(Collection<E> collection, Class<E> cls) {
        Preconditions.checkNotNull(collection);
        if (collection instanceof EnumSet) {
            return EnumSet.complementOf((EnumSet) collection);
        }
        return makeComplementByHand(collection, cls);
    }

    private static <E extends Enum<E>> EnumSet<E> makeComplementByHand(Collection<E> collection, Class<E> cls) {
        EnumSet<E> enumSetAllOf = EnumSet.allOf(cls);
        enumSetAllOf.removeAll(collection);
        return enumSetAllOf;
    }

    @Deprecated
    public static <E> Set<E> newSetFromMap(Map<E, Boolean> map) {
        return Collections.newSetFromMap(map);
    }

    public static abstract class SetView<E> extends AbstractSet<E> {
        @Override
        public abstract UnmodifiableIterator<E> iterator();

        private SetView() {
        }

        public ImmutableSet<E> immutableCopy() {
            return ImmutableSet.copyOf((Collection) this);
        }

        public <S extends Set<E>> S copyInto(S s) {
            s.addAll(this);
            return s;
        }

        @Override
        @Deprecated
        public final boolean add(@ParametricNullness E e) {
            throw new UnsupportedOperationException();
        }

        @Override
        @Deprecated
        public final boolean remove(@CheckForNull Object obj) {
            throw new UnsupportedOperationException();
        }

        @Override
        @Deprecated
        public final boolean addAll(Collection<? extends E> collection) {
            throw new UnsupportedOperationException();
        }

        @Override
        @Deprecated
        public final boolean removeAll(Collection<?> collection) {
            throw new UnsupportedOperationException();
        }

        @Override
        @Deprecated
        public final boolean retainAll(Collection<?> collection) {
            throw new UnsupportedOperationException();
        }

        @Override
        @Deprecated
        public final void clear() {
            throw new UnsupportedOperationException();
        }
    }

    public static <E> SetView<E> union(final Set<? extends E> set, final Set<? extends E> set2) {
        Preconditions.checkNotNull(set, "set1");
        Preconditions.checkNotNull(set2, "set2");
        return new SetView<E>() {
            {
                super();
            }

            @Override
            public int size() {
                int size = set.size();
                Iterator<E> it = set2.iterator();
                while (it.hasNext()) {
                    if (!set.contains(it.next())) {
                        size++;
                    }
                }
                return size;
            }

            @Override
            public boolean isEmpty() {
                return set.isEmpty() && set2.isEmpty();
            }

            @Override
            public UnmodifiableIterator<E> iterator() {
                return new AbstractIterator<E>() {
                    final Iterator<? extends E> itr1;
                    final Iterator<? extends E> itr2;

                    {
                        this.itr1 = set.iterator();
                        this.itr2 = set2.iterator();
                    }

                    @Override
                    @CheckForNull
                    protected E computeNext() {
                        if (this.itr1.hasNext()) {
                            return this.itr1.next();
                        }
                        while (this.itr2.hasNext()) {
                            E next = this.itr2.next();
                            if (!set.contains(next)) {
                                return next;
                            }
                        }
                        return endOfData();
                    }
                };
            }

            @Override
            public boolean contains(@CheckForNull Object obj) {
                return set.contains(obj) || set2.contains(obj);
            }

            @Override
            public <S extends Set<E>> S copyInto(S s) {
                s.addAll(set);
                s.addAll(set2);
                return s;
            }

            @Override
            public ImmutableSet<E> immutableCopy() {
                return new ImmutableSet.Builder().addAll((Iterable) set).addAll((Iterable) set2).build();
            }
        };
    }

    public static <E> SetView<E> intersection(final Set<E> set, final Set<?> set2) {
        Preconditions.checkNotNull(set, "set1");
        Preconditions.checkNotNull(set2, "set2");
        return new SetView<E>() {
            {
                super();
            }

            @Override
            public UnmodifiableIterator<E> iterator() {
                return new AbstractIterator<E>() {
                    final Iterator<E> itr;

                    {
                        this.itr = set.iterator();
                    }

                    @Override
                    @CheckForNull
                    protected E computeNext() {
                        while (this.itr.hasNext()) {
                            E next = this.itr.next();
                            if (set2.contains(next)) {
                                return next;
                            }
                        }
                        return endOfData();
                    }
                };
            }

            @Override
            public int size() {
                Iterator<E> it = set.iterator();
                int i = 0;
                while (it.hasNext()) {
                    if (set2.contains(it.next())) {
                        i++;
                    }
                }
                return i;
            }

            @Override
            public boolean isEmpty() {
                return Collections.disjoint(set2, set);
            }

            @Override
            public boolean contains(@CheckForNull Object obj) {
                return set.contains(obj) && set2.contains(obj);
            }

            @Override
            public boolean containsAll(Collection<?> collection) {
                return set.containsAll(collection) && set2.containsAll(collection);
            }
        };
    }

    public static <E> SetView<E> difference(final Set<E> set, final Set<?> set2) {
        Preconditions.checkNotNull(set, "set1");
        Preconditions.checkNotNull(set2, "set2");
        return new SetView<E>() {
            {
                super();
            }

            @Override
            public UnmodifiableIterator<E> iterator() {
                return new AbstractIterator<E>() {
                    final Iterator<E> itr;

                    {
                        this.itr = set.iterator();
                    }

                    @Override
                    @CheckForNull
                    protected E computeNext() {
                        while (this.itr.hasNext()) {
                            E next = this.itr.next();
                            if (!set2.contains(next)) {
                                return next;
                            }
                        }
                        return endOfData();
                    }
                };
            }

            @Override
            public int size() {
                Iterator<E> it = set.iterator();
                int i = 0;
                while (it.hasNext()) {
                    if (!set2.contains(it.next())) {
                        i++;
                    }
                }
                return i;
            }

            @Override
            public boolean isEmpty() {
                return set2.containsAll(set);
            }

            @Override
            public boolean contains(@CheckForNull Object obj) {
                return set.contains(obj) && !set2.contains(obj);
            }
        };
    }

    public static <E> SetView<E> symmetricDifference(final Set<? extends E> set, final Set<? extends E> set2) {
        Preconditions.checkNotNull(set, "set1");
        Preconditions.checkNotNull(set2, "set2");
        return new SetView<E>() {
            {
                super();
            }

            @Override
            public UnmodifiableIterator<E> iterator() {
                final Iterator<E> it = set.iterator();
                final Iterator<E> it2 = set2.iterator();
                return new AbstractIterator<E>() {
                    @Override
                    @CheckForNull
                    public E computeNext() {
                        while (it.hasNext()) {
                            E e = (E) it.next();
                            if (!set2.contains(e)) {
                                return e;
                            }
                        }
                        while (it2.hasNext()) {
                            E e2 = (E) it2.next();
                            if (!set.contains(e2)) {
                                return e2;
                            }
                        }
                        return endOfData();
                    }
                };
            }

            @Override
            public int size() {
                Iterator<E> it = set.iterator();
                int i = 0;
                while (it.hasNext()) {
                    if (!set2.contains(it.next())) {
                        i++;
                    }
                }
                Iterator<E> it2 = set2.iterator();
                while (it2.hasNext()) {
                    if (!set.contains(it2.next())) {
                        i++;
                    }
                }
                return i;
            }

            @Override
            public boolean isEmpty() {
                return set.equals(set2);
            }

            @Override
            public boolean contains(@CheckForNull Object obj) {
                return set2.contains(obj) ^ set.contains(obj);
            }
        };
    }

    public static <E> Set<E> filter(Set<E> set, Predicate<? super E> predicate) {
        if (set instanceof SortedSet) {
            return filter((SortedSet) set, (Predicate) predicate);
        }
        if (set instanceof FilteredSet) {
            FilteredSet filteredSet = (FilteredSet) set;
            return new FilteredSet((Set) filteredSet.unfiltered, Predicates.and(filteredSet.predicate, predicate));
        }
        return new FilteredSet((Set) Preconditions.checkNotNull(set), (Predicate) Preconditions.checkNotNull(predicate));
    }

    public static <E> SortedSet<E> filter(SortedSet<E> sortedSet, Predicate<? super E> predicate) {
        if (sortedSet instanceof FilteredSet) {
            FilteredSet filteredSet = (FilteredSet) sortedSet;
            return new FilteredSortedSet((SortedSet) filteredSet.unfiltered, Predicates.and(filteredSet.predicate, predicate));
        }
        return new FilteredSortedSet((SortedSet) Preconditions.checkNotNull(sortedSet), (Predicate) Preconditions.checkNotNull(predicate));
    }

    public static <E> NavigableSet<E> filter(NavigableSet<E> navigableSet, Predicate<? super E> predicate) {
        if (navigableSet instanceof FilteredSet) {
            FilteredSet filteredSet = (FilteredSet) navigableSet;
            return new FilteredNavigableSet((NavigableSet) filteredSet.unfiltered, Predicates.and(filteredSet.predicate, predicate));
        }
        return new FilteredNavigableSet((NavigableSet) Preconditions.checkNotNull(navigableSet), (Predicate) Preconditions.checkNotNull(predicate));
    }

    private static class FilteredSet<E> extends Collections2.FilteredCollection<E> implements Set<E> {
        FilteredSet(Set<E> set, Predicate<? super E> predicate) {
            super(set, predicate);
        }

        @Override
        public boolean equals(@CheckForNull Object obj) {
            return Sets.equalsImpl(this, obj);
        }

        @Override
        public int hashCode() {
            return Sets.hashCodeImpl(this);
        }
    }

    private static class FilteredSortedSet<E> extends FilteredSet<E> implements SortedSet<E> {
        FilteredSortedSet(SortedSet<E> sortedSet, Predicate<? super E> predicate) {
            super(sortedSet, predicate);
        }

        @Override
        @CheckForNull
        public Comparator<? super E> comparator() {
            return ((SortedSet) this.unfiltered).comparator();
        }

        @Override
        public SortedSet<E> subSet(@ParametricNullness E e, @ParametricNullness E e2) {
            return new FilteredSortedSet(((SortedSet) this.unfiltered).subSet(e, e2), this.predicate);
        }

        @Override
        public SortedSet<E> headSet(@ParametricNullness E e) {
            return new FilteredSortedSet(((SortedSet) this.unfiltered).headSet(e), this.predicate);
        }

        @Override
        public SortedSet<E> tailSet(@ParametricNullness E e) {
            return new FilteredSortedSet(((SortedSet) this.unfiltered).tailSet(e), this.predicate);
        }

        @Override
        @ParametricNullness
        public E first() {
            return (E) Iterators.find(this.unfiltered.iterator(), this.predicate);
        }

        @ParametricNullness
        public E last() {
            SortedSet sortedSetHeadSet = (SortedSet) this.unfiltered;
            while (true) {
                E e = (Object) sortedSetHeadSet.last();
                if (this.predicate.apply(e)) {
                    return e;
                }
                sortedSetHeadSet = sortedSetHeadSet.headSet(e);
            }
        }
    }

    private static class FilteredNavigableSet<E> extends FilteredSortedSet<E> implements NavigableSet<E> {
        FilteredNavigableSet(NavigableSet<E> navigableSet, Predicate<? super E> predicate) {
            super(navigableSet, predicate);
        }

        NavigableSet<E> unfiltered() {
            return (NavigableSet) this.unfiltered;
        }

        @Override
        @CheckForNull
        public E lower(@ParametricNullness E e) {
            return (E) Iterators.find(unfiltered().headSet(e, false).descendingIterator(), this.predicate, null);
        }

        @Override
        @CheckForNull
        public E floor(@ParametricNullness E e) {
            return (E) Iterators.find(unfiltered().headSet(e, true).descendingIterator(), this.predicate, null);
        }

        @Override
        @CheckForNull
        public E ceiling(@ParametricNullness E e) {
            return (E) Iterables.find(unfiltered().tailSet(e, true), this.predicate, null);
        }

        @Override
        @CheckForNull
        public E higher(@ParametricNullness E e) {
            return (E) Iterables.find(unfiltered().tailSet(e, false), this.predicate, null);
        }

        @Override
        @CheckForNull
        public E pollFirst() {
            return (E) Iterables.removeFirstMatching(unfiltered(), this.predicate);
        }

        @Override
        @CheckForNull
        public E pollLast() {
            return (E) Iterables.removeFirstMatching(unfiltered().descendingSet(), this.predicate);
        }

        @Override
        public NavigableSet<E> descendingSet() {
            return Sets.filter((NavigableSet) unfiltered().descendingSet(), (Predicate) this.predicate);
        }

        @Override
        public Iterator<E> descendingIterator() {
            return Iterators.filter(unfiltered().descendingIterator(), this.predicate);
        }

        @Override
        @ParametricNullness
        public E last() {
            return (E) Iterators.find(unfiltered().descendingIterator(), this.predicate);
        }

        @Override
        public NavigableSet<E> subSet(@ParametricNullness E e, boolean z, @ParametricNullness E e2, boolean z2) {
            return Sets.filter((NavigableSet) unfiltered().subSet(e, z, e2, z2), (Predicate) this.predicate);
        }

        @Override
        public NavigableSet<E> headSet(@ParametricNullness E e, boolean z) {
            return Sets.filter((NavigableSet) unfiltered().headSet(e, z), (Predicate) this.predicate);
        }

        @Override
        public NavigableSet<E> tailSet(@ParametricNullness E e, boolean z) {
            return Sets.filter((NavigableSet) unfiltered().tailSet(e, z), (Predicate) this.predicate);
        }
    }

    public static <B> Set<List<B>> cartesianProduct(List<? extends Set<? extends B>> list) {
        return CartesianSet.create(list);
    }

    @SafeVarargs
    public static <B> Set<List<B>> cartesianProduct(Set<? extends B>... setArr) {
        return cartesianProduct(Arrays.asList(setArr));
    }

    private static final class CartesianSet<E> extends ForwardingCollection<List<E>> implements Set<List<E>> {
        private final transient ImmutableList<ImmutableSet<E>> axes;
        private final transient CartesianList<E> delegate;

        static <E> Set<List<E>> create(List<? extends Set<? extends E>> list) {
            ImmutableList.Builder builder = new ImmutableList.Builder(list.size());
            Iterator<? extends Set<? extends E>> it = list.iterator();
            while (it.hasNext()) {
                ImmutableSet immutableSetCopyOf = ImmutableSet.copyOf((Collection) it.next());
                if (immutableSetCopyOf.isEmpty()) {
                    return ImmutableSet.m207of();
                }
                builder.add(immutableSetCopyOf);
            }
            final ImmutableList<E> immutableListBuild = builder.build();
            return new CartesianSet(immutableListBuild, new CartesianList(new ImmutableList<List<E>>() {
                @Override
                boolean isPartialView() {
                    return true;
                }

                @Override
                public int size() {
                    return immutableListBuild.size();
                }

                @Override
                public List<E> get(int i) {
                    return ((ImmutableSet) immutableListBuild.get(i)).asList();
                }
            }));
        }

        private CartesianSet(ImmutableList<ImmutableSet<E>> immutableList, CartesianList<E> cartesianList) {
            this.axes = immutableList;
            this.delegate = cartesianList;
        }

        @Override
        public Collection<List<E>> delegate() {
            return this.delegate;
        }

        @Override
        public boolean contains(@CheckForNull Object obj) {
            if (!(obj instanceof List)) {
                return false;
            }
            List list = (List) obj;
            if (list.size() != this.axes.size()) {
                return false;
            }
            Iterator<E> it = list.iterator();
            int i = 0;
            while (it.hasNext()) {
                if (!this.axes.get(i).contains(it.next())) {
                    return false;
                }
                i++;
            }
            return true;
        }

        @Override
        public boolean equals(@CheckForNull Object obj) {
            if (obj instanceof CartesianSet) {
                return this.axes.equals(((CartesianSet) obj).axes);
            }
            return super.equals(obj);
        }

        @Override
        public int hashCode() {
            int i = 1;
            int size = size() - 1;
            for (int i2 = 0; i2 < this.axes.size(); i2++) {
                size = ~(~(size * 31));
            }
            UnmodifiableIterator<ImmutableSet<E>> it = this.axes.iterator();
            while (it.hasNext()) {
                ImmutableSet<E> next = it.next();
                i = ~(~((i * 31) + ((size() / next.size()) * next.hashCode())));
            }
            return ~(~(i + size));
        }
    }

    public static <E> Set<Set<E>> powerSet(Set<E> set) {
        return new PowerSet(set);
    }

    private static final class SubSet<E> extends AbstractSet<E> {
        private final ImmutableMap<E, Integer> inputSet;
        private final int mask;

        SubSet(ImmutableMap<E, Integer> immutableMap, int i) {
            this.inputSet = immutableMap;
            this.mask = i;
        }

        @Override
        public Iterator<E> iterator() {
            return new UnmodifiableIterator<E>() {
                final ImmutableList<E> elements;
                int remainingSetBits;

                {
                    this.elements = SubSet.this.inputSet.keySet().asList();
                    this.remainingSetBits = SubSet.this.mask;
                }

                @Override
                public boolean hasNext() {
                    return this.remainingSetBits != 0;
                }

                @Override
                public E next() {
                    int iNumberOfTrailingZeros = Integer.numberOfTrailingZeros(this.remainingSetBits);
                    if (iNumberOfTrailingZeros == 32) {
                        throw new NoSuchElementException();
                    }
                    this.remainingSetBits &= ~(1 << iNumberOfTrailingZeros);
                    return this.elements.get(iNumberOfTrailingZeros);
                }
            };
        }

        @Override
        public int size() {
            return Integer.bitCount(this.mask);
        }

        @Override
        public boolean contains(@CheckForNull Object obj) {
            Integer num = this.inputSet.get(obj);
            if (num != null) {
                if (((1 << num.intValue()) & this.mask) != 0) {
                    return true;
                }
            }
            return false;
        }
    }

    private static final class PowerSet<E> extends AbstractSet<Set<E>> {
        final ImmutableMap<E, Integer> inputSet;

        @Override
        public boolean isEmpty() {
            return false;
        }

        PowerSet(Set<E> set) {
            Preconditions.checkArgument(set.size() <= 30, "Too many elements to create power set: %s > 30", set.size());
            this.inputSet = Maps.indexMap(set);
        }

        @Override
        public int size() {
            return 1 << this.inputSet.size();
        }

        @Override
        public Iterator<Set<E>> iterator() {
            return new AbstractIndexedListIterator<Set<E>>(size()) {
                @Override
                public Set<E> get(int i) {
                    return new SubSet(PowerSet.this.inputSet, i);
                }
            };
        }

        @Override
        public boolean contains(@CheckForNull Object obj) {
            if (!(obj instanceof Set)) {
                return false;
            }
            return this.inputSet.keySet().containsAll((Set) obj);
        }

        @Override
        public boolean equals(@CheckForNull Object obj) {
            if (obj instanceof PowerSet) {
                return this.inputSet.keySet().equals(((PowerSet) obj).inputSet.keySet());
            }
            return super.equals(obj);
        }

        @Override
        public int hashCode() {
            return this.inputSet.keySet().hashCode() << (this.inputSet.size() - 1);
        }

        @Override
        public String toString() {
            String strValueOf = String.valueOf(this.inputSet);
            StringBuilder sb = new StringBuilder(String.valueOf(strValueOf).length() + 10);
            sb.append("powerSet(");
            sb.append(strValueOf);
            sb.append(")");
            return sb.toString();
        }
    }

    public static <E> Set<Set<E>> combinations(Set<E> set, int i) {
        ImmutableMap immutableMapIndexMap = Maps.indexMap(set);
        CollectPreconditions.checkNonnegative(i, "size");
        Preconditions.checkArgument(i <= immutableMapIndexMap.size(), "size (%s) must be <= set.size() (%s)", i, immutableMapIndexMap.size());
        if (i == 0) {
            return ImmutableSet.m208of(ImmutableSet.m207of());
        }
        if (i == immutableMapIndexMap.size()) {
            return ImmutableSet.m208of(immutableMapIndexMap.keySet());
        }
        return new C05465(i, immutableMapIndexMap);
    }

    class C05465<E> extends AbstractSet<Set<E>> {
        final ImmutableMap val$index;
        final int val$size;

        C05465(int i, ImmutableMap immutableMap) {
            this.val$size = i;
            this.val$index = immutableMap;
        }

        @Override
        public boolean contains(@CheckForNull Object obj) {
            if (!(obj instanceof Set)) {
                return false;
            }
            Set set = (Set) obj;
            return set.size() == this.val$size && this.val$index.keySet().containsAll(set);
        }

        class AnonymousClass1 extends AbstractIterator<Set<E>> {
            final BitSet bits;

            AnonymousClass1() {
                this.bits = new BitSet(C05465.this.val$index.size());
            }

            @Override
            @CheckForNull
            public Set<E> computeNext() {
                if (this.bits.isEmpty()) {
                    this.bits.set(0, C05465.this.val$size);
                } else {
                    int iNextSetBit = this.bits.nextSetBit(0);
                    int iNextClearBit = this.bits.nextClearBit(iNextSetBit);
                    if (iNextClearBit == C05465.this.val$index.size()) {
                        return endOfData();
                    }
                    int i = (iNextClearBit - iNextSetBit) - 1;
                    this.bits.set(0, i);
                    this.bits.clear(i, iNextClearBit);
                    this.bits.set(iNextClearBit);
                }
                final BitSet bitSet = (BitSet) this.bits.clone();
                return new AbstractSet<E>() {
                    @Override
                    public boolean contains(@CheckForNull Object obj) {
                        Integer num = (Integer) C05465.this.val$index.get(obj);
                        return num != null && bitSet.get(num.intValue());
                    }

                    @Override
                    public Iterator<E> iterator() {
                        return new AbstractIterator<E>() {

                            int f120i = -1;

                            @Override
                            @CheckForNull
                            protected E computeNext() {
                                int iNextSetBit2 = bitSet.nextSetBit(this.f120i + 1);
                                this.f120i = iNextSetBit2;
                                if (iNextSetBit2 == -1) {
                                    return endOfData();
                                }
                                return C05465.this.val$index.keySet().asList().get(this.f120i);
                            }
                        };
                    }

                    @Override
                    public int size() {
                        return C05465.this.val$size;
                    }
                };
            }
        }

        @Override
        public Iterator<Set<E>> iterator() {
            return new AnonymousClass1();
        }

        @Override
        public int size() {
            return IntMath.binomial(this.val$index.size(), this.val$size);
        }

        @Override
        public String toString() {
            String strValueOf = String.valueOf(this.val$index.keySet());
            int i = this.val$size;
            StringBuilder sb = new StringBuilder(String.valueOf(strValueOf).length() + 32);
            sb.append("Sets.combinations(");
            sb.append(strValueOf);
            sb.append(", ");
            sb.append(i);
            sb.append(")");
            return sb.toString();
        }
    }

    static int hashCodeImpl(Set<?> set) {
        Iterator<?> it = set.iterator();
        int i = 0;
        while (it.hasNext()) {
            Object next = it.next();
            i = ~(~(i + (next != null ? next.hashCode() : 0)));
        }
        return i;
    }

    static boolean equalsImpl(Set<?> set, @CheckForNull Object obj) {
        if (set == obj) {
            return true;
        }
        if (obj instanceof Set) {
            Set set2 = (Set) obj;
            try {
                return set.size() == set2.size() && set.containsAll(set2);
            } catch (ClassCastException | NullPointerException unused) {
            }
        }
        return false;
    }

    public static <E> NavigableSet<E> unmodifiableNavigableSet(NavigableSet<E> navigableSet) {
        return ((navigableSet instanceof ImmutableCollection) || (navigableSet instanceof UnmodifiableNavigableSet)) ? navigableSet : new UnmodifiableNavigableSet(navigableSet);
    }

    static final class UnmodifiableNavigableSet<E> extends ForwardingSortedSet<E> implements NavigableSet<E>, Serializable {
        private static final long serialVersionUID = 0;
        private final NavigableSet<E> delegate;

        @CheckForNull
        private transient UnmodifiableNavigableSet<E> descendingSet;
        private final SortedSet<E> unmodifiableDelegate;

        UnmodifiableNavigableSet(NavigableSet<E> navigableSet) {
            this.delegate = (NavigableSet) Preconditions.checkNotNull(navigableSet);
            this.unmodifiableDelegate = Collections.unmodifiableSortedSet(navigableSet);
        }

        @Override
        public SortedSet<E> delegate() {
            return this.unmodifiableDelegate;
        }

        @Override
        @CheckForNull
        public E lower(@ParametricNullness E e) {
            return this.delegate.lower(e);
        }

        @Override
        @CheckForNull
        public E floor(@ParametricNullness E e) {
            return this.delegate.floor(e);
        }

        @Override
        @CheckForNull
        public E ceiling(@ParametricNullness E e) {
            return this.delegate.ceiling(e);
        }

        @Override
        @CheckForNull
        public E higher(@ParametricNullness E e) {
            return this.delegate.higher(e);
        }

        @Override
        @CheckForNull
        public E pollFirst() {
            throw new UnsupportedOperationException();
        }

        @Override
        @CheckForNull
        public E pollLast() {
            throw new UnsupportedOperationException();
        }

        @Override
        public NavigableSet<E> descendingSet() {
            UnmodifiableNavigableSet<E> unmodifiableNavigableSet = this.descendingSet;
            if (unmodifiableNavigableSet != null) {
                return unmodifiableNavigableSet;
            }
            UnmodifiableNavigableSet<E> unmodifiableNavigableSet2 = new UnmodifiableNavigableSet<>(this.delegate.descendingSet());
            this.descendingSet = unmodifiableNavigableSet2;
            unmodifiableNavigableSet2.descendingSet = this;
            return unmodifiableNavigableSet2;
        }

        @Override
        public Iterator<E> descendingIterator() {
            return Iterators.unmodifiableIterator(this.delegate.descendingIterator());
        }

        @Override
        public NavigableSet<E> subSet(@ParametricNullness E e, boolean z, @ParametricNullness E e2, boolean z2) {
            return Sets.unmodifiableNavigableSet(this.delegate.subSet(e, z, e2, z2));
        }

        @Override
        public NavigableSet<E> headSet(@ParametricNullness E e, boolean z) {
            return Sets.unmodifiableNavigableSet(this.delegate.headSet(e, z));
        }

        @Override
        public NavigableSet<E> tailSet(@ParametricNullness E e, boolean z) {
            return Sets.unmodifiableNavigableSet(this.delegate.tailSet(e, z));
        }
    }

    public static <E> NavigableSet<E> synchronizedNavigableSet(NavigableSet<E> navigableSet) {
        return Synchronized.navigableSet(navigableSet);
    }

    static boolean removeAllImpl(Set<?> set, Iterator<?> it) {
        boolean zRemove = false;
        while (it.hasNext()) {
            zRemove |= set.remove(it.next());
        }
        return zRemove;
    }

    static boolean removeAllImpl(Set<?> set, Collection<?> collection) {
        Preconditions.checkNotNull(collection);
        if (collection instanceof Multiset) {
            collection = ((Multiset) collection).elementSet();
        }
        if ((collection instanceof Set) && collection.size() > set.size()) {
            return Iterators.removeAll(set.iterator(), collection);
        }
        return removeAllImpl(set, collection.iterator());
    }

    static class DescendingSet<E> extends ForwardingNavigableSet<E> {
        private final NavigableSet<E> forward;

        DescendingSet(NavigableSet<E> navigableSet) {
            this.forward = navigableSet;
        }

        @Override
        public NavigableSet<E> delegate() {
            return this.forward;
        }

        @Override
        @CheckForNull
        public E lower(@ParametricNullness E e) {
            return this.forward.higher(e);
        }

        @Override
        @CheckForNull
        public E floor(@ParametricNullness E e) {
            return this.forward.ceiling(e);
        }

        @Override
        @CheckForNull
        public E ceiling(@ParametricNullness E e) {
            return this.forward.floor(e);
        }

        @Override
        @CheckForNull
        public E higher(@ParametricNullness E e) {
            return this.forward.lower(e);
        }

        @Override
        @CheckForNull
        public E pollFirst() {
            return this.forward.pollLast();
        }

        @Override
        @CheckForNull
        public E pollLast() {
            return this.forward.pollFirst();
        }

        @Override
        public NavigableSet<E> descendingSet() {
            return this.forward;
        }

        @Override
        public Iterator<E> descendingIterator() {
            return this.forward.iterator();
        }

        @Override
        public NavigableSet<E> subSet(@ParametricNullness E e, boolean z, @ParametricNullness E e2, boolean z2) {
            return this.forward.subSet(e2, z2, e, z).descendingSet();
        }

        @Override
        public SortedSet<E> subSet(@ParametricNullness E e, @ParametricNullness E e2) {
            return standardSubSet(e, e2);
        }

        @Override
        public NavigableSet<E> headSet(@ParametricNullness E e, boolean z) {
            return this.forward.tailSet(e, z).descendingSet();
        }

        @Override
        public SortedSet<E> headSet(@ParametricNullness E e) {
            return standardHeadSet(e);
        }

        @Override
        public NavigableSet<E> tailSet(@ParametricNullness E e, boolean z) {
            return this.forward.headSet(e, z).descendingSet();
        }

        @Override
        public SortedSet<E> tailSet(@ParametricNullness E e) {
            return standardTailSet(e);
        }

        @Override
        public Comparator<? super E> comparator() {
            Comparator<? super E> comparator = this.forward.comparator();
            if (comparator == null) {
                return Ordering.natural().reverse();
            }
            return reverse(comparator);
        }

        private static <T> Ordering<T> reverse(Comparator<T> comparator) {
            return Ordering.from(comparator).reverse();
        }

        @Override
        @ParametricNullness
        public E first() {
            return this.forward.last();
        }

        @Override
        @ParametricNullness
        public E last() {
            return this.forward.first();
        }

        @Override
        public Iterator<E> iterator() {
            return this.forward.descendingIterator();
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

    public static <K extends Comparable<? super K>> NavigableSet<K> subSet(NavigableSet<K> navigableSet, Range<K> range) {
        if (navigableSet.comparator() != null && navigableSet.comparator() != Ordering.natural() && range.hasLowerBound() && range.hasUpperBound()) {
            Preconditions.checkArgument(navigableSet.comparator().compare(range.lowerEndpoint(), range.upperEndpoint()) <= 0, "set is using a custom comparator which is inconsistent with the natural ordering.");
        }
        if (range.hasLowerBound() && range.hasUpperBound()) {
            return navigableSet.subSet(range.lowerEndpoint(), range.lowerBoundType() == BoundType.CLOSED, range.upperEndpoint(), range.upperBoundType() == BoundType.CLOSED);
        }
        if (range.hasLowerBound()) {
            return navigableSet.tailSet(range.lowerEndpoint(), range.lowerBoundType() == BoundType.CLOSED);
        }
        if (range.hasUpperBound()) {
            return navigableSet.headSet(range.upperEndpoint(), range.upperBoundType() == BoundType.CLOSED);
        }
        return (NavigableSet) Preconditions.checkNotNull(navigableSet);
    }
}
