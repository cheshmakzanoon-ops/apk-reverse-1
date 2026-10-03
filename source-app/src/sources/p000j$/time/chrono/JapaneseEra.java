package p000j$.time.chrono;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;
import java.io.InvalidObjectException;
import java.io.ObjectInputStream;
import java.io.Serializable;
import java.util.Arrays;
import p000j$.time.DateTimeException;
import p000j$.time.LocalDate;
import p000j$.time.temporal.ChronoField;
import p000j$.time.temporal.Temporal;
import p000j$.time.temporal.TemporalAccessor;
import p000j$.time.temporal.TemporalField;
import p000j$.time.temporal.TemporalQuery;
import p000j$.time.temporal.ValueRange;

public final class JapaneseEra implements Era, Serializable {
    public static final JapaneseEra HEISEI;
    private static final JapaneseEra[] KNOWN_ERAS;
    public static final JapaneseEra MEIJI;
    private static final int N_ERA_CONSTANTS;
    public static final JapaneseEra REIWA;
    public static final JapaneseEra SHOWA;
    public static final JapaneseEra TAISHO;
    private static final long serialVersionUID = 1466499369062886794L;
    private final transient String abbreviation;
    private final transient int eraValue;
    private final transient String name;
    private final transient LocalDate since;

    private static int ordinal(int i) {
        return i + 1;
    }

    @Override
    public Temporal adjustInto(Temporal temporal) {
        return temporal.with(ChronoField.ERA, getValue());
    }

    @Override
    public int get(TemporalField temporalField) {
        return Era.CC.$default$get(this, temporalField);
    }

    @Override
    public long getLong(TemporalField temporalField) {
        return Era.CC.$default$getLong(this, temporalField);
    }

    @Override
    public boolean isSupported(TemporalField temporalField) {
        return Era.CC.$default$isSupported(this, temporalField);
    }

    @Override
    public Object query(TemporalQuery temporalQuery) {
        return Era.CC.$default$query(this, temporalQuery);
    }

    static {
        JapaneseEra japaneseEra = new JapaneseEra(-1, LocalDate.m1633of(1868, 1, 1), "Meiji", "M");
        MEIJI = japaneseEra;
        JapaneseEra japaneseEra2 = new JapaneseEra(0, LocalDate.m1633of(1912, 7, 30), "Taisho", "T");
        TAISHO = japaneseEra2;
        JapaneseEra japaneseEra3 = new JapaneseEra(1, LocalDate.m1633of(1926, 12, 25), "Showa", "S");
        SHOWA = japaneseEra3;
        JapaneseEra japaneseEra4 = new JapaneseEra(2, LocalDate.m1633of(1989, 1, 8), "Heisei", "H");
        HEISEI = japaneseEra4;
        JapaneseEra japaneseEra5 = new JapaneseEra(3, LocalDate.m1633of(2019, 5, 1), "Reiwa", "R");
        REIWA = japaneseEra5;
        int value = japaneseEra5.getValue() + 2;
        N_ERA_CONSTANTS = value;
        JapaneseEra[] japaneseEraArr = new JapaneseEra[value];
        KNOWN_ERAS = japaneseEraArr;
        japaneseEraArr[0] = japaneseEra;
        japaneseEraArr[1] = japaneseEra2;
        japaneseEraArr[2] = japaneseEra3;
        japaneseEraArr[3] = japaneseEra4;
        japaneseEraArr[4] = japaneseEra5;
    }

    static JapaneseEra getCurrentEra() {
        JapaneseEra[] japaneseEraArr = KNOWN_ERAS;
        return japaneseEraArr[japaneseEraArr.length - 1];
    }

    static long shortestYearsOfEra() {
        int year = 1000000000 - getCurrentEra().since.getYear();
        int year2 = KNOWN_ERAS[0].since.getYear();
        int i = 1;
        while (true) {
            JapaneseEra[] japaneseEraArr = KNOWN_ERAS;
            if (i >= japaneseEraArr.length) {
                return year;
            }
            JapaneseEra japaneseEra = japaneseEraArr[i];
            year = Math.min(year, (japaneseEra.since.getYear() - year2) + 1);
            year2 = japaneseEra.since.getYear();
            i++;
        }
    }

    static long shortestDaysOfYear() {
        long smallestMaximum = ChronoField.DAY_OF_YEAR.range().getSmallestMaximum();
        for (JapaneseEra japaneseEra : KNOWN_ERAS) {
            smallestMaximum = Math.min(smallestMaximum, (japaneseEra.since.lengthOfYear() - japaneseEra.since.getDayOfYear()) + 1);
            if (japaneseEra.next() != null) {
                smallestMaximum = Math.min(smallestMaximum, japaneseEra.next().since.getDayOfYear() - 1);
            }
        }
        return smallestMaximum;
    }

    private JapaneseEra(int i, LocalDate localDate, String str, String str2) {
        this.eraValue = i;
        this.since = localDate;
        this.name = str;
        this.abbreviation = str2;
    }

    LocalDate getSince() {
        return this.since;
    }

    public static JapaneseEra m1700of(int i) {
        int iOrdinal = ordinal(i);
        if (iOrdinal >= 0) {
            JapaneseEra[] japaneseEraArr = KNOWN_ERAS;
            if (iOrdinal < japaneseEraArr.length) {
                return japaneseEraArr[iOrdinal];
            }
        }
        throw new DateTimeException("Invalid era: " + i);
    }

    public static JapaneseEra[] values() {
        JapaneseEra[] japaneseEraArr = KNOWN_ERAS;
        return (JapaneseEra[]) Arrays.copyOf(japaneseEraArr, japaneseEraArr.length);
    }

    static JapaneseEra from(LocalDate localDate) {
        if (localDate.isBefore(JapaneseDate.MEIJI_6_ISODATE)) {
            throw new DateTimeException("JapaneseDate before Meiji 6 are not supported");
        }
        for (int length = KNOWN_ERAS.length - 1; length >= 0; length--) {
            JapaneseEra japaneseEra = KNOWN_ERAS[length];
            if (localDate.compareTo((ChronoLocalDate) japaneseEra.since) >= 0) {
                return japaneseEra;
            }
        }
        return null;
    }

    @Override
    public int getValue() {
        return this.eraValue;
    }

    @Override
    public ValueRange range(TemporalField temporalField) {
        ChronoField chronoField = ChronoField.ERA;
        if (temporalField != chronoField) {
            return TemporalAccessor.CC.$default$range(this, temporalField);
        }
        return JapaneseChronology.INSTANCE.range(chronoField);
    }

    String getName() {
        return this.name;
    }

    JapaneseEra next() {
        if (this == getCurrentEra()) {
            return null;
        }
        return m1700of(this.eraValue + 1);
    }

    public String toString() {
        return getName();
    }

    private void readObject(ObjectInputStream objectInputStream) throws InvalidObjectException {
        throw new InvalidObjectException("Deserialization via serialization delegate");
    }

    private Object writeReplace() {
        return new Ser((byte) 5, this);
    }

    void writeExternal(DataOutput dataOutput) throws IOException {
        dataOutput.writeByte(getValue());
    }

    static JapaneseEra readExternal(DataInput dataInput) {
        return m1700of(dataInput.readByte());
    }
}
