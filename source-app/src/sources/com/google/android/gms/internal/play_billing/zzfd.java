package com.google.android.gms.internal.play_billing;

import java.io.IOException;
import java.util.List;
import java.util.Map;

final class zzfd implements zzit {
    private final zzfc zza;

    private zzfd(zzfc zzfcVar) {
        byte[] bArr = zzga.zzb;
        this.zza = zzfcVar;
        zzfcVar.zza = this;
    }

    public static zzfd zza(zzfc zzfcVar) {
        Object obj = zzfcVar.zza;
        return obj != null ? (zzfd) obj : new zzfd(zzfcVar);
    }

    @Override
    public final void zzA(int i, long j) throws IOException {
        this.zza.zzj(i, j);
    }

    @Override
    public final void zzC(int i, int i2) throws IOException {
        this.zza.zzt(i, (i2 >> 31) ^ (i2 + i2));
    }

    @Override
    public final void zzE(int i, long j) throws IOException {
        this.zza.zzv(i, (j >> 63) ^ (j + j));
    }

    @Override
    @Deprecated
    public final void zzG(int i) throws IOException {
        this.zza.zzs(i, 3);
    }

    @Override
    public final void zzH(int i, String str) throws IOException {
        this.zza.zzq(i, str);
    }

    @Override
    public final void zzJ(int i, int i2) throws IOException {
        this.zza.zzt(i, i2);
    }

    @Override
    public final void zzL(int i, long j) throws IOException {
        this.zza.zzv(i, j);
    }

    @Override
    public final void zzb(int i, boolean z) throws IOException {
        this.zza.zzd(i, z);
    }

    @Override
    public final void zzd(int i, zzev zzevVar) throws IOException {
        this.zza.zzf(i, zzevVar);
    }

    @Override
    public final void zze(int i, List list) throws IOException {
        for (int i2 = 0; i2 < list.size(); i2++) {
            this.zza.zzf(i, (zzev) list.get(i2));
        }
    }

    @Override
    public final void zzf(int i, double d) throws IOException {
        this.zza.zzj(i, Double.doubleToRawLongBits(d));
    }

    @Override
    @Deprecated
    public final void zzh(int i) throws IOException {
        this.zza.zzs(i, 4);
    }

    @Override
    public final void zzi(int i, int i2) throws IOException {
        this.zza.zzl(i, i2);
    }

    @Override
    public final void zzk(int i, int i2) throws IOException {
        this.zza.zzh(i, i2);
    }

    @Override
    public final void zzm(int i, long j) throws IOException {
        this.zza.zzj(i, j);
    }

    @Override
    public final void zzo(int i, float f) throws IOException {
        this.zza.zzh(i, Float.floatToRawIntBits(f));
    }

    @Override
    public final void zzq(int i, Object obj, zzhl zzhlVar) throws IOException {
        zzfc zzfcVar = this.zza;
        zzfcVar.zzs(i, 3);
        zzhlVar.zzi((zzeg) obj, this);
        zzfcVar.zzs(i, 4);
    }

    @Override
    public final void zzr(int i, int i2) throws IOException {
        this.zza.zzl(i, i2);
    }

    @Override
    public final void zzt(int i, long j) throws IOException {
        this.zza.zzv(i, j);
    }

    @Override
    public final void zzv(int i, zzgt zzgtVar, Map map) throws IOException {
        for (Map.Entry entry : map.entrySet()) {
            zzfc zzfcVar = this.zza;
            zzfcVar.zzs(i, 2);
            zzfcVar.zzu(zzgu.zzb(zzgtVar, entry.getKey(), entry.getValue()));
            zzgu.zze(zzfcVar, zzgtVar, entry.getKey(), entry.getValue());
        }
    }

    @Override
    public final void zzw(int i, Object obj, zzhl zzhlVar) throws IOException {
        zzfc zzfcVar = this.zza;
        zzeg zzegVar = (zzeg) obj;
        zzfcVar.zzs(i, 2);
        zzfcVar.zzu(zzegVar.zzi(zzhlVar));
        zzhlVar.zzi(zzegVar, this);
    }

