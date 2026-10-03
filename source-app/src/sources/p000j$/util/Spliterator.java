package p000j$.util;

import java.util.Comparator;
import java.util.function.Consumer;
import java.util.function.DoubleConsumer;
import java.util.function.IntConsumer;
import java.util.function.LongConsumer;

public interface Spliterator<T> {

    public interface OfPrimitive extends Spliterator {

        public final class VivifiedWrapper implements OfPrimitive {
            public final java.util.Spliterator.OfPrimitive wrappedValue;

            private VivifiedWrapper(java.util.Spliterator.OfPrimitive ofPrimitive) {
                this.wrappedValue = ofPrimitive;
            }

            public static OfPrimitive convert(java.util.Spliterator.OfPrimitive ofPrimitive) {
                if (ofPrimitive == null) {
                    return null;
                }
                if (ofPrimitive instanceof Wrapper) {
                    return OfPrimitive.this;
                }
                if (ofPrimitive instanceof java.util.Spliterator.OfDouble) {
                    return OfDouble.VivifiedWrapper.convert((java.util.Spliterator.OfDouble) ofPrimitive);
                }
                if (ofPrimitive instanceof java.util.Spliterator.OfInt) {
                    return OfInt.VivifiedWrapper.convert((java.util.Spliterator.OfInt) ofPrimitive);
                }
                return ofPrimitive instanceof java.util.Spliterator.OfLong ? OfLong.VivifiedWrapper.convert((java.util.Spliterator.OfLong) ofPrimitive) : new VivifiedWrapper(ofPrimitive);
            }

            @Override
            public int characteristics() {
                return this.wrappedValue.characteristics();
            }

            public boolean equals(Object obj) {
                java.util.Spliterator.OfPrimitive ofPrimitive = this.wrappedValue;
                if (obj instanceof VivifiedWrapper) {
                    obj = ((VivifiedWrapper) obj).wrappedValue;
                }
                return ofPrimitive.equals(obj);
            }

            @Override
            public long estimateSize() {
                return this.wrappedValue.estimateSize();
            }

            @Override
            public void forEachRemaining(Object obj) {
                this.wrappedValue.forEachRemaining(obj);
            }

            @Override
            public void forEachRemaining(Consumer consumer) {
                this.wrappedValue.forEachRemaining(consumer);
            }

            @Override
            public Comparator getComparator() {
                return this.wrappedValue.getComparator();
            }

            @Override
            public long getExactSizeIfKnown() {
                return this.wrappedValue.getExactSizeIfKnown();
            }

            @Override
            public boolean hasCharacteristics(int i) {
                return this.wrappedValue.hasCharacteristics(i);
            }

            public int hashCode() {
                return this.wrappedValue.hashCode();
            }

            @Override
            public boolean tryAdvance(Object obj) {
                return this.wrappedValue.tryAdvance(obj);
            }

            @Override
            public boolean tryAdvance(Consumer consumer) {
                return this.wrappedValue.tryAdvance(consumer);
            }

            @Override
            public OfPrimitive trySplit() {
                return convert(this.wrappedValue.trySplit());
            }

            @Override
            public Spliterator trySplit() {
                return VivifiedWrapper.convert(this.wrappedValue.trySplit());
            }
        }

        public final class Wrapper implements java.util.Spliterator.OfPrimitive {
            private Wrapper() {
            }

            public static java.util.Spliterator.OfPrimitive convert(OfPrimitive ofPrimitive) {
                if (ofPrimitive == null) {
                    return null;
                }
                if (ofPrimitive instanceof VivifiedWrapper) {
                    return ((VivifiedWrapper) ofPrimitive).wrappedValue;
                }
                if (ofPrimitive instanceof OfDouble) {
                    return OfDouble.Wrapper.convert((OfDouble) ofPrimitive);
                }
                if (ofPrimitive instanceof OfInt) {
                    return OfInt.Wrapper.convert((OfInt) ofPrimitive);
                }
                return ofPrimitive instanceof OfLong ? OfLong.Wrapper.convert((OfLong) ofPrimitive) : ofPrimitive.new Wrapper();
            }

