package p000j$.util.stream;

import java.util.Iterator;
import java.util.function.BiConsumer;
import java.util.function.LongBinaryOperator;
import java.util.function.LongConsumer;
import java.util.function.LongFunction;
import java.util.function.LongPredicate;
import java.util.function.LongToDoubleFunction;
import java.util.function.LongToIntFunction;
import java.util.function.LongUnaryOperator;
import java.util.function.ObjLongConsumer;
import java.util.function.Supplier;
import java.util.stream.BaseStream;
import java.util.stream.DoubleStream;
import java.util.stream.IntStream;
import java.util.stream.Stream;
import p000j$.util.LongSummaryStatistics;
import p000j$.util.LongSummaryStatisticsConversions;
import p000j$.util.OptionalConversions;
import p000j$.util.OptionalDouble;
import p000j$.util.OptionalLong;
import p000j$.util.PrimitiveIterator;
import p000j$.util.Spliterator;

public interface LongStream extends BaseStream<Long, LongStream> {

    public final class VivifiedWrapper implements LongStream {
        public final java.util.stream.LongStream wrappedValue;

        private VivifiedWrapper(java.util.stream.LongStream longStream) {
            this.wrappedValue = longStream;
        }

        public static LongStream convert(java.util.stream.LongStream longStream) {
            if (longStream == null) {
                return null;
            }
            return longStream instanceof Wrapper ? LongStream.this : new VivifiedWrapper(longStream);
        }

        @Override
        public boolean allMatch(LongPredicate longPredicate) {
            return this.wrappedValue.allMatch(longPredicate);
        }

        @Override
        public boolean anyMatch(LongPredicate longPredicate) {
            return this.wrappedValue.anyMatch(longPredicate);
        }