    @Override
    public final void zzx(int i, Object obj) throws IOException {
        if (obj instanceof zzev) {
            this.zza.zzp(i, (zzev) obj);
        } else {
            this.zza.zzo(i, (zzhb) obj);
        }
    }

    @Override
    public final void zzy(int i, int i2) throws IOException {
        this.zza.zzh(i, i2);
    }

    @Override
    public final void zzI(int i, List list) throws IOException {
        int i2 = 0;
        if (!(list instanceof zzgj)) {
            while (i2 < list.size()) {
                this.zza.zzq(i, (String) list.get(i2));
                i2++;
            }
            return;
        }
        zzgj zzgjVar = (zzgj) list;
        while (i2 < list.size()) {
            Object objZza = zzgjVar.zza();
            if (objZza instanceof String) {
                this.zza.zzq(i, (String) objZza);
            } else {
                this.zza.zzf(i, (zzev) objZza);
            }
            i2++;
        }
    }

    @Override
    public final void zzK(int i, List list, boolean z) throws IOException {
        int i2 = 0;
        if (!(list instanceof zzfv)) {
            if (!z) {
                while (i2 < list.size()) {
                    this.zza.zzt(i, ((Integer) list.get(i2)).intValue());
                    i2++;
                }
                return;
            }
            zzfc zzfcVar = this.zza;
            zzfcVar.zzs(i, 2);
            int iZzy = 0;
            for (int i3 = 0; i3 < list.size(); i3++) {
                iZzy += zzfc.zzy(((Integer) list.get(i3)).intValue());
            }
            zzfcVar.zzu(iZzy);
            while (i2 < list.size()) {
                zzfcVar.zzu(((Integer) list.get(i2)).intValue());
                i2++;
            }
            return;
        }
        zzfv zzfvVar = (zzfv) list;
        if (!z) {
            while (i2 < zzfvVar.size()) {
                this.zza.zzt(i, zzfvVar.zze(i2));
                i2++;
            }
            return;
        }
        zzfc zzfcVar2 = this.zza;
        zzfcVar2.zzs(i, 2);
        int iZzy2 = 0;
        for (int i4 = 0; i4 < zzfvVar.size(); i4++) {
            iZzy2 += zzfc.zzy(zzfvVar.zze(i4));
        }
        zzfcVar2.zzu(iZzy2);
        while (i2 < zzfvVar.size()) {
            zzfcVar2.zzu(zzfvVar.zze(i2));
            i2++;
        }
    }

    @Override
    public final void zzM(int i, List list, boolean z) throws IOException {
        int i2 = 0;
        if (!(list instanceof zzgp)) {
            if (!z) {
                while (i2 < list.size()) {
                    this.zza.zzv(i, ((Long) list.get(i2)).longValue());
                    i2++;
                }
                return;
            }
            zzfc zzfcVar = this.zza;
            zzfcVar.zzs(i, 2);
            int iZzz = 0;
            for (int i3 = 0; i3 < list.size(); i3++) {
                iZzz += zzfc.zzz(((Long) list.get(i3)).longValue());
            }
            zzfcVar.zzu(iZzz);
            while (i2 < list.size()) {
                zzfcVar.zzw(((Long) list.get(i2)).longValue());
                i2++;
            }
            return;
        }
        zzgp zzgpVar = (zzgp) list;
        if (!z) {
            while (i2 < zzgpVar.size()) {
                this.zza.zzv(i, zzgpVar.zze(i2));
                i2++;
            }
            return;
        }
        zzfc zzfcVar2 = this.zza;
        zzfcVar2.zzs(i, 2);
        int iZzz2 = 0;
        for (int i4 = 0; i4 < zzgpVar.size(); i4++) {
            iZzz2 += zzfc.zzz(zzgpVar.zze(i4));
        }
        zzfcVar2.zzu(iZzz2);
        while (i2 < zzgpVar.size()) {
            zzfcVar2.zzw(zzgpVar.zze(i2));
            i2++;
        }
    }