            @Override
            public int characteristics() {
                return OfPrimitive.this.characteristics();
            }

            public boolean equals(Object obj) {
                OfPrimitive ofPrimitive = OfPrimitive.this;
                if (obj instanceof Wrapper) {
                    obj = OfPrimitive.this;
                }
                return ofPrimitive.equals(obj);
            }

            @Override
            public long estimateSize() {
                return OfPrimitive.this.estimateSize();
            }

            @Override
            public void forEachRemaining(Object obj) {
                OfPrimitive.this.forEachRemaining(obj);
            }

            @Override
            public void forEachRemaining(Consumer consumer) {
                OfPrimitive.this.forEachRemaining(consumer);
            }

            @Override
            public Comparator getComparator() {
                return OfPrimitive.this.getComparator();
            }

            @Override
            public long getExactSizeIfKnown() {
                return OfPrimitive.this.getExactSizeIfKnown();
            }

            @Override
            public boolean hasCharacteristics(int i) {
                return OfPrimitive.this.hasCharacteristics(i);
            }

            public int hashCode() {
                return OfPrimitive.this.hashCode();
            }

            @Override
            public boolean tryAdvance(Object obj) {
                return OfPrimitive.this.tryAdvance(obj);
            }

            @Override
            public boolean tryAdvance(Consumer consumer) {
                return OfPrimitive.this.tryAdvance(consumer);
            }

            @Override
            public java.util.Spliterator.OfPrimitive trySplit() {
                return convert(OfPrimitive.this.trySplit());
            }

            @Override
            public java.util.Spliterator trySplit() {
                return Wrapper.convert(OfPrimitive.this.trySplit());
            }
        }

        void forEachRemaining(Object obj);

        boolean tryAdvance(Object obj);

        @Override
        OfPrimitive trySplit();
    }

    public final class VivifiedWrapper implements Spliterator {
        public final java.util.Spliterator wrappedValue;

        private VivifiedWrapper(java.util.Spliterator spliterator) {
            this.wrappedValue = spliterator;
        }

        public static Spliterator convert(java.util.Spliterator spliterator) {
            if (spliterator == null) {
                return null;
            }
            if (spliterator instanceof Wrapper) {
                return Spliterator.this;
            }
            return spliterator instanceof java.util.Spliterator.OfPrimitive ? OfPrimitive.VivifiedWrapper.convert((java.util.Spliterator.OfPrimitive) spliterator) : new VivifiedWrapper(spliterator);
        }

        @Override
        public int characteristics() {
            return this.wrappedValue.characteristics();
        }

        public boolean equals(Object obj) {
            java.util.Spliterator spliterator = this.wrappedValue;
            if (obj instanceof VivifiedWrapper) {
                obj = ((VivifiedWrapper) obj).wrappedValue;
            }
            return spliterator.equals(obj);
        }

        @Override
        public long estimateSize() {
            return this.wrappedValue.estimateSize();
        }

        @Override
        public void forEachRemaining(Consumer consumer) {
            this.wrappedValue.forEachRemaining(consumer);
        }

        @Override
        public Comparator getComparator() {
            return this.wrappedValue.getComparator();
        }

        @Override
        public long getExactSizeIfKnown() {
            return this.wrappedValue.getExactSizeIfKnown();
        }

        @Override
        public boolean hasCharacteristics(int i) {
            return this.wrappedValue.hasCharacteristics(i);
        }

        public int hashCode() {
            return this.wrappedValue.hashCode();
        }

        @Override
        public boolean tryAdvance(Consumer consumer) {
            return this.wrappedValue.tryAdvance(consumer);
        }

        @Override
        public Spliterator trySplit() {
            return convert(this.wrappedValue.trySplit());
        }
    }

