package com.google.android.gms.measurement.internal;

import android.accounts.Account;
import android.accounts.AccountManager;
import android.accounts.AuthenticatorException;
import android.accounts.OperationCanceledException;
import android.content.Context;
import androidx.core.content.ContextCompat;
import com.google.android.gms.common.util.Clock;
import java.io.IOException;
import java.util.Calendar;
import java.util.Locale;
import java.util.concurrent.TimeUnit;
import org.checkerframework.dataflow.qual.Pure;

public final class zzba extends zzic {
    private long zza;
    private String zzb;
    private AccountManager zzc;
    private Boolean zzd;
    private long zze;

    final long zzc() {
        zzt();
        return this.zze;
    }

    public final long zzg() {
        zzab();
        return this.zza;
    }

    @Override
    @Pure
    public final Context zza() {
        return super.zza();
    }

    @Override
    @Pure
    public final Clock zzb() {
        return super.zzb();
    }

    @Override
    @Pure
    public final zzae zzd() {
        return super.zzd();
    }

    @Override
    @Pure
    public final zzaf zze() {
        return super.zze();
    }

    @Override
    @Pure
    public final zzba zzf() {
        return super.zzf();
    }

    @Override
    @Pure
    public final zzfq zzi() {
        return super.zzi();
    }

    @Override
    @Pure
    public final zzfr zzj() {
        return super.zzj();
    }

    @Override
    @Pure
    public final zzgd zzk() {
        return super.zzk();
    }

    @Override
    @Pure
    public final zzgy zzl() {
        return super.zzl();
    }

    @Override
    @Pure
    public final zznd zzq() {
        return super.zzq();
    }

    public final String zzh() {
        zzab();
        return this.zzb;
    }

    zzba(zzhf zzhfVar) {
        super(zzhfVar);
    }

    @Override
    public final void zzr() {
        super.zzr();
    }

    @Override
    public final void zzs() {
        super.zzs();
    }

    @Override
    public final void zzt() {
        super.zzt();
    }

    final void zzm() {
        zzt();
        this.zzd = null;
        this.zze = 0L;
    }

    final boolean zzn() {
        zzt();
        long jCurrentTimeMillis = zzb().currentTimeMillis();
        if (jCurrentTimeMillis - this.zze > 86400000) {
            this.zzd = null;
        }
        Boolean bool = this.zzd;
        if (bool != null) {
            return bool.booleanValue();
        }
        if (ContextCompat.checkSelfPermission(zza(), "android.permission.GET_ACCOUNTS") != 0) {
            zzj().zzw().zza("Permission error checking for dasher/unicorn accounts");
            this.zze = jCurrentTimeMillis;
            this.zzd = false;
            return false;
        }
        if (this.zzc == null) {
            this.zzc = AccountManager.get(zza());
        }
        try {
            Account[] result = this.zzc.getAccountsByTypeAndFeatures("com.google", new String[]{"service_HOSTED"}, null, null).getResult();
            if (result != null && result.length > 0) {
                this.zzd = true;
                this.zze = jCurrentTimeMillis;
                return true;
            }
            Account[] result2 = this.zzc.getAccountsByTypeAndFeatures("com.google", new String[]{"service_uca"}, null, null).getResult();
            if (result2 != null && result2.length > 0) {
                this.zzd = true;
                this.zze = jCurrentTimeMillis;
                return true;
            }
            this.zze = jCurrentTimeMillis;
            this.zzd = false;
            return false;
        } catch (AuthenticatorException | OperationCanceledException | IOException e) {
            zzj().zzm().zza("Exception checking account types", e);
        }
    }

    @Override
    protected final boolean zzo() {
        Calendar calendar = Calendar.getInstance();
        this.zza = TimeUnit.MINUTES.convert(calendar.get(15) + calendar.get(16), TimeUnit.MILLISECONDS);
        Locale locale = Locale.getDefault();
        this.zzb = locale.getLanguage().toLowerCase(Locale.ENGLISH) + "-" + locale.getCountry().toLowerCase(Locale.ENGLISH);
        return false;
    }
}
