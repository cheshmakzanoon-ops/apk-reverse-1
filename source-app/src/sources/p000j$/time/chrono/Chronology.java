package p000j$.time.chrono;

import java.util.List;
import java.util.Locale;
import java.util.Map;
import p000j$.time.DateTimeException;
import p000j$.time.Instant;
import p000j$.time.LocalTime;
import p000j$.time.ZoneId;
import p000j$.time.format.ResolverStyle;
import p000j$.time.temporal.ChronoField;
import p000j$.time.temporal.TemporalAccessor;
import p000j$.time.temporal.TemporalQueries;
import p000j$.time.temporal.ValueRange;
import p000j$.util.Objects;

public interface Chronology extends Comparable<Chronology> {
    int compareTo(Chronology chronology);

    ChronoLocalDate date(int i, int i2, int i3);

    ChronoLocalDate date(TemporalAccessor temporalAccessor);

    ChronoLocalDate dateEpochDay(long j);

    ChronoLocalDate dateYearDay(int i, int i2);

    boolean equals(Object obj);

    Era eraOf(int i);

    List eras();

    String getCalendarType();

    String getId();

    int hashCode();

    boolean isLeapYear(long j);

    ChronoLocalDateTime localDateTime(TemporalAccessor temporalAccessor);

    int prolepticYear(Era era, int i);

    ValueRange range(ChronoField chronoField);

    ChronoLocalDate resolveDate(Map map, ResolverStyle resolverStyle);

    String toString();

    ChronoZonedDateTime zonedDateTime(Instant instant, ZoneId zoneId);

    ChronoZonedDateTime zonedDateTime(TemporalAccessor temporalAccessor);

    public final class CC {
        public static Chronology from(TemporalAccessor temporalAccessor) {
            Objects.requireNonNull(temporalAccessor, "temporal");
            return (Chronology) Objects.requireNonNullElse((Chronology) temporalAccessor.query(TemporalQueries.chronology()), IsoChronology.INSTANCE);
        }

        public static Chronology ofLocale(Locale locale) {
            return AbstractChronology.ofLocale(locale);
        }

        public static Chronology m1693of(String str) {
            return AbstractChronology.m1682of(str);
        }

        public static ChronoLocalDateTime $default$localDateTime(Chronology chronology, TemporalAccessor temporalAccessor) {
            try {
                return chronology.date(temporalAccessor).atTime(LocalTime.from(temporalAccessor));
            } catch (DateTimeException e) {
                throw new DateTimeException("Unable to obtain ChronoLocalDateTime from TemporalAccessor: " + temporalAccessor.getClass(), e);
            }
        }

        public static ChronoZonedDateTime $default$zonedDateTime(Chronology chronology, TemporalAccessor temporalAccessor) {
            try {
                ZoneId zoneIdFrom = ZoneId.from(temporalAccessor);
                try {
                    return chronology.zonedDateTime(Instant.from(temporalAccessor), zoneIdFrom);
                } catch (DateTimeException unused) {
                    return ChronoZonedDateTimeImpl.ofBest(ChronoLocalDateTimeImpl.ensureValid(chronology, chronology.localDateTime(temporalAccessor)), zoneIdFrom, null);
                }
            } catch (DateTimeException e) {
                throw new DateTimeException("Unable to obtain ChronoZonedDateTime from TemporalAccessor: " + temporalAccessor.getClass(), e);
            }
        }
    }
}
