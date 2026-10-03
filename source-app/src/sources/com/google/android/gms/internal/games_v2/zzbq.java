package com.google.android.gms.internal.games_v2;

import android.app.Activity;
import android.app.Application;
import android.app.PendingIntent;
import android.content.pm.PackageInfo;
import android.os.Looper;
import androidx.compose.animation.core.ComplexDouble$;
import com.google.android.gms.common.api.ApiException;
import com.google.android.gms.common.api.GoogleApi;
import com.google.android.gms.common.api.ResolvableApiException;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.common.internal.Preconditions;
import com.google.android.gms.common.util.ClientLibraryUtils;
import com.google.android.gms.games.AuthenticationResult;
import com.google.android.gms.games.gamessignin.AuthResponse;
import com.google.android.gms.tasks.Continuation;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.SuccessContinuation;
import com.google.android.gms.tasks.Task;
import com.google.android.gms.tasks.TaskCompletionSource;
import com.google.android.gms.tasks.TaskExecutors;
import com.google.android.gms.tasks.Tasks;
import java.util.ArrayDeque;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Queue;
import java.util.concurrent.atomic.AtomicReference;

public final class zzbq implements zzaw {
    private final AtomicReference zza = new AtomicReference(zzba.UNINITIALIZED);
    private final AtomicReference zzb = new AtomicReference(zzaz.AUTOMATIC);
    private final Queue zzc = new ArrayDeque();
    private final AtomicReference zzd = new AtomicReference();
    private final AtomicReference zze = new AtomicReference();
    private final Application zzf;
    private final com.google.android.gms.games.internal.zzf zzg;
    private final zzbr zzh;

    zzbq(Application application, com.google.android.gms.games.internal.zzf zzfVar, com.google.android.gms.games.internal.p000v2.resolution.zzb zzbVar, zzbr zzbrVar) {
        this.zzf = application;
        this.zzg = zzfVar;
        this.zzh = zzbrVar;
    }

    private final void zzm(int i) {
        zzaz zzazVar;
        StringBuilder sb = new StringBuilder(String.valueOf(i).length() + 45);
        sb.append("startAuthenticationIfNecessary() signInType: ");
        sb.append(i);
        zzfn.zza("GamesApiManager", sb.toString());
        Preconditions.checkMainThread("Must be called on the main thread.");
        AtomicReference atomicReference = this.zza;
        zzba zzbaVar = zzba.UNINITIALIZED;
        zzba zzbaVar2 = zzba.AUTHENTICATING;
        int i2 = 0;
        if (!ComplexDouble$.ExternalSyntheticBackport0.m(atomicReference, zzbaVar, zzbaVar2)) {
            if (i != 1) {
                if (ComplexDouble$.ExternalSyntheticBackport0.m(atomicReference, zzba.AUTHENTICATION_FAILED, zzbaVar2)) {
                    i = 0;
                } else {
                    boolean zM = ComplexDouble$.ExternalSyntheticBackport0.m(this.zzb, zzaz.AUTOMATIC, zzaz.AUTOMATIC_PENDING_EXPLICIT);
                    StringBuilder sb2 = new StringBuilder(String.valueOf(zM).length() + 83);
                    sb2.append("Explicit sign-in during existing authentication. Marking pending explicit sign-in: ");
                    sb2.append(zM);
                    zzfn.zza("GamesApiManager", sb2.toString());
                }
            }
            String strValueOf = String.valueOf(atomicReference.get());
            String.valueOf(strValueOf);
            zzfn.zza("GamesApiManager", "Authentication attempt skipped. Already authenticated or authenticating. State: ".concat(String.valueOf(strValueOf)));
            return;
        }
        AtomicReference atomicReference2 = this.zzd;
        TaskCompletionSource taskCompletionSource = (TaskCompletionSource) atomicReference2.get();
        if (taskCompletionSource != null) {
            taskCompletionSource.trySetException(new IllegalStateException("New authentication attempt in progress"));
        }
        TaskCompletionSource taskCompletionSource2 = new TaskCompletionSource();
        atomicReference2.set(taskCompletionSource2);
        AtomicReference atomicReference3 = this.zzb;
        if (i == 0) {
            zzazVar = zzaz.EXPLICIT;
        } else {
            zzazVar = zzaz.AUTOMATIC;
            i2 = 1;
        }
        atomicReference3.set(zzazVar);
        zzn(taskCompletionSource2, zzq.zza(i2));
    }

