package p000j$.util.stream;

import java.util.Iterator;
import java.util.function.BiConsumer;
import java.util.function.IntBinaryOperator;
import java.util.function.IntConsumer;
import java.util.function.IntFunction;
import java.util.function.IntPredicate;
import java.util.function.IntToDoubleFunction;
import java.util.function.IntToLongFunction;
import java.util.function.IntUnaryOperator;
import java.util.function.ObjIntConsumer;
import java.util.function.Supplier;
import java.util.stream.BaseStream;
import java.util.stream.DoubleStream;
import java.util.stream.LongStream;
import java.util.stream.Stream;
import p000j$.util.IntSummaryStatistics;
import p000j$.util.IntSummaryStatisticsConversions;
import p000j$.util.OptionalConversions;
import p000j$.util.OptionalDouble;
import p000j$.util.OptionalInt;
import p000j$.util.PrimitiveIterator;
import p000j$.util.Spliterator;

public interface IntStream extends BaseStream<Integer, IntStream> {

    public final class VivifiedWrapper implements IntStream {
        public final java.util.stream.IntStream wrappedValue;

        private VivifiedWrapper(java.util.stream.IntStream intStream) {
            this.wrappedValue = intStream;
        }

        public static IntStream convert(java.util.stream.IntStream intStream) {
            if (intStream == null) {
                return null;
            }
            return intStream instanceof Wrapper ? IntStream.this : new VivifiedWrapper(intStream);
        }

        @Override
        public boolean allMatch(IntPredicate intPredicate) {
            return this.wrappedValue.allMatch(intPredicate);
        }

        @Override
        public boolean anyMatch(IntPredicate intPredicate) {
            return this.wrappedValue.anyMatch(intPredicate);
        }

        @Override
        public DoubleStream asDoubleStream() {
            return DoubleStream.VivifiedWrapper.convert(this.wrappedValue.asDoubleStream());
        }

        @Override
        public LongStream asLongStream() {
            return LongStream.VivifiedWrapper.convert(this.wrappedValue.asLongStream());
        }

        @Override
        public OptionalDouble average() {
            return OptionalConversions.convert(this.wrappedValue.average());
        }

        @Override
        public Stream boxed() {
            return Stream.VivifiedWrapper.convert(this.wrappedValue.boxed());
        }

        @Override
        public void close() {
            this.wrappedValue.close();
        }

        @Override
        public Object collect(Supplier supplier, ObjIntConsumer objIntConsumer, BiConsumer biConsumer) {
            return this.wrappedValue.collect(supplier, objIntConsumer, biConsumer);
        }

        @Override
        public long count() {
            return this.wrappedValue.count();
        }

        @Override
        public IntStream distinct() {
            return convert(this.wrappedValue.distinct());
        }

        @Override
        public IntStream dropWhile(IntPredicate intPredicate) {
            return convert(this.wrappedValue.dropWhile(intPredicate));
        }

        public boolean equals(Object obj) {
            java.util.stream.IntStream intStream = this.wrappedValue;
            if (obj instanceof VivifiedWrapper) {
                obj = ((VivifiedWrapper) obj).wrappedValue;
            }
            return intStream.equals(obj);
        }

        @Override
        public IntStream filter(IntPredicate intPredicate) {
            return convert(this.wrappedValue.filter(intPredicate));
        }

        @Override
        public OptionalInt findAny() {
            return OptionalConversions.convert(this.wrappedValue.findAny());
        }

        @Override
        public OptionalInt findFirst() {
            return OptionalConversions.convert(this.wrappedValue.findFirst());
        }

        @Override
        public IntStream flatMap(IntFunction intFunction) {
            return convert(this.wrappedValue.flatMap(FlatMapApiFlips.flipFunctionReturningStream(intFunction)));
        }

        @Override
        public void forEach(IntConsumer intConsumer) {
            this.wrappedValue.forEach(intConsumer);
        }

        @Override
        public void forEachOrdered(IntConsumer intConsumer) {
            this.wrappedValue.forEachOrdered(intConsumer);
        }

        public int hashCode() {
            return this.wrappedValue.hashCode();
        }

