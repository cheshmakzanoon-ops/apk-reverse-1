package p000j$.util.stream;

import java.util.Comparator;
import java.util.Iterator;
import java.util.function.BiConsumer;
import java.util.function.BiFunction;
import java.util.function.BinaryOperator;
import java.util.function.Consumer;
import java.util.function.Function;
import java.util.function.IntFunction;
import java.util.function.Predicate;
import java.util.function.Supplier;
import java.util.function.ToDoubleFunction;
import java.util.function.ToIntFunction;
import java.util.function.ToLongFunction;
import java.util.stream.BaseStream;
import java.util.stream.Collector;
import java.util.stream.DoubleStream;
import java.util.stream.IntStream;
import java.util.stream.LongStream;
import p000j$.util.Optional;
import p000j$.util.OptionalConversions;
import p000j$.util.Spliterator;

public interface Stream<T> extends BaseStream<T, Stream<T>> {

    public final class VivifiedWrapper implements Stream {
        public final java.util.stream.Stream wrappedValue;

        private VivifiedWrapper(java.util.stream.Stream stream) {
            this.wrappedValue = stream;
        }

        public static Stream convert(java.util.stream.Stream stream) {
            if (stream == null) {
                return null;
            }
            return stream instanceof Wrapper ? Stream.this : new VivifiedWrapper(stream);
        }

        @Override
        public boolean allMatch(Predicate predicate) {
            return this.wrappedValue.allMatch(predicate);
        }

        @Override
        public boolean anyMatch(Predicate predicate) {
            return this.wrappedValue.anyMatch(predicate);
        }

        @Override
        public void close() {
            this.wrappedValue.close();
        }

        @Override
        public Object collect(Collector collector) {
            return this.wrappedValue.collect(Collector.Wrapper.convert(collector));
        }

        @Override
        public Object collect(Supplier supplier, BiConsumer biConsumer, BiConsumer biConsumer2) {
            return this.wrappedValue.collect(supplier, biConsumer, biConsumer2);
        }

        @Override
        public long count() {
            return this.wrappedValue.count();
        }

        @Override
        public Stream distinct() {
            return convert(this.wrappedValue.distinct());
        }

        @Override
        public Stream dropWhile(Predicate predicate) {
            return convert(this.wrappedValue.dropWhile(predicate));
        }

        public boolean equals(Object obj) {
            java.util.stream.Stream stream = this.wrappedValue;
            if (obj instanceof VivifiedWrapper) {
                obj = ((VivifiedWrapper) obj).wrappedValue;
            }
            return stream.equals(obj);
        }

        @Override
        public Stream filter(Predicate predicate) {
            return convert(this.wrappedValue.filter(predicate));
        }

        @Override
        public Optional findAny() {
            return OptionalConversions.convert(this.wrappedValue.findAny());
        }

        @Override
        public Optional findFirst() {
            return OptionalConversions.convert(this.wrappedValue.findFirst());
        }

        @Override
        public Stream flatMap(Function function) {
            return convert(this.wrappedValue.flatMap(FlatMapApiFlips.flipFunctionReturningStream(function)));
        }

        @Override
        public DoubleStream flatMapToDouble(Function function) {
            return DoubleStream.VivifiedWrapper.convert(this.wrappedValue.flatMapToDouble(FlatMapApiFlips.flipFunctionReturningStream(function)));
        }

        @Override
        public IntStream flatMapToInt(Function function) {
            return IntStream.VivifiedWrapper.convert(this.wrappedValue.flatMapToInt(FlatMapApiFlips.flipFunctionReturningStream(function)));
        }

        @Override
        public LongStream flatMapToLong(Function function) {
            return LongStream.VivifiedWrapper.convert(this.wrappedValue.flatMapToLong(FlatMapApiFlips.flipFunctionReturningStream(function)));
        }

        @Override
        public void forEach(Consumer consumer) {
            this.wrappedValue.forEach(consumer);
        }

        @Override
        public void forEachOrdered(Consumer consumer) {
            this.wrappedValue.forEachOrdered(consumer);
        }

        public int hashCode() {
            return this.wrappedValue.hashCode();
        }

        @Override
        public boolean isParallel() {
            return this.wrappedValue.isParallel();
        }

        @Override
        public Iterator iterator() {
            return this.wrappedValue.iterator();
        }

        @Override
        public Stream limit(long j) {
            return convert(this.wrappedValue.limit(j));
        }

        @Override
        public Stream map(Function function) {
            return convert(this.wrappedValue.map(function));
        }

        @Override
        public DoubleStream mapToDouble(ToDoubleFunction toDoubleFunction) {
            return DoubleStream.VivifiedWrapper.convert(this.wrappedValue.mapToDouble(toDoubleFunction));
        }

        @Override
        public IntStream mapToInt(ToIntFunction toIntFunction) {
            return IntStream.VivifiedWrapper.convert(this.wrappedValue.mapToInt(toIntFunction));
        }

        @Override
        public LongStream mapToLong(ToLongFunction toLongFunction) {
            return LongStream.VivifiedWrapper.convert(this.wrappedValue.mapToLong(toLongFunction));
        }

