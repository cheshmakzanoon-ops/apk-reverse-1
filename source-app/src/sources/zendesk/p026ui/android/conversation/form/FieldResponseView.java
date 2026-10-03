package zendesk.p026ui.android.conversation.form;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;
import kotlin.Metadata;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.ui.android.R;
import zendesk.ui.android.Renderer;

@Metadata(m17d1 = {"\u00004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\b\u0007\u0018\u00002\u00020\u00012\b\u0012\u0004\u0012\u00020\u00030\u0002B\u001b\b\u0007\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007¢\u0006\u0002\u0010\bJ\u001c\u0010\r\u001a\u00020\u000e2\u0012\u0010\u000f\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00030\u0010H\u0016R\u000e\u0010\t\u001a\u00020\nX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000b\u001a\u00020\nX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\f\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0011"}, m18d2 = {"Lzendesk/ui/android/conversation/form/FieldResponseView;", "Landroid/widget/LinearLayout;", "Lzendesk/ui/android/Renderer;", "Lzendesk/ui/android/conversation/form/FieldResponseRendering;", "context", "Landroid/content/Context;", "attrs", "Landroid/util/AttributeSet;", "(Landroid/content/Context;Landroid/util/AttributeSet;)V", "itemHeader", "Landroid/widget/TextView;", "itemText", "rendering", "render", "", "renderingUpdate", "Lkotlin/Function1;", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class FieldResponseView extends LinearLayout implements Renderer<FieldResponseRendering> {
    public static final int $stable = 8;
    private final TextView itemHeader;
    private final TextView itemText;
    private FieldResponseRendering rendering;

    public FieldResponseView(Context context) {
        this(context, null, 2, 0 == true ? 1 : 0);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public FieldResponseView(Context context, AttributeSet attributeSet, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(context, (i & 2) != 0 ? null : attributeSet);
    }

    public FieldResponseView(Context context, AttributeSet attributeSet) {
        super(context, attributeSet, 0, 0);
        Intrinsics.checkNotNullParameter(context, "context");
        this.rendering = new FieldResponseRendering();
        LinearLayout.inflate(context, R.layout.zuia_view_field_response, this);
        setOrientation(1);
        View viewFindViewById = findViewById(R.id.zuia_form_response_title);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById, "findViewById(...)");
        this.itemHeader = (TextView) viewFindViewById;
        View viewFindViewById2 = findViewById(R.id.zuia_form_response_subtitle);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById2, "findViewById(...)");
        this.itemText = (TextView) viewFindViewById2;
        render(new Function1<FieldResponseRendering, FieldResponseRendering>() {
            @Override
            public final FieldResponseRendering invoke(FieldResponseRendering it) {
                Intrinsics.checkNotNullParameter(it, "it");
                return it;
            }
        });
    }

    public void render(Function1<? super FieldResponseRendering, FieldResponseRendering> renderingUpdate) {
        Intrinsics.checkNotNullParameter(renderingUpdate, "renderingUpdate");
        FieldResponseRendering fieldResponseRenderingInvoke = renderingUpdate.invoke(this.rendering);
        this.itemHeader.setTextColor(fieldResponseRenderingInvoke.getState().getTextColor$zendesk_ui_ui_android());
        this.itemText.setTextColor(fieldResponseRenderingInvoke.getState().getTextColor$zendesk_ui_ui_android());
        this.itemHeader.setText(fieldResponseRenderingInvoke.getState().getTitle$zendesk_ui_ui_android());
        this.itemText.setText(fieldResponseRenderingInvoke.getState().getResponse$zendesk_ui_ui_android());
        this.rendering = fieldResponseRenderingInvoke;
    }
}
