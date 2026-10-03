package kotlin.streams.jdk8;

import j$.util.Spliterator;
import j$.util.Spliterators;
import j$.util.stream.Collectors;
import j$.util.stream.DoubleStream;
import j$.util.stream.IntStream;
import j$.util.stream.LongStream;
import j$.util.stream.Stream;
import j$.util.stream.StreamSupport;
import java.util.Iterator;
import java.util.List;
import java.util.function.Supplier;
import kotlin.Metadata;
import kotlin.collections.ArraysKt;
import kotlin.jvm.internal.Intrinsics;
import kotlin.sequences.Sequence;

@Metadata(m17d1 = {"\u0000.\n\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0000\n\u0002\u0010\t\n\u0000\n\u0000\n\u0002\u0010\u0006\n\u0002\b\u0003\n\u0002\u0010 \n\u0002\b\u0006\u001a%\u0010\u0003\u001a\b\u0012\u0004\u0012\u00028\u00000\u0002\"\u0004\b\u0000\u0010\u0000*\b\u0012\u0004\u0012\u00028\u00000\u0001H\u0007¢\u0006\u0004\b\u0003\u0010\u0004\u001a\u0019\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00060\u0002*\u00020\u0005H\u0007¢\u0006\u0004\b\u0003\u0010\u0007\u001a\u0019\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\t0\u0002*\u00020\bH\u0007¢\u0006\u0004\b\u0003\u0010\n\u001a\u0019\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\f0\u0002*\u00020\u000bH\u0007¢\u0006\u0004\b\u0003\u0010\r\u001a%\u0010\u000e\u001a\b\u0012\u0004\u0012\u00028\u00000\u0001\"\u0004\b\u0000\u0010\u0000*\b\u0012\u0004\u0012\u00028\u00000\u0002H\u0007¢\u0006\u0004\b\u000e\u0010\u000f\u001a%\u0010\u0011\u001a\b\u0012\u0004\u0012\u00028\u00000\u0010\"\u0004\b\u0000\u0010\u0000*\b\u0012\u0004\u0012\u00028\u00000\u0001H\u0007¢\u0006\u0004\b\u0011\u0010\u0012\u001a\u0019\u0010\u0011\u001a\b\u0012\u0004\u0012\u00020\u00060\u0010*\u00020\u0005H\u0007¢\u0006\u0004\b\u0011\u0010\u0013\u001a\u0019\u0010\u0011\u001a\b\u0012\u0004\u0012\u00020\t0\u0010*\u00020\bH\u0007¢\u0006\u0004\b\u0011\u0010\u0014\u001a\u0019\u0010\u0011\u001a\b\u0012\u0004\u0012\u00020\f0\u0010*\u00020\u000bH\u0007¢\u0006\u0004\b\u0011\u0010\u0015¨\u0006\u0016"}, m18d2 = {"T", "j$/util/stream/Stream", "Lkotlin/sequences/Sequence;", "asSequence", "(Lj$/util/stream/Stream;)Lkotlin/sequences/Sequence;", "j$/util/stream/IntStream", "", "(Lj$/util/stream/IntStream;)Lkotlin/sequences/Sequence;", "j$/util/stream/LongStream", "", "(Lj$/util/stream/LongStream;)Lkotlin/sequences/Sequence;", "j$/util/stream/DoubleStream", "", "(Lj$/util/stream/DoubleStream;)Lkotlin/sequences/Sequence;", "asStream", "(Lkotlin/sequences/Sequence;)Lj$/util/stream/Stream;", "", "toList", "(Lj$/util/stream/Stream;)Ljava/util/List;", "(Lj$/util/stream/IntStream;)Ljava/util/List;", "(Lj$/util/stream/LongStream;)Ljava/util/List;", "(Lj$/util/stream/DoubleStream;)Ljava/util/List;", "kotlin-stdlib-jdk8"}, m19k = 2, m20mv = {1, 8, 0}, m22xi = 48)
public final class StreamsKt {
    public static final <T> Sequence<T> asSequence(final Stream<T> stream) {
        Intrinsics.checkNotNullParameter(stream, "<this>");
        return new Sequence<T>() {
            @Override
            public Iterator<T> iterator() {
                Iterator<T> it = stream.iterator();
                Intrinsics.checkNotNullExpressionValue(it, "iterator()");
                return it;
            }
        };
    }

    public static final Sequence<Integer> asSequence(final IntStream intStream) {
        Intrinsics.checkNotNullParameter(intStream, "<this>");
        return new Sequence<Integer>() {
            @Override
            public Iterator<Integer> iterator() {
                Iterator<Integer> it = intStream.iterator();
                Intrinsics.checkNotNullExpressionValue(it, "iterator()");
                return it;
            }
        };
    }

    public static final Sequence<Long> asSequence(final LongStream longStream) {
        Intrinsics.checkNotNullParameter(longStream, "<this>");
        return new Sequence<Long>() {
            @Override
            public Iterator<Long> iterator() {
                Iterator<Long> it = longStream.iterator();
                Intrinsics.checkNotNullExpressionValue(it, "iterator()");
                return it;
            }
        };
    }

    public static final Sequence<Double> asSequence(final DoubleStream doubleStream) {
        Intrinsics.checkNotNullParameter(doubleStream, "<this>");
        return new Sequence<Double>() {
            @Override
            public Iterator<Double> iterator() {
                Iterator<Double> it = doubleStream.iterator();
                Intrinsics.checkNotNullExpressionValue(it, "iterator()");
                return it;
            }
        };
    }

    public static final <T> Stream<T> asStream(final Sequence<? extends T> sequence) {
        Intrinsics.checkNotNullParameter(sequence, "<this>");
        Stream<T> stream = StreamSupport.stream(new Supplier() {
            @Override
            public final Object get() {
                return StreamsKt.asStream$lambda$4(sequence);
            }
        }, 16, false);
        Intrinsics.checkNotNullExpressionValue(stream, "stream({ Spliterators.sp…literator.ORDERED, false)");
        return stream;
    }

    public static final Spliterator asStream$lambda$4(Sequence this_asStream) {
        Intrinsics.checkNotNullParameter(this_asStream, "$this_asStream");
        return Spliterators.spliteratorUnknownSize(this_asStream.iterator(), 16);
    }

    public static final <T> List<T> toList(Stream<T> stream) {
        Intrinsics.checkNotNullParameter(stream, "<this>");
        Object objCollect = stream.collect(Collectors.toList());
        Intrinsics.checkNotNullExpressionValue(objCollect, "collect(Collectors.toList<T>())");
        return (List) objCollect;
    }

    public static final List<Integer> toList(IntStream intStream) {
        Intrinsics.checkNotNullParameter(intStream, "<this>");
        int[] array = intStream.toArray();
        Intrinsics.checkNotNullExpressionValue(array, "toArray()");
        return ArraysKt.asList(array);
    }

    public static final List<Long> toList(LongStream longStream) {
        Intrinsics.checkNotNullParameter(longStream, "<this>");
        long[] array = longStream.toArray();
        Intrinsics.checkNotNullExpressionValue(array, "toArray()");
        return ArraysKt.asList(array);
    }

    public static final List<Double> toList(DoubleStream doubleStream) {
        Intrinsics.checkNotNullParameter(doubleStream, "<this>");
        double[] array = doubleStream.toArray();
        Intrinsics.checkNotNullExpressionValue(array, "toArray()");
        return ArraysKt.asList(array);
    }
}
