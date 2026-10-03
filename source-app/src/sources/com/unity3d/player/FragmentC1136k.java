package com.unity3d.player;

import android.app.Fragment;
import android.app.FragmentTransaction;
import android.os.Bundle;

public final class FragmentC1136k extends Fragment {
    @Override
    public final void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        requestPermissions(new String[]{getArguments().getString("PermissionNames")}, 96489);
    }

    @Override
    public final void onRequestPermissionsResult(int i, String[] strArr, int[] iArr) {
        StringBuilder sb;
        String str;
        if (i != 96489) {
            return;
        }
        if (strArr.length == 0) {
            requestPermissions(new String[]{getArguments().getString("PermissionNames")}, 96489);
            return;
        }
        for (int i2 = 0; i2 < strArr.length && i2 < iArr.length; i2++) {
            if (iArr[i2] == -1) {
                sb = new StringBuilder();
                sb.append(strArr[i2]);
                str = " denied.\n";
            } else {
                sb = new StringBuilder();
                sb.append(strArr[i2]);
                str = " granted";
            }
            sb.append(str);
            C1134i.Log(4, sb.toString());
        }
        FragmentTransaction fragmentTransactionBeginTransaction = getActivity().getFragmentManager().beginTransaction();
        fragmentTransactionBeginTransaction.remove(this);
        fragmentTransactionBeginTransaction.commit();
    }
}
