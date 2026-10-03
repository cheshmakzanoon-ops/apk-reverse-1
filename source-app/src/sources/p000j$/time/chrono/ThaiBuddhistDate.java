package p000j$.time.chrono;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;
import java.io.InvalidObjectException;
import java.io.ObjectInputStream;
import java.io.Serializable;
import p000j$.time.LocalDate;
import p000j$.time.LocalTime;
import p000j$.time.temporal.ChronoField;
import p000j$.time.temporal.Temporal;
import p000j$.time.temporal.TemporalAdjuster;
import p000j$.time.temporal.TemporalAmount;
import p000j$.time.temporal.TemporalField;
import p000j$.time.temporal.TemporalUnit;
import p000j$.time.temporal.UnsupportedTemporalTypeException;
import p000j$.time.temporal.ValueRange;
import p000j$.util.Objects;

public final class ThaiBuddhistDate extends ChronoLocalDateImpl implements ChronoLocalDate, Serializable {
    private static final long serialVersionUID = -8722293800195731463L;
    private final transient LocalDate isoDate;

    @Override
    public String toString() {
        return super.toString();
    }

    @Override
    public long until(Temporal temporal, TemporalUnit temporalUnit) {
        return super.until(temporal, temporalUnit);
    }

    ThaiBuddhistDate(LocalDate localDate) {
        Objects.requireNonNull(localDate, "isoDate");
        this.isoDate = localDate;
    }

    @Override
    public ThaiBuddhistChronology getChronology() {
        return ThaiBuddhistChronology.INSTANCE;
    }

    @Override
    public ThaiBuddhistEra getEra() {
        return getProlepticYear() >= 1 ? ThaiBuddhistEra.BE : ThaiBuddhistEra.BEFORE_BE;
    }

    @Override
    public ValueRange range(TemporalField temporalField) {
        if (temporalField instanceof ChronoField) {
            if (isSupported(temporalField)) {
                ChronoField chronoField = (ChronoField) temporalField;
                int i = C04891.$SwitchMap$java$time$temporal$ChronoField[chronoField.ordinal()];
                if (i == 1 || i == 2 || i == 3) {
                    return this.isoDate.range(temporalField);
                }
                if (i == 4) {
                    ValueRange valueRangeRange = ChronoField.YEAR.range();
                    return ValueRange.m1708of(1L, getProlepticYear() <= 0 ? (-(valueRangeRange.getMinimum() + 543)) + 1 : 543 + valueRangeRange.getMaximum());
                }
                return getChronology().range(chronoField);
            }
            throw new UnsupportedTemporalTypeException("Unsupported field: " + temporalField);
        }
        return temporalField.rangeRefinedBy(this);
    }

    static class C04891 {
        static final int[] $SwitchMap$java$time$temporal$ChronoField;

