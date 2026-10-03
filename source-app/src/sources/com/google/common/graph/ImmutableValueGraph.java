package com.google.common.graph;

import com.google.common.base.Function;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Maps;
import com.google.errorprone.annotations.Immutable;
import j$.util.Objects;
import java.util.Set;
import javax.annotation.CheckForNull;

@Immutable(containerOf = {"N", "V"})
@ElementTypesAreNonnullByDefault
public final class ImmutableValueGraph<N, V> extends StandardValueGraph<N, V> {
    @Override
    public Set adjacentNodes(Object obj) {
        return super.adjacentNodes(obj);
    }

    @Override
    public boolean allowsSelfLoops() {
        return super.allowsSelfLoops();
    }

    @Override
    @CheckForNull
    public Object edgeValueOrDefault(EndpointPair endpointPair, @CheckForNull Object obj) {
        return super.edgeValueOrDefault(endpointPair, obj);
    }

    @Override
    @CheckForNull
    public Object edgeValueOrDefault(Object obj, Object obj2, @CheckForNull Object obj3) {
        return super.edgeValueOrDefault(obj, obj2, obj3);
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
    public Set predecessors(Object obj) {
        return super.predecessors(obj);
    }

    @Override
    public Set successors(Object obj) {
        return super.successors(obj);
    }

    private ImmutableValueGraph(ValueGraph<N, V> valueGraph) {
        super(ValueGraphBuilder.from(valueGraph), getNodeConnections(valueGraph), valueGraph.edges().size());
    }

    public static <N, V> ImmutableValueGraph<N, V> copyOf(ValueGraph<N, V> valueGraph) {
        if (valueGraph instanceof ImmutableValueGraph) {
            return (ImmutableValueGraph) valueGraph;
        }
        return new ImmutableValueGraph<>(valueGraph);
    }

    @Deprecated
    public static <N, V> ImmutableValueGraph<N, V> copyOf(ImmutableValueGraph<N, V> immutableValueGraph) {
        return (ImmutableValueGraph) Preconditions.checkNotNull(immutableValueGraph);
    }

    @Override
    public ElementOrder<N> incidentEdgeOrder() {
        return ElementOrder.stable();
    }

    @Override
    public ImmutableGraph<N> asGraph() {
        return new ImmutableGraph<>(this);
    }

    private static <N, V> ImmutableMap<N, GraphConnections<N, V>> getNodeConnections(ValueGraph<N, V> valueGraph) {
        ImmutableMap.Builder builder = ImmutableMap.builder();
        for (N n : valueGraph.nodes()) {
            builder.put(n, connectionsOf(valueGraph, n));
        }
        return builder.buildOrThrow();
    }

    private static <N, V> GraphConnections<N, V> connectionsOf(final ValueGraph<N, V> valueGraph, final N n) {
        Function function = new Function() {
            @Override
            public final Object apply(Object obj) {
                return Objects.requireNonNull(valueGraph.edgeValueOrDefault(n, obj, null));
            }
        };
        if (valueGraph.isDirected()) {
            return DirectedGraphConnections.ofImmutable(n, valueGraph.incidentEdges(n), function);
        }
        return UndirectedGraphConnections.ofImmutable(Maps.asMap(valueGraph.adjacentNodes(n), function));
    }

    public static class Builder<N, V> {
        private final MutableValueGraph<N, V> mutableValueGraph;

        Builder(ValueGraphBuilder<N, V> valueGraphBuilder) {
            this.mutableValueGraph = valueGraphBuilder.copy().incidentEdgeOrder(ElementOrder.stable()).build();
        }

        public Builder<N, V> addNode(N n) {
            this.mutableValueGraph.addNode(n);
            return this;
        }

        public Builder<N, V> putEdgeValue(N n, N n2, V v) {
            this.mutableValueGraph.putEdgeValue(n, n2, v);
            return this;
        }

        public Builder<N, V> putEdgeValue(EndpointPair<N> endpointPair, V v) {
            this.mutableValueGraph.putEdgeValue(endpointPair, v);
            return this;
        }

        public ImmutableValueGraph<N, V> build() {
            return ImmutableValueGraph.copyOf(this.mutableValueGraph);
        }
    }
}
