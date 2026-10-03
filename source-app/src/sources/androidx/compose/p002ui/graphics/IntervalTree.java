package androidx.compose.p002ui.graphics;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.markers.KMappedMarker;
import kotlin.ranges.ClosedFloatingPointRange;

@Metadata(d1 = {"\u0000Z\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u0007\n\u0002\b\u0005\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010!\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010(\n\u0002\b\n\b\u0007\u0018\u0000*\u0004\b\u0000\u0010\u00012\u00020\u0002:\u0002)*B\u0005¢\u0006\u0002\u0010\u0003J%\u0010\n\u001a\u00020\u000b2\u0006\u0010\f\u001a\u00020\r2\u0006\u0010\u000e\u001a\u00020\r2\b\u0010\u000f\u001a\u0004\u0018\u00018\u0000¢\u0006\u0002\u0010\u0010J\u0006\u0010\u0011\u001a\u00020\u000bJ\u0011\u0010\u0012\u001a\u00020\u00132\u0006\u0010\u0014\u001a\u00020\rH\u0086\u0002J\u0017\u0010\u0012\u001a\u00020\u00132\f\u0010\u0015\u001a\b\u0012\u0004\u0012\u00020\r0\u0016H\u0086\u0002J\u001e\u0010\u0017\u001a\b\u0012\u0004\u0012\u00028\u00000\u00182\u0006\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\rJ\u001a\u0010\u0017\u001a\b\u0012\u0004\u0012\u00028\u00000\u00182\f\u0010\u0015\u001a\b\u0012\u0004\u0012\u00020\r0\u0016J:\u0010\u0019\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00000\u00180\u001a2\u0006\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\r2\u0014\b\u0002\u0010\u001b\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00000\u00180\u001aJ6\u0010\u0019\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00000\u00180\u001a2\f\u0010\u0015\u001a\b\u0012\u0004\u0012\u00020\r0\u00162\u0014\b\u0002\u0010\u001b\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00000\u00180\u001aJ:\u0010\u001c\u001a\u00020\u000b2\u0006\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\r2\u0018\u0010\u001d\u001a\u0014\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00000\u0018\u0012\u0004\u0012\u00020\u000b0\u001eH\u0080\b¢\u0006\u0002\b\u001fJ6\u0010\u001c\u001a\u00020\u000b2\f\u0010\u0015\u001a\b\u0012\u0004\u0012\u00020\r0\u00162\u0018\u0010\u001d\u001a\u0014\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00000\u0018\u0012\u0004\u0012\u00020\u000b0\u001eH\u0080\b¢\u0006\u0002\b\u001fJ\u0015\u0010 \u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00000\u00180!H\u0086\u0002J\u0017\u0010\"\u001a\u00020\u000b2\f\u0010\u0015\u001a\b\u0012\u0004\u0012\u00028\u00000\u0018H\u0086\u0002J\u001a\u0010#\u001a\u00020\u000b2\u0010\u0010$\u001a\f0\u0005R\b\u0012\u0004\u0012\u00028\u00000\u0000H\u0002J\u001a\u0010%\u001a\u00020\u000b2\u0010\u0010&\u001a\f0\u0005R\b\u0012\u0004\u0012\u00028\u00000\u0000H\u0002J\u001a\u0010'\u001a\u00020\u000b2\u0010\u0010&\u001a\f0\u0005R\b\u0012\u0004\u0012\u00028\u00000\u0000H\u0002J\u001a\u0010(\u001a\u00020\u000b2\u0010\u0010&\u001a\f0\u0005R\b\u0012\u0004\u0012\u00028\u00000\u0000H\u0002R\u0018\u0010\u0004\u001a\f0\u0005R\b\u0012\u0004\u0012\u00028\u00000\u0000X\u0082\u000e¢\u0006\u0002\n\u0000R2\u0010\u0006\u001a&\u0012\u000e\u0012\f0\u0005R\b\u0012\u0004\u0012\u00028\u00000\u00000\u0007j\u0012\u0012\u000e\u0012\f0\u0005R\b\u0012\u0004\u0012\u00028\u00000\u0000`\bX\u0082\u0004¢\u0006\u0002\n\u0000R\u0018\u0010\t\u001a\f0\u0005R\b\u0012\u0004\u0012\u00028\u00000\u0000X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006+"}, d2 = {"Landroidx/compose/ui/graphics/IntervalTree;", "T", "", "()V", "root", "Landroidx/compose/ui/graphics/IntervalTree$Node;", "stack", "Ljava/util/ArrayList;", "Lkotlin/collections/ArrayList;", "terminator", "addInterval", "", "start", "", "end", "data", "(FFLjava/lang/Object;)V", "clear", "contains", "", "value", "interval", "Lkotlin/ranges/ClosedFloatingPointRange;", "findFirstOverlap", "Landroidx/compose/ui/graphics/Interval;", "findOverlaps", "", "results", "forEach", "block", "Lkotlin/Function1;", "forEach$ui_graphics_release", "iterator", "", "plusAssign", "rebalance", "target", "rotateLeft", "node", "rotateRight", "updateNodeData", "Node", "TreeColor", "ui-graphics_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class IntervalTree<T> {
    private IntervalTree<T>.Node root;
    private final ArrayList<IntervalTree<T>.Node> stack;
    private final IntervalTree<T>.Node terminator;

    @Metadata(d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0002\b\u0004\b\u0080\u0001\u0018\u00002\b\u0012\u0004\u0012\u00020\u00000\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002j\u0002\b\u0003j\u0002\b\u0004¨\u0006\u0005"}, d2 = {"Landroidx/compose/ui/graphics/IntervalTree$TreeColor;", "", "(Ljava/lang/String;I)V", "Red", "Black", "ui-graphics_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public enum TreeColor {
        Red,
        Black
    }

    public IntervalTree() {
        IntervalTree<T>.Node node = new Node(Float.MAX_VALUE, Float.MIN_VALUE, null, TreeColor.Black);
        this.terminator = node;
        this.root = node;
        this.stack = new ArrayList<>();
    }

    public final void clear() {
        this.root = this.terminator;
    }

    public final Interval<T> findFirstOverlap(ClosedFloatingPointRange<Float> interval) {
        return findFirstOverlap(((Number) interval.getStart()).floatValue(), ((Number) interval.getEndInclusive()).floatValue());
    }

    public static Interval findFirstOverlap$default(IntervalTree intervalTree, float f, float f2, int i, Object obj) {
        if ((i & 2) != 0) {
            f2 = f;
        }
        return intervalTree.findFirstOverlap(f, f2);
    }

    public final Interval<T> findFirstOverlap(float start, float end) {
        if (this.root != this.terminator && this.root != this.terminator) {
            ArrayList arrayList = this.stack;
            arrayList.add(this.root);
            while (arrayList.size() > 0) {
                Node node = (Node) CollectionsKt.removeLast(arrayList);
                if (node.overlaps(start, end)) {
                    return node;
                }
                if (node.getLeft() != this.terminator && node.getLeft().getMax() >= start) {
                    arrayList.add(node.getLeft());
                }
                if (node.getRight() != this.terminator && node.getRight().getMin() <= end) {
                    arrayList.add(node.getRight());
                }
            }
            arrayList.clear();
        }
        Interval<T> interval = (Interval<T>) IntervalTreeKt.getEmptyInterval();
        Intrinsics.checkNotNull(interval, "null cannot be cast to non-null type androidx.compose.ui.graphics.Interval<T of androidx.compose.ui.graphics.IntervalTree>");
        return interval;
    }

    public static List findOverlaps$default(IntervalTree intervalTree, ClosedFloatingPointRange closedFloatingPointRange, List list, int i, Object obj) {
        if ((i & 2) != 0) {
            list = new ArrayList();
        }
        return intervalTree.findOverlaps(closedFloatingPointRange, list);
    }

    public final List<Interval<T>> findOverlaps(ClosedFloatingPointRange<Float> interval, List<Interval<T>> results) {
        return findOverlaps(((Number) interval.getStart()).floatValue(), ((Number) interval.getEndInclusive()).floatValue(), results);
    }

    public static List findOverlaps$default(IntervalTree intervalTree, float f, float f2, List list, int i, Object obj) {
        if ((i & 2) != 0) {
            f2 = f;
        }
        if ((i & 4) != 0) {
            list = new ArrayList();
        }
        return intervalTree.findOverlaps(f, f2, list);
    }

    public final void forEach$ui_graphics_release(ClosedFloatingPointRange<Float> interval, Function1<? super Interval<T>, Unit> block) {
        float fFloatValue = ((Number) interval.getStart()).floatValue();
        float fFloatValue2 = ((Number) interval.getEndInclusive()).floatValue();
        if (this.root != this.terminator) {
            ArrayList arrayList = this.stack;
            arrayList.add(this.root);
            while (arrayList.size() > 0) {
                Node node = (Node) CollectionsKt.removeLast(arrayList);
                if (node.overlaps(fFloatValue, fFloatValue2)) {
                    block.invoke(node);
                }
                if (node.getLeft() != this.terminator && node.getLeft().getMax() >= fFloatValue) {
                    arrayList.add(node.getLeft());
                }
                if (node.getRight() != this.terminator && node.getRight().getMin() <= fFloatValue2) {
                    arrayList.add(node.getRight());
                }
            }
            arrayList.clear();
        }
    }

    public static void forEach$ui_graphics_release$default(IntervalTree intervalTree, float f, float f2, Function1 function1, int i, Object obj) {
        if ((i & 2) != 0) {
            f2 = f;
        }
        if (intervalTree.root != intervalTree.terminator) {
            ArrayList arrayList = intervalTree.stack;
            arrayList.add(intervalTree.root);
            while (arrayList.size() > 0) {
                Node node = (Node) CollectionsKt.removeLast(arrayList);
                if (node.overlaps(f, f2)) {
                    function1.invoke(node);
                }
                if (node.getLeft() != intervalTree.terminator && node.getLeft().getMax() >= f) {
                    arrayList.add(node.getLeft());
                }
                if (node.getRight() != intervalTree.terminator && node.getRight().getMin() <= f2) {
                    arrayList.add(node.getRight());
                }
            }
            arrayList.clear();
        }
    }

    public final void forEach$ui_graphics_release(float start, float end, Function1<? super Interval<T>, Unit> block) {
        if (this.root != this.terminator) {
            ArrayList arrayList = this.stack;
            arrayList.add(this.root);
            while (arrayList.size() > 0) {
                Node node = (Node) CollectionsKt.removeLast(arrayList);
                if (node.overlaps(start, end)) {
                    block.invoke(node);
                }
                if (node.getLeft() != this.terminator && node.getLeft().getMax() >= start) {
                    arrayList.add(node.getLeft());
                }
                if (node.getRight() != this.terminator && node.getRight().getMin() <= end) {
                    arrayList.add(node.getRight());
                }
            }
            arrayList.clear();
        }
    }

    public final boolean contains(float value) {
        return findFirstOverlap(value, value) != IntervalTreeKt.getEmptyInterval();
    }

    public final boolean contains(ClosedFloatingPointRange<Float> interval) {
        return findFirstOverlap(((Number) interval.getStart()).floatValue(), ((Number) interval.getEndInclusive()).floatValue()) != IntervalTreeKt.getEmptyInterval();
    }

    @Metadata(d1 = {"\u0000!\n\u0000\n\u0002\u0010(\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u000b\n\u0000*\u0001\u0000\b\n\u0018\u00002\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00000\u00020\u0001J\t\u0010\n\u001a\u00020\u000bH\u0096\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00028\u00000\u0002H\u0096\u0002R$\u0010\u0003\u001a\f0\u0004R\b\u0012\u0004\u0012\u00028\u00000\u0005X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0006\u0010\u0007\"\u0004\b\b\u0010\t¨\u0006\f"}, d2 = {"androidx/compose/ui/graphics/IntervalTree$iterator$1", "", "Landroidx/compose/ui/graphics/Interval;", "next", "Landroidx/compose/ui/graphics/IntervalTree$Node;", "Landroidx/compose/ui/graphics/IntervalTree;", "getNext", "()Landroidx/compose/ui/graphics/IntervalTree$Node;", "setNext", "(Landroidx/compose/ui/graphics/IntervalTree$Node;)V", "hasNext", "", "ui-graphics_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class C16171 implements Iterator<Interval<T>>, KMappedMarker {
        private IntervalTree<T>.Node next;
        final IntervalTree<T> this$0;

        @Override
        public void remove() {
            throw new UnsupportedOperationException("Operation is not supported for read-only collection");
        }

        C16171(IntervalTree<T> intervalTree) {
            this.this$0 = intervalTree;
            this.next = ((IntervalTree) intervalTree).root.lowestNode();
        }

        public final IntervalTree<T>.Node getNext() {
            return this.next;
        }

        public final void setNext(IntervalTree<T>.Node node) {
            this.next = node;
        }

        @Override
        public boolean hasNext() {
            return this.next != ((IntervalTree) this.this$0).terminator;
        }

        @Override
        public Interval<T> next() {
            IntervalTree<T>.Node node = this.next;
            this.next = node.next();
            return node;
        }
    }

    public final Iterator<Interval<T>> iterator() {
        return new C16171(this);
    }

    public final void plusAssign(Interval<T> interval) {
        addInterval(interval.getStart(), interval.getEnd(), interval.getData());
    }

    public final void addInterval(float start, float end, T data) {
        IntervalTree<T>.Node right;
        IntervalTree<T>.Node node = new Node(start, end, data, TreeColor.Red);
        IntervalTree<T>.Node node2 = this.root;
        IntervalTree<T>.Node node3 = this.terminator;
        while (node2 != this.terminator) {
            if (node.getStart() <= node2.getStart()) {
                right = node2.getLeft();
            } else {
                right = node2.getRight();
            }
            IntervalTree<T>.Node node4 = right;
            node3 = node2;
            node2 = node4;
        }
        node.setParent(node3);
        if (node3 == this.terminator) {
            this.root = node;
        } else if (node.getStart() <= node3.getStart()) {
            node3.setLeft(node);
        } else {
            node3.setRight(node);
        }
        updateNodeData(node);
        rebalance(node);
    }

    private final void rebalance(IntervalTree<T>.Node target) {
        while (target != this.root && target.getParent().getColor() == TreeColor.Red) {
            IntervalTree<T>.Node parent = target.getParent().getParent();
            if (target.getParent() == parent.getLeft()) {
                IntervalTree<T>.Node right = parent.getRight();
                if (right.getColor() == TreeColor.Red) {
                    right.setColor(TreeColor.Black);
                    target.getParent().setColor(TreeColor.Black);
                    parent.setColor(TreeColor.Red);
                    target = parent;
                } else {
                    if (target == target.getParent().getRight()) {
                        target = target.getParent();
                        rotateLeft(target);
                    }
                    target.getParent().setColor(TreeColor.Black);
                    parent.setColor(TreeColor.Red);
                    rotateRight(parent);
                }
            } else {
                IntervalTree<T>.Node left = parent.getLeft();
                if (left.getColor() == TreeColor.Red) {
                    left.setColor(TreeColor.Black);
                    target.getParent().setColor(TreeColor.Black);
                    parent.setColor(TreeColor.Red);
                    target = parent;
                } else {
                    if (target == target.getParent().getLeft()) {
                        target = target.getParent();
                        rotateRight(target);
                    }
                    target.getParent().setColor(TreeColor.Black);
                    parent.setColor(TreeColor.Red);
                    rotateLeft(parent);
                }
            }
        }
        this.root.setColor(TreeColor.Black);
    }

    private final void rotateLeft(IntervalTree<T>.Node node) {
        IntervalTree<T>.Node right = node.getRight();
        node.setRight(right.getLeft());
        if (right.getLeft() != this.terminator) {
            right.getLeft().setParent(node);
        }
        right.setParent(node.getParent());
        if (node.getParent() == this.terminator) {
            this.root = right;
        } else if (node.getParent().getLeft() == node) {
            node.getParent().setLeft(right);
        } else {
            node.getParent().setRight(right);
        }
        right.setLeft(node);
        node.setParent(right);
        updateNodeData(node);
    }

    private final void rotateRight(IntervalTree<T>.Node node) {
        IntervalTree<T>.Node left = node.getLeft();
        node.setLeft(left.getRight());
        if (left.getRight() != this.terminator) {
            left.getRight().setParent(node);
        }
        left.setParent(node.getParent());
        if (node.getParent() == this.terminator) {
            this.root = left;
        } else if (node.getParent().getRight() == node) {
            node.getParent().setRight(left);
        } else {
            node.getParent().setLeft(left);
        }
        left.setRight(node);
        node.setParent(left);
        updateNodeData(node);
    }

    private final void updateNodeData(IntervalTree<T>.Node node) {
        while (node != this.terminator) {
            node.setMin(Math.min(node.getStart(), Math.min(node.getLeft().getMin(), node.getRight().getMin())));
            node.setMax(Math.max(node.getEnd(), Math.max(node.getLeft().getMax(), node.getRight().getMax())));
            node = node.getParent();
        }
    }

    @Metadata(d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0007\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0015\b\u0080\u0004\u0018\u00002\b\u0012\u0004\u0012\u00028\u00000\u0001B'\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003\u0012\b\u0010\u0005\u001a\u0004\u0018\u00018\u0000\u0012\u0006\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\bJ\u0010\u0010!\u001a\f0\u0000R\b\u0012\u0004\u0012\u00028\u00000\u000eJ\u0010\u0010\"\u001a\f0\u0000R\b\u0012\u0004\u0012\u00028\u00000\u000eR\u001a\u0010\u0006\u001a\u00020\u0007X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\t\u0010\n\"\u0004\b\u000b\u0010\fR$\u0010\r\u001a\f0\u0000R\b\u0012\u0004\u0012\u00028\u00000\u000eX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u000f\u0010\u0010\"\u0004\b\u0011\u0010\u0012R\u001a\u0010\u0013\u001a\u00020\u0003X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0014\u0010\u0015\"\u0004\b\u0016\u0010\u0017R\u001a\u0010\u0018\u001a\u00020\u0003X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0019\u0010\u0015\"\u0004\b\u001a\u0010\u0017R$\u0010\u001b\u001a\f0\u0000R\b\u0012\u0004\u0012\u00028\u00000\u000eX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u001c\u0010\u0010\"\u0004\b\u001d\u0010\u0012R$\u0010\u001e\u001a\f0\u0000R\b\u0012\u0004\u0012\u00028\u00000\u000eX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u001f\u0010\u0010\"\u0004\b \u0010\u0012¨\u0006#"}, d2 = {"Landroidx/compose/ui/graphics/IntervalTree$Node;", "Landroidx/compose/ui/graphics/Interval;", "start", "", "end", "data", "color", "Landroidx/compose/ui/graphics/IntervalTree$TreeColor;", "(Landroidx/compose/ui/graphics/IntervalTree;FFLjava/lang/Object;Landroidx/compose/ui/graphics/IntervalTree$TreeColor;)V", "getColor", "()Landroidx/compose/ui/graphics/IntervalTree$TreeColor;", "setColor", "(Landroidx/compose/ui/graphics/IntervalTree$TreeColor;)V", "left", "Landroidx/compose/ui/graphics/IntervalTree;", "getLeft", "()Landroidx/compose/ui/graphics/IntervalTree$Node;", "setLeft", "(Landroidx/compose/ui/graphics/IntervalTree$Node;)V", "max", "getMax", "()F", "setMax", "(F)V", "min", "getMin", "setMin", "parent", "getParent", "setParent", "right", "getRight", "setRight", "lowestNode", "next", "ui-graphics_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public final class Node extends Interval<T> {
        private TreeColor color;
        private IntervalTree<T>.Node left;
        private float max;
        private float min;
        private IntervalTree<T>.Node parent;
        private IntervalTree<T>.Node right;

        public Node(float f, float f2, T t, TreeColor treeColor) {
            super(f, f2, t);
            this.color = treeColor;
            this.min = f;
            this.max = f2;
            this.left = IntervalTree.this.terminator;
            this.right = IntervalTree.this.terminator;
            this.parent = IntervalTree.this.terminator;
        }

        public final TreeColor getColor() {
            return this.color;
        }

        public final void setColor(TreeColor treeColor) {
            this.color = treeColor;
        }

        public final float getMin() {
            return this.min;
        }

        public final void setMin(float f) {
            this.min = f;
        }

        public final float getMax() {
            return this.max;
        }

        public final void setMax(float f) {
            this.max = f;
        }

        public final IntervalTree<T>.Node getLeft() {
            return this.left;
        }

        public final void setLeft(IntervalTree<T>.Node node) {
            this.left = node;
        }

        public final IntervalTree<T>.Node getRight() {
            return this.right;
        }

        public final void setRight(IntervalTree<T>.Node node) {
            this.right = node;
        }

        public final IntervalTree<T>.Node getParent() {
            return this.parent;
        }

        public final void setParent(IntervalTree<T>.Node node) {
            this.parent = node;
        }

        public final IntervalTree<T>.Node lowestNode() {
            Node node = this;
            while (node.left != ((IntervalTree) IntervalTree.this).terminator) {
                node = node.left;
            }
            return node;
        }

        public final IntervalTree<T>.Node next() {
            if (this.right != ((IntervalTree) IntervalTree.this).terminator) {
                return this.right.lowestNode();
            }
            IntervalTree<T>.Node node = this.parent;
            Node node2 = this;
            while (node != ((IntervalTree) IntervalTree.this).terminator && node2 == node.right) {
                node2 = node;
                node = node.parent;
            }
            return node;
        }
    }

    public final List<Interval<T>> findOverlaps(float start, float end, List<Interval<T>> results) {
        if (this.root != this.terminator) {
            ArrayList arrayList = this.stack;
            arrayList.add(this.root);
            while (arrayList.size() > 0) {
                Node node = (Node) CollectionsKt.removeLast(arrayList);
                if (node.overlaps(start, end)) {
                    results.add(node);
                }
                if (node.getLeft() != this.terminator && node.getLeft().getMax() >= start) {
                    arrayList.add(node.getLeft());
                }
                if (node.getRight() != this.terminator && node.getRight().getMin() <= end) {
                    arrayList.add(node.getRight());
                }
            }
            arrayList.clear();
        }
        return results;
    }
}
