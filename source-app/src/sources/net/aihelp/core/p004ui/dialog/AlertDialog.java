package net.aihelp.core.p004ui.dialog;

import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.view.View;
import net.aihelp.utils.ResResolver;

public class AlertDialog extends Dialog {
    private static long sLastObjectCreatedTime;
    public AlertController mAlert;

    public AlertDialog(Context context, int i) {
        super(context, i);
        this.mAlert = new AlertController(this, getWindow());
    }

    public void setText(int i, CharSequence charSequence) {
        this.mAlert.setText(i, charSequence);
    }

    public void setOnClickListener(int i, View.OnClickListener onClickListener) {
        this.mAlert.setOnClickListener(i, onClickListener);
    }

    public <V extends View> V getView(int i) {
        return (V) this.mAlert.getView(i);
    }

    public static class Builder {

        public final AlertController.AlertParams f76P;
        private Context mContext;
        private OnDoubleChoiceListener mDoubleConfirmListener;
        private OnSingleConfirmListener mSingleConfirmListener;

        public interface OnDoubleChoiceListener {
            void onCancelClicked(AlertDialog alertDialog);

            void onConfirmClicked(AlertDialog alertDialog);
        }

        public interface OnSingleConfirmListener {
            void onConfirmClicked(AlertDialog alertDialog);
        }

        public Builder(Context context) {
            this(context, ResResolver.getStyleId("aihelp_dialog"));
            this.mContext = context;
        }

        public Builder(Context context, int i) {
            this.f76P = new AlertController.AlertParams(context, i);
        }

        public AlertController.AlertParams getAlertParams() {
            return this.f76P;
        }

        public Builder setContentView(int i) {
            this.f76P.mView = null;
            this.f76P.mViewLayoutResId = i;
            return this;
        }

        public Builder setContentView(View view) {
            this.f76P.mView = view;
            this.f76P.mViewLayoutResId = 0;
            return this;
        }

        public Builder setCancelViewId(int i) {
            this.f76P.mCancelViewId = i;
            return this;
        }

        public Builder setConfirmViewId(int i) {
            this.f76P.mSingleConfirmViewId = i;
            return this;
        }

        public Builder setDoubleConfirmViewId(int i, int i2) {
            this.f76P.mLeftConfirmViewId = i;
            this.f76P.mRightConfirmViewId = i2;
            return this;
        }

        public Builder setBottomTextViewId(int i) {
            this.f76P.mBottomTextViewId = i;
            return this;
        }

        public Builder setOnCancelListener(DialogInterface.OnCancelListener onCancelListener) {
            this.f76P.mOnCancelListener = onCancelListener;
            return this;
        }

        public Builder setCancelableOntheOutside(boolean z) {
            this.f76P.mCancelable = z;
            return this;
        }

        public Builder setText(int i, CharSequence charSequence) {
            this.f76P.mTextArray.put(i, charSequence);
            return this;
        }

        public Builder setTextBackground(int i, int i2) {
            this.f76P.mBackgroundResArray.put(i, Integer.valueOf(i2));
            return this;
        }

        public Builder setOnClickListener(int i, View.OnClickListener onClickListener) {
            this.f76P.mClickArray.put(i, onClickListener);
            return this;
        }

        public Builder setOnDismissListener(DialogInterface.OnDismissListener onDismissListener) {
            this.f76P.mOnDismissListener = onDismissListener;
            return this;
        }

        public Builder setOnKeyListener(DialogInterface.OnKeyListener onKeyListener) {
            this.f76P.mOnKeyListener = onKeyListener;
            return this;
        }

        public Builder fullWidth() {
            this.f76P.mWidth = -1;
            return this;
        }

        public Builder fromBottom(boolean z) {
            if (z) {
                this.f76P.mAnimation = ResResolver.getStyleId("aihelp_dialog_from_bottom_anim");
            }
            this.f76P.mGravity = 80;
            return this;
        }

        public Builder fromRight(boolean z) {
            if (z) {
                this.f76P.mAnimation = ResResolver.getStyleId("aihelp_dialog_from_right_anim");
            }
            this.f76P.mGravity = 8388613;
            return this;
        }

