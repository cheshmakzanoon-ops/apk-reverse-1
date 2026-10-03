package net.aihelp.core.net.mqtt.cli;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.concurrent.CountDownLatch;
import net.aihelp.core.net.mqtt.client.Callback;
import net.aihelp.core.net.mqtt.client.CallbackConnection;
import net.aihelp.core.net.mqtt.client.MQTT;
import net.aihelp.core.net.mqtt.client.QoS;
import net.aihelp.core.net.mqtt.client.Topic;
import net.aihelp.core.net.mqtt.hawtbuf.Buffer;
import net.aihelp.core.net.mqtt.hawtbuf.UTF8Buffer;
import net.aihelp.core.net.mqtt.hawtdispatch.Task;

public class Listener {
    private boolean debug;
    private boolean showTopic;
    private final MQTT mqtt = new MQTT();
    private final ArrayList<Topic> topics = new ArrayList<>();

    private static void displayHelpAndExit(int i) {
        stdout("");
        stdout("This is a simple mqtt client that will subscribe to topics and print all messages it receives.");
        stdout("");
        stdout("Arguments: [-h host] [-k keepalive] [-c] [-i id] [-u username [-p password]]");
        stdout("           [--will-topic topic [--will-payload payload] [--will-qos qos] [--will-retain]]");
        stdout("           [-d] [-s]");
        stdout("           ( [-q qos] -t topic )+");
        stdout("");
        stdout("");
        stdout(" -h : mqtt host uri to connect to. Defaults to tcp://localhost:1883.");
        stdout(" -k : keep alive in seconds for this client. Defaults to 60.");
        stdout(" -c : disable 'clean session' (store subscription and pending messages when client disconnects).");
        stdout(" -i : id to use for this client. Defaults to a random id.");
        stdout(" -u : provide a username (requires MQTT 3.1 broker)");
        stdout(" -p : provide a password (requires MQTT 3.1 broker)");
        stdout(" --will-topic : the topic on which to publish the client Will.");
        stdout(" --will-payload : payload for the client Will, which is sent by the broker in case of");
        stdout("                  unexpected disconnection. If not given and will-topic is set, a zero");
        stdout("                  length message will be sent.");
        stdout(" --will-qos : QoS level for the client Will.");
        stdout(" --will-retain : if given, make the client Will retained.");
        stdout(" -d : dispaly debug info on stderr");
        stdout(" -s : show message topics in output");
        stdout(" -q : quality of service level to use for the subscription. Defaults to 0.");
        stdout(" -t : mqtt topic to subscribe to. May be repeated multiple times.");
        stdout(" -v : MQTT version to use 3.1 or 3.1.1. (default: 3.1)");
        stdout("");
        System.exit(i);
    }

    public static void stdout(Object obj) {
        System.out.println(obj);
    }

    public static void stderr(Object obj) {
        System.err.println(obj);
    }

    private static String shift(LinkedList<String> linkedList) {
        if (linkedList.isEmpty()) {
            stderr("Invalid usage: Missing argument");
            displayHelpAndExit(1);
        }
        return linkedList.removeFirst();
    }

    public static void main(String[] strArr) throws Exception {
        Listener listener = new Listener();
        QoS qoS = QoS.AT_MOST_ONCE;
        LinkedList linkedList = new LinkedList(Arrays.asList(strArr));
        while (!linkedList.isEmpty()) {
            try {
                String str = (String) linkedList.removeFirst();
                if ("--help".equals(str)) {
                    displayHelpAndExit(0);
                } else if ("-v".equals(str)) {
                    listener.mqtt.setVersion(shift(linkedList));
                } else if ("-h".equals(str)) {
                    listener.mqtt.setHost(shift(linkedList));
                } else if ("-k".equals(str)) {
                    listener.mqtt.setKeepAlive(Short.parseShort(shift(linkedList)));
                } else if ("-c".equals(str)) {
                    listener.mqtt.setCleanSession(false);
                } else if ("-i".equals(str)) {
                    listener.mqtt.setClientId(shift(linkedList));
                } else if ("-u".equals(str)) {
                    listener.mqtt.setUserName(shift(linkedList));
                } else if ("-p".equals(str)) {
                    listener.mqtt.setPassword(shift(linkedList));
                } else if ("--will-topic".equals(str)) {
                    listener.mqtt.setWillTopic(shift(linkedList));
                } else if ("--will-payload".equals(str)) {
                    listener.mqtt.setWillMessage(shift(linkedList));
                } else if ("--will-qos".equals(str)) {
                    int i = Integer.parseInt(shift(linkedList));
                    if (i > QoS.values().length) {
                        stderr("Invalid qos value : " + i);
                        displayHelpAndExit(1);
                    }
                    listener.mqtt.setWillQos(QoS.values()[i]);
                } else if ("--will-retain".equals(str)) {
                    listener.mqtt.setWillRetain(true);
                } else if ("-d".equals(str)) {
                    listener.debug = true;
                } else if ("-s".equals(str)) {
                    listener.showTopic = true;
                } else if ("-q".equals(str)) {
                    int i2 = Integer.parseInt(shift(linkedList));
                    if (i2 > QoS.values().length) {
                        stderr("Invalid qos value : " + i2);
                        displayHelpAndExit(1);
                    }
                    qoS = QoS.values()[i2];
                } else if ("-t".equals(str)) {
                    listener.topics.add(new Topic(shift(linkedList), qoS));
                } else {
                    stderr("Invalid usage: unknown option: " + str);
                    displayHelpAndExit(1);
                }
            } catch (NumberFormatException unused) {
                stderr("Invalid usage: argument not a number");
                displayHelpAndExit(1);
            }
        }
        if (listener.topics.isEmpty()) {
            stderr("Invalid usage: no topics specified.");
            displayHelpAndExit(1);
        }
        listener.execute();
        System.exit(0);
    }