    @Override
    public final void zzl(int i, List list, boolean z) throws IOException {
        int i2 = 0;
        if (!(list instanceof zzfv)) {
            if (!z) {
                while (i2 < list.size()) {
                    this.zza.zzh(i, ((Integer) list.get(i2)).intValue());
                    i2++;
                }
                return;
            }
            zzfc zzfcVar = this.zza;
            zzfcVar.zzs(i, 2);
            int i3 = 0;
            for (int i4 = 0; i4 < list.size(); i4++) {
                ((Integer) list.get(i4)).intValue();
                i3 += 4;
            }
            zzfcVar.zzu(i3);
            while (i2 < list.size()) {
                zzfcVar.zzi(((Integer) list.get(i2)).intValue());
                i2++;
            }
            return;
        }
        zzfv zzfvVar = (zzfv) list;
        if (!z) {
            while (i2 < zzfvVar.size()) {
                this.zza.zzh(i, zzfvVar.zze(i2));
                i2++;
            }
            return;
        }
        zzfc zzfcVar2 = this.zza;
        zzfcVar2.zzs(i, 2);
        int i5 = 0;
        for (int i6 = 0; i6 < zzfvVar.size(); i6++) {
            zzfvVar.zze(i6);
            i5 += 4;
        }
        zzfcVar2.zzu(i5);
        while (i2 < zzfvVar.size()) {
            zzfcVar2.zzi(zzfvVar.zze(i2));
            i2++;
        }
    }

    @Override
    public final void zzn(int i, List list, boolean z) throws IOException {
        int i2 = 0;
        if (!(list instanceof zzgp)) {
            if (!z) {
                while (i2 < list.size()) {
                    this.zza.zzj(i, ((Long) list.get(i2)).longValue());
                    i2++;
                }
                return;
            }
            zzfc zzfcVar = this.zza;
            zzfcVar.zzs(i, 2);
            int i3 = 0;
            for (int i4 = 0; i4 < list.size(); i4++) {
                ((Long) list.get(i4)).longValue();
                i3 += 8;
            }
            zzfcVar.zzu(i3);
            while (i2 < list.size()) {
                zzfcVar.zzk(((Long) list.get(i2)).longValue());
                i2++;
            }
            return;
        }
        zzgp zzgpVar = (zzgp) list;
        if (!z) {
            while (i2 < zzgpVar.size()) {
                this.zza.zzj(i, zzgpVar.zze(i2));
                i2++;
            }
            return;
        }
        zzfc zzfcVar2 = this.zza;
        zzfcVar2.zzs(i, 2);
        int i5 = 0;
        for (int i6 = 0; i6 < zzgpVar.size(); i6++) {
            zzgpVar.zze(i6);
            i5 += 8;
        }
        zzfcVar2.zzu(i5);
        while (i2 < zzgpVar.size()) {
            zzfcVar2.zzk(zzgpVar.zze(i2));
            i2++;
        }
    }

    @Override
    public final void zzc(int i, List list, boolean z) throws IOException {
        int i2 = 0;
        if (!(list instanceof zzel)) {
            if (!z) {
                while (i2 < list.size()) {
                    this.zza.zzd(i, ((Boolean) list.get(i2)).booleanValue());
                    i2++;
                }
                return;
            }
            zzfc zzfcVar = this.zza;
            zzfcVar.zzs(i, 2);
            int i3 = 0;
            for (int i4 = 0; i4 < list.size(); i4++) {
                ((Boolean) list.get(i4)).booleanValue();
                i3++;
            }
            zzfcVar.zzu(i3);
            while (i2 < list.size()) {
                zzfcVar.zzb(((Boolean) list.get(i2)).booleanValue() ? (byte) 1 : (byte) 0);
                i2++;
            }
            return;
        }
        zzel zzelVar = (zzel) list;
        if (!z) {
            while (i2 < zzelVar.size()) {
                this.zza.zzd(i, zzelVar.zzf(i2));
                i2++;
            }
            return;
        }
        zzfc zzfcVar2 = this.zza;
        zzfcVar2.zzs(i, 2);
        int i5 = 0;
        for (int i6 = 0; i6 < zzelVar.size(); i6++) {
            zzelVar.zzf(i6);
            i5++;
        }
        zzfcVar2.zzu(i5);
        while (i2 < zzelVar.size()) {
            zzfcVar2.zzb(zzelVar.zzf(i2) ? (byte) 1 : (byte) 0);
            i2++;
        }
    }

