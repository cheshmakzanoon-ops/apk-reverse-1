package coil.util;

import androidx.constraintlayout.widget.ConstraintLayout;
import kotlin.Metadata;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.FunctionReferenceImpl;

@Metadata(d1 = {"\u0000 \n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\t\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0002\bÀ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0006\u0010\u0006\u001a\u00020\u0005J\u0006\u0010\u0007\u001a\u00020\bJ\u000e\u0010\t\u001a\u00020\b2\u0006\u0010\u0006\u001a\u00020\u0005R\u0014\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\n"}, d2 = {"Lcoil/util/Time;", "", "()V", "provider", "Lkotlin/Function0;", "", "currentMillis", "reset", "", "setCurrentMillis", "coil-base_release"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class Time {
    public static final Time INSTANCE = new Time();
    private static Function0<Long> provider = Time$provider$1.INSTANCE;

    private Time() {
    }

    public final long currentMillis() {
        return ((Number) provider.invoke()).longValue();
    }

    public final void setCurrentMillis(final long currentMillis) {
        provider = new Function0<Long>() {
            {
                super(0);
            }

            public final Long m2332invoke() {
                return Long.valueOf(currentMillis);
            }
        };
    }

    @Metadata(k = 3, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    class C08141 extends FunctionReferenceImpl implements Function0<Long> {
        public static final C08141 INSTANCE = new C08141();

        C08141() {
            super(0, System.class, "currentTimeMillis", "currentTimeMillis()J", 0);
        }

        public final Long m2331invoke() {
            return Long.valueOf(System.currentTimeMillis());
        }
    }

    public final void reset() {
        provider = C08141.INSTANCE;
    }
}