    private final void zzn(final TaskCompletionSource taskCompletionSource, final zzq zzqVar) {
        zzfn.zza("GamesApiManager", "Attempting authentication: ".concat(zzqVar.toString()));
        this.zzh.zza(zzqVar).addOnCompleteListener(TaskExecutors.MAIN_THREAD, new OnCompleteListener() {
            @Override
            public final void onComplete(Task task) {
                this.zza.zzk(taskCompletionSource, zzqVar, task);
            }
        });
    }

    private final void zzo(final TaskCompletionSource taskCompletionSource, final int i, PendingIntent pendingIntent, boolean z, boolean z2) {
        Activity activityZzd;
        Preconditions.checkMainThread("Must be called on the main thread.");
        Application application = this.zzf;
        int clientVersion = ClientLibraryUtils.getClientVersion(application, "com.google.android.gms");
        zzfn.zza("GamesApiManager", String.format(Locale.US, "GmsCore version is %d", Integer.valueOf(clientVersion)));
        if (clientVersion < 220812000) {
            PackageInfo packageInfo = ClientLibraryUtils.getPackageInfo(application, "com.android.vending");
            if (packageInfo == null) {
                zzfn.zza("GamesApiManager", "PlayStore is not installed");
            } else {
                int i2 = packageInfo.versionCode;
                if (i2 < 82470600) {
                    zzfn.zza("GamesApiManager", String.format(Locale.US, "PlayStore version is below resolution threshold: %s", Integer.valueOf(i2)));
                } else {
                    zzfn.zza("GamesApiManager", "Installed PlayStore version can be used for resolution.");
                }
            }
            zzfn.zze("GamesApiManager", "PlayStore is too old or not available and the version of GmsCore would attempt PGA installation on automatic sign-in. Skipping it.");
            taskCompletionSource.trySetResult(false);
            this.zza.set(zzba.AUTHENTICATION_FAILED);
            return;
        }
        if (z && pendingIntent != null && (activityZzd = this.zzg.zzd()) != null) {
            com.google.android.gms.games.internal.p000v2.resolution.zzb.zzb(activityZzd, pendingIntent).addOnCompleteListener(TaskExecutors.MAIN_THREAD, new OnCompleteListener() {
                @Override
                public final void onComplete(Task task) {
                    this.zza.zzl(taskCompletionSource, i, task);
                }
            });
            zzfn.zza("GamesApiManager", "Resolution triggered");
            return;
        }
        boolean zM = ComplexDouble$.ExternalSyntheticBackport0.m(this.zzb, zzaz.AUTOMATIC_PENDING_EXPLICIT, zzaz.EXPLICIT);
        if (!z2 && zM) {
            zzfn.zza("GamesApiManager", "Consumed pending explicit sign-in. Attempting explicit sign-in");
            zzn(taskCompletionSource, zzq.zza(0));
            return;
        }
        taskCompletionSource.trySetResult(false);
        this.zza.set(zzba.AUTHENTICATION_FAILED);
        Iterator it = this.zzc.iterator();
        while (it.hasNext()) {
            ((zzbc) it.next()).zzb(zzr());
            it.remove();
        }
    }

    private static boolean zzp() {
        return Looper.myLooper() == Looper.getMainLooper();
    }

    private static Task zzq(final zzip zzipVar) {
        if (zzp()) {
            return (Task) zzipVar.zza();
        }
        final TaskCompletionSource taskCompletionSource = new TaskCompletionSource();
        TaskExecutors.MAIN_THREAD.execute(new Runnable() {
            @Override
            public final void run() {
                Task task = (Task) zzipVar.zza();
                final TaskCompletionSource taskCompletionSource2 = taskCompletionSource;
                task.addOnCompleteListener(new OnCompleteListener() {
                    @Override
                    public final void onComplete(Task task2) {
                        TaskCompletionSource taskCompletionSource3 = taskCompletionSource2;
                        if (task2.isSuccessful()) {
                            taskCompletionSource3.trySetResult(task2.getResult());
                            return;
                        }
                        Exception exception = task2.getException();
                        zzfw.zza(exception);
                        taskCompletionSource3.trySetException(exception);
                    }
                });
            }
        });
        return taskCompletionSource.getTask();
    }

    private static ApiException zzr() {
        return new ApiException(new Status(4));
    }