        @Override
        public boolean isParallel() {
            return this.wrappedValue.isParallel();
        }

        @Override
        public Iterator<Integer> iterator() {
            return PrimitiveIterator.OfInt.VivifiedWrapper.convert(this.wrappedValue.iterator());
        }

        @Override
        public Iterator<Integer> iterator2() {
            return this.wrappedValue.iterator();
        }

        @Override
        public IntStream limit(long j) {
            return convert(this.wrappedValue.limit(j));
        }

        @Override
        public IntStream map(IntUnaryOperator intUnaryOperator) {
            return convert(this.wrappedValue.map(intUnaryOperator));
        }

        @Override
        public DoubleStream mapToDouble(IntToDoubleFunction intToDoubleFunction) {
            return DoubleStream.VivifiedWrapper.convert(this.wrappedValue.mapToDouble(intToDoubleFunction));
        }

        @Override
        public LongStream mapToLong(IntToLongFunction intToLongFunction) {
            return LongStream.VivifiedWrapper.convert(this.wrappedValue.mapToLong(intToLongFunction));
        }

        @Override
        public Stream mapToObj(IntFunction intFunction) {
            return Stream.VivifiedWrapper.convert(this.wrappedValue.mapToObj(intFunction));
        }

        @Override
        public OptionalInt max() {
            return OptionalConversions.convert(this.wrappedValue.max());
        }

        @Override
        public OptionalInt min() {
            return OptionalConversions.convert(this.wrappedValue.min());
        }

        @Override
        public boolean noneMatch(IntPredicate intPredicate) {
            return this.wrappedValue.noneMatch(intPredicate);
        }

        @Override
        public BaseStream onClose(Runnable runnable) {
            return BaseStream.VivifiedWrapper.convert(this.wrappedValue.onClose(runnable));
        }

        @Override
        public BaseStream parallel() {
            return BaseStream.VivifiedWrapper.convert(this.wrappedValue.parallel());
        }

        @Override
        public IntStream parallel() {
            return convert(this.wrappedValue.parallel());
        }

        @Override
        public IntStream peek(IntConsumer intConsumer) {
            return convert(this.wrappedValue.peek(intConsumer));
        }

        @Override
        public int reduce(int i, IntBinaryOperator intBinaryOperator) {
            return this.wrappedValue.reduce(i, intBinaryOperator);
        }

        @Override
        public OptionalInt reduce(IntBinaryOperator intBinaryOperator) {
            return OptionalConversions.convert(this.wrappedValue.reduce(intBinaryOperator));
        }

        @Override
        public BaseStream sequential() {
            return BaseStream.VivifiedWrapper.convert(this.wrappedValue.sequential());
        }

        @Override
        public IntStream sequential() {
            return convert(this.wrappedValue.sequential());
        }

        @Override
        public IntStream skip(long j) {
            return convert(this.wrappedValue.skip(j));
        }

        @Override
        public IntStream sorted() {
            return convert(this.wrappedValue.sorted());
        }

        @Override
        public Spliterator.OfInt spliterator() {
            return Spliterator.OfInt.VivifiedWrapper.convert(this.wrappedValue.spliterator());
        }

        @Override
        public Spliterator spliterator() {
            return Spliterator.VivifiedWrapper.convert(this.wrappedValue.spliterator());
        }

        @Override
        public int sum() {
            return this.wrappedValue.sum();
        }

        @Override
        public IntSummaryStatistics summaryStatistics() {
            return IntSummaryStatisticsConversions.convert(this.wrappedValue.summaryStatistics());
        }

        @Override
        public IntStream takeWhile(IntPredicate intPredicate) {
            return convert(this.wrappedValue.takeWhile(intPredicate));
        }

        @Override
        public int[] toArray() {
            return this.wrappedValue.toArray();
        }

        @Override
        public BaseStream unordered() {
            return BaseStream.VivifiedWrapper.convert(this.wrappedValue.unordered());
        }
    }

    public final class Wrapper implements java.util.stream.IntStream {
        private Wrapper() {
        }

        public static java.util.stream.IntStream convert(IntStream intStream) {
            if (intStream == null) {
                return null;
            }
            return intStream instanceof VivifiedWrapper ? ((VivifiedWrapper) intStream).wrappedValue : intStream.new Wrapper();
        }

