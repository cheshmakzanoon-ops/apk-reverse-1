package com.gamesafe.ano;

import android.content.DialogInterface;

class DialogInterfaceOnDismissListenerC0986l implements DialogInterface.OnDismissListener {

    final C0985k f566a;

    DialogInterfaceOnDismissListenerC0986l(C0985k c0985k) {
        this.f566a = c0985k;
    }

    @Override
    public void onDismiss(DialogInterface dialogInterface) {
        if (this.f566a.f564f != null) {
            this.f566a.f564f.mo874a(0);
        }
    }
}