    public final class Wrapper implements java.util.Spliterator {
        private Wrapper() {
        }

        public static java.util.Spliterator convert(Spliterator spliterator) {
            if (spliterator == null) {
                return null;
            }
            if (spliterator instanceof VivifiedWrapper) {
                return ((VivifiedWrapper) spliterator).wrappedValue;
            }
            return spliterator instanceof OfPrimitive ? OfPrimitive.Wrapper.convert((OfPrimitive) spliterator) : new Wrapper();
        }

        @Override
        public int characteristics() {
            return Spliterator.this.characteristics();
        }

        public boolean equals(Object obj) {
            Spliterator spliterator = Spliterator.this;
            if (obj instanceof Wrapper) {
                obj = Spliterator.this;
            }
            return spliterator.equals(obj);
        }

        @Override
        public long estimateSize() {
            return Spliterator.this.estimateSize();
        }

        @Override
        public void forEachRemaining(Consumer consumer) {
            Spliterator.this.forEachRemaining(consumer);
        }

        @Override
        public Comparator getComparator() {
            return Spliterator.this.getComparator();
        }

        @Override
        public long getExactSizeIfKnown() {
            return Spliterator.this.getExactSizeIfKnown();
        }

        @Override
        public boolean hasCharacteristics(int i) {
            return Spliterator.this.hasCharacteristics(i);
        }

        public int hashCode() {
            return Spliterator.this.hashCode();
        }

        @Override
        public boolean tryAdvance(Consumer consumer) {
            return Spliterator.this.tryAdvance(consumer);
        }

        @Override
        public java.util.Spliterator trySplit() {
            return convert(Spliterator.this.trySplit());
        }
    }

    int characteristics();

    long estimateSize();

    void forEachRemaining(Consumer consumer);

    Comparator getComparator();

    long getExactSizeIfKnown();

    boolean hasCharacteristics(int i);

    boolean tryAdvance(Consumer consumer);

    Spliterator trySplit();

    public abstract class CC {
        public static void $default$forEachRemaining(Spliterator spliterator, Consumer consumer) {
            while (spliterator.tryAdvance(consumer)) {
            }
        }

        public static long $default$getExactSizeIfKnown(Spliterator spliterator) {
            if ((spliterator.characteristics() & 64) == 0) {
                return -1L;
            }
            return spliterator.estimateSize();
        }

        public static boolean $default$hasCharacteristics(Spliterator spliterator, int i) {
            return (spliterator.characteristics() & i) == i;
        }

        public static Comparator $default$getComparator(Spliterator spliterator) {
            throw new IllegalStateException();
        }
    }

    public interface OfInt extends OfPrimitive {

        public final class VivifiedWrapper implements OfInt {
            public final java.util.Spliterator.OfInt wrappedValue;

            private VivifiedWrapper(java.util.Spliterator.OfInt ofInt) {
                this.wrappedValue = ofInt;
            }

            public static OfInt convert(java.util.Spliterator.OfInt ofInt) {
                if (ofInt == null) {
                    return null;
                }
                return ofInt instanceof Wrapper ? OfInt.this : new VivifiedWrapper(ofInt);
            }

            @Override
            public int characteristics() {
                return this.wrappedValue.characteristics();
            }

            public boolean equals(Object obj) {
                java.util.Spliterator.OfInt ofInt = this.wrappedValue;
                if (obj instanceof VivifiedWrapper) {
                    obj = ((VivifiedWrapper) obj).wrappedValue;
                }
                return ofInt.equals(obj);
            }

            @Override
            public long estimateSize() {
                return this.wrappedValue.estimateSize();
            }

            @Override
            public void forEachRemaining(Object obj) {
                this.wrappedValue.forEachRemaining(obj);
            }

            @Override
            public void forEachRemaining(Consumer consumer) {
                this.wrappedValue.forEachRemaining((Consumer<? super Integer>) consumer);
            }

