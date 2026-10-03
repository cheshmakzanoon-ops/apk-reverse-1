package com.google.common.graph;

import java.util.Set;
import javax.annotation.CheckForNull;

@ElementTypesAreNonnullByDefault
abstract class ForwardingValueGraph<N, V> extends AbstractValueGraph<N, V> {
    abstract ValueGraph<N, V> delegate();

    ForwardingValueGraph() {
    }

    @Override
    public Set<N> nodes() {
        return delegate().nodes();
    }

    @Override
    protected long edgeCount() {
        return delegate().edges().size();
    }

    @Override
    public boolean isDirected() {
        return delegate().isDirected();
    }

    @Override
    public boolean allowsSelfLoops() {
        return delegate().allowsSelfLoops();
    }

    @Override
    public ElementOrder<N> nodeOrder() {
        return delegate().nodeOrder();
    }

    @Override
    public ElementOrder<N> incidentEdgeOrder() {
        return delegate().incidentEdgeOrder();
    }

    @Override
    public Set<N> adjacentNodes(N n) {
        return delegate().adjacentNodes(n);
    }

    @Override
    public Set<N> predecessors(N n) {
        return delegate().predecessors((Object) n);
    }

    @Override
    public Set<N> successors(N n) {
        return delegate().successors((Object) n);
    }

    @Override
    public int degree(N n) {
        return delegate().degree(n);
    }

    @Override
    public int inDegree(N n) {
        return delegate().inDegree(n);
    }

    @Override
    public int outDegree(N n) {
        return delegate().outDegree(n);
    }

    @Override
    public boolean hasEdgeConnecting(N n, N n2) {
        return delegate().hasEdgeConnecting(n, n2);
    }

    @Override
    public boolean hasEdgeConnecting(EndpointPair<N> endpointPair) {
        return delegate().hasEdgeConnecting(endpointPair);
    }

    @Override
    @CheckForNull
    public V edgeValueOrDefault(N n, N n2, @CheckForNull V v) {
        return delegate().edgeValueOrDefault(n, n2, v);
    }

    @Override
    @CheckForNull
    public V edgeValueOrDefault(EndpointPair<N> endpointPair, @CheckForNull V v) {
        return delegate().edgeValueOrDefault(endpointPair, v);
    }
}
