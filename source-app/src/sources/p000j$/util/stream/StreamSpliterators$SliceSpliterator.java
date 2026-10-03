package p000j$.util.stream;

import java.util.Comparator;
import java.util.function.Consumer;
import java.util.function.DoubleConsumer;
import java.util.function.IntConsumer;
import java.util.function.LongConsumer;
import p000j$.util.Objects;
import p000j$.util.Spliterator;
import p000j$.util.function.Consumer$CC;
import p000j$.util.function.DoubleConsumer$CC;
import p000j$.util.function.IntConsumer$CC;
import p000j$.util.function.LongConsumer$CC;

abstract class StreamSpliterators$SliceSpliterator {
    long fence;
    long index;

    Spliterator f1403s;
    final long sliceFence;
    final long sliceOrigin;

    protected abstract Spliterator makeSpliterator(Spliterator spliterator, long j, long j2, long j3, long j4);

    StreamSpliterators$SliceSpliterator(Spliterator spliterator, long j, long j2, long j3, long j4) {
        this.f1403s = spliterator;
        this.sliceOrigin = j;
        this.sliceFence = j2;
        this.index = j3;
        this.fence = j4;
    }

    public Spliterator trySplit() {
        long j = this.sliceOrigin;
        long j2 = this.fence;
        if (j >= j2 || this.index >= j2) {
            return null;
        }
        while (true) {
            Spliterator spliteratorTrySplit = this.f1403s.trySplit();
            if (spliteratorTrySplit == null) {
                return null;
            }
            long jEstimateSize = this.index + spliteratorTrySplit.estimateSize();
            long jMin = Math.min(jEstimateSize, this.sliceFence);
            long j3 = this.sliceOrigin;
            if (j3 >= jMin) {
                this.index = jMin;
            } else {
                long j4 = this.sliceFence;
                if (jMin >= j4) {
                    this.f1403s = spliteratorTrySplit;
                    this.fence = jMin;
                } else {
                    long j5 = this.index;
                    if (j5 >= j3 && jEstimateSize <= j4) {
                        this.index = jMin;
                        return spliteratorTrySplit;
                    }
                    this.index = jMin;
                    return makeSpliterator(spliteratorTrySplit, j3, j4, j5, jMin);
                }
            }
        }
    }

    public long estimateSize() {
        long j = this.sliceOrigin;
        long j2 = this.fence;
        if (j < j2) {
            return j2 - Math.max(j, this.index);
        }
        return 0L;
    }

    public int characteristics() {
        return this.f1403s.characteristics();
    }

    static final class OfRef extends StreamSpliterators$SliceSpliterator implements Spliterator {
        static void lambda$forEachRemaining$1(Object obj) {
        }

        static void lambda$tryAdvance$0(Object obj) {
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

        OfRef(Spliterator spliterator, long j, long j2) {
            this(spliterator, j, j2, 0L, Math.min(spliterator.estimateSize(), j2));
        }

        private OfRef(Spliterator spliterator, long j, long j2, long j3, long j4) {
            super(spliterator, j, j2, j3, j4);
        }

        @Override
        protected Spliterator makeSpliterator(Spliterator spliterator, long j, long j2, long j3, long j4) {
            return new OfRef(spliterator, j, j2, j3, j4);
        }

        @Override
        public boolean tryAdvance(Consumer consumer) {
            long j;
            Objects.requireNonNull(consumer);
            if (this.sliceOrigin >= this.fence) {
                return false;
            }
            while (true) {
                long j2 = this.sliceOrigin;
                j = this.index;
                if (j2 <= j) {
                    break;
                }
                this.f1403s.tryAdvance(new Consumer() {
                    @Override
                    public final void accept(Object obj) {
                        StreamSpliterators$SliceSpliterator.OfRef.lambda$tryAdvance$0(obj);
                    }

                    public Consumer andThen(Consumer consumer2) {
                        return Consumer$CC.$default$andThen(this, consumer2);
                    }
                });
                this.index++;
            }
            if (j >= this.fence) {
                return false;
            }
            this.index = j + 1;
            return this.f1403s.tryAdvance(consumer);
        }

        @Override
        public void forEachRemaining(Consumer consumer) {
            Objects.requireNonNull(consumer);
            long j = this.sliceOrigin;
            long j2 = this.fence;
            if (j >= j2) {
                return;
            }
            long j3 = this.index;
            if (j3 >= j2) {
                return;
            }
            if (j3 >= j && j3 + this.f1403s.estimateSize() <= this.sliceFence) {
                this.f1403s.forEachRemaining(consumer);
                this.index = this.fence;
                return;
            }
            while (this.sliceOrigin > this.index) {
                this.f1403s.tryAdvance(new Consumer() {
                    @Override
                    public final void accept(Object obj) {
                        StreamSpliterators$SliceSpliterator.OfRef.lambda$forEachRemaining$1(obj);
                    }

                    public Consumer andThen(Consumer consumer2) {
                        return Consumer$CC.$default$andThen(this, consumer2);
                    }
                });
                this.index++;
            }
            while (this.index < this.fence) {
                this.f1403s.tryAdvance(consumer);
                this.index++;
            }
        }
    }

    static abstract class OfPrimitive extends StreamSpliterators$SliceSpliterator implements Spliterator.OfPrimitive {
        protected abstract Object emptyConsumer();

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