            @Override
            public void forEachRemaining(IntConsumer intConsumer) {
                this.wrappedValue.forEachRemaining(intConsumer);
            }

            @Override
            public Comparator getComparator() {
                return this.wrappedValue.getComparator();
            }

            @Override
            public long getExactSizeIfKnown() {
                return this.wrappedValue.getExactSizeIfKnown();
            }

            @Override
            public boolean hasCharacteristics(int i) {
                return this.wrappedValue.hasCharacteristics(i);
            }

            public int hashCode() {
                return this.wrappedValue.hashCode();
            }

            @Override
            public boolean tryAdvance(Object obj) {
                return this.wrappedValue.tryAdvance(obj);
            }

            @Override
            public boolean tryAdvance(Consumer consumer) {
                return this.wrappedValue.tryAdvance((Consumer<? super Integer>) consumer);
            }

            @Override
            public boolean tryAdvance(IntConsumer intConsumer) {
                return this.wrappedValue.tryAdvance(intConsumer);
            }

            @Override
            public OfInt trySplit() {
                return convert(this.wrappedValue.trySplit());
            }

            @Override
            public OfPrimitive trySplit() {
                return OfPrimitive.VivifiedWrapper.convert(this.wrappedValue.trySplit());
            }

            @Override
            public Spliterator trySplit() {
                return VivifiedWrapper.convert(this.wrappedValue.trySplit());
            }
        }

        public final class Wrapper implements java.util.Spliterator.OfInt {
            private Wrapper() {
            }

            public static java.util.Spliterator.OfInt convert(OfInt ofInt) {
                if (ofInt == null) {
                    return null;
                }
                return ofInt instanceof VivifiedWrapper ? ((VivifiedWrapper) ofInt).wrappedValue : ofInt.new Wrapper();
            }

            @Override
            public int characteristics() {
                return OfInt.this.characteristics();
            }

            public boolean equals(Object obj) {
                OfInt ofInt = OfInt.this;
                if (obj instanceof Wrapper) {
                    obj = OfInt.this;
                }
                return ofInt.equals(obj);
            }

            @Override
            public long estimateSize() {
                return OfInt.this.estimateSize();
            }

            @Override
            public void forEachRemaining(IntConsumer intConsumer) {
                OfInt.this.forEachRemaining((Object) intConsumer);
            }

            @Override
            public void forEachRemaining(Consumer consumer) {
                OfInt.this.forEachRemaining(consumer);
            }

            @Override
            public void forEachRemaining2(IntConsumer intConsumer) {
                OfInt.this.forEachRemaining(intConsumer);
            }

            @Override
            public Comparator getComparator() {
                return OfInt.this.getComparator();
            }

            @Override
            public long getExactSizeIfKnown() {
                return OfInt.this.getExactSizeIfKnown();
            }

            @Override
            public boolean hasCharacteristics(int i) {
                return OfInt.this.hasCharacteristics(i);
            }

            public int hashCode() {
                return OfInt.this.hashCode();
            }

            @Override
            public boolean tryAdvance(IntConsumer intConsumer) {
                return OfInt.this.tryAdvance((Object) intConsumer);
            }

            @Override
            public boolean tryAdvance(Consumer consumer) {
                return OfInt.this.tryAdvance(consumer);
            }

            @Override
            public boolean tryAdvance2(IntConsumer intConsumer) {
                return OfInt.this.tryAdvance(intConsumer);
            }

            @Override
            public java.util.Spliterator.OfInt trySplit() {
                return convert(OfInt.this.trySplit());
            }

            @Override
            public java.util.Spliterator.OfPrimitive trySplit() {
                return OfPrimitive.Wrapper.convert(OfInt.this.trySplit());
            }

            @Override
            public java.util.Spliterator trySplit() {
                return Wrapper.convert(OfInt.this.trySplit());
            }
        }

        @Override
        void forEachRemaining(Consumer consumer);