    @Override
    public final void zzs(int i, List list, boolean z) throws IOException {
        int i2 = 0;
        if (!(list instanceof zzfv)) {
            if (!z) {
                while (i2 < list.size()) {
                    this.zza.zzl(i, ((Integer) list.get(i2)).intValue());
                    i2++;
                }
                return;
            }
            zzfc zzfcVar = this.zza;
            zzfcVar.zzs(i, 2);
            int iZzz = 0;
            for (int i3 = 0; i3 < list.size(); i3++) {
                iZzz += zzfc.zzz(((Integer) list.get(i3)).intValue());
            }
            zzfcVar.zzu(iZzz);
            while (i2 < list.size()) {
                zzfcVar.zzm(((Integer) list.get(i2)).intValue());
                i2++;
            }
            return;
        }
        zzfv zzfvVar = (zzfv) list;
        if (!z) {
            while (i2 < zzfvVar.size()) {
                this.zza.zzl(i, zzfvVar.zze(i2));
                i2++;
            }
            return;
        }
        zzfc zzfcVar2 = this.zza;
        zzfcVar2.zzs(i, 2);
        int iZzz2 = 0;
        for (int i4 = 0; i4 < zzfvVar.size(); i4++) {
            iZzz2 += zzfc.zzz(zzfvVar.zze(i4));
        }
        zzfcVar2.zzu(iZzz2);
        while (i2 < zzfvVar.size()) {
            zzfcVar2.zzm(zzfvVar.zze(i2));
            i2++;
        }
    }

    @Override
    public final void zzB(int i, List list, boolean z) throws IOException {
        int i2 = 0;
        if (!(list instanceof zzgp)) {
            if (!z) {
                while (i2 < list.size()) {
                    this.zza.zzj(i, ((Long) list.get(i2)).longValue());
                    i2++;
                }
                return;
            }
            zzfc zzfcVar = this.zza;
            zzfcVar.zzs(i, 2);
            int i3 = 0;
            for (int i4 = 0; i4 < list.size(); i4++) {
                ((Long) list.get(i4)).longValue();
                i3 += 8;
            }
            zzfcVar.zzu(i3);
            while (i2 < list.size()) {
                zzfcVar.zzk(((Long) list.get(i2)).longValue());
                i2++;
            }
            return;
        }
        zzgp zzgpVar = (zzgp) list;
        if (!z) {
            while (i2 < zzgpVar.size()) {
                this.zza.zzj(i, zzgpVar.zze(i2));
                i2++;
            }
            return;
        }
        zzfc zzfcVar2 = this.zza;
        zzfcVar2.zzs(i, 2);
        int i5 = 0;
        for (int i6 = 0; i6 < zzgpVar.size(); i6++) {
            zzgpVar.zze(i6);
            i5 += 8;
        }
        zzfcVar2.zzu(i5);
        while (i2 < zzgpVar.size()) {
            zzfcVar2.zzk(zzgpVar.zze(i2));
            i2++;
        }
    }