        @Override
        public DoubleStream asDoubleStream() {
            return DoubleStream.VivifiedWrapper.convert(this.wrappedValue.asDoubleStream());
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
        public Object collect(Supplier supplier, ObjLongConsumer objLongConsumer, BiConsumer biConsumer) {
            return this.wrappedValue.collect(supplier, objLongConsumer, biConsumer);
        }

        @Override
        public long count() {
            return this.wrappedValue.count();
        }

        @Override
        public LongStream distinct() {
            return convert(this.wrappedValue.distinct());
        }

        @Override
        public LongStream dropWhile(LongPredicate longPredicate) {
            return convert(this.wrappedValue.dropWhile(longPredicate));
        }

        public boolean equals(Object obj) {
            java.util.stream.LongStream longStream = this.wrappedValue;
            if (obj instanceof VivifiedWrapper) {
                obj = ((VivifiedWrapper) obj).wrappedValue;
            }
            return longStream.equals(obj);
        }

        @Override
        public LongStream filter(LongPredicate longPredicate) {
            return convert(this.wrappedValue.filter(longPredicate));
        }

        @Override
        public OptionalLong findAny() {
            return OptionalConversions.convert(this.wrappedValue.findAny());
        }

        @Override
        public OptionalLong findFirst() {
            return OptionalConversions.convert(this.wrappedValue.findFirst());
        }

        @Override
        public LongStream flatMap(LongFunction longFunction) {
            return convert(this.wrappedValue.flatMap(FlatMapApiFlips.flipFunctionReturningStream(longFunction)));
        }

        @Override
        public void forEach(LongConsumer longConsumer) {
            this.wrappedValue.forEach(longConsumer);
        }

        @Override
        public void forEachOrdered(LongConsumer longConsumer) {
            this.wrappedValue.forEachOrdered(longConsumer);
        }

        public int hashCode() {
            return this.wrappedValue.hashCode();
        }

        @Override
        public boolean isParallel() {
            return this.wrappedValue.isParallel();
        }

        @Override
        public Iterator<Long> iterator() {
            return PrimitiveIterator.OfLong.VivifiedWrapper.convert(this.wrappedValue.iterator());
        }

        @Override
        public Iterator<Long> iterator2() {
            return this.wrappedValue.iterator();
        }

        @Override
        public LongStream limit(long j) {
            return convert(this.wrappedValue.limit(j));
        }

        @Override
        public LongStream map(LongUnaryOperator longUnaryOperator) {
            return convert(this.wrappedValue.map(longUnaryOperator));
        }

        @Override
        public DoubleStream mapToDouble(LongToDoubleFunction longToDoubleFunction) {
            return DoubleStream.VivifiedWrapper.convert(this.wrappedValue.mapToDouble(longToDoubleFunction));
        }

        @Override
        public IntStream mapToInt(LongToIntFunction longToIntFunction) {
            return IntStream.VivifiedWrapper.convert(this.wrappedValue.mapToInt(longToIntFunction));
        }

        @Override
        public Stream mapToObj(LongFunction longFunction) {
            return Stream.VivifiedWrapper.convert(this.wrappedValue.mapToObj(longFunction));
        }

        @Override
        public OptionalLong max() {
            return OptionalConversions.convert(this.wrappedValue.max());
        }

        @Override
        public OptionalLong min() {
            return OptionalConversions.convert(this.wrappedValue.min());
        }

        @Override
        public boolean noneMatch(LongPredicate longPredicate) {
            return this.wrappedValue.noneMatch(longPredicate);
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
        public LongStream parallel() {
            return convert(this.wrappedValue.parallel());
        }

        @Override
        public LongStream peek(LongConsumer longConsumer) {
            return convert(this.wrappedValue.peek(longConsumer));
        }

        @Override
        public long reduce(long j, LongBinaryOperator longBinaryOperator) {
            return this.wrappedValue.reduce(j, longBinaryOperator);
        }

        @Override
        public OptionalLong reduce(LongBinaryOperator longBinaryOperator) {
            return OptionalConversions.convert(this.wrappedValue.reduce(longBinaryOperator));
        }

        @Override
        public BaseStream sequential() {
            return BaseStream.VivifiedWrapper.convert(this.wrappedValue.sequential());
        }

        @Override
        public LongStream sequential() {
            return convert(this.wrappedValue.sequential());
        }

        @Override
        public LongStream skip(long j) {
            return convert(this.wrappedValue.skip(j));
        }

        @Override
        public LongStream sorted() {
            return convert(this.wrappedValue.sorted());
        }

        @Override
        public Spliterator.OfLong spliterator() {
            return Spliterator.OfLong.VivifiedWrapper.convert(this.wrappedValue.spliterator());
        }

        @Override
        public Spliterator spliterator() {
            return Spliterator.VivifiedWrapper.convert(this.wrappedValue.spliterator());
        }

        @Override
        public long sum() {
            return this.wrappedValue.sum();
        }

        @Override
        public LongSummaryStatistics summaryStatistics() {
            return LongSummaryStatisticsConversions.convert(this.wrappedValue.summaryStatistics());
        }

        @Override
        public LongStream takeWhile(LongPredicate longPredicate) {
            return convert(this.wrappedValue.takeWhile(longPredicate));
        }

        @Override
        public long[] toArray() {
            return this.wrappedValue.toArray();
        }

        @Override
        public BaseStream unordered() {
            return BaseStream.VivifiedWrapper.convert(this.wrappedValue.unordered());
        }
    }

    public final class Wrapper implements java.util.stream.LongStream {
        private Wrapper() {
        }

        public static java.util.stream.LongStream convert(LongStream longStream) {
            if (longStream == null) {
                return null;
            }
            return longStream instanceof VivifiedWrapper ? ((VivifiedWrapper) longStream).wrappedValue : longStream.new Wrapper();
        }

        @Override
        public boolean allMatch(LongPredicate longPredicate) {
            return LongStream.this.allMatch(longPredicate);
        }

        @Override
        public boolean anyMatch(LongPredicate longPredicate) {
            return LongStream.this.anyMatch(longPredicate);
        }

        @Override
        public DoubleStream asDoubleStream() {
            return DoubleStream.Wrapper.convert(LongStream.this.asDoubleStream());
        }

        @Override
        public java.util.OptionalDouble average() {
            return OptionalConversions.convert(LongStream.this.average());
        }

        @Override
        public Stream boxed() {
            return Stream.Wrapper.convert(LongStream.this.boxed());
        }

        @Override
        public void close() {
            LongStream.this.close();
        }

        @Override
        public Object collect(Supplier supplier, ObjLongConsumer objLongConsumer, BiConsumer biConsumer) {
            return LongStream.this.collect(supplier, objLongConsumer, biConsumer);
        }

        @Override
        public long count() {
            return LongStream.this.count();
        }

        @Override
        public java.util.stream.LongStream distinct() {
            return convert(LongStream.this.distinct());
        }

        public java.util.stream.LongStream dropWhile(LongPredicate longPredicate) {
            return convert(LongStream.this.dropWhile(longPredicate));
        }

        public boolean equals(Object obj) {
            LongStream longStream = LongStream.this;
            if (obj instanceof Wrapper) {
                obj = LongStream.this;
            }
            return longStream.equals(obj);
        }

        @Override
        public java.util.stream.LongStream filter(LongPredicate longPredicate) {
            return convert(LongStream.this.filter(longPredicate));
        }

        @Override
        public java.util.OptionalLong findAny() {
            return OptionalConversions.convert(LongStream.this.findAny());
        }

        @Override
        public java.util.OptionalLong findFirst() {
            return OptionalConversions.convert(LongStream.this.findFirst());
        }

        @Override
        public java.util.stream.LongStream flatMap(LongFunction longFunction) {
            return convert(LongStream.this.flatMap(FlatMapApiFlips.flipFunctionReturningStream(longFunction)));
        }

        @Override
        public void forEach(LongConsumer longConsumer) {
            LongStream.this.forEach(longConsumer);
        }

        @Override
        public void forEachOrdered(LongConsumer longConsumer) {
            LongStream.this.forEachOrdered(longConsumer);
        }

        public int hashCode() {
            return LongStream.this.hashCode();
        }

        @Override
        public boolean isParallel() {
            return LongStream.this.isParallel();
        }

        @Override
        public Iterator<Long> iterator() {
            return LongStream.this.iterator();
        }

        @Override
        public Iterator<Long> iterator2() {
            return PrimitiveIterator.OfLong.Wrapper.convert(LongStream.this.iterator());
        }

        @Override
        public java.util.stream.LongStream limit(long j) {
            return convert(LongStream.this.limit(j));
        }

        @Override
        public java.util.stream.LongStream map(LongUnaryOperator longUnaryOperator) {
            return convert(LongStream.this.map(longUnaryOperator));
        }

        @Override
        public DoubleStream mapToDouble(LongToDoubleFunction longToDoubleFunction) {
            return DoubleStream.Wrapper.convert(LongStream.this.mapToDouble(longToDoubleFunction));
        }

        @Override
        public IntStream mapToInt(LongToIntFunction longToIntFunction) {
            return IntStream.Wrapper.convert(LongStream.this.mapToInt(longToIntFunction));
        }

        @Override
        public Stream mapToObj(LongFunction longFunction) {
            return Stream.Wrapper.convert(LongStream.this.mapToObj(longFunction));
        }

        @Override
        public java.util.OptionalLong max() {
            return OptionalConversions.convert(LongStream.this.max());
        }

        @Override
        public java.util.OptionalLong min() {
            return OptionalConversions.convert(LongStream.this.min());
        }

        @Override
        public boolean noneMatch(LongPredicate longPredicate) {
            return LongStream.this.noneMatch(longPredicate);
        }

        @Override
        public BaseStream onClose(Runnable runnable) {
            return BaseStream.Wrapper.convert(LongStream.this.onClose(runnable));
        }

        @Override
        public BaseStream parallel() {
            return BaseStream.Wrapper.convert(LongStream.this.parallel());
        }

        @Override
        public java.util.stream.LongStream parallel() {
            return convert(LongStream.this.parallel());
        }

        @Override
        public java.util.stream.LongStream peek(LongConsumer longConsumer) {
            return convert(LongStream.this.peek(longConsumer));
        }

        @Override
        public long reduce(long j, LongBinaryOperator longBinaryOperator) {
            return LongStream.this.reduce(j, longBinaryOperator);
        }

        @Override
        public java.util.OptionalLong reduce(LongBinaryOperator longBinaryOperator) {
            return OptionalConversions.convert(LongStream.this.reduce(longBinaryOperator));
        }

        @Override
        public BaseStream sequential() {
            return BaseStream.Wrapper.convert(LongStream.this.sequential());
        }

        @Override
        public java.util.stream.LongStream sequential() {
            return convert(LongStream.this.sequential());
        }

        @Override
        public java.util.stream.LongStream skip(long j) {
            return convert(LongStream.this.skip(j));
        }

        @Override
        public java.util.stream.LongStream sorted() {
            return convert(LongStream.this.sorted());
        }

        @Override
        public java.util.Spliterator<Long> spliterator() {
            return Spliterator.OfLong.Wrapper.convert(LongStream.this.spliterator());
        }

        @Override
        public java.util.Spliterator<Long> spliterator2() {
            return Spliterator.Wrapper.convert(LongStream.this.spliterator());
        }

        @Override
        public long sum() {
            return LongStream.this.sum();
        }

        @Override
        public java.util.LongSummaryStatistics summaryStatistics() {
            return LongSummaryStatisticsConversions.convert(LongStream.this.summaryStatistics());
        }

        public java.util.stream.LongStream takeWhile(LongPredicate longPredicate) {
            return convert(LongStream.this.takeWhile(longPredicate));
        }

        @Override
        public long[] toArray() {
            return LongStream.this.toArray();
        }

        @Override
        public BaseStream unordered() {
            return BaseStream.Wrapper.convert(LongStream.this.unordered());
        }
    }

    boolean allMatch(LongPredicate longPredicate);

    boolean anyMatch(LongPredicate longPredicate);

    DoubleStream asDoubleStream();

    OptionalDouble average();

    Stream boxed();

    Object collect(Supplier supplier, ObjLongConsumer objLongConsumer, BiConsumer biConsumer);

    long count();

    LongStream distinct();

    LongStream dropWhile(LongPredicate longPredicate);

    LongStream filter(LongPredicate longPredicate);

    OptionalLong findAny();

    OptionalLong findFirst();

    LongStream flatMap(LongFunction longFunction);

    void forEach(LongConsumer longConsumer);

    void forEachOrdered(LongConsumer longConsumer);

    @Override
    Iterator<Long> iterator();

    LongStream limit(long j);

    LongStream map(LongUnaryOperator longUnaryOperator);

    DoubleStream mapToDouble(LongToDoubleFunction longToDoubleFunction);

    IntStream mapToInt(LongToIntFunction longToIntFunction);

    Stream mapToObj(LongFunction longFunction);

    OptionalLong max();

    OptionalLong min();

    boolean noneMatch(LongPredicate longPredicate);

    @Override
    LongStream parallel();

    LongStream peek(LongConsumer longConsumer);

    long reduce(long j, LongBinaryOperator longBinaryOperator);

    OptionalLong reduce(LongBinaryOperator longBinaryOperator);

    @Override
    LongStream sequential();

    LongStream skip(long j);

    LongStream sorted();

    @Override
    Spliterator.OfLong spliterator();

    long sum();

    LongSummaryStatistics summaryStatistics();

    LongStream takeWhile(LongPredicate longPredicate);

    long[] toArray();
}