        @Override
        public Spliterator.OfPrimitive trySplit() {
            return (Spliterator.OfPrimitive) super.trySplit();
        }

        OfPrimitive(Spliterator.OfPrimitive ofPrimitive, long j, long j2) {
            this(ofPrimitive, j, j2, 0L, Math.min(ofPrimitive.estimateSize(), j2));
        }

        private OfPrimitive(Spliterator.OfPrimitive ofPrimitive, long j, long j2, long j3, long j4) {
            super(ofPrimitive, j, j2, j3, j4);
        }

        @Override
        public boolean tryAdvance(Object obj) {
            long j;
            Objects.requireNonNull(obj);
            if (this.sliceOrigin >= this.fence) {
                return false;
            }
            while (true) {
                long j2 = this.sliceOrigin;
                j = this.index;
                if (j2 <= j) {
                    break;
                }
                ((Spliterator.OfPrimitive) this.f1403s).tryAdvance(emptyConsumer());
                this.index++;
            }
            if (j >= this.fence) {
                return false;
            }
            this.index = j + 1;
            return ((Spliterator.OfPrimitive) this.f1403s).tryAdvance(obj);
        }

        @Override
        public void forEachRemaining(Object obj) {
            Objects.requireNonNull(obj);
            long j = this.sliceOrigin;
            long j2 = this.fence;
            if (j >= j2) {
                return;
            }
            long j3 = this.index;
            if (j3 >= j2) {
                return;
            }
            if (j3 >= j && j3 + ((Spliterator.OfPrimitive) this.f1403s).estimateSize() <= this.sliceFence) {
                ((Spliterator.OfPrimitive) this.f1403s).forEachRemaining(obj);
                this.index = this.fence;
                return;
            }
            while (this.sliceOrigin > this.index) {
                ((Spliterator.OfPrimitive) this.f1403s).tryAdvance(emptyConsumer());
                this.index++;
            }
            while (this.index < this.fence) {
                ((Spliterator.OfPrimitive) this.f1403s).tryAdvance(obj);
                this.index++;
            }
        }
    }

    static final class OfInt extends OfPrimitive implements Spliterator.OfInt {
        static void lambda$emptyConsumer$0(int i) {
        }

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

        OfInt(Spliterator.OfInt ofInt, long j, long j2) {
            super(ofInt, j, j2);
        }

        OfInt(Spliterator.OfInt ofInt, long j, long j2, long j3, long j4) {
            super(ofInt, j, j2, j3, j4);
        }

        @Override
        public Spliterator.OfInt makeSpliterator(Spliterator.OfInt ofInt, long j, long j2, long j3, long j4) {
            return new OfInt(ofInt, j, j2, j3, j4);
        }

        @Override
        public IntConsumer emptyConsumer() {
            return new IntConsumer() {
                @Override
                public final void accept(int i) {
                    StreamSpliterators$SliceSpliterator.OfInt.lambda$emptyConsumer$0(i);
                }

                public IntConsumer andThen(IntConsumer intConsumer) {
                    return IntConsumer$CC.$default$andThen(this, intConsumer);
                }
            };
        }
    }

    static final class OfLong extends OfPrimitive implements Spliterator.OfLong {
        static void lambda$emptyConsumer$0(long j) {
        }

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

        OfLong(Spliterator.OfLong ofLong, long j, long j2) {
            super(ofLong, j, j2);
        }

        OfLong(Spliterator.OfLong ofLong, long j, long j2, long j3, long j4) {
            super(ofLong, j, j2, j3, j4);
        }

        @Override
        public Spliterator.OfLong makeSpliterator(Spliterator.OfLong ofLong, long j, long j2, long j3, long j4) {
            return new OfLong(ofLong, j, j2, j3, j4);
        }

        @Override
        public LongConsumer emptyConsumer() {
            return new LongConsumer() {
                @Override
                public final void accept(long j) {
                    StreamSpliterators$SliceSpliterator.OfLong.lambda$emptyConsumer$0(j);
                }

                public LongConsumer andThen(LongConsumer longConsumer) {
                    return LongConsumer$CC.$default$andThen(this, longConsumer);
                }
            };
        }
    }

    static final class OfDouble extends OfPrimitive implements Spliterator.OfDouble {
        static void lambda$emptyConsumer$0(double d) {
        }

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

        OfDouble(Spliterator.OfDouble ofDouble, long j, long j2) {
            super(ofDouble, j, j2);
        }

        OfDouble(Spliterator.OfDouble ofDouble, long j, long j2, long j3, long j4) {
            super(ofDouble, j, j2, j3, j4);
        }

        @Override
        public Spliterator.OfDouble makeSpliterator(Spliterator.OfDouble ofDouble, long j, long j2, long j3, long j4) {
            return new OfDouble(ofDouble, j, j2, j3, j4);
        }

        @Override
        public DoubleConsumer emptyConsumer() {
            return new DoubleConsumer() {
                @Override
                public final void accept(double d) {
                    StreamSpliterators$SliceSpliterator.OfDouble.lambda$emptyConsumer$0(d);
                }

                public DoubleConsumer andThen(DoubleConsumer doubleConsumer) {
                    return DoubleConsumer$CC.$default$andThen(this, doubleConsumer);
                }
            };
        }
    }
}
