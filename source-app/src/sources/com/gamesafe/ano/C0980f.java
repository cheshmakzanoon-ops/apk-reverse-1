package com.gamesafe.ano;

import android.widget.SeekBar;
import android.widget.TextView;
import java.util.Locale;

class C0980f implements SeekBar.OnSeekBarChangeListener {

    final TextView f552a;

    final C0978d f553b;

    C0980f(C0978d c0978d, TextView textView) {
        this.f553b = c0978d;
        this.f552a = textView;
    }

    @Override
    public void onProgressChanged(SeekBar seekBar, int i, boolean z) {
        this.f552a.setText(String.format(Locale.ENGLISH, "%s%d", this.f553b.f545e, Integer.valueOf(i)));
        this.f553b.f548h = i;
    }

    @Override
    public void onStartTrackingTouch(SeekBar seekBar) {
    }

    @Override
    public void onStopTrackingTouch(SeekBar seekBar) {
        AnoSdk.ioctl(String.format(Locale.ENGLISH, C0975a.m846a("VyyVijOjpxcZqzio:xvko_kmjx=%y"), Integer.valueOf(this.f553b.f548h)));
        seekBar.setProgress(0);
    }
}
