package com.google.common.graph;

import com.google.errorprone.annotations.DoNotMock;
import java.util.Set;
import javax.annotation.CheckForNull;

@DoNotMock("Use GraphBuilder to create a real instance")
@ElementTypesAreNonnullByDefault
public interface Graph<N> extends BaseGraph<N> {
    Set<N> adjacentNodes(N n);

    boolean allowsSelfLoops();

    @Override
    int degree(N n);

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

    boolean isDirected();

    ElementOrder<N> nodeOrder();

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
