package com.android.billingclient.api;

import android.R;
import android.app.Activity;
import android.app.ActivityManager;
import android.app.PendingIntent;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.graphics.Rect;
import android.os.Build;
import android.os.Bundle;
import android.os.DeadObjectException;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.os.ResultReceiver;
import android.text.TextUtils;
import android.view.View;
import androidx.core.app.BundleCompat;
import com.android.billingclient.BuildConfig;
import com.google.android.gms.internal.play_billing.zzhu;
import com.google.android.gms.internal.play_billing.zzhx;
import com.google.android.gms.internal.play_billing.zzio;
import com.google.android.gms.internal.play_billing.zziq;
import com.google.android.gms.internal.play_billing.zziu;
import com.google.android.gms.internal.play_billing.zziw;
import com.google.android.gms.internal.play_billing.zziy;
import com.google.android.gms.internal.play_billing.zzja;
import com.google.android.gms.internal.play_billing.zzjb;
import com.google.android.gms.internal.play_billing.zzjd;
import com.google.android.gms.internal.play_billing.zzjf;
import com.google.android.gms.internal.play_billing.zzjk;
import com.google.android.gms.internal.play_billing.zzjp;
import com.google.android.gms.internal.play_billing.zzjr;
import com.google.android.gms.internal.play_billing.zzjv;
import com.google.android.gms.internal.play_billing.zzjy;
import com.google.android.gms.internal.play_billing.zzks;
import com.google.android.gms.internal.play_billing.zzku;
import j$.util.Objects;
import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Random;
import java.util.concurrent.Callable;
import java.util.concurrent.CancellationException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;
import org.json.JSONException;
import org.json.JSONObject;

class BillingClientImpl extends BillingClient {
    private boolean zzA;
    private boolean zzB;
    private boolean zzC;
    private boolean zzD;
    private PendingPurchasesParams zzE;
    private boolean zzF;
    private boolean zzG;
    private volatile BillingClientStateListener zzH;
    private ExecutorService zzI;
    private final Long zzJ;
    private com.google.android.gms.internal.play_billing.zzbo zzK;
    private final Object zza;
    private volatile int zzb;
    private final String zzc;
    private final String zzd;
    private final Handler zze;
    private volatile zzab zzf;
    private Context zzg;
    private zzcz zzh;
    private volatile com.google.android.gms.internal.play_billing.zzap zzi;
    private volatile zzbw zzj;
    private boolean zzk;
    private boolean zzl;
    private int zzm;
    private boolean zzn;
    private boolean zzo;
    private boolean zzp;
    private boolean zzq;
    private boolean zzr;
    private boolean zzs;
    private boolean zzt;
    private boolean zzu;
    private boolean zzv;
    private boolean zzw;
    private boolean zzx;
    private boolean zzy;
    private boolean zzz;

    private BillingClientImpl(Activity activity, PendingPurchasesParams pendingPurchasesParams, String str, BillingClient.Builder builder) {
        this(activity.getApplicationContext(), pendingPurchasesParams, new zzci(), str, null, null, null, null, null, builder);
    }

