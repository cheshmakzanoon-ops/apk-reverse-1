package androidx.privacysandbox.ads.adservices.appsetid;

import androidx.constraintlayout.widget.ConstraintLayout;
import kotlin.Metadata;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;

@Metadata(k = 3, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
@DebugMetadata(c = "androidx.privacysandbox.ads.adservices.appsetid.AppSetIdManager$Api33Ext4Impl", f = "AppSetIdManager.kt", i = {}, l = {ConstraintLayout.LayoutParams.Table.LAYOUT_GONE_MARGIN_BASELINE}, m = "getAppSetId", n = {}, s = {})
final class AppSetIdManager$Api33Ext4Impl$getAppSetId$1 extends ContinuationImpl {
    Object L$0;
    int label;
    Object result;
    final AppSetIdManager.Api33Ext4Impl this$0;

    AppSetIdManager$Api33Ext4Impl$getAppSetId$1(AppSetIdManager.Api33Ext4Impl api33Ext4Impl, Continuation<? super AppSetIdManager$Api33Ext4Impl$getAppSetId$1> continuation) {
        super(continuation);
        this.this$0 = api33Ext4Impl;
    }

    public final Object invokeSuspend(Object obj) {
        this.result = obj;
        this.label |= Integer.MIN_VALUE;
        return this.this$0.getAppSetId((Continuation) this);
    }
}
