package com.google.common.graph;

import java.util.Set;
import javax.annotation.CheckForNull;

@ElementTypesAreNonnullByDefault
public abstract class AbstractGraph<N> extends AbstractBaseGraph<N> implements Graph<N> {
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
    public final boolean equals(@CheckForNull Object obj) {
        if (obj == this) {
            return true;
        }
        if (!(obj instanceof Graph)) {
            return false;
        }
        Graph graph = (Graph) obj;
        return isDirected() == graph.isDirected() && nodes().equals(graph.nodes()) && edges().equals(graph.edges());
    }

    @Override
    public final int hashCode() {
        return edges().hashCode();
    }

    public String toString() {
        boolean zIsDirected = isDirected();
        boolean zAllowsSelfLoops = allowsSelfLoops();
        String strValueOf = String.valueOf(nodes());
        String strValueOf2 = String.valueOf(edges());
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
}
