package p000j$.util.stream;

import java.util.function.Consumer;
import java.util.function.DoubleConsumer;
import java.util.function.IntConsumer;
import java.util.function.IntFunction;
import java.util.function.LongConsumer;
import p000j$.util.Spliterator;
import p000j$.util.function.Consumer$CC;
import p000j$.util.function.DoubleConsumer$CC;
import p000j$.util.function.IntConsumer$CC;
import p000j$.util.function.LongConsumer$CC;

interface Node {

    public interface Builder extends Sink {

        public interface OfDouble extends Builder, Sink.OfDouble {
            @Override
            OfDouble build();
        }

        public interface OfInt extends Builder, Sink.OfInt {
            @Override
            OfInt build();
        }

        public interface OfLong extends Builder, Sink.OfLong {
            @Override
            OfLong build();
        }

        Node build();
    }

    Object[] asArray(IntFunction intFunction);

    void copyInto(Object[] objArr, int i);

    long count();

    void forEach(Consumer consumer);

    Node getChild(int i);

    int getChildCount();

    Spliterator spliterator();

    Node truncate(long j, long j2, IntFunction intFunction);

    public abstract class CC {
        public static int $default$getChildCount(Node node) {
            return 0;
        }

        public static void lambda$truncate$0(Object obj) {
        }

        public static Node $default$getChild(Node node, int i) {
            throw new IndexOutOfBoundsException();
        }

        public static Node $default$truncate(Node node, long j, long j2, IntFunction intFunction) {
            if (j == 0 && j2 == node.count()) {
                return node;
            }
            Spliterator spliterator = node.spliterator();
            long j3 = j2 - j;
            Builder builder = Nodes.builder(j3, intFunction);
            builder.begin(j3);
            for (int i = 0; i < j && spliterator.tryAdvance(new Consumer() {
                @Override
                public final void accept(Object obj) {
                    Node.CC.lambda$truncate$0(obj);
                }

                public Consumer andThen(Consumer consumer) {
                    return Consumer$CC.$default$andThen(this, consumer);
                }
            }); i++) {
            }
            if (j2 == node.count()) {
                spliterator.forEachRemaining(builder);
            } else {
                for (int i2 = 0; i2 < j3 && spliterator.tryAdvance(builder); i2++) {
                }
            }
            builder.end();
            return builder.build();
        }
    }

    public interface OfPrimitive extends Node {
        Object asPrimitiveArray();

        void copyInto(Object obj, int i);

        void forEach(Object obj);

        @Override
        OfPrimitive getChild(int i);

        Object newArray(int i);

        @Override
        Spliterator.OfPrimitive spliterator();

        public abstract class CC {
            public static OfPrimitive $default$getChild(OfPrimitive ofPrimitive, int i) {
                throw new IndexOutOfBoundsException();
            }

            public static Object[] $default$asArray(OfPrimitive ofPrimitive, IntFunction intFunction) {
                if (Tripwire.ENABLED) {
                    Tripwire.trip(ofPrimitive.getClass(), "{0} calling Node.OfPrimitive.asArray");
                }
                if (ofPrimitive.count() >= 2147483639) {
                    throw new IllegalArgumentException("Stream size exceeds max array size");
                }
                Object[] objArr = (Object[]) intFunction.apply((int) ofPrimitive.count());
                ofPrimitive.copyInto(objArr, 0);
                return objArr;
            }
        }
    }

    public interface OfInt extends OfPrimitive {
        void copyInto(Integer[] numArr, int i);

        @Override
        int[] newArray(int i);

        @Override
        OfInt truncate(long j, long j2, IntFunction intFunction);

        public abstract class CC {
            public static void lambda$truncate$0(int i) {
            }

            public static void $default$forEach(OfInt ofInt, Consumer consumer) {
                if (consumer instanceof IntConsumer) {
                    ofInt.forEach((IntConsumer) consumer);
                    return;
                }
                if (Tripwire.ENABLED) {
                    Tripwire.trip(ofInt.getClass(), "{0} calling Node.OfInt.forEachRemaining(Consumer)");
                }
                ((Spliterator.OfInt) ofInt.spliterator()).forEachRemaining(consumer);
            }

            public static void $default$copyInto(OfInt ofInt, Integer[] numArr, int i) {
                if (Tripwire.ENABLED) {
                    Tripwire.trip(ofInt.getClass(), "{0} calling Node.OfInt.copyInto(Integer[], int)");
                }
                int[] iArr = (int[]) ofInt.asPrimitiveArray();
                for (int i2 = 0; i2 < iArr.length; i2++) {
                    numArr[i + i2] = Integer.valueOf(iArr[i2]);
                }
            }

            public static OfInt $default$truncate(OfInt ofInt, long j, long j2, IntFunction intFunction) {
                if (j == 0 && j2 == ofInt.count()) {
                    return ofInt;
                }
                long j3 = j2 - j;
                Spliterator.OfInt ofInt2 = (Spliterator.OfInt) ofInt.spliterator();
                Builder.OfInt ofIntIntBuilder = Nodes.intBuilder(j3);
                ofIntIntBuilder.begin(j3);
                for (int i = 0; i < j && ofInt2.tryAdvance(new IntConsumer() {
                    @Override
                    public final void accept(int i2) {
                        Node.OfInt.CC.lambda$truncate$0(i2);
                    }

                    public IntConsumer andThen(IntConsumer intConsumer) {
                        return IntConsumer$CC.$default$andThen(this, intConsumer);
                    }
                }); i++) {
                }
                if (j2 == ofInt.count()) {
                    ofInt2.forEachRemaining((IntConsumer) ofIntIntBuilder);
                } else {
                    for (int i2 = 0; i2 < j3 && ofInt2.tryAdvance((IntConsumer) ofIntIntBuilder); i2++) {
                    }
                }
                ofIntIntBuilder.end();
                return ofIntIntBuilder.build();
            }