        @Override
        public boolean allMatch(IntPredicate intPredicate) {
            return IntStream.this.allMatch(intPredicate);
        }

        @Override
        public boolean anyMatch(IntPredicate intPredicate) {
            return IntStream.this.anyMatch(intPredicate);
        }

        @Override
        public DoubleStream asDoubleStream() {
            return DoubleStream.Wrapper.convert(IntStream.this.asDoubleStream());
        }

        @Override
        public LongStream asLongStream() {
            return LongStream.Wrapper.convert(IntStream.this.asLongStream());
        }

        @Override
        public java.util.OptionalDouble average() {
            return OptionalConversions.convert(IntStream.this.average());
        }

        @Override
        public Stream boxed() {
            return Stream.Wrapper.convert(IntStream.this.boxed());
        }

        @Override
        public void close() {
            IntStream.this.close();
        }

        @Override
        public Object collect(Supplier supplier, ObjIntConsumer objIntConsumer, BiConsumer biConsumer) {
            return IntStream.this.collect(supplier, objIntConsumer, biConsumer);
        }

        @Override
        public long count() {
            return IntStream.this.count();
        }

        @Override
        public java.util.stream.IntStream distinct() {
            return convert(IntStream.this.distinct());
        }

        public java.util.stream.IntStream dropWhile(IntPredicate intPredicate) {
            return convert(IntStream.this.dropWhile(intPredicate));
        }

        public boolean equals(Object obj) {
            IntStream intStream = IntStream.this;
            if (obj instanceof Wrapper) {
                obj = IntStream.this;
            }
            return intStream.equals(obj);
        }

        @Override
        public java.util.stream.IntStream filter(IntPredicate intPredicate) {
            return convert(IntStream.this.filter(intPredicate));
        }

        @Override
        public java.util.OptionalInt findAny() {
            return OptionalConversions.convert(IntStream.this.findAny());
        }

        @Override
        public java.util.OptionalInt findFirst() {
            return OptionalConversions.convert(IntStream.this.findFirst());
        }

        @Override
        public java.util.stream.IntStream flatMap(IntFunction intFunction) {
            return convert(IntStream.this.flatMap(FlatMapApiFlips.flipFunctionReturningStream(intFunction)));
        }

        @Override
        public void forEach(IntConsumer intConsumer) {
            IntStream.this.forEach(intConsumer);
        }

        @Override
        public void forEachOrdered(IntConsumer intConsumer) {
            IntStream.this.forEachOrdered(intConsumer);
        }

        public int hashCode() {
            return IntStream.this.hashCode();
        }

        @Override
        public boolean isParallel() {
            return IntStream.this.isParallel();
        }

        @Override
        public Iterator<Integer> iterator() {
            return IntStream.this.iterator();
        }

        @Override
        public Iterator<Integer> iterator2() {
            return PrimitiveIterator.OfInt.Wrapper.convert(IntStream.this.iterator());
        }

        @Override
        public java.util.stream.IntStream limit(long j) {
            return convert(IntStream.this.limit(j));
        }

        @Override
        public java.util.stream.IntStream map(IntUnaryOperator intUnaryOperator) {
            return convert(IntStream.this.map(intUnaryOperator));
        }

        @Override
        public DoubleStream mapToDouble(IntToDoubleFunction intToDoubleFunction) {
            return DoubleStream.Wrapper.convert(IntStream.this.mapToDouble(intToDoubleFunction));
        }

        @Override
        public LongStream mapToLong(IntToLongFunction intToLongFunction) {
            return LongStream.Wrapper.convert(IntStream.this.mapToLong(intToLongFunction));
        }

        @Override
        public Stream mapToObj(IntFunction intFunction) {
            return Stream.Wrapper.convert(IntStream.this.mapToObj(intFunction));
        }

        @Override
        public java.util.OptionalInt max() {
            return OptionalConversions.convert(IntStream.this.max());
        }

        @Override
        public java.util.OptionalInt min() {
            return OptionalConversions.convert(IntStream.this.min());
        }

