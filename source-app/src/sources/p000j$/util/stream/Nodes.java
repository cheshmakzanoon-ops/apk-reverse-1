package p000j$.util.stream;

import java.util.ArrayDeque;
import java.util.Arrays;
import java.util.Collection;
import java.util.Comparator;
import java.util.Deque;
import java.util.Iterator;
import java.util.concurrent.CountedCompleter;
import java.util.function.BiFunction;
import java.util.function.BinaryOperator;
import java.util.function.Consumer;
import java.util.function.DoubleConsumer;
import java.util.function.Function;
import java.util.function.IntConsumer;
import java.util.function.IntFunction;
import java.util.function.LongConsumer;
import java.util.function.LongFunction;
import p000j$.util.DesugarArrays;
import p000j$.util.Objects;
import p000j$.util.Spliterator;
import p000j$.util.Spliterators;
import p000j$.util.function.BiFunction$CC;
import p000j$.util.function.Consumer$CC;
import p000j$.util.function.DoubleConsumer$CC;
import p000j$.util.function.IntConsumer$CC;
import p000j$.util.function.LongConsumer$CC;

abstract class Nodes {
    private static final Node EMPTY_NODE = new EmptyNode.OfRef();
    private static final Node.OfInt EMPTY_INT_NODE = new EmptyNode.OfInt();
    private static final Node.OfLong EMPTY_LONG_NODE = new EmptyNode.OfLong();
    private static final Node.OfDouble EMPTY_DOUBLE_NODE = new EmptyNode.OfDouble();
    private static final int[] EMPTY_INT_ARRAY = new int[0];
    private static final long[] EMPTY_LONG_ARRAY = new long[0];
    private static final double[] EMPTY_DOUBLE_ARRAY = new double[0];

    static IntFunction castingArray() {
        return new IntFunction() {
            @Override
            public final Object apply(int i) {
                return Nodes.lambda$castingArray$0(i);
            }
        };
    }

    static Object[] lambda$castingArray$0(int i) {
        return new Object[i];
    }

    static class C05441 {
        static final int[] $SwitchMap$java$util$stream$StreamShape;

