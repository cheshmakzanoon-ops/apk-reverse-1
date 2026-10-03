package net.aihelp.core.util.permission;

import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.view.View;
import android.widget.TextView;
import net.aihelp.core.p004ui.dialog.AlertDialog;
import net.aihelp.utils.ResResolver;

public class RequestAlertHelper {
    private static final String AIHELP_PERMISSION_REQUEST_ALERT = "AIHELP_PERMISSION_REQUEST_ALERT";

    private static boolean checkMetaData(Context context) {
        try {
            ApplicationInfo applicationInfo = context.getPackageManager().getApplicationInfo(context.getPackageName(), 128);
            if (applicationInfo.metaData == null) {
                return false;
            }
            for (String str : applicationInfo.metaData.keySet()) {
                if (AIHELP_PERMISSION_REQUEST_ALERT.equals(str)) {
                    return "yes".equals(applicationInfo.metaData.get(str));
                }
            }
            return false;
        } catch (Exception unused) {
            return false;
        }
    }

    public static void request(Context context, PermissionHelper permissionHelper) {
        if (permissionHelper == null) {
            return;
        }
        if (context != null && checkMetaData(context)) {
            showRequestAlert(context, permissionHelper);
        } else {
            permissionHelper.requestPermission();
        }
    }

    public static void showRequestAlert(Context context, final PermissionHelper permissionHelper) {
        if (permissionHelper.avoidInvoking()) {
            return;
        }
        final AlertDialog alertDialogCreate = new AlertDialog.Builder(context).setContentView(ResResolver.getLayoutId("aihelp_dia_request_permission")).setWidthByDevice().create();
        TextView textView = (TextView) alertDialogCreate.getView(ResResolver.getViewId("aihelp_tv_title"));
        TextView textView2 = (TextView) alertDialogCreate.getView(ResResolver.getViewId("aihelp_tv_cancel"));
        TextView textView3 = (TextView) alertDialogCreate.getView(ResResolver.getViewId("aihelp_tv_confirm"));
        textView.setText(ResResolver.getString("aihelp_storage_permission"));
        textView2.setText(ResResolver.getString("aihelp_no"));
        textView3.setText(ResResolver.getString("aihelp_yes"));
        alertDialogCreate.setOnClickListener(ResResolver.getViewId("aihelp_tv_cancel"), new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                alertDialogCreate.dismiss();
                permissionHelper.setInvokeId(-1);
                permissionHelper.invokePermissionCallback(Permission.Result.CANCELED);
            }
        });
        textView3.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                alertDialogCreate.dismiss();
                permissionHelper.requestPermission();
            }
        });
        alertDialogCreate.show();
    }
}
