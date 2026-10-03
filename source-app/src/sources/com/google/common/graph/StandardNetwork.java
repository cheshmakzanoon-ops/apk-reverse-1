package com.google.common.graph;

import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;
import j$.util.Objects;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;

@ElementTypesAreNonnullByDefault
class StandardNetwork<N, E> extends AbstractNetwork<N, E> {
    private final boolean allowsParallelEdges;
    private final boolean allowsSelfLoops;
    private final ElementOrder<E> edgeOrder;
    final MapIteratorCache<E, N> edgeToReferenceNode;
    private final boolean isDirected;
    final MapIteratorCache<N, NetworkConnections<N, E>> nodeConnections;
    private final ElementOrder<N> nodeOrder;

    StandardNetwork(NetworkBuilder<? super N, ? super E> networkBuilder) {
        this(networkBuilder, networkBuilder.nodeOrder.createMap(networkBuilder.expectedNodeCount.mo127or(10).intValue()), networkBuilder.edgeOrder.createMap(networkBuilder.expectedEdgeCount.mo127or(20).intValue()));
    }

    StandardNetwork(NetworkBuilder<? super N, ? super E> networkBuilder, Map<N, NetworkConnections<N, E>> map, Map<E, N> map2) {
        MapIteratorCache<N, NetworkConnections<N, E>> mapIteratorCache;
        this.isDirected = networkBuilder.directed;
        this.allowsParallelEdges = networkBuilder.allowsParallelEdges;
        this.allowsSelfLoops = networkBuilder.allowsSelfLoops;
        this.nodeOrder = (ElementOrder<N>) networkBuilder.nodeOrder.cast();
        this.edgeOrder = (ElementOrder<E>) networkBuilder.edgeOrder.cast();
        if (map instanceof TreeMap) {
            mapIteratorCache = new MapRetrievalCache<>(map);
        } else {
            mapIteratorCache = new MapIteratorCache<>(map);
        }
        this.nodeConnections = mapIteratorCache;
        this.edgeToReferenceNode = new MapIteratorCache<>(map2);
    }

    @Override
    public Set<N> nodes() {
        return this.nodeConnections.unmodifiableKeySet();
    }

    @Override
    public Set<E> edges() {
        return this.edgeToReferenceNode.unmodifiableKeySet();
    }

    @Override
    public boolean isDirected() {
        return this.isDirected;
    }

    @Override
    public boolean allowsParallelEdges() {
        return this.allowsParallelEdges;
    }

    @Override
    public boolean allowsSelfLoops() {
        return this.allowsSelfLoops;
    }

    @Override
    public ElementOrder<N> nodeOrder() {
        return this.nodeOrder;
    }

    @Override
    public ElementOrder<E> edgeOrder() {
        return this.edgeOrder;
    }

    @Override
    public Set<E> incidentEdges(N n) {
        return checkedConnections(n).incidentEdges();
    }

    @Override
    public EndpointPair<N> incidentNodes(E e) {
        N nCheckedReferenceNode = checkedReferenceNode(e);
        return EndpointPair.m274of(this, nCheckedReferenceNode, ((NetworkConnections) Objects.requireNonNull(this.nodeConnections.get(nCheckedReferenceNode))).adjacentNode(e));
    }

    @Override
    public Set<N> adjacentNodes(N n) {
        return checkedConnections(n).adjacentNodes();
    }

    @Override
    public Set<E> edgesConnecting(N n, N n2) {
        NetworkConnections<N, E> networkConnectionsCheckedConnections = checkedConnections(n);
        if (!this.allowsSelfLoops && n == n2) {
            return ImmutableSet.m207of();
        }
        Preconditions.checkArgument(containsNode(n2), "Node %s is not an element of this graph.", n2);
        return networkConnectionsCheckedConnections.edgesConnecting(n2);
    }

    @Override
    public Set<E> inEdges(N n) {
        return checkedConnections(n).inEdges();
    }

    @Override
    public Set<E> outEdges(N n) {
        return checkedConnections(n).outEdges();
    }

    @Override
    public Set<N> predecessors(N n) {
        return checkedConnections(n).predecessors();
    }

    @Override
    public Set<N> successors(N n) {
        return checkedConnections(n).successors();
    }

    final NetworkConnections<N, E> checkedConnections(N n) {
        NetworkConnections<N, E> networkConnections = this.nodeConnections.get(n);
        if (networkConnections != null) {
            return networkConnections;
        }
        Preconditions.checkNotNull(n);
        throw new IllegalArgumentException(String.format("Node %s is not an element of this graph.", n));
    }

    final N checkedReferenceNode(E e) {
        N n = this.edgeToReferenceNode.get(e);
        if (n != null) {
            return n;
        }
        Preconditions.checkNotNull(e);
        throw new IllegalArgumentException(String.format("Edge %s is not an element of this graph.", e));
    }

    final boolean containsNode(N n) {
        return this.nodeConnections.containsKey(n);
    }

    final boolean containsEdge(E e) {
        return this.edgeToReferenceNode.containsKey(e);
    }
}
