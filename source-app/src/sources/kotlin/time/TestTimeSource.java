package kotlin.time;

import kotlin.Metadata;
import kotlin.jvm.internal.LongCompanionObject;

@Metadata(m17d1 = {"\u0000 \n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\t\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\b\u0007\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J\u001a\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\bH\u0002ø\u0001\u0000¢\u0006\u0004\b\t\u0010\nJ\u001b\u0010\u000b\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\bH\u0086\u0002ø\u0001\u0000¢\u0006\u0004\b\f\u0010\nJ\b\u0010\r\u001a\u00020\u0004H\u0014R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082\u000e¢\u0006\u0002\n\u0000\u0082\u0002\u0004\n\u0002\b\u0019¨\u0006\u000e"}, m18d2 = {"Lkotlin/time/TestTimeSource;", "Lkotlin/time/AbstractLongTimeSource;", "()V", "reading", "", "overflow", "", "duration", "Lkotlin/time/Duration;", "overflow-LRDsOJo", "(J)V", "plusAssign", "plusAssign-LRDsOJo", "read", "kotlin-stdlib"}, m19k = 1, m20mv = {1, 8, 0}, m22xi = 48)
public final class TestTimeSource extends AbstractLongTimeSource {
    private long reading;

    public TestTimeSource() {
        super(DurationUnit.NANOSECONDS);
    }

    @Override
    protected long getReading() {
        return this.reading;
    }

    public final void m1766plusAssignLRDsOJo(long duration) {
        long j;
        long jM1677toLongimpl = Duration.m1677toLongimpl(duration, getUnit());
        if (jM1677toLongimpl != Long.MIN_VALUE && jM1677toLongimpl != LongCompanionObject.MAX_VALUE) {
            long j2 = this.reading;
            j = j2 + jM1677toLongimpl;
            if ((jM1677toLongimpl ^ j2) >= 0 && (j2 ^ j) < 0) {
                m1765overflowLRDsOJo(duration);
            }
        } else {
            double dM1674toDoubleimpl = this.reading + Duration.m1674toDoubleimpl(duration, getUnit());
            if (dM1674toDoubleimpl > 9.223372036854776E18d || dM1674toDoubleimpl < -9.223372036854776E18d) {
                m1765overflowLRDsOJo(duration);
            }
            j = (long) dM1674toDoubleimpl;
        }
        this.reading = j;
    }

    private final void m1765overflowLRDsOJo(long duration) {
        throw new IllegalStateException("TestTimeSource will overflow if its reading " + this.reading + DurationUnitKt.shortName(getUnit()) + " is advanced by " + ((Object) Duration.m1680toStringimpl(duration)) + '.');
    }
}
