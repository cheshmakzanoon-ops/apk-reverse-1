package com.google.android.gms.internal.measurement;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.math.RoundingMode;
import java.text.DecimalFormat;
import java.util.Iterator;
import java.util.List;

public final class zzai implements zzaq {
    private final Double zza;

    public final int hashCode() {
        return this.zza.hashCode();
    }

    @Override
    public final Iterator<zzaq> zzh() {
        return null;
    }

    @Override
    public final zzaq zza(String str, zzh zzhVar, List<zzaq> list) {
        if ("toString".equals(str)) {
            return new zzas(zzf());
        }
        throw new IllegalArgumentException(String.format("%s.%s is not a function.", zzf(), str));
    }

    @Override
    public final zzaq zzc() {
        return new zzai(this.zza);
    }

    @Override
    public final Boolean zzd() {
        return Boolean.valueOf((Double.isNaN(this.zza.doubleValue()) || this.zza.doubleValue() == 0.0d) ? false : true);
    }

    @Override
    public final Double zze() {
        return this.zza;
    }

    @Override
    public final String zzf() {
        int iScale;
        if (Double.isNaN(this.zza.doubleValue())) {
            return "NaN";
        }
        if (Double.isInfinite(this.zza.doubleValue())) {
            if (this.zza.doubleValue() > 0.0d) {
                return "Infinity";
            }
            return "-Infinity";
        }
        BigDecimal bigDecimalValueOf = BigDecimal.valueOf(this.zza.doubleValue());
        BigDecimal bigDecimal = bigDecimalValueOf.signum() == 0 ? new BigDecimal(BigInteger.ZERO, 0) : zzai$$ExternalSyntheticBackportWithForwarding0.m22m(bigDecimalValueOf);
        DecimalFormat decimalFormat = new DecimalFormat("0E0");
        decimalFormat.setRoundingMode(RoundingMode.HALF_UP);
        if (bigDecimal.scale() > 0) {
            iScale = bigDecimal.precision();
        } else {
            iScale = bigDecimal.scale();
        }
        decimalFormat.setMinimumFractionDigits(iScale - 1);
        String str = decimalFormat.format(bigDecimal);
        int iIndexOf = str.indexOf("E");
        if (iIndexOf <= 0) {
            return str;
        }
        int i = Integer.parseInt(str.substring(iIndexOf + 1));
        if ((i >= 0 || i <= -7) && (i < 0 || i >= 21)) {
            return str.replace("E-", "e-").replace("E", "e+");
        }
        return bigDecimal.toPlainString();
    }

    public final String toString() {
        return zzf();
    }

    public zzai(Double d) {
        if (d == null) {
            this.zza = Double.valueOf(Double.NaN);
        } else {
            this.zza = d;
        }
    }

    public final boolean equals(Object obj) {
        if (obj == this) {
            return true;
        }
        if (obj instanceof zzai) {
            return this.zza.equals(((zzai) obj).zza);
        }
        return false;
    }
}