    private static Task zzs(AtomicReference atomicReference, TaskCompletionSource taskCompletionSource) {
        int iOrdinal = ((zzba) atomicReference.get()).ordinal();
        if (iOrdinal == 0) {
            return Tasks.forException(new ApiException(new Status(10)));
        }
        if (iOrdinal == 2) {
            return Tasks.forResult(AuthenticationResult.zza);
        }
        if (iOrdinal == 3) {
            return Tasks.forResult(AuthenticationResult.zzb);
        }
        if (taskCompletionSource == null) {
            return Tasks.forResult(AuthenticationResult.zzb);
        }
        Task task = taskCompletionSource.getTask();
        if (task.isSuccessful()) {
            return ((Boolean) task.getResult()).booleanValue() ? Tasks.forResult(AuthenticationResult.zza) : Tasks.forResult(AuthenticationResult.zzb);
        }
        final TaskCompletionSource taskCompletionSource2 = new TaskCompletionSource();
        task.addOnCompleteListener(zzio.zza(), new OnCompleteListener() {
            @Override
            public final void onComplete(Task task2) {
                TaskCompletionSource taskCompletionSource3 = taskCompletionSource2;
                if (task2.isSuccessful() && ((Boolean) task2.getResult()).booleanValue()) {
                    taskCompletionSource3.trySetResult(AuthenticationResult.zza);
                } else {
                    taskCompletionSource3.trySetResult(AuthenticationResult.zzb);
                }
            }
        });
        return taskCompletionSource2.getTask();
    }

    @Override
    public final Task zza(zzav zzavVar) {
        zzba zzbaVar = (zzba) this.zza.get();
        String strValueOf = String.valueOf(zzbaVar);
        String.valueOf(strValueOf);
        zzfn.zzc("GamesApiManager", "Executing API call with authentication state: ".concat(String.valueOf(strValueOf)));
        if (zzbaVar == zzba.AUTHENTICATED) {
            return zzavVar.zza((GoogleApi) this.zze.get());
        }
        if (zzbaVar == zzba.AUTHENTICATION_FAILED) {
            return Tasks.forException(zzr());
        }
        if (zzbaVar == zzba.UNINITIALIZED) {
            return Tasks.forException(new ApiException(new Status(10)));
        }
        TaskCompletionSource taskCompletionSource = new TaskCompletionSource();
        final zzbc zzbcVar = new zzbc(zzavVar, taskCompletionSource);
        Runnable runnable = new Runnable() {
            @Override
            public final void run() {
                this.zza.zzf(zzbcVar);
            }
        };
        if (zzp()) {
            runnable.run();
        } else {
            TaskExecutors.MAIN_THREAD.execute(runnable);
        }
        return taskCompletionSource.getTask();
    }

    @Override
    public final Task zzb(final zzau zzauVar, final List list) {
        return zza(new zzav() {
            @Override
            public final Task zza(GoogleApi googleApi) {
                return zzauVar.zza(googleApi, list);
            }
        }).continueWithTask(new Continuation() {
            @Override
            public final Object then(Task task) {
                return this.zza.zzg(zzauVar, list, task);
            }
        });
    }

    @Override
    public final Task zzc() {
        return zzs(this.zza, (TaskCompletionSource) this.zzd.get());
    }

    @Override
    public final Task zzd() {
        return zzq(new zzip() {
            @Override
            public final Object zza() {
                return this.zza.zzi();
            }
        });
    }

    @Override
    public final Task zze() {
        return zzq(new zzip() {
            @Override
            public final Object zza() {
                return this.zza.zzj();
            }
        });
    }

    final void zzf(zzbc zzbcVar) {
        Preconditions.checkMainThread("Must be called on the main thread.");
        zzba zzbaVar = (zzba) this.zza.get();
        if (zzbaVar == zzba.AUTHENTICATED) {
            zzbcVar.zza((GoogleApi) this.zze.get());
        } else if (zzbaVar == zzba.AUTHENTICATION_FAILED) {
            zzbcVar.zzb(zzr());
        } else {
            this.zzc.add(zzbcVar);
        }
    }

