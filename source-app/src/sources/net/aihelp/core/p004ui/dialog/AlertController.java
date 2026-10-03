package net.aihelp.core.p004ui.dialog;

import android.content.Context;
import android.content.DialogInterface;
import android.util.SparseArray;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;

public class AlertController {
    private AlertDialog mDialog;
    private DialogViewHelper mViewHelper;
    private Window mWindow;

    public AlertController(AlertDialog alertDialog, Window window) {
        this.mDialog = alertDialog;
        this.mWindow = window;
    }

    public AlertDialog getDialog() {
        return this.mDialog;
    }

    public Window getWindow() {
        return this.mWindow;
    }

    public void setViewHelper(DialogViewHelper dialogViewHelper) {
        this.mViewHelper = dialogViewHelper;
    }

    public void setText(int i, CharSequence charSequence) {
        this.mViewHelper.setText(i, charSequence);
    }

    public void setOnClickListener(int i, View.OnClickListener onClickListener) {
        this.mViewHelper.setOnClickListener(i, onClickListener);
    }

    public void setBackground(int i, int i2) {
        this.mViewHelper.setBackground(i, i2);
    }

    public <V extends View> V getView(int i) {
        return (V) this.mViewHelper.getView(i);
    }

    public static class AlertParams {
        public int mCancelViewId;
        public Context mContext;
        public int mLeftConfirmViewId;
        public DialogInterface.OnCancelListener mOnCancelListener;
        public DialogInterface.OnDismissListener mOnDismissListener;
        public DialogInterface.OnKeyListener mOnKeyListener;
        public int mRightConfirmViewId;
        public int mSingleConfirmViewId;
        public int mThemeResId;
        public View mView;
        public int mViewLayoutResId;
        public boolean mCancelable = false;
        public SparseArray<CharSequence> mTextArray = new SparseArray<>();
        public SparseArray<View.OnClickListener> mClickArray = new SparseArray<>();
        public SparseArray<Integer> mBackgroundResArray = new SparseArray<>();
        public int mWidth = -2;
        public int mHeight = -2;
        public int mGravity = 17;
        public int mAnimation = 0;
        public int mBottomTextViewId = 0;

        public AlertParams(Context context, int i) {
            this.mContext = context;
            this.mThemeResId = i;
        }

        void apply(AlertController alertController) {
            DialogViewHelper dialogViewHelper = this.mViewLayoutResId != 0 ? new DialogViewHelper(this.mContext, this.mViewLayoutResId) : null;
            if (this.mView != null) {
                dialogViewHelper = new DialogViewHelper();
                dialogViewHelper.setContentView(this.mView);
            }
            if (dialogViewHelper == null) {
                throw new IllegalArgumentException("method setContentView() must be called! ");
            }
            alertController.getDialog().setContentView(dialogViewHelper.getContentView());
            alertController.setViewHelper(dialogViewHelper);
            for (int i = 0; i < this.mTextArray.size(); i++) {
                alertController.setText(this.mTextArray.keyAt(i), this.mTextArray.valueAt(i));
            }
            for (int i2 = 0; i2 < this.mClickArray.size(); i2++) {
                alertController.setOnClickListener(this.mClickArray.keyAt(i2), this.mClickArray.valueAt(i2));
            }
            for (int i3 = 0; i3 < this.mBackgroundResArray.size(); i3++) {
                alertController.setBackground(this.mBackgroundResArray.keyAt(i3), this.mBackgroundResArray.valueAt(i3).intValue());
            }
            Window window = alertController.getWindow();
            window.setGravity(this.mGravity);
            int i4 = this.mAnimation;
            if (i4 != 0) {
                window.setWindowAnimations(i4);
            }
            WindowManager.LayoutParams attributes = window.getAttributes();
            attributes.width = this.mWidth;
            attributes.height = this.mHeight;
            window.setAttributes(attributes);
        }
    }
}