        static {
            int[] iArr = new int[ChronoField.values().length];
            $SwitchMap$java$time$temporal$ChronoField = iArr;
            try {
                iArr[ChronoField.DAY_OF_MONTH.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                $SwitchMap$java$time$temporal$ChronoField[ChronoField.DAY_OF_YEAR.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                $SwitchMap$java$time$temporal$ChronoField[ChronoField.ALIGNED_WEEK_OF_MONTH.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            try {
                $SwitchMap$java$time$temporal$ChronoField[ChronoField.YEAR_OF_ERA.ordinal()] = 4;
            } catch (NoSuchFieldError unused4) {
            }
            try {
                $SwitchMap$java$time$temporal$ChronoField[ChronoField.PROLEPTIC_MONTH.ordinal()] = 5;
            } catch (NoSuchFieldError unused5) {
            }
            try {
                $SwitchMap$java$time$temporal$ChronoField[ChronoField.YEAR.ordinal()] = 6;
            } catch (NoSuchFieldError unused6) {
            }
            try {
                $SwitchMap$java$time$temporal$ChronoField[ChronoField.ERA.ordinal()] = 7;
            } catch (NoSuchFieldError unused7) {
            }
        }
    }

    @Override
    public long getLong(TemporalField temporalField) {
        if (temporalField instanceof ChronoField) {
            int i = C04891.$SwitchMap$java$time$temporal$ChronoField[((ChronoField) temporalField).ordinal()];
            if (i == 4) {
                int prolepticYear = getProlepticYear();
                if (prolepticYear < 1) {
                    prolepticYear = 1 - prolepticYear;
                }
                return prolepticYear;
            }
            if (i == 5) {
                return getProlepticMonth();
            }
            if (i == 6) {
                return getProlepticYear();
            }
            if (i != 7) {
                return this.isoDate.getLong(temporalField);
            }
            return getProlepticYear() < 1 ? 0 : 1;
        }
        return temporalField.getFrom(this);
    }

    private long getProlepticMonth() {
        return ((((long) getProlepticYear()) * 12) + ((long) this.isoDate.getMonthValue())) - 1;
    }

    private int getProlepticYear() {
        return this.isoDate.getYear() + 543;
    }

    @Override
    public ThaiBuddhistDate with(TemporalField temporalField, long j) {
        int iCheckValidIntValue;
        int i;
        if (temporalField instanceof ChronoField) {
            ChronoField chronoField = (ChronoField) temporalField;
            if (getLong(chronoField) == j) {
                return this;
            }
            int[] iArr = C04891.$SwitchMap$java$time$temporal$ChronoField;
            int i2 = iArr[chronoField.ordinal()];
            if (i2 == 4) {
                iCheckValidIntValue = getChronology().range(chronoField).checkValidIntValue(j, chronoField);
                i = iArr[chronoField.ordinal()];
                if (i != 4) {
                    LocalDate localDate = this.isoDate;
                    if (getProlepticYear() < 1) {
                        iCheckValidIntValue = 1 - iCheckValidIntValue;
                    }
                    return with(localDate.withYear(iCheckValidIntValue - 543));
                }
                if (i != 6) {
                    return with(this.isoDate.withYear(iCheckValidIntValue - 543));
                }
                if (i == 7) {
                    return with(this.isoDate.withYear((-542) - getProlepticYear()));
                }
            } else {
                if (i2 == 5) {
                    getChronology().range(chronoField).checkValidValue(j, chronoField);
                    return plusMonths(j - getProlepticMonth());
                }
                if (i2 == 6 || i2 == 7) {
                    iCheckValidIntValue = getChronology().range(chronoField).checkValidIntValue(j, chronoField);
                    i = iArr[chronoField.ordinal()];
                    if (i != 4) {
                        LocalDate localDate2 = this.isoDate;
                        if (getProlepticYear() < 1) {
                            iCheckValidIntValue = 1 - iCheckValidIntValue;
                        }
                        return with(localDate2.withYear(iCheckValidIntValue - 543));
                    }
                    if (i != 6) {
                        return with(this.isoDate.withYear(iCheckValidIntValue - 543));
                    }
                    if (i == 7) {
                        return with(this.isoDate.withYear((-542) - getProlepticYear()));
                    }
                }
            }
            return with(this.isoDate.with(temporalField, j));
        }
        return (ThaiBuddhistDate) super.with(temporalField, j);
    }

    @Override
    public ThaiBuddhistDate with(TemporalAdjuster temporalAdjuster) {
        return (ThaiBuddhistDate) super.with(temporalAdjuster);
    }

    @Override
    public ThaiBuddhistDate plus(TemporalAmount temporalAmount) {
        return (ThaiBuddhistDate) super.plus(temporalAmount);
    }

    @Override
    public ThaiBuddhistDate plusYears(long j) {
        return with(this.isoDate.plusYears(j));
    }

    @Override
    public ThaiBuddhistDate plusMonths(long j) {
        return with(this.isoDate.plusMonths(j));
    }

    @Override
    public ThaiBuddhistDate plusDays(long j) {
        return with(this.isoDate.plusDays(j));
    }

    @Override
    public ThaiBuddhistDate plus(long j, TemporalUnit temporalUnit) {
        return (ThaiBuddhistDate) super.plus(j, temporalUnit);
    }

    @Override
    public ThaiBuddhistDate minus(long j, TemporalUnit temporalUnit) {
        return (ThaiBuddhistDate) super.minus(j, temporalUnit);
    }

    private ThaiBuddhistDate with(LocalDate localDate) {
        return localDate.equals(this.isoDate) ? this : new ThaiBuddhistDate(localDate);
    }

    @Override
    public final ChronoLocalDateTime atTime(LocalTime localTime) {
        return super.atTime(localTime);
    }

    @Override
    public long toEpochDay() {
        return this.isoDate.toEpochDay();
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj instanceof ThaiBuddhistDate) {
            return this.isoDate.equals(((ThaiBuddhistDate) obj).isoDate);
        }
        return false;
    }

    @Override
    public int hashCode() {
        return getChronology().getId().hashCode() ^ this.isoDate.hashCode();
    }

    private void readObject(ObjectInputStream objectInputStream) throws InvalidObjectException {
        throw new InvalidObjectException("Deserialization via serialization delegate");
    }

    private Object writeReplace() {
        return new Ser((byte) 8, this);
    }

    void writeExternal(DataOutput dataOutput) throws IOException {
        dataOutput.writeInt(get(ChronoField.YEAR));
        dataOutput.writeByte(get(ChronoField.MONTH_OF_YEAR));
        dataOutput.writeByte(get(ChronoField.DAY_OF_MONTH));
    }

    static ThaiBuddhistDate readExternal(DataInput dataInput) throws IOException {
        return ThaiBuddhistChronology.INSTANCE.date(dataInput.readInt(), (int) dataInput.readByte(), (int) dataInput.readByte());
    }
}