    @Override
    public final void zzg(int i, List list, boolean z) throws IOException {
        int i2 = 0;
        if (!(list instanceof zzfe)) {
            if (!z) {
                while (i2 < list.size()) {
                    this.zza.zzj(i, Double.doubleToRawLongBits(((Double) list.get(i2)).doubleValue()));
                    i2++;
                }
                return;
            }
            zzfc zzfcVar = this.zza;
            zzfcVar.zzs(i, 2);
            int i3 = 0;
            for (int i4 = 0; i4 < list.size(); i4++) {
                ((Double) list.get(i4)).doubleValue();
                i3 += 8;
            }
            zzfcVar.zzu(i3);
            while (i2 < list.size()) {
                zzfcVar.zzk(Double.doubleToRawLongBits(((Double) list.get(i2)).doubleValue()));
                i2++;
            }
            return;
        }
        zzfe zzfeVar = (zzfe) list;
        if (!z) {
            while (i2 < zzfeVar.size()) {
                this.zza.zzj(i, Double.doubleToRawLongBits(zzfeVar.zze(i2)));
                i2++;
            }
            return;
        }
        zzfc zzfcVar2 = this.zza;
        zzfcVar2.zzs(i, 2);
        int i5 = 0;
        for (int i6 = 0; i6 < zzfeVar.size(); i6++) {
            zzfeVar.zze(i6);
            i5 += 8;
        }
        zzfcVar2.zzu(i5);
        while (i2 < zzfeVar.size()) {
            zzfcVar2.zzk(Double.doubleToRawLongBits(zzfeVar.zze(i2)));
            i2++;
        }
    }

    @Override
    public final void zzp(int i, List list, boolean z) throws IOException {
        int i2 = 0;
        if (!(list instanceof zzfo)) {
            if (!z) {
                while (i2 < list.size()) {
                    this.zza.zzh(i, Float.floatToRawIntBits(((Float) list.get(i2)).floatValue()));
                    i2++;
                }
                return;
            }
            zzfc zzfcVar = this.zza;
            zzfcVar.zzs(i, 2);
            int i3 = 0;
            for (int i4 = 0; i4 < list.size(); i4++) {
                ((Float) list.get(i4)).floatValue();
                i3 += 4;
            }
            zzfcVar.zzu(i3);
            while (i2 < list.size()) {
                zzfcVar.zzi(Float.floatToRawIntBits(((Float) list.get(i2)).floatValue()));
                i2++;
            }
            return;
        }
        zzfo zzfoVar = (zzfo) list;
        if (!z) {
            while (i2 < zzfoVar.size()) {
                this.zza.zzh(i, Float.floatToRawIntBits(zzfoVar.zze(i2)));
                i2++;
            }
            return;
        }
        zzfc zzfcVar2 = this.zza;
        zzfcVar2.zzs(i, 2);
        int i5 = 0;
        for (int i6 = 0; i6 < zzfoVar.size(); i6++) {
            zzfoVar.zze(i6);
            i5 += 4;
        }
        zzfcVar2.zzu(i5);
        while (i2 < zzfoVar.size()) {
            zzfcVar2.zzi(Float.floatToRawIntBits(zzfoVar.zze(i2)));
            i2++;
        }
    }

    @Override
    public final void zzz(int i, List list, boolean z) throws IOException {
        int i2 = 0;
        if (!(list instanceof zzfv)) {
            if (!z) {
                while (i2 < list.size()) {
                    this.zza.zzh(i, ((Integer) list.get(i2)).intValue());
                    i2++;
                }
                return;
            }
            zzfc zzfcVar = this.zza;
            zzfcVar.zzs(i, 2);
            int i3 = 0;
            for (int i4 = 0; i4 < list.size(); i4++) {
                ((Integer) list.get(i4)).intValue();
                i3 += 4;
            }
            zzfcVar.zzu(i3);
            while (i2 < list.size()) {
                zzfcVar.zzi(((Integer) list.get(i2)).intValue());
                i2++;
            }
            return;
        }
        zzfv zzfvVar = (zzfv) list;
        if (!z) {
            while (i2 < zzfvVar.size()) {
                this.zza.zzh(i, zzfvVar.zze(i2));
                i2++;
            }
            return;
        }
        zzfc zzfcVar2 = this.zza;
        zzfcVar2.zzs(i, 2);
        int i5 = 0;
        for (int i6 = 0; i6 < zzfvVar.size(); i6++) {
            zzfvVar.zze(i6);
            i5 += 4;
        }
        zzfcVar2.zzu(i5);
        while (i2 < zzfvVar.size()) {
            zzfcVar2.zzi(zzfvVar.zze(i2));
            i2++;
        }
    }

