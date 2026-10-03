package net.aihelp.core.net.mqtt.cli;

import java.io.File;
import java.io.RandomAccessFile;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;
import net.aihelp.core.net.mqtt.client.Callback;
import net.aihelp.core.net.mqtt.client.CallbackConnection;
import net.aihelp.core.net.mqtt.client.MQTT;
import net.aihelp.core.net.mqtt.client.QoS;
import net.aihelp.core.net.mqtt.hawtbuf.AsciiBuffer;
import net.aihelp.core.net.mqtt.hawtbuf.Buffer;
import net.aihelp.core.net.mqtt.hawtbuf.ByteArrayOutputStream;
import net.aihelp.core.net.mqtt.hawtbuf.UTF8Buffer;
import net.aihelp.core.net.mqtt.hawtdispatch.Task;

public class Publisher {
    private Buffer body;
    private boolean debug;
    private boolean prefixCounter;
    private boolean retain;
    private long sleep;
    private UTF8Buffer topic;
    private final MQTT mqtt = new MQTT();
    private QoS qos = QoS.AT_MOST_ONCE;
    private long count = 1;

    private static void displayHelpAndExit(int i) {
        stdout("");
        stdout("This is a simple mqtt client that will publish to a topic.");
        stdout("");
        stdout("Arguments: [-h host] [-k keepalive] [-c] [-i id] [-u username [-p password]]");
        stdout("           [--will-topic topic [--will-payload payload] [--will-qos qos] [--will-retain]]");
        stdout("           [-d] [-n count] [-s sleep] [-q qos] [-r] -t topic ( -pc | -m message | -z | -f file )");
        stdout("");
        stdout("");
        stdout(" -h : mqtt host uri to connect to. Defaults to tcp://localhost:1883.");
        stdout(" -k : keep alive in seconds for this client. Defaults to 60.");
        stdout(" -c : disable 'clean session'.");
        stdout(" -i : id to use for this client. Defaults to a random id.");
        stdout(" -u : provide a username (requires MQTT 3.1 broker)");
        stdout(" -p : provide a password (requires MQTT 3.1 broker)");
        stdout(" --will-topic : the topic on which to publish the client Will.");
        stdout(" --will-payload : payload for the client Will, which is sent by the broker in case of");
        stdout("                  unexpected disconnection. If not given and will-topic is set, a zero");
        stdout("                  length message will be sent.");
        stdout(" --will-qos : QoS level for the client Will.");
        stdout(" --will-retain : if given, make the client Will retained.");
        stdout(" -d : display debug info on stderr");
        stdout(" -n : the number of times to publish the message");
        stdout(" -s : the number of milliseconds to sleep between publish operations (defaut: 0)");
        stdout(" -q : quality of service level to use for the publish. Defaults to 0.");
        stdout(" -r : message should be retained.");
        stdout(" -t : mqtt topic to publish to.");
        stdout(" -m : message payload to send.");
        stdout(" -z : send a null (zero length) message.");
        stdout(" -f : send the contents of a file as the message.");
        stdout(" -pc : prefix a message counter to the message");
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
        Publisher publisher = new Publisher();
        LinkedList linkedList = new LinkedList(Arrays.asList(strArr));
        while (!linkedList.isEmpty()) {
            try {
                String str = (String) linkedList.removeFirst();
                if ("--help".equals(str)) {
                    displayHelpAndExit(0);
                } else if ("-v".equals(str)) {
                    publisher.mqtt.setVersion(shift(linkedList));
                } else if ("-h".equals(str)) {
                    publisher.mqtt.setHost(shift(linkedList));
                } else if ("-k".equals(str)) {
                    publisher.mqtt.setKeepAlive(Short.parseShort(shift(linkedList)));
                } else if ("-c".equals(str)) {
                    publisher.mqtt.setCleanSession(false);
                } else if ("-i".equals(str)) {
                    publisher.mqtt.setClientId(shift(linkedList));
                } else if ("-u".equals(str)) {
                    publisher.mqtt.setUserName(shift(linkedList));
                } else if ("-p".equals(str)) {
                    publisher.mqtt.setPassword(shift(linkedList));
                } else if ("--will-topic".equals(str)) {
                    publisher.mqtt.setWillTopic(shift(linkedList));
                } else if ("--will-payload".equals(str)) {
                    publisher.mqtt.setWillMessage(shift(linkedList));
                } else if ("--will-qos".equals(str)) {
                    int i = Integer.parseInt(shift(linkedList));
                    if (i > QoS.values().length) {
                        stderr("Invalid qos value : " + i);
                        displayHelpAndExit(1);
                    }
                    publisher.mqtt.setWillQos(QoS.values()[i]);
                } else if ("--will-retain".equals(str)) {
                    publisher.mqtt.setWillRetain(true);
                } else if ("-d".equals(str)) {
                    publisher.debug = true;
                } else if ("-n".equals(str)) {
                    publisher.count = Long.parseLong(shift(linkedList));
                } else if ("-s".equals(str)) {
                    publisher.sleep = Long.parseLong(shift(linkedList));
                } else if ("-q".equals(str)) {
                    int i2 = Integer.parseInt(shift(linkedList));
                    if (i2 > QoS.values().length) {
                        stderr("Invalid qos value : " + i2);
                        displayHelpAndExit(1);
                    }
                    publisher.qos = QoS.values()[i2];
                } else if ("-r".equals(str)) {
                    publisher.retain = true;
                } else if ("-t".equals(str)) {
                    publisher.topic = new UTF8Buffer(shift(linkedList));
                } else if ("-m".equals(str)) {
                    publisher.body = new UTF8Buffer(shift(linkedList) + "\n");
                } else if ("-z".equals(str)) {
                    publisher.body = new UTF8Buffer("");
                } else if ("-f".equals(str)) {
                    RandomAccessFile randomAccessFile = new RandomAccessFile(new File(shift(linkedList)), "r");
                    try {
                        byte[] bArr = new byte[(int) randomAccessFile.length()];
                        randomAccessFile.seek(0L);
                        randomAccessFile.readFully(bArr);
                        publisher.body = new Buffer(bArr);
                        randomAccessFile.close();
                    } catch (Throwable th) {
                        randomAccessFile.close();
                        throw th;
                    }
                } else if ("-pc".equals(str)) {
                    publisher.prefixCounter = true;
                } else {
                    stderr("Invalid usage: unknown option: " + str);
                    displayHelpAndExit(1);
                }
            } catch (NumberFormatException unused) {
                stderr("Invalid usage: argument not a number");
                displayHelpAndExit(1);
            }
        }
        if (publisher.topic == null) {
            stderr("Invalid usage: no topic specified.");
            displayHelpAndExit(1);
        }
        if (publisher.body == null) {
            stderr("Invalid usage: -z -m or -f must be specified.");
            displayHelpAndExit(1);
        }
        publisher.execute();
        System.exit(0);
    }