        public Builder setWidthAndHeight(int i, int i2) {
            this.f76P.mWidth = dip2px(this.mContext, i);
            this.f76P.mHeight = dip2px(this.mContext, i2);
            if (i == -1 || i == -2) {
                this.f76P.mWidth = i;
            }
            if (i2 == -1 || i2 == -2) {
                this.f76P.mHeight = i2;
            }
            return this;
        }

        public Builder setWidthByDevice() {
            return setWidthByDevice(0.725d);
        }

        public Builder setWidthByDevice(double d) {
            this.f76P.mWidth = (int) (((double) this.mContext.getResources().getDisplayMetrics().widthPixels) * d);
            return this;
        }

        public Builder setHeightByDevice() {
            return setHeightByDevice(0.725d);
        }

        public Builder setHeightByDevice(double d) {
            this.f76P.mHeight = (int) (((double) this.mContext.getResources().getDisplayMetrics().heightPixels) * d);
            return this;
        }

        public Builder setGravity(int i) {
            this.f76P.mGravity = i;
            return this;
        }

        public void setBottomText(String str) {
            this.f76P.mTextArray.put(this.f76P.mBottomTextViewId, str);
        }

        public AlertDialog create() {
            AlertDialog alertDialog = new AlertDialog(this.f76P.mContext, this.f76P.mThemeResId);
            this.f76P.apply(alertDialog.mAlert);
            alertDialog.setCancelable(this.f76P.mCancelable);
            if (this.f76P.mCancelable) {
                alertDialog.setCanceledOnTouchOutside(true);
            }
            alertDialog.setOnCancelListener(this.f76P.mOnCancelListener);
            alertDialog.setOnDismissListener(this.f76P.mOnDismissListener);
            if (this.f76P.mOnKeyListener != null) {
                alertDialog.setOnKeyListener(this.f76P.mOnKeyListener);
            }
            setClickListeners(alertDialog);
            return alertDialog;
        }

        private void setClickListeners(final AlertDialog alertDialog) {
            if (this.f76P.mCancelViewId != 0) {
                alertDialog.getView(this.f76P.mCancelViewId).setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        alertDialog.dismiss();
                    }
                });
            }
            if (this.f76P.mSingleConfirmViewId != 0 && this.mSingleConfirmListener != null) {
                alertDialog.getView(this.f76P.mSingleConfirmViewId).setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        Builder.this.mSingleConfirmListener.onConfirmClicked(alertDialog);
                    }
                });
            }
            if (this.f76P.mLeftConfirmViewId != 0 && this.mDoubleConfirmListener != null) {
                alertDialog.getView(this.f76P.mLeftConfirmViewId).setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        Builder.this.mDoubleConfirmListener.onCancelClicked(alertDialog);
                    }
                });
            }
            if (this.f76P.mRightConfirmViewId == 0 || this.mDoubleConfirmListener == null) {
                return;
            }
            alertDialog.getView(this.f76P.mRightConfirmViewId).setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    Builder.this.mDoubleConfirmListener.onConfirmClicked(alertDialog);
                }
            });
        }

        public AlertDialog show() {
            AlertDialog alertDialogCreate = create();
            if (System.currentTimeMillis() - AlertDialog.sLastObjectCreatedTime > 1000) {
                alertDialogCreate.show();
                long unused = AlertDialog.sLastObjectCreatedTime = System.currentTimeMillis();
            }
            return alertDialogCreate;
        }

        public Builder setOnSingleConfirmListener(OnSingleConfirmListener onSingleConfirmListener) {
            this.mSingleConfirmListener = onSingleConfirmListener;
            return this;
        }

        public Builder setOnDoubleChoiceListener(OnDoubleChoiceListener onDoubleChoiceListener) {
            this.mDoubleConfirmListener = onDoubleChoiceListener;
            return this;
        }

        public int dip2px(Context context, double d) {
            return (int) ((d * ((double) context.getResources().getDisplayMetrics().density)) + 0.5d);
        }

        public static int px2dip(Context context, float f) {
            return (int) ((f / context.getResources().getDisplayMetrics().density) + 0.5f);
        }
    }
}