        @Override
        public Optional max(Comparator comparator) {
            return OptionalConversions.convert(this.wrappedValue.max(comparator));
        }

        @Override
        public Optional min(Comparator comparator) {
            return OptionalConversions.convert(this.wrappedValue.min(comparator));
        }

        @Override
        public boolean noneMatch(Predicate predicate) {
            return this.wrappedValue.noneMatch(predicate);
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
        public Stream peek(Consumer consumer) {
            return convert(this.wrappedValue.peek(consumer));
        }

        @Override
        public Optional reduce(BinaryOperator binaryOperator) {
            return OptionalConversions.convert(this.wrappedValue.reduce(binaryOperator));
        }

        @Override
        public Object reduce(Object obj, BiFunction biFunction, BinaryOperator binaryOperator) {
            return this.wrappedValue.reduce(obj, biFunction, binaryOperator);
        }

        @Override
        public Object reduce(Object obj, BinaryOperator binaryOperator) {
            return this.wrappedValue.reduce(obj, binaryOperator);
        }

        @Override
        public BaseStream sequential() {
            return BaseStream.VivifiedWrapper.convert(this.wrappedValue.sequential());
        }

        @Override
        public Stream skip(long j) {
            return convert(this.wrappedValue.skip(j));
        }

        @Override
        public Stream sorted() {
            return convert(this.wrappedValue.sorted());
        }

        @Override
        public Stream sorted(Comparator comparator) {
            return convert(this.wrappedValue.sorted(comparator));
        }

        @Override
        public Spliterator spliterator() {
            return Spliterator.VivifiedWrapper.convert(this.wrappedValue.spliterator());
        }

        @Override
        public Stream takeWhile(Predicate predicate) {
            return convert(this.wrappedValue.takeWhile(predicate));
        }

        @Override
        public Object[] toArray() {
            return this.wrappedValue.toArray();
        }

        @Override
        public Object[] toArray(IntFunction intFunction) {
            return this.wrappedValue.toArray(intFunction);
        }

        @Override
        public BaseStream unordered() {
            return BaseStream.VivifiedWrapper.convert(this.wrappedValue.unordered());
        }
    }

    public final class Wrapper implements java.util.stream.Stream {
        private Wrapper() {
        }

        public static java.util.stream.Stream convert(Stream stream) {
            if (stream == null) {
                return null;
            }
            return stream instanceof VivifiedWrapper ? ((VivifiedWrapper) stream).wrappedValue : new Wrapper();
        }

        @Override
        public boolean allMatch(Predicate predicate) {
            return Stream.this.allMatch(predicate);
        }

        @Override
        public boolean anyMatch(Predicate predicate) {
            return Stream.this.anyMatch(predicate);
        }

        @Override
        public void close() {
            Stream.this.close();
        }

        @Override
        public Object collect(Supplier supplier, BiConsumer biConsumer, BiConsumer biConsumer2) {
            return Stream.this.collect(supplier, biConsumer, biConsumer2);
        }

        @Override
        public Object collect(Collector collector) {
            return Stream.this.collect(Collector.VivifiedWrapper.convert(collector));
        }

        @Override
        public long count() {
            return Stream.this.count();
        }

        @Override
        public java.util.stream.Stream distinct() {
            return convert(Stream.this.distinct());
        }

        @Override
        public java.util.stream.Stream dropWhile(Predicate predicate) {
            return convert(Stream.this.dropWhile(predicate));
        }

        public boolean equals(Object obj) {
            Stream stream = Stream.this;
            if (obj instanceof Wrapper) {
                obj = Stream.this;
            }
            return stream.equals(obj);
        }

        @Override
        public java.util.stream.Stream filter(Predicate predicate) {
            return convert(Stream.this.filter(predicate));
        }

        @Override
        public java.util.Optional findAny() {
            return OptionalConversions.convert(Stream.this.findAny());
        }

        @Override
        public java.util.Optional findFirst() {
            return OptionalConversions.convert(Stream.this.findFirst());
        }

        @Override
        public java.util.stream.Stream flatMap(Function function) {
            return convert(Stream.this.flatMap(FlatMapApiFlips.flipFunctionReturningStream(function)));
        }

        @Override
        public DoubleStream flatMapToDouble(Function function) {
            return DoubleStream.Wrapper.convert(Stream.this.flatMapToDouble(FlatMapApiFlips.flipFunctionReturningStream(function)));
        }

        @Override
        public IntStream flatMapToInt(Function function) {
            return IntStream.Wrapper.convert(Stream.this.flatMapToInt(FlatMapApiFlips.flipFunctionReturningStream(function)));
        }

        @Override
        public LongStream flatMapToLong(Function function) {
            return LongStream.Wrapper.convert(Stream.this.flatMapToLong(FlatMapApiFlips.flipFunctionReturningStream(function)));
        }

        @Override
        public void forEach(Consumer consumer) {
            Stream.this.forEach(consumer);
        }

        @Override
        public void forEachOrdered(Consumer consumer) {
            Stream.this.forEachOrdered(consumer);
        }

