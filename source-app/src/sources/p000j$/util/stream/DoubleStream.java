package p000j$.util.stream;

import java.util.Iterator;
import java.util.function.BiConsumer;
import java.util.function.DoubleBinaryOperator;
import java.util.function.DoubleConsumer;
import java.util.function.DoubleFunction;
import java.util.function.DoublePredicate;
import java.util.function.DoubleToIntFunction;
import java.util.function.DoubleToLongFunction;
import java.util.function.DoubleUnaryOperator;
import java.util.function.ObjDoubleConsumer;
import java.util.function.Supplier;
import java.util.stream.BaseStream;
import java.util.stream.IntStream;
import java.util.stream.LongStream;
import java.util.stream.Stream;
import p000j$.util.DoubleSummaryStatistics;
import p000j$.util.DoubleSummaryStatisticsConversions;
import p000j$.util.OptionalConversions;
import p000j$.util.OptionalDouble;
import p000j$.util.PrimitiveIterator;
import p000j$.util.Spliterator;

public interface DoubleStream extends BaseStream<Double, DoubleStream> {

    public final class VivifiedWrapper implements DoubleStream {
        public final java.util.stream.DoubleStream wrappedValue;

        private VivifiedWrapper(java.util.stream.DoubleStream doubleStream) {
            this.wrappedValue = doubleStream;
        }

        public static DoubleStream convert(java.util.stream.DoubleStream doubleStream) {
            if (doubleStream == null) {
                return null;
            }
            return doubleStream instanceof Wrapper ? DoubleStream.this : new VivifiedWrapper(doubleStream);
        }

        @Override
        public boolean allMatch(DoublePredicate doublePredicate) {
            return this.wrappedValue.allMatch(doublePredicate);
        }

