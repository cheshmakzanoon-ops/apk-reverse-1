package p000j$.time.temporal;

import p000j$.time.DayOfWeek;

public abstract class TemporalAdjusters {
    static Temporal lambda$lastDayOfMonth$2(Temporal temporal) {
        ChronoField chronoField = ChronoField.DAY_OF_MONTH;
        return temporal.with(chronoField, temporal.range(chronoField).getMaximum());
    }

    public static TemporalAdjuster lastDayOfMonth() {
        return new TemporalAdjuster() {
            @Override
            public final Temporal adjustInto(Temporal temporal) {
                return TemporalAdjusters.lambda$lastDayOfMonth$2(temporal);
            }
        };
    }

    public static TemporalAdjuster nextOrSame(DayOfWeek dayOfWeek) {
        final int value = dayOfWeek.getValue();
        return new TemporalAdjuster() {
            @Override
            public final Temporal adjustInto(Temporal temporal) {
                return TemporalAdjusters.lambda$nextOrSame$10(value, temporal);
            }
        };
    }

    static Temporal lambda$nextOrSame$10(int i, Temporal temporal) {
        int i2 = temporal.get(ChronoField.DAY_OF_WEEK);
        if (i2 == i) {
            return temporal;
        }
        int i3 = i2 - i;
        return temporal.plus(i3 >= 0 ? 7 - i3 : -i3, ChronoUnit.DAYS);
    }

    public static TemporalAdjuster previousOrSame(DayOfWeek dayOfWeek) {
        final int value = dayOfWeek.getValue();
        return new TemporalAdjuster() {
            @Override
            public final Temporal adjustInto(Temporal temporal) {
                return TemporalAdjusters.lambda$previousOrSame$12(value, temporal);
            }
        };
    }

    static Temporal lambda$previousOrSame$12(int i, Temporal temporal) {
        int i2 = temporal.get(ChronoField.DAY_OF_WEEK);
        if (i2 == i) {
            return temporal;
        }
        int i3 = i - i2;
        return temporal.minus(i3 >= 0 ? 7 - i3 : -i3, ChronoUnit.DAYS);
    }
}
