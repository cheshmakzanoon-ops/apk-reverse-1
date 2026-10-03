package net.aihelp.core.net.mqtt.tansport;

import java.security.cert.X509Certificate;

public interface SecuredSession {
    X509Certificate[] getPeerX509Certificates();
}
