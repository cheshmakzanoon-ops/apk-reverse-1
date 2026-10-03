package com.unity3d.player;

import android.app.Activity;
import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.RuntimeExecutionException;
import com.google.android.gms.tasks.Task;
import com.google.android.play.core.assetpacks.AssetPackLocation;
import com.google.android.play.core.assetpacks.AssetPackManager;
import com.google.android.play.core.assetpacks.AssetPackManagerFactory;
import com.google.android.play.core.assetpacks.AssetPackState;
import com.google.android.play.core.assetpacks.AssetPackStateUpdateListener;
import com.google.android.play.core.assetpacks.AssetPackStates;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

final class C1126a implements InterfaceC1130e {

    private static C1126a f365a;

    private AssetPackManager f366b;

    private HashSet f367c;

    private Object f368d;

    private static class a implements Runnable {

        private Set f369a;

        private String f370b;

        private int f371c;

        private long f372d;

        private long f373e;

        private int f374f;

        private int f375g;

        a(Set set, String str, int i, long j, long j2, int i2, int i3) {
            this.f369a = set;
            this.f370b = str;
            this.f371c = i;
            this.f372d = j;
            this.f373e = j2;
            this.f374f = i2;
            this.f375g = i3;
        }

        @Override
        public final void run() {
            Iterator it = this.f369a.iterator();
            while (it.hasNext()) {
                ((IAssetPackManagerDownloadStatusCallback) it.next()).onStatusUpdate(this.f370b, this.f371c, this.f372d, this.f373e, this.f374f, this.f375g);
            }
        }
    }

    private class b implements AssetPackStateUpdateListener {

        private HashSet f377b;

        private Looper f378c;

        public b(C1126a c1126a, IAssetPackManagerDownloadStatusCallback iAssetPackManagerDownloadStatusCallback) {
            this(iAssetPackManagerDownloadStatusCallback, Looper.myLooper());
        }

        public b(IAssetPackManagerDownloadStatusCallback iAssetPackManagerDownloadStatusCallback, Looper looper) {
            HashSet hashSet = new HashSet();
            this.f377b = hashSet;
            hashSet.add(iAssetPackManagerDownloadStatusCallback);
            this.f378c = looper;
        }

        private static Set m521a(HashSet hashSet) {
            return (Set) hashSet.clone();
        }

        public synchronized void onStateUpdate(AssetPackState assetPackState) {
            if (assetPackState.status() == 4 || assetPackState.status() == 5 || assetPackState.status() == 0) {
                synchronized (C1126a.f365a) {
                    C1126a.this.f367c.remove(assetPackState.name());
                    if (C1126a.this.f367c.isEmpty()) {
                        C1126a c1126a = C1126a.this;
                        c1126a.mo516a(c1126a.f368d);
                        C1126a.m512c(C1126a.this);
                    }
                }
            }
            if (this.f377b.size() == 0) {
                return;
            }
            new Handler(this.f378c).post(new a(m521a(this.f377b), assetPackState.name(), assetPackState.status(), assetPackState.totalBytesToDownload(), assetPackState.bytesDownloaded(), assetPackState.transferProgressPercentage(), assetPackState.errorCode()));
        }

        public final synchronized void m523a(IAssetPackManagerDownloadStatusCallback iAssetPackManagerDownloadStatusCallback) {
            this.f377b.add(iAssetPackManagerDownloadStatusCallback);
        }
    }

    private static class c implements OnSuccessListener {

        private IAssetPackManagerMobileDataConfirmationCallback f379a;

        private Looper f380b = Looper.myLooper();

        private static class a implements Runnable {

            private IAssetPackManagerMobileDataConfirmationCallback f381a;

            private boolean f382b;

            a(IAssetPackManagerMobileDataConfirmationCallback iAssetPackManagerMobileDataConfirmationCallback, boolean z) {
                this.f381a = iAssetPackManagerMobileDataConfirmationCallback;
                this.f382b = z;
            }

            @Override
            public final void run() {
                this.f381a.onMobileDataConfirmationResult(this.f382b);
            }
        }

        public c(IAssetPackManagerMobileDataConfirmationCallback iAssetPackManagerMobileDataConfirmationCallback) {
            this.f379a = iAssetPackManagerMobileDataConfirmationCallback;
        }

        @Override
        public void onSuccess(Integer num) {
            if (this.f379a != null) {
                new Handler(this.f380b).post(new a(this.f379a, num.intValue() == -1));
            }
        }
    }

    private static class d implements OnCompleteListener {

        private IAssetPackManagerDownloadStatusCallback f383a;

        private Looper f384b = Looper.myLooper();

        private String f385c;

        public d(IAssetPackManagerDownloadStatusCallback iAssetPackManagerDownloadStatusCallback, String str) {
            this.f383a = iAssetPackManagerDownloadStatusCallback;
            this.f385c = str;
        }

        private void m525a(String str, int i, int i2, long j) {
            new Handler(this.f384b).post(new a(Collections.singleton(this.f383a), str, i, j, i == 4 ? j : 0L, 0, i2));
        }

        @Override
        public final void onComplete(Task task) {
            try {
                AssetPackStates assetPackStates = (AssetPackStates) task.getResult();
                Map mapPackStates = assetPackStates.packStates();
                if (mapPackStates.size() == 0) {
                    return;
                }
                for (AssetPackState assetPackState : mapPackStates.values()) {
                    if (assetPackState.errorCode() != 0 || assetPackState.status() == 4 || assetPackState.status() == 5 || assetPackState.status() == 0) {
                        m525a(assetPackState.name(), assetPackState.status(), assetPackState.errorCode(), assetPackStates.totalBytes());
                    } else {
                        C1126a.f365a.m510a(assetPackState.name(), this.f383a, this.f384b);
                    }
                }
            } catch (RuntimeExecutionException e) {
                m525a(this.f385c, 0, e.getErrorCode(), 0L);
            }
        }
    }

