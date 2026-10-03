package com.joke.speedfloatingball;

import BMGame.GameKillerApp;
import android.content.Context;
import android.util.Base64;
import android.widget.Toast;

public class SpeedApplication extends GameKillerApp {
    public void onCreate() {
        Toast.makeText((Context) this, (CharSequence) new String(Base64.decode("ICBNb2QgQlkgTU9EWk1BTklBLkNPTSAg", 0)), 1).show();
        super.onCreate();
        JokeInit.getSingleton().initRegister(this);
    }
}