        void forEachRemaining(IntConsumer intConsumer);

        @Override
        boolean tryAdvance(Consumer consumer);

        boolean tryAdvance(IntConsumer intConsumer);

        @Override
        OfInt trySplit();

        public abstract class CC {
            public static void $default$forEachRemaining(OfInt ofInt, IntConsumer intConsumer) {
                while (ofInt.tryAdvance(intConsumer)) {
                }
            }

            public static boolean $default$tryAdvance(OfInt ofInt, Consumer consumer) {
                if (consumer instanceof IntConsumer) {
                    return ofInt.tryAdvance((IntConsumer) consumer);
                }
                if (Tripwire.ENABLED) {
                    Tripwire.trip(ofInt.getClass(), "{0} calling Spliterator.OfInt.tryAdvance((IntConsumer) action::accept)");
                }
                Objects.requireNonNull(consumer);
                return ofInt.tryAdvance((IntConsumer) new PrimitiveIterator$OfInt$$ExternalSyntheticLambda0(consumer));
            }

            public static void $default$forEachRemaining(OfInt ofInt, Consumer consumer) {
                if (consumer instanceof IntConsumer) {
                    ofInt.forEachRemaining((IntConsumer) consumer);
                    return;
                }
                if (Tripwire.ENABLED) {
                    Tripwire.trip(ofInt.getClass(), "{0} calling Spliterator.OfInt.forEachRemaining((IntConsumer) action::accept)");
                }
                Objects.requireNonNull(consumer);
                ofInt.forEachRemaining((IntConsumer) new PrimitiveIterator$OfInt$$ExternalSyntheticLambda0(consumer));
            }
        }
    }

    public interface OfLong extends OfPrimitive {

        public final class VivifiedWrapper implements OfLong {
            public final java.util.Spliterator.OfLong wrappedValue;

            private VivifiedWrapper(java.util.Spliterator.OfLong ofLong) {
                this.wrappedValue = ofLong;
            }

            public static OfLong convert(java.util.Spliterator.OfLong ofLong) {
                if (ofLong == null) {
                    return null;
                }
                return ofLong instanceof Wrapper ? OfLong.this : new VivifiedWrapper(ofLong);
            }

            @Override
            public int characteristics() {
                return this.wrappedValue.characteristics();
            }

            public boolean equals(Object obj) {
                java.util.Spliterator.OfLong ofLong = this.wrappedValue;
                if (obj instanceof VivifiedWrapper) {
                    obj = ((VivifiedWrapper) obj).wrappedValue;
                }
                return ofLong.equals(obj);
            }

            @Override
            public long estimateSize() {
                return this.wrappedValue.estimateSize();
            }

            @Override
            public void forEachRemaining(Object obj) {
                this.wrappedValue.forEachRemaining(obj);
            }

            @Override
            public void forEachRemaining(Consumer consumer) {
                this.wrappedValue.forEachRemaining((Consumer<? super Long>) consumer);
            }

            @Override
            public void forEachRemaining(LongConsumer longConsumer) {
                this.wrappedValue.forEachRemaining(longConsumer);
            }

            @Override
            public Comparator getComparator() {
                return this.wrappedValue.getComparator();
            }

            @Override
            public long getExactSizeIfKnown() {
                return this.wrappedValue.getExactSizeIfKnown();
            }

            @Override
            public boolean hasCharacteristics(int i) {
                return this.wrappedValue.hasCharacteristics(i);
            }

            public int hashCode() {
                return this.wrappedValue.hashCode();
            }

            @Override
            public boolean tryAdvance(Object obj) {
                return this.wrappedValue.tryAdvance(obj);
            }

            @Override
            public boolean tryAdvance(Consumer consumer) {
                return this.wrappedValue.tryAdvance((Consumer<? super Long>) consumer);
            }

            @Override
            public boolean tryAdvance(LongConsumer longConsumer) {
                return this.wrappedValue.tryAdvance(longConsumer);
            }