        public int hashCode() {
            return Stream.this.hashCode();
        }

        @Override
        public boolean isParallel() {
            return Stream.this.isParallel();
        }

        @Override
        public Iterator iterator() {
            return Stream.this.iterator();
        }

        @Override
        public java.util.stream.Stream limit(long j) {
            return convert(Stream.this.limit(j));
        }

        @Override
        public java.util.stream.Stream map(Function function) {
            return convert(Stream.this.map(function));
        }

        @Override
        public DoubleStream mapToDouble(ToDoubleFunction toDoubleFunction) {
            return DoubleStream.Wrapper.convert(Stream.this.mapToDouble(toDoubleFunction));
        }

        @Override
        public IntStream mapToInt(ToIntFunction toIntFunction) {
            return IntStream.Wrapper.convert(Stream.this.mapToInt(toIntFunction));
        }

        @Override
        public LongStream mapToLong(ToLongFunction toLongFunction) {
            return LongStream.Wrapper.convert(Stream.this.mapToLong(toLongFunction));
        }

        @Override
        public java.util.Optional max(Comparator comparator) {
            return OptionalConversions.convert(Stream.this.max(comparator));
        }

        @Override
        public java.util.Optional min(Comparator comparator) {
            return OptionalConversions.convert(Stream.this.min(comparator));
        }

        @Override
        public boolean noneMatch(Predicate predicate) {
            return Stream.this.noneMatch(predicate);
        }

        @Override
        public BaseStream onClose(Runnable runnable) {
            return BaseStream.Wrapper.convert(Stream.this.onClose(runnable));
        }

        @Override
        public BaseStream parallel() {
            return BaseStream.Wrapper.convert(Stream.this.parallel());
        }

        @Override
        public java.util.stream.Stream peek(Consumer consumer) {
            return convert(Stream.this.peek(consumer));
        }

        @Override
        public Object reduce(Object obj, BiFunction biFunction, BinaryOperator binaryOperator) {
            return Stream.this.reduce(obj, biFunction, binaryOperator);
        }

        @Override
        public Object reduce(Object obj, BinaryOperator binaryOperator) {
            return Stream.this.reduce(obj, binaryOperator);
        }

        @Override
        public java.util.Optional reduce(BinaryOperator binaryOperator) {
            return OptionalConversions.convert(Stream.this.reduce(binaryOperator));
        }

        @Override
        public BaseStream sequential() {
            return BaseStream.Wrapper.convert(Stream.this.sequential());
        }

        @Override
        public java.util.stream.Stream skip(long j) {
            return convert(Stream.this.skip(j));
        }

        @Override
        public java.util.stream.Stream sorted() {
            return convert(Stream.this.sorted());
        }

        @Override
        public java.util.stream.Stream sorted(Comparator comparator) {
            return convert(Stream.this.sorted(comparator));
        }

        @Override
        public java.util.Spliterator spliterator() {
            return Spliterator.Wrapper.convert(Stream.this.spliterator());
        }

        @Override
        public java.util.stream.Stream takeWhile(Predicate predicate) {
            return convert(Stream.this.takeWhile(predicate));
        }

        @Override
        public Object[] toArray() {
            return Stream.this.toArray();
        }

        @Override
        public Object[] toArray(IntFunction intFunction) {
            return Stream.this.toArray(intFunction);
        }

        @Override
        public BaseStream unordered() {
            return BaseStream.Wrapper.convert(Stream.this.unordered());
        }
    }

    boolean allMatch(Predicate predicate);

    boolean anyMatch(Predicate predicate);

    <R, A> R collect(Collector<? super T, A, R> collector);

    Object collect(Supplier supplier, BiConsumer biConsumer, BiConsumer biConsumer2);

    long count();

    Stream<T> distinct();

    Stream dropWhile(Predicate predicate);

    Stream filter(Predicate predicate);

    Optional findAny();

    Optional findFirst();

    Stream flatMap(Function function);

    DoubleStream flatMapToDouble(Function function);

    IntStream flatMapToInt(Function function);

    LongStream flatMapToLong(Function function);

    void forEach(Consumer consumer);

    void forEachOrdered(Consumer consumer);

    Stream limit(long j);

    <R> Stream<R> map(Function<? super T, ? extends R> function);

    DoubleStream mapToDouble(ToDoubleFunction toDoubleFunction);

    IntStream mapToInt(ToIntFunction toIntFunction);

    LongStream mapToLong(ToLongFunction toLongFunction);

    Optional max(Comparator comparator);

    Optional min(Comparator comparator);

    boolean noneMatch(Predicate predicate);

    Stream peek(Consumer consumer);

    Optional reduce(BinaryOperator binaryOperator);

    Object reduce(Object obj, BiFunction biFunction, BinaryOperator binaryOperator);

    Object reduce(Object obj, BinaryOperator binaryOperator);

    Stream skip(long j);

    Stream sorted();

    Stream sorted(Comparator comparator);

    Stream takeWhile(Predicate predicate);

    Object[] toArray();

    Object[] toArray(IntFunction intFunction);
}
