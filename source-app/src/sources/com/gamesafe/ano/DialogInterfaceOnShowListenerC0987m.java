package com.gamesafe.ano;

import android.content.DialogInterface;
import android.widget.Button;

class DialogInterfaceOnShowListenerC0987m implements DialogInterface.OnShowListener {

    final C0985k f567a;

    DialogInterfaceOnShowListenerC0987m(C0985k c0985k) {
        this.f567a = c0985k;
    }

    @Override
    public void onShow(DialogInterface dialogInterface) {
        Button button = this.f567a.f559a.getButton(-3);
        if (button != null) {
            button.setTextSize(2, 18.0f);
        }
    }
}
