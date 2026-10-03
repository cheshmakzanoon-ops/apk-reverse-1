package com.google.android.gms.cloudmessaging;

import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Looper;
import android.os.Message;
import android.os.Messenger;
import android.os.Parcelable;
import android.os.RemoteException;
import android.util.Log;
import androidx.collection.SimpleArrayMap;
import com.google.android.gms.tasks.Continuation;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.SuccessContinuation;
import com.google.android.gms.tasks.Task;
import com.google.android.gms.tasks.TaskCompletionSource;
import com.google.android.gms.tasks.Tasks;
import java.io.IOException;
import java.util.concurrent.Executor;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.ScheduledThreadPoolExecutor;
import java.util.concurrent.TimeUnit;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Rpc {
    private static int zza;
    private static PendingIntent zzb;
    private static final Executor zzc = new Executor() {
        @Override
        public final void execute(Runnable runnable) {
            runnable.run();
        }
    };
    private static final Pattern zzd = Pattern.compile("\\|ID\\|([^|]+)\\|:?+(.*)");
    private final Context zzf;
    private final zzt zzg;
    private final ScheduledExecutorService zzh;
    private Messenger zzj;
    private zzd zzk;
    private final SimpleArrayMap<String, TaskCompletionSource<Bundle>> zze = new SimpleArrayMap<>();
    private Messenger zzi = new Messenger(new zzaa(this, Looper.getMainLooper()));

    public Rpc(Context context) {
        this.zzf = context;
        this.zzg = new zzt(context);
        ScheduledThreadPoolExecutor scheduledThreadPoolExecutor = new ScheduledThreadPoolExecutor(1);
        scheduledThreadPoolExecutor.setKeepAliveTime(60L, TimeUnit.SECONDS);
        scheduledThreadPoolExecutor.allowCoreThreadTimeOut(true);
        this.zzh = scheduledThreadPoolExecutor;
    }

    static Task zza(Bundle bundle) throws Exception {
        return zzi(bundle) ? Tasks.forResult(null) : Tasks.forResult(bundle);
    }

    static void zzc(Rpc rpc, Message message) {
        if (message == null || !(message.obj instanceof Intent)) {
            Log.w("Rpc", "Dropping invalid message");
            return;
        }
        Intent intent = (Intent) message.obj;
        intent.setExtrasClassLoader(new zzc());
        if (intent.hasExtra("google.messenger")) {
            Parcelable parcelableExtra = intent.getParcelableExtra("google.messenger");
            if (parcelableExtra instanceof zzd) {
                rpc.zzk = (zzd) parcelableExtra;
            }
            if (parcelableExtra instanceof Messenger) {
                rpc.zzj = (Messenger) parcelableExtra;
            }
        }
        Intent intent2 = (Intent) message.obj;
        String action = intent2.getAction();
        if (!"com.google.android.c2dm.intent.REGISTRATION".equals(action)) {
            if (Log.isLoggable("Rpc", 3)) {
                String strValueOf = String.valueOf(action);
                Log.d("Rpc", strValueOf.length() != 0 ? "Unexpected response action: ".concat(strValueOf) : new String("Unexpected response action: "));
                return;
            }
            return;
        }
        String stringExtra = intent2.getStringExtra("registration_id");
        if (stringExtra == null) {
            stringExtra = intent2.getStringExtra("unregistered");
        }
        if (stringExtra != null) {
            Matcher matcher = zzd.matcher(stringExtra);
            if (!matcher.matches()) {
                if (Log.isLoggable("Rpc", 3)) {
                    Log.d("Rpc", stringExtra.length() != 0 ? "Unexpected response string: ".concat(stringExtra) : new String("Unexpected response string: "));
                    return;
                }
                return;
            }
            String strGroup = matcher.group(1);
            String strGroup2 = matcher.group(2);
            if (strGroup != null) {
                Bundle extras = intent2.getExtras();
                extras.putString("registration_id", strGroup2);
                rpc.zzh(strGroup, extras);
                return;
            }
            return;
        }
        String stringExtra2 = intent2.getStringExtra("error");
        if (stringExtra2 == null) {
            String strValueOf2 = String.valueOf(intent2.getExtras());
            StringBuilder sb = new StringBuilder(String.valueOf(strValueOf2).length() + 49);
            sb.append("Unexpected response, no error or registration id ");
            sb.append(strValueOf2);
            Log.w("Rpc", sb.toString());
            return;
        }
        if (Log.isLoggable("Rpc", 3)) {
            Log.d("Rpc", stringExtra2.length() != 0 ? "Received InstanceID error ".concat(stringExtra2) : new String("Received InstanceID error "));
        }
        if (!stringExtra2.startsWith("|")) {
            synchronized (rpc.zze) {
                for (int i = 0; i < rpc.zze.size(); i++) {
                    rpc.zzh((String) rpc.zze.keyAt(i), intent2.getExtras());
                }
            }
            return;
        }
        String[] strArrSplit = stringExtra2.split("\\|");
        if (strArrSplit.length <= 2 || !"ID".equals(strArrSplit[1])) {
            Log.w("Rpc", stringExtra2.length() != 0 ? "Unexpected structured response ".concat(stringExtra2) : new String("Unexpected structured response "));
            return;
        }
        String str = strArrSplit[2];
        String strSubstring = strArrSplit[3];
        if (strSubstring.startsWith(":")) {
            strSubstring = strSubstring.substring(1);
        }
        rpc.zzh(str, intent2.putExtra("error", strSubstring).getExtras());
    }

    private final Task<Bundle> zze(Bundle bundle) {
        final String strZzf = zzf();
        final TaskCompletionSource taskCompletionSource = new TaskCompletionSource();
        synchronized (this.zze) {
            this.zze.put(strZzf, taskCompletionSource);
        }
        Intent intent = new Intent();
        intent.setPackage("com.google.android.gms");
        if (this.zzg.zzb() == 2) {
            intent.setAction("com.google.iid.TOKEN_REQUEST");
        } else {
            intent.setAction("com.google.android.c2dm.intent.REGISTER");
        }
        intent.putExtras(bundle);
        zzg(this.zzf, intent);
        StringBuilder sb = new StringBuilder(String.valueOf(strZzf).length() + 5);
        sb.append("|ID|");
        sb.append(strZzf);
        sb.append("|");
        intent.putExtra("kid", sb.toString());
        if (Log.isLoggable("Rpc", 3)) {
            String strValueOf = String.valueOf(intent.getExtras());
            StringBuilder sb2 = new StringBuilder(String.valueOf(strValueOf).length() + 8);
            sb2.append("Sending ");
            sb2.append(strValueOf);
            Log.d("Rpc", sb2.toString());
        }
        intent.putExtra("google.messenger", this.zzi);
        if (this.zzj != null || this.zzk != null) {
            Message messageObtain = Message.obtain();
            messageObtain.obj = intent;
            try {
                Messenger messenger = this.zzj;
                if (messenger != null) {
                    messenger.send(messageObtain);
                } else {
                    this.zzk.zzb(messageObtain);
                }
            } catch (RemoteException unused) {
                if (Log.isLoggable("Rpc", 3)) {
                    Log.d("Rpc", "Messenger failed, fallback to startService");
                }
                if (this.zzg.zzb() == 2) {
                    this.zzf.sendBroadcast(intent);
                } else {
                    this.zzf.startService(intent);
                }
            }
        } else if (this.zzg.zzb() == 2) {
            this.zzf.sendBroadcast(intent);
        } else {
            this.zzf.startService(intent);
        }
        final ScheduledFuture<?> scheduledFutureSchedule = this.zzh.schedule(new Runnable() {
            @Override
            public final void run() {
                if (taskCompletionSource.trySetException(new IOException("TIMEOUT"))) {
                    Log.w("Rpc", "No response");
                }
            }
        }, 30L, TimeUnit.SECONDS);
        taskCompletionSource.getTask().addOnCompleteListener(zzc, new OnCompleteListener() {
            @Override
            public final void onComplete(Task task) {
                this.zza.zzd(strZzf, scheduledFutureSchedule, task);
            }
        });
        return taskCompletionSource.getTask();
    }

    private static synchronized String zzf() {
        int i;
        i = zza;
        zza = i + 1;
        return Integer.toString(i);
    }

    private static synchronized void zzg(Context context, Intent intent) {
        if (zzb == null) {
            Intent intent2 = new Intent();
            intent2.setPackage("com.google.example.invalidpackage");
            zzb = com.google.android.gms.internal.cloudmessaging.zza.zza(context, 0, intent2, com.google.android.gms.internal.cloudmessaging.zza.zza);
        }
        intent.putExtra("app", zzb);
    }

    private final void zzh(String str, Bundle bundle) {
        synchronized (this.zze) {
            TaskCompletionSource taskCompletionSource = (TaskCompletionSource) this.zze.remove(str);
            if (taskCompletionSource != null) {
                taskCompletionSource.setResult(bundle);
            } else {
                String strValueOf = String.valueOf(str);
                Log.w("Rpc", strValueOf.length() != 0 ? "Missing callback for ".concat(strValueOf) : new String("Missing callback for "));
            }
        }
    }

    private static boolean zzi(Bundle bundle) {
        return bundle != null && bundle.containsKey("google.messenger");
    }

    public Task<Bundle> send(final Bundle bundle) {
        if (this.zzg.zza() < 12000000) {
            return this.zzg.zzb() != 0 ? zze(bundle).continueWithTask(zzc, new Continuation() {
                @Override
                public final Object then(Task task) {
                    return this.zza.zzb(bundle, task);
                }
            }) : Tasks.forException(new IOException("MISSING_INSTANCEID_SERVICE"));
        }
        return zzs.zzb(this.zzf).zzd(1, bundle).continueWith(zzc, new Continuation() {
            @Override
            public final Object then(Task task) throws IOException {
                if (task.isSuccessful()) {
                    return (Bundle) task.getResult();
                }
                if (Log.isLoggable("Rpc", 3)) {
                    String strValueOf = String.valueOf(task.getException());
                    StringBuilder sb = new StringBuilder(String.valueOf(strValueOf).length() + 22);
                    sb.append("Error making request: ");
                    sb.append(strValueOf);
                    Log.d("Rpc", sb.toString());
                }
                throw new IOException("SERVICE_NOT_AVAILABLE", task.getException());
            }
        });
    }

    public final Task zzb(Bundle bundle, Task task) throws Exception {
        return (task.isSuccessful() && zzi((Bundle) task.getResult())) ? zze(bundle).onSuccessTask(zzc, new SuccessContinuation() {
            @Override
            public final Task then(Object obj) {
                return Rpc.zza((Bundle) obj);
            }
        }) : task;
    }

    public final void zzd(String str, ScheduledFuture scheduledFuture, Task task) {
        synchronized (this.zze) {
            this.zze.remove(str);
        }
        scheduledFuture.cancel(false);
    }
}