    private static class e implements OnCompleteListener {

        private IAssetPackManagerStatusQueryCallback f386a;

        private Looper f387b = Looper.myLooper();

        private String[] f388c;

        private static class a implements Runnable {

            private IAssetPackManagerStatusQueryCallback f389a;

            private long f390b;

            private String[] f391c;

            private int[] f392d;

            private int[] f393e;

            a(IAssetPackManagerStatusQueryCallback iAssetPackManagerStatusQueryCallback, long j, String[] strArr, int[] iArr, int[] iArr2) {
                this.f389a = iAssetPackManagerStatusQueryCallback;
                this.f390b = j;
                this.f391c = strArr;
                this.f392d = iArr;
                this.f393e = iArr2;
            }

            @Override
            public final void run() {
                this.f389a.onStatusResult(this.f390b, this.f391c, this.f392d, this.f393e);
            }
        }

        public e(IAssetPackManagerStatusQueryCallback iAssetPackManagerStatusQueryCallback, String[] strArr) {
            this.f386a = iAssetPackManagerStatusQueryCallback;
            this.f388c = strArr;
        }

        @Override
        public final void onComplete(Task task) {
            if (this.f386a == null) {
                return;
            }
            int i = 0;
            try {
                AssetPackStates assetPackStates = (AssetPackStates) task.getResult();
                Map mapPackStates = assetPackStates.packStates();
                int size = mapPackStates.size();
                String[] strArr = new String[size];
                int[] iArr = new int[size];
                int[] iArr2 = new int[size];
                for (AssetPackState assetPackState : mapPackStates.values()) {
                    strArr[i] = assetPackState.name();
                    iArr[i] = assetPackState.status();
                    iArr2[i] = assetPackState.errorCode();
                    i++;
                }
                new Handler(this.f387b).post(new a(this.f386a, assetPackStates.totalBytes(), strArr, iArr, iArr2));
            } catch (RuntimeExecutionException e) {
                String message = e.getMessage();
                for (String str : this.f388c) {
                    if (message.contains(str)) {
                        new Handler(this.f387b).post(new a(this.f386a, 0L, new String[]{str}, new int[]{0}, new int[]{0}));
                        return;
                    }
                }
                String[] strArr2 = this.f388c;
                int[] iArr3 = new int[strArr2.length];
                int[] iArr4 = new int[strArr2.length];
                for (int i2 = 0; i2 < this.f388c.length; i2++) {
                    iArr3[i2] = 0;
                    iArr4[i2] = 0;
                }
                new Handler(this.f387b).post(new a(this.f386a, 0L, this.f388c, iArr3, iArr4));
            }
        }
    }

    private C1126a(Context context) {
        if (f365a != null) {
            throw new RuntimeException("AssetPackManagerWrapper should be created only once. Use getInstance() instead.");
        }
        this.f366b = AssetPackManagerFactory.getInstance(context);
        this.f367c = new HashSet();
    }

    public static InterfaceC1130e m507a(Context context) {
        if (f365a == null) {
            f365a = new C1126a(context);
        }
        return f365a;
    }

    public void m510a(String str, IAssetPackManagerDownloadStatusCallback iAssetPackManagerDownloadStatusCallback, Looper looper) {
        synchronized (f365a) {
            Object obj = this.f368d;
            if (obj == null) {
                b bVar = new b(iAssetPackManagerDownloadStatusCallback, looper);
                this.f366b.registerListener(bVar);
                this.f368d = bVar;
            } else {
                ((b) obj).m523a(iAssetPackManagerDownloadStatusCallback);
            }
            this.f367c.add(str);
            this.f366b.fetch(Collections.singletonList(str));
        }
    }

    static Object m512c(C1126a c1126a) {
        c1126a.f368d = null;
        return null;
    }

    @Override
    public final Object mo513a(IAssetPackManagerDownloadStatusCallback iAssetPackManagerDownloadStatusCallback) {
        b bVar = new b(this, iAssetPackManagerDownloadStatusCallback);
        this.f366b.registerListener(bVar);
        return bVar;
    }

    @Override
    public final String mo514a(String str) {
        AssetPackLocation packLocation = this.f366b.getPackLocation(str);
        return packLocation == null ? "" : packLocation.assetsPath();
    }

    @Override
    public final void mo515a(Activity activity, IAssetPackManagerMobileDataConfirmationCallback iAssetPackManagerMobileDataConfirmationCallback) {
        this.f366b.showCellularDataConfirmation(activity).addOnSuccessListener(new c(iAssetPackManagerMobileDataConfirmationCallback));
    }

    @Override
    public final void mo516a(Object obj) {
        if (obj instanceof b) {
            this.f366b.unregisterListener((b) obj);
        }
    }

    @Override
    public final void mo517a(String[] strArr) {
        this.f366b.cancel(Arrays.asList(strArr));
    }

    @Override
    public final void mo518a(String[] strArr, IAssetPackManagerDownloadStatusCallback iAssetPackManagerDownloadStatusCallback) {
        for (String str : strArr) {
            this.f366b.getPackStates(Collections.singletonList(str)).addOnCompleteListener(new d(iAssetPackManagerDownloadStatusCallback, str));
        }
    }

    @Override
    public final void mo519a(String[] strArr, IAssetPackManagerStatusQueryCallback iAssetPackManagerStatusQueryCallback) {
        this.f366b.getPackStates(Arrays.asList(strArr)).addOnCompleteListener(new e(iAssetPackManagerStatusQueryCallback, strArr));
    }

    @Override
    public final void mo520b(String str) {
        this.f366b.removePack(str);
    }
}
