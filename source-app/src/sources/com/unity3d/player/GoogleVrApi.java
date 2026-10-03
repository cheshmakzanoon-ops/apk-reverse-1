package com.unity3d.player;

import androidx.compose.animation.core.ComplexDouble$;
import java.util.concurrent.atomic.AtomicReference;

public class GoogleVrApi {

    private static AtomicReference f218a = new AtomicReference();

    private GoogleVrApi() {
    }

    static void m446a() {
        f218a.set(null);
    }

    static void m447a(InterfaceC1133h interfaceC1133h) {
        ComplexDouble$.ExternalSyntheticBackport0.m(f218a, (Object) null, new GoogleVrProxy(interfaceC1133h));
    }

    static GoogleVrProxy m448b() {
        return (GoogleVrProxy) f218a.get();
    }

    public static GoogleVrVideo getGoogleVrVideo() {
        return (GoogleVrVideo) f218a.get();
    }
}