    @Override
    public final void zzD(int i, List list, boolean z) throws IOException {
        int i2 = 0;
        if (!(list instanceof zzfv)) {
            if (!z) {
                while (i2 < list.size()) {
                    zzfc zzfcVar = this.zza;
                    int iIntValue = ((Integer) list.get(i2)).intValue();
                    zzfcVar.zzt(i, (iIntValue >> 31) ^ (iIntValue + iIntValue));
                    i2++;
                }
                return;
            }
            zzfc zzfcVar2 = this.zza;
            zzfcVar2.zzs(i, 2);
            int iZzy = 0;
            for (int i3 = 0; i3 < list.size(); i3++) {
                int iIntValue2 = ((Integer) list.get(i3)).intValue();
                iZzy += zzfc.zzy((iIntValue2 >> 31) ^ (iIntValue2 + iIntValue2));
            }
            zzfcVar2.zzu(iZzy);
            while (i2 < list.size()) {
                int iIntValue3 = ((Integer) list.get(i2)).intValue();
                zzfcVar2.zzu((iIntValue3 >> 31) ^ (iIntValue3 + iIntValue3));
                i2++;
            }
            return;
        }
        zzfv zzfvVar = (zzfv) list;
        if (!z) {
            while (i2 < zzfvVar.size()) {
                zzfc zzfcVar3 = this.zza;
                int iZze = zzfvVar.zze(i2);
                zzfcVar3.zzt(i, (iZze >> 31) ^ (iZze + iZze));
                i2++;
            }
            return;
        }
        zzfc zzfcVar4 = this.zza;
        zzfcVar4.zzs(i, 2);
        int iZzy2 = 0;
        for (int i4 = 0; i4 < zzfvVar.size(); i4++) {
            int iZze2 = zzfvVar.zze(i4);
            iZzy2 += zzfc.zzy((iZze2 >> 31) ^ (iZze2 + iZze2));
        }
        zzfcVar4.zzu(iZzy2);
        while (i2 < zzfvVar.size()) {
            int iZze3 = zzfvVar.zze(i2);
            zzfcVar4.zzu((iZze3 >> 31) ^ (iZze3 + iZze3));
            i2++;
        }
    }

    @Override
    public final void zzF(int i, List list, boolean z) throws IOException {
        int i2 = 0;
        if (!(list instanceof zzgp)) {
            if (!z) {
                while (i2 < list.size()) {
                    zzfc zzfcVar = this.zza;
                    long jLongValue = ((Long) list.get(i2)).longValue();
                    zzfcVar.zzv(i, (jLongValue >> 63) ^ (jLongValue + jLongValue));
                    i2++;
                }
                return;
            }
            zzfc zzfcVar2 = this.zza;
            zzfcVar2.zzs(i, 2);
            int iZzz = 0;
            for (int i3 = 0; i3 < list.size(); i3++) {
                long jLongValue2 = ((Long) list.get(i3)).longValue();
                iZzz += zzfc.zzz((jLongValue2 >> 63) ^ (jLongValue2 + jLongValue2));
            }
            zzfcVar2.zzu(iZzz);
            while (i2 < list.size()) {
                long jLongValue3 = ((Long) list.get(i2)).longValue();
                zzfcVar2.zzw((jLongValue3 >> 63) ^ (jLongValue3 + jLongValue3));
                i2++;
            }
            return;
        }
        zzgp zzgpVar = (zzgp) list;
        if (!z) {
            while (i2 < zzgpVar.size()) {
                zzfc zzfcVar3 = this.zza;
                long jZze = zzgpVar.zze(i2);
                zzfcVar3.zzv(i, (jZze >> 63) ^ (jZze + jZze));
                i2++;
            }
            return;
        }
        zzfc zzfcVar4 = this.zza;
        zzfcVar4.zzs(i, 2);
        int iZzz2 = 0;
        for (int i4 = 0; i4 < zzgpVar.size(); i4++) {
            long jZze2 = zzgpVar.zze(i4);
            iZzz2 += zzfc.zzz((jZze2 >> 63) ^ (jZze2 + jZze2));
        }
        zzfcVar4.zzu(iZzz2);
        while (i2 < zzgpVar.size()) {
            long jZze3 = zzgpVar.zze(i2);
            zzfcVar4.zzw((jZze3 >> 63) ^ (jZze3 + jZze3));
            i2++;
        }
    }