            @Override
            public OfLong trySplit() {
                return convert(this.wrappedValue.trySplit());
            }

            @Override
            public OfPrimitive trySplit() {
                return OfPrimitive.VivifiedWrapper.convert(this.wrappedValue.trySplit());
            }

            @Override
            public Spliterator trySplit() {
                return VivifiedWrapper.convert(this.wrappedValue.trySplit());
            }
        }

        public final class Wrapper implements java.util.Spliterator.OfLong {
            private Wrapper() {
            }

            public static java.util.Spliterator.OfLong convert(OfLong ofLong) {
                if (ofLong == null) {
                    return null;
                }
                return ofLong instanceof VivifiedWrapper ? ((VivifiedWrapper) ofLong).wrappedValue : ofLong.new Wrapper();
            }

            @Override
            public int characteristics() {
                return OfLong.this.characteristics();
            }

            public boolean equals(Object obj) {
                OfLong ofLong = OfLong.this;
                if (obj instanceof Wrapper) {
                    obj = OfLong.this;
                }
                return ofLong.equals(obj);
            }

            @Override
            public long estimateSize() {
                return OfLong.this.estimateSize();
            }

            @Override
            public void forEachRemaining(LongConsumer longConsumer) {
                OfLong.this.forEachRemaining((Object) longConsumer);
            }

            @Override
            public void forEachRemaining(Consumer consumer) {
                OfLong.this.forEachRemaining(consumer);
            }

            @Override
            public void forEachRemaining2(LongConsumer longConsumer) {
                OfLong.this.forEachRemaining(longConsumer);
            }

            @Override
            public Comparator getComparator() {
                return OfLong.this.getComparator();
            }

            @Override
            public long getExactSizeIfKnown() {
                return OfLong.this.getExactSizeIfKnown();
            }

            @Override
            public boolean hasCharacteristics(int i) {
                return OfLong.this.hasCharacteristics(i);
            }

            public int hashCode() {
                return OfLong.this.hashCode();
            }

            @Override
            public boolean tryAdvance(LongConsumer longConsumer) {
                return OfLong.this.tryAdvance((Object) longConsumer);
            }

            @Override
            public boolean tryAdvance(Consumer consumer) {
                return OfLong.this.tryAdvance(consumer);
            }

            @Override
            public boolean tryAdvance2(LongConsumer longConsumer) {
                return OfLong.this.tryAdvance(longConsumer);
            }

            @Override
            public java.util.Spliterator.OfLong trySplit() {
                return convert(OfLong.this.trySplit());
            }

            @Override
            public java.util.Spliterator.OfPrimitive trySplit() {
                return OfPrimitive.Wrapper.convert(OfLong.this.trySplit());
            }

            @Override
            public java.util.Spliterator trySplit() {
                return Wrapper.convert(OfLong.this.trySplit());
            }
        }

        @Override
        void forEachRemaining(Consumer consumer);

        void forEachRemaining(LongConsumer longConsumer);

        @Override
        boolean tryAdvance(Consumer consumer);

        boolean tryAdvance(LongConsumer longConsumer);

        @Override
        OfLong trySplit();

        public abstract class CC {
            public static void $default$forEachRemaining(OfLong ofLong, LongConsumer longConsumer) {
                while (ofLong.tryAdvance(longConsumer)) {
                }
            }

            public static boolean $default$tryAdvance(OfLong ofLong, Consumer consumer) {
                if (consumer instanceof LongConsumer) {
                    return ofLong.tryAdvance((LongConsumer) consumer);
                }
                if (Tripwire.ENABLED) {
                    Tripwire.trip(ofLong.getClass(), "{0} calling Spliterator.OfLong.tryAdvance((LongConsumer) action::accept)");
                }
                Objects.requireNonNull(consumer);
                return ofLong.tryAdvance((LongConsumer) new PrimitiveIterator$OfLong$$ExternalSyntheticLambda0(consumer));
            }

