package androidx.privacysandbox.ads.adservices.java.appsetid;

import android.content.Context;
import androidx.constraintlayout.core.motion.utils.TypedValues;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.privacysandbox.ads.adservices.appsetid.AppSetId;
import androidx.privacysandbox.ads.adservices.appsetid.AppSetIdManager;
import androidx.privacysandbox.ads.adservices.java.internal.CoroutineAdapterKt;
import com.google.common.util.concurrent.ListenableFuture;
import kotlin.Metadata;
import kotlin.coroutines.CoroutineContext;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineScopeKt;
import kotlinx.coroutines.CoroutineStart;
import kotlinx.coroutines.Dispatchers;

@Metadata(d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\b&\u0018\u0000 \u00072\u00020\u0001:\u0002\u0006\u0007B\u0007\b\u0000¢\u0006\u0002\u0010\u0002J\u000e\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004H&¨\u0006\b"}, d2 = {"Landroidx/privacysandbox/ads/adservices/java/appsetid/AppSetIdManagerFutures;", "", "()V", "getAppSetIdAsync", "Lcom/google/common/util/concurrent/ListenableFuture;", "Landroidx/privacysandbox/ads/adservices/appsetid/AppSetId;", "Api33Ext4JavaImpl", "Companion", "ads-adservices-java_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public abstract class AppSetIdManagerFutures {

    public static final Companion INSTANCE = new Companion(null);

    @JvmStatic
    public static final AppSetIdManagerFutures from(Context context) {
        return INSTANCE.from(context);
    }

    public abstract ListenableFuture<AppSetId> getAppSetIdAsync();

    @Metadata(d1 = {"\u0000\u001c\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0002\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\u000e\u0010\u0005\u001a\b\u0012\u0004\u0012\u00020\u00070\u0006H\u0017R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\b"}, d2 = {"Landroidx/privacysandbox/ads/adservices/java/appsetid/AppSetIdManagerFutures$Api33Ext4JavaImpl;", "Landroidx/privacysandbox/ads/adservices/java/appsetid/AppSetIdManagerFutures;", "mAppSetIdManager", "Landroidx/privacysandbox/ads/adservices/appsetid/AppSetIdManager;", "(Landroidx/privacysandbox/ads/adservices/appsetid/AppSetIdManager;)V", "getAppSetIdAsync", "Lcom/google/common/util/concurrent/ListenableFuture;", "Landroidx/privacysandbox/ads/adservices/appsetid/AppSetId;", "ads-adservices-java_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    static final class Api33Ext4JavaImpl extends AppSetIdManagerFutures {
        private final AppSetIdManager mAppSetIdManager;

        public Api33Ext4JavaImpl(AppSetIdManager appSetIdManager) {
            Intrinsics.checkNotNullParameter(appSetIdManager, "mAppSetIdManager");
            this.mAppSetIdManager = appSetIdManager;
        }

        @Override
        public ListenableFuture<AppSetId> getAppSetIdAsync() {
            return CoroutineAdapterKt.asListenableFuture$default(BuildersKt.async$default(CoroutineScopeKt.CoroutineScope(Dispatchers.getDefault()), (CoroutineContext) null, (CoroutineStart) null, new AppSetIdManagerFutures$Api33Ext4JavaImpl$getAppSetIdAsync$1(this, null), 3, (Object) null), null, 1, null);
        }
    }

    @Metadata(d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0012\u0010\u0003\u001a\u0004\u0018\u00010\u00042\u0006\u0010\u0005\u001a\u00020\u0006H\u0007¨\u0006\u0007"}, d2 = {"Landroidx/privacysandbox/ads/adservices/java/appsetid/AppSetIdManagerFutures$Companion;", "", "()V", TypedValues.TransitionType.S_FROM, "Landroidx/privacysandbox/ads/adservices/java/appsetid/AppSetIdManagerFutures;", "context", "Landroid/content/Context;", "ads-adservices-java_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        @JvmStatic
        public final AppSetIdManagerFutures from(Context context) {
            Intrinsics.checkNotNullParameter(context, "context");
            AppSetIdManager appSetIdManagerObtain = AppSetIdManager.INSTANCE.obtain(context);
            return appSetIdManagerObtain != null ? new Api33Ext4JavaImpl(appSetIdManagerObtain) : null;
        }
    }
}