        @Override
        public boolean anyMatch(DoublePredicate doublePredicate) {
            return this.wrappedValue.anyMatch(doublePredicate);
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
        public Object collect(Supplier supplier, ObjDoubleConsumer objDoubleConsumer, BiConsumer biConsumer) {
            return this.wrappedValue.collect(supplier, objDoubleConsumer, biConsumer);
        }

        @Override
        public long count() {
            return this.wrappedValue.count();
        }

        @Override
        public DoubleStream distinct() {
            return convert(this.wrappedValue.distinct());
        }

        @Override
        public DoubleStream dropWhile(DoublePredicate doublePredicate) {
            return convert(this.wrappedValue.dropWhile(doublePredicate));
        }

        public boolean equals(Object obj) {
            java.util.stream.DoubleStream doubleStream = this.wrappedValue;
            if (obj instanceof VivifiedWrapper) {
                obj = ((VivifiedWrapper) obj).wrappedValue;
            }
            return doubleStream.equals(obj);
        }

        @Override
        public DoubleStream filter(DoublePredicate doublePredicate) {
            return convert(this.wrappedValue.filter(doublePredicate));
        }

        @Override
        public OptionalDouble findAny() {
            return OptionalConversions.convert(this.wrappedValue.findAny());
        }

        @Override
        public OptionalDouble findFirst() {
            return OptionalConversions.convert(this.wrappedValue.findFirst());
        }

        @Override
        public DoubleStream flatMap(DoubleFunction doubleFunction) {
            return convert(this.wrappedValue.flatMap(FlatMapApiFlips.flipFunctionReturningStream(doubleFunction)));
        }

        @Override
        public void forEach(DoubleConsumer doubleConsumer) {
            this.wrappedValue.forEach(doubleConsumer);
        }

        @Override
        public void forEachOrdered(DoubleConsumer doubleConsumer) {
            this.wrappedValue.forEachOrdered(doubleConsumer);
        }

        public int hashCode() {
            return this.wrappedValue.hashCode();
        }

        @Override
        public boolean isParallel() {
            return this.wrappedValue.isParallel();
        }

        @Override
        public Iterator<Double> iterator() {
            return PrimitiveIterator.OfDouble.VivifiedWrapper.convert(this.wrappedValue.iterator());
        }

        @Override
        public Iterator<Double> iterator2() {
            return this.wrappedValue.iterator();
        }

        @Override
        public DoubleStream limit(long j) {
            return convert(this.wrappedValue.limit(j));
        }

        @Override
        public DoubleStream map(DoubleUnaryOperator doubleUnaryOperator) {
            return convert(this.wrappedValue.map(doubleUnaryOperator));
        }

        @Override
        public IntStream mapToInt(DoubleToIntFunction doubleToIntFunction) {
            return IntStream.VivifiedWrapper.convert(this.wrappedValue.mapToInt(doubleToIntFunction));
        }

        @Override
        public LongStream mapToLong(DoubleToLongFunction doubleToLongFunction) {
            return LongStream.VivifiedWrapper.convert(this.wrappedValue.mapToLong(doubleToLongFunction));
        }

        @Override
        public Stream mapToObj(DoubleFunction doubleFunction) {
            return Stream.VivifiedWrapper.convert(this.wrappedValue.mapToObj(doubleFunction));
        }

        @Override
        public OptionalDouble max() {
            return OptionalConversions.convert(this.wrappedValue.max());
        }

        @Override
        public OptionalDouble min() {
            return OptionalConversions.convert(this.wrappedValue.min());
        }

        @Override
        public boolean noneMatch(DoublePredicate doublePredicate) {
            return this.wrappedValue.noneMatch(doublePredicate);
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
        public DoubleStream parallel() {
            return convert(this.wrappedValue.parallel());
        }

        @Override
        public DoubleStream peek(DoubleConsumer doubleConsumer) {
            return convert(this.wrappedValue.peek(doubleConsumer));
        }

        @Override
        public double reduce(double d, DoubleBinaryOperator doubleBinaryOperator) {
            return this.wrappedValue.reduce(d, doubleBinaryOperator);
        }

        @Override
        public OptionalDouble reduce(DoubleBinaryOperator doubleBinaryOperator) {
            return OptionalConversions.convert(this.wrappedValue.reduce(doubleBinaryOperator));
        }

        @Override
        public BaseStream sequential() {
            return BaseStream.VivifiedWrapper.convert(this.wrappedValue.sequential());
        }

        @Override
        public DoubleStream sequential() {
            return convert(this.wrappedValue.sequential());
        }

        @Override
        public DoubleStream skip(long j) {
            return convert(this.wrappedValue.skip(j));
        }

        @Override
        public DoubleStream sorted() {
            return convert(this.wrappedValue.sorted());
        }

        @Override
        public Spliterator.OfDouble spliterator() {
            return Spliterator.OfDouble.VivifiedWrapper.convert(this.wrappedValue.spliterator());
        }

        @Override
        public Spliterator spliterator() {
            return Spliterator.VivifiedWrapper.convert(this.wrappedValue.spliterator());
        }

        @Override
        public double sum() {
            return this.wrappedValue.sum();
        }

        @Override
        public DoubleSummaryStatistics summaryStatistics() {
            return DoubleSummaryStatisticsConversions.convert(this.wrappedValue.summaryStatistics());
        }

        @Override
        public DoubleStream takeWhile(DoublePredicate doublePredicate) {
            return convert(this.wrappedValue.takeWhile(doublePredicate));
        }

        @Override
        public double[] toArray() {
            return this.wrappedValue.toArray();
        }

        @Override
        public BaseStream unordered() {
            return BaseStream.VivifiedWrapper.convert(this.wrappedValue.unordered());
        }
    }

    public final class Wrapper implements java.util.stream.DoubleStream {
        private Wrapper() {
        }

        public static java.util.stream.DoubleStream convert(DoubleStream doubleStream) {
            if (doubleStream == null) {
                return null;
            }
            return doubleStream instanceof VivifiedWrapper ? ((VivifiedWrapper) doubleStream).wrappedValue : doubleStream.new Wrapper();
        }

        @Override
        public boolean allMatch(DoublePredicate doublePredicate) {
            return DoubleStream.this.allMatch(doublePredicate);
        }

        @Override
        public boolean anyMatch(DoublePredicate doublePredicate) {
            return DoubleStream.this.anyMatch(doublePredicate);
        }

        @Override
        public java.util.OptionalDouble average() {
            return OptionalConversions.convert(DoubleStream.this.average());
        }

        @Override
        public Stream boxed() {
            return Stream.Wrapper.convert(DoubleStream.this.boxed());
        }

        @Override
        public void close() {
            DoubleStream.this.close();
        }

        @Override
        public Object collect(Supplier supplier, ObjDoubleConsumer objDoubleConsumer, BiConsumer biConsumer) {
            return DoubleStream.this.collect(supplier, objDoubleConsumer, biConsumer);
        }

        @Override
        public long count() {
            return DoubleStream.this.count();
        }

        @Override
        public java.util.stream.DoubleStream distinct() {
            return convert(DoubleStream.this.distinct());
        }

        public java.util.stream.DoubleStream dropWhile(DoublePredicate doublePredicate) {
            return convert(DoubleStream.this.dropWhile(doublePredicate));
        }

        public boolean equals(Object obj) {
            DoubleStream doubleStream = DoubleStream.this;
            if (obj instanceof Wrapper) {
                obj = DoubleStream.this;
            }
            return doubleStream.equals(obj);
        }

        @Override
        public java.util.stream.DoubleStream filter(DoublePredicate doublePredicate) {
            return convert(DoubleStream.this.filter(doublePredicate));
        }

        @Override
        public java.util.OptionalDouble findAny() {
            return OptionalConversions.convert(DoubleStream.this.findAny());
        }

        @Override
        public java.util.OptionalDouble findFirst() {
            return OptionalConversions.convert(DoubleStream.this.findFirst());
        }

        @Override
        public java.util.stream.DoubleStream flatMap(DoubleFunction doubleFunction) {
            return convert(DoubleStream.this.flatMap(FlatMapApiFlips.flipFunctionReturningStream(doubleFunction)));
        }

        @Override
        public void forEach(DoubleConsumer doubleConsumer) {
            DoubleStream.this.forEach(doubleConsumer);
        }

        @Override
        public void forEachOrdered(DoubleConsumer doubleConsumer) {
            DoubleStream.this.forEachOrdered(doubleConsumer);
        }

        public int hashCode() {
            return DoubleStream.this.hashCode();
        }

        @Override
        public boolean isParallel() {
            return DoubleStream.this.isParallel();
        }

        @Override
        public Iterator<Double> iterator() {
            return DoubleStream.this.iterator();
        }

        @Override
        public Iterator<Double> iterator2() {
            return PrimitiveIterator.OfDouble.Wrapper.convert(DoubleStream.this.iterator());
        }

        @Override
        public java.util.stream.DoubleStream limit(long j) {
            return convert(DoubleStream.this.limit(j));
        }

        @Override
        public java.util.stream.DoubleStream map(DoubleUnaryOperator doubleUnaryOperator) {
            return convert(DoubleStream.this.map(doubleUnaryOperator));
        }

        @Override
        public IntStream mapToInt(DoubleToIntFunction doubleToIntFunction) {
            return IntStream.Wrapper.convert(DoubleStream.this.mapToInt(doubleToIntFunction));
        }

        @Override
        public LongStream mapToLong(DoubleToLongFunction doubleToLongFunction) {
            return LongStream.Wrapper.convert(DoubleStream.this.mapToLong(doubleToLongFunction));
        }

        @Override
        public Stream mapToObj(DoubleFunction doubleFunction) {
            return Stream.Wrapper.convert(DoubleStream.this.mapToObj(doubleFunction));
        }

        @Override
        public java.util.OptionalDouble max() {
            return OptionalConversions.convert(DoubleStream.this.max());
        }

        @Override
        public java.util.OptionalDouble min() {
            return OptionalConversions.convert(DoubleStream.this.min());
        }

        @Override
        public boolean noneMatch(DoublePredicate doublePredicate) {
            return DoubleStream.this.noneMatch(doublePredicate);
        }

        @Override
        public BaseStream onClose(Runnable runnable) {
            return BaseStream.Wrapper.convert(DoubleStream.this.onClose(runnable));
        }

        @Override
        public BaseStream parallel() {
            return BaseStream.Wrapper.convert(DoubleStream.this.parallel());
        }

        @Override
        public java.util.stream.DoubleStream parallel() {
            return convert(DoubleStream.this.parallel());
        }

        @Override
        public java.util.stream.DoubleStream peek(DoubleConsumer doubleConsumer) {
            return convert(DoubleStream.this.peek(doubleConsumer));
        }

        @Override
        public double reduce(double d, DoubleBinaryOperator doubleBinaryOperator) {
            return DoubleStream.this.reduce(d, doubleBinaryOperator);
        }

        @Override
        public java.util.OptionalDouble reduce(DoubleBinaryOperator doubleBinaryOperator) {
            return OptionalConversions.convert(DoubleStream.this.reduce(doubleBinaryOperator));
        }

        @Override
        public BaseStream sequential() {
            return BaseStream.Wrapper.convert(DoubleStream.this.sequential());
        }

        @Override
        public java.util.stream.DoubleStream sequential() {
            return convert(DoubleStream.this.sequential());
        }

        @Override
        public java.util.stream.DoubleStream skip(long j) {
            return convert(DoubleStream.this.skip(j));
        }

        @Override
        public java.util.stream.DoubleStream sorted() {
            return convert(DoubleStream.this.sorted());
        }

        @Override
        public java.util.Spliterator<Double> spliterator() {
            return Spliterator.OfDouble.Wrapper.convert(DoubleStream.this.spliterator());
        }

        @Override
        public java.util.Spliterator<Double> spliterator2() {
            return Spliterator.Wrapper.convert(DoubleStream.this.spliterator());
        }

        @Override
        public double sum() {
            return DoubleStream.this.sum();
        }

        @Override
        public java.util.DoubleSummaryStatistics summaryStatistics() {
            return DoubleSummaryStatisticsConversions.convert(DoubleStream.this.summaryStatistics());
        }

        public java.util.stream.DoubleStream takeWhile(DoublePredicate doublePredicate) {
            return convert(DoubleStream.this.takeWhile(doublePredicate));
        }

        @Override
        public double[] toArray() {
            return DoubleStream.this.toArray();
        }

        @Override
        public BaseStream unordered() {
            return BaseStream.Wrapper.convert(DoubleStream.this.unordered());
        }
    }

    boolean allMatch(DoublePredicate doublePredicate);

    boolean anyMatch(DoublePredicate doublePredicate);

    OptionalDouble average();

    Stream boxed();

    Object collect(Supplier supplier, ObjDoubleConsumer objDoubleConsumer, BiConsumer biConsumer);

    long count();

    DoubleStream distinct();

    DoubleStream dropWhile(DoublePredicate doublePredicate);

    DoubleStream filter(DoublePredicate doublePredicate);

    OptionalDouble findAny();

    OptionalDouble findFirst();

    DoubleStream flatMap(DoubleFunction doubleFunction);

    void forEach(DoubleConsumer doubleConsumer);

    void forEachOrdered(DoubleConsumer doubleConsumer);

    @Override
    Iterator<Double> iterator();

    DoubleStream limit(long j);

    DoubleStream map(DoubleUnaryOperator doubleUnaryOperator);

    IntStream mapToInt(DoubleToIntFunction doubleToIntFunction);

    LongStream mapToLong(DoubleToLongFunction doubleToLongFunction);

    Stream mapToObj(DoubleFunction doubleFunction);

    OptionalDouble max();

    OptionalDouble min();

    boolean noneMatch(DoublePredicate doublePredicate);

    @Override
    DoubleStream parallel();

    DoubleStream peek(DoubleConsumer doubleConsumer);

    double reduce(double d, DoubleBinaryOperator doubleBinaryOperator);

    OptionalDouble reduce(DoubleBinaryOperator doubleBinaryOperator);

    @Override
    DoubleStream sequential();

    DoubleStream skip(long j);

    DoubleStream sorted();

    @Override
    Spliterator.OfDouble spliterator();

    double sum();

    DoubleSummaryStatistics summaryStatistics();

    DoubleStream takeWhile(DoublePredicate doublePredicate);

    double[] toArray();
}
