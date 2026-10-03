package androidx.privacysandbox.ads.adservices.topics;

import android.content.Context;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.tracing.Trace$$ExternalSyntheticApiModelOutline0;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000 \n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0007\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\u0015\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\bH\u0010¢\u0006\u0002\b\t¨\u0006\n"}, d2 = {"Landroidx/privacysandbox/ads/adservices/topics/TopicsManagerApi33Ext5Impl;", "Landroidx/privacysandbox/ads/adservices/topics/TopicsManagerImplCommon;", "context", "Landroid/content/Context;", "(Landroid/content/Context;)V", "convertRequest", "Landroid/adservices/topics/GetTopicsRequest;", "request", "Landroidx/privacysandbox/ads/adservices/topics/GetTopicsRequest;", "convertRequest$ads_adservices_release", "ads-adservices_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class TopicsManagerApi33Ext5Impl extends TopicsManagerImplCommon {
    public TopicsManagerApi33Ext5Impl(Context context) {
        Intrinsics.checkNotNullParameter(context, "context");
        Object systemService = context.getSystemService((Class<Object>) Trace$$ExternalSyntheticApiModelOutline0.m$3());
        Intrinsics.checkNotNullExpressionValue(systemService, "context.getSystemService…opicsManager::class.java)");
        super(Trace$$ExternalSyntheticApiModelOutline0.m397m(systemService));
    }

    @Override
    public android.adservices.topics.GetTopicsRequest convertRequest$ads_adservices_release(GetTopicsRequest request) {
        Intrinsics.checkNotNullParameter(request, "request");
        android.adservices.topics.GetTopicsRequest getTopicsRequestBuild = Trace$$ExternalSyntheticApiModelOutline0.m391m().setAdsSdkName(request.getAdsSdkName()).setShouldRecordObservation(request.getShouldRecordObservation()).build();
        Intrinsics.checkNotNullExpressionValue(getTopicsRequestBuild, "Builder()\n            .s…ion)\n            .build()");
        return getTopicsRequestBuild;
    }
}
