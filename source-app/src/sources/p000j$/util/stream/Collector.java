package p000j$.util.stream;

import java.util.Collections;
import java.util.EnumSet;
import java.util.Set;
import java.util.function.BiConsumer;
import java.util.function.BinaryOperator;
import java.util.function.Function;
import java.util.function.Supplier;
import p000j$.util.Objects;

public interface Collector<T, A, R> {

    public enum Characteristics {
        CONCURRENT,
        UNORDERED,
        IDENTITY_FINISH;

        public abstract class EnumConversion {
            public static Characteristics convert(java.util.stream.Collector.Characteristics characteristics) {
                if (characteristics == null) {
                    return null;
                }
                if (characteristics == java.util.stream.Collector.Characteristics.CONCURRENT) {
                    return Characteristics.CONCURRENT;
                }
                return characteristics == java.util.stream.Collector.Characteristics.UNORDERED ? Characteristics.UNORDERED : Characteristics.IDENTITY_FINISH;
            }

            public static java.util.stream.Collector.Characteristics convert(Characteristics characteristics) {
                if (characteristics == null) {
                    return null;
                }
                if (characteristics == Characteristics.CONCURRENT) {
                    return java.util.stream.Collector.Characteristics.CONCURRENT;
                }
                return characteristics == Characteristics.UNORDERED ? java.util.stream.Collector.Characteristics.UNORDERED : java.util.stream.Collector.Characteristics.IDENTITY_FINISH;
            }
        }
    }

    public final class VivifiedWrapper implements Collector {
        public final java.util.stream.Collector wrappedValue;

        private VivifiedWrapper(java.util.stream.Collector collector) {
            this.wrappedValue = collector;
        }

        public static Collector convert(java.util.stream.Collector collector) {
            if (collector == null) {
                return null;
            }
            return collector instanceof Wrapper ? Collector.this : new VivifiedWrapper(collector);
        }

        @Override
        public BiConsumer accumulator() {
            return this.wrappedValue.accumulator();
        }

        @Override
        public Set characteristics() {
            return StreamApiFlips.flipCharacteristicSet(this.wrappedValue.characteristics());
        }

        @Override
        public BinaryOperator combiner() {
            return this.wrappedValue.combiner();
        }

        public boolean equals(Object obj) {
            java.util.stream.Collector collector = this.wrappedValue;
            if (obj instanceof VivifiedWrapper) {
                obj = ((VivifiedWrapper) obj).wrappedValue;
            }
            return collector.equals(obj);
        }

        @Override
        public Function finisher() {
            return this.wrappedValue.finisher();
        }

        public int hashCode() {
            return this.wrappedValue.hashCode();
        }

        @Override
        public Supplier supplier() {
            return this.wrappedValue.supplier();
        }
    }

    public final class Wrapper implements java.util.stream.Collector {
        private Wrapper() {
        }

        public static java.util.stream.Collector convert(Collector collector) {
            if (collector == null) {
                return null;
            }
            return collector instanceof VivifiedWrapper ? ((VivifiedWrapper) collector).wrappedValue : new Wrapper();
        }

        @Override
        public BiConsumer accumulator() {
            return Collector.this.accumulator();
        }

        @Override
        public Set characteristics() {
            return StreamApiFlips.flipCharacteristicSet(Collector.this.characteristics());
        }

        @Override
        public BinaryOperator combiner() {
            return Collector.this.combiner();
        }

        public boolean equals(Object obj) {
            Collector collector = Collector.this;
            if (obj instanceof Wrapper) {
                obj = Collector.this;
            }
            return collector.equals(obj);
        }

        @Override
        public Function finisher() {
            return Collector.this.finisher();
        }

        public int hashCode() {
            return Collector.this.hashCode();
        }

        @Override
        public Supplier supplier() {
            return Collector.this.supplier();
        }
    }

    BiConsumer accumulator();

    Set characteristics();

    BinaryOperator combiner();

    Function finisher();

    Supplier supplier();

    public final class CC {
        public static <T, A, R> Collector<T, A, R> m1730of(Supplier<A> supplier, BiConsumer<A, T> biConsumer, BinaryOperator<A> binaryOperator, Function<A, R> function, Characteristics... characteristicsArr) {
            Objects.requireNonNull(supplier);
            Objects.requireNonNull(biConsumer);
            Objects.requireNonNull(binaryOperator);
            Objects.requireNonNull(function);
            Objects.requireNonNull(characteristicsArr);
            Set setUnmodifiableSet = Collectors.CH_NOID;
            if (characteristicsArr.length > 0) {
                EnumSet enumSetNoneOf = EnumSet.noneOf(Characteristics.class);
                Collections.addAll(enumSetNoneOf, characteristicsArr);
                setUnmodifiableSet = Collections.unmodifiableSet(enumSetNoneOf);
            }
            return new Collectors.CollectorImpl(supplier, biConsumer, binaryOperator, function, setUnmodifiableSet);
        }
    }
}