    private void execute() {
        final CallbackConnection callbackConnection = this.mqtt.callbackConnection();
        CountDownLatch countDownLatch = new CountDownLatch(1);
        Runtime.getRuntime().addShutdownHook(new C04461(callbackConnection, countDownLatch));
        callbackConnection.listener(new net.aihelp.core.net.mqtt.client.Listener() {
            @Override
            public void onConnected() {
                if (Listener.this.debug) {
                    Listener.stderr("Connected");
                }
            }

            @Override
            public void onDisconnected() {
                if (Listener.this.debug) {
                    Listener.stderr("Disconnected");
                }
            }

            @Override
            public void onPublish(UTF8Buffer uTF8Buffer, Buffer buffer, Runnable runnable) {
                try {
                    if (Listener.this.showTopic) {
                        Listener.stdout("");
                        Listener.stdout("Topic: " + uTF8Buffer);
                        buffer.writeTo(System.out);
                        Listener.stdout("");
                    } else {
                        buffer.writeTo(System.out);
                    }
                    runnable.run();
                } catch (IOException e) {
                    onFailure(e);
                }
            }

            @Override
            public void onFailure(Throwable th) {
                if (!Listener.this.debug) {
                    Listener.stderr(th);
                } else {
                    th.printStackTrace();
                }
                System.exit(2);
            }
        });
        callbackConnection.resume();
        callbackConnection.connect(new Callback<Void>() {
            @Override
            public void onFailure(Throwable th) {
                if (!Listener.this.debug) {
                    Listener.stderr(th);
                } else {
                    th.printStackTrace();
                }
                System.exit(2);
            }

            @Override
            public void onSuccess(Void r3) {
                final Topic[] topicArr = (Topic[]) Listener.this.topics.toArray(new Topic[Listener.this.topics.size()]);
                callbackConnection.subscribe(topicArr, new Callback<byte[]>() {
                    @Override
                    public void onSuccess(byte[] bArr) {
                        if (Listener.this.debug) {
                            for (int i = 0; i < bArr.length; i++) {
                                Listener.stderr("Subscribed to Topic: " + topicArr[i].name() + " with QoS: " + QoS.values()[bArr[i]]);
                            }
                        }
                    }

                    @Override
                    public void onFailure(Throwable th) {
                        Listener.stderr("Subscribe failed: " + th);
                        if (Listener.this.debug) {
                            th.printStackTrace();
                        }
                        System.exit(2);
                    }
                });
            }
        });
        try {
            countDownLatch.await();
        } catch (Exception e) {
            e.printStackTrace();
        }
        System.exit(0);
    }

    class C04461 extends Thread {
        final CallbackConnection val$connection;
        final CountDownLatch val$done;

        C04461(CallbackConnection callbackConnection, CountDownLatch countDownLatch) {
            this.val$connection = callbackConnection;
            this.val$done = countDownLatch;
        }

        @Override
        public void run() {
            setName("MQTT client shutdown");
            if (Listener.this.debug) {
                Listener.stderr("Disconnecting the client.");
            }
            this.val$connection.getDispatchQueue().execute(new Task() {
                @Override
                public void run() {
                    C04461.this.val$connection.disconnect(new Callback<Void>() {
                        @Override
                        public void onSuccess(Void r1) {
                            C04461.this.val$done.countDown();
                        }

                        @Override
                        public void onFailure(Throwable th) {
                            C04461.this.val$done.countDown();
                        }
                    });
                }
            });
        }
    }
}