        static {
            int[] iArr = new int[StreamShape.values().length];
            $SwitchMap$java$util$stream$StreamShape = iArr;
            try {
                iArr[StreamShape.REFERENCE.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                $SwitchMap$java$util$stream$StreamShape[StreamShape.INT_VALUE.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                $SwitchMap$java$util$stream$StreamShape[StreamShape.LONG_VALUE.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            try {
                $SwitchMap$java$util$stream$StreamShape[StreamShape.DOUBLE_VALUE.ordinal()] = 4;
            } catch (NoSuchFieldError unused4) {
            }
        }
    }

    static Node emptyNode(StreamShape streamShape) {
        int i = C05441.$SwitchMap$java$util$stream$StreamShape[streamShape.ordinal()];
        if (i == 1) {
            return EMPTY_NODE;
        }
        if (i == 2) {
            return EMPTY_INT_NODE;
        }
        if (i == 3) {
            return EMPTY_LONG_NODE;
        }
        if (i == 4) {
            return EMPTY_DOUBLE_NODE;
        }
        throw new IllegalStateException("Unknown shape " + streamShape);
    }

    static Node conc(StreamShape streamShape, Node node, Node node2) {
        int i = C05441.$SwitchMap$java$util$stream$StreamShape[streamShape.ordinal()];
        if (i == 1) {
            return new ConcNode(node, node2);
        }
        if (i == 2) {
            return new ConcNode.OfInt((Node.OfInt) node, (Node.OfInt) node2);
        }
        if (i == 3) {
            return new ConcNode.OfLong((Node.OfLong) node, (Node.OfLong) node2);
        }
        if (i == 4) {
            return new ConcNode.OfDouble((Node.OfDouble) node, (Node.OfDouble) node2);
        }
        throw new IllegalStateException("Unknown shape " + streamShape);
    }

    static Node node(Object[] objArr) {
        return new ArrayNode(objArr);
    }

    static Node node(Collection collection) {
        return new CollectionNode(collection);
    }

    public static Node.Builder builder(long j, IntFunction intFunction) {
        if (j >= 0 && j < 2147483639) {
            return new FixedNodeBuilder(j, intFunction);
        }
        return builder();
    }

    static Node.Builder builder() {
        return new SpinedNodeBuilder();
    }

    static Node.OfInt node(int[] iArr) {
        return new IntArrayNode(iArr);
    }

    static Node.Builder.OfInt intBuilder(long j) {
        if (j >= 0 && j < 2147483639) {
            return new IntFixedNodeBuilder(j);
        }
        return intBuilder();
    }

    static Node.Builder.OfInt intBuilder() {
        return new IntSpinedNodeBuilder();
    }

    static Node.OfLong node(long[] jArr) {
        return new LongArrayNode(jArr);
    }

    static Node.Builder.OfLong longBuilder(long j) {
        if (j >= 0 && j < 2147483639) {
            return new LongFixedNodeBuilder(j);
        }
        return longBuilder();
    }

    static Node.Builder.OfLong longBuilder() {
        return new LongSpinedNodeBuilder();
    }

    static Node.OfDouble node(double[] dArr) {
        return new DoubleArrayNode(dArr);
    }

    static Node.Builder.OfDouble doubleBuilder(long j) {
        if (j >= 0 && j < 2147483639) {
            return new DoubleFixedNodeBuilder(j);
        }
        return doubleBuilder();
    }

    static Node.Builder.OfDouble doubleBuilder() {
        return new DoubleSpinedNodeBuilder();
    }

    public static Node collect(PipelineHelper pipelineHelper, Spliterator spliterator, boolean z, IntFunction intFunction) {
        long jExactOutputSizeIfKnown = pipelineHelper.exactOutputSizeIfKnown(spliterator);
        if (jExactOutputSizeIfKnown < 0 || !spliterator.hasCharacteristics(16384)) {
            Node node = (Node) new CollectorTask.OfRef(pipelineHelper, intFunction, spliterator).invoke();
            return z ? flatten(node, intFunction) : node;
        }
        if (jExactOutputSizeIfKnown >= 2147483639) {
            throw new IllegalArgumentException("Stream size exceeds max array size");
        }
        Object[] objArr = (Object[]) intFunction.apply((int) jExactOutputSizeIfKnown);
        new SizedCollectorTask.OfRef(spliterator, pipelineHelper, objArr).invoke();
        return node(objArr);
    }

    public static Node.OfInt collectInt(PipelineHelper pipelineHelper, Spliterator spliterator, boolean z) {
        long jExactOutputSizeIfKnown = pipelineHelper.exactOutputSizeIfKnown(spliterator);
        if (jExactOutputSizeIfKnown < 0 || !spliterator.hasCharacteristics(16384)) {
            Node.OfInt ofInt = (Node.OfInt) new CollectorTask.OfInt(pipelineHelper, spliterator).invoke();
            return z ? flattenInt(ofInt) : ofInt;
        }
        if (jExactOutputSizeIfKnown >= 2147483639) {
            throw new IllegalArgumentException("Stream size exceeds max array size");
        }
        int[] iArr = new int[(int) jExactOutputSizeIfKnown];
        new SizedCollectorTask.OfInt(spliterator, pipelineHelper, iArr).invoke();
        return node(iArr);
    }

    public static Node.OfLong collectLong(PipelineHelper pipelineHelper, Spliterator spliterator, boolean z) {
        long jExactOutputSizeIfKnown = pipelineHelper.exactOutputSizeIfKnown(spliterator);
        if (jExactOutputSizeIfKnown < 0 || !spliterator.hasCharacteristics(16384)) {
            Node.OfLong ofLong = (Node.OfLong) new CollectorTask.OfLong(pipelineHelper, spliterator).invoke();
            return z ? flattenLong(ofLong) : ofLong;
        }
        if (jExactOutputSizeIfKnown >= 2147483639) {
            throw new IllegalArgumentException("Stream size exceeds max array size");
        }
        long[] jArr = new long[(int) jExactOutputSizeIfKnown];
        new SizedCollectorTask.OfLong(spliterator, pipelineHelper, jArr).invoke();
        return node(jArr);
    }

    public static Node.OfDouble collectDouble(PipelineHelper pipelineHelper, Spliterator spliterator, boolean z) {
        long jExactOutputSizeIfKnown = pipelineHelper.exactOutputSizeIfKnown(spliterator);
        if (jExactOutputSizeIfKnown < 0 || !spliterator.hasCharacteristics(16384)) {
            Node.OfDouble ofDouble = (Node.OfDouble) new CollectorTask.OfDouble(pipelineHelper, spliterator).invoke();
            return z ? flattenDouble(ofDouble) : ofDouble;
        }
        if (jExactOutputSizeIfKnown >= 2147483639) {
            throw new IllegalArgumentException("Stream size exceeds max array size");
        }
        double[] dArr = new double[(int) jExactOutputSizeIfKnown];
        new SizedCollectorTask.OfDouble(spliterator, pipelineHelper, dArr).invoke();
        return node(dArr);
    }

    public static Node flatten(Node node, IntFunction intFunction) {
        if (node.getChildCount() <= 0) {
            return node;
        }
        long jCount = node.count();
        if (jCount >= 2147483639) {
            throw new IllegalArgumentException("Stream size exceeds max array size");
        }
        Object[] objArr = (Object[]) intFunction.apply((int) jCount);
        new ToArrayTask.OfRef(node, objArr, 0).invoke();
        return node(objArr);
    }

    public static Node.OfInt flattenInt(Node.OfInt ofInt) {
        if (ofInt.getChildCount() <= 0) {
            return ofInt;
        }
        long jCount = ofInt.count();
        if (jCount >= 2147483639) {
            throw new IllegalArgumentException("Stream size exceeds max array size");
        }
        int[] iArr = new int[(int) jCount];
        new ToArrayTask.OfInt(ofInt, iArr, 0).invoke();
        return node(iArr);
    }

    public static Node.OfLong flattenLong(Node.OfLong ofLong) {
        if (ofLong.getChildCount() <= 0) {
            return ofLong;
        }
        long jCount = ofLong.count();
        if (jCount >= 2147483639) {
            throw new IllegalArgumentException("Stream size exceeds max array size");
        }
        long[] jArr = new long[(int) jCount];
        new ToArrayTask.OfLong(ofLong, jArr, 0).invoke();
        return node(jArr);
    }

    public static Node.OfDouble flattenDouble(Node.OfDouble ofDouble) {
        if (ofDouble.getChildCount() <= 0) {
            return ofDouble;
        }
        long jCount = ofDouble.count();
        if (jCount >= 2147483639) {
            throw new IllegalArgumentException("Stream size exceeds max array size");
        }
        double[] dArr = new double[(int) jCount];
        new ToArrayTask.OfDouble(ofDouble, dArr, 0).invoke();
        return node(dArr);
    }

    private static abstract class EmptyNode implements Node {
        public void copyInto(Object obj, int i) {
        }

        @Override
        public long count() {
            return 0L;
        }

        public void forEach(Object obj) {
        }

        @Override
        public Node getChild(int i) {
            return Node.CC.$default$getChild(this, i);
        }

        @Override
        public int getChildCount() {
            return Node.CC.$default$getChildCount(this);
        }

        @Override
        public Node truncate(long j, long j2, IntFunction intFunction) {
            return Node.CC.$default$truncate(this, j, j2, intFunction);
        }

        EmptyNode() {
        }

        @Override
        public Object[] asArray(IntFunction intFunction) {
            return (Object[]) intFunction.apply(0);
        }

        private static class OfRef extends EmptyNode {
            @Override
            public void copyInto(Object[] objArr, int i) {
                super.copyInto((Object) objArr, i);
            }

            @Override
            public void forEach(Consumer consumer) {
                super.forEach((Object) consumer);
            }

            private OfRef() {
            }

            @Override
            public Spliterator spliterator() {
                return Spliterators.emptySpliterator();
            }
        }

        private static final class OfInt extends EmptyNode implements Node.OfInt {
            @Override
            public void copyInto(Integer[] numArr, int i) {
                Node.OfInt.CC.$default$copyInto((Node.OfInt) this, numArr, i);
            }

            @Override
            public void copyInto(Object[] objArr, int i) {
                copyInto((Integer[]) objArr, i);
            }

            @Override
            public void forEach(Consumer consumer) {
                Node.OfInt.CC.$default$forEach(this, consumer);
            }

            @Override
            public Node.OfPrimitive getChild(int i) {
                return Node.OfPrimitive.CC.$default$getChild((Node.OfPrimitive) this, i);
            }

            @Override
            public Node getChild(int i) {
                return getChild(i);
            }

            @Override
            public int[] newArray(int i) {
                return Node.OfInt.CC.m14254$default$newArray((Node.OfInt) this, i);
            }

            @Override
            public Node.OfInt truncate(long j, long j2, IntFunction intFunction) {
                return Node.OfInt.CC.$default$truncate((Node.OfInt) this, j, j2, intFunction);
            }

            @Override
            public Node truncate(long j, long j2, IntFunction intFunction) {
                return truncate(j, j2, intFunction);
            }

            OfInt() {
            }

            @Override
            public Spliterator.OfInt spliterator() {
                return Spliterators.emptyIntSpliterator();
            }

            @Override
            public int[] asPrimitiveArray() {
                return Nodes.EMPTY_INT_ARRAY;
            }
        }

        private static final class OfLong extends EmptyNode implements Node.OfLong {
            @Override
            public void copyInto(Long[] lArr, int i) {
                Node.OfLong.CC.$default$copyInto((Node.OfLong) this, lArr, i);
            }

            @Override
            public void copyInto(Object[] objArr, int i) {
                copyInto((Long[]) objArr, i);
            }

            @Override
            public void forEach(Consumer consumer) {
                Node.OfLong.CC.$default$forEach(this, consumer);
            }

            @Override
            public Node.OfPrimitive getChild(int i) {
                return Node.OfPrimitive.CC.$default$getChild((Node.OfPrimitive) this, i);
            }

            @Override
            public Node getChild(int i) {
                return getChild(i);
            }

            @Override
            public long[] newArray(int i) {
                return Node.OfLong.CC.m14256$default$newArray((Node.OfLong) this, i);
            }

            @Override
            public Node.OfLong truncate(long j, long j2, IntFunction intFunction) {
                return Node.OfLong.CC.$default$truncate((Node.OfLong) this, j, j2, intFunction);
            }

            @Override
            public Node truncate(long j, long j2, IntFunction intFunction) {
                return truncate(j, j2, intFunction);
            }

            OfLong() {
            }

            @Override
            public Spliterator.OfLong spliterator() {
                return Spliterators.emptyLongSpliterator();
            }

            @Override
            public long[] asPrimitiveArray() {
                return Nodes.EMPTY_LONG_ARRAY;
            }
        }

        private static final class OfDouble extends EmptyNode implements Node.OfDouble {
            @Override
            public void copyInto(Double[] dArr, int i) {
                Node.OfDouble.CC.$default$copyInto((Node.OfDouble) this, dArr, i);
            }

            @Override
            public void copyInto(Object[] objArr, int i) {
                copyInto((Double[]) objArr, i);
            }

            @Override
            public void forEach(Consumer consumer) {
                Node.OfDouble.CC.$default$forEach(this, consumer);
            }

            @Override
            public Node.OfPrimitive getChild(int i) {
                return Node.OfPrimitive.CC.$default$getChild((Node.OfPrimitive) this, i);
            }

            @Override
            public Node getChild(int i) {
                return getChild(i);
            }

            @Override
            public double[] newArray(int i) {
                return Node.OfDouble.CC.m14252$default$newArray((Node.OfDouble) this, i);
            }

            @Override
            public Node.OfDouble truncate(long j, long j2, IntFunction intFunction) {
                return Node.OfDouble.CC.$default$truncate((Node.OfDouble) this, j, j2, intFunction);
            }

            @Override
            public Node truncate(long j, long j2, IntFunction intFunction) {
                return truncate(j, j2, intFunction);
            }

            OfDouble() {
            }

            @Override
            public Spliterator.OfDouble spliterator() {
                return Spliterators.emptyDoubleSpliterator();
            }

            @Override
            public double[] asPrimitiveArray() {
                return Nodes.EMPTY_DOUBLE_ARRAY;
            }
        }
    }

    private static class ArrayNode implements Node {
        final Object[] array;
        int curSize;

        @Override
        public Node getChild(int i) {
            return Node.CC.$default$getChild(this, i);
        }

        @Override
        public int getChildCount() {
            return Node.CC.$default$getChildCount(this);
        }

        @Override
        public Node truncate(long j, long j2, IntFunction intFunction) {
            return Node.CC.$default$truncate(this, j, j2, intFunction);
        }

        ArrayNode(long j, IntFunction intFunction) {
            if (j >= 2147483639) {
                throw new IllegalArgumentException("Stream size exceeds max array size");
            }
            this.array = (Object[]) intFunction.apply((int) j);
            this.curSize = 0;
        }

        ArrayNode(Object[] objArr) {
            this.array = objArr;
            this.curSize = objArr.length;
        }

        @Override
        public Spliterator spliterator() {
            return DesugarArrays.spliterator(this.array, 0, this.curSize);
        }

        @Override
        public void copyInto(Object[] objArr, int i) {
            System.arraycopy(this.array, 0, objArr, i, this.curSize);
        }

        @Override
        public Object[] asArray(IntFunction intFunction) {
            Object[] objArr = this.array;
            if (objArr.length == this.curSize) {
                return objArr;
            }
            throw new IllegalStateException();
        }

        @Override
        public long count() {
            return this.curSize;
        }

        @Override
        public void forEach(Consumer consumer) {
            for (int i = 0; i < this.curSize; i++) {
                consumer.accept(this.array[i]);
            }
        }

        public String toString() {
            return String.format("ArrayNode[%d][%s]", Integer.valueOf(this.array.length - this.curSize), Arrays.toString(this.array));
        }
    }

    private static final class CollectionNode implements Node {

        private final Collection f1385c;

        @Override
        public Node getChild(int i) {
            return Node.CC.$default$getChild(this, i);
        }

        @Override
        public int getChildCount() {
            return Node.CC.$default$getChildCount(this);
        }

        @Override
        public Node truncate(long j, long j2, IntFunction intFunction) {
            return Node.CC.$default$truncate(this, j, j2, intFunction);
        }

        CollectionNode(Collection collection) {
            this.f1385c = collection;
        }

        @Override
        public Spliterator spliterator() {
            return p000j$.util.Collection.EL.stream(this.f1385c).spliterator();
        }

        @Override
        public void copyInto(Object[] objArr, int i) {
            Iterator it = this.f1385c.iterator();
            while (it.hasNext()) {
                objArr[i] = it.next();
                i++;
            }
        }

        @Override
        public Object[] asArray(IntFunction intFunction) {
            Collection collection = this.f1385c;
            return collection.toArray((Object[]) intFunction.apply(collection.size()));
        }

        @Override
        public long count() {
            return this.f1385c.size();
        }

        @Override
        public void forEach(Consumer consumer) {
            p000j$.util.Collection.EL.forEach(this.f1385c, consumer);
        }

        public String toString() {
            return String.format("CollectionNode[%d][%s]", Integer.valueOf(this.f1385c.size()), this.f1385c);
        }
    }

    private static abstract class AbstractConcNode implements Node {
        protected final Node left;
        protected final Node right;
        private final long size;

        @Override
        public int getChildCount() {
            return 2;
        }

        public StreamShape getShape() {
            return StreamShape.REFERENCE;
        }

        AbstractConcNode(Node node, Node node2) {
            this.left = node;
            this.right = node2;
            this.size = node.count() + node2.count();
        }

        @Override
        public Node getChild(int i) {
            if (i == 0) {
                return this.left;
            }
            if (i == 1) {
                return this.right;
            }
            throw new IndexOutOfBoundsException();
        }

        @Override
        public long count() {
            return this.size;
        }
    }

    static final class ConcNode extends AbstractConcNode implements Node {
        ConcNode(Node node, Node node2) {
            super(node, node2);
        }

        @Override
        public Spliterator spliterator() {
            return new InternalNodeSpliterator.OfRef(this);
        }

        @Override
        public void copyInto(Object[] objArr, int i) {
            Objects.requireNonNull(objArr);
            this.left.copyInto(objArr, i);
            this.right.copyInto(objArr, i + ((int) this.left.count()));
        }

        @Override
        public Object[] asArray(IntFunction intFunction) {
            long jCount = count();
            if (jCount >= 2147483639) {
                throw new IllegalArgumentException("Stream size exceeds max array size");
            }
            Object[] objArr = (Object[]) intFunction.apply((int) jCount);
            copyInto(objArr, 0);
            return objArr;
        }

        @Override
        public void forEach(Consumer consumer) {
            this.left.forEach(consumer);
            this.right.forEach(consumer);
        }

        @Override
        public Node truncate(long j, long j2, IntFunction intFunction) {
            if (j == 0 && j2 == count()) {
                return this;
            }
            long jCount = this.left.count();
            if (j >= jCount) {
                return this.right.truncate(j - jCount, j2 - jCount, intFunction);
            }
            if (j2 <= jCount) {
                return this.left.truncate(j, j2, intFunction);
            }
            return Nodes.conc(getShape(), this.left.truncate(j, jCount, intFunction), this.right.truncate(0L, j2 - jCount, intFunction));
        }

        public String toString() {
            return count() < 32 ? String.format("ConcNode[%s.%s]", this.left, this.right) : String.format("ConcNode[size=%d]", Long.valueOf(count()));
        }

        private static abstract class OfPrimitive extends AbstractConcNode implements Node.OfPrimitive {
            @Override
            public Object[] asArray(IntFunction intFunction) {
                return Node.OfPrimitive.CC.$default$asArray(this, intFunction);
            }

            @Override
            public Node.OfPrimitive getChild(int i) {
                return (Node.OfPrimitive) super.getChild(i);
            }

            OfPrimitive(Node.OfPrimitive ofPrimitive, Node.OfPrimitive ofPrimitive2) {
                super(ofPrimitive, ofPrimitive2);
            }

            @Override
            public void forEach(Object obj) {
                ((Node.OfPrimitive) this.left).forEach(obj);
                ((Node.OfPrimitive) this.right).forEach(obj);
            }

            @Override
            public void copyInto(Object obj, int i) {
                ((Node.OfPrimitive) this.left).copyInto(obj, i);
                ((Node.OfPrimitive) this.right).copyInto(obj, i + ((int) ((Node.OfPrimitive) this.left).count()));
            }

            @Override
            public Object asPrimitiveArray() {
                long jCount = count();
                if (jCount >= 2147483639) {
                    throw new IllegalArgumentException("Stream size exceeds max array size");
                }
                Object objNewArray = newArray((int) jCount);
                copyInto(objNewArray, 0);
                return objNewArray;
            }

            public String toString() {
                return count() < 32 ? String.format("%s[%s.%s]", getClass().getName(), this.left, this.right) : String.format("%s[size=%d]", getClass().getName(), Long.valueOf(count()));
            }
        }

        static final class OfInt extends OfPrimitive implements Node.OfInt {
            @Override
            public void copyInto(Integer[] numArr, int i) {
                Node.OfInt.CC.$default$copyInto((Node.OfInt) this, numArr, i);
            }

            @Override
            public void copyInto(Object[] objArr, int i) {
                copyInto((Integer[]) objArr, i);
            }

            @Override
            public void forEach(Consumer consumer) {
                Node.OfInt.CC.$default$forEach(this, consumer);
            }

            @Override
            public Object newArray(int i) {
                return newArray(i);
            }

            @Override
            public int[] newArray(int i) {
                return Node.OfInt.CC.m14254$default$newArray((Node.OfInt) this, i);
            }

            @Override
            public Node.OfInt truncate(long j, long j2, IntFunction intFunction) {
                return Node.OfInt.CC.$default$truncate((Node.OfInt) this, j, j2, intFunction);
            }

            @Override
            public Node truncate(long j, long j2, IntFunction intFunction) {
                return truncate(j, j2, intFunction);
            }

            OfInt(Node.OfInt ofInt, Node.OfInt ofInt2) {
                super(ofInt, ofInt2);
            }

            @Override
            public Spliterator.OfInt spliterator() {
                return new InternalNodeSpliterator.OfInt(this);
            }
        }

        static final class OfLong extends OfPrimitive implements Node.OfLong {
            @Override
            public void copyInto(Long[] lArr, int i) {
                Node.OfLong.CC.$default$copyInto((Node.OfLong) this, lArr, i);
            }

            @Override
            public void copyInto(Object[] objArr, int i) {
                copyInto((Long[]) objArr, i);
            }

            @Override
            public void forEach(Consumer consumer) {
                Node.OfLong.CC.$default$forEach(this, consumer);
            }

            @Override
            public Object newArray(int i) {
                return newArray(i);
            }

            @Override
            public long[] newArray(int i) {
                return Node.OfLong.CC.m14256$default$newArray((Node.OfLong) this, i);
            }

            @Override
            public Node.OfLong truncate(long j, long j2, IntFunction intFunction) {
                return Node.OfLong.CC.$default$truncate((Node.OfLong) this, j, j2, intFunction);
            }

            @Override
            public Node truncate(long j, long j2, IntFunction intFunction) {
                return truncate(j, j2, intFunction);
            }

            OfLong(Node.OfLong ofLong, Node.OfLong ofLong2) {
                super(ofLong, ofLong2);
            }

            @Override
            public Spliterator.OfLong spliterator() {
                return new InternalNodeSpliterator.OfLong(this);
            }
        }

        static final class OfDouble extends OfPrimitive implements Node.OfDouble {
            @Override
            public void copyInto(Double[] dArr, int i) {
                Node.OfDouble.CC.$default$copyInto((Node.OfDouble) this, dArr, i);
            }

            @Override
            public void copyInto(Object[] objArr, int i) {
                copyInto((Double[]) objArr, i);
            }

            @Override
            public void forEach(Consumer consumer) {
                Node.OfDouble.CC.$default$forEach(this, consumer);
            }

            @Override
            public Object newArray(int i) {
                return newArray(i);
            }

            @Override
            public double[] newArray(int i) {
                return Node.OfDouble.CC.m14252$default$newArray((Node.OfDouble) this, i);
            }

            @Override
            public Node.OfDouble truncate(long j, long j2, IntFunction intFunction) {
                return Node.OfDouble.CC.$default$truncate((Node.OfDouble) this, j, j2, intFunction);
            }

            @Override
            public Node truncate(long j, long j2, IntFunction intFunction) {
                return truncate(j, j2, intFunction);
            }

            OfDouble(Node.OfDouble ofDouble, Node.OfDouble ofDouble2) {
                super(ofDouble, ofDouble2);
            }

            @Override
            public Spliterator.OfDouble spliterator() {
                return new InternalNodeSpliterator.OfDouble(this);
            }
        }
    }

    private static abstract class InternalNodeSpliterator implements Spliterator {
        int curChildIndex;
        Node curNode;
        Spliterator lastNodeSpliterator;
        Spliterator tryAdvanceSpliterator;
        Deque tryAdvanceStack;

        @Override
        public final int characteristics() {
            return 64;
        }

        @Override
        public Comparator getComparator() {
            return Spliterator.CC.$default$getComparator(this);
        }

        @Override
        public long getExactSizeIfKnown() {
            return Spliterator.CC.$default$getExactSizeIfKnown(this);
        }

        @Override
        public boolean hasCharacteristics(int i) {
            return Spliterator.CC.$default$hasCharacteristics(this, i);
        }

        InternalNodeSpliterator(Node node) {
            this.curNode = node;
        }

        protected final Deque initStack() {
            ArrayDeque arrayDeque = new ArrayDeque(8);
            int childCount = this.curNode.getChildCount();
            while (true) {
                childCount--;
                if (childCount < this.curChildIndex) {
                    return arrayDeque;
                }
                arrayDeque.addFirst(this.curNode.getChild(childCount));
            }
        }

        protected final Node findNextLeafNode(Deque deque) {
            while (true) {
                Node node = (Node) deque.pollFirst();
                if (node == null) {
                    return null;
                }
                if (node.getChildCount() != 0) {
                    for (int childCount = node.getChildCount() - 1; childCount >= 0; childCount--) {
                        deque.addFirst(node.getChild(childCount));
                    }
                } else if (node.count() > 0) {
                    return node;
                }
            }
        }

        protected final boolean initTryAdvance() {
            if (this.curNode == null) {
                return false;
            }
            if (this.tryAdvanceSpliterator != null) {
                return true;
            }
            Spliterator spliterator = this.lastNodeSpliterator;
            if (spliterator == null) {
                Deque dequeInitStack = initStack();
                this.tryAdvanceStack = dequeInitStack;
                Node nodeFindNextLeafNode = findNextLeafNode(dequeInitStack);
                if (nodeFindNextLeafNode != null) {
                    this.tryAdvanceSpliterator = nodeFindNextLeafNode.spliterator();
                    return true;
                }
                this.curNode = null;
                return false;
            }
            this.tryAdvanceSpliterator = spliterator;
            return true;
        }

        @Override
        public final Spliterator trySplit() {
            Node node = this.curNode;
            if (node == null || this.tryAdvanceSpliterator != null) {
                return null;
            }
            Spliterator spliterator = this.lastNodeSpliterator;
            if (spliterator != null) {
                return spliterator.trySplit();
            }
            if (this.curChildIndex < node.getChildCount() - 1) {
                Node node2 = this.curNode;
                int i = this.curChildIndex;
                this.curChildIndex = i + 1;
                return node2.getChild(i).spliterator();
            }
            Node child = this.curNode.getChild(this.curChildIndex);
            this.curNode = child;
            if (child.getChildCount() == 0) {
                Spliterator spliterator2 = this.curNode.spliterator();
                this.lastNodeSpliterator = spliterator2;
                return spliterator2.trySplit();
            }
            Node node3 = this.curNode;
            this.curChildIndex = 1;
            return node3.getChild(0).spliterator();
        }

        @Override
        public final long estimateSize() {
            long jCount = 0;
            if (this.curNode == null) {
                return 0L;
            }
            Spliterator spliterator = this.lastNodeSpliterator;
            if (spliterator != null) {
                return spliterator.estimateSize();
            }
            for (int i = this.curChildIndex; i < this.curNode.getChildCount(); i++) {
                jCount += this.curNode.getChild(i).count();
            }
            return jCount;
        }

        private static final class OfRef extends InternalNodeSpliterator {
            OfRef(Node node) {
                super(node);
            }

            @Override
            public boolean tryAdvance(Consumer consumer) {
                Node nodeFindNextLeafNode;
                if (!initTryAdvance()) {
                    return false;
                }
                boolean zTryAdvance = this.tryAdvanceSpliterator.tryAdvance(consumer);
                if (!zTryAdvance) {
                    if (this.lastNodeSpliterator == null && (nodeFindNextLeafNode = findNextLeafNode(this.tryAdvanceStack)) != null) {
                        Spliterator spliterator = nodeFindNextLeafNode.spliterator();
                        this.tryAdvanceSpliterator = spliterator;
                        return spliterator.tryAdvance(consumer);
                    }
                    this.curNode = null;
                }
                return zTryAdvance;
            }

            @Override
            public void forEachRemaining(Consumer consumer) {
                if (this.curNode == null) {
                    return;
                }
                if (this.tryAdvanceSpliterator == null) {
                    Spliterator spliterator = this.lastNodeSpliterator;
                    if (spliterator == null) {
                        Deque dequeInitStack = initStack();
                        while (true) {
                            Node nodeFindNextLeafNode = findNextLeafNode(dequeInitStack);
                            if (nodeFindNextLeafNode != null) {
                                nodeFindNextLeafNode.forEach(consumer);
                            } else {
                                this.curNode = null;
                                return;
                            }
                        }
                    } else {
                        spliterator.forEachRemaining(consumer);
                    }
                } else {
                    while (tryAdvance(consumer)) {
                    }
                }
            }
        }

        private static abstract class OfPrimitive extends InternalNodeSpliterator implements Spliterator.OfPrimitive {
            @Override
            public Spliterator.OfPrimitive trySplit() {
                return (Spliterator.OfPrimitive) super.trySplit();
            }

            OfPrimitive(Node.OfPrimitive ofPrimitive) {
                super(ofPrimitive);
            }

            @Override
            public boolean tryAdvance(Object obj) {
                Node.OfPrimitive ofPrimitive;
                if (!initTryAdvance()) {
                    return false;
                }
                boolean zTryAdvance = ((Spliterator.OfPrimitive) this.tryAdvanceSpliterator).tryAdvance(obj);
                if (!zTryAdvance) {
                    if (this.lastNodeSpliterator == null && (ofPrimitive = (Node.OfPrimitive) findNextLeafNode(this.tryAdvanceStack)) != null) {
                        Spliterator.OfPrimitive ofPrimitiveSpliterator = ofPrimitive.spliterator();
                        this.tryAdvanceSpliterator = ofPrimitiveSpliterator;
                        return ofPrimitiveSpliterator.tryAdvance(obj);
                    }
                    this.curNode = null;
                }
                return zTryAdvance;
            }

            @Override
            public void forEachRemaining(Object obj) {
                if (this.curNode == null) {
                    return;
                }
                if (this.tryAdvanceSpliterator == null) {
                    Spliterator spliterator = this.lastNodeSpliterator;
                    if (spliterator == null) {
                        Deque dequeInitStack = initStack();
                        while (true) {
                            Node.OfPrimitive ofPrimitive = (Node.OfPrimitive) findNextLeafNode(dequeInitStack);
                            if (ofPrimitive != null) {
                                ofPrimitive.forEach(obj);
                            } else {
                                this.curNode = null;
                                return;
                            }
                        }
                    } else {
                        ((Spliterator.OfPrimitive) spliterator).forEachRemaining(obj);
                    }
                } else {
                    while (tryAdvance(obj)) {
                    }
                }
            }
        }

        private static final class OfInt extends OfPrimitive implements Spliterator.OfInt {
            @Override
            public void forEachRemaining(Consumer consumer) {
                Spliterator.OfInt.CC.$default$forEachRemaining((Spliterator.OfInt) this, consumer);
            }

            @Override
            public boolean tryAdvance(Consumer consumer) {
                return Spliterator.OfInt.CC.$default$tryAdvance(this, consumer);
            }

            @Override
            public void forEachRemaining(IntConsumer intConsumer) {
                super.forEachRemaining((Object) intConsumer);
            }

            @Override
            public boolean tryAdvance(IntConsumer intConsumer) {
                return super.tryAdvance((Object) intConsumer);
            }

            @Override
            public Spliterator.OfInt trySplit() {
                return (Spliterator.OfInt) super.trySplit();
            }

            OfInt(Node.OfInt ofInt) {
                super(ofInt);
            }
        }

        private static final class OfLong extends OfPrimitive implements Spliterator.OfLong {
            @Override
            public void forEachRemaining(Consumer consumer) {
                Spliterator.OfLong.CC.$default$forEachRemaining((Spliterator.OfLong) this, consumer);
            }

            @Override
            public boolean tryAdvance(Consumer consumer) {
                return Spliterator.OfLong.CC.$default$tryAdvance(this, consumer);
            }

            @Override
            public void forEachRemaining(LongConsumer longConsumer) {
                super.forEachRemaining((Object) longConsumer);
            }

            @Override
            public boolean tryAdvance(LongConsumer longConsumer) {
                return super.tryAdvance((Object) longConsumer);
            }

            @Override
            public Spliterator.OfLong trySplit() {
                return (Spliterator.OfLong) super.trySplit();
            }

            OfLong(Node.OfLong ofLong) {
                super(ofLong);
            }
        }

        private static final class OfDouble extends OfPrimitive implements Spliterator.OfDouble {
            @Override
            public void forEachRemaining(Consumer consumer) {
                Spliterator.OfDouble.CC.$default$forEachRemaining((Spliterator.OfDouble) this, consumer);
            }

            @Override
            public boolean tryAdvance(Consumer consumer) {
                return Spliterator.OfDouble.CC.$default$tryAdvance(this, consumer);
            }

            @Override
            public void forEachRemaining(DoubleConsumer doubleConsumer) {
                super.forEachRemaining((Object) doubleConsumer);
            }

            @Override
            public boolean tryAdvance(DoubleConsumer doubleConsumer) {
                return super.tryAdvance((Object) doubleConsumer);
            }

            @Override
            public Spliterator.OfDouble trySplit() {
                return (Spliterator.OfDouble) super.trySplit();
            }

            OfDouble(Node.OfDouble ofDouble) {
                super(ofDouble);
            }
        }
    }

    private static final class FixedNodeBuilder extends ArrayNode implements Node.Builder {
        @Override
        public void accept(double d) {
            Sink.CC.$default$accept(this, d);
        }

        @Override
        public void accept(int i) {
            Sink.CC.$default$accept((Sink) this, i);
        }

        @Override
        public void accept(long j) {
            Sink.CC.$default$accept((Sink) this, j);
        }

        public Consumer andThen(Consumer consumer) {
            return Consumer$CC.$default$andThen(this, consumer);
        }

        @Override
        public boolean cancellationRequested() {
            return Sink.CC.$default$cancellationRequested(this);
        }

        FixedNodeBuilder(long j, IntFunction intFunction) {
            super(j, intFunction);
        }

        @Override
        public Node build() {
            if (this.curSize >= this.array.length) {
                return this;
            }
            throw new IllegalStateException(String.format("Current size %d is less than fixed size %d", Integer.valueOf(this.curSize), Integer.valueOf(this.array.length)));
        }

        @Override
        public void begin(long j) {
            if (j != this.array.length) {
                throw new IllegalStateException(String.format("Begin size %d is not equal to fixed size %d", Long.valueOf(j), Integer.valueOf(this.array.length)));
            }
            this.curSize = 0;
        }

        @Override
        public void accept(Object obj) {
            int i = this.curSize;
            Object[] objArr = this.array;
            if (i < objArr.length) {
                this.curSize = 1 + i;
                objArr[i] = obj;
                return;
            }
            throw new IllegalStateException(String.format("Accept exceeded fixed size of %d", Integer.valueOf(this.array.length)));
        }

        @Override
        public void end() {
            if (this.curSize < this.array.length) {
                throw new IllegalStateException(String.format("End size %d is less than fixed size %d", Integer.valueOf(this.curSize), Integer.valueOf(this.array.length)));
            }
        }

        @Override
        public String toString() {
            return String.format("FixedNodeBuilder[%d][%s]", Integer.valueOf(this.array.length - this.curSize), Arrays.toString(this.array));
        }
    }

    private static final class SpinedNodeBuilder extends SpinedBuffer implements Node, Node.Builder {
        private boolean building = false;

        @Override
        public void accept(double d) {
            Sink.CC.$default$accept(this, d);
        }

        @Override
        public void accept(int i) {
            Sink.CC.$default$accept((Sink) this, i);
        }

        @Override
        public void accept(long j) {
            Sink.CC.$default$accept((Sink) this, j);
        }

        @Override
        public Node build() {
            return this;
        }

        @Override
        public boolean cancellationRequested() {
            return Sink.CC.$default$cancellationRequested(this);
        }

        @Override
        public Node getChild(int i) {
            return Node.CC.$default$getChild(this, i);
        }

        @Override
        public int getChildCount() {
            return Node.CC.$default$getChildCount(this);
        }

        @Override
        public Node truncate(long j, long j2, IntFunction intFunction) {
            return Node.CC.$default$truncate(this, j, j2, intFunction);
        }

        SpinedNodeBuilder() {
        }

        @Override
        public Spliterator spliterator() {
            return super.spliterator();
        }

        @Override
        public void forEach(Consumer consumer) {
            super.forEach(consumer);
        }

        @Override
        public void begin(long j) {
            this.building = true;
            clear();
            ensureCapacity(j);
        }

        @Override
        public void accept(Object obj) {
            super.accept(obj);
        }

        @Override
        public void end() {
            this.building = false;
        }

        @Override
        public void copyInto(Object[] objArr, int i) {
            super.copyInto(objArr, i);
        }

        @Override
        public Object[] asArray(IntFunction intFunction) {
            return super.asArray(intFunction);
        }
    }

    private static class IntArrayNode implements Node.OfInt {
        final int[] array;
        int curSize;

        @Override
        public Object[] asArray(IntFunction intFunction) {
            return Node.OfPrimitive.CC.$default$asArray(this, intFunction);
        }

        @Override
        public void copyInto(Integer[] numArr, int i) {
            Node.OfInt.CC.$default$copyInto((Node.OfInt) this, numArr, i);
        }

        @Override
        public void copyInto(Object[] objArr, int i) {
            copyInto((Integer[]) objArr, i);
        }

        @Override
        public void forEach(Consumer consumer) {
            Node.OfInt.CC.$default$forEach(this, consumer);
        }

        @Override
        public Node.OfPrimitive getChild(int i) {
            return Node.OfPrimitive.CC.$default$getChild((Node.OfPrimitive) this, i);
        }

        @Override
        public Node getChild(int i) {
            return getChild(i);
        }

        @Override
        public int getChildCount() {
            return Node.CC.$default$getChildCount(this);
        }

        @Override
        public int[] newArray(int i) {
            return Node.OfInt.CC.m14254$default$newArray((Node.OfInt) this, i);
        }

        @Override
        public Node.OfInt truncate(long j, long j2, IntFunction intFunction) {
            return Node.OfInt.CC.$default$truncate((Node.OfInt) this, j, j2, intFunction);
        }

        @Override
        public Node truncate(long j, long j2, IntFunction intFunction) {
            return truncate(j, j2, intFunction);
        }

        IntArrayNode(long j) {
            if (j >= 2147483639) {
                throw new IllegalArgumentException("Stream size exceeds max array size");
            }
            this.array = new int[(int) j];
            this.curSize = 0;
        }

        IntArrayNode(int[] iArr) {
            this.array = iArr;
            this.curSize = iArr.length;
        }

        @Override
        public Spliterator.OfInt spliterator() {
            return DesugarArrays.spliterator(this.array, 0, this.curSize);
        }

        @Override
        public int[] asPrimitiveArray() {
            int[] iArr = this.array;
            int length = iArr.length;
            int i = this.curSize;
            return length == i ? iArr : Arrays.copyOf(iArr, i);
        }

        @Override
        public void copyInto(int[] iArr, int i) {
            System.arraycopy(this.array, 0, iArr, i, this.curSize);
        }

        @Override
        public long count() {
            return this.curSize;
        }

        @Override
        public void forEach(IntConsumer intConsumer) {
            for (int i = 0; i < this.curSize; i++) {
                intConsumer.accept(this.array[i]);
            }
        }

        public String toString() {
            return String.format("IntArrayNode[%d][%s]", Integer.valueOf(this.array.length - this.curSize), Arrays.toString(this.array));
        }
    }

    private static class LongArrayNode implements Node.OfLong {
        final long[] array;
        int curSize;

        @Override
        public Object[] asArray(IntFunction intFunction) {
            return Node.OfPrimitive.CC.$default$asArray(this, intFunction);
        }

        @Override
        public void copyInto(Long[] lArr, int i) {
            Node.OfLong.CC.$default$copyInto((Node.OfLong) this, lArr, i);
        }

        @Override
        public void copyInto(Object[] objArr, int i) {
            copyInto((Long[]) objArr, i);
        }

        @Override
        public void forEach(Consumer consumer) {
            Node.OfLong.CC.$default$forEach(this, consumer);
        }

        @Override
        public Node.OfPrimitive getChild(int i) {
            return Node.OfPrimitive.CC.$default$getChild((Node.OfPrimitive) this, i);
        }

        @Override
        public Node getChild(int i) {
            return getChild(i);
        }

        @Override
        public int getChildCount() {
            return Node.CC.$default$getChildCount(this);
        }

        @Override
        public long[] newArray(int i) {
            return Node.OfLong.CC.m14256$default$newArray((Node.OfLong) this, i);
        }

        @Override
        public Node.OfLong truncate(long j, long j2, IntFunction intFunction) {
            return Node.OfLong.CC.$default$truncate((Node.OfLong) this, j, j2, intFunction);
        }

        @Override
        public Node truncate(long j, long j2, IntFunction intFunction) {
            return truncate(j, j2, intFunction);
        }

        LongArrayNode(long j) {
            if (j >= 2147483639) {
                throw new IllegalArgumentException("Stream size exceeds max array size");
            }
            this.array = new long[(int) j];
            this.curSize = 0;
        }

        LongArrayNode(long[] jArr) {
            this.array = jArr;
            this.curSize = jArr.length;
        }

        @Override
        public Spliterator.OfLong spliterator() {
            return DesugarArrays.spliterator(this.array, 0, this.curSize);
        }

        @Override
        public long[] asPrimitiveArray() {
            long[] jArr = this.array;
            int length = jArr.length;
            int i = this.curSize;
            return length == i ? jArr : Arrays.copyOf(jArr, i);
        }

        @Override
        public void copyInto(long[] jArr, int i) {
            System.arraycopy(this.array, 0, jArr, i, this.curSize);
        }

        @Override
        public long count() {
            return this.curSize;
        }

        @Override
        public void forEach(LongConsumer longConsumer) {
            for (int i = 0; i < this.curSize; i++) {
                longConsumer.accept(this.array[i]);
            }
        }

        public String toString() {
            return String.format("LongArrayNode[%d][%s]", Integer.valueOf(this.array.length - this.curSize), Arrays.toString(this.array));
        }
    }

    private static class DoubleArrayNode implements Node.OfDouble {
        final double[] array;
        int curSize;

        @Override
        public Object[] asArray(IntFunction intFunction) {
            return Node.OfPrimitive.CC.$default$asArray(this, intFunction);
        }

        @Override
        public void copyInto(Double[] dArr, int i) {
            Node.OfDouble.CC.$default$copyInto((Node.OfDouble) this, dArr, i);
        }

        @Override
        public void copyInto(Object[] objArr, int i) {
            copyInto((Double[]) objArr, i);
        }

        @Override
        public void forEach(Consumer consumer) {
            Node.OfDouble.CC.$default$forEach(this, consumer);
        }

        @Override
        public Node.OfPrimitive getChild(int i) {
            return Node.OfPrimitive.CC.$default$getChild((Node.OfPrimitive) this, i);
        }

        @Override
        public Node getChild(int i) {
            return getChild(i);
        }

        @Override
        public int getChildCount() {
            return Node.CC.$default$getChildCount(this);
        }

        @Override
        public double[] newArray(int i) {
            return Node.OfDouble.CC.m14252$default$newArray((Node.OfDouble) this, i);
        }

        @Override
        public Node.OfDouble truncate(long j, long j2, IntFunction intFunction) {
            return Node.OfDouble.CC.$default$truncate((Node.OfDouble) this, j, j2, intFunction);
        }

        @Override
        public Node truncate(long j, long j2, IntFunction intFunction) {
            return truncate(j, j2, intFunction);
        }

        DoubleArrayNode(long j) {
            if (j >= 2147483639) {
                throw new IllegalArgumentException("Stream size exceeds max array size");
            }
            this.array = new double[(int) j];
            this.curSize = 0;
        }

        DoubleArrayNode(double[] dArr) {
            this.array = dArr;
            this.curSize = dArr.length;
        }

        @Override
        public Spliterator.OfDouble spliterator() {
            return DesugarArrays.spliterator(this.array, 0, this.curSize);
        }

        @Override
        public double[] asPrimitiveArray() {
            double[] dArr = this.array;
            int length = dArr.length;
            int i = this.curSize;
            return length == i ? dArr : Arrays.copyOf(dArr, i);
        }

        @Override
        public void copyInto(double[] dArr, int i) {
            System.arraycopy(this.array, 0, dArr, i, this.curSize);
        }

        @Override
        public long count() {
            return this.curSize;
        }

        @Override
        public void forEach(DoubleConsumer doubleConsumer) {
            for (int i = 0; i < this.curSize; i++) {
                doubleConsumer.accept(this.array[i]);
            }
        }

        public String toString() {
            return String.format("DoubleArrayNode[%d][%s]", Integer.valueOf(this.array.length - this.curSize), Arrays.toString(this.array));
        }
    }

    private static final class IntFixedNodeBuilder extends IntArrayNode implements Node.Builder.OfInt {
        @Override
        public void accept(double d) {
            Sink.CC.$default$accept(this, d);
        }

        @Override
        public void accept(long j) {
            Sink.CC.$default$accept((Sink) this, j);
        }

        @Override
        public void accept(Integer num) {
            Sink.OfInt.CC.$default$accept((Sink.OfInt) this, num);
        }

        @Override
        public void accept(Object obj) {
            Sink.OfInt.CC.$default$accept(this, obj);
        }

        public Consumer andThen(Consumer consumer) {
            return Consumer$CC.$default$andThen(this, consumer);
        }

        public IntConsumer andThen(IntConsumer intConsumer) {
            return IntConsumer$CC.$default$andThen(this, intConsumer);
        }

        @Override
        public boolean cancellationRequested() {
            return Sink.CC.$default$cancellationRequested(this);
        }

        IntFixedNodeBuilder(long j) {
            super(j);
        }

        @Override
        public Node.OfInt build() {
            if (this.curSize >= this.array.length) {
                return this;
            }
            throw new IllegalStateException(String.format("Current size %d is less than fixed size %d", Integer.valueOf(this.curSize), Integer.valueOf(this.array.length)));
        }

        @Override
        public void begin(long j) {
            if (j != this.array.length) {
                throw new IllegalStateException(String.format("Begin size %d is not equal to fixed size %d", Long.valueOf(j), Integer.valueOf(this.array.length)));
            }
            this.curSize = 0;
        }

        @Override
        public void accept(int i) {
            int i2 = this.curSize;
            int[] iArr = this.array;
            if (i2 < iArr.length) {
                this.curSize = 1 + i2;
                iArr[i2] = i;
                return;
            }
            throw new IllegalStateException(String.format("Accept exceeded fixed size of %d", Integer.valueOf(this.array.length)));
        }

        @Override
        public void end() {
            if (this.curSize < this.array.length) {
                throw new IllegalStateException(String.format("End size %d is less than fixed size %d", Integer.valueOf(this.curSize), Integer.valueOf(this.array.length)));
            }
        }

        @Override
        public String toString() {
            return String.format("IntFixedNodeBuilder[%d][%s]", Integer.valueOf(this.array.length - this.curSize), Arrays.toString(this.array));
        }
    }

    private static final class LongFixedNodeBuilder extends LongArrayNode implements Node.Builder.OfLong {
        @Override
        public void accept(double d) {
            Sink.CC.$default$accept(this, d);
        }

        @Override
        public void accept(int i) {
            Sink.CC.$default$accept((Sink) this, i);
        }

        @Override
        public void accept(Long l) {
            Sink.OfLong.CC.$default$accept((Sink.OfLong) this, l);
        }

        @Override
        public void accept(Object obj) {
            Sink.OfLong.CC.$default$accept(this, obj);
        }

        public Consumer andThen(Consumer consumer) {
            return Consumer$CC.$default$andThen(this, consumer);
        }

        public LongConsumer andThen(LongConsumer longConsumer) {
            return LongConsumer$CC.$default$andThen(this, longConsumer);
        }

        @Override
        public boolean cancellationRequested() {
            return Sink.CC.$default$cancellationRequested(this);
        }

        LongFixedNodeBuilder(long j) {
            super(j);
        }

        @Override
        public Node.OfLong build() {
            if (this.curSize >= this.array.length) {
                return this;
            }
            throw new IllegalStateException(String.format("Current size %d is less than fixed size %d", Integer.valueOf(this.curSize), Integer.valueOf(this.array.length)));
        }

        @Override
        public void begin(long j) {
            if (j != this.array.length) {
                throw new IllegalStateException(String.format("Begin size %d is not equal to fixed size %d", Long.valueOf(j), Integer.valueOf(this.array.length)));
            }
            this.curSize = 0;
        }

        @Override
        public void accept(long j) {
            int i = this.curSize;
            long[] jArr = this.array;
            if (i < jArr.length) {
                this.curSize = 1 + i;
                jArr[i] = j;
                return;
            }
            throw new IllegalStateException(String.format("Accept exceeded fixed size of %d", Integer.valueOf(this.array.length)));
        }

        @Override
        public void end() {
            if (this.curSize < this.array.length) {
                throw new IllegalStateException(String.format("End size %d is less than fixed size %d", Integer.valueOf(this.curSize), Integer.valueOf(this.array.length)));
            }
        }

        @Override
        public String toString() {
            return String.format("LongFixedNodeBuilder[%d][%s]", Integer.valueOf(this.array.length - this.curSize), Arrays.toString(this.array));
        }
    }

    private static final class DoubleFixedNodeBuilder extends DoubleArrayNode implements Node.Builder.OfDouble {
        @Override
        public void accept(int i) {
            Sink.CC.$default$accept((Sink) this, i);
        }

        @Override
        public void accept(long j) {
            Sink.CC.$default$accept((Sink) this, j);
        }

        @Override
        public void accept(Double d) {
            Sink.OfDouble.CC.$default$accept((Sink.OfDouble) this, d);
        }

        @Override
        public void accept(Object obj) {
            Sink.OfDouble.CC.$default$accept(this, obj);
        }

        public Consumer andThen(Consumer consumer) {
            return Consumer$CC.$default$andThen(this, consumer);
        }

        public DoubleConsumer andThen(DoubleConsumer doubleConsumer) {
            return DoubleConsumer$CC.$default$andThen(this, doubleConsumer);
        }

        @Override
        public boolean cancellationRequested() {
            return Sink.CC.$default$cancellationRequested(this);
        }

        DoubleFixedNodeBuilder(long j) {
            super(j);
        }

        @Override
        public Node.OfDouble build() {
            if (this.curSize >= this.array.length) {
                return this;
            }
            throw new IllegalStateException(String.format("Current size %d is less than fixed size %d", Integer.valueOf(this.curSize), Integer.valueOf(this.array.length)));
        }

        @Override
        public void begin(long j) {
            if (j != this.array.length) {
                throw new IllegalStateException(String.format("Begin size %d is not equal to fixed size %d", Long.valueOf(j), Integer.valueOf(this.array.length)));
            }
            this.curSize = 0;
        }

        @Override
        public void accept(double d) {
            int i = this.curSize;
            double[] dArr = this.array;
            if (i < dArr.length) {
                this.curSize = 1 + i;
                dArr[i] = d;
                return;
            }
            throw new IllegalStateException(String.format("Accept exceeded fixed size of %d", Integer.valueOf(this.array.length)));
        }

        @Override
        public void end() {
            if (this.curSize < this.array.length) {
                throw new IllegalStateException(String.format("End size %d is less than fixed size %d", Integer.valueOf(this.curSize), Integer.valueOf(this.array.length)));
            }
        }

        @Override
        public String toString() {
            return String.format("DoubleFixedNodeBuilder[%d][%s]", Integer.valueOf(this.array.length - this.curSize), Arrays.toString(this.array));
        }
    }

    private static final class IntSpinedNodeBuilder extends SpinedBuffer.OfInt implements Node.OfInt, Node.Builder.OfInt {
        private boolean building = false;

        @Override
        public void accept(double d) {
            Sink.CC.$default$accept(this, d);
        }

        @Override
        public void accept(long j) {
            Sink.CC.$default$accept((Sink) this, j);
        }

        @Override
        public void accept(Integer num) {
            Sink.OfInt.CC.$default$accept((Sink.OfInt) this, num);
        }

        @Override
        public void accept(Object obj) {
            Sink.OfInt.CC.$default$accept(this, obj);
        }

        public Consumer andThen(Consumer consumer) {
            return Consumer$CC.$default$andThen(this, consumer);
        }

        @Override
        public Object[] asArray(IntFunction intFunction) {
            return Node.OfPrimitive.CC.$default$asArray(this, intFunction);
        }

        @Override
        public Node.OfInt build() {
            return this;
        }

        @Override
        public boolean cancellationRequested() {
            return Sink.CC.$default$cancellationRequested(this);
        }

        @Override
        public void copyInto(Integer[] numArr, int i) {
            Node.OfInt.CC.$default$copyInto((Node.OfInt) this, numArr, i);
        }

        @Override
        public void copyInto(Object[] objArr, int i) {
            copyInto((Integer[]) objArr, i);
        }

        @Override
        public Node.OfPrimitive getChild(int i) {
            return Node.OfPrimitive.CC.$default$getChild((Node.OfPrimitive) this, i);
        }

        @Override
        public Node getChild(int i) {
            return getChild(i);
        }

        @Override
        public int getChildCount() {
            return Node.CC.$default$getChildCount(this);
        }

        @Override
        public Node.OfInt truncate(long j, long j2, IntFunction intFunction) {
            return Node.OfInt.CC.$default$truncate((Node.OfInt) this, j, j2, intFunction);
        }

        @Override
        public Node truncate(long j, long j2, IntFunction intFunction) {
            return truncate(j, j2, intFunction);
        }

        IntSpinedNodeBuilder() {
        }

        @Override
        public Spliterator.OfInt spliterator() {
            return super.spliterator();
        }

        @Override
        public void forEach(IntConsumer intConsumer) {
            super.forEach((Object) intConsumer);
        }

        @Override
        public void begin(long j) {
            this.building = true;
            clear();
            ensureCapacity(j);
        }

        @Override
        public void accept(int i) {
            super.accept(i);
        }

        @Override
        public void end() {
            this.building = false;
        }

        @Override
        public void copyInto(int[] iArr, int i) {
            super.copyInto((Object) iArr, i);
        }

        @Override
        public int[] asPrimitiveArray() {
            return (int[]) super.asPrimitiveArray();
        }
    }

    private static final class LongSpinedNodeBuilder extends SpinedBuffer.OfLong implements Node.OfLong, Node.Builder.OfLong {
        private boolean building = false;

        @Override
        public void accept(double d) {
            Sink.CC.$default$accept(this, d);
        }

        @Override
        public void accept(int i) {
            Sink.CC.$default$accept((Sink) this, i);
        }

        @Override
        public void accept(Long l) {
            Sink.OfLong.CC.$default$accept((Sink.OfLong) this, l);
        }

        @Override
        public void accept(Object obj) {
            Sink.OfLong.CC.$default$accept(this, obj);
        }

        public Consumer andThen(Consumer consumer) {
            return Consumer$CC.$default$andThen(this, consumer);
        }

        @Override
        public Object[] asArray(IntFunction intFunction) {
            return Node.OfPrimitive.CC.$default$asArray(this, intFunction);
        }

        @Override
        public Node.OfLong build() {
            return this;
        }

        @Override
        public boolean cancellationRequested() {
            return Sink.CC.$default$cancellationRequested(this);
        }

        @Override
        public void copyInto(Long[] lArr, int i) {
            Node.OfLong.CC.$default$copyInto((Node.OfLong) this, lArr, i);
        }

        @Override
        public void copyInto(Object[] objArr, int i) {
            copyInto((Long[]) objArr, i);
        }

        @Override
        public Node.OfPrimitive getChild(int i) {
            return Node.OfPrimitive.CC.$default$getChild((Node.OfPrimitive) this, i);
        }

        @Override
        public Node getChild(int i) {
            return getChild(i);
        }

        @Override
        public int getChildCount() {
            return Node.CC.$default$getChildCount(this);
        }

        @Override
        public Node.OfLong truncate(long j, long j2, IntFunction intFunction) {
            return Node.OfLong.CC.$default$truncate((Node.OfLong) this, j, j2, intFunction);
        }

        @Override
        public Node truncate(long j, long j2, IntFunction intFunction) {
            return truncate(j, j2, intFunction);
        }

        LongSpinedNodeBuilder() {
        }

        @Override
        public Spliterator.OfLong spliterator() {
            return super.spliterator();
        }

        @Override
        public void forEach(LongConsumer longConsumer) {
            super.forEach((Object) longConsumer);
        }

        @Override
        public void begin(long j) {
            this.building = true;
            clear();
            ensureCapacity(j);
        }

        @Override
        public void accept(long j) {
            super.accept(j);
        }

        @Override
        public void end() {
            this.building = false;
        }

        @Override
        public void copyInto(long[] jArr, int i) {
            super.copyInto((Object) jArr, i);
        }

        @Override
        public long[] asPrimitiveArray() {
            return (long[]) super.asPrimitiveArray();
        }
    }

    private static final class DoubleSpinedNodeBuilder extends SpinedBuffer.OfDouble implements Node.OfDouble, Node.Builder.OfDouble {
        private boolean building = false;

        @Override
        public void accept(int i) {
            Sink.CC.$default$accept((Sink) this, i);
        }

        @Override
        public void accept(long j) {
            Sink.CC.$default$accept((Sink) this, j);
        }

        @Override
        public void accept(Double d) {
            Sink.OfDouble.CC.$default$accept((Sink.OfDouble) this, d);
        }

        @Override
        public void accept(Object obj) {
            Sink.OfDouble.CC.$default$accept(this, obj);
        }

        public Consumer andThen(Consumer consumer) {
            return Consumer$CC.$default$andThen(this, consumer);
        }

        @Override
        public Object[] asArray(IntFunction intFunction) {
            return Node.OfPrimitive.CC.$default$asArray(this, intFunction);
        }

        @Override
        public Node.OfDouble build() {
            return this;
        }

        @Override
        public boolean cancellationRequested() {
            return Sink.CC.$default$cancellationRequested(this);
        }

        @Override
        public void copyInto(Double[] dArr, int i) {
            Node.OfDouble.CC.$default$copyInto((Node.OfDouble) this, dArr, i);
        }

        @Override
        public void copyInto(Object[] objArr, int i) {
            copyInto((Double[]) objArr, i);
        }

        @Override
        public Node.OfPrimitive getChild(int i) {
            return Node.OfPrimitive.CC.$default$getChild((Node.OfPrimitive) this, i);
        }

        @Override
        public Node getChild(int i) {
            return getChild(i);
        }

        @Override
        public int getChildCount() {
            return Node.CC.$default$getChildCount(this);
        }

        @Override
        public Node.OfDouble truncate(long j, long j2, IntFunction intFunction) {
            return Node.OfDouble.CC.$default$truncate((Node.OfDouble) this, j, j2, intFunction);
        }

        @Override
        public Node truncate(long j, long j2, IntFunction intFunction) {
            return truncate(j, j2, intFunction);
        }

        DoubleSpinedNodeBuilder() {
        }

        @Override
        public Spliterator.OfDouble spliterator() {
            return super.spliterator();
        }

        @Override
        public void forEach(DoubleConsumer doubleConsumer) {
            super.forEach((Object) doubleConsumer);
        }

        @Override
        public void begin(long j) {
            this.building = true;
            clear();
            ensureCapacity(j);
        }

        @Override
        public void accept(double d) {
            super.accept(d);
        }

        @Override
        public void end() {
            this.building = false;
        }

        @Override
        public void copyInto(double[] dArr, int i) {
            super.copyInto((Object) dArr, i);
        }

        @Override
        public double[] asPrimitiveArray() {
            return (double[]) super.asPrimitiveArray();
        }
    }

    private static abstract class SizedCollectorTask extends CountedCompleter implements Sink {
        protected int fence;
        protected final PipelineHelper helper;
        protected int index;
        protected long length;
        protected long offset;
        protected final Spliterator spliterator;
        protected final long targetSize;

        @Override
        public void accept(double d) {
            Sink.CC.$default$accept(this, d);
        }

        @Override
        public void accept(int i) {
            Sink.CC.$default$accept((Sink) this, i);
        }

        @Override
        public void accept(long j) {
            Sink.CC.$default$accept((Sink) this, j);
        }

        public Consumer andThen(Consumer consumer) {
            return Consumer$CC.$default$andThen(this, consumer);
        }

        @Override
        public boolean cancellationRequested() {
            return Sink.CC.$default$cancellationRequested(this);
        }

        @Override
        public void end() {
            Sink.CC.$default$end(this);
        }

        abstract SizedCollectorTask makeChild(Spliterator spliterator, long j, long j2);

        SizedCollectorTask(Spliterator spliterator, PipelineHelper pipelineHelper, int i) {
            this.spliterator = spliterator;
            this.helper = pipelineHelper;
            this.targetSize = AbstractTask.suggestTargetSize(spliterator.estimateSize());
            this.offset = 0L;
            this.length = i;
        }

        SizedCollectorTask(SizedCollectorTask sizedCollectorTask, Spliterator spliterator, long j, long j2, int i) {
            super(sizedCollectorTask);
            this.spliterator = spliterator;
            this.helper = sizedCollectorTask.helper;
            this.targetSize = sizedCollectorTask.targetSize;
            this.offset = j;
            this.length = j2;
            if (j < 0 || j2 < 0 || (j + j2) - 1 >= i) {
                throw new IllegalArgumentException(String.format("offset and length interval [%d, %d + %d) is not within array size interval [0, %d)", Long.valueOf(j), Long.valueOf(j), Long.valueOf(j2), Integer.valueOf(i)));
            }
        }

        @Override
        public void compute() {
            Spliterator spliteratorTrySplit;
            Spliterator spliterator = this.spliterator;
            SizedCollectorTask sizedCollectorTaskMakeChild = this;
            while (spliterator.estimateSize() > sizedCollectorTaskMakeChild.targetSize && (spliteratorTrySplit = spliterator.trySplit()) != null) {
                sizedCollectorTaskMakeChild.setPendingCount(1);
                long jEstimateSize = spliteratorTrySplit.estimateSize();
                sizedCollectorTaskMakeChild.makeChild(spliteratorTrySplit, sizedCollectorTaskMakeChild.offset, jEstimateSize).fork();
                sizedCollectorTaskMakeChild = sizedCollectorTaskMakeChild.makeChild(spliterator, sizedCollectorTaskMakeChild.offset + jEstimateSize, sizedCollectorTaskMakeChild.length - jEstimateSize);
            }
            sizedCollectorTaskMakeChild.helper.wrapAndCopyInto(sizedCollectorTaskMakeChild, spliterator);
            sizedCollectorTaskMakeChild.propagateCompletion();
        }

        @Override
        public void begin(long j) {
            long j2 = this.length;
            if (j > j2) {
                throw new IllegalStateException("size passed to Sink.begin exceeds array length");
            }
            int i = (int) this.offset;
            this.index = i;
            this.fence = i + ((int) j2);
        }

        static final class OfRef extends SizedCollectorTask implements Sink {
            private final Object[] array;

            OfRef(Spliterator spliterator, PipelineHelper pipelineHelper, Object[] objArr) {
                super(spliterator, pipelineHelper, objArr.length);
                this.array = objArr;
            }

            OfRef(OfRef ofRef, Spliterator spliterator, long j, long j2) {
                super(ofRef, spliterator, j, j2, ofRef.array.length);
                this.array = ofRef.array;
            }

            @Override
            public OfRef makeChild(Spliterator spliterator, long j, long j2) {
                return new OfRef(this, spliterator, j, j2);
            }

            @Override
            public void accept(Object obj) {
                int i = this.index;
                if (i >= this.fence) {
                    throw new IndexOutOfBoundsException(Integer.toString(this.index));
                }
                Object[] objArr = this.array;
                this.index = i + 1;
                objArr[i] = obj;
            }
        }

        static final class OfInt extends SizedCollectorTask implements Sink.OfInt {
            private final int[] array;

            @Override
            public void accept(Integer num) {
                Sink.OfInt.CC.$default$accept((Sink.OfInt) this, num);
            }

            @Override
            public void accept(Object obj) {
                Sink.OfInt.CC.$default$accept(this, obj);
            }

            public IntConsumer andThen(IntConsumer intConsumer) {
                return IntConsumer$CC.$default$andThen(this, intConsumer);
            }

            OfInt(Spliterator spliterator, PipelineHelper pipelineHelper, int[] iArr) {
                super(spliterator, pipelineHelper, iArr.length);
                this.array = iArr;
            }

            OfInt(OfInt ofInt, Spliterator spliterator, long j, long j2) {
                super(ofInt, spliterator, j, j2, ofInt.array.length);
                this.array = ofInt.array;
            }

            @Override
            public OfInt makeChild(Spliterator spliterator, long j, long j2) {
                return new OfInt(this, spliterator, j, j2);
            }

            @Override
            public void accept(int i) {
                int i2 = this.index;
                if (i2 >= this.fence) {
                    throw new IndexOutOfBoundsException(Integer.toString(this.index));
                }
                int[] iArr = this.array;
                this.index = i2 + 1;
                iArr[i2] = i;
            }
        }

        static final class OfLong extends SizedCollectorTask implements Sink.OfLong {
            private final long[] array;

            @Override
            public void accept(Long l) {
                Sink.OfLong.CC.$default$accept((Sink.OfLong) this, l);
            }

            @Override
            public void accept(Object obj) {
                Sink.OfLong.CC.$default$accept(this, obj);
            }

            public LongConsumer andThen(LongConsumer longConsumer) {
                return LongConsumer$CC.$default$andThen(this, longConsumer);
            }

            OfLong(Spliterator spliterator, PipelineHelper pipelineHelper, long[] jArr) {
                super(spliterator, pipelineHelper, jArr.length);
                this.array = jArr;
            }

            OfLong(OfLong ofLong, Spliterator spliterator, long j, long j2) {
                super(ofLong, spliterator, j, j2, ofLong.array.length);
                this.array = ofLong.array;
            }

            @Override
            public OfLong makeChild(Spliterator spliterator, long j, long j2) {
                return new OfLong(this, spliterator, j, j2);
            }

            @Override
            public void accept(long j) {
                int i = this.index;
                if (i >= this.fence) {
                    throw new IndexOutOfBoundsException(Integer.toString(this.index));
                }
                long[] jArr = this.array;
                this.index = i + 1;
                jArr[i] = j;
            }
        }

        static final class OfDouble extends SizedCollectorTask implements Sink.OfDouble {
            private final double[] array;

            @Override
            public void accept(Double d) {
                Sink.OfDouble.CC.$default$accept((Sink.OfDouble) this, d);
            }

            @Override
            public void accept(Object obj) {
                Sink.OfDouble.CC.$default$accept(this, obj);
            }

            public DoubleConsumer andThen(DoubleConsumer doubleConsumer) {
                return DoubleConsumer$CC.$default$andThen(this, doubleConsumer);
            }

            OfDouble(Spliterator spliterator, PipelineHelper pipelineHelper, double[] dArr) {
                super(spliterator, pipelineHelper, dArr.length);
                this.array = dArr;
            }

            OfDouble(OfDouble ofDouble, Spliterator spliterator, long j, long j2) {
                super(ofDouble, spliterator, j, j2, ofDouble.array.length);
                this.array = ofDouble.array;
            }

            @Override
            public OfDouble makeChild(Spliterator spliterator, long j, long j2) {
                return new OfDouble(this, spliterator, j, j2);
            }

            @Override
            public void accept(double d) {
                int i = this.index;
                if (i >= this.fence) {
                    throw new IndexOutOfBoundsException(Integer.toString(this.index));
                }
                double[] dArr = this.array;
                this.index = i + 1;
                dArr[i] = d;
            }
        }
    }

    private static abstract class ToArrayTask extends CountedCompleter {
        protected final Node node;
        protected final int offset;

        abstract void copyNodeToArray();

        abstract ToArrayTask makeChild(int i, int i2);

        ToArrayTask(Node node, int i) {
            this.node = node;
            this.offset = i;
        }

        ToArrayTask(ToArrayTask toArrayTask, Node node, int i) {
            super(toArrayTask);
            this.node = node;
            this.offset = i;
        }

        @Override
        public void compute() {
            ToArrayTask toArrayTaskMakeChild = this;
            while (toArrayTaskMakeChild.node.getChildCount() != 0) {
                toArrayTaskMakeChild.setPendingCount(toArrayTaskMakeChild.node.getChildCount() - 1);
                int i = 0;
                int iCount = 0;
                while (i < toArrayTaskMakeChild.node.getChildCount() - 1) {
                    ToArrayTask toArrayTaskMakeChild2 = toArrayTaskMakeChild.makeChild(i, toArrayTaskMakeChild.offset + iCount);
                    iCount = (int) (((long) iCount) + toArrayTaskMakeChild2.node.count());
                    toArrayTaskMakeChild2.fork();
                    i++;
                }
                toArrayTaskMakeChild = toArrayTaskMakeChild.makeChild(i, toArrayTaskMakeChild.offset + iCount);
            }
            toArrayTaskMakeChild.copyNodeToArray();
            toArrayTaskMakeChild.propagateCompletion();
        }

        private static final class OfRef extends ToArrayTask {
            private final Object[] array;

            private OfRef(Node node, Object[] objArr, int i) {
                super(node, i);
                this.array = objArr;
            }

            private OfRef(OfRef ofRef, Node node, int i) {
                super(ofRef, node, i);
                this.array = ofRef.array;
            }

            @Override
            public OfRef makeChild(int i, int i2) {
                return new OfRef(this, this.node.getChild(i), i2);
            }

            @Override
            void copyNodeToArray() {
                this.node.copyInto(this.array, this.offset);
            }
        }

        private static class OfPrimitive extends ToArrayTask {
            private final Object array;

            private OfPrimitive(Node.OfPrimitive ofPrimitive, Object obj, int i) {
                super(ofPrimitive, i);
                this.array = obj;
            }

            private OfPrimitive(OfPrimitive ofPrimitive, Node.OfPrimitive ofPrimitive2, int i) {
                super(ofPrimitive, ofPrimitive2, i);
                this.array = ofPrimitive.array;
            }

            @Override
            public OfPrimitive makeChild(int i, int i2) {
                return new OfPrimitive(this, ((Node.OfPrimitive) this.node).getChild(i), i2);
            }

            @Override
            void copyNodeToArray() {
                ((Node.OfPrimitive) this.node).copyInto(this.array, this.offset);
            }
        }

        private static final class OfInt extends OfPrimitive {
            private OfInt(Node.OfInt ofInt, int[] iArr, int i) {
                super(ofInt, iArr, i);
            }
        }

        private static final class OfLong extends OfPrimitive {
            private OfLong(Node.OfLong ofLong, long[] jArr, int i) {
                super(ofLong, jArr, i);
            }
        }

        private static final class OfDouble extends OfPrimitive {
            private OfDouble(Node.OfDouble ofDouble, double[] dArr, int i) {
                super(ofDouble, dArr, i);
            }
        }
    }

    static class CollectorTask extends AbstractTask {
        protected final LongFunction builderFactory;
        protected final BinaryOperator concFactory;
        protected final PipelineHelper helper;

        CollectorTask(PipelineHelper pipelineHelper, Spliterator spliterator, LongFunction longFunction, BinaryOperator binaryOperator) {
            super(pipelineHelper, spliterator);
            this.helper = pipelineHelper;
            this.builderFactory = longFunction;
            this.concFactory = binaryOperator;
        }

        CollectorTask(CollectorTask collectorTask, Spliterator spliterator) {
            super(collectorTask, spliterator);
            this.helper = collectorTask.helper;
            this.builderFactory = collectorTask.builderFactory;
            this.concFactory = collectorTask.concFactory;
        }

        @Override
        public CollectorTask makeChild(Spliterator spliterator) {
            return new CollectorTask(this, spliterator);
        }

        @Override
        public Node doLeaf() {
            return ((Node.Builder) this.helper.wrapAndCopyInto((Node.Builder) this.builderFactory.apply(this.helper.exactOutputSizeIfKnown(this.spliterator)), this.spliterator)).build();
        }

        @Override
        public void onCompletion(CountedCompleter countedCompleter) {
            if (!isLeaf()) {
                setLocalResult((Node) this.concFactory.apply((Node) ((CollectorTask) this.leftChild).getLocalResult(), (Node) ((CollectorTask) this.rightChild).getLocalResult()));
            }
            super.onCompletion(countedCompleter);
        }

        static final class OfRef extends CollectorTask {
            @Override
            protected Object doLeaf() {
                return super.doLeaf();
            }

            @Override
            protected AbstractTask makeChild(Spliterator spliterator) {
                return super.makeChild(spliterator);
            }

            OfRef(PipelineHelper pipelineHelper, final IntFunction intFunction, Spliterator spliterator) {
                super(pipelineHelper, spliterator, new LongFunction() {
                    @Override
                    public final Object apply(long j) {
                        return Nodes.builder(j, intFunction);
                    }
                }, new BinaryOperator() {
                    public BiFunction andThen(Function function) {
                        return BiFunction$CC.$default$andThen(this, function);
                    }

                    @Override
                    public final Object apply(Object obj, Object obj2) {
                        return new Nodes.ConcNode((Node) obj, (Node) obj2);
                    }
                });
            }
        }

        private static final class OfInt extends CollectorTask {
            @Override
            protected Object doLeaf() {
                return super.doLeaf();
            }

            @Override
            protected AbstractTask makeChild(Spliterator spliterator) {
                return super.makeChild(spliterator);
            }

            OfInt(PipelineHelper pipelineHelper, Spliterator spliterator) {
                super(pipelineHelper, spliterator, new LongFunction() {
                    @Override
                    public final Object apply(long j) {
                        return Nodes.intBuilder(j);
                    }
                }, new BinaryOperator() {
                    public BiFunction andThen(Function function) {
                        return BiFunction$CC.$default$andThen(this, function);
                    }

                    @Override
                    public final Object apply(Object obj, Object obj2) {
                        return new Nodes.ConcNode.OfInt((Node.OfInt) obj, (Node.OfInt) obj2);
                    }
                });
            }
        }

        private static final class OfLong extends CollectorTask {
            @Override
            protected Object doLeaf() {
                return super.doLeaf();
            }

            @Override
            protected AbstractTask makeChild(Spliterator spliterator) {
                return super.makeChild(spliterator);
            }

            OfLong(PipelineHelper pipelineHelper, Spliterator spliterator) {
                super(pipelineHelper, spliterator, new LongFunction() {
                    @Override
                    public final Object apply(long j) {
                        return Nodes.longBuilder(j);
                    }
                }, new BinaryOperator() {
                    public BiFunction andThen(Function function) {
                        return BiFunction$CC.$default$andThen(this, function);
                    }

                    @Override
                    public final Object apply(Object obj, Object obj2) {
                        return new Nodes.ConcNode.OfLong((Node.OfLong) obj, (Node.OfLong) obj2);
                    }
                });
            }
        }

        private static final class OfDouble extends CollectorTask {
            @Override
            protected Object doLeaf() {
                return super.doLeaf();
            }

            @Override
            protected AbstractTask makeChild(Spliterator spliterator) {
                return super.makeChild(spliterator);
            }

            OfDouble(PipelineHelper pipelineHelper, Spliterator spliterator) {
                super(pipelineHelper, spliterator, new LongFunction() {
                    @Override
                    public final Object apply(long j) {
                        return Nodes.doubleBuilder(j);
                    }
                }, new BinaryOperator() {
                    public BiFunction andThen(Function function) {
                        return BiFunction$CC.$default$andThen(this, function);
                    }

                    @Override
                    public final Object apply(Object obj, Object obj2) {
                        return new Nodes.ConcNode.OfDouble((Node.OfDouble) obj, (Node.OfDouble) obj2);
                    }
                });
            }
        }
    }
}
