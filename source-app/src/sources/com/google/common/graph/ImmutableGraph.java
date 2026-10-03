package com.google.common.graph;

import com.google.common.base.Function;
import com.google.common.base.Functions;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Maps;
import com.google.errorprone.annotations.Immutable;
import java.util.Set;

@Immutable(containerOf = {"N"})
@ElementTypesAreNonnullByDefault
public class ImmutableGraph<N> extends ForwardingGraph<N> {
    private final BaseGraph<N> backingGraph;

    @Override
    public Set adjacentNodes(Object obj) {
        return super.adjacentNodes(obj);
    }

    @Override
    public boolean allowsSelfLoops() {
        return super.allowsSelfLoops();
    }

    @Override
    public int degree(Object obj) {
        return super.degree(obj);
    }

    @Override
    public boolean hasEdgeConnecting(EndpointPair endpointPair) {
        return super.hasEdgeConnecting(endpointPair);
    }

    @Override
    public boolean hasEdgeConnecting(Object obj, Object obj2) {
        return super.hasEdgeConnecting(obj, obj2);
    }

    @Override
    public int inDegree(Object obj) {
        return super.inDegree(obj);
    }

    @Override
    public Set incidentEdges(Object obj) {
        return super.incidentEdges(obj);
    }

    @Override
    public boolean isDirected() {
        return super.isDirected();
    }

    @Override
    public ElementOrder nodeOrder() {
        return super.nodeOrder();
    }

    @Override
    public Set nodes() {
        return super.nodes();
    }

    @Override
    public int outDegree(Object obj) {
        return super.outDegree(obj);
    }

    @Override
    public Set predecessors(Object obj) {
        return super.predecessors(obj);
    }

    @Override
    public Set successors(Object obj) {
        return super.successors(obj);
    }

    ImmutableGraph(BaseGraph<N> baseGraph) {
        this.backingGraph = baseGraph;
    }

    public static <N> ImmutableGraph<N> copyOf(Graph<N> graph) {
        if (graph instanceof ImmutableGraph) {
            return (ImmutableGraph) graph;
        }
        return new ImmutableGraph<>(new StandardValueGraph(GraphBuilder.from(graph), getNodeConnections(graph), graph.edges().size()));
    }

    @Deprecated
    public static <N> ImmutableGraph<N> copyOf(ImmutableGraph<N> immutableGraph) {
        return (ImmutableGraph) Preconditions.checkNotNull(immutableGraph);
    }

    @Override
    public ElementOrder<N> incidentEdgeOrder() {
        return ElementOrder.stable();
    }

    private static <N> ImmutableMap<N, GraphConnections<N, GraphConstants.Presence>> getNodeConnections(Graph<N> graph) {
        ImmutableMap.Builder builder = ImmutableMap.builder();
        for (N n : graph.nodes()) {
            builder.put(n, connectionsOf(graph, n));
        }
        return builder.buildOrThrow();
    }

    private static <N> GraphConnections<N, GraphConstants.Presence> connectionsOf(Graph<N> graph, N n) {
        Function functionConstant = Functions.constant(GraphConstants.Presence.EDGE_EXISTS);
        if (graph.isDirected()) {
            return DirectedGraphConnections.ofImmutable(n, graph.incidentEdges(n), functionConstant);
        }
        return UndirectedGraphConnections.ofImmutable(Maps.asMap(graph.adjacentNodes(n), functionConstant));
    }

    @Override
    BaseGraph<N> delegate() {
        return this.backingGraph;
    }

    public static class Builder<N> {
        private final MutableGraph<N> mutableGraph;

        Builder(GraphBuilder<N> graphBuilder) {
            this.mutableGraph = graphBuilder.copy().incidentEdgeOrder(ElementOrder.stable()).build();
        }

        public Builder<N> addNode(N n) {
            this.mutableGraph.addNode(n);
            return this;
        }

        public Builder<N> putEdge(N n, N n2) {
            this.mutableGraph.putEdge(n, n2);
            return this;
        }

        public Builder<N> putEdge(EndpointPair<N> endpointPair) {
            this.mutableGraph.putEdge(endpointPair);
            return this;
        }

        public ImmutableGraph<N> build() {
            return ImmutableGraph.copyOf(this.mutableGraph);
        }
    }
}