    private void initialize(Context context, PurchasesUpdatedListener purchasesUpdatedListener, PendingPurchasesParams pendingPurchasesParams, zzb zzbVar, String str, zzcz zzczVar, BillingClient.Builder builder) {
        this.zzg = context.getApplicationContext();
        zzjp zzjpVarZza = zzjr.zza();
        zzjpVarZza.zzx(str);
        String str2 = this.zzd;
        if (str2 != null) {
            zzjpVarZza.zzy(str2);
        }
        zzjpVarZza.zzq(this.zzg.getPackageName());
        zzjpVarZza.zzd(this.zzJ.longValue());
        zzjpVarZza.zzw(builder.zza);
        zzjpVarZza.zza(Build.VERSION.SDK_INT);
        zzjpVarZza.zzp(846465066L);
        zzbo(zzjpVarZza, context);
        try {
            zzjpVarZza.zzb(this.zzg.getPackageManager().getPackageInfo(this.zzg.getPackageName(), 0).versionCode);
        } catch (Throwable th) {
            com.google.android.gms.internal.play_billing.zzc.zzp("BillingClient", "Error getting app version code.", th);
        }
        if (zzczVar != null) {
            this.zzh = zzczVar;
        } else {
            this.zzh = new zzdl(this.zzg, zzjpVarZza.zzi());
        }
        if (purchasesUpdatedListener == null) {
            com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "Billing client should have a valid listener but the provided is null.");
        }
        this.zzf = new zzab(this.zzg, purchasesUpdatedListener, null, zzbVar, null, null, this.zzh);
        this.zzE = pendingPurchasesParams;
        this.zzG = zzbVar != null;
        this.zzg.getPackageName();
        com.google.android.gms.internal.play_billing.zzbo zzboVar = builder.zzb;
        this.zzF = builder.zza;
    }

    private int launchBillingFlowCpp(Activity activity, BillingFlowParams billingFlowParams) {
        return launchBillingFlow(activity, billingFlowParams).getResponseCode();
    }

    private void startConnection(long j) {
        startConnection(new zzci(j));
    }

    public static Void zzA(BillingClientImpl billingClientImpl, AlternativeBillingOnlyInformationDialogListener alternativeBillingOnlyInformationDialogListener, Activity activity, ResultReceiver resultReceiver) throws Exception {
        billingClientImpl.zzaL(alternativeBillingOnlyInformationDialogListener, activity, resultReceiver);
        return null;
    }

    public static Void zzB(BillingClientImpl billingClientImpl, ExternalOfferAvailabilityListener externalOfferAvailabilityListener) throws Exception {
        billingClientImpl.zzaK(externalOfferAvailabilityListener);
        return null;
    }

    public static Void zzC(BillingClientImpl billingClientImpl, BillingProgramAvailabilityListener billingProgramAvailabilityListener, int i) throws Exception {
        billingClientImpl.zzaJ(billingProgramAvailabilityListener, i);
        return null;
    }

    public static Void zzD(BillingClientImpl billingClientImpl, LaunchExternalLinkResponseListener launchExternalLinkResponseListener, LaunchExternalLinkParams launchExternalLinkParams, Activity activity) {
        com.google.android.gms.internal.play_billing.zzap zzapVar;
        zzch zzchVar = null;
        try {
            if (!billingClientImpl.zzbl(30000L)) {
                billingClientImpl.zzaZ(launchExternalLinkResponseListener, zzdc.zzj, zzjd.zzb, null);
            } else if (billingClientImpl.zzD) {
                synchronized (billingClientImpl.zza) {
                    zzapVar = billingClientImpl.zzi;
                }
                if (zzapVar == null) {
                    billingClientImpl.zzaZ(launchExternalLinkResponseListener, zzdc.zzj, zzjd.zzbc, null);
                } else {
                    String packageName = billingClientImpl.zzg.getPackageName();
                    String str = billingClientImpl.zzc;
                    String str2 = billingClientImpl.zzd;
                    long jLongValue = billingClientImpl.zzJ.longValue();
                    int i = com.google.android.gms.internal.play_billing.zzc.zza;
                    Bundle bundle = new Bundle();
                    com.google.android.gms.internal.play_billing.zzc.zzc(bundle, str, str2, jLongValue);
                    zzhu zzhuVarZza = zzhx.zza();
                    zzio zzioVarZza = zziq.zza();
                    zzioVarZza.zza(launchExternalLinkParams.getLinkUri().toString());
                    zzhuVarZza.zza("externalOfferUri", zzioVarZza.zzi());
                    zzio zzioVarZza2 = zziq.zza();
                    zzioVarZza2.zza(String.valueOf(launchExternalLinkParams.getLaunchMode()));
                    zzhuVarZza.zza("externalOfferLaunchMode", zzioVarZza2.zzi());
                    zzio zzioVarZza3 = zziq.zza();
                    zzioVarZza3.zza(String.valueOf(launchExternalLinkParams.getLinkType()));
                    zzhuVarZza.zza("externalOfferLinkType", zzioVarZza3.zzi());
                    zzio zzioVarZza4 = zziq.zza();
                    zzioVarZza4.zza(String.valueOf(launchExternalLinkParams.getBillingProgram()));
                    zzhuVarZza.zza("externalOfferBillingProgram", zzioVarZza4.zzi());
                    bundle.putByteArray("REQUEST_PARAMS", zzhuVarZza.zzi().zzQ());
                    zzapVar.zzp(27, packageName, bundle, new zzcc(billingClientImpl, new WeakReference(activity), launchExternalLinkResponseListener, zzchVar));
                }
            } else {
                com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "Current client doesn't support launch external link.");
                billingClientImpl.zzaZ(launchExternalLinkResponseListener, zzdc.zzG, zzjd.zzbs, null);
            }
        } catch (RuntimeException e) {
            billingClientImpl.zzaZ(launchExternalLinkResponseListener, zzdc.zzh, zzjd.zzbb, e);
        }
        return null;
    }

    public static Void zzE(BillingClientImpl billingClientImpl, ExternalOfferReportingDetailsListener externalOfferReportingDetailsListener) throws Exception {
        billingClientImpl.zzaH(externalOfferReportingDetailsListener);
        return null;
    }

    public static Void zzF(BillingClientImpl billingClientImpl, ExternalOfferInformationDialogListener externalOfferInformationDialogListener, Activity activity, ResultReceiver resultReceiver) throws Exception {
        billingClientImpl.zzaM(externalOfferInformationDialogListener, activity, resultReceiver);
        return null;
    }

    public static Void zzG(BillingClientImpl billingClientImpl, AlternativeBillingOnlyReportingDetailsListener alternativeBillingOnlyReportingDetailsListener) throws Exception {
        billingClientImpl.zzaF(alternativeBillingOnlyReportingDetailsListener);
        return null;
    }

    public static Void zzH(BillingClientImpl billingClientImpl, BillingProgramReportingDetailsListener billingProgramReportingDetailsListener, BillingProgramReportingDetailsParams billingProgramReportingDetailsParams) throws Exception {
        billingClientImpl.zzaG(billingProgramReportingDetailsListener, billingProgramReportingDetailsParams);
        return null;
    }

    public static Void zzI(BillingClientImpl billingClientImpl, AlternativeBillingOnlyAvailabilityListener alternativeBillingOnlyAvailabilityListener) throws Exception {
        billingClientImpl.zzaI(alternativeBillingOnlyAvailabilityListener);
        return null;
    }

    static Future zzK(Callable callable, long j, final Runnable runnable, Handler handler, ExecutorService executorService) {
        try {
            final Future futureSubmit = executorService.submit(callable);
            handler.postDelayed(new Runnable() {
                @Override
                public final void run() {
                    Future future = futureSubmit;
                    if (future.isDone() || future.isCancelled()) {
                        return;
                    }
                    Runnable runnable2 = runnable;
                    future.cancel(true);
                    com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "Async task is taking too long, cancel it!");
                    if (runnable2 != null) {
                        runnable2.run();
                    }
                }
            }, (long) (j * 0.95d));
            return futureSubmit;
        } catch (Exception e) {
            com.google.android.gms.internal.play_billing.zzc.zzp("BillingClient", "Async task throws exception!", e);
            return null;
        }
    }

    public static void zzL(BillingClientImpl billingClientImpl, ConsumeResponseListener consumeResponseListener, ConsumeParams consumeParams) {
        zzjd zzjdVar = zzjd.zzx;
        BillingResult billingResult = zzdc.zzk;
        billingClientImpl.zzbs(zzjdVar, 4, billingResult);
        consumeResponseListener.onConsumeResponse(billingResult, consumeParams.getPurchaseToken());
    }

    public static void zzM(BillingClientImpl billingClientImpl, PurchasesResponseListener purchasesResponseListener) {
        zzjd zzjdVar = zzjd.zzx;
        BillingResult billingResult = zzdc.zzk;
        billingClientImpl.zzbs(zzjdVar, 9, billingResult);
        purchasesResponseListener.onQueryPurchasesResponse(billingResult, com.google.android.gms.internal.play_billing.zzbw.zzk());
    }

    public static void zzN(BillingClientImpl billingClientImpl, BillingConfigResponseListener billingConfigResponseListener) {
        zzjd zzjdVar = zzjd.zzx;
        BillingResult billingResult = zzdc.zzk;
        billingClientImpl.zzbs(zzjdVar, 13, billingResult);
        billingConfigResponseListener.onBillingConfigResponse(billingResult, null);
    }

    public static void zzR(BillingClientImpl billingClientImpl, AcknowledgePurchaseResponseListener acknowledgePurchaseResponseListener) {
        zzjd zzjdVar = zzjd.zzx;
        BillingResult billingResult = zzdc.zzk;
        billingClientImpl.zzbs(zzjdVar, 3, billingResult);
        acknowledgePurchaseResponseListener.onAcknowledgePurchaseResponse(billingResult);
    }

    public static void zzT(BillingClientImpl billingClientImpl, ProductDetailsResponseListener productDetailsResponseListener) {
        zzjd zzjdVar = zzjd.zzx;
        BillingResult billingResult = zzdc.zzk;
        billingClientImpl.zzbs(zzjdVar, 7, billingResult);
        productDetailsResponseListener.onProductDetailsResponse(billingResult, new QueryProductDetailsResult(com.google.android.gms.internal.play_billing.zzbw.zzk(), com.google.android.gms.internal.play_billing.zzbw.zzk()));
    }

    public static void zzV(BillingClientImpl billingClientImpl, BillingResult billingResult) {
        if (billingClientImpl.zzf.zzf() != null) {
            billingClientImpl.zzf.zzf().onPurchasesUpdated(billingResult, null);
        } else {
            zzab zzabVar = billingClientImpl.zzf;
            com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "No valid listener is set in BroadcastManager");
        }
    }

    private final Object zzaA(AcknowledgePurchaseResponseListener acknowledgePurchaseResponseListener, AcknowledgePurchaseParams acknowledgePurchaseParams) throws Exception {
        com.google.android.gms.internal.play_billing.zzap zzapVar;
        try {
            if (!zzbl(30000L)) {
                zzjd zzjdVar = zzjd.zzb;
                BillingResult billingResult = zzdc.zzj;
                zzbs(zzjdVar, 3, billingResult);
                acknowledgePurchaseResponseListener.onAcknowledgePurchaseResponse(billingResult);
            } else if (TextUtils.isEmpty(acknowledgePurchaseParams.getPurchaseToken())) {
                com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "Please provide a valid purchase token.");
                zzjd zzjdVar2 = zzjd.zzz;
                BillingResult billingResult2 = zzdc.zzg;
                zzbs(zzjdVar2, 3, billingResult2);
                acknowledgePurchaseResponseListener.onAcknowledgePurchaseResponse(billingResult2);
            } else if (this.zzp) {
                synchronized (this.zza) {
                    zzapVar = this.zzi;
                }
                if (zzapVar != null) {
                    String packageName = this.zzg.getPackageName();
                    String purchaseToken = acknowledgePurchaseParams.getPurchaseToken();
                    String str = this.zzc;
                    String str2 = this.zzd;
                    long jLongValue = this.zzJ.longValue();
                    int i = com.google.android.gms.internal.play_billing.zzc.zza;
                    Bundle bundle = new Bundle();
                    com.google.android.gms.internal.play_billing.zzc.zzc(bundle, str, str2, jLongValue);
                    Bundle bundleZzd = zzapVar.zzd(9, packageName, purchaseToken, bundle);
                    acknowledgePurchaseResponseListener.onAcknowledgePurchaseResponse(zzdc.zza(com.google.android.gms.internal.play_billing.zzc.zzb(bundleZzd, "BillingClient"), com.google.android.gms.internal.play_billing.zzc.zzk(bundleZzd, "BillingClient")));
                    return null;
                }
                zzaP(acknowledgePurchaseResponseListener, zzdc.zzj, zzjd.zzbc, null);
            } else {
                zzjd zzjdVar3 = zzjd.zzA;
                BillingResult billingResult3 = zzdc.zza;
                zzbs(zzjdVar3, 3, billingResult3);
                acknowledgePurchaseResponseListener.onAcknowledgePurchaseResponse(billingResult3);
            }
            return null;
        } catch (DeadObjectException e) {
            zzaP(acknowledgePurchaseResponseListener, zzdc.zzj, zzjd.zzB, e);
            return null;
        } catch (Exception e2) {
            zzaP(acknowledgePurchaseResponseListener, zzdc.zzh, zzjd.zzB, e2);
            return null;
        }
    }

    private final Object zzaB(BillingConfigResponseListener billingConfigResponseListener) throws Exception {
        com.google.android.gms.internal.play_billing.zzap zzapVar;
        zzch zzchVar = null;
        try {
            if (!zzbl(30000L)) {
                com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "Service disconnected.");
                zzjd zzjdVar = zzjd.zzb;
                BillingResult billingResult = zzdc.zzj;
                zzbs(zzjdVar, 13, billingResult);
                billingConfigResponseListener.onBillingConfigResponse(billingResult, null);
            } else if (this.zzv) {
                synchronized (this.zza) {
                    zzapVar = this.zzi;
                }
                if (zzapVar == null) {
                    zzaY(billingConfigResponseListener, zzdc.zzj, zzjd.zzbc, null);
                } else {
                    String packageName = this.zzg.getPackageName();
                    String str = this.zzc;
                    String str2 = this.zzd;
                    long jLongValue = this.zzJ.longValue();
                    int i = com.google.android.gms.internal.play_billing.zzc.zza;
                    Bundle bundle = new Bundle();
                    com.google.android.gms.internal.play_billing.zzc.zzc(bundle, str, str2, jLongValue);
                    zzapVar.zzo(18, packageName, bundle, new zzca(billingConfigResponseListener, this.zzh, this.zzm, zzchVar));
                }
            } else {
                com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "Current client doesn't support get billing config.");
                zzjd zzjdVar2 = zzjd.zzF;
                BillingResult billingResult2 = zzdc.zzy;
                zzbs(zzjdVar2, 13, billingResult2);
                billingConfigResponseListener.onBillingConfigResponse(billingResult2, null);
            }
        } catch (DeadObjectException e) {
            zzaY(billingConfigResponseListener, zzdc.zzj, zzjd.zzaj, e);
        } catch (Exception e2) {
            zzaY(billingConfigResponseListener, zzdc.zzh, zzjd.zzaj, e2);
        }
        return null;
    }

    private final Object zzaC(Bundle bundle, Activity activity, ResultReceiver resultReceiver) throws Exception {
        com.google.android.gms.internal.play_billing.zzap zzapVar;
        try {
            synchronized (this.zza) {
                zzapVar = this.zzi;
            }
            if (zzapVar == null) {
                zzbb(-1, zzjd.zzbc, null);
            } else {
                zzapVar.zzs(12, this.zzg.getPackageName(), bundle, new zzcf(new WeakReference(activity), resultReceiver, null));
            }
        } catch (DeadObjectException e) {
            zzbb(-1, zzjd.zzbb, e);
        } catch (Exception e2) {
            zzbb(6, zzjd.zzbb, e2);
        }
        return null;
    }

    private final String zzaD(QueryProductDetailsParams queryProductDetailsParams) {
        if (TextUtils.isEmpty(null)) {
            return this.zzg.getPackageName();
        }
        return null;
    }

    private static String zzaE() {
        try {
            return (String) Class.forName("com.android.billingclient.ktx.BuildConfig").getField("VERSION_NAME").get(null);
        } catch (Exception unused) {
            return null;
        }
    }

    private final Void zzaF(AlternativeBillingOnlyReportingDetailsListener alternativeBillingOnlyReportingDetailsListener) throws Exception {
        com.google.android.gms.internal.play_billing.zzap zzapVar;
        zzch zzchVar = null;
        try {
            if (!zzbl(30000L)) {
                zzaT(alternativeBillingOnlyReportingDetailsListener, zzdc.zzj, zzjd.zzb, null);
            } else if (this.zzy) {
                synchronized (this.zza) {
                    zzapVar = this.zzi;
                }
                if (zzapVar == null) {
                    zzaT(alternativeBillingOnlyReportingDetailsListener, zzdc.zzj, zzjd.zzbc, null);
                } else {
                    zzapVar.zzk(21, this.zzg.getPackageName(), com.google.android.gms.internal.play_billing.zzc.zzh(this.zzc, this.zzd, this.zzJ.longValue()), new zzbx(alternativeBillingOnlyReportingDetailsListener, this.zzh, this.zzm, zzchVar));
                }
            } else {
                com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "Current client doesn't support alternative billing only.");
                zzaT(alternativeBillingOnlyReportingDetailsListener, zzdc.zzC, zzjd.zzan, null);
            }
        } catch (DeadObjectException e) {
            zzaT(alternativeBillingOnlyReportingDetailsListener, zzdc.zzj, zzjd.zzar, e);
        } catch (Exception e2) {
            zzaT(alternativeBillingOnlyReportingDetailsListener, zzdc.zzh, zzjd.zzar, e2);
        }
        return null;
    }

    private final Void zzaG(BillingProgramReportingDetailsListener billingProgramReportingDetailsListener, BillingProgramReportingDetailsParams billingProgramReportingDetailsParams) throws Exception {
        com.google.android.gms.internal.play_billing.zzap zzapVar;
        try {
            if (!zzbl(30000L)) {
                zzaU(billingProgramReportingDetailsListener, zzdc.zzj, zzjd.zzb, null);
            } else if (this.zzD) {
                synchronized (this.zza) {
                    zzapVar = this.zzi;
                }
                if (zzapVar == null) {
                    zzaU(billingProgramReportingDetailsListener, zzdc.zzj, zzjd.zzbc, null);
                } else {
                    String str = this.zzc;
                    com.google.android.gms.internal.play_billing.zzdy zzdyVarZzb = zzdg.zzb(str, 24, this.zzg, zzdf.CREATE_BILLING_PROGRAM_REPORTING_DETAILS_ASYNC.zza());
                    zzhu zzhuVarZza = zzhx.zza();
                    zzio zzioVarZza = zziq.zza();
                    zzioVarZza.zza(str);
                    zzhuVarZza.zza("PLAY_BILLING_LIBRARY_VERSION", zzioVarZza.zzi());
                    zzio zzioVarZza2 = zziq.zza();
                    zzioVarZza2.zza(this.zzg.getPackageName());
                    zzhuVarZza.zza("CALLING_PACKAGE", zzioVarZza2.zzi());
                    zzio zzioVarZza3 = zziq.zza();
                    zzioVarZza3.zza(String.valueOf(billingProgramReportingDetailsParams.getBillingProgram()));
                    zzhuVarZza.zza("BILLING_PROGRAM", zzioVarZza3.zzi());
                    zzio zzioVarZza4 = zziq.zza();
                    zzioVarZza4.zza("RESPONSE_FORMAT_PROTO");
                    zzhuVarZza.zza("RESPONSE_FORMAT", zzioVarZza4.zzi());
                    if (billingProgramReportingDetailsParams.getBillingProgram() == 3) {
                        zzio zzioVarZza5 = zziq.zza();
                        zzioVarZza5.zza(String.valueOf(this.zzg.getPackageManager().getPackageInfo(this.zzg.getPackageName(), 0).firstInstallTime));
                        zzhuVarZza.zza("APP_INSTALL_TIME_MILLIS", zzioVarZza5.zzi());
                    }
                    zzapVar.zzm(zzdg.zza(zzdyVarZzb, zzhuVarZza.zzi()), new CreateBillingProgramReportingDetailsDelegateToBackendCallback(billingProgramReportingDetailsListener, billingProgramReportingDetailsParams.getBillingProgram(), this.zzh, this.zzm, zzav(), zzJ()));
                }
            } else {
                com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "Current client doesn't support the provided billing program.");
                zzaU(billingProgramReportingDetailsListener, zzdc.zzF, zzjd.zzbp, null);
            }
        } catch (DeadObjectException e) {
            zzaU(billingProgramReportingDetailsListener, zzdc.zzj, zzjd.zzbb, e);
        } catch (RuntimeException e2) {
            zzaU(billingProgramReportingDetailsListener, zzdc.zzh, zzjd.zzbb, e2);
        }
        return null;
    }

    private final Void zzaH(ExternalOfferReportingDetailsListener externalOfferReportingDetailsListener) throws Exception {
        com.google.android.gms.internal.play_billing.zzap zzapVar;
        zzch zzchVar = null;
        try {
            if (!zzbl(30000L)) {
                zzaV(externalOfferReportingDetailsListener, zzdc.zzj, zzjd.zzb, null);
            } else if (this.zzz) {
                synchronized (this.zza) {
                    zzapVar = this.zzi;
                }
                if (zzapVar == null) {
                    zzaV(externalOfferReportingDetailsListener, zzdc.zzj, zzjd.zzbc, null);
                } else {
                    String packageName = this.zzg.getPackageName();
                    long j = this.zzg.getPackageManager().getPackageInfo(this.zzg.getPackageName(), 0).firstInstallTime;
                    String str = this.zzc;
                    String str2 = this.zzd;
                    long jLongValue = this.zzJ.longValue();
                    int i = com.google.android.gms.internal.play_billing.zzc.zza;
                    Bundle bundle = new Bundle();
                    com.google.android.gms.internal.play_billing.zzc.zzc(bundle, str, str2, jLongValue);
                    bundle.putLong("appInstallTimeMillis", j);
                    zzapVar.zzl(22, packageName, bundle, new zzby(externalOfferReportingDetailsListener, this.zzh, this.zzm, zzchVar));
                }
            } else {
                com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "Current client doesn't support external offer.");
                zzaV(externalOfferReportingDetailsListener, zzdc.zzt, zzjd.zzaE, null);
            }
        } catch (DeadObjectException e) {
            zzaV(externalOfferReportingDetailsListener, zzdc.zzj, zzjd.zzaF, e);
        } catch (Exception e2) {
            zzaV(externalOfferReportingDetailsListener, zzdc.zzh, zzjd.zzaF, e2);
        }
        return null;
    }

    private final Void zzaI(AlternativeBillingOnlyAvailabilityListener alternativeBillingOnlyAvailabilityListener) throws Exception {
        com.google.android.gms.internal.play_billing.zzap zzapVar;
        try {
            if (!zzbl(30000L)) {
                zzaQ(alternativeBillingOnlyAvailabilityListener, zzdc.zzj, zzjd.zzb, null);
            } else if (this.zzy) {
                synchronized (this.zza) {
                    zzapVar = this.zzi;
                }
                if (zzapVar == null) {
                    zzaQ(alternativeBillingOnlyAvailabilityListener, zzdc.zzj, zzjd.zzbc, null);
                } else {
                    zzapVar.zzq(21, this.zzg.getPackageName(), com.google.android.gms.internal.play_billing.zzc.zzh(this.zzc, this.zzd, this.zzJ.longValue()), new zzcd(alternativeBillingOnlyAvailabilityListener, this.zzh, this.zzm, null));
                }
            } else {
                com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "Current client doesn't support alternative billing only.");
                zzaQ(alternativeBillingOnlyAvailabilityListener, zzdc.zzC, zzjd.zzan, null);
            }
        } catch (DeadObjectException e) {
            zzaQ(alternativeBillingOnlyAvailabilityListener, zzdc.zzj, zzjd.zzaq, e);
        } catch (Exception e2) {
            zzaQ(alternativeBillingOnlyAvailabilityListener, zzdc.zzh, zzjd.zzaq, e2);
        }
        return null;
    }

    private final Void zzaJ(BillingProgramAvailabilityListener billingProgramAvailabilityListener, int i) throws Exception {
        com.google.android.gms.internal.play_billing.zzap zzapVar;
        try {
            if (!zzbl(30000L)) {
                zzaR(billingProgramAvailabilityListener, i, zzdc.zzj, zzjd.zzb, null);
                return null;
            }
            if (!this.zzD) {
                com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "Current client doesn't support the provided billing program.");
                zzaR(billingProgramAvailabilityListener, i, zzdc.zzF, zzjd.zzbp, null);
                return null;
            }
            synchronized (this.zza) {
                zzapVar = this.zzi;
            }
            if (zzapVar == null) {
                zzaR(billingProgramAvailabilityListener, i, zzdc.zzj, zzjd.zzbc, null);
                return null;
            }
            String str = this.zzc;
            com.google.android.gms.internal.play_billing.zzdy zzdyVarZzb = zzdg.zzb(str, 24, this.zzg, zzdf.IS_BILLING_PROGRAM_AVAILABLE_ASYNC.zza());
            zzhu zzhuVarZza = zzhx.zza();
            zzio zzioVarZza = zziq.zza();
            zzioVarZza.zza(str);
            zzhuVarZza.zza("PLAY_BILLING_LIBRARY_VERSION", zzioVarZza.zzi());
            zzio zzioVarZza2 = zziq.zza();
            zzioVarZza2.zza(this.zzg.getPackageName());
            zzhuVarZza.zza("CALLING_PACKAGE", zzioVarZza2.zzi());
            zzio zzioVarZza3 = zziq.zza();
            zzioVarZza3.zza(String.valueOf(i));
            zzhuVarZza.zza("BILLING_PROGRAM", zzioVarZza3.zzi());
            zzapVar.zzm(zzdg.zza(zzdyVarZzb, zzhuVarZza.zzi()), new IsBillingProgramAvailableDelegateToBackendCallback(billingProgramAvailabilityListener, i, this.zzh, this.zzm, zzav(), zzJ()));
            return null;
        } catch (DeadObjectException e) {
            zzaR(billingProgramAvailabilityListener, i, zzdc.zzj, zzjd.zzaj, e);
            return null;
        } catch (Exception e2) {
            zzaR(billingProgramAvailabilityListener, i, zzdc.zzh, zzjd.zzbb, e2);
            return null;
        }
    }

    private final Void zzaK(ExternalOfferAvailabilityListener externalOfferAvailabilityListener) throws Exception {
        com.google.android.gms.internal.play_billing.zzap zzapVar;
        try {
            if (!zzbl(30000L)) {
                zzaW(externalOfferAvailabilityListener, zzdc.zzj, zzjd.zzb, null);
            } else if (this.zzB) {
                synchronized (this.zza) {
                    zzapVar = this.zzi;
                }
                if (zzapVar == null) {
                    zzaW(externalOfferAvailabilityListener, zzdc.zzj, zzjd.zzbc, null);
                } else {
                    zzapVar.zzr(24, this.zzg.getPackageName(), com.google.android.gms.internal.play_billing.zzc.zzh(this.zzc, this.zzd, this.zzJ.longValue()), new zzce(externalOfferAvailabilityListener, this.zzh, this.zzm, null));
                }
            } else {
                com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "Current client doesn't support external offer.");
                zzaW(externalOfferAvailabilityListener, zzdc.zzt, zzjd.zzaE, null);
            }
        } catch (DeadObjectException e) {
            zzaW(externalOfferAvailabilityListener, zzdc.zzj, zzjd.zzaC, e);
        } catch (Exception e2) {
            zzaW(externalOfferAvailabilityListener, zzdc.zzh, zzjd.zzaC, e2);
        }
        return null;
    }

    private final Void zzaL(AlternativeBillingOnlyInformationDialogListener alternativeBillingOnlyInformationDialogListener, Activity activity, ResultReceiver resultReceiver) throws Exception {
        com.google.android.gms.internal.play_billing.zzap zzapVar;
        try {
            synchronized (this.zza) {
                zzapVar = this.zzi;
            }
            if (zzapVar == null) {
                zzba(alternativeBillingOnlyInformationDialogListener, zzdc.zzj, zzjd.zzbc, null);
            } else {
                zzapVar.zzn(21, this.zzg.getPackageName(), com.google.android.gms.internal.play_billing.zzc.zzh(this.zzc, this.zzd, this.zzJ.longValue()), new zzbz(new WeakReference(activity), resultReceiver, null));
            }
        } catch (DeadObjectException e) {
            zzba(alternativeBillingOnlyInformationDialogListener, zzdc.zzj, zzjd.zzav, e);
        } catch (Exception e2) {
            zzba(alternativeBillingOnlyInformationDialogListener, zzdc.zzh, zzjd.zzav, e2);
        }
        return null;
    }

    private final Void zzaM(ExternalOfferInformationDialogListener externalOfferInformationDialogListener, Activity activity, ResultReceiver resultReceiver) throws Exception {
        com.google.android.gms.internal.play_billing.zzap zzapVar;
        try {
            synchronized (this.zza) {
                zzapVar = this.zzi;
            }
            if (zzapVar == null) {
                zzaX(externalOfferInformationDialogListener, zzdc.zzj, zzjd.zzbc, null);
            } else {
                zzapVar.zzp(22, this.zzg.getPackageName(), com.google.android.gms.internal.play_billing.zzc.zzh(this.zzc, this.zzd, this.zzJ.longValue()), new zzcb(new WeakReference(activity), resultReceiver, null));
            }
        } catch (DeadObjectException e) {
            zzaX(externalOfferInformationDialogListener, zzdc.zzj, zzjd.zzaJ, e);
        } catch (Exception e2) {
            zzaX(externalOfferInformationDialogListener, zzdc.zzh, zzjd.zzaJ, e2);
        }
        return null;
    }

    private final Future zzaN(Callable callable, long j, final Runnable runnable, Handler handler) throws Exception {
        try {
            final Future futureSubmit = zzJ().submit(callable);
            handler.postDelayed(new Runnable() {
                @Override
                public final void run() {
                    Future future = futureSubmit;
                    if (future.isDone() || future.isCancelled()) {
                        return;
                    }
                    Runnable runnable2 = runnable;
                    future.cancel(true);
                    com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "Async task is taking too long, cancel it!");
                    runnable2.run();
                }
            }, 28500L);
            return futureSubmit;
        } catch (Exception e) {
            com.google.android.gms.internal.play_billing.zzc.zzp("BillingClient", "Async task throws exception!", e);
            throw e;
        }
    }

    private final void zzaO(ConsumeParams consumeParams, ConsumeResponseListener consumeResponseListener) {
        com.google.android.gms.internal.play_billing.zzap zzapVar;
        int iZza;
        String strZzk;
        String purchaseToken = consumeParams.getPurchaseToken();
        try {
            com.google.android.gms.internal.play_billing.zzc.zzn("BillingClient", "Consuming purchase with token: " + purchaseToken);
            synchronized (this.zza) {
                zzapVar = this.zzi;
            }
            if (zzapVar == null) {
                zzaS(consumeResponseListener, purchaseToken, zzdc.zzj, zzjd.zzbc, "Service has been reset to null.", null);
                return;
            }
            if (this.zzp) {
                String packageName = this.zzg.getPackageName();
                boolean z = this.zzp;
                String str = this.zzc;
                String str2 = this.zzd;
                long jLongValue = this.zzJ.longValue();
                Bundle bundle = new Bundle();
                if (z) {
                    com.google.android.gms.internal.play_billing.zzc.zzc(bundle, str, str2, jLongValue);
                }
                Bundle bundleZze = zzapVar.zze(9, packageName, purchaseToken, bundle);
                iZza = bundleZze.getInt("RESPONSE_CODE");
                strZzk = com.google.android.gms.internal.play_billing.zzc.zzk(bundleZze, "BillingClient");
            } else {
                iZza = zzapVar.zza(3, this.zzg.getPackageName(), purchaseToken);
                strZzk = "";
            }
            BillingResult billingResultZza = zzdc.zza(iZza, strZzk);
            if (iZza == 0) {
                com.google.android.gms.internal.play_billing.zzc.zzn("BillingClient", "Successfully consumed purchase.");
                consumeResponseListener.onConsumeResponse(billingResultZza, purchaseToken);
            } else {
                zzaS(consumeResponseListener, purchaseToken, billingResultZza, zzjd.zzw, "Error consuming purchase with token. Response code: " + iZza, null);
            }
        } catch (DeadObjectException e) {
            zzaS(consumeResponseListener, purchaseToken, zzdc.zzj, zzjd.zzC, "Error consuming purchase!", e);
        } catch (Exception e2) {
            zzaS(consumeResponseListener, purchaseToken, zzdc.zzh, zzjd.zzC, "Error consuming purchase!", e2);
        }
    }

    private final void zzaP(AcknowledgePurchaseResponseListener acknowledgePurchaseResponseListener, BillingResult billingResult, zzjd zzjdVar, Exception exc) {
        com.google.android.gms.internal.play_billing.zzc.zzp("BillingClient", "Error in acknowledge purchase!", exc);
        zzbu(zzjdVar, 3, billingResult, zzcy.zza(exc));
        acknowledgePurchaseResponseListener.onAcknowledgePurchaseResponse(billingResult);
    }

    public final void zzaQ(AlternativeBillingOnlyAvailabilityListener alternativeBillingOnlyAvailabilityListener, BillingResult billingResult, zzjd zzjdVar, Exception exc) {
        zzbu(zzjdVar, 14, billingResult, zzcy.zza(exc));
        alternativeBillingOnlyAvailabilityListener.onAlternativeBillingOnlyAvailabilityResponse(billingResult);
    }

    public final void zzaR(BillingProgramAvailabilityListener billingProgramAvailabilityListener, int i, BillingResult billingResult, zzjd zzjdVar, Exception exc) {
        zzbu(zzjdVar, 33, billingResult, zzcy.zza(exc));
        billingProgramAvailabilityListener.onBillingProgramAvailabilityResponse(billingResult, new BillingProgramAvailabilityDetails(i));
    }

    private final void zzaS(ConsumeResponseListener consumeResponseListener, String str, BillingResult billingResult, zzjd zzjdVar, String str2, Exception exc) {
        com.google.android.gms.internal.play_billing.zzc.zzp("BillingClient", str2, exc);
        zzbu(zzjdVar, 4, billingResult, zzcy.zza(exc));
        consumeResponseListener.onConsumeResponse(billingResult, str);
    }

    public final void zzaT(AlternativeBillingOnlyReportingDetailsListener alternativeBillingOnlyReportingDetailsListener, BillingResult billingResult, zzjd zzjdVar, Exception exc) {
        zzbu(zzjdVar, 15, billingResult, zzcy.zza(exc));
        alternativeBillingOnlyReportingDetailsListener.onAlternativeBillingOnlyTokenResponse(billingResult, null);
    }

    public final void zzaU(BillingProgramReportingDetailsListener billingProgramReportingDetailsListener, BillingResult billingResult, zzjd zzjdVar, Exception exc) {
        zzbu(zzjdVar, 35, billingResult, zzcy.zza(exc));
        billingProgramReportingDetailsListener.onCreateBillingProgramReportingDetailsResponse(billingResult, null);
    }

    public final void zzaV(ExternalOfferReportingDetailsListener externalOfferReportingDetailsListener, BillingResult billingResult, zzjd zzjdVar, Exception exc) {
        zzbu(zzjdVar, 24, billingResult, zzcy.zza(exc));
        externalOfferReportingDetailsListener.onExternalOfferReportingDetailsResponse(billingResult, null);
    }

    public final void zzaW(ExternalOfferAvailabilityListener externalOfferAvailabilityListener, BillingResult billingResult, zzjd zzjdVar, Exception exc) {
        zzbu(zzjdVar, 23, billingResult, zzcy.zza(exc));
        externalOfferAvailabilityListener.onExternalOfferAvailabilityResponse(billingResult);
    }

    public final void zzaX(ExternalOfferInformationDialogListener externalOfferInformationDialogListener, BillingResult billingResult, zzjd zzjdVar, Exception exc) {
        zzbu(zzjdVar, 25, billingResult, zzcy.zza(exc));
        externalOfferInformationDialogListener.onExternalOfferInformationDialogResponse(billingResult);
    }

    private final void zzaY(BillingConfigResponseListener billingConfigResponseListener, BillingResult billingResult, zzjd zzjdVar, Exception exc) {
        com.google.android.gms.internal.play_billing.zzc.zzp("BillingClient", "getBillingConfig got an exception.", exc);
        zzbu(zzjdVar, 13, billingResult, zzcy.zza(exc));
        billingConfigResponseListener.onBillingConfigResponse(billingResult, null);
    }

    public final void zzaZ(LaunchExternalLinkResponseListener launchExternalLinkResponseListener, BillingResult billingResult, zzjd zzjdVar, Exception exc) {
        zzbu(zzjdVar, 37, billingResult, zzcy.zza(exc));
        launchExternalLinkResponseListener.onLaunchExternalLinkResponse(billingResult);
    }

    static void zzak(BillingClientImpl billingClientImpl, int i) {
        billingClientImpl.zzm = i;
        billingClientImpl.zzD = i >= 27;
        billingClientImpl.zzC = i >= 26;
        billingClientImpl.zzB = i >= 24;
        billingClientImpl.zzA = i >= 23;
        billingClientImpl.zzz = i >= 22;
        billingClientImpl.zzy = i >= 21;
        billingClientImpl.zzx = i >= 20;
        billingClientImpl.zzw = i >= 19;
        billingClientImpl.zzv = i >= 18;
        billingClientImpl.zzu = i >= 17;
        billingClientImpl.zzt = i >= 16;
        billingClientImpl.zzs = i >= 15;
        billingClientImpl.zzr = i >= 14;
        billingClientImpl.zzq = i >= 12;
        billingClientImpl.zzp = i >= 9;
        billingClientImpl.zzo = i >= 8;
        billingClientImpl.zzn = i >= 6;
    }

    static void zzam(BillingClientImpl billingClientImpl, int i) {
        if (i != 0) {
            billingClientImpl.zzbg(0);
            return;
        }
        synchronized (billingClientImpl.zza) {
            if (billingClientImpl.zzb == 3) {
                return;
            }
            billingClientImpl.zzbg(2);
            zzab zzabVar = billingClientImpl.zzf != null ? billingClientImpl.zzf : null;
            if (zzabVar != null) {
                zzabVar.zzi(billingClientImpl.zzy);
            }
        }
    }

    static boolean zzaq(BillingClientImpl billingClientImpl) {
        boolean z;
        synchronized (billingClientImpl.zza) {
            z = true;
            if (billingClientImpl.zzb != 1) {
                z = false;
            }
        }
        return z;
    }

    public final Bundle zzat(int i, String str, String str2, BillingFlowParams billingFlowParams, Bundle bundle) throws Exception {
        com.google.android.gms.internal.play_billing.zzap zzapVar;
        try {
            synchronized (this.zza) {
                zzapVar = this.zzi;
            }
            return zzapVar == null ? com.google.android.gms.internal.play_billing.zzc.zzd(zzdc.zzj, zzjd.zzbc) : zzapVar.zzg(i, this.zzg.getPackageName(), str, str2, (String) null, bundle);
        } catch (DeadObjectException e) {
            return com.google.android.gms.internal.play_billing.zzc.zze(zzdc.zzj, zzjd.zze, zzcy.zza(e));
        } catch (Exception e2) {
            return com.google.android.gms.internal.play_billing.zzc.zze(zzdc.zzh, zzjd.zze, zzcy.zza(e2));
        }
    }

    public final Bundle zzau(String str, String str2) throws Exception {
        com.google.android.gms.internal.play_billing.zzap zzapVar;
        try {
            synchronized (this.zza) {
                zzapVar = this.zzi;
            }
            return zzapVar == null ? com.google.android.gms.internal.play_billing.zzc.zzd(zzdc.zzj, zzjd.zzbc) : zzapVar.zzf(3, this.zzg.getPackageName(), str, str2, (String) null);
        } catch (DeadObjectException e) {
            return com.google.android.gms.internal.play_billing.zzc.zze(zzdc.zzj, zzjd.zze, zzcy.zza(e));
        } catch (Exception e2) {
            return com.google.android.gms.internal.play_billing.zzc.zze(zzdc.zzh, zzjd.zze, zzcy.zza(e2));
        }
    }

    public final Handler zzav() {
        return Looper.myLooper() == null ? this.zze : new Handler(Looper.myLooper());
    }

    private final zzcg zzaw(BillingResult billingResult, zzjd zzjdVar, String str, Exception exc) {
        com.google.android.gms.internal.play_billing.zzc.zzp("BillingClient", str, exc);
        zzbu(zzjdVar, 7, billingResult, zzcy.zza(exc));
        return new zzcg(billingResult.getResponseCode(), billingResult.getDebugMessage(), new ArrayList(), new ArrayList());
    }

    private final BillingResult zzax(int i) {
        com.google.android.gms.internal.play_billing.zzc.zzn("BillingClient", "Service connection is valid. No need to re-initialize.");
        zziy zziyVarZza = zzja.zza();
        zziyVarZza.zze(6);
        zzks zzksVarZza = zzku.zza();
        zzksVarZza.zze(true);
        zzksVarZza.zza(i > 0);
        zzksVarZza.zzb(i);
        zziyVarZza.zzd(zzksVarZza);
        zzbe((zzja) zziyVarZza.zzi());
        return zzdc.zzi;
    }

    public final BillingResult zzay() {
        BillingResult billingResult;
        int[] iArr = {0, 3};
        synchronized (this.zza) {
            for (int i = 0; i < 2; i++) {
                if (this.zzb == iArr[i]) {
                    billingResult = zzdc.zzj;
                }
            }
            billingResult = zzdc.zzh;
        }
        return billingResult;
    }

    private final com.google.android.gms.internal.play_billing.zzdc zzaz(final int i) {
        if (this.zzF && !zzbm()) {
            return com.google.android.gms.internal.play_billing.zzu.zza(new com.google.android.gms.internal.play_billing.zzr() {
                public final Object zza(com.google.android.gms.internal.play_billing.zzp zzpVar) {
                    return BillingClientImpl.zzr(this.zza, i, zzpVar);
                }
            });
        }
        com.google.android.gms.internal.play_billing.zzc.zzn("BillingClient", "Already connected or not opted into auto reconnection.");
        return com.google.android.gms.internal.play_billing.zzcx.zza(zzdc.zzi);
    }

    public final void zzba(AlternativeBillingOnlyInformationDialogListener alternativeBillingOnlyInformationDialogListener, BillingResult billingResult, zzjd zzjdVar, Exception exc) {
        zzbu(zzjdVar, 16, billingResult, zzcy.zza(exc));
        alternativeBillingOnlyInformationDialogListener.onAlternativeBillingOnlyInformationDialogResponse(billingResult);
    }

    private final void zzbb(int i, zzjd zzjdVar, Exception exc) {
        zziw zziwVar;
        com.google.android.gms.internal.play_billing.zzc.zzp("BillingClient", "showInAppMessages error.", exc);
        zzcz zzczVar = this.zzh;
        String strZza = zzcy.zza(exc);
        try {
            zzjb zzjbVarZza = zzjf.zza();
            zzjbVarZza.zzp(i);
            if (zzjdVar != null) {
                zzjbVarZza.zze(zzjdVar);
            }
            if (strZza != null) {
                zzjbVarZza.zza(strZza);
            }
            zziu zziuVarZza = zziw.zza();
            zziuVarZza.zzb(zzjbVarZza);
            zziuVarZza.zzp(30);
            zziwVar = (zziw) zziuVarZza.zzi();
        } catch (Throwable th) {
            com.google.android.gms.internal.play_billing.zzc.zzp("BillingLogger", "Unable to create logging payload", th);
            zziwVar = null;
        }
        zzczVar.zza(zziwVar);
    }

    public final void zzbc(zziw zziwVar) {
        try {
            this.zzh.zzb(zziwVar, this.zzm);
        } catch (Throwable th) {
            com.google.android.gms.internal.play_billing.zzc.zzp("BillingClient", "Unable to log.", th);
        }
    }

    private final void zzbd(zziw zziwVar, long j, boolean z) {
        try {
            this.zzh.zze(zziwVar, this.zzm, j, z);
        } catch (Throwable th) {
            com.google.android.gms.internal.play_billing.zzc.zzp("BillingClient", "Unable to log.", th);
        }
    }

    public final void zzbe(zzja zzjaVar) {
        try {
            this.zzh.zzg(zzjaVar, this.zzm);
        } catch (Throwable th) {
            com.google.android.gms.internal.play_billing.zzc.zzp("BillingClient", "Unable to log.", th);
        }
    }

    public final void zzbf(zzjd zzjdVar, BillingResult billingResult, int i) {
        try {
            int i2 = zzcy.zza;
            zziu zziuVarZzq = zzcy.zzb(zzjdVar, 6, billingResult, null, zzjk.zza).zzq();
            zzks zzksVarZza = zzku.zza();
            zzksVarZza.zza(i > 0);
            zzksVarZza.zzb(i);
            zziuVarZzq.zze(zzksVarZza);
            zzbc((zziw) zziuVarZzq.zzi());
        } catch (Throwable th) {
            com.google.android.gms.internal.play_billing.zzc.zzp("BillingClient", "Unable to log.", th);
        }
    }

    public final void zzbg(int i) {
        synchronized (this.zza) {
            if (this.zzb == 3) {
                return;
            }
            com.google.android.gms.internal.play_billing.zzc.zzn("BillingClient", "Setting clientState from " + zzbn(this.zzb) + " to " + zzbn(i));
            this.zzb = i;
        }
    }

    private final synchronized void zzbh() {
        ExecutorService executorService = this.zzI;
        if (executorService != null) {
            executorService.shutdownNow();
            this.zzI = null;
        }
    }

    private final void zzbi(BillingClientStateListener billingClientStateListener, int i) {
        zzjd zzjdVar;
        BillingResult billingResultZzax;
        BillingResult billingResult;
        synchronized (this.zza) {
            if (zzbm()) {
                billingResultZzax = zzax(i);
            } else {
                if (this.zzb == 1) {
                    com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "Client is already in the process of connecting to billing service.");
                    zzjd zzjdVar2 = zzjd.zzK;
                    billingResult = zzdc.zzd;
                    zzbf(zzjdVar2, billingResult, i);
                } else if (this.zzb == 3) {
                    com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "Client was already closed and can't be reused. Please create another instance.");
                    zzjd zzjdVar3 = zzjd.zzL;
                    billingResult = zzdc.zzj;
                    zzbf(zzjdVar3, billingResult, i);
                } else {
                    zzbg(1);
                    if (i == 0) {
                        this.zzH = billingClientStateListener;
                        i = 0;
                    }
                    zzbj();
                    com.google.android.gms.internal.play_billing.zzc.zzn("BillingClient", "Starting in-app billing setup.");
                    this.zzj = new zzbw(this, billingClientStateListener, i, null);
                    this.zzj.zzc();
                    Intent intent = new Intent("com.android.vending.billing.InAppBillingService.BIND");
                    intent.setPackage("com.android.vending");
                    List<ResolveInfo> listQueryIntentServices = this.zzg.getPackageManager().queryIntentServices(intent, 0);
                    if (listQueryIntentServices == null || listQueryIntentServices.isEmpty()) {
                        zzjdVar = zzjd.zzO;
                    } else {
                        ResolveInfo resolveInfo = listQueryIntentServices.get(0);
                        if (resolveInfo.serviceInfo != null) {
                            String str = resolveInfo.serviceInfo.packageName;
                            String str2 = resolveInfo.serviceInfo.name;
                            if (!Objects.equals(str, "com.android.vending") || str2 == null) {
                                zzjdVar = zzjd.zzN;
                                com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "The device doesn't have valid Play Store.");
                            } else {
                                ComponentName componentName = new ComponentName(str, str2);
                                Intent intent2 = new Intent(intent);
                                intent2.setComponent(componentName);
                                intent2.putExtra("playBillingLibraryVersion", this.zzc);
                                synchronized (this.zza) {
                                    if (this.zzb == 2) {
                                        billingResultZzax = zzax(i);
                                    } else if (this.zzb != 1) {
                                        com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "Client state no longer CONNECTING, returning service disconnected.");
                                        zzjd zzjdVar4 = zzjd.zzba;
                                        billingResult = zzdc.zzj;
                                        zzbf(zzjdVar4, billingResult, i);
                                    } else {
                                        zzbw zzbwVar = this.zzj;
                                        if ((i <= 0 || Build.VERSION.SDK_INT < 29) ? this.zzg.bindService(intent2, zzbwVar, 1) : this.zzg.bindService(intent2, 1, zzJ(), zzbwVar)) {
                                            com.google.android.gms.internal.play_billing.zzc.zzn("BillingClient", "Service was bonded successfully.");
                                            billingResultZzax = null;
                                        } else {
                                            zzjdVar = zzjd.zzM;
                                            com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "Connection to Billing service is blocked.");
                                        }
                                    }
                                }
                            }
                        } else {
                            zzjdVar = zzjd.zzN;
                            com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "The device doesn't have valid Play Store.");
                        }
                    }
                    zzbg(0);
                    com.google.android.gms.internal.play_billing.zzc.zzn("BillingClient", "Billing service unavailable on device.");
                    BillingResult billingResult2 = zzdc.zzb;
                    zzbf(zzjdVar, billingResult2, i);
                    billingResultZzax = billingResult2;
                }
                billingResultZzax = billingResult;
            }
        }
        if (billingResultZzax != null) {
            billingClientStateListener.onBillingSetupFinished(billingResultZzax);
        }
    }

    public final void zzbj() {
        synchronized (this.zza) {
            if (this.zzj != null) {
                try {
                    this.zzg.unbindService(this.zzj);
                    this.zzi = null;
                    this.zzj = null;
                } catch (Throwable th) {
                    try {
                        com.google.android.gms.internal.play_billing.zzc.zzp("BillingClient", "There was an exception while unbinding service!", th);
                        this.zzi = null;
                        this.zzj = null;
                    } catch (Throwable th2) {
                        this.zzi = null;
                        this.zzj = null;
                        throw th2;
                    }
                }
            }
        }
    }

    private final boolean zzbk(long j) {
        try {
            BillingResult billingResult = (BillingResult) zzaz(1).get(Build.VERSION.SDK_INT < 29 ? 0L : 3000L, TimeUnit.MILLISECONDS);
            if (billingResult.getResponseCode() == 0) {
                com.google.android.gms.internal.play_billing.zzc.zzn("BillingClient", "Reconnection succeeded with result: " + billingResult.getResponseCode());
            } else {
                com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "Reconnection failed with result: " + billingResult.getResponseCode());
            }
        } catch (Exception e) {
            if (e instanceof InterruptedException) {
                Thread.currentThread().interrupt();
            }
            com.google.android.gms.internal.play_billing.zzc.zzp("BillingClient", "Error during reconnection attempt: ", e);
        }
        return zzbm();
    }

    public final boolean zzbl(long j) {
        com.google.android.gms.internal.play_billing.zzbl zzblVarZzb = com.google.android.gms.internal.play_billing.zzbl.zzb(this.zzK);
        long jZza = 30000;
        for (int i = 1; i <= 3; i++) {
            try {
                long jMax = Math.max(0L, jZza);
                if (jMax <= 0) {
                    com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "No time remaining for reconnection attempt.");
                    return zzbm();
                }
                BillingResult billingResult = (BillingResult) zzaz(i).get(jMax, TimeUnit.MILLISECONDS);
                if (billingResult.getResponseCode() == 0) {
                    com.google.android.gms.internal.play_billing.zzc.zzn("BillingClient", "Reconnection succeeded with result: " + billingResult.getResponseCode());
                    return zzbm();
                }
                com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "Reconnection failed with result: " + billingResult.getResponseCode());
                jZza = 30000 - zzblVarZzb.zza(TimeUnit.MILLISECONDS);
                long jPow = ((long) Math.pow(2.0d, i - 1)) * 1000;
                if (jZza < jPow) {
                    com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "Reconnection failed due to timeout limit reached.");
                    return zzbm();
                }
                if (i < 3 && jPow > 0) {
                    try {
                        Thread.sleep(jPow);
                        jZza = 30000 - zzblVarZzb.zza(TimeUnit.MILLISECONDS);
                    } catch (InterruptedException e) {
                        Thread.currentThread().interrupt();
                        com.google.android.gms.internal.play_billing.zzc.zzp("BillingClient", "Error sleeping during reconnection attempt: ", e);
                    }
                }
            } catch (Exception e2) {
                if (e2 instanceof InterruptedException) {
                    Thread.currentThread().interrupt();
                }
                com.google.android.gms.internal.play_billing.zzc.zzp("BillingClient", "Error during reconnection attempt: ", e2);
            }
        }
        com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "Max retries reached.");
        return zzbm();
    }

    private final boolean zzbm() {
        boolean z;
        synchronized (this.zza) {
            z = false;
            if (this.zzb == 2 && this.zzi != null && this.zzj != null) {
                z = true;
            }
        }
        return z;
    }

    private static final String zzbn(int i) {
        if (i == 0) {
            return "DISCONNECTED";
        }
        if (i != 1) {
            return i != 2 ? "CLOSED" : "CONNECTED";
        }
        return "CONNECTING";
    }

    private static final void zzbo(zzjp zzjpVar, Context context) {
        try {
            ActivityManager activityManager = (ActivityManager) context.getSystemService("activity");
            if (activityManager != null) {
                ActivityManager.MemoryInfo memoryInfo = new ActivityManager.MemoryInfo();
                activityManager.getMemoryInfo(memoryInfo);
                zzjpVar.zzv((int) (memoryInfo.totalMem / 1048576));
                zzjpVar.zzr(Build.BRAND);
                zzjpVar.zzu(Build.MODEL);
                zzjpVar.zzt(Build.MANUFACTURER);
                zzjpVar.zzs(Build.FINGERPRINT);
            }
        } catch (RuntimeException e) {
            com.google.android.gms.internal.play_billing.zzc.zzp("BillingClient", "Runtime error while populating device info.", e);
        }
    }

    private final zzdz zzbp(int i, BillingResult billingResult, zzjd zzjdVar, String str, Exception exc) {
        zzbu(zzjdVar, 9, billingResult, zzcy.zza(exc));
        com.google.android.gms.internal.play_billing.zzc.zzp("BillingClient", str, exc);
        return new zzdz(billingResult, null);
    }

    public final zzdz zzbq(String str, boolean z, int i) {
        com.google.android.gms.internal.play_billing.zzap zzapVar;
        int i2;
        int i3;
        Bundle bundleZzi;
        zzjd zzjdVar;
        BillingResult billingResult;
        zzjd zzjdVar2;
        ArrayList<String> stringArrayList;
        ArrayList<String> stringArrayList2;
        ArrayList<String> stringArrayList3;
        boolean z2;
        Purchase purchase;
        com.google.android.gms.internal.play_billing.zzc.zzn("BillingClient", "Querying owned items, item type: ".concat(String.valueOf(str)));
        ArrayList arrayList = new ArrayList();
        boolean z3 = this.zzp;
        boolean z4 = this.zzw;
        boolean zIsEnabledForOneTimeProducts = this.zzE.isEnabledForOneTimeProducts();
        boolean zIsEnabledForPrepaidPlans = this.zzE.isEnabledForPrepaidPlans();
        long jLongValue = this.zzJ.longValue();
        Bundle bundle = new Bundle();
        com.google.android.gms.internal.play_billing.zzc.zzc(bundle, this.zzc, this.zzd, jLongValue);
        int i4 = 1;
        if (z3 && zIsEnabledForOneTimeProducts) {
            bundle.putBoolean("enablePendingPurchases", true);
        }
        if (z4 && zIsEnabledForPrepaidPlans) {
            bundle.putBoolean("enablePendingPurchaseForSubscriptions", true);
        }
        if (z) {
            bundle.putBoolean("includeSuspendedSubscriptions", true);
        }
        String string = null;
        while (true) {
            try {
                synchronized (this.zza) {
                    zzapVar = this.zzi;
                }
                if (zzapVar == null) {
                    return zzbp(9, zzdc.zzj, zzjd.zzbc, "Service has been reset to null", null);
                }
                if (z && !this.zzC) {
                    return zzbp(9, zzdc.zzw, zzjd.zzbH, "Include suspended subscriptions is not supported", null);
                }
                if (this.zzp) {
                    if (this.zzC) {
                        i3 = 26;
                    } else if (this.zzB) {
                        i3 = 24;
                    } else {
                        if (this.zzw) {
                            i3 = 19;
                        } else {
                            i2 = 9;
                        }
                        bundleZzi = zzapVar.zzi(i2, this.zzg.getPackageName(), str, string, bundle);
                    }
                    i2 = i3;
                    bundleZzi = zzapVar.zzi(i2, this.zzg.getPackageName(), str, string, bundle);
                } else {
                    bundleZzi = zzapVar.zzh(3, this.zzg.getPackageName(), str, string);
                }
                BillingResult billingResult2 = zzdc.zzh;
                if (bundleZzi == null) {
                    Object[] objArr = new Object[i4];
                    objArr[0] = "getPurchase()";
                    com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", String.format("%s got null owned items list", objArr));
                    zzjdVar = zzjd.zzab;
                } else {
                    int iZzb = com.google.android.gms.internal.play_billing.zzc.zzb(bundleZzi, "BillingClient");
                    String strZzk = com.google.android.gms.internal.play_billing.zzc.zzk(bundleZzi, "BillingClient");
                    BillingResult.Builder builderNewBuilder = BillingResult.newBuilder();
                    builderNewBuilder.setResponseCode(iZzb);
                    builderNewBuilder.setDebugMessage(strZzk);
                    BillingResult billingResultBuild = builderNewBuilder.build();
                    if (iZzb != 0) {
                        Integer numValueOf = Integer.valueOf(iZzb);
                        Object[] objArr2 = new Object[2];
                        objArr2[0] = "getPurchase()";
                        objArr2[i4] = numValueOf;
                        com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", String.format("%s failed. Response code: %s", objArr2));
                        zzjdVar2 = zzjd.zzw;
                        billingResult = billingResultBuild;
                    } else if (bundleZzi.containsKey("INAPP_PURCHASE_ITEM_LIST") && bundleZzi.containsKey("INAPP_PURCHASE_DATA_LIST") && bundleZzi.containsKey("INAPP_DATA_SIGNATURE_LIST")) {
                        ArrayList<String> stringArrayList4 = bundleZzi.getStringArrayList("INAPP_PURCHASE_ITEM_LIST");
                        ArrayList<String> stringArrayList5 = bundleZzi.getStringArrayList("INAPP_PURCHASE_DATA_LIST");
                        ArrayList<String> stringArrayList6 = bundleZzi.getStringArrayList("INAPP_DATA_SIGNATURE_LIST");
                        if (stringArrayList4 == null) {
                            Object[] objArr3 = new Object[i4];
                            objArr3[0] = "getPurchase()";
                            com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", String.format("Bundle returned from %s contains null SKUs list.", objArr3));
                            zzjdVar = zzjd.zzad;
                        } else if (stringArrayList5 == null) {
                            Object[] objArr4 = new Object[i4];
                            objArr4[0] = "getPurchase()";
                            com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", String.format("Bundle returned from %s contains null purchases list.", objArr4));
                            zzjdVar = zzjd.zzae;
                        } else if (stringArrayList6 == null) {
                            Object[] objArr5 = new Object[i4];
                            objArr5[0] = "getPurchase()";
                            com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", String.format("Bundle returned from %s contains null signatures list.", objArr5));
                            zzjdVar = zzjd.zzaf;
                        } else {
                            billingResult = zzdc.zzi;
                            zzjdVar2 = zzjd.zza;
                        }
                    } else {
                        Object[] objArr6 = new Object[i4];
                        objArr6[0] = "getPurchase()";
                        com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", String.format("Bundle returned from %s doesn't contain required fields.", objArr6));
                        zzjdVar = zzjd.zzac;
                    }
                    if (billingResult != zzdc.zzi) {
                        return zzbp(9, billingResult, zzjdVar2, "Purchase bundle invalid", null);
                    }
                    stringArrayList = bundleZzi.getStringArrayList("INAPP_PURCHASE_ITEM_LIST");
                    stringArrayList2 = bundleZzi.getStringArrayList("INAPP_PURCHASE_DATA_LIST");
                    stringArrayList3 = bundleZzi.getStringArrayList("INAPP_DATA_SIGNATURE_LIST");
                    z2 = false;
                    for (int i5 = 0; i5 < stringArrayList2.size(); i5++) {
                        String str2 = stringArrayList2.get(i5);
                        String str3 = stringArrayList3.get(i5);
                        com.google.android.gms.internal.play_billing.zzc.zzn("BillingClient", "Sku is owned: ".concat(String.valueOf(stringArrayList.get(i5))));
                        try {
                            purchase = new Purchase(str2, str3);
                            if (TextUtils.isEmpty(purchase.getPurchaseToken())) {
                                com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "BUG: empty/null token!");
                                z2 = true;
                            }
                            arrayList.add(purchase);
                        } catch (JSONException e) {
                            return zzbp(9, zzdc.zzh, zzjd.zzY, "Got an exception trying to decode the purchase!", e);
                        }
                    }
                    if (z2) {
                        zzbs(zzjd.zzz, 9, billingResult2);
                    }
                    string = bundleZzi.getString("INAPP_CONTINUATION_TOKEN");
                    com.google.android.gms.internal.play_billing.zzc.zzn("BillingClient", "Continuation token: ".concat(String.valueOf(string)));
                    if (TextUtils.isEmpty(string)) {
                        return new zzdz(zzdc.zzi, arrayList);
                    }
                    i4 = 1;
                }
                zzjdVar2 = zzjdVar;
                billingResult = billingResult2;
                if (billingResult != zzdc.zzi) {
                    return zzbp(9, billingResult, zzjdVar2, "Purchase bundle invalid", null);
                }
                stringArrayList = bundleZzi.getStringArrayList("INAPP_PURCHASE_ITEM_LIST");
                stringArrayList2 = bundleZzi.getStringArrayList("INAPP_PURCHASE_DATA_LIST");
                stringArrayList3 = bundleZzi.getStringArrayList("INAPP_DATA_SIGNATURE_LIST");
                z2 = false;
                while (i5 < stringArrayList2.size()) {
                    String str4 = stringArrayList2.get(i5);
                    String str5 = stringArrayList3.get(i5);
                    com.google.android.gms.internal.play_billing.zzc.zzn("BillingClient", "Sku is owned: ".concat(String.valueOf(stringArrayList.get(i5))));
                    purchase = new Purchase(str4, str5);
                    if (TextUtils.isEmpty(purchase.getPurchaseToken())) {
                        com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "BUG: empty/null token!");
                        z2 = true;
                    }
                    arrayList.add(purchase);
                }
                if (z2) {
                    zzbs(zzjd.zzz, 9, billingResult2);
                }
                string = bundleZzi.getString("INAPP_CONTINUATION_TOKEN");
                com.google.android.gms.internal.play_billing.zzc.zzn("BillingClient", "Continuation token: ".concat(String.valueOf(string)));
                if (TextUtils.isEmpty(string)) {
                    return new zzdz(zzdc.zzi, arrayList);
                }
                i4 = 1;
            } catch (DeadObjectException e2) {
                return zzbp(9, zzdc.zzj, zzjd.zzZ, "Got exception trying to get purchases try to reconnect", e2);
            } catch (Exception e3) {
                return zzbp(9, zzdc.zzh, zzjd.zzZ, "Got exception trying to get purchases try to reconnect", e3);
            }
        }
    }

    private final void zzbr(BillingResult billingResult, zzjd zzjdVar, int i) {
        zziw zziwVar = null;
        if (billingResult.getResponseCode() == 0) {
            int i2 = zzcy.zza;
            try {
                zziy zziyVarZza = zzja.zza();
                zziyVarZza.zze(5);
                zzjv zzjvVarZza = zzjy.zza();
                zzjvVarZza.zza(i);
                zziyVarZza.zzb(zzjvVarZza.zzi());
                zziwVar = (zzja) zziyVarZza.zzi();
            } catch (Exception e) {
                com.google.android.gms.internal.play_billing.zzc.zzp("BillingLogger", "Unable to create logging payload", e);
            }
            zzbe(zziwVar);
            return;
        }
        int i3 = zzcy.zza;
        try {
            zziu zziuVarZza = zziw.zza();
            zzjb zzjbVarZza = zzjf.zza();
            zzjbVarZza.zzp(billingResult.getResponseCode());
            zzjbVarZza.zzb(billingResult.getDebugMessage());
            zzjbVarZza.zze(zzjdVar);
            zziuVarZza.zzb(zzjbVarZza);
            zziuVarZza.zzp(5);
            zzjv zzjvVarZza2 = zzjy.zza();
            zzjvVarZza2.zza(i);
            zziuVarZza.zzc(zzjvVarZza2.zzi());
            zziwVar = (zziw) zziuVarZza.zzi();
        } catch (Exception e2) {
            com.google.android.gms.internal.play_billing.zzc.zzp("BillingLogger", "Unable to create logging payload", e2);
        }
        zzbc(zziwVar);
    }

    public void zzbs(zzjd zzjdVar, int i, BillingResult billingResult) {
        try {
            int i2 = zzcy.zza;
            zzbc(zzcy.zzb(zzjdVar, i, billingResult, null, zzjk.zza));
        } catch (Throwable th) {
            com.google.android.gms.internal.play_billing.zzc.zzp("BillingClient", "Unable to log.", th);
        }
    }

    private final void zzbt(zzjd zzjdVar, int i, BillingResult billingResult, long j) {
        try {
            int i2 = zzcy.zza;
            try {
                this.zzh.zzc(zzcy.zzb(zzjdVar, 2, billingResult, null, zzjk.zza), this.zzm, j);
            } catch (Throwable th) {
                com.google.android.gms.internal.play_billing.zzc.zzp("BillingClient", "Unable to log.", th);
            }
        } catch (Throwable th2) {
            com.google.android.gms.internal.play_billing.zzc.zzp("BillingClient", "Unable to log.", th2);
        }
    }

    private final void zzbu(zzjd zzjdVar, int i, BillingResult billingResult, String str) {
        try {
            int i2 = zzcy.zza;
            zzbc(zzcy.zzb(zzjdVar, i, billingResult, str, zzjk.zza));
        } catch (Throwable th) {
            com.google.android.gms.internal.play_billing.zzc.zzp("BillingClient", "Unable to log.", th);
        }
    }

    private final void zzbv(zzjd zzjdVar, int i, BillingResult billingResult, long j, boolean z) {
        try {
            int i2 = zzcy.zza;
            zzbd(zzcy.zzb(zzjdVar, 2, billingResult, null, zzjk.zza), j, z);
        } catch (Throwable th) {
            com.google.android.gms.internal.play_billing.zzc.zzp("BillingClient", "Unable to log.", th);
        }
    }

    private final void zzbw(zzjd zzjdVar, int i, BillingResult billingResult, String str, long j, boolean z) {
        try {
            int i2 = zzcy.zza;
            zzbd(zzcy.zzb(zzjdVar, 2, billingResult, str, zzjk.zza), j, z);
        } catch (Throwable th) {
            com.google.android.gms.internal.play_billing.zzc.zzp("BillingClient", "Unable to log.", th);
        }
    }

    private void zzbx(int i) {
        try {
            int i2 = zzcy.zza;
            zzbe(zzcy.zzc(i, zzjk.zza));
        } catch (Throwable th) {
            com.google.android.gms.internal.play_billing.zzc.zzp("BillingClient", "Unable to log.", th);
        }
    }

    static ResultReceiver zzg(BillingClientImpl billingClientImpl, LaunchExternalLinkResponseListener launchExternalLinkResponseListener) {
        return new zzbt(billingClientImpl, billingClientImpl.zze, launchExternalLinkResponseListener);
    }

    static BillingResult zzm(Exception exc) {
        return exc instanceof DeadObjectException ? zzdc.zzj : zzdc.zzh;
    }

    public static Object zzr(BillingClientImpl billingClientImpl, int i, com.google.android.gms.internal.play_billing.zzp zzpVar) {
        billingClientImpl.zzbi(new zzbs(billingClientImpl, zzpVar), i);
        return "reconnectIfNeeded";
    }

    public static Object zzs(BillingClientImpl billingClientImpl, ConsumeResponseListener consumeResponseListener, ConsumeParams consumeParams) {
        if (billingClientImpl.zzbl(30000L)) {
            billingClientImpl.zzaO(consumeParams, consumeResponseListener);
            return null;
        }
        zzjd zzjdVar = zzjd.zzb;
        BillingResult billingResult = zzdc.zzj;
        billingClientImpl.zzbs(zzjdVar, 4, billingResult);
        consumeResponseListener.onConsumeResponse(billingResult, consumeParams.getPurchaseToken());
        return null;
    }

    public static Object zzt(BillingClientImpl billingClientImpl, ProductDetailsResponseListener productDetailsResponseListener, QueryProductDetailsParams queryProductDetailsParams) throws JSONException {
        if (!billingClientImpl.zzbl(30000L)) {
            zzjd zzjdVar = zzjd.zzb;
            BillingResult billingResult = zzdc.zzj;
            billingClientImpl.zzbs(zzjdVar, 7, billingResult);
            productDetailsResponseListener.onProductDetailsResponse(billingResult, new QueryProductDetailsResult(com.google.android.gms.internal.play_billing.zzbw.zzk(), com.google.android.gms.internal.play_billing.zzbw.zzk()));
            return null;
        }
        if (billingClientImpl.zzu) {
            zzcg zzcgVarZzh = billingClientImpl.zzh(queryProductDetailsParams);
            productDetailsResponseListener.onProductDetailsResponse(zzdc.zza(zzcgVarZzh.zza(), zzcgVarZzh.zzb()), new QueryProductDetailsResult(zzcgVarZzh.zzc(), zzcgVarZzh.zzd()));
            return null;
        }
        com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "Querying product details is not supported.");
        zzjd zzjdVar2 = zzjd.zzt;
        BillingResult billingResult2 = zzdc.zzr;
        billingClientImpl.zzbs(zzjdVar2, 7, billingResult2);
        productDetailsResponseListener.onProductDetailsResponse(billingResult2, new QueryProductDetailsResult(com.google.android.gms.internal.play_billing.zzbw.zzk(), com.google.android.gms.internal.play_billing.zzbw.zzk()));
        return null;
    }

    public static Object zzu(BillingClientImpl billingClientImpl, AcknowledgePurchaseResponseListener acknowledgePurchaseResponseListener, AcknowledgePurchaseParams acknowledgePurchaseParams) throws Exception {
        billingClientImpl.zzaA(acknowledgePurchaseResponseListener, acknowledgePurchaseParams);
        return null;
    }

    public static Object zzv(BillingClientImpl billingClientImpl, Bundle bundle, Activity activity, ResultReceiver resultReceiver) throws Exception {
        billingClientImpl.zzaC(bundle, activity, resultReceiver);
        return null;
    }

    public static Object zzw(BillingClientImpl billingClientImpl, BillingConfigResponseListener billingConfigResponseListener) throws Exception {
        billingClientImpl.zzaB(billingConfigResponseListener);
        return null;
    }

    @Override
    public void acknowledgePurchase(final AcknowledgePurchaseParams acknowledgePurchaseParams, final AcknowledgePurchaseResponseListener acknowledgePurchaseResponseListener) {
        if (zzK(new Callable() {
            @Override
            public final Object call() throws Exception {
                BillingClientImpl.zzu(this.zza, acknowledgePurchaseResponseListener, acknowledgePurchaseParams);
                return null;
            }
        }, 30000L, new Runnable() {
            @Override
            public final void run() {
                BillingClientImpl.zzR(this.zza, acknowledgePurchaseResponseListener);
            }
        }, zzav(), zzJ()) == null) {
            BillingResult billingResultZzay = zzay();
            zzbs(zzjd.zzy, 3, billingResultZzay);
            acknowledgePurchaseResponseListener.onAcknowledgePurchaseResponse(billingResultZzay);
        }
    }

    @Override
    public void consumeAsync(final ConsumeParams consumeParams, final ConsumeResponseListener consumeResponseListener) {
        if (zzK(new Callable() {
            @Override
            public final Object call() {
                BillingClientImpl.zzs(this.zza, consumeResponseListener, consumeParams);
                return null;
            }
        }, 30000L, new Runnable() {
            @Override
            public final void run() {
                BillingClientImpl.zzL(this.zza, consumeResponseListener, consumeParams);
            }
        }, zzav(), zzJ()) == null) {
            BillingResult billingResultZzay = zzay();
            zzbs(zzjd.zzy, 4, billingResultZzay);
            consumeResponseListener.onConsumeResponse(billingResultZzay, consumeParams.getPurchaseToken());
        }
    }

    @Override
    public void createAlternativeBillingOnlyReportingDetailsAsync(final AlternativeBillingOnlyReportingDetailsListener alternativeBillingOnlyReportingDetailsListener) {
        if (zzK(new Callable() {
            @Override
            public final Object call() throws Exception {
                BillingClientImpl.zzG(this.zza, alternativeBillingOnlyReportingDetailsListener);
                return null;
            }
        }, 30000L, new Runnable() {
            @Override
            public final void run() {
                this.zza.zzaT(alternativeBillingOnlyReportingDetailsListener, zzdc.zzk, zzjd.zzx, null);
            }
        }, zzav(), zzJ()) == null) {
            zzaT(alternativeBillingOnlyReportingDetailsListener, zzay(), zzjd.zzy, null);
        }
    }

    @Override
    public void createBillingProgramReportingDetailsAsync(final BillingProgramReportingDetailsParams billingProgramReportingDetailsParams, final BillingProgramReportingDetailsListener billingProgramReportingDetailsListener) {
        try {
            zzaN(new Callable() {
                @Override
                public final Object call() throws Exception {
                    BillingClientImpl.zzH(this.zza, billingProgramReportingDetailsListener, billingProgramReportingDetailsParams);
                    return null;
                }
            }, 30000L, new Runnable() {
                @Override
                public final void run() {
                    this.zza.zzaU(billingProgramReportingDetailsListener, zzdc.zzk, zzjd.zzx, null);
                }
            }, zzav());
        } catch (Exception e) {
            zzaU(billingProgramReportingDetailsListener, zzay(), zzjd.zzy, e);
        }
    }

    @Override
    public void createExternalOfferReportingDetailsAsync(final ExternalOfferReportingDetailsListener externalOfferReportingDetailsListener) {
        if (zzK(new Callable() {
            @Override
            public final Object call() throws Exception {
                BillingClientImpl.zzE(this.zza, externalOfferReportingDetailsListener);
                return null;
            }
        }, 30000L, new Runnable() {
            @Override
            public final void run() {
                this.zza.zzaV(externalOfferReportingDetailsListener, zzdc.zzk, zzjd.zzx, null);
            }
        }, zzav(), zzJ()) == null) {
            zzaV(externalOfferReportingDetailsListener, zzay(), zzjd.zzy, null);
        }
    }

    @Override
    public void endConnection() {
        zzbx(12);
        synchronized (this.zza) {
            try {
                if (this.zzf != null) {
                    this.zzf.zzh();
                    try {
                        com.google.android.gms.internal.play_billing.zzc.zzn("BillingClient", "Unbinding from service.");
                        zzbj();
                    } catch (Throwable th) {
                        com.google.android.gms.internal.play_billing.zzc.zzp("BillingClient", "There was an exception while unbinding from the service while ending connection!", th);
                    }
                    try {
                        zzbh();
                        zzbg(3);
                    } catch (Throwable th2) {
                        try {
                            com.google.android.gms.internal.play_billing.zzc.zzp("BillingClient", "There was an exception while shutting down the executor service while ending connection!", th2);
                            zzbg(3);
                        } catch (Throwable th3) {
                            zzbg(3);
                            this.zzH = null;
                            throw th3;
                        }
                    }
                    this.zzH = null;
                } else {
                    com.google.android.gms.internal.play_billing.zzc.zzn("BillingClient", "Unbinding from service.");
                    zzbj();
                    zzbh();
                    zzbg(3);
                    this.zzH = null;
                }
            } catch (Throwable th4) {
                com.google.android.gms.internal.play_billing.zzc.zzp("BillingClient", "There was an exception while shutting down broadcast manager while ending connection!", th4);
            }
            throw th;
        }
    }

    @Override
    public void getBillingConfigAsync(GetBillingConfigParams getBillingConfigParams, final BillingConfigResponseListener billingConfigResponseListener) {
        if (zzK(new Callable() {
            @Override
            public final Object call() throws Exception {
                BillingClientImpl.zzw(this.zza, billingConfigResponseListener);
                return null;
            }
        }, 30000L, new Runnable() {
            @Override
            public final void run() {
                BillingClientImpl.zzN(this.zza, billingConfigResponseListener);
            }
        }, zzav(), zzJ()) == null) {
            BillingResult billingResultZzay = zzay();
            zzbs(zzjd.zzy, 13, billingResultZzay);
            billingConfigResponseListener.onBillingConfigResponse(billingResultZzay, null);
        }
    }

    @Override
    public final int getConnectionState() {
        int i;
        synchronized (this.zza) {
            i = this.zzb;
        }
        return i;
    }

    @Override
    public void isAlternativeBillingOnlyAvailableAsync(final AlternativeBillingOnlyAvailabilityListener alternativeBillingOnlyAvailabilityListener) {
        if (zzK(new Callable() {
            @Override
            public final Object call() throws Exception {
                BillingClientImpl.zzI(this.zza, alternativeBillingOnlyAvailabilityListener);
                return null;
            }
        }, 30000L, new Runnable() {
            @Override
            public final void run() {
                this.zza.zzaQ(alternativeBillingOnlyAvailabilityListener, zzdc.zzk, zzjd.zzx, null);
            }
        }, zzav(), zzJ()) == null) {
            zzaQ(alternativeBillingOnlyAvailabilityListener, zzay(), zzjd.zzy, null);
        }
    }

    @Override
    public void isBillingProgramAvailableAsync(final int i, final BillingProgramAvailabilityListener billingProgramAvailabilityListener) {
        if (zzK(new Callable() {
            @Override
            public final Object call() throws Exception {
                BillingClientImpl.zzC(this.zza, billingProgramAvailabilityListener, i);
                return null;
            }
        }, 30000L, new Runnable() {
            @Override
            public final void run() {
                this.zza.zzaR(billingProgramAvailabilityListener, i, zzdc.zzk, zzjd.zzx, null);
            }
        }, zzav(), zzJ()) == null) {
            zzaR(billingProgramAvailabilityListener, i, zzay(), zzjd.zzy, null);
        }
    }

    @Override
    public void isExternalOfferAvailableAsync(final ExternalOfferAvailabilityListener externalOfferAvailabilityListener) {
        if (zzK(new Callable() {
            @Override
            public final Object call() throws Exception {
                BillingClientImpl.zzB(this.zza, externalOfferAvailabilityListener);
                return null;
            }
        }, 30000L, new Runnable() {
            @Override
            public final void run() {
                this.zza.zzaW(externalOfferAvailabilityListener, zzdc.zzk, zzjd.zzx, null);
            }
        }, zzav(), zzJ()) == null) {
            zzaW(externalOfferAvailabilityListener, zzay(), zzjd.zzy, null);
        }
    }

    @Override
    public final BillingResult isFeatureSupported(String str) {
        if (!zzbk(3000L)) {
            BillingResult billingResult = zzdc.zzj;
            zzjd zzjdVar = zzjd.zzb;
            if (billingResult.getResponseCode() != 0) {
                zzbs(zzjdVar, 5, billingResult);
            } else {
                zzbx(5);
            }
            return billingResult;
        }
        int i = zzdc.zzI;
        switch (str) {
            case "subscriptions":
                BillingResult billingResult2 = this.zzk ? zzdc.zzi : zzdc.zzl;
                zzbr(billingResult2, zzjd.zzi, 2);
                return billingResult2;
            case "subscriptionsUpdate":
                BillingResult billingResult3 = this.zzl ? zzdc.zzi : zzdc.zzm;
                zzbr(billingResult3, zzjd.zzj, 3);
                return billingResult3;
            case "priceChangeConfirmation":
                BillingResult billingResult4 = this.zzo ? zzdc.zzi : zzdc.zzn;
                zzbr(billingResult4, zzjd.zzI, 4);
                return billingResult4;
            case "bbb":
                BillingResult billingResult5 = this.zzq ? zzdc.zzi : zzdc.zzs;
                zzbr(billingResult5, zzjd.zzD, 5);
                return billingResult5;
            case "aaa":
                BillingResult billingResult6 = this.zzs ? zzdc.zzi : zzdc.zzo;
                zzbr(billingResult6, zzjd.zzE, 6);
                return billingResult6;
            case "ddd":
                BillingResult billingResult7 = this.zzr ? zzdc.zzi : zzdc.zzq;
                zzbr(billingResult7, zzjd.zzu, 7);
                return billingResult7;
            case "ccc":
                BillingResult billingResult8 = this.zzt ? zzdc.zzi : zzdc.zzp;
                zzbr(billingResult8, zzjd.zzs, 8);
                return billingResult8;
            case "eee":
                BillingResult billingResult9 = this.zzt ? zzdc.zzi : zzdc.zzp;
                zzbr(billingResult9, zzjd.zzai, 9);
                return billingResult9;
            case "fff":
                BillingResult billingResult10 = this.zzu ? zzdc.zzi : zzdc.zzr;
                zzbr(billingResult10, zzjd.zzt, 10);
                return billingResult10;
            case "ggg":
                BillingResult billingResult11 = this.zzv ? zzdc.zzi : zzdc.zzy;
                zzbr(billingResult11, zzjd.zzF, 11);
                return billingResult11;
            case "hhh":
                BillingResult billingResult12 = this.zzv ? zzdc.zzi : zzdc.zzz;
                zzbr(billingResult12, zzjd.zzG, 12);
                return billingResult12;
            case "iii":
                BillingResult billingResult13 = this.zzx ? zzdc.zzi : zzdc.zzB;
                zzbr(billingResult13, zzjd.zzah, 13);
                return billingResult13;
            case "jjj":
                BillingResult billingResult14 = this.zzy ? zzdc.zzi : zzdc.zzC;
                zzbr(billingResult14, zzjd.zzan, 14);
                return billingResult14;
            case "kkk":
                BillingResult billingResult15 = this.zzB ? zzdc.zzi : zzdc.zzt;
                zzbr(billingResult15, zzjd.zzaE, 18);
                return billingResult15;
            case "lll":
                BillingResult billingResult16 = this.zzA ? zzdc.zzi : zzdc.zzu;
                zzbr(billingResult16, zzjd.zzaZ, 19);
                return billingResult16;
            case "mmm":
                BillingResult billingResult17 = this.zzB ? zzdc.zzi : zzdc.zzv;
                zzbr(billingResult17, zzjd.zzbo, 20);
                return billingResult17;
            case "nnn":
                BillingResult billingResult18 = this.zzC ? zzdc.zzi : zzdc.zzw;
                zzbr(billingResult18, zzjd.zzbH, 21);
                return billingResult18;
            default:
                com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "Unsupported feature: ".concat(String.valueOf(str)));
                BillingResult billingResult19 = zzdc.zzx;
                zzbr(billingResult19, zzjd.zzH, 1);
                return billingResult19;
        }
    }

    @Override
    public final boolean isReady() {
        if (this.zzF) {
            return true;
        }
        return zzbm();
    }

    @Override
    public BillingResult launchBillingFlow(Activity activity, final BillingFlowParams billingFlowParams) {
        boolean zZzd;
        String productId;
        String productType;
        String str;
        boolean z;
        Future futureZzK;
        ?? r10;
        boolean z2;
        zzjd zzjdVarZzb;
        String string;
        Object obj;
        BillingFlowParams.ProductDetailsParams productDetailsParams;
        String str2;
        boolean z3;
        Intent intent;
        int i;
        long jNextLong = new Random().nextLong();
        if (this.zzf == null || this.zzf.zzf() == null) {
            zzjd zzjdVar = zzjd.zzl;
            BillingResult billingResult = zzdc.zzD;
            zzbt(zzjdVar, 2, billingResult, jNextLong);
            return billingResult;
        }
        if (billingFlowParams.getDeveloperBillingOptionParams() != null && this.zzf.zzd() == null) {
            zzjd zzjdVar2 = zzjd.zzbJ;
            BillingResult billingResult2 = zzdc.zzH;
            zzbt(zzjdVar2, 2, billingResult2, jNextLong);
            return billingResult2;
        }
        if (!zzbk(3000L)) {
            zzjd zzjdVar3 = zzjd.zzb;
            BillingResult billingResult3 = zzdc.zzj;
            zzbt(zzjdVar3, 2, billingResult3, jNextLong);
            zzn(billingResult3);
            return billingResult3;
        }
        synchronized (this.zza) {
            zZzd = this.zzj != null ? this.zzj.zzd() : false;
        }
        ArrayList arrayListZzj = billingFlowParams.zzj();
        List listZzk = billingFlowParams.zzk();
        SkuDetails skuDetails = (SkuDetails) com.google.android.gms.internal.play_billing.zzcb.zza(arrayListZzj, (Object) null);
        BillingFlowParams.ProductDetailsParams productDetailsParams2 = (BillingFlowParams.ProductDetailsParams) com.google.android.gms.internal.play_billing.zzcb.zza(listZzk, (Object) null);
        if (skuDetails != null) {
            productId = skuDetails.getSku();
            productType = skuDetails.getType();
        } else {
            productId = productDetailsParams2.zza().getProductId();
            productType = productDetailsParams2.zza().getProductType();
        }
        final String str3 = productId;
        final String str4 = productType;
        if (str4.equals("subs") && !this.zzk) {
            com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "Current client doesn't support subscriptions.");
            zzjd zzjdVar4 = zzjd.zzi;
            BillingResult billingResult4 = zzdc.zzl;
            zzbv(zzjdVar4, 2, billingResult4, jNextLong, zZzd);
            zzn(billingResult4);
            return billingResult4;
        }
        if (billingFlowParams.zzu() && !this.zzn) {
            com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "Current client doesn't support extra params for buy intent.");
            zzjd zzjdVar5 = zzjd.zzr;
            BillingResult billingResult5 = zzdc.zzf;
            zzbv(zzjdVar5, 2, billingResult5, jNextLong, zZzd);
            zzn(billingResult5);
            return billingResult5;
        }
        if (arrayListZzj.size() > 1 && !this.zzt) {
            com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "Current client doesn't support multi-item purchases.");
            zzjd zzjdVar6 = zzjd.zzs;
            BillingResult billingResult6 = zzdc.zzp;
            zzbv(zzjdVar6, 2, billingResult6, jNextLong, zZzd);
            zzn(billingResult6);
            return billingResult6;
        }
        if (!listZzk.isEmpty() && !this.zzu) {
            com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "Current client doesn't support purchases with ProductDetails.");
            zzjd zzjdVar7 = zzjd.zzt;
            BillingResult billingResult7 = zzdc.zzr;
            zzbv(zzjdVar7, 2, billingResult7, jNextLong, zZzd);
            zzn(billingResult7);
            return billingResult7;
        }
        BillingResult billingResultZzd = billingFlowParams.zzd();
        if (billingResultZzd != zzdc.zzi) {
            zzbv(zzjd.zzbd, 2, billingResultZzd, jNextLong, zZzd);
            zzn(billingResultZzd);
            return billingResultZzd;
        }
        if (this.zzn) {
            z = zZzd;
            final Bundle bundleZzf = com.google.android.gms.internal.play_billing.zzc.zzf(billingFlowParams, this.zzp, this.zzw, this.zzE.isEnabledForOneTimeProducts(), this.zzE.isEnabledForPrepaidPlans(), this.zzG, this.zzc, this.zzd, this.zzJ.longValue(), this.zzg.getPackageName(), jNextLong);
            if (arrayListZzj.isEmpty()) {
                productDetailsParams = productDetailsParams2;
                ArrayList<String> arrayList = new ArrayList<>(listZzk.size() - 1);
                ArrayList<String> arrayList2 = new ArrayList<>(listZzk.size() - 1);
                ArrayList<String> arrayList3 = new ArrayList<>();
                ArrayList<String> arrayList4 = new ArrayList<>();
                ArrayList<String> arrayList5 = new ArrayList<>();
                ArrayList<Integer> arrayList6 = new ArrayList<>();
                for (int i2 = 0; i2 < listZzk.size(); i2++) {
                    BillingFlowParams.ProductDetailsParams productDetailsParams3 = (BillingFlowParams.ProductDetailsParams) listZzk.get(i2);
                    ProductDetails productDetailsZza = productDetailsParams3.zza();
                    if (!productDetailsZza.zzb().isEmpty()) {
                        arrayList3.add(productDetailsZza.zzb());
                    }
                    String strZzb = productDetailsParams3.zzb();
                    arrayList4.add(strZzb);
                    String strZzc = productDetailsZza.zzc(strZzb);
                    if (!TextUtils.isEmpty(strZzc)) {
                        arrayList5.add(strZzc);
                    }
                    if (i2 > 0) {
                        arrayList.add(((BillingFlowParams.ProductDetailsParams) listZzk.get(i2)).zza().getProductId());
                        arrayList2.add(((BillingFlowParams.ProductDetailsParams) listZzk.get(i2)).zza().getProductType());
                    }
                }
                bundleZzf.putStringArrayList("SKU_OFFER_ID_TOKEN_LIST", arrayList4);
                if (!arrayList6.isEmpty()) {
                    bundleZzf.putIntegerArrayList("autoPayBalanceThresholdList", arrayList6);
                }
                if (!arrayList3.isEmpty()) {
                    bundleZzf.putStringArrayList("skuDetailsTokens", arrayList3);
                }
                if (!arrayList5.isEmpty()) {
                    bundleZzf.putStringArrayList("SKU_SERIALIZED_DOCID_LIST", arrayList5);
                }
                if (!arrayList.isEmpty()) {
                    bundleZzf.putStringArrayList("additionalSkus", arrayList);
                    bundleZzf.putStringArrayList("additionalSkuTypes", arrayList2);
                }
            } else {
                ArrayList<String> arrayList7 = new ArrayList<>();
                ArrayList<String> arrayList8 = new ArrayList<>();
                ArrayList<String> arrayList9 = new ArrayList<>();
                ArrayList<Integer> arrayList10 = new ArrayList<>();
                ArrayList<String> arrayList11 = new ArrayList<>();
                Iterator it = arrayListZzj.iterator();
                boolean z4 = false;
                boolean z5 = false;
                boolean z6 = false;
                boolean z7 = false;
                while (it.hasNext()) {
                    SkuDetails skuDetails2 = (SkuDetails) it.next();
                    if (!skuDetails2.zzf().isEmpty()) {
                        arrayList7.add(skuDetails2.zzf());
                    }
                    String strZzc2 = skuDetails2.zzc();
                    Iterator it2 = it;
                    String strZzb2 = skuDetails2.zzb();
                    int iZza = skuDetails2.zza();
                    BillingFlowParams.ProductDetailsParams productDetailsParams4 = productDetailsParams2;
                    String strZze = skuDetails2.zze();
                    arrayList8.add(strZzc2);
                    z4 |= !TextUtils.isEmpty(strZzc2);
                    arrayList9.add(strZzb2);
                    z5 |= !TextUtils.isEmpty(strZzb2);
                    arrayList10.add(Integer.valueOf(iZza));
                    z6 |= iZza != 0;
                    z7 |= !TextUtils.isEmpty(strZze);
                    arrayList11.add(strZze);
                    it = it2;
                    productDetailsParams2 = productDetailsParams4;
                }
                productDetailsParams = productDetailsParams2;
                if (!arrayList7.isEmpty()) {
                    bundleZzf.putStringArrayList("skuDetailsTokens", arrayList7);
                }
                if (z4) {
                    bundleZzf.putStringArrayList("SKU_OFFER_ID_TOKEN_LIST", arrayList8);
                }
                if (z5) {
                    bundleZzf.putStringArrayList("SKU_OFFER_ID_LIST", arrayList9);
                }
                if (z6) {
                    bundleZzf.putIntegerArrayList("SKU_OFFER_TYPE_LIST", arrayList10);
                }
                if (z7) {
                    bundleZzf.putStringArrayList("SKU_SERIALIZED_DOCID_LIST", arrayList11);
                }
                if (arrayListZzj.size() > 1) {
                    ArrayList<String> arrayList12 = new ArrayList<>(arrayListZzj.size() - 1);
                    ArrayList<String> arrayList13 = new ArrayList<>(arrayListZzj.size() - 1);
                    for (int i3 = 1; i3 < arrayListZzj.size(); i3++) {
                        arrayList12.add(((SkuDetails) arrayListZzj.get(i3)).getSku());
                        arrayList13.add(((SkuDetails) arrayListZzj.get(i3)).getType());
                    }
                    bundleZzf.putStringArrayList("additionalSkus", arrayList12);
                    bundleZzf.putStringArrayList("additionalSkuTypes", arrayList13);
                }
            }
            if (bundleZzf.containsKey("SKU_OFFER_ID_TOKEN_LIST") && !this.zzr) {
                zzjd zzjdVar8 = zzjd.zzu;
                BillingResult billingResult8 = zzdc.zzq;
                zzbv(zzjdVar8, 2, billingResult8, jNextLong, z);
                zzn(billingResult8);
                return billingResult8;
            }
            if (skuDetails == null || TextUtils.isEmpty(skuDetails.zzd())) {
                if (productDetailsParams == null || TextUtils.isEmpty(productDetailsParams.zza().zza())) {
                    str2 = null;
                    z3 = false;
                } else {
                    bundleZzf.putString("skuPackageName", productDetailsParams.zza().zza());
                }
                if (!TextUtils.isEmpty(str2)) {
                    bundleZzf.putString("accountName", str2);
                }
                intent = activity.getIntent();
                if (intent == null) {
                    com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "Activity's intent is null.");
                } else if (!TextUtils.isEmpty(intent.getStringExtra("PROXY_PACKAGE"))) {
                    String stringExtra = intent.getStringExtra("PROXY_PACKAGE");
                    bundleZzf.putString("proxyPackage", stringExtra);
                    try {
                        bundleZzf.putString("proxyPackageVersion", this.zzg.getPackageManager().getPackageInfo(stringExtra, 0).versionName);
                    } catch (PackageManager.NameNotFoundException unused) {
                        bundleZzf.putString("proxyPackageVersion", "package not found");
                    }
                }
                if (!this.zzu && !listZzk.isEmpty()) {
                    i = 17;
                } else if (!this.zzs && z3) {
                    i = 15;
                } else if (this.zzp) {
                    i = 9;
                } else {
                    i = 6;
                }
                final int i4 = i;
                str = str2;
                jNextLong = jNextLong;
                futureZzK = zzK(new Callable() {
                    @Override
                    public final Object call() {
                        return this.zza.zzat(i4, str3, str4, billingFlowParams, bundleZzf);
                    }
                }, 5000L, null, this.zze, zzJ());
                r10 = bundleZzf;
            } else {
                bundleZzf.putString("skuPackageName", skuDetails.zzd());
            }
            str2 = null;
            z3 = true;
            if (!TextUtils.isEmpty(str2)) {
                bundleZzf.putString("accountName", str2);
            }
            intent = activity.getIntent();
            if (intent == null) {
                com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "Activity's intent is null.");
            } else if (!TextUtils.isEmpty(intent.getStringExtra("PROXY_PACKAGE"))) {
                String stringExtra2 = intent.getStringExtra("PROXY_PACKAGE");
                bundleZzf.putString("proxyPackage", stringExtra2);
                bundleZzf.putString("proxyPackageVersion", this.zzg.getPackageManager().getPackageInfo(stringExtra2, 0).versionName);
            }
            if (!this.zzu) {
                if (!this.zzs) {
                    if (this.zzp) {
                        i = 9;
                    } else {
                        i = 6;
                    }
                } else if (this.zzp) {
                    i = 9;
                } else {
                    i = 6;
                }
            } else if (!this.zzs) {
                if (this.zzp) {
                    i = 9;
                } else {
                    i = 6;
                }
            } else if (this.zzp) {
                i = 9;
            } else {
                i = 6;
            }
            final int i5 = i;
            str = str2;
            jNextLong = jNextLong;
            futureZzK = zzK(new Callable() {
                @Override
                public final Object call() {
                    return this.zza.zzat(i5, str3, str4, billingFlowParams, bundleZzf);
                }
            }, 5000L, null, this.zze, zzJ());
            r10 = bundleZzf;
        } else {
            str = null;
            z = zZzd;
            final String str5 = str3;
            futureZzK = zzK(new Callable() {
                @Override
                public final Object call() {
                    return this.zza.zzau(str5, str4);
                }
            }, 5000L, null, this.zze, zzJ());
            r10 = str5;
        }
        try {
            if (futureZzK == null) {
                try {
                    zzjd zzjdVar9 = zzjd.zzy;
                    BillingResult billingResult9 = zzdc.zzc;
                    zzbv(zzjdVar9, 2, billingResult9, jNextLong, z);
                    zzn(billingResult9);
                    return billingResult9;
                } catch (CancellationException e) {
                    e = e;
                    r10 = jNextLong;
                    z2 = z;
                    com.google.android.gms.internal.play_billing.zzc.zzp("BillingClient", "Time out while launching billing flow. Try to reconnect", e);
                    zzjd zzjdVar10 = zzjd.zzd;
                    BillingResult billingResult10 = zzdc.zzk;
                    zzbw(zzjdVar10, 2, billingResult10, zzcy.zza(e), r10, z2);
                    zzn(billingResult10);
                    return billingResult10;
                } catch (TimeoutException e2) {
                    e = e2;
                    r10 = jNextLong;
                    z2 = z;
                    com.google.android.gms.internal.play_billing.zzc.zzp("BillingClient", "Time out while launching billing flow. Try to reconnect", e);
                    zzjd zzjdVar11 = zzjd.zzd;
                    BillingResult billingResult11 = zzdc.zzk;
                    zzbw(zzjdVar11, 2, billingResult11, zzcy.zza(e), r10, z2);
                    zzn(billingResult11);
                    return billingResult11;
                } catch (Exception e3) {
                    e = e3;
                    r10 = jNextLong;
                    z2 = z;
                    com.google.android.gms.internal.play_billing.zzc.zzp("BillingClient", "Exception while launching billing flow. Try to reconnect", e);
                    zzjd zzjdVar12 = zzjd.zze;
                    BillingResult billingResult12 = zzdc.zzj;
                    zzbw(zzjdVar12, 2, billingResult12, zzcy.zza(e), r10, z2);
                    zzn(billingResult12);
                    return billingResult12;
                }
            }
            r10 = jNextLong;
            Bundle bundle = (Bundle) futureZzK.get(5000L, TimeUnit.MILLISECONDS);
            int iZzb = com.google.android.gms.internal.play_billing.zzc.zzb(bundle, "BillingClient");
            String strZzk = com.google.android.gms.internal.play_billing.zzc.zzk(bundle, "BillingClient");
            if (iZzb == 0) {
                ?? intent2 = new Intent((Context) activity, (Class<?>) ProxyBillingActivity.class);
                intent2.putExtra("BUY_INTENT", (PendingIntent) bundle.getParcelable("BUY_INTENT"));
                intent2.putExtra("billingClientTransactionId", r10);
                z2 = z;
                try {
                    intent2.putExtra("wasServiceAutoReconnected", z2);
                    activity.startActivity(intent2);
                    return zzdc.zzi;
                } catch (CancellationException e4) {
                    e = e4;
                    com.google.android.gms.internal.play_billing.zzc.zzp("BillingClient", "Time out while launching billing flow. Try to reconnect", e);
                    zzjd zzjdVar13 = zzjd.zzd;
                    BillingResult billingResult13 = zzdc.zzk;
                    zzbw(zzjdVar13, 2, billingResult13, zzcy.zza(e), r10, z2);
                    zzn(billingResult13);
                    return billingResult13;
                } catch (TimeoutException e5) {
                    e = e5;
                    com.google.android.gms.internal.play_billing.zzc.zzp("BillingClient", "Time out while launching billing flow. Try to reconnect", e);
                    zzjd zzjdVar14 = zzjd.zzd;
                    BillingResult billingResult14 = zzdc.zzk;
                    zzbw(zzjdVar14, 2, billingResult14, zzcy.zza(e), r10, z2);
                    zzn(billingResult14);
                    return billingResult14;
                } catch (Exception e6) {
                    e = e6;
                    com.google.android.gms.internal.play_billing.zzc.zzp("BillingClient", "Exception while launching billing flow. Try to reconnect", e);
                    zzjd zzjdVar15 = zzjd.zze;
                    BillingResult billingResult15 = zzdc.zzj;
                    zzbw(zzjdVar15, 2, billingResult15, zzcy.zza(e), r10, z2);
                    zzn(billingResult15);
                    return billingResult15;
                }
            }
            com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "Unable to buy item, Error response code: " + iZzb);
            BillingResult billingResultZza = zzdc.zza(iZzb, strZzk);
            try {
                if (bundle == null || (obj = bundle.get("LOG_REASON")) == null) {
                    zzjdVarZzb = zzjd.zza;
                } else if (obj instanceof Integer) {
                    zzjdVarZzb = zzjd.zzb(((Integer) obj).intValue());
                } else {
                    com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "Unexpected type for bundle log reason: " + obj.getClass().getName());
                    zzjdVarZzb = zzjd.zza;
                }
            } catch (Throwable th) {
                com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "Failed to get log reason from bundle: ".concat(String.valueOf(th.getMessage())));
                zzjdVarZzb = zzjd.zza;
            }
            if (zzjdVarZzb == zzjd.zza) {
                zzjdVarZzb = zzjd.zzw;
            }
            zzjd zzjdVar16 = zzjdVarZzb;
            if (bundle == null) {
                string = str;
            } else {
                try {
                    string = bundle.getString("ADDITIONAL_LOG_DETAILS");
                } catch (Throwable th2) {
                    com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "Failed to get additional log details from bundle: ".concat(String.valueOf(th2.getMessage())));
                    string = str;
                }
            }
            zzbw(zzjdVar16, 2, billingResultZza, string, r10, z);
            zzn(billingResultZza);
            return billingResultZza;
        } catch (CancellationException e7) {
            e = e7;
        } catch (TimeoutException e8) {
            e = e8;
        } catch (Exception e9) {
            e = e9;
        }
    }

    @Override
    public void launchExternalLink(final Activity activity, final LaunchExternalLinkParams launchExternalLinkParams, final LaunchExternalLinkResponseListener launchExternalLinkResponseListener) {
        if (activity == null) {
            throw new IllegalArgumentException("Please provide a valid activity.");
        }
        try {
            zzaN(new Callable() {
                @Override
                public final Object call() {
                    BillingClientImpl.zzD(this.zza, launchExternalLinkResponseListener, launchExternalLinkParams, activity);
                    return null;
                }
            }, 30000L, new Runnable() {
                @Override
                public final void run() {
                    this.zza.zzaZ(launchExternalLinkResponseListener, zzdc.zzk, zzjd.zzx, null);
                }
            }, zzav());
        } catch (Exception e) {
            zzaZ(launchExternalLinkResponseListener, zzay(), zzjd.zzbb, e);
        }
    }

    @Override
    public void queryProductDetailsAsync(final QueryProductDetailsParams queryProductDetailsParams, final ProductDetailsResponseListener productDetailsResponseListener) {
        if (zzK(new Callable() {
            @Override
            public final Object call() throws JSONException {
                BillingClientImpl.zzt(this.zza, productDetailsResponseListener, queryProductDetailsParams);
                return null;
            }
        }, 30000L, new Runnable() {
            @Override
            public final void run() {
                BillingClientImpl.zzT(this.zza, productDetailsResponseListener);
            }
        }, zzav(), zzJ()) == null) {
            BillingResult billingResultZzay = zzay();
            zzbs(zzjd.zzy, 7, billingResultZzay);
            productDetailsResponseListener.onProductDetailsResponse(billingResultZzay, new QueryProductDetailsResult(com.google.android.gms.internal.play_billing.zzbw.zzk(), com.google.android.gms.internal.play_billing.zzbw.zzk()));
        }
    }

    @Override
    public final void queryPurchasesAsync(QueryPurchasesParams queryPurchasesParams, final PurchasesResponseListener purchasesResponseListener) {
        if (zzK(new zzbm(this, purchasesResponseListener, queryPurchasesParams.zza(), queryPurchasesParams.getIncludeSuspendedSubscriptions()), 30000L, new Runnable() {
            @Override
            public final void run() {
                BillingClientImpl.zzM(this.zza, purchasesResponseListener);
            }
        }, zzav(), zzJ()) == null) {
            BillingResult billingResultZzay = zzay();
            zzbs(zzjd.zzy, 9, billingResultZzay);
            purchasesResponseListener.onQueryPurchasesResponse(billingResultZzay, com.google.android.gms.internal.play_billing.zzbw.zzk());
        }
    }

    @Override
    public final BillingResult showInAppMessages(final Activity activity, InAppMessageParams inAppMessageParams, InAppMessageResponseListener inAppMessageResponseListener) {
        if (!zzbk(3000L)) {
            com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "Service disconnected.");
            return zzdc.zzj;
        }
        if (!this.zzq) {
            com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "Current client doesn't support showing in-app messages.");
            return zzdc.zzs;
        }
        View viewFindViewById = activity.findViewById(R.id.content);
        IBinder windowToken = viewFindViewById.getWindowToken();
        Rect rect = new Rect();
        viewFindViewById.getGlobalVisibleRect(rect);
        final Bundle bundle = new Bundle();
        BundleCompat.putBinder(bundle, "KEY_WINDOW_TOKEN", windowToken);
        bundle.putInt("KEY_DIMEN_LEFT", rect.left);
        bundle.putInt("KEY_DIMEN_TOP", rect.top);
        bundle.putInt("KEY_DIMEN_RIGHT", rect.right);
        bundle.putInt("KEY_DIMEN_BOTTOM", rect.bottom);
        bundle.putString("playBillingLibraryVersion", this.zzc);
        String str = this.zzd;
        if (str != null) {
            bundle.putString("playBillingLibraryWrapperVersion", str);
        }
        bundle.putIntegerArrayList("KEY_CATEGORY_IDS", inAppMessageParams.zza());
        Handler handler = this.zze;
        final zzbn zzbnVar = new zzbn(this, handler, inAppMessageResponseListener);
        zzK(new Callable() {
            @Override
            public final Object call() throws Exception {
                BillingClientImpl.zzv(this.zza, bundle, activity, zzbnVar);
                return null;
            }
        }, 5000L, null, handler, zzJ());
        return zzdc.zzi;
    }

    final synchronized ExecutorService zzJ() {
        if (this.zzI == null) {
            this.zzI = Executors.newFixedThreadPool(com.google.android.gms.internal.play_billing.zzc.zza, new zzbl(this));
        }
        return this.zzI;
    }

    public final void zzao(Runnable runnable) {
        if (Looper.myLooper() == Looper.getMainLooper()) {
            runnable.run();
        } else {
            this.zze.post(runnable);
        }
    }

    final zzcg zzh(QueryProductDetailsParams queryProductDetailsParams) throws JSONException {
        com.google.android.gms.internal.play_billing.zzap zzapVar;
        ArrayList arrayList = new ArrayList();
        ArrayList arrayList2 = new ArrayList();
        String strZzb = queryProductDetailsParams.zzb();
        com.google.android.gms.internal.play_billing.zzbw zzbwVarZza = queryProductDetailsParams.zza();
        int size = zzbwVarZza.size();
        int i = 0;
        while (i < size) {
            int i2 = i + 20;
            ArrayList<QueryProductDetailsParams.Product> arrayList3 = new ArrayList(zzbwVarZza.subList(i, i2 > size ? size : i2));
            ArrayList<String> arrayList4 = new ArrayList<>();
            int size2 = arrayList3.size();
            for (int i3 = 0; i3 < size2; i3++) {
                arrayList4.add(((QueryProductDetailsParams.Product) arrayList3.get(i3)).zza());
            }
            Bundle bundle = new Bundle();
            bundle.putStringArrayList("ITEM_ID_LIST", arrayList4);
            String str = this.zzc;
            bundle.putString("playBillingLibraryVersion", str);
            try {
                synchronized (this.zza) {
                    zzapVar = this.zzi;
                }
                if (zzapVar == null) {
                    return zzaw(zzdc.zzj, zzjd.zzbc, "Service has been reset to null.", null);
                }
                boolean z = this.zzw && this.zzE.isEnabledForPrepaidPlans();
                zzaD(queryProductDetailsParams);
                zzaD(queryProductDetailsParams);
                zzaD(queryProductDetailsParams);
                zzaD(queryProductDetailsParams);
                Bundle bundleZzj = zzapVar.zzj(true != this.zzx ? 17 : 20, this.zzg.getPackageName(), strZzb, bundle, com.google.android.gms.internal.play_billing.zzc.zzg(str, this.zzd, arrayList3, (String) null, (String) null, com.google.android.gms.internal.play_billing.zza.zza(z, true, true, true, false, true), this.zzJ.longValue()));
                if (bundleZzj == null) {
                    return zzaw(zzdc.zzA, zzjd.zzR, "queryProductDetailsAsync got empty product details response.", null);
                }
                if (!bundleZzj.containsKey("DETAILS_LIST")) {
                    int iZzb = com.google.android.gms.internal.play_billing.zzc.zzb(bundleZzj, "BillingClient");
                    String strZzk = com.google.android.gms.internal.play_billing.zzc.zzk(bundleZzj, "BillingClient");
                    if (iZzb == 0) {
                        return zzaw(zzdc.zza(6, strZzk), zzjd.zzS, "getSkuDetails() returned a bundle with neither an error nor a product detail list for queryProductDetailsAsync.", null);
                    }
                    return zzaw(zzdc.zza(iZzb, strZzk), zzjd.zzw, "getSkuDetails() failed for queryProductDetailsAsync. Response code: " + iZzb, null);
                }
                ArrayList<String> stringArrayList = bundleZzj.getStringArrayList("DETAILS_LIST");
                if (stringArrayList == null) {
                    return zzaw(zzdc.zzA, zzjd.zzT, "queryProductDetailsAsync got null response list", null);
                }
                ArrayList arrayList5 = new ArrayList();
                int size3 = stringArrayList.size();
                for (int i4 = 0; i4 < size3; i4++) {
                    try {
                        ProductDetails productDetails = new ProductDetails(stringArrayList.get(i4));
                        com.google.android.gms.internal.play_billing.zzc.zzn("BillingClient", "Got product details: ".concat(productDetails.toString()));
                        arrayList5.add(productDetails);
                    } catch (JSONException e) {
                        return zzaw(zzdc.zza(6, "Error trying to decode SkuDetails."), zzjd.zzU, "Got a JSON exception trying to decode ProductDetails. \n Exception: ", e);
                    }
                }
                ArrayList<String> stringArrayList2 = bundleZzj.getStringArrayList("UNFETCHED_PRODUCT_LIST");
                new ArrayList();
                try {
                    ArrayList arrayList6 = new ArrayList();
                    if (stringArrayList2 == null) {
                        for (QueryProductDetailsParams.Product product : arrayList3) {
                            Iterator it = arrayList5.iterator();
                            while (true) {
                                if (!it.hasNext()) {
                                    arrayList6.add(new UnfetchedProduct(new JSONObject().put("productId", product.zza()).put("type", product.zzb()).put("statusCode", 0).toString()));
                                    break;
                                }
                                ProductDetails productDetails2 = (ProductDetails) it.next();
                                if (product.zza().equals(productDetails2.getProductId()) && product.zzb().equals(productDetails2.getProductType())) {
                                    break;
                                }
                            }
                        }
                    } else {
                        Iterator<String> it2 = stringArrayList2.iterator();
                        while (it2.hasNext()) {
                            UnfetchedProduct unfetchedProduct = new UnfetchedProduct(it2.next());
                            com.google.android.gms.internal.play_billing.zzc.zzn("BillingClient", "Got unfetchedProduct: ".concat(unfetchedProduct.toString()));
                            arrayList6.add(unfetchedProduct);
                        }
                    }
                    arrayList.addAll(arrayList5);
                    arrayList2.addAll(arrayList6);
                    i = i2;
                } catch (JSONException e2) {
                    return zzaw(zzdc.zza(6, "Error trying to decode SkuDetails."), zzjd.zzU, "Got a JSON exception trying to decode UnfetchedProduct. \n Exception: ", e2);
                }
            } catch (DeadObjectException e3) {
                return zzaw(zzdc.zzj, zzjd.zzQ, "queryProductDetailsAsync got a remote exception (try to reconnect).", e3);
            } catch (Exception e4) {
                return zzaw(zzdc.zzh, zzjd.zzQ, "queryProductDetailsAsync got a remote exception (try to reconnect).", e4);
            }
        }
        return new zzcg(0, "", arrayList, arrayList2);
    }

    final zzcz zzk() {
        return this.zzh;
    }

    public final BillingResult zzn(final BillingResult billingResult) {
        if (Thread.interrupted()) {
            return billingResult;
        }
        this.zze.post(new Runnable() {
            @Override
            public final void run() {
                BillingClientImpl.zzV(this.zza, billingResult);
            }
        });
        return billingResult;
    }

    @Override
    public BillingResult showAlternativeBillingOnlyInformationDialog(final Activity activity, final AlternativeBillingOnlyInformationDialogListener alternativeBillingOnlyInformationDialogListener) {
        if (activity == null) {
            throw new IllegalArgumentException("Please provide a valid activity.");
        }
        if (!zzbk(3000L)) {
            zzjd zzjdVar = zzjd.zzb;
            BillingResult billingResult = zzdc.zzj;
            zzbs(zzjdVar, 16, billingResult);
            return billingResult;
        }
        if (!this.zzy) {
            com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "Current Play Store version doesn't support alternative billing only.");
            zzjd zzjdVar2 = zzjd.zzan;
            BillingResult billingResult2 = zzdc.zzC;
            zzbs(zzjdVar2, 16, billingResult2);
            return billingResult2;
        }
        Handler handler = this.zze;
        final zzbo zzboVar = new zzbo(this, handler, alternativeBillingOnlyInformationDialogListener);
        if (zzK(new Callable() {
            @Override
            public final Object call() throws Exception {
                BillingClientImpl.zzA(this.zza, alternativeBillingOnlyInformationDialogListener, activity, zzboVar);
                return null;
            }
        }, 30000L, new Runnable() {
            @Override
            public final void run() {
                this.zza.zzba(alternativeBillingOnlyInformationDialogListener, zzdc.zzk, zzjd.zzx, null);
            }
        }, handler, zzJ()) != null) {
            return zzdc.zzi;
        }
        BillingResult billingResultZzay = zzay();
        zzbs(zzjd.zzy, 16, billingResultZzay);
        return billingResultZzay;
    }

    @Override
    public BillingResult showExternalOfferInformationDialog(final Activity activity, final ExternalOfferInformationDialogListener externalOfferInformationDialogListener) {
        if (activity == null) {
            throw new IllegalArgumentException("Please provide a valid activity.");
        }
        if (!zzbk(3000L)) {
            zzjd zzjdVar = zzjd.zzb;
            BillingResult billingResult = zzdc.zzj;
            zzbs(zzjdVar, 25, billingResult);
            return billingResult;
        }
        if (!this.zzz) {
            com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "Current Play Store version doesn't support external offer.");
            zzjd zzjdVar2 = zzjd.zzaE;
            BillingResult billingResult2 = zzdc.zzt;
            zzbs(zzjdVar2, 25, billingResult2);
            return billingResult2;
        }
        Handler handler = this.zze;
        final zzbp zzbpVar = new zzbp(this, handler, externalOfferInformationDialogListener);
        if (zzK(new Callable() {
            @Override
            public final Object call() throws Exception {
                BillingClientImpl.zzF(this.zza, externalOfferInformationDialogListener, activity, zzbpVar);
                return null;
            }
        }, 30000L, new Runnable() {
            @Override
            public final void run() {
                this.zza.zzaX(externalOfferInformationDialogListener, zzdc.zzk, zzjd.zzx, null);
            }
        }, handler, zzJ()) != null) {
            return zzdc.zzi;
        }
        BillingResult billingResultZzay = zzay();
        zzbs(zzjd.zzy, 25, billingResultZzay);
        return billingResultZzay;
    }

    @Override
    public void startConnection(BillingClientStateListener billingClientStateListener) {
        zzbi(billingClientStateListener, 0);
    }

    private BillingClientImpl(Context context, PendingPurchasesParams pendingPurchasesParams, PurchasesUpdatedListener purchasesUpdatedListener, String str, String str2, UserChoiceBillingListener userChoiceBillingListener, DeveloperProvidedBillingListener developerProvidedBillingListener, zzcz zzczVar, ExecutorService executorService, BillingClient.Builder builder) {
        this.zza = new Object();
        this.zzb = 0;
        this.zze = new Handler(Looper.getMainLooper());
        this.zzm = 0;
        this.zzJ = Long.valueOf(new Random().nextLong());
        this.zzK = com.google.android.gms.internal.play_billing.zzbd.zza();
        this.zzc = str;
        this.zzd = zzaE();
        initialize(context, purchasesUpdatedListener, pendingPurchasesParams, userChoiceBillingListener, developerProvidedBillingListener, str, null, builder);
    }

    private BillingClientImpl(String str) {
        this.zza = new Object();
        this.zzb = 0;
        this.zze = new Handler(Looper.getMainLooper());
        this.zzm = 0;
        this.zzJ = Long.valueOf(new Random().nextLong());
        this.zzK = com.google.android.gms.internal.play_billing.zzbd.zza();
        this.zzc = str;
        this.zzd = zzaE();
    }

    BillingClientImpl(String str, Context context, zzcz zzczVar, ExecutorService executorService, BillingClient.Builder builder) {
        this.zza = new Object();
        this.zzb = 0;
        this.zze = new Handler(Looper.getMainLooper());
        this.zzm = 0;
        Long lValueOf = Long.valueOf(new Random().nextLong());
        this.zzJ = lValueOf;
        this.zzK = com.google.android.gms.internal.play_billing.zzbd.zza();
        this.zzc = BuildConfig.VERSION_NAME;
        String strZzaE = zzaE();
        this.zzd = strZzaE;
        this.zzg = context.getApplicationContext();
        zzjp zzjpVarZza = zzjr.zza();
        zzjpVarZza.zzx(BuildConfig.VERSION_NAME);
        if (strZzaE != null) {
            zzjpVarZza.zzy(strZzaE);
        }
        zzjpVarZza.zzq(this.zzg.getPackageName());
        zzjpVarZza.zzd(lValueOf.longValue());
        zzjpVarZza.zzw(builder.zza);
        zzjpVarZza.zza(Build.VERSION.SDK_INT);
        zzjpVarZza.zzp(846465066L);
        zzbo(zzjpVarZza, context);
        try {
            zzjpVarZza.zzb(this.zzg.getPackageManager().getPackageInfo(this.zzg.getPackageName(), 0).versionCode);
        } catch (Throwable th) {
            com.google.android.gms.internal.play_billing.zzc.zzp("BillingClient", "Error getting app version code.", th);
        }
        this.zzh = new zzdl(this.zzg, zzjpVarZza.zzi());
        this.zzg.getPackageName();
        com.google.android.gms.internal.play_billing.zzbo zzboVar = builder.zzb;
        this.zzF = builder.zza;
    }

    private void initialize(Context context, PurchasesUpdatedListener purchasesUpdatedListener, PendingPurchasesParams pendingPurchasesParams, UserChoiceBillingListener userChoiceBillingListener, DeveloperProvidedBillingListener developerProvidedBillingListener, String str, zzcz zzczVar, BillingClient.Builder builder) {
        this.zzg = context.getApplicationContext();
        zzjp zzjpVarZza = zzjr.zza();
        zzjpVarZza.zzx(str);
        String str2 = this.zzd;
        if (str2 != null) {
            zzjpVarZza.zzy(str2);
        }
        zzjpVarZza.zzq(this.zzg.getPackageName());
        zzjpVarZza.zzd(this.zzJ.longValue());
        zzjpVarZza.zzw(builder.zza);
        zzjpVarZza.zza(Build.VERSION.SDK_INT);
        zzjpVarZza.zzp(846465066L);
        zzbo(zzjpVarZza, context);
        try {
            zzjpVarZza.zzb(this.zzg.getPackageManager().getPackageInfo(this.zzg.getPackageName(), 0).versionCode);
        } catch (Throwable th) {
            com.google.android.gms.internal.play_billing.zzc.zzp("BillingClient", "Error getting app version code.", th);
        }
        if (zzczVar != null) {
            this.zzh = zzczVar;
        } else {
            this.zzh = new zzdl(this.zzg, zzjpVarZza.zzi());
        }
        if (purchasesUpdatedListener == null) {
            com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "Billing client should have a valid listener but the provided is null.");
        }
        this.zzf = new zzab(this.zzg, purchasesUpdatedListener, null, null, userChoiceBillingListener, developerProvidedBillingListener, this.zzh);
        this.zzE = pendingPurchasesParams;
        this.zzG = userChoiceBillingListener != null;
        com.google.android.gms.internal.play_billing.zzbo zzboVar = builder.zzb;
        this.zzF = builder.zza;
    }

    BillingClientImpl(String str, PendingPurchasesParams pendingPurchasesParams, Context context, zzdo zzdoVar, zzcz zzczVar, ExecutorService executorService, BillingClient.Builder builder) {
        this.zza = new Object();
        this.zzb = 0;
        this.zze = new Handler(Looper.getMainLooper());
        this.zzm = 0;
        Long lValueOf = Long.valueOf(new Random().nextLong());
        this.zzJ = lValueOf;
        this.zzK = com.google.android.gms.internal.play_billing.zzbd.zza();
        this.zzc = BuildConfig.VERSION_NAME;
        String strZzaE = zzaE();
        this.zzd = strZzaE;
        this.zzg = context.getApplicationContext();
        zzjp zzjpVarZza = zzjr.zza();
        zzjpVarZza.zzx(BuildConfig.VERSION_NAME);
        if (strZzaE != null) {
            zzjpVarZza.zzy(strZzaE);
        }
        zzjpVarZza.zzq(this.zzg.getPackageName());
        zzjpVarZza.zzd(lValueOf.longValue());
        zzjpVarZza.zzw(builder.zza);
        zzjpVarZza.zza(Build.VERSION.SDK_INT);
        zzjpVarZza.zzp(846465066L);
        zzbo(zzjpVarZza, context);
        try {
            zzjpVarZza.zzb(this.zzg.getPackageManager().getPackageInfo(this.zzg.getPackageName(), 0).versionCode);
        } catch (Throwable th) {
            com.google.android.gms.internal.play_billing.zzc.zzp("BillingClient", "Error getting app version code.", th);
        }
        this.zzh = new zzdl(this.zzg, zzjpVarZza.zzi());
        com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "Billing client should have a valid listener but the provided is null.");
        this.zzf = new zzab(this.zzg, null, null, null, null, null, this.zzh);
        this.zzE = pendingPurchasesParams;
        this.zzg.getPackageName();
        com.google.android.gms.internal.play_billing.zzbo zzboVar = builder.zzb;
        this.zzF = builder.zza;
    }

    BillingClientImpl(String str, PendingPurchasesParams pendingPurchasesParams, Context context, PurchasesUpdatedListener purchasesUpdatedListener, zzb zzbVar, zzcz zzczVar, ExecutorService executorService, BillingClient.Builder builder) {
        this.zza = new Object();
        this.zzb = 0;
        this.zze = new Handler(Looper.getMainLooper());
        this.zzm = 0;
        this.zzJ = Long.valueOf(new Random().nextLong());
        this.zzK = com.google.android.gms.internal.play_billing.zzbd.zza();
        this.zzc = BuildConfig.VERSION_NAME;
        this.zzd = zzaE();
        initialize(context, purchasesUpdatedListener, pendingPurchasesParams, null, BuildConfig.VERSION_NAME, null, builder);
    }

    BillingClientImpl(String str, PendingPurchasesParams pendingPurchasesParams, Context context, PurchasesUpdatedListener purchasesUpdatedListener, UserChoiceBillingListener userChoiceBillingListener, DeveloperProvidedBillingListener developerProvidedBillingListener, zzcz zzczVar, ExecutorService executorService, BillingClient.Builder builder) {
        this(context, pendingPurchasesParams, purchasesUpdatedListener, BuildConfig.VERSION_NAME, null, userChoiceBillingListener, developerProvidedBillingListener, null, null, builder);
    }
}
