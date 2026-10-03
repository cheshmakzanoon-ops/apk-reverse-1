package com.google.common.graph;

import java.util.Set;
import javax.annotation.CheckForNull;

@ElementTypesAreNonnullByDefault
public interface ValueGraph<N, V> extends BaseGraph<N> {
    @Override
    Set<N> adjacentNodes(N n);

    @Override
    boolean allowsSelfLoops();

    Graph<N> asGraph();

    @Override
    int degree(N n);

    @CheckForNull
    V edgeValueOrDefault(EndpointPair<N> endpointPair, @CheckForNull V v);

    @CheckForNull
    V edgeValueOrDefault(N n, N n2, @CheckForNull V v);

    @Override
    Set<EndpointPair<N>> edges();

    boolean equals(@CheckForNull Object obj);

    @Override
    boolean hasEdgeConnecting(EndpointPair<N> endpointPair);

    @Override
    boolean hasEdgeConnecting(N n, N n2);

    int hashCode();

    @Override
    int inDegree(N n);

    @Override
    ElementOrder<N> incidentEdgeOrder();

    @Override
    Set<EndpointPair<N>> incidentEdges(N n);

    @Override
    boolean isDirected();

    @Override
    ElementOrder<N> nodeOrder();

    @Override
    Set<N> nodes();

    @Override
    int outDegree(N n);

    @Override
    Set<N> predecessors(N n);

    @Override
    Set<N> successors(N n);

    public final class CC {
    }
}
