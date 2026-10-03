package p000j$.util.stream;

import java.util.Iterator;
import java.util.stream.DoubleStream;
import java.util.stream.IntStream;
import java.util.stream.LongStream;
import java.util.stream.Stream;
import p000j$.util.Spliterator;
import p000j$.util.stream.BaseStream;

public interface BaseStream<T, S extends BaseStream<T, S>> extends AutoCloseable {

    public final class VivifiedWrapper implements BaseStream {
        public final java.util.stream.BaseStream wrappedValue;

        private VivifiedWrapper(java.util.stream.BaseStream baseStream) {
            this.wrappedValue = baseStream;
        }

        public static BaseStream convert(java.util.stream.BaseStream baseStream) {
            if (baseStream == null) {
                return null;
            }
            if (baseStream instanceof Wrapper) {
                return BaseStream.this;
            }
            if (baseStream instanceof DoubleStream) {
                return DoubleStream.VivifiedWrapper.convert((DoubleStream) baseStream);
            }
            if (baseStream instanceof IntStream) {
                return IntStream.VivifiedWrapper.convert((IntStream) baseStream);
            }
            if (baseStream instanceof LongStream) {
                return LongStream.VivifiedWrapper.convert((LongStream) baseStream);
            }
            return baseStream instanceof Stream ? Stream.VivifiedWrapper.convert((Stream) baseStream) : new VivifiedWrapper(baseStream);
        }

        @Override
        public void close() {
            this.wrappedValue.close();
        }

        public boolean equals(Object obj) {
            java.util.stream.BaseStream baseStream = this.wrappedValue;
            if (obj instanceof VivifiedWrapper) {
                obj = ((VivifiedWrapper) obj).wrappedValue;
            }
            return baseStream.equals(obj);
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
        public BaseStream onClose(Runnable runnable) {
            return convert(this.wrappedValue.onClose(runnable));
        }

        @Override
        public BaseStream parallel() {
            return convert(this.wrappedValue.parallel());
        }

        @Override
        public BaseStream sequential() {
            return convert(this.wrappedValue.sequential());
        }

        @Override
        public Spliterator spliterator() {
            return Spliterator.VivifiedWrapper.convert(this.wrappedValue.spliterator());
        }

        @Override
        public BaseStream unordered() {
            return convert(this.wrappedValue.unordered());
        }
    }

    public final class Wrapper implements java.util.stream.BaseStream {
        private Wrapper() {
        }

        public static java.util.stream.BaseStream convert(BaseStream baseStream) {
            if (baseStream == null) {
                return null;
            }
            if (baseStream instanceof VivifiedWrapper) {
                return ((VivifiedWrapper) baseStream).wrappedValue;
            }
            if (baseStream instanceof DoubleStream) {
                return DoubleStream.Wrapper.convert((DoubleStream) baseStream);
            }
            if (baseStream instanceof IntStream) {
                return IntStream.Wrapper.convert((IntStream) baseStream);
            }
            if (baseStream instanceof LongStream) {
                return LongStream.Wrapper.convert((LongStream) baseStream);
            }
            return baseStream instanceof Stream ? Stream.Wrapper.convert((Stream) baseStream) : new Wrapper();
        }

        @Override
        public void close() {
            BaseStream.this.close();
        }

        public boolean equals(Object obj) {
            BaseStream baseStream = BaseStream.this;
            if (obj instanceof Wrapper) {
                obj = BaseStream.this;
            }
            return baseStream.equals(obj);
        }

        public int hashCode() {
            return BaseStream.this.hashCode();
        }

        @Override
        public boolean isParallel() {
            return BaseStream.this.isParallel();
        }

        @Override
        public Iterator iterator() {
            return BaseStream.this.iterator();
        }

        @Override
        public java.util.stream.BaseStream onClose(Runnable runnable) {
            return convert(BaseStream.this.onClose(runnable));
        }

        @Override
        public java.util.stream.BaseStream parallel() {
            return convert(BaseStream.this.parallel());
        }

        @Override
        public java.util.stream.BaseStream sequential() {
            return convert(BaseStream.this.sequential());
        }

        @Override
        public java.util.Spliterator spliterator() {
            return Spliterator.Wrapper.convert(BaseStream.this.spliterator());
        }

        @Override
        public java.util.stream.BaseStream unordered() {
            return convert(BaseStream.this.unordered());
        }
    }

    @Override
    void close();

    boolean isParallel();

    Iterator<T> iterator();

    BaseStream onClose(Runnable runnable);

    BaseStream parallel();

    BaseStream sequential();

    Spliterator spliterator();

    BaseStream unordered();
}
