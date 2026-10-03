package zendesk.p026ui.android.conversation.bottomsheet;

import android.content.Context;
import android.content.DialogInterface;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
import com.google.android.material.bottomsheet.BottomSheetDialog;
import kotlin.Metadata;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.BuildersKt__Builders_commonKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.CoroutineScopeKt;
import kotlinx.coroutines.Dispatchers;
import zendesk.core.p017ui.android.internal.xml.AccessibilityExtKt;
import zendesk.p026ui.android.internal.ColorExtKt;
import zendesk.ui.android.R;
import zendesk.ui.android.Renderer;

@Metadata(m17d1 = {"\u0000>\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0007\u0018\u00002\u00020\u00012\b\u0012\u0004\u0012\u00020\u00030\u0002B\r\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\b\u0010\u000f\u001a\u00020\u0010H\u0002J\b\u0010\u0011\u001a\u00020\u0010H\u0016J\b\u0010\u0012\u001a\u00020\u0010H\u0016J\u001c\u0010\u0013\u001a\u00020\u00102\u0012\u0010\u0014\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00030\u0015H\u0016J\b\u0010\u0016\u001a\u00020\u0010H\u0002R\u0010\u0010\u0007\u001a\u0004\u0018\u00010\bX\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\t\u001a\u0004\u0018\u00010\nX\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\u000b\u001a\u0004\u0018\u00010\fX\u0082\u000e¢\u0006\u0002\n\u0000R\u0010\u0010\r\u001a\u0004\u0018\u00010\bX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000e\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0017"}, m18d2 = {"Lzendesk/ui/android/conversation/bottomsheet/BottomSheetView;", "Lcom/google/android/material/bottomsheet/BottomSheetDialog;", "Lzendesk/ui/android/Renderer;", "Lzendesk/ui/android/conversation/bottomsheet/BottomSheetRendering;", "context", "Landroid/content/Context;", "(Landroid/content/Context;)V", "actionText", "Landroid/widget/TextView;", "container", "Landroid/widget/LinearLayout;", "coroutineScope", "Lkotlinx/coroutines/CoroutineScope;", "messageText", "rendering", "clearCoroutines", "", "dismiss", "onDetachedFromWindow", "render", "renderingUpdate", "Lkotlin/Function1;", "showBottomSheet", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class BottomSheetView extends BottomSheetDialog implements Renderer<BottomSheetRendering> {
    public static final int $stable = 8;
    private final TextView actionText;
    private final LinearLayout container;
    private CoroutineScope coroutineScope;
    private final TextView messageText;
    private BottomSheetRendering rendering;

    public BottomSheetView(Context context) {
        super(context);
        Intrinsics.checkNotNullParameter(context, "context");
        this.rendering = new BottomSheetRendering();
        context.getTheme().applyStyle(R.style.ThemeOverlay_ZendeskComponents_BottomSheetStyle, false);
        setContentView(R.layout.zuia_bottom_sheet_view);
        this.container = (LinearLayout) findViewById(R.id.zuia_bottom_sheet_container);
        this.messageText = (TextView) findViewById(R.id.zuia_bottom_sheet_message_text);
        this.actionText = (TextView) findViewById(R.id.zuia_bottom_sheet_actions_text);
        render(new Function1<BottomSheetRendering, BottomSheetRendering>() {
            @Override
            public final BottomSheetRendering invoke(BottomSheetRendering it) {
                Intrinsics.checkNotNullParameter(it, "it");
                return it;
            }
        });
        setCancelable(true);
    }

    public void render(Function1<? super BottomSheetRendering, BottomSheetRendering> renderingUpdate) {
        int iResolveColorAttr;
        int iResolveColorAttr2;
        int iResolveColorAttr3;
        Intrinsics.checkNotNullParameter(renderingUpdate, "renderingUpdate");
        BottomSheetRendering bottomSheetRenderingInvoke = renderingUpdate.invoke(this.rendering);
        this.rendering = bottomSheetRenderingInvoke;
        BottomSheetState state = bottomSheetRenderingInvoke.getState();
        Integer backgroundColor = state.getBackgroundColor();
        if (backgroundColor != null) {
            iResolveColorAttr = backgroundColor.intValue();
        } else {
            Context context = getContext();
            Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
            iResolveColorAttr = ColorExtKt.resolveColorAttr(context, R.attr.bottomSheetBackgroundColor);
        }
        Integer messageTextColor = state.getMessageTextColor();
        if (messageTextColor != null) {
            iResolveColorAttr2 = messageTextColor.intValue();
        } else {
            Context context2 = getContext();
            Intrinsics.checkNotNullExpressionValue(context2, "getContext(...)");
            iResolveColorAttr2 = ColorExtKt.resolveColorAttr(context2, R.attr.bottomSheetMessageTextColor);
        }
        Integer actionTextColor = state.getActionTextColor();
        if (actionTextColor != null) {
            iResolveColorAttr3 = actionTextColor.intValue();
        } else {
            Context context3 = getContext();
            Intrinsics.checkNotNullExpressionValue(context3, "getContext(...)");
            iResolveColorAttr3 = ColorExtKt.resolveColorAttr(context3, R.attr.bottomSheetActionTextColor);
        }
        LinearLayout linearLayout = this.container;
        if (linearLayout != null) {
            linearLayout.setBackgroundColor(iResolveColorAttr);
        }
        TextView textView = this.messageText;
        if (textView != null) {
            textView.setText(state.getMessageText$zendesk_ui_ui_android());
        }
        TextView textView2 = this.messageText;
        if (textView2 != null) {
            textView2.setTextColor(iResolveColorAttr2);
        }
        TextView textView3 = this.actionText;
        if (textView3 != null) {
            textView3.setText(state.getActionText$zendesk_ui_ui_android());
        }
        TextView textView4 = this.actionText;
        if (textView4 != null) {
            textView4.setTextColor(iResolveColorAttr3);
        }
        TextView textView5 = this.actionText;
        if (textView5 != null) {
            String name = Button.class.getName();
            Intrinsics.checkNotNullExpressionValue(name, "getName(...)");
            AccessibilityExtKt.overrideAccessibilityNodeClassNameInfo(textView5, name);
        }
        TextView textView6 = this.actionText;
        if (textView6 != null) {
            textView6.setOnClickListener(new View.OnClickListener() {
                @Override
                public final void onClick(View view) {
                    BottomSheetView.render$lambda$2$lambda$0(this.f$0, view);
                }
            });
        }
        setOnCancelListener(new DialogInterface.OnCancelListener() {
            @Override
            public final void onCancel(DialogInterface dialogInterface) {
                BottomSheetView.render$lambda$2$lambda$1(this.f$0, dialogInterface);
            }
        });
        if (state.getShowBottomSheet$zendesk_ui_ui_android()) {
            showBottomSheet();
        }
    }

    public static final void render$lambda$2$lambda$0(BottomSheetView this$0, View view) {
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        this$0.rendering.getOnBottomSheetActionClicked$zendesk_ui_ui_android().invoke();
        this$0.dismiss();
    }

    public static final void render$lambda$2$lambda$1(BottomSheetView this$0, DialogInterface dialogInterface) {
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        this$0.rendering.getOnBottomSheetDismissed$zendesk_ui_ui_android().invoke();
    }

    private final void showBottomSheet() {
        if (isShowing()) {
            return;
        }
        show();
        CoroutineScope CoroutineScope = CoroutineScopeKt.CoroutineScope(Dispatchers.getDefault());
        BuildersKt__Builders_commonKt.launch$default(CoroutineScope, null, null, new BottomSheetView$showBottomSheet$1$1(this, null), 3, null);
        this.coroutineScope = CoroutineScope;
    }

    private final void clearCoroutines() {
        CoroutineScope coroutineScope = this.coroutineScope;
        if (coroutineScope != null) {
            CoroutineScopeKt.cancel$default(coroutineScope, null, 1, null);
        }
        this.coroutineScope = null;
    }

    public void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        clearCoroutines();
    }

    public void dismiss() {
        super.dismiss();
        clearCoroutines();
    }
}
