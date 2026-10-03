package com.google.common.collect;

import com.google.errorprone.annotations.DoNotMock;
import java.util.Iterator;

@DoNotMock("Use Iterators.peekingIterator")
@ElementTypesAreNonnullByDefault
public interface PeekingIterator<E> extends Iterator<E> {
    @Override
    @ParametricNullness
    E next();

    @ParametricNullness
    E peek();

    @Override
    void remove();
}