            public static void $default$forEachRemaining(OfLong ofLong, Consumer consumer) {
                if (consumer instanceof LongConsumer) {
                    ofLong.forEachRemaining((LongConsumer) consumer);
                    return;
                }
                if (Tripwire.ENABLED) {
                    Tripwire.trip(ofLong.getClass(), "{0} calling Spliterator.OfLong.forEachRemaining((LongConsumer) action::accept)");
                }
                Objects.requireNonNull(consumer);
                ofLong.forEachRemaining((LongConsumer) new PrimitiveIterator$OfLong$$ExternalSyntheticLambda0(consumer));
            }
        }
    }

    public interface OfDouble extends OfPrimitive {

        public final class VivifiedWrapper implements OfDouble {
            public final java.util.Spliterator.OfDouble wrappedValue;

            private VivifiedWrapper(java.util.Spliterator.OfDouble ofDouble) {
                this.wrappedValue = ofDouble;
            }

            public static OfDouble convert(java.util.Spliterator.OfDouble ofDouble) {
                if (ofDouble == null) {
                    return null;
                }
                return ofDouble instanceof Wrapper ? OfDouble.this : new VivifiedWrapper(ofDouble);
            }

            @Override
            public int characteristics() {
                return this.wrappedValue.characteristics();
            }

            public boolean equals(Object obj) {
                java.util.Spliterator.OfDouble ofDouble = this.wrappedValue;
                if (obj instanceof VivifiedWrapper) {
                    obj = ((VivifiedWrapper) obj).wrappedValue;
                }
                return ofDouble.equals(obj);
            }

            @Override
            public long estimateSize() {
                return this.wrappedValue.estimateSize();
            }

            @Override
            public void forEachRemaining(Object obj) {
                this.wrappedValue.forEachRemaining(obj);
            }

            @Override
            public void forEachRemaining(Consumer consumer) {
                this.wrappedValue.forEachRemaining((Consumer<? super Double>) consumer);
            }

            @Override
            public void forEachRemaining(DoubleConsumer doubleConsumer) {
                this.wrappedValue.forEachRemaining(doubleConsumer);
            }

            @Override
            public Comparator getComparator() {
                return this.wrappedValue.getComparator();
            }

            @Override
            public long getExactSizeIfKnown() {
                return this.wrappedValue.getExactSizeIfKnown();
            }

            @Override
            public boolean hasCharacteristics(int i) {
                return this.wrappedValue.hasCharacteristics(i);
            }

            public int hashCode() {
                return this.wrappedValue.hashCode();
            }

            @Override
            public boolean tryAdvance(Object obj) {
                return this.wrappedValue.tryAdvance(obj);
            }

            @Override
            public boolean tryAdvance(Consumer consumer) {
                return this.wrappedValue.tryAdvance((Consumer<? super Double>) consumer);
            }

            @Override
            public boolean tryAdvance(DoubleConsumer doubleConsumer) {
                return this.wrappedValue.tryAdvance(doubleConsumer);
            }

            @Override
            public OfDouble trySplit() {
                return convert(this.wrappedValue.trySplit());
            }

            @Override
            public OfPrimitive trySplit() {
                return OfPrimitive.VivifiedWrapper.convert(this.wrappedValue.trySplit());
            }

            @Override
            public Spliterator trySplit() {
                return VivifiedWrapper.convert(this.wrappedValue.trySplit());
            }
        }

        public final class Wrapper implements java.util.Spliterator.OfDouble {
            private Wrapper() {
            }

            public static java.util.Spliterator.OfDouble convert(OfDouble ofDouble) {
                if (ofDouble == null) {
                    return null;
                }
                return ofDouble instanceof VivifiedWrapper ? ((VivifiedWrapper) ofDouble).wrappedValue : ofDouble.new Wrapper();
            }

            @Override
            public int characteristics() {
                return OfDouble.this.characteristics();
            }

