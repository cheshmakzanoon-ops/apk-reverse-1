package com.google.common.graph;

import com.google.common.base.Function;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Maps;
import com.google.errorprone.annotations.Immutable;
import java.util.Map;
import java.util.Set;

@Immutable(containerOf = {"N", "E"})
@ElementTypesAreNonnullByDefault
public final class ImmutableNetwork<N, E> extends StandardNetwork<N, E> {
    @Override
    public Set adjacentNodes(Object obj) {
        return super.adjacentNodes(obj);
    }

    @Override
    public boolean allowsParallelEdges() {
        return super.allowsParallelEdges();
    }

    @Override
    public boolean allowsSelfLoops() {
        return super.allowsSelfLoops();
    }

    @Override
    public ElementOrder edgeOrder() {
        return super.edgeOrder();
    }

    @Override
    public Set edges() {
        return super.edges();
    }

    @Override
    public Set edgesConnecting(Object obj, Object obj2) {
        return super.edgesConnecting(obj, obj2);
    }

    @Override
    public Set inEdges(Object obj) {
        return super.inEdges(obj);
    }

    @Override
    public Set incidentEdges(Object obj) {
        return super.incidentEdges(obj);
    }

    @Override
    public EndpointPair incidentNodes(Object obj) {
        return super.incidentNodes(obj);
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
    public Set outEdges(Object obj) {
        return super.outEdges(obj);
    }

    @Override
    public Set predecessors(Object obj) {
        return super.predecessors(obj);
    }

    @Override
    public Set successors(Object obj) {
        return super.successors(obj);
    }

    private ImmutableNetwork(Network<N, E> network) {
        super(NetworkBuilder.from(network), getNodeConnections(network), getEdgeToReferenceNode(network));
    }

    public static <N, E> ImmutableNetwork<N, E> copyOf(Network<N, E> network) {
        if (network instanceof ImmutableNetwork) {
            return (ImmutableNetwork) network;
        }
        return new ImmutableNetwork<>(network);
    }

    @Deprecated
    public static <N, E> ImmutableNetwork<N, E> copyOf(ImmutableNetwork<N, E> immutableNetwork) {
        return (ImmutableNetwork) Preconditions.checkNotNull(immutableNetwork);
    }

    @Override
    public ImmutableGraph<N> asGraph() {
        return new ImmutableGraph<>(super.asGraph());
    }

    private static <N, E> Map<N, NetworkConnections<N, E>> getNodeConnections(Network<N, E> network) {
        ImmutableMap.Builder builder = ImmutableMap.builder();
        for (N n : network.nodes()) {
            builder.put(n, connectionsOf(network, n));
        }
        return builder.buildOrThrow();
    }

    private static <N, E> Map<E, N> getEdgeToReferenceNode(Network<N, E> network) {
        ImmutableMap.Builder builder = ImmutableMap.builder();
        for (E e : network.edges()) {
            builder.put(e, network.incidentNodes(e).nodeU());
        }
        return builder.buildOrThrow();
    }

    private static <N, E> NetworkConnections<N, E> connectionsOf(Network<N, E> network, N n) {
        if (network.isDirected()) {
            Map mapAsMap = Maps.asMap(network.inEdges(n), sourceNodeFn(network));
            Map mapAsMap2 = Maps.asMap(network.outEdges(n), targetNodeFn(network));
            int size = network.edgesConnecting(n, n).size();
            if (network.allowsParallelEdges()) {
                return DirectedMultiNetworkConnections.ofImmutable(mapAsMap, mapAsMap2, size);
            }
            return DirectedNetworkConnections.ofImmutable(mapAsMap, mapAsMap2, size);
        }
        Map mapAsMap3 = Maps.asMap(network.incidentEdges(n), adjacentNodeFn(network, n));
        if (network.allowsParallelEdges()) {
            return UndirectedMultiNetworkConnections.ofImmutable(mapAsMap3);
        }
        return UndirectedNetworkConnections.ofImmutable(mapAsMap3);
    }

    private static <N, E> Function<E, N> sourceNodeFn(final Network<N, E> network) {
        return new Function() {
            @Override
            public final Object apply(Object obj) {
                return network.incidentNodes(obj).source();
            }
        };
    }

    private static <N, E> Function<E, N> targetNodeFn(final Network<N, E> network) {
        return new Function() {
            @Override
            public final Object apply(Object obj) {
                return network.incidentNodes(obj).target();
            }
        };
    }

    private static <N, E> Function<E, N> adjacentNodeFn(final Network<N, E> network, final N n) {
        return new Function() {
            @Override
            public final Object apply(Object obj) {
                return network.incidentNodes(obj).adjacentNode(n);
            }
        };
    }

    public static class Builder<N, E> {
        private final MutableNetwork<N, E> mutableNetwork;

        Builder(NetworkBuilder<N, E> networkBuilder) {
            this.mutableNetwork = (MutableNetwork<N, E>) networkBuilder.build();
        }

        public Builder<N, E> addNode(N n) {
            this.mutableNetwork.addNode(n);
            return this;
        }

        public Builder<N, E> addEdge(N n, N n2, E e) {
            this.mutableNetwork.addEdge(n, n2, e);
            return this;
        }

        public Builder<N, E> addEdge(EndpointPair<N> endpointPair, E e) {
            this.mutableNetwork.addEdge(endpointPair, e);
            return this;
        }

        public ImmutableNetwork<N, E> build() {
            return ImmutableNetwork.copyOf(this.mutableNetwork);
        }
    }
}
