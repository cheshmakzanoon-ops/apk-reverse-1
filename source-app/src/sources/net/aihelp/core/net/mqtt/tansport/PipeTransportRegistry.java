package net.aihelp.core.net.mqtt.tansport;

import java.io.IOException;
import java.net.URISyntaxException;
import java.util.HashMap;
import java.util.Map;

public class PipeTransportRegistry {
    public static final HashMap<String, PipeTransportServer> servers = new HashMap<>();

    public static synchronized TransportServer bind(String str) throws URISyntaxException, IOException {
        PipeTransportServer pipeTransportServer;
        HashMap<String, PipeTransportServer> map = servers;
        if (map.containsKey(str)) {
            throw new IOException("Server already bound: " + str);
        }
        pipeTransportServer = new PipeTransportServer();
        pipeTransportServer.setConnectURI(str);
        pipeTransportServer.setName(str);
        map.put(str, pipeTransportServer);
        return pipeTransportServer;
    }

    public static synchronized Transport connect(String str) throws URISyntaxException, IOException {
        PipeTransportServer pipeTransportServerLookup;
        pipeTransportServerLookup = lookup(str);
        if (pipeTransportServerLookup == null) {
            throw new IOException("Server is not bound: " + str);
        }
        return pipeTransportServerLookup.connect();
    }

    public static synchronized PipeTransportServer lookup(String str) {
        return servers.get(str);
    }

    public static synchronized Map<String, PipeTransportServer> getServers() {
        return new HashMap(servers);
    }

    public static synchronized void unbind(PipeTransportServer pipeTransportServer) {
        servers.remove(pipeTransportServer.getName());
    }
}
