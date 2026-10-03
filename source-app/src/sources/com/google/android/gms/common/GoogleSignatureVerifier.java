package com.google.android.gms.common;

import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.Signature;
import android.content.pm.SigningInfo;
import android.os.Build;
import android.os.RemoteException;
import android.os.StrictMode;
import android.util.Log;
import androidx.core.graphics.ColorKt$;
import com.google.android.gms.common.internal.Preconditions;
import com.google.android.gms.common.util.AndroidUtilsLight;
import com.google.android.gms.dynamite.DynamiteModule;
import com.google.android.gms.internal.common.zzah;
import com.google.android.gms.internal.common.zzal;
import java.util.Arrays;
import java.util.Set;
import javax.annotation.Nullable;

public class GoogleSignatureVerifier {

    @Nullable
    private static GoogleSignatureVerifier zza;

    @Nullable
    private static volatile Set zzd;

    @Nullable
    private static volatile Set zze;
    private final Context zzb;
    private volatile String zzc;

    public GoogleSignatureVerifier(Context context) {
        this.zzb = context.getApplicationContext();
    }

    public static GoogleSignatureVerifier getInstance(Context context) {
        Preconditions.checkNotNull(context);
        synchronized (GoogleSignatureVerifier.class) {
            if (zza == null) {
                zzo.zza(context);
                zza = new GoogleSignatureVerifier(context);
            }
        }
        return zza;
    }

    @Deprecated
    static final boolean zza(PackageInfo packageInfo, boolean z) {
        zzah zzahVarZzj;
        if (packageInfo == null) {
            return false;
        }
        if (z && ("com.android.vending".equals(packageInfo.packageName) || "com.google.android.gms".equals(packageInfo.packageName))) {
            ApplicationInfo applicationInfo = packageInfo.applicationInfo;
            z = (applicationInfo == null || (applicationInfo.flags & 129) == 0) ? false : true;
        }
        try {
            zzah zzahVar = z ? zzn.zzc : zzn.zzb;
            int i = AndroidUtilsLight.zza;
            if (Build.VERSION.SDK_INT < 28) {
                byte[] byteArray = null;
                if (packageInfo.signatures != null && packageInfo.signatures.length == 1) {
                    byteArray = packageInfo.signatures[0].toByteArray();
                }
                zzahVarZzj = byteArray != null ? zzah.zzk(byteArray) : zzah.zzj();
            } else {
                com.google.android.gms.internal.common.zzr.zza(Build.VERSION.SDK_INT >= 28);
                SigningInfo signingInfoM = ColorKt$.ExternalSyntheticApiModelOutline0.m(packageInfo);
                if (signingInfoM == null || signingInfoM.hasMultipleSigners() || signingInfoM.getSigningCertificateHistory() == null) {
                    zzahVarZzj = zzah.zzj();
                } else {
                    int i2 = zzah.zzd;
                    com.google.android.gms.internal.common.zzad zzadVar = new com.google.android.gms.internal.common.zzad();
                    for (Signature signature : signingInfoM.getSigningCertificateHistory()) {
                        zzadVar.zzb(signature.toByteArray());
                    }
                    zzahVarZzj = zzadVar.zzd();
                }
            }
            if (zzahVarZzj.isEmpty()) {
                throw new IllegalArgumentException("Unable to obtain package certificate history.");
            }
            zzah zzahVarZzh = zzahVarZzj.zzh();
            int size = zzahVarZzh.size();
            int i3 = 0;
            while (i3 < size) {
                byte[] bArr = (byte[]) zzahVarZzh.get(i3);
                zzal zzalVarListIterator = zzahVar.listIterator(0);
                do {
                    int i4 = i3 + 1;
                    if (!zzalVarListIterator.hasNext()) {
                        i3 = i4;
                    }
                } while (!Arrays.equals(bArr, (byte[]) zzalVarListIterator.next()));
                return true;
            }
            return false;
        } catch (IllegalArgumentException unused) {
            Log.i("GoogleSignatureVerifier", "package info is not set correctly");
            return (z ? zzc(packageInfo, zzn.zza) : zzc(packageInfo, zzn.zza[0])) != null;
        }
    }

