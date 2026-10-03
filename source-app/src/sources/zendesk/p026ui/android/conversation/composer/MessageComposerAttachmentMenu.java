package zendesk.p026ui.android.conversation.composer;

import android.content.Context;
import android.view.View;
import android.view.accessibility.AccessibilityNodeInfo;
import android.widget.FrameLayout;
import android.widget.TextView;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;
import zendesk.ui.android.R;

@Metadata(m17d1 = {"\u00006\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0010\b\n\u0002\u0010\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0000\b\u0000\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\u000e\u0010\u000f\u001a\u00020\u000e2\u0006\u0010\u0005\u001a\u00020\u0006J\u000e\u0010\u0010\u001a\u00020\u000e2\u0006\u0010\t\u001a\u00020\u0006J\u001a\u0010\u0011\u001a\u00020\u000e2\u0012\u0010\u0012\u001a\u000e\u0012\u0004\u0012\u00020\r\u0012\u0004\u0012\u00020\u000e0\fJ\u0010\u0010\u0013\u001a\u00020\u000e2\u0006\u0010\u0014\u001a\u00020\u0015H\u0002R\u000e\u0010\u0005\u001a\u00020\u0006X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0007\u001a\u00020\bX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\t\u001a\u00020\u0006X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\n\u001a\u00020\bX\u0082\u0004¢\u0006\u0002\n\u0000R\u001c\u0010\u000b\u001a\u0010\u0012\u0004\u0012\u00020\r\u0012\u0004\u0012\u00020\u000e\u0018\u00010\fX\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0016"}, m18d2 = {"Lzendesk/ui/android/conversation/composer/MessageComposerAttachmentMenu;", "Landroid/widget/FrameLayout;", "context", "Landroid/content/Context;", "(Landroid/content/Context;)V", "cameraSupported", "", "cameraTextView", "Landroid/widget/TextView;", "gallerySupported", "galleryTextView", "itemClickListener", "Lkotlin/Function1;", "", "", "setCameraSupported", "setGallerySupported", "setOnItemClickListener", "listener", "updateAccessibilityNodeInfo", "view", "Landroid/view/View;", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class MessageComposerAttachmentMenu extends FrameLayout {
    public static final int $stable = 8;
    private boolean cameraSupported;
    private final TextView cameraTextView;
    private boolean gallerySupported;
    private final TextView galleryTextView;
    private Function1<? super Integer, Unit> itemClickListener;

    public MessageComposerAttachmentMenu(Context context) {
        super(context);
        Intrinsics.checkNotNullParameter(context, "context");
        this.gallerySupported = true;
        this.cameraSupported = true;
        FrameLayout.inflate(context, R.layout.zuia_view_attachment_menu, this);
        View viewFindViewById = findViewById(R.id.menu_item_camera);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById, "findViewById(...)");
        TextView textView = (TextView) viewFindViewById;
        this.cameraTextView = textView;
        View viewFindViewById2 = findViewById(R.id.menu_item_gallery);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById2, "findViewById(...)");
        TextView textView2 = (TextView) viewFindViewById2;
        this.galleryTextView = textView2;
        updateAccessibilityNodeInfo(textView);
        updateAccessibilityNodeInfo(textView2);
        textView.setOnClickListener(new View.OnClickListener() {
            @Override
            public final void onClick(View view) {
                MessageComposerAttachmentMenu._init_$lambda$0(this.f$0, view);
            }
        });
        textView2.setOnClickListener(new View.OnClickListener() {
            @Override
            public final void onClick(View view) {
                MessageComposerAttachmentMenu._init_$lambda$1(this.f$0, view);
            }
        });
    }

    public static final void _init_$lambda$0(MessageComposerAttachmentMenu this$0, View view) {
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        Function1<? super Integer, Unit> function1 = this$0.itemClickListener;
        if (function1 != null) {
            function1.invoke(Integer.valueOf(R.id.menu_item_camera));
        }
    }

    public static final void _init_$lambda$1(MessageComposerAttachmentMenu this$0, View view) {
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        Function1<? super Integer, Unit> function1 = this$0.itemClickListener;
        if (function1 != null) {
            function1.invoke(Integer.valueOf(R.id.menu_item_gallery));
        }
    }

    private final void updateAccessibilityNodeInfo(View view) {
        view.setAccessibilityDelegate(new View.AccessibilityDelegate() {
            @Override
            public void onInitializeAccessibilityNodeInfo(View host, AccessibilityNodeInfo info) {
                Intrinsics.checkNotNullParameter(host, "host");
                Intrinsics.checkNotNullParameter(info, "info");
                super.onInitializeAccessibilityNodeInfo(host, info);
                info.setClassName("android.widget.Button");
            }
        });
    }

    public final void setOnItemClickListener(Function1<? super Integer, Unit> listener) {
        Intrinsics.checkNotNullParameter(listener, "listener");
        this.itemClickListener = listener;
    }

    public final void setGallerySupported(boolean gallerySupported) {
        this.gallerySupported = gallerySupported;
        this.galleryTextView.setVisibility(gallerySupported ? 0 : 8);
    }

    public final void setCameraSupported(boolean cameraSupported) {
        this.cameraSupported = cameraSupported;
        this.cameraTextView.setVisibility(cameraSupported ? 0 : 8);
    }
}
