package com.google.common.graph;

import com.google.common.base.Preconditions;
import com.google.common.collect.Iterables;
import com.google.common.collect.Iterators;
import com.google.common.collect.Sets;
import com.google.common.collect.UnmodifiableIterator;
import com.google.common.math.IntMath;
import j$.util.Objects;
import java.util.AbstractSet;
import java.util.Collections;
import java.util.Map;
import java.util.Set;
import javax.annotation.CheckForNull;

@ElementTypesAreNonnullByDefault
abstract class AbstractDirectedNetworkConnections<N, E> implements NetworkConnections<N, E> {
    final Map<E, N> inEdgeMap;
    final Map<E, N> outEdgeMap;
    private int selfLoopCount;

    AbstractDirectedNetworkConnections(Map<E, N> map, Map<E, N> map2, int i) {
        this.inEdgeMap = (Map) Preconditions.checkNotNull(map);
        this.outEdgeMap = (Map) Preconditions.checkNotNull(map2);
        this.selfLoopCount = Graphs.checkNonNegative(i);
        Preconditions.checkState(i <= map.size() && i <= map2.size());
    }

    @Override
    public Set<N> adjacentNodes() {
        return Sets.union(predecessors(), successors());
    }

    @Override
    public Set<E> incidentEdges() {
        return new AbstractSet<E>() {
            @Override
            public UnmodifiableIterator<E> iterator() {
                Iterable iterableUnion;
                if (AbstractDirectedNetworkConnections.this.selfLoopCount == 0) {
                    iterableUnion = Iterables.concat(AbstractDirectedNetworkConnections.this.inEdgeMap.keySet(), AbstractDirectedNetworkConnections.this.outEdgeMap.keySet());
                } else {
                    iterableUnion = Sets.union(AbstractDirectedNetworkConnections.this.inEdgeMap.keySet(), AbstractDirectedNetworkConnections.this.outEdgeMap.keySet());
                }
                return Iterators.unmodifiableIterator(iterableUnion.iterator());
            }

            @Override
            public int size() {
                return IntMath.saturatedAdd(AbstractDirectedNetworkConnections.this.inEdgeMap.size(), AbstractDirectedNetworkConnections.this.outEdgeMap.size() - AbstractDirectedNetworkConnections.this.selfLoopCount);
            }

            @Override
            public boolean contains(@CheckForNull Object obj) {
                return AbstractDirectedNetworkConnections.this.inEdgeMap.containsKey(obj) || AbstractDirectedNetworkConnections.this.outEdgeMap.containsKey(obj);
            }
        };
    }

    @Override
    public Set<E> inEdges() {
        return Collections.unmodifiableSet(this.inEdgeMap.keySet());
    }

    @Override
    public Set<E> outEdges() {
        return Collections.unmodifiableSet(this.outEdgeMap.keySet());
    }

    @Override
    public N adjacentNode(E e) {
        return (N) Objects.requireNonNull(this.outEdgeMap.get(e));
    }

    @Override
    public N removeInEdge(E e, boolean z) {
        if (z) {
            int i = this.selfLoopCount - 1;
            this.selfLoopCount = i;
            Graphs.checkNonNegative(i);
        }
        return (N) Objects.requireNonNull(this.inEdgeMap.remove(e));
    }

    @Override
    public N removeOutEdge(E e) {
        return (N) Objects.requireNonNull(this.outEdgeMap.remove(e));
    }

    @Override
    public void addInEdge(E e, N n, boolean z) {
        Preconditions.checkNotNull(e);
        Preconditions.checkNotNull(n);
        if (z) {
            int i = this.selfLoopCount + 1;
            this.selfLoopCount = i;
            Graphs.checkPositive(i);
        }
        Preconditions.checkState(this.inEdgeMap.put(e, n) == null);
    }

    @Override
    public void addOutEdge(E e, N n) {
        Preconditions.checkNotNull(e);
        Preconditions.checkNotNull(n);
        Preconditions.checkState(this.outEdgeMap.put(e, n) == null);
    }
}