        @Override
        public boolean noneMatch(IntPredicate intPredicate) {
            return IntStream.this.noneMatch(intPredicate);
        }

        @Override
        public BaseStream onClose(Runnable runnable) {
            return BaseStream.Wrapper.convert(IntStream.this.onClose(runnable));
        }

        @Override
        public BaseStream parallel() {
            return BaseStream.Wrapper.convert(IntStream.this.parallel());
        }

        @Override
        public java.util.stream.IntStream parallel() {
            return convert(IntStream.this.parallel());
        }

        @Override
        public java.util.stream.IntStream peek(IntConsumer intConsumer) {
            return convert(IntStream.this.peek(intConsumer));
        }

        @Override
        public int reduce(int i, IntBinaryOperator intBinaryOperator) {
            return IntStream.this.reduce(i, intBinaryOperator);
        }

        @Override
        public java.util.OptionalInt reduce(IntBinaryOperator intBinaryOperator) {
            return OptionalConversions.convert(IntStream.this.reduce(intBinaryOperator));
        }

        @Override
        public BaseStream sequential() {
            return BaseStream.Wrapper.convert(IntStream.this.sequential());
        }

        @Override
        public java.util.stream.IntStream sequential() {
            return convert(IntStream.this.sequential());
        }

        @Override
        public java.util.stream.IntStream skip(long j) {
            return convert(IntStream.this.skip(j));
        }

        @Override
        public java.util.stream.IntStream sorted() {
            return convert(IntStream.this.sorted());
        }

        @Override
        public java.util.Spliterator<Integer> spliterator() {
            return Spliterator.OfInt.Wrapper.convert(IntStream.this.spliterator());
        }

        @Override
        public java.util.Spliterator<Integer> spliterator2() {
            return Spliterator.Wrapper.convert(IntStream.this.spliterator());
        }

        @Override
        public int sum() {
            return IntStream.this.sum();
        }

        @Override
        public java.util.IntSummaryStatistics summaryStatistics() {
            return IntSummaryStatisticsConversions.convert(IntStream.this.summaryStatistics());
        }

        public java.util.stream.IntStream takeWhile(IntPredicate intPredicate) {
            return convert(IntStream.this.takeWhile(intPredicate));
        }

        @Override
        public int[] toArray() {
            return IntStream.this.toArray();
        }

        @Override
        public BaseStream unordered() {
            return BaseStream.Wrapper.convert(IntStream.this.unordered());
        }
    }

    boolean allMatch(IntPredicate intPredicate);

    boolean anyMatch(IntPredicate intPredicate);

    DoubleStream asDoubleStream();

    LongStream asLongStream();

    OptionalDouble average();

    Stream boxed();

    Object collect(Supplier supplier, ObjIntConsumer objIntConsumer, BiConsumer biConsumer);

    long count();

    IntStream distinct();

    IntStream dropWhile(IntPredicate intPredicate);

    IntStream filter(IntPredicate intPredicate);

    OptionalInt findAny();

    OptionalInt findFirst();

    IntStream flatMap(IntFunction intFunction);

    void forEach(IntConsumer intConsumer);

    void forEachOrdered(IntConsumer intConsumer);

    @Override
    Iterator<Integer> iterator();

    IntStream limit(long j);

    IntStream map(IntUnaryOperator intUnaryOperator);

    DoubleStream mapToDouble(IntToDoubleFunction intToDoubleFunction);

    LongStream mapToLong(IntToLongFunction intToLongFunction);

    Stream mapToObj(IntFunction intFunction);

    OptionalInt max();

    OptionalInt min();

    boolean noneMatch(IntPredicate intPredicate);

    @Override
    IntStream parallel();

    IntStream peek(IntConsumer intConsumer);

    int reduce(int i, IntBinaryOperator intBinaryOperator);

    OptionalInt reduce(IntBinaryOperator intBinaryOperator);

    @Override
    IntStream sequential();

    IntStream skip(long j);

    IntStream sorted();

    @Override
    Spliterator.OfInt spliterator();

    int sum();

    IntSummaryStatistics summaryStatistics();

    IntStream takeWhile(IntPredicate intPredicate);

    int[] toArray();
}
