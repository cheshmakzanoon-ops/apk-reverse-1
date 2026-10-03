package zendesk.p026ui.android.conversation.file;

import android.content.Context;
import android.graphics.PorterDuff;
import android.os.Build;
import android.text.format.Formatter;
import android.util.AttributeSet;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.p026ui.android.internal.ThrottledOnClickListenerKt;
import zendesk.ui.android.R;
import zendesk.ui.android.Renderer;

@Metadata(m17d1 = {"\u0000J\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0002\u0010\t\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\b\u0007\u0018\u00002\u00020\u00012\b\u0012\u0004\u0012\u00020\u00030\u0002B/\b\u0007\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t\u0012\b\b\u0002\u0010\n\u001a\u00020\t¢\u0006\u0002\u0010\u000bJ\u0010\u0010\u0012\u001a\u00020\u00132\u0006\u0010\u0010\u001a\u00020\u0014H\u0002J\u001c\u0010\u0015\u001a\u00020\u00162\u0012\u0010\u0017\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00030\u0018H\u0016R\u000e\u0010\f\u001a\u00020\rX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000e\u001a\u00020\u000fX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0010\u001a\u00020\u000fX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0011\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0019"}, m18d2 = {"Lzendesk/ui/android/conversation/file/FileView;", "Landroid/widget/RelativeLayout;", "Lzendesk/ui/android/Renderer;", "Lzendesk/ui/android/conversation/file/FileRendering;", "context", "Landroid/content/Context;", "attrs", "Landroid/util/AttributeSet;", "defStyleAttrs", "", "defStyleRes", "(Landroid/content/Context;Landroid/util/AttributeSet;II)V", "fileIcon", "Landroid/widget/ImageView;", "fileName", "Landroid/widget/TextView;", "fileSize", "rendering", "getFormattedFileSize", "", "", "render", "", "renderingUpdate", "Lkotlin/Function1;", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class FileView extends RelativeLayout implements Renderer<FileRendering> {
    public static final int $stable = 8;
    private final ImageView fileIcon;
    private final TextView fileName;
    private final TextView fileSize;
    private FileRendering rendering;

    public FileView(Context context) {
        this(context, null, 0, 0, 14, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public FileView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0, 0, 12, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public FileView(Context context, AttributeSet attributeSet, int i) {
        this(context, attributeSet, i, 0, 8, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public FileView(Context context, AttributeSet attributeSet, int i, int i2, int i3, DefaultConstructorMarker defaultConstructorMarker) {
        this(context, (i3 & 2) != 0 ? null : attributeSet, (i3 & 4) != 0 ? 0 : i, (i3 & 8) != 0 ? 0 : i2);
    }

    public FileView(Context context, AttributeSet attributeSet, int i, int i2) {
        super(context, attributeSet, i, i2);
        Intrinsics.checkNotNullParameter(context, "context");
        this.rendering = new FileRendering();
        context.getTheme().applyStyle(R.style.ThemeOverlay_ZendeskComponents_TextCellStyle, false);
        RelativeLayout.inflate(context, R.layout.zuia_view_file_cell, this);
        setLayoutParams(new RelativeLayout.LayoutParams(-1, -2));
        int dimensionPixelSize = context.getResources().getDimensionPixelSize(R.dimen.zuia_horizontal_message_padding);
        int dimensionPixelSize2 = context.getResources().getDimensionPixelSize(R.dimen.zuia_vertical_message_padding);
        setPaddingRelative(dimensionPixelSize, dimensionPixelSize2, dimensionPixelSize, dimensionPixelSize2);
        setClickable(true);
        setFocusable(true);
        View viewFindViewById = findViewById(R.id.zuia_file_icon);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById, "findViewById(...)");
        this.fileIcon = (ImageView) viewFindViewById;
        View viewFindViewById2 = findViewById(R.id.zuia_file_name);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById2, "findViewById(...)");
        this.fileName = (TextView) viewFindViewById2;
        View viewFindViewById3 = findViewById(R.id.zuia_file_size);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById3, "findViewById(...)");
        this.fileSize = (TextView) viewFindViewById3;
        render(new Function1<FileRendering, FileRendering>() {
            @Override
            public final FileRendering invoke(FileRendering it) {
                Intrinsics.checkNotNullParameter(it, "it");
                return it;
            }
        });
    }

    public void render(Function1<? super FileRendering, FileRendering> renderingUpdate) {
        Intrinsics.checkNotNullParameter(renderingUpdate, "renderingUpdate");
        FileState state = this.rendering.getState();
        FileRendering fileRenderingInvoke = renderingUpdate.invoke(this.rendering);
        this.rendering = fileRenderingInvoke;
        if (Intrinsics.areEqual(state, fileRenderingInvoke.getState())) {
            return;
        }
        this.fileName.setText(this.rendering.getState().getFileName$zendesk_ui_ui_android());
        this.fileSize.setText(getFormattedFileSize(this.rendering.getState().getFileSize$zendesk_ui_ui_android()));
        Integer backgroundDrawable$zendesk_ui_ui_android = this.rendering.getState().getBackgroundDrawable$zendesk_ui_ui_android();
        if (backgroundDrawable$zendesk_ui_ui_android != null) {
            setBackgroundResource(backgroundDrawable$zendesk_ui_ui_android.intValue());
        }
        if (getBackground() != null) {
            getBackground().setTint(this.rendering.getState().getBackgroundColor$zendesk_ui_ui_android());
        }
        int textColor$zendesk_ui_ui_android = this.rendering.getState().getTextColor$zendesk_ui_ui_android();
        this.fileName.setTextColor(textColor$zendesk_ui_ui_android);
        this.fileSize.setTextColor(textColor$zendesk_ui_ui_android);
        this.fileIcon.setColorFilter(this.rendering.getState().getIconColor$zendesk_ui_ui_android(), PorterDuff.Mode.SRC_IN);
        setOnClickListener(ThrottledOnClickListenerKt.throttledOnClickListener$default(0L, new Function0<Unit>() {
            {
                super(0);
            }

            @Override
            public Unit invoke() {
                invoke2();
                return Unit.INSTANCE;
            }

            public final void invoke2() {
                FileView.this.rendering.getOnCellClicked$zendesk_ui_ui_android().invoke();
            }
        }, 1, null));
    }

    private final String getFormattedFileSize(long fileSize) {
        Context context = getContext();
        if (Build.VERSION.SDK_INT >= 26) {
            long j = 1000;
            long j2 = fileSize * j * j;
            long j3 = 1024;
            fileSize = (j2 / j3) / j3;
        }
        String fileSize2 = Formatter.formatFileSize(context, fileSize);
        Intrinsics.checkNotNullExpressionValue(fileSize2, "formatFileSize(...)");
        return fileSize2;
    }
}
