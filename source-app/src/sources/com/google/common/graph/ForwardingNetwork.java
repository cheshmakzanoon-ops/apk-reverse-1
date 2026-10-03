package com.google.common.graph;

import java.util.Set;
import javax.annotation.CheckForNull;

@ElementTypesAreNonnullByDefault
abstract class ForwardingNetwork<N, E> extends AbstractNetwork<N, E> {
    abstract Network<N, E> delegate();

    ForwardingNetwork() {
    }

    @Override
    public Set<N> nodes() {
        return delegate().nodes();
    }

    @Override
    public Set<E> edges() {
        return delegate().edges();
    }

    @Override
    public boolean isDirected() {
        return delegate().isDirected();
    }

    @Override
    public boolean allowsParallelEdges() {
        return delegate().allowsParallelEdges();
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
    public ElementOrder<E> edgeOrder() {
        return delegate().edgeOrder();
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
    public Set<E> incidentEdges(N n) {
        return delegate().incidentEdges(n);
    }

    @Override
    public Set<E> inEdges(N n) {
        return delegate().inEdges(n);
    }

    @Override
    public Set<E> outEdges(N n) {
        return delegate().outEdges(n);
    }

    @Override
    public EndpointPair<N> incidentNodes(E e) {
        return delegate().incidentNodes(e);
    }

    @Override
    public Set<E> adjacentEdges(E e) {
        return delegate().adjacentEdges(e);
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
    public Set<E> edgesConnecting(N n, N n2) {
        return delegate().edgesConnecting(n, n2);
    }

    @Override
    public Set<E> edgesConnecting(EndpointPair<N> endpointPair) {
        return delegate().edgesConnecting(endpointPair);
    }

    @Override
    @CheckForNull
    public E edgeConnectingOrNull(N n, N n2) {
        return delegate().edgeConnectingOrNull(n, n2);
    }

    @Override
    @CheckForNull
    public E edgeConnectingOrNull(EndpointPair<N> endpointPair) {
        return delegate().edgeConnectingOrNull(endpointPair);
    }

    @Override
    public boolean hasEdgeConnecting(N n, N n2) {
        return delegate().hasEdgeConnecting(n, n2);
    }

    @Override
    public boolean hasEdgeConnecting(EndpointPair<N> endpointPair) {
        return delegate().hasEdgeConnecting(endpointPair);
    }
}
