package zendesk.core.p017ui.android.internal.xml;

import android.app.Dialog;
import android.content.DialogInterface;
import android.content.res.Resources;
import android.graphics.Outline;
import android.graphics.Rect;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewOutlineProvider;
import android.view.ViewTreeObserver;
import com.google.android.material.R;
import com.google.android.material.bottomsheet.BottomSheetDialog;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.Ref;
import zendesk.core.p017ui.android.internal.InternalZendeskUIApi;

@Metadata(m17d1 = {"\u0000\"\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0006\n\u0002\b\u0002\u001a*\u0010\u0002\u001a\u00020\u0003*\u00020\u00042\b\b\u0003\u0010\u0005\u001a\u00020\u00012\b\b\u0002\u0010\u0006\u001a\u00020\u00072\b\b\u0002\u0010\b\u001a\u00020\tH\u0007\u001a \u0010\n\u001a\u00020\u0003*\u00020\u00042\b\b\u0003\u0010\u0005\u001a\u00020\u00012\b\b\u0002\u0010\u0006\u001a\u00020\u0007H\u0007\"\u000e\u0010\u0000\u001a\u00020\u0001X\u0082T¢\u0006\u0002\n\u0000¨\u0006\u000b"}, m18d2 = {"MAX_WIDTH_FOR_BOTTOM_SHEET", "", "setConversationExtensionFullScreen", "", "Landroid/app/Dialog;", "cornerRadius", "skipCollapsed", "", "size", "", "setFullScreen", "zendesk.core.ui_core-ui"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class BottomSheetDialogKtxKt {
    private static final int MAX_WIDTH_FOR_BOTTOM_SHEET = 640;

    public static void setFullScreen$default(Dialog dialog, int i, boolean z, int i2, Object obj) {
        if ((i2 & 1) != 0) {
            i = 30;
        }
        if ((i2 & 2) != 0) {
            z = true;
        }
        setFullScreen(dialog, i, z);
    }

    @InternalZendeskUIApi
    public static final void setFullScreen(Dialog dialog, final int i, boolean z) {
        Intrinsics.checkNotNullParameter(dialog, "<this>");
        if (!(dialog instanceof BottomSheetDialog)) {
            throw new IllegalStateException("Dialog must be a BottomSheetDialog.".toString());
        }
        BottomSheetDialog bottomSheetDialog = (BottomSheetDialog) dialog;
        ViewGroup viewGroup = (ViewGroup) bottomSheetDialog.findViewById(R.id.design_bottom_sheet);
        if (viewGroup != null) {
            ViewGroup viewGroup2 = viewGroup;
            ViewGroup.LayoutParams layoutParams = viewGroup2.getLayoutParams();
            if (layoutParams != null) {
                layoutParams.height = -1;
                viewGroup2.setLayoutParams(layoutParams);
            } else {
                throw new NullPointerException("null cannot be cast to non-null type android.view.ViewGroup.LayoutParams");
            }
        }
        if (viewGroup != null) {
            viewGroup.setClipToOutline(true);
        }
        if (viewGroup != null) {
            viewGroup.setOutlineProvider(new ViewOutlineProvider() {
                @Override
                public void getOutline(View view, Outline outline) {
                    Intrinsics.checkNotNullParameter(view, "view");
                    Intrinsics.checkNotNullParameter(outline, "outline");
                    int width = view.getWidth();
                    int height = view.getHeight();
                    int i2 = i;
                    outline.setRoundRect(0, 0, width, height + i2, i2);
                }
            });
        }
        bottomSheetDialog.getBehavior().setState(3);
        bottomSheetDialog.getBehavior().setDraggable(false);
        bottomSheetDialog.getBehavior().setSkipCollapsed(z);
    }

    public static void setConversationExtensionFullScreen$default(Dialog dialog, int i, boolean z, double d, int i2, Object obj) {
        if ((i2 & 1) != 0) {
            i = 30;
        }
        if ((i2 & 2) != 0) {
            z = true;
        }
        if ((i2 & 4) != 0) {
            d = 1.0d;
        }
        setConversationExtensionFullScreen(dialog, i, z, d);
    }

    @InternalZendeskUIApi
    public static final void setConversationExtensionFullScreen(Dialog dialog, final int i, boolean z, final double d) {
        ViewTreeObserver viewTreeObserver;
        Intrinsics.checkNotNullParameter(dialog, "<this>");
        if (!(dialog instanceof BottomSheetDialog)) {
            throw new IllegalStateException("Dialog must be a BottomSheetDialog.".toString());
        }
        final int i2 = (int) (MAX_WIDTH_FOR_BOTTOM_SHEET * Resources.getSystem().getDisplayMetrics().density);
        BottomSheetDialog bottomSheetDialog = (BottomSheetDialog) dialog;
        final ViewGroup viewGroup = (ViewGroup) bottomSheetDialog.findViewById(R.id.design_bottom_sheet);
        final Ref.IntRef intRef = new Ref.IntRef();
        final ViewTreeObserver.OnGlobalLayoutListener onGlobalLayoutListener = new ViewTreeObserver.OnGlobalLayoutListener() {
            @Override
            public final void onGlobalLayout() {
                BottomSheetDialogKtxKt.setConversationExtensionFullScreen$lambda$7$lambda$5(viewGroup, intRef, d, i2);
            }
        };
        if (viewGroup != null && (viewTreeObserver = viewGroup.getViewTreeObserver()) != null) {
            viewTreeObserver.addOnGlobalLayoutListener(onGlobalLayoutListener);
        }
        if (viewGroup != null) {
            viewGroup.setClipToOutline(true);
        }
        if (viewGroup != null) {
            viewGroup.setOutlineProvider(new ViewOutlineProvider() {
                @Override
                public void getOutline(View view, Outline outline) {
                    Intrinsics.checkNotNullParameter(view, "view");
                    Intrinsics.checkNotNullParameter(outline, "outline");
                    int width = view.getWidth();
                    int height = view.getHeight();
                    int i3 = i;
                    outline.setRoundRect(0, 0, width, height + i3, i3);
                }
            });
        }
        bottomSheetDialog.getBehavior().setState(3);
        bottomSheetDialog.getBehavior().setDraggable(false);
        bottomSheetDialog.getBehavior().setSkipCollapsed(z);
        dialog.setOnDismissListener(new DialogInterface.OnDismissListener() {
            @Override
            public final void onDismiss(DialogInterface dialogInterface) {
                BottomSheetDialogKtxKt.setConversationExtensionFullScreen$lambda$7$lambda$6(viewGroup, onGlobalLayoutListener, dialogInterface);
            }
        });
    }

    public static final void setConversationExtensionFullScreen$lambda$7$lambda$5(ViewGroup viewGroup, Ref.IntRef previousHeight, double d, int i) {
        View rootView;
        Intrinsics.checkNotNullParameter(previousHeight, "$previousHeight");
        Rect rect = new Rect();
        if (viewGroup != null && (rootView = viewGroup.getRootView()) != null) {
            rootView.getWindowVisibleDisplayFrame(rect);
        }
        int i2 = rect.bottom - rect.top;
        if (i2 != previousHeight.element) {
            previousHeight.element = i2;
            if (viewGroup != null) {
                ViewGroup viewGroup2 = viewGroup;
                ViewGroup.LayoutParams layoutParams = viewGroup2.getLayoutParams();
                if (layoutParams != null) {
                    layoutParams.height = (int) (((double) i2) * d);
                    if (layoutParams.width <= i) {
                        i = -1;
                    }
                    layoutParams.width = i;
                    viewGroup2.setLayoutParams(layoutParams);
                    return;
                }
                throw new NullPointerException("null cannot be cast to non-null type android.view.ViewGroup.LayoutParams");
            }
        }
    }

    public static final void setConversationExtensionFullScreen$lambda$7$lambda$6(ViewGroup viewGroup, ViewTreeObserver.OnGlobalLayoutListener globalLayoutListener, DialogInterface dialogInterface) {
        ViewTreeObserver viewTreeObserver;
        Intrinsics.checkNotNullParameter(globalLayoutListener, "$globalLayoutListener");
        if (viewGroup == null || (viewTreeObserver = viewGroup.getViewTreeObserver()) == null) {
            return;
        }
        viewTreeObserver.removeOnGlobalLayoutListener(globalLayoutListener);
    }
}
