package net.aihelp.core.util.viewer;

import android.R;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.view.KeyEvent;
import android.view.View;

public class ImageViewer implements DialogInterface.OnShowListener, DialogInterface.OnKeyListener, View.OnClickListener, IOnUserActionResultListener {
    private Context context;
    private IOnUserActionResultListener onUserActionResultListener;
    private ViewerLayout rootLayout;
    private boolean shown;
    private Dialog transDialog;

    private ImageViewer(Context context) {
        this.context = context;
        createLayout();
        createDialog();
    }

    public static ImageViewer getDefault(Context context) {
        return new ImageViewer(context);
    }

    private void createLayout() {
        ViewerLayout viewerLayout = new ViewerLayout(this.context);
        this.rootLayout = viewerLayout;
        viewerLayout.setOnChildViewClickedListener(this);
        this.rootLayout.setOnUserActionResultListener(this);
    }

    private void createDialog() {
        AlertDialog alertDialogCreate = new AlertDialog.Builder(this.context, R.style.Theme.Translucent.NoTitleBar.Fullscreen).setView(this.rootLayout).create();
        this.transDialog = alertDialogCreate;
        alertDialogCreate.setOnShowListener(this);
        this.transDialog.setOnKeyListener(this);
    }

    public ImageViewer setOnUserActionResultListener(IOnUserActionResultListener iOnUserActionResultListener) {
        this.onUserActionResultListener = iOnUserActionResultListener;
        return this;
    }

    public ImageViewer updateImageResource(String str) {
        ViewerLayout viewerLayout = this.rootLayout;
        if (viewerLayout != null) {
            viewerLayout.updateImageResource(str);
        }
        return this;
    }

    public ImageViewer updateVideoResource(String str, String str2) {
        ViewerLayout viewerLayout = this.rootLayout;
        if (viewerLayout != null) {
            viewerLayout.updateImageResource(str);
            this.rootLayout.updateVideoResource(str2);
        }
        return this;
    }

    public boolean isShown() {
        return this.shown;
    }

    public void show() {
        if (this.shown) {
            return;
        }
        this.transDialog.show();
        this.shown = true;
    }

    public void dismiss() {
        if (this.shown) {
            this.shown = false;
        }
        this.transDialog.dismiss();
    }

    @Override
    public void onShow(DialogInterface dialogInterface) {
        this.rootLayout.show();
    }

    @Override
    public boolean onKey(DialogInterface dialogInterface, int i, KeyEvent keyEvent) {
        if (i != 4 || keyEvent.getAction() != 1 || keyEvent.isCanceled()) {
            return false;
        }
        dismiss();
        return true;
    }

    @Override
    public void onClick(View view) {
        dismiss();
    }

    @Override
    public void onCancel() {
        IOnUserActionResultListener iOnUserActionResultListener = this.onUserActionResultListener;
        if (iOnUserActionResultListener != null) {
            iOnUserActionResultListener.onCancel();
        }
    }

    @Override
    public void onConfirm(String str) {
        IOnUserActionResultListener iOnUserActionResultListener = this.onUserActionResultListener;
        if (iOnUserActionResultListener != null) {
            iOnUserActionResultListener.onConfirm(str);
        }
    }
}
