package com.gamesafe.ano;

import android.content.DialogInterface;

class DialogInterfaceOnDismissListenerC0979e implements DialogInterface.OnDismissListener {

    final C0978d f551a;

    DialogInterfaceOnDismissListenerC0979e(C0978d c0978d) {
        this.f551a = c0978d;
    }

    @Override
    public void onDismiss(DialogInterface dialogInterface) {
        if (this.f551a.f549i != null) {
            this.f551a.f549i.mo874a(0);
        }
    }
}