            public boolean equals(Object obj) {
                OfDouble ofDouble = OfDouble.this;
                if (obj instanceof Wrapper) {
                    obj = OfDouble.this;
                }
                return ofDouble.equals(obj);
            }

            @Override
            public long estimateSize() {
                return OfDouble.this.estimateSize();
            }

            @Override
            public void forEachRemaining(DoubleConsumer doubleConsumer) {
                OfDouble.this.forEachRemaining((Object) doubleConsumer);
            }

            @Override
            public void forEachRemaining(Consumer consumer) {
                OfDouble.this.forEachRemaining(consumer);
            }

            @Override
            public void forEachRemaining2(DoubleConsumer doubleConsumer) {
                OfDouble.this.forEachRemaining(doubleConsumer);
            }

            @Override
            public Comparator getComparator() {
                return OfDouble.this.getComparator();
            }

            @Override
            public long getExactSizeIfKnown() {
                return OfDouble.this.getExactSizeIfKnown();
            }

            @Override
            public boolean hasCharacteristics(int i) {
                return OfDouble.this.hasCharacteristics(i);
            }

            public int hashCode() {
                return OfDouble.this.hashCode();
            }

            @Override
            public boolean tryAdvance(DoubleConsumer doubleConsumer) {
                return OfDouble.this.tryAdvance((Object) doubleConsumer);
            }

            @Override
            public boolean tryAdvance(Consumer consumer) {
                return OfDouble.this.tryAdvance(consumer);
            }

            @Override
            public boolean tryAdvance2(DoubleConsumer doubleConsumer) {
                return OfDouble.this.tryAdvance(doubleConsumer);
            }

            @Override
            public java.util.Spliterator.OfDouble trySplit() {
                return convert(OfDouble.this.trySplit());
            }

            @Override
            public java.util.Spliterator.OfPrimitive trySplit() {
                return OfPrimitive.Wrapper.convert(OfDouble.this.trySplit());
            }

            @Override
            public java.util.Spliterator trySplit() {
                return Wrapper.convert(OfDouble.this.trySplit());
            }
        }

        @Override
        void forEachRemaining(Consumer consumer);

        void forEachRemaining(DoubleConsumer doubleConsumer);

        @Override
        boolean tryAdvance(Consumer consumer);

        boolean tryAdvance(DoubleConsumer doubleConsumer);

        @Override
        OfDouble trySplit();

        public abstract class CC {
            public static void $default$forEachRemaining(OfDouble ofDouble, DoubleConsumer doubleConsumer) {
                while (ofDouble.tryAdvance(doubleConsumer)) {
                }
            }

            public static boolean $default$tryAdvance(OfDouble ofDouble, Consumer consumer) {
                if (consumer instanceof DoubleConsumer) {
                    return ofDouble.tryAdvance((DoubleConsumer) consumer);
                }
                if (Tripwire.ENABLED) {
                    Tripwire.trip(ofDouble.getClass(), "{0} calling Spliterator.OfDouble.tryAdvance((DoubleConsumer) action::accept)");
                }
                Objects.requireNonNull(consumer);
                return ofDouble.tryAdvance((DoubleConsumer) new PrimitiveIterator$OfDouble$$ExternalSyntheticLambda0(consumer));
            }

            public static void $default$forEachRemaining(OfDouble ofDouble, Consumer consumer) {
                if (consumer instanceof DoubleConsumer) {
                    ofDouble.forEachRemaining((DoubleConsumer) consumer);
                    return;
                }
                if (Tripwire.ENABLED) {
                    Tripwire.trip(ofDouble.getClass(), "{0} calling Spliterator.OfDouble.forEachRemaining((DoubleConsumer) action::accept)");
                }
                Objects.requireNonNull(consumer);
                ofDouble.forEachRemaining((DoubleConsumer) new PrimitiveIterator$OfDouble$$ExternalSyntheticLambda0(consumer));
            }
        }
    }
}
