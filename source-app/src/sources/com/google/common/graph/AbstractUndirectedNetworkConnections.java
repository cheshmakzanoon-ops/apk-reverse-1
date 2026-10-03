package com.google.common.graph;

import com.google.common.base.Preconditions;
import j$.util.Objects;
import java.util.Collections;
import java.util.Map;
import java.util.Set;
import javax.annotation.CheckForNull;

@ElementTypesAreNonnullByDefault
abstract class AbstractUndirectedNetworkConnections<N, E> implements NetworkConnections<N, E> {
    final Map<E, N> incidentEdgeMap;

    AbstractUndirectedNetworkConnections(Map<E, N> map) {
        this.incidentEdgeMap = (Map) Preconditions.checkNotNull(map);
    }

    @Override
    public Set<N> predecessors() {
        return adjacentNodes();
    }

    @Override
    public Set<N> successors() {
        return adjacentNodes();
    }

    @Override
    public Set<E> incidentEdges() {
        return Collections.unmodifiableSet(this.incidentEdgeMap.keySet());
    }

    @Override
    public Set<E> inEdges() {
        return incidentEdges();
    }

    @Override
    public Set<E> outEdges() {
        return incidentEdges();
    }

    @Override
    public N adjacentNode(E e) {
        return (N) Objects.requireNonNull(this.incidentEdgeMap.get(e));
    }

    @Override
    @CheckForNull
    public N removeInEdge(E e, boolean z) {
        if (z) {
            return null;
        }
        return removeOutEdge(e);
    }

    @Override
    public N removeOutEdge(E e) {
        return (N) Objects.requireNonNull(this.incidentEdgeMap.remove(e));
    }

    @Override
    public void addInEdge(E e, N n, boolean z) {
        if (z) {
            return;
        }
        addOutEdge(e, n);
    }

    @Override
    public void addOutEdge(E e, N n) {
        Preconditions.checkState(this.incidentEdgeMap.put(e, n) == null);
    }
}