            public static int[] m14254$default$newArray(OfInt ofInt, int i) {
                return new int[i];
            }
        }
    }

    public interface OfLong extends OfPrimitive {
        void copyInto(Long[] lArr, int i);

        @Override
        long[] newArray(int i);

        @Override
        OfLong truncate(long j, long j2, IntFunction intFunction);

        public abstract class CC {
            public static void lambda$truncate$0(long j) {
            }

            public static void $default$forEach(OfLong ofLong, Consumer consumer) {
                if (consumer instanceof LongConsumer) {
                    ofLong.forEach((LongConsumer) consumer);
                    return;
                }
                if (Tripwire.ENABLED) {
                    Tripwire.trip(ofLong.getClass(), "{0} calling Node.OfLong.forEachRemaining(Consumer)");
                }
                ((Spliterator.OfLong) ofLong.spliterator()).forEachRemaining(consumer);
            }

            public static void $default$copyInto(OfLong ofLong, Long[] lArr, int i) {
                if (Tripwire.ENABLED) {
                    Tripwire.trip(ofLong.getClass(), "{0} calling Node.OfInt.copyInto(Long[], int)");
                }
                long[] jArr = (long[]) ofLong.asPrimitiveArray();
                for (int i2 = 0; i2 < jArr.length; i2++) {
                    lArr[i + i2] = Long.valueOf(jArr[i2]);
                }
            }

            public static OfLong $default$truncate(OfLong ofLong, long j, long j2, IntFunction intFunction) {
                if (j == 0 && j2 == ofLong.count()) {
                    return ofLong;
                }
                long j3 = j2 - j;
                Spliterator.OfLong ofLong2 = (Spliterator.OfLong) ofLong.spliterator();
                Builder.OfLong ofLongLongBuilder = Nodes.longBuilder(j3);
                ofLongLongBuilder.begin(j3);
                for (int i = 0; i < j && ofLong2.tryAdvance(new LongConsumer() {
                    @Override
                    public final void accept(long j4) {
                        Node.OfLong.CC.lambda$truncate$0(j4);
                    }

                    public LongConsumer andThen(LongConsumer longConsumer) {
                        return LongConsumer$CC.$default$andThen(this, longConsumer);
                    }
                }); i++) {
                }
                if (j2 == ofLong.count()) {
                    ofLong2.forEachRemaining((LongConsumer) ofLongLongBuilder);
                } else {
                    for (int i2 = 0; i2 < j3 && ofLong2.tryAdvance((LongConsumer) ofLongLongBuilder); i2++) {
                    }
                }
                ofLongLongBuilder.end();
                return ofLongLongBuilder.build();
            }

            public static long[] m14256$default$newArray(OfLong ofLong, int i) {
                return new long[i];
            }
        }
    }

    public interface OfDouble extends OfPrimitive {
        void copyInto(Double[] dArr, int i);

        @Override
        double[] newArray(int i);

        @Override
        OfDouble truncate(long j, long j2, IntFunction intFunction);

        public abstract class CC {
            public static void lambda$truncate$0(double d) {
            }

            public static void $default$forEach(OfDouble ofDouble, Consumer consumer) {
                if (consumer instanceof DoubleConsumer) {
                    ofDouble.forEach((DoubleConsumer) consumer);
                    return;
                }
                if (Tripwire.ENABLED) {
                    Tripwire.trip(ofDouble.getClass(), "{0} calling Node.OfLong.forEachRemaining(Consumer)");
                }
                ((Spliterator.OfDouble) ofDouble.spliterator()).forEachRemaining(consumer);
            }

            public static void $default$copyInto(OfDouble ofDouble, Double[] dArr, int i) {
                if (Tripwire.ENABLED) {
                    Tripwire.trip(ofDouble.getClass(), "{0} calling Node.OfDouble.copyInto(Double[], int)");
                }
                double[] dArr2 = (double[]) ofDouble.asPrimitiveArray();
                for (int i2 = 0; i2 < dArr2.length; i2++) {
                    dArr[i + i2] = Double.valueOf(dArr2[i2]);
                }
            }

            public static OfDouble $default$truncate(OfDouble ofDouble, long j, long j2, IntFunction intFunction) {
                if (j == 0 && j2 == ofDouble.count()) {
                    return ofDouble;
                }
                long j3 = j2 - j;
                Spliterator.OfDouble ofDouble2 = (Spliterator.OfDouble) ofDouble.spliterator();
                Builder.OfDouble ofDoubleDoubleBuilder = Nodes.doubleBuilder(j3);
                ofDoubleDoubleBuilder.begin(j3);
                for (int i = 0; i < j && ofDouble2.tryAdvance(new DoubleConsumer() {
                    @Override
                    public final void accept(double d) {
                        Node.OfDouble.CC.lambda$truncate$0(d);
                    }

                    public DoubleConsumer andThen(DoubleConsumer doubleConsumer) {
                        return DoubleConsumer$CC.$default$andThen(this, doubleConsumer);
                    }
                }); i++) {
                }
                if (j2 == ofDouble.count()) {
                    ofDouble2.forEachRemaining((DoubleConsumer) ofDoubleDoubleBuilder);
                } else {
                    for (int i2 = 0; i2 < j3 && ofDouble2.tryAdvance((DoubleConsumer) ofDoubleDoubleBuilder); i2++) {
                    }
                }
                ofDoubleDoubleBuilder.end();
                return ofDoubleDoubleBuilder.build();
            }

            public static double[] m14252$default$newArray(OfDouble ofDouble, int i) {
                return new double[i];
            }
        }
    }
}
