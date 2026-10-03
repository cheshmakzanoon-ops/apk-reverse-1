package androidx.core.util;

import j$.util.Objects;

public interface Predicate<T> {
    Predicate<T> and(Predicate<? super T> predicate);

    Predicate<T> negate();

    Predicate<T> mo76or(Predicate<? super T> predicate);

    boolean test(T t);

    public final class CC {
        public static Predicate $default$and(final Predicate _this, final Predicate predicate) {
            Objects.requireNonNull(predicate);
            return new Predicate() {
                @Override
                public Predicate and(Predicate predicate2) {
                    return Predicate.CC.$default$and(this, predicate2);
                }

                @Override
                public Predicate negate() {
                    return Predicate.CC.$default$negate(this);
                }

                @Override
                public Predicate mo76or(Predicate predicate2) {
                    return Predicate.CC.$default$or(this, predicate2);
                }

                @Override
                public final boolean test(Object obj) {
                    return Predicate.CC.$private$lambda$and$0(_this, predicate, obj);
                }
            };
        }

        public static boolean $private$lambda$and$0(Predicate _this, Predicate predicate, Object obj) {
            return _this.test(obj) && predicate.test(obj);
        }

        public static Predicate $default$negate(final Predicate _this) {
            return new Predicate() {
                @Override
                public Predicate and(Predicate predicate) {
                    return Predicate.CC.$default$and(this, predicate);
                }

                @Override
                public Predicate negate() {
                    return Predicate.CC.$default$negate(this);
                }

                @Override
                public Predicate mo76or(Predicate predicate) {
                    return Predicate.CC.$default$or(this, predicate);
                }

                @Override
                public final boolean test(Object obj) {
                    return Predicate.CC.$private$lambda$negate$1(_this, obj);
                }
            };
        }

        public static boolean $private$lambda$negate$1(Predicate _this, Object obj) {
            return !_this.test(obj);
        }

        public static Predicate $default$or(final Predicate _this, final Predicate predicate) {
            Objects.requireNonNull(predicate);
            return new Predicate() {
                @Override
                public Predicate and(Predicate predicate2) {
                    return Predicate.CC.$default$and(this, predicate2);
                }

                @Override
                public Predicate negate() {
                    return Predicate.CC.$default$negate(this);
                }

                @Override
                public Predicate mo76or(Predicate predicate2) {
                    return Predicate.CC.$default$or(this, predicate2);
                }

                @Override
                public final boolean test(Object obj) {
                    return Predicate.CC.$private$lambda$or$2(_this, predicate, obj);
                }
            };
        }

        public static boolean $private$lambda$or$2(Predicate _this, Predicate predicate, Object obj) {
            return _this.test(obj) || predicate.test(obj);
        }

        public static <T> Predicate<T> isEqual(final Object obj) {
            return obj == null ? new Predicate() {
                @Override
                public Predicate and(Predicate predicate) {
                    return Predicate.CC.$default$and(this, predicate);
                }

                @Override
                public Predicate negate() {
                    return Predicate.CC.$default$negate(this);
                }

                @Override
                public Predicate mo76or(Predicate predicate) {
                    return Predicate.CC.$default$or(this, predicate);
                }

                @Override
                public final boolean test(Object obj2) {
                    return Objects.isNull(obj2);
                }
            } : new Predicate() {
                @Override
                public Predicate and(Predicate predicate) {
                    return Predicate.CC.$default$and(this, predicate);
                }

                @Override
                public Predicate negate() {
                    return Predicate.CC.$default$negate(this);
                }

                @Override
                public Predicate mo76or(Predicate predicate) {
                    return Predicate.CC.$default$or(this, predicate);
                }

                @Override
                public final boolean test(Object obj2) {
                    return obj.equals(obj2);
                }
            };
        }

        public static <T> Predicate<T> not(Predicate<? super T> predicate) {
            Objects.requireNonNull(predicate);
            return predicate.negate();
        }
    }
}
