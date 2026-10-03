package net.aihelp.utils;

import android.R;
import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import android.widget.Toast;
import java.util.WeakHashMap;
import net.aihelp.config.AIHelpContext;
import net.aihelp.core.util.concurrent.ApiExecutorFactory;
import net.aihelp.p007ui.widget.snackbar.Snackbar;

public enum ToastUtil {
    INSTANCE;

    private Snackbar snackbar;
    private Toast toast;
    private final WeakHashMap<View, Snackbar> viewToSnackBarMapping = new WeakHashMap<>();

    ToastUtil() {
    }

    public void makeRawToast(final Context context, final String str) {
        ApiExecutorFactory.getHandlerExecutor().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                try {
                    if (ToastUtil.this.toast != null) {
                        ToastUtil.this.toast.setView(null);
                        ToastUtil.this.toast.setText(str);
                    } else {
                        ToastUtil.this.toast = Toast.makeText(context.getApplicationContext(), str, 0);
                    }
                    ToastUtil.this.toast.show();
                } catch (Exception unused) {
                    Toast.makeText(context.getApplicationContext(), str, 0).show();
                }
            }
        });
    }

    public void makeText(final Context context, final String str, final boolean z) {
        ApiExecutorFactory.getHandlerExecutor().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                try {
                    View viewInflate = LayoutInflater.from(context).inflate(ResResolver.getLayoutId("aihelp_toast_center_view"), (ViewGroup) null);
                    TextView textView = (TextView) viewInflate.findViewById(ResResolver.getViewId("aihelp_toast_txt"));
                    textView.setText(str);
                    if (ToastUtil.this.toast != null) {
                        textView.setText(str);
                    } else {
                        ToastUtil.this.toast = Toast.makeText(context.getApplicationContext(), str, z ? 1 : 0);
                    }
                    ToastUtil.this.toast.setView(viewInflate);
                    ToastUtil.this.toast.setGravity(17, 0, 0);
                    ToastUtil.this.toast.show();
                } catch (Exception unused) {
                    Toast.makeText(context.getApplicationContext(), str, 0).show();
                }
            }
        });
    }

    public void makeTextWithIcon(final Context context, final String str, final boolean z) {
        ApiExecutorFactory.getHandlerExecutor().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                try {
                    View viewInflate = LayoutInflater.from(context).inflate(ResResolver.getLayoutId("aihelp_toast_network_fine"), (ViewGroup) null);
                    TextView textView = (TextView) viewInflate.findViewById(ResResolver.getViewId("aihelp_toast_txt"));
                    textView.setText(str);
                    if (ToastUtil.this.toast != null) {
                        textView.setText(str);
                    } else {
                        ToastUtil.this.toast = Toast.makeText(context.getApplicationContext(), str, z ? 1 : 0);
                    }
                    ToastUtil.this.toast.setView(viewInflate);
                    ToastUtil.this.toast.setGravity(17, 0, 0);
                    ToastUtil.this.toast.show();
                } catch (Exception unused) {
                    Toast.makeText(context.getApplicationContext(), str, 0).show();
                }
            }
        });
    }

    public void showSnackBar(final View view, final String str, final boolean z) {
        ApiExecutorFactory.getHandlerExecutor().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                try {
                    String str2 = str;
                    if (str2 != null && str2.length() != 0) {
                        View view2 = view;
                        int i = 0;
                        if (view2 != null) {
                            ToastUtil toastUtil = ToastUtil.this;
                            String str3 = str;
                            if (!z) {
                                i = -1;
                            }
                            toastUtil.snackbar = Snackbar.make(view2, str3, i);
                            ToastUtil.this.snackbar.show();
                            ToastUtil.this.viewToSnackBarMapping.put(view, ToastUtil.this.snackbar);
                        } else {
                            ToastUtil.this.makeText(AIHelpContext.getInstance().getContext(), str, false);
                        }
                    }
                } catch (Exception unused) {
                }
            }
        });
    }

    public void hideSnackBar(final View view) {
        ApiExecutorFactory.getHandlerExecutor().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                try {
                    if (view != null) {
                        Snackbar snackbar = (Snackbar) ToastUtil.this.viewToSnackBarMapping.get(view);
                        if (snackbar != null && snackbar.isShown()) {
                            snackbar.dismiss();
                        }
                        ToastUtil.this.viewToSnackBarMapping.remove(view);
                    }
                } catch (Exception unused) {
                }
            }
        });
    }

    public void showSnackBar(final Activity activity, final String str, final boolean z) {
        ApiExecutorFactory.getHandlerExecutor().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                String str2;
                try {
                    if ((ToastUtil.this.snackbar != null && ToastUtil.this.snackbar.isShown()) || (str2 = str) == null || str2.length() == 0) {
                        return;
                    }
                    Snackbar snackbarMake = Snackbar.make(activity.getWindow().getDecorView().findViewById(R.id.content), str, z ? 0 : -1);
                    View view = snackbarMake.getView();
                    view.setBackgroundColor(-1);
                    ((TextView) view.findViewById(ResResolver.getViewId("snackbar_text"))).setTextColor(Color.parseColor("#1B8AFA"));
                    snackbarMake.setActionTextColor(Color.parseColor("#1B8AFA"));
                    snackbarMake.show();
                } catch (Exception unused) {
                }
            }
        });
    }

    public void showSnackBar(final Activity activity, final String str, final String str2, final View.OnClickListener onClickListener) {
        ApiExecutorFactory.getHandlerExecutor().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                try {
                    String str3 = str;
                    if (str3 == null || str3.length() == 0) {
                        return;
                    }
                    ToastUtil.this.snackbar = Snackbar.make(activity.getWindow().getDecorView().findViewById(R.id.content), str, 0).setAction(str2, onClickListener);
                    View view = ToastUtil.this.snackbar.getView();
                    view.setBackgroundColor(Color.parseColor("#EFF1F6"));
                    ((TextView) view.findViewById(ResResolver.getViewId("snackbar_text"))).setTextColor(Color.parseColor("#1B8AFA"));
                    ToastUtil.this.snackbar.setActionTextColor(Color.parseColor("#1B8AFA"));
                    ToastUtil.this.snackbar.show();
                } catch (Exception unused) {
                }
            }
        });
    }

    public void showRawSnackBar(final Activity activity, final String str, final int i) {
        ApiExecutorFactory.getHandlerExecutor().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                try {
                    String str2 = str;
                    if (str2 != null && str2.length() != 0) {
                        Activity activity2 = activity;
                        if (activity2 != null) {
                            Snackbar.make(activity2.getWindow().getDecorView().findViewById(R.id.content), str, i).show();
                        } else {
                            ToastUtil.this.makeText(AIHelpContext.getInstance().getContext(), str, false);
                        }
                    }
                } catch (Exception unused) {
                }
            }
        });
    }

    public void showRawSnackBar(final Activity activity, final String str, final String str2, final int i, final View.OnClickListener onClickListener) {
        ApiExecutorFactory.getHandlerExecutor().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                try {
                    String str3 = str;
                    if (str3 == null || str3.length() == 0) {
                        return;
                    }
                    Activity activity2 = activity;
                    if (activity2 != null) {
                        Snackbar action = Snackbar.make(activity2.getWindow().getDecorView().findViewById(R.id.content), str, i).setAction(str2, onClickListener);
                        if (action.getView().findViewById(ResResolver.getViewId("snackbar_text")) instanceof TextView) {
                            ((TextView) action.getView().findViewById(ResResolver.getViewId("snackbar_text"))).setMaxLines(4);
                        }
                        if (action.getView().findViewById(ResResolver.getViewId("snackbar_action")) instanceof TextView) {
                            ((TextView) action.getView().findViewById(ResResolver.getViewId("snackbar_action"))).setTextColor(Color.parseColor("#5C7EFF"));
                        }
                        action.show();
                        return;
                    }
                    ToastUtil.this.makeText(AIHelpContext.getInstance().getContext(), str, false);
                } catch (Exception unused) {
                }
            }
        });
    }
}
