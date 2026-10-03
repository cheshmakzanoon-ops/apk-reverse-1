package com.google.common.collect;

import java.lang.Comparable;
import java.util.Iterator;
import javax.annotation.CheckForNull;

@ElementTypesAreNonnullByDefault
abstract class AbstractRangeSet<C extends Comparable> implements RangeSet<C> {
    @Override
    public abstract boolean encloses(Range<C> range);

    @Override
    @CheckForNull
    public abstract Range<C> rangeContaining(C c);

    AbstractRangeSet() {
    }

    @Override
    public boolean contains(C c) {
        return rangeContaining(c) != null;
    }

    @Override
    public boolean isEmpty() {
        return asRanges().isEmpty();
    }

    @Override
    public void add(Range<C> range) {
        throw new UnsupportedOperationException();
    }

    @Override
    public void remove(Range<C> range) {
        throw new UnsupportedOperationException();
    }

    @Override
    public void clear() {
        remove(Range.all());
    }

    @Override
    public boolean enclosesAll(RangeSet<C> rangeSet) {
        return enclosesAll(rangeSet.asRanges());
    }

    @Override
    public boolean enclosesAll(Iterable<Range<C>> iterable) {
        Iterator<Range<C>> it = iterable.iterator();
        while (it.hasNext()) {
            if (!encloses(it.next())) {
                return false;
            }
        }
        return true;
    }

    @Override
    public void addAll(RangeSet<C> rangeSet) {
        addAll(rangeSet.asRanges());
    }

    @Override
    public void addAll(Iterable<Range<C>> iterable) {
        Iterator<Range<C>> it = iterable.iterator();
        while (it.hasNext()) {
            add(it.next());
        }
    }

    @Override
    public void removeAll(RangeSet<C> rangeSet) {
        removeAll(rangeSet.asRanges());
    }

    @Override
    public void removeAll(Iterable<Range<C>> iterable) {
        Iterator<Range<C>> it = iterable.iterator();
        while (it.hasNext()) {
            remove(it.next());
        }
    }

    @Override
    public boolean intersects(Range<C> range) {
        return !subRangeSet(range).isEmpty();
    }

    @Override
    public boolean equals(@CheckForNull Object obj) {
        if (obj == this) {
            return true;
        }
        if (obj instanceof RangeSet) {
            return asRanges().equals(((RangeSet) obj).asRanges());
        }
        return false;
    }

    @Override
    public final int hashCode() {
        return asRanges().hashCode();
    }

    @Override
    public final String toString() {
        return asRanges().toString();
    }
}