    final Task zzg(final zzau zzauVar, final List list, Task task) {
        Task task2;
        if (task.isSuccessful()) {
            return Tasks.forResult((AuthResponse) task.getResult());
        }
        Exception exception = task.getException();
        if (!(exception instanceof ResolvableApiException)) {
            if (exception == null) {
                exception = new ApiException(new Status(8));
            }
            return Tasks.forException(exception);
        }
        PendingIntent resolution = ((ResolvableApiException) exception).getResolution();
        if (resolution == null) {
            task2 = Tasks.forException(new IllegalArgumentException("Resolution intent must not be null."));
        } else {
            Activity activityZzd = this.zzg.zzd();
            if (activityZzd == null) {
                task2 = Tasks.forException(new IllegalStateException("Foreground activity is missing."));
            } else {
                final TaskCompletionSource taskCompletionSource = new TaskCompletionSource();
                com.google.android.gms.games.internal.p000v2.resolution.zzb.zzb(activityZzd, resolution).addOnSuccessListener(new OnSuccessListener() {
                    @Override
                    public final void onSuccess(Object obj) {
                        taskCompletionSource.setResult(obj);
                    }
                }).addOnFailureListener(new OnFailureListener() {
                    @Override
                    public final void onFailure(Exception exc) {
                        taskCompletionSource.setException(exc);
                    }
                });
                task2 = taskCompletionSource.getTask();
            }
        }
        return task2.onSuccessTask(new SuccessContinuation() {
            @Override
            public final Task then(Object obj) {
                return this.zza.zzh(list, zzauVar, (com.google.android.gms.games.internal.p000v2.resolution.zzc) obj);
            }
        });
    }

    final Task zzh(List list, zzau zzauVar, com.google.android.gms.games.internal.p000v2.resolution.zzc zzcVar) {
        if (!zzcVar.zzc()) {
            list = zzhd.zzi();
        }
        return zzauVar.zza((GoogleApi) this.zze.get(), list);
    }

    final Task zzi() {
        zzm(1);
        return zzs(this.zza, (TaskCompletionSource) this.zzd.get());
    }

    final Task zzj() {
        zzm(0);
        return zzs(this.zza, (TaskCompletionSource) this.zzd.get());
    }

    final void zzk(TaskCompletionSource taskCompletionSource, zzq zzqVar, Task task) {
        if (!task.isSuccessful()) {
            Exception exception = task.getException();
            zzfw.zza(exception);
            zzfn.zzb("GamesApiManager", "Authentication task failed", exception);
            zzo(taskCompletionSource, zzqVar.zzc(), null, false, !zzqVar.zzd());
            return;
        }
        zzbv zzbvVar = (zzbv) task.getResult();
        if (!zzbvVar.zzc()) {
            String strValueOf = String.valueOf(zzbvVar);
            String.valueOf(strValueOf);
            zzfn.zza("GamesApiManager", "Failed to authenticate: ".concat(String.valueOf(strValueOf)));
            zzo(taskCompletionSource, zzqVar.zzc(), zzbvVar.zze(), true, !zzqVar.zzd());
            return;
        }
        String strZzd = zzbvVar.zzd();
        if (strZzd == null) {
            zzfn.zze("GamesApiManager", "Unexpected state: game run token absent");
            zzo(taskCompletionSource, zzqVar.zzc(), null, false, !zzqVar.zzd());
            return;
        }
        zzfn.zza("GamesApiManager", "Successfully authenticated");
        Preconditions.checkMainThread("Must be called on the main thread.");
        com.google.android.gms.games.zzh zzhVarZza = com.google.android.gms.games.zzi.zza();
        zzhVarZza.zza(2101523);
        zzhVarZza.zzb(strZzd);
        com.google.android.gms.games.internal.zzh zzhVarZzd = com.google.android.gms.games.internal.zzi.zzd();
        zzhVarZzd.zza(true);
        zzhVarZzd.zzb(true);
        zzhVarZzd.zzc(true);
        zzhVarZza.zzc(zzhVarZzd.zzd());
        zzf zzfVar = new zzf(this.zzf, zzhVarZza.zzd());
        this.zze.set(zzfVar);
        this.zza.set(zzba.AUTHENTICATED);
        taskCompletionSource.trySetResult(true);
        Iterator it = this.zzc.iterator();
        while (it.hasNext()) {
            ((zzbc) it.next()).zza(zzfVar);
            it.remove();
        }
    }

    final void zzl(TaskCompletionSource taskCompletionSource, int i, Task task) {
        if (!task.isSuccessful()) {
            Exception exception = task.getException();
            zzfw.zza(exception);
            zzfn.zzf("GamesApiManager", "Resolution failed", exception);
            zzo(taskCompletionSource, i, null, false, true);
            return;
        }
        com.google.android.gms.games.internal.p000v2.resolution.zzc zzcVar = (com.google.android.gms.games.internal.p000v2.resolution.zzc) task.getResult();
        if (zzcVar.zzc()) {
            zzfn.zza("GamesApiManager", "Resolution successful");
            zzn(taskCompletionSource, zzq.zzb(i, zzx.zza(zzcVar.zzd())));
        } else {
            zzfn.zza("GamesApiManager", "Resolution attempt was canceled");
            zzo(taskCompletionSource, i, null, false, true);
        }
    }
}