    private final zzy zzb(@Nullable String str, boolean z, boolean z2) {
        zzy zzyVarZzc;
        if (str == null) {
            return zzy.zzc("null pkg");
        }
        if (str.equals(this.zzc)) {
            return zzy.zzb();
        }
        int i = zzo.zzh;
        StrictMode.ThreadPolicy threadPolicyAllowThreadDiskReads = StrictMode.allowThreadDiskReads();
        try {
            try {
                zzo.zzb();
                boolean zZzg = zzo.zzg.zzg();
                StrictMode.setThreadPolicy(threadPolicyAllowThreadDiskReads);
                if (zZzg) {
                    zzv zzvVar = new zzv(null);
                    zzvVar.zza(str);
                    zzvVar.zzb(GooglePlayServicesUtilLight.honorsDebugCertificates(this.zzb));
                    zzvVar.zzc(true);
                    zzyVarZzc = zzo.zzc(zzvVar.zzd());
                } else {
                    threadPolicyAllowThreadDiskReads = Build.VERSION.SDK_INT;
                    try {
                        PackageInfo packageInfo = this.zzb.getPackageManager().getPackageInfo(str, threadPolicyAllowThreadDiskReads >= 28 ? 134217792 : 64);
                        boolean zHonorsDebugCertificates = GooglePlayServicesUtilLight.honorsDebugCertificates(this.zzb);
                        if (packageInfo == null) {
                            zzyVarZzc = zzy.zzc("null pkg");
                        } else if (packageInfo.signatures == null || packageInfo.signatures.length != 1) {
                            zzyVarZzc = zzy.zzc("single cert required");
                        } else {
                            zzk zzkVar = new zzk(packageInfo.signatures[0].toByteArray());
                            String str2 = packageInfo.packageName;
                            zzy zzyVarZzd = zzo.zzd(str2, zzkVar, zHonorsDebugCertificates, false);
                            zzyVarZzc = (!zzyVarZzd.zza || packageInfo.applicationInfo == null || (packageInfo.applicationInfo.flags & 2) == 0 || !zzo.zzd(str2, zzkVar, false, true).zza) ? zzyVarZzd : zzy.zzc("debuggable release cert app rejected");
                        }
                    } catch (PackageManager.NameNotFoundException e) {
                        return zzy.zzd("no pkg ".concat(str), e);
                    }
                }
            } catch (Throwable th) {
                StrictMode.setThreadPolicy(threadPolicyAllowThreadDiskReads);
                throw th;
            }
        } catch (RemoteException | DynamiteModule.LoadingException e2) {
            Log.e("GoogleCertificates", "Failed to get Google certificates from remote", e2);
            StrictMode.setThreadPolicy(threadPolicyAllowThreadDiskReads);
        }
        if (zzyVarZzc.zza) {
            this.zzc = str;
        }
        return zzyVarZzc;
    }

    @Nullable
    private static zzj zzc(PackageInfo packageInfo, zzj... zzjVarArr) {
        if (packageInfo.signatures != null) {
            if (packageInfo.signatures.length != 1) {
                Log.w("GoogleSignatureVerifier", "Package has more than one signature.");
                return null;
            }
            zzk zzkVar = new zzk(packageInfo.signatures[0].toByteArray());
            for (int i = 0; i < zzjVarArr.length; i++) {
                if (zzjVarArr[i].equals(zzkVar)) {
                    return zzjVarArr[i];
                }
            }
        }
        return null;
    }

    public boolean isGooglePublicSignedPackage(PackageInfo packageInfo) {
        if (packageInfo == null) {
            return false;
        }
        if (zza(packageInfo, false)) {
            return true;
        }
        if (zza(packageInfo, true)) {
            if (GooglePlayServicesUtilLight.honorsDebugCertificates(this.zzb)) {
                return true;
            }
            Log.w("GoogleSignatureVerifier", "Test-keys aren't accepted on this build.");
        }
        return false;
    }

    public boolean isPackageGoogleSigned(@Nullable String str) {
        zzy zzyVarZzb = zzb(str, false, false);
        zzyVarZzb.zze();
        return zzyVarZzb.zza;
    }

    public boolean isUidGoogleSigned(int i) {
        zzy zzyVarZzc;
        String[] packagesForUid = this.zzb.getPackageManager().getPackagesForUid(i);
        if (packagesForUid == null || (packagesForUid.length) == 0) {
            zzyVarZzc = zzy.zzc("no pkgs");
        } else {
            zzyVarZzc = null;
            for (String str : packagesForUid) {
                zzyVarZzc = zzb(str, false, false);
                if (!zzyVarZzc.zza) {
                }
            }
            Preconditions.checkNotNull(zzyVarZzc);
        }
        zzyVarZzc.zze();
        return zzyVarZzc.zza;
    }
}
