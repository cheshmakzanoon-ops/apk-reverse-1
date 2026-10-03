package com.google.common.graph;

import com.google.common.base.Function;
import com.google.common.collect.Maps;
import j$.util.Objects;
import java.util.Map;
import java.util.Set;
import javax.annotation.CheckForNull;

@ElementTypesAreNonnullByDefault
public abstract class AbstractValueGraph<N, V> extends AbstractBaseGraph<N> implements ValueGraph<N, V> {
    @Override
    public Iterable predecessors(Object obj) {
        return predecessors(obj);
    }

    @Override
    public Iterable successors(Object obj) {
        return successors(obj);
    }

    @Override
    public int degree(Object obj) {
        return super.degree(obj);
    }

    @Override
    public Set edges() {
        return super.edges();
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
    public ElementOrder incidentEdgeOrder() {
        return super.incidentEdgeOrder();
    }

    @Override
    public Set incidentEdges(Object obj) {
        return super.incidentEdges(obj);
    }

    @Override
    public int outDegree(Object obj) {
        return super.outDegree(obj);
    }

    @Override
    public Graph<N> asGraph() {
        return new AbstractGraph<N>() {
            @Override
            public Set<N> nodes() {
                return AbstractValueGraph.this.nodes();
            }

            @Override
            public Set<EndpointPair<N>> edges() {
                return AbstractValueGraph.this.edges();
            }

            @Override
            public boolean isDirected() {
                return AbstractValueGraph.this.isDirected();
            }

            @Override
            public boolean allowsSelfLoops() {
                return AbstractValueGraph.this.allowsSelfLoops();
            }

            @Override
            public ElementOrder<N> nodeOrder() {
                return AbstractValueGraph.this.nodeOrder();
            }

            @Override
            public ElementOrder<N> incidentEdgeOrder() {
                return AbstractValueGraph.this.incidentEdgeOrder();
            }

            @Override
            public Set<N> adjacentNodes(N n) {
                return AbstractValueGraph.this.adjacentNodes(n);
            }

            @Override
            public Set<N> predecessors(N n) {
                return AbstractValueGraph.this.predecessors((Object) n);
            }

            @Override
            public Set<N> successors(N n) {
                return AbstractValueGraph.this.successors((Object) n);
            }

            @Override
            public int degree(N n) {
                return AbstractValueGraph.this.degree(n);
            }

            @Override
            public int inDegree(N n) {
                return AbstractValueGraph.this.inDegree(n);
            }

            @Override
            public int outDegree(N n) {
                return AbstractValueGraph.this.outDegree(n);
            }
        };
    }

    @Override
    public final boolean equals(@CheckForNull Object obj) {
        if (obj == this) {
            return true;
        }
        if (!(obj instanceof ValueGraph)) {
            return false;
        }
        ValueGraph valueGraph = (ValueGraph) obj;
        return isDirected() == valueGraph.isDirected() && nodes().equals(valueGraph.nodes()) && edgeValueMap(this).equals(edgeValueMap(valueGraph));
    }

    @Override
    public final int hashCode() {
        return edgeValueMap(this).hashCode();
    }

    public String toString() {
        boolean zIsDirected = isDirected();
        boolean zAllowsSelfLoops = allowsSelfLoops();
        String strValueOf = String.valueOf(nodes());
        String strValueOf2 = String.valueOf(edgeValueMap(this));
        StringBuilder sb = new StringBuilder(String.valueOf(strValueOf).length() + 59 + String.valueOf(strValueOf2).length());
        sb.append("isDirected: ");
        sb.append(zIsDirected);
        sb.append(", allowsSelfLoops: ");
        sb.append(zAllowsSelfLoops);
        sb.append(", nodes: ");
        sb.append(strValueOf);
        sb.append(", edges: ");
        sb.append(strValueOf2);
        return sb.toString();
    }

    private static <N, V> Map<EndpointPair<N>, V> edgeValueMap(final ValueGraph<N, V> valueGraph) {
        return Maps.asMap(valueGraph.edges(), new Function<EndpointPair<N>, V>() {
            @Override
            public V apply(EndpointPair<N> endpointPair) {
                return (V) Objects.requireNonNull(valueGraph.edgeValueOrDefault(endpointPair.nodeU(), endpointPair.nodeV(), null));
            }
        });
    }
}