    @Override
    public final void zzj(int i, List list, boolean z) throws IOException {
        int i2 = 0;
        if (!(list instanceof zzfv)) {
            if (!z) {
                while (i2 < list.size()) {
                    this.zza.zzl(i, ((Integer) list.get(i2)).intValue());
                    i2++;
                }
                return;
            }
            zzfc zzfcVar = this.zza;
            zzfcVar.zzs(i, 2);
            int iZzz = 0;
            for (int i3 = 0; i3 < list.size(); i3++) {
                iZzz += zzfc.zzz(((Integer) list.get(i3)).intValue());
            }
            zzfcVar.zzu(iZzz);
            while (i2 < list.size()) {
                zzfcVar.zzm(((Integer) list.get(i2)).intValue());
                i2++;
            }
            return;
        }
        zzfv zzfvVar = (zzfv) list;
        if (!z) {
            while (i2 < zzfvVar.size()) {
                this.zza.zzl(i, zzfvVar.zze(i2));
                i2++;
            }
            return;
        }
        zzfc zzfcVar2 = this.zza;
        zzfcVar2.zzs(i, 2);
        int iZzz2 = 0;
        for (int i4 = 0; i4 < zzfvVar.size(); i4++) {
            iZzz2 += zzfc.zzz(zzfvVar.zze(i4));
        }
        zzfcVar2.zzu(iZzz2);
        while (i2 < zzfvVar.size()) {
            zzfcVar2.zzm(zzfvVar.zze(i2));
            i2++;
        }
    }

    @Override
    public final void zzu(int i, List list, boolean z) throws IOException {
        int i2 = 0;
        if (!(list instanceof zzgp)) {
            if (!z) {
                while (i2 < list.size()) {
                    this.zza.zzv(i, ((Long) list.get(i2)).longValue());
                    i2++;
                }
                return;
            }
            zzfc zzfcVar = this.zza;
            zzfcVar.zzs(i, 2);
            int iZzz = 0;
            for (int i3 = 0; i3 < list.size(); i3++) {
                iZzz += zzfc.zzz(((Long) list.get(i3)).longValue());
            }
            zzfcVar.zzu(iZzz);
            while (i2 < list.size()) {
                zzfcVar.zzw(((Long) list.get(i2)).longValue());
                i2++;
            }
            return;
        }
        zzgp zzgpVar = (zzgp) list;
        if (!z) {
            while (i2 < zzgpVar.size()) {
                this.zza.zzv(i, zzgpVar.zze(i2));
                i2++;
            }
            return;
        }
        zzfc zzfcVar2 = this.zza;
        zzfcVar2.zzs(i, 2);
        int iZzz2 = 0;
        for (int i4 = 0; i4 < zzgpVar.size(); i4++) {
            iZzz2 += zzfc.zzz(zzgpVar.zze(i4));
        }
        zzfcVar2.zzu(iZzz2);
        while (i2 < zzgpVar.size()) {
            zzfcVar2.zzw(zzgpVar.zze(i2));
            i2++;
        }
    }
}
