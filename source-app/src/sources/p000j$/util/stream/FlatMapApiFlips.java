package p000j$.util.stream;

import java.util.function.DoubleFunction;
import java.util.function.Function;
import java.util.function.IntFunction;
import java.util.function.LongFunction;
import java.util.stream.DoubleStream;
import java.util.stream.IntStream;
import java.util.stream.LongStream;
import java.util.stream.Stream;
import p000j$.util.ConversionRuntimeException;
import p000j$.util.function.Function$CC;

public abstract class FlatMapApiFlips {
    public static Function flipFunctionReturningStream(Function function) {
        return new FunctionStreamWrapper(function);
    }

    public static IntFunction flipFunctionReturningStream(IntFunction intFunction) {
        return new IntFunctionStreamWrapper(intFunction);
    }

    public static DoubleFunction flipFunctionReturningStream(DoubleFunction doubleFunction) {
        return new DoubleFunctionStreamWrapper(doubleFunction);
    }

    public static LongFunction flipFunctionReturningStream(LongFunction longFunction) {
        return new LongFunctionStreamWrapper(longFunction);
    }

    public static class FunctionStreamWrapper implements Function {
        public Function function;

        public Function andThen(Function function) {
            return Function$CC.$default$andThen(this, function);
        }

        public Function compose(Function function) {
            return Function$CC.$default$compose(this, function);
        }

        public FunctionStreamWrapper(Function function) {
            this.function = function;
        }

        private Object flipStream(Object obj) {
            if (obj == null) {
                return null;
            }
            if (obj instanceof Stream) {
                return Stream.Wrapper.convert((Stream) obj);
            }
            if (obj instanceof Stream) {
                return Stream.VivifiedWrapper.convert((Stream) obj);
            }
            if (obj instanceof IntStream) {
                return IntStream.Wrapper.convert((IntStream) obj);
            }
            if (obj instanceof IntStream) {
                return IntStream.VivifiedWrapper.convert((IntStream) obj);
            }
            if (obj instanceof DoubleStream) {
                return DoubleStream.Wrapper.convert((DoubleStream) obj);
            }
            if (obj instanceof DoubleStream) {
                return DoubleStream.VivifiedWrapper.convert((DoubleStream) obj);
            }
            if (obj instanceof LongStream) {
                return LongStream.Wrapper.convert((LongStream) obj);
            }
            if (obj instanceof LongStream) {
                return LongStream.VivifiedWrapper.convert((LongStream) obj);
            }
            throw ConversionRuntimeException.exception("java.util.stream.*Stream", obj.getClass());
        }

        @Override
        public Object apply(Object obj) {
            return flipStream(this.function.apply(obj));
        }
    }

    public static class IntFunctionStreamWrapper implements IntFunction {
        public IntFunction function;

        public IntFunctionStreamWrapper(IntFunction intFunction) {
            this.function = intFunction;
        }

        private Object flipStream(Object obj) {
            if (obj == null) {
                return null;
            }
            if (obj instanceof IntStream) {
                return IntStream.Wrapper.convert((IntStream) obj);
            }
            if (obj instanceof IntStream) {
                return IntStream.VivifiedWrapper.convert((IntStream) obj);
            }
            throw ConversionRuntimeException.exception("java.util.stream.IntStream", obj.getClass());
        }

        @Override
        public Object apply(int i) {
            return flipStream(this.function.apply(i));
        }
    }

    public static class DoubleFunctionStreamWrapper implements DoubleFunction {
        public DoubleFunction function;

        public DoubleFunctionStreamWrapper(DoubleFunction doubleFunction) {
            this.function = doubleFunction;
        }

        private Object flipStream(Object obj) {
            if (obj == null) {
                return null;
            }
            if (obj instanceof DoubleStream) {
                return DoubleStream.Wrapper.convert((DoubleStream) obj);
            }
            if (obj instanceof DoubleStream) {
                return DoubleStream.VivifiedWrapper.convert((DoubleStream) obj);
            }
            throw ConversionRuntimeException.exception("java.util.stream.DoubleStream", obj.getClass());
        }

        @Override
        public Object apply(double d) {
            return flipStream(this.function.apply(d));
        }
    }

    public static class LongFunctionStreamWrapper implements LongFunction {
        public LongFunction function;

        public LongFunctionStreamWrapper(LongFunction longFunction) {
            this.function = longFunction;
        }

        private Object flipStream(Object obj) {
            if (obj == null) {
                return null;
            }
            if (obj instanceof LongStream) {
                return LongStream.Wrapper.convert((LongStream) obj);
            }
            if (obj instanceof LongStream) {
                return LongStream.VivifiedWrapper.convert((LongStream) obj);
            }
            throw ConversionRuntimeException.exception("java.util.stream.LongStream", obj.getClass());
        }

        @Override
        public Object apply(long j) {
            return flipStream(this.function.apply(j));
        }
    }
}