    private void execute() {
        CallbackConnection callbackConnection = this.mqtt.callbackConnection();
        CountDownLatch countDownLatch = new CountDownLatch(1);
        Runtime.getRuntime().addShutdownHook(new C04491(callbackConnection, countDownLatch));
        callbackConnection.listener(new net.aihelp.core.net.mqtt.client.Listener() {
            @Override
            public void onPublish(UTF8Buffer uTF8Buffer, Buffer buffer, Runnable runnable) {
            }

            @Override
            public void onConnected() {
                if (Publisher.this.debug) {
                    Publisher.stderr("Connected");
                }
            }

            @Override
            public void onDisconnected() {
                if (Publisher.this.debug) {
                    Publisher.stderr("Disconnected");
                }
            }

            @Override
            public void onFailure(Throwable th) {
                if (!Publisher.this.debug) {
                    Publisher.stderr(th);
                } else {
                    th.printStackTrace();
                }
                System.exit(2);
            }
        });
        callbackConnection.resume();
        callbackConnection.connect(new Callback<Void>() {
            @Override
            public void onSuccess(Void r1) {
            }

            @Override
            public void onFailure(Throwable th) {
                if (!Publisher.this.debug) {
                    Publisher.stderr(th);
                } else {
                    th.printStackTrace();
                }
                System.exit(2);
            }
        });
        new C04524(callbackConnection, countDownLatch).run();
        try {
            countDownLatch.await();
        } catch (Exception e) {
            e.printStackTrace();
        }
        System.exit(0);
    }

    class C04491 extends Thread {
        final CallbackConnection val$connection;
        final CountDownLatch val$done;

        C04491(CallbackConnection callbackConnection, CountDownLatch countDownLatch) {
            this.val$connection = callbackConnection;
            this.val$done = countDownLatch;
        }

        @Override
        public void run() {
            setName("MQTT client shutdown");
            this.val$connection.getDispatchQueue().execute(new Task() {
                @Override
                public void run() {
                    C04491.this.val$connection.disconnect(new Callback<Void>() {
                        @Override
                        public void onSuccess(Void r1) {
                            C04491.this.val$done.countDown();
                        }

                        @Override
                        public void onFailure(Throwable th) {
                            C04491.this.val$done.countDown();
                        }
                    });
                }
            });
        }
    }

    class C04524 extends Task {
        private long sent = 0;
        final CallbackConnection val$connection;
        final CountDownLatch val$done;

        C04524(CallbackConnection callbackConnection, CountDownLatch countDownLatch) {
            this.val$connection = callbackConnection;
            this.val$done = countDownLatch;
        }

        static long access$708(C04524 c04524) {
            long j = c04524.sent;
            c04524.sent = 1 + j;
            return j;
        }

        @Override
        public void run() {
            Buffer buffer = Publisher.this.body;
            if (Publisher.this.prefixCounter) {
                long j = this.sent + 1;
                ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream(buffer.length + 15);
                byteArrayOutputStream.write(new AsciiBuffer(Long.toString(j)));
                byteArrayOutputStream.write(58);
                byteArrayOutputStream.write(Publisher.this.body);
                buffer = byteArrayOutputStream.toBuffer();
            }
            this.val$connection.publish(Publisher.this.topic, buffer, Publisher.this.qos, Publisher.this.retain, new Callback<Void>() {
                @Override
                public void onSuccess(Void r5) {
                    C04524.access$708(C04524.this);
                    if (Publisher.this.debug) {
                        Publisher.stdout("Sent message #" + C04524.this.sent);
                    }
                    if (C04524.this.sent >= Publisher.this.count) {
                        C04524.this.val$connection.disconnect(new Callback<Void>() {
                            @Override
                            public void onSuccess(Void r1) {
                                C04524.this.val$done.countDown();
                            }

                            @Override
                            public void onFailure(Throwable th) {
                                C04524.this.val$done.countDown();
                            }
                        });
                    } else if (Publisher.this.sleep > 0) {
                        System.out.println("Sleeping");
                        C04524.this.val$connection.getDispatchQueue().executeAfter(Publisher.this.sleep, TimeUnit.MILLISECONDS, this);
                    } else {
                        C04524.this.val$connection.getDispatchQueue().execute(this);
                    }
                }

                @Override
                public void onFailure(Throwable th) {
                    Publisher.stderr("Publish failed: " + th);
                    if (Publisher.this.debug) {
                        th.printStackTrace();
                    }
                    System.exit(2);
                }
            });
        }
    }
}
