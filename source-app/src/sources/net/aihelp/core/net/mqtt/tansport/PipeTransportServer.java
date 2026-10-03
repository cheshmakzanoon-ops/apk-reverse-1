package net.aihelp.core.net.mqtt.tansport;

import java.net.InetSocketAddress;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.concurrent.Executor;
import java.util.concurrent.atomic.AtomicInteger;
import net.aihelp.core.net.mqtt.hawtdispatch.CustomDispatchSource;
import net.aihelp.core.net.mqtt.hawtdispatch.Dispatch;
import net.aihelp.core.net.mqtt.hawtdispatch.DispatchQueue;
import net.aihelp.core.net.mqtt.hawtdispatch.EventAggregators;
import net.aihelp.core.net.mqtt.hawtdispatch.Task;
import net.aihelp.core.net.mqtt.hawtdispatch.TaskWrapper;

public class PipeTransportServer implements TransportServer {
    private CustomDispatchSource<PipeTransport, LinkedList<PipeTransport>> acceptSource;
    protected String connectURI;
    protected final AtomicInteger connectionCounter = new AtomicInteger();
    DispatchQueue dispatchQueue;
    protected TransportServerListener listener;
    protected boolean marshal;
    protected String name;

    @Override
    public Executor getBlockingExecutor() {
        return null;
    }

    @Override
    public InetSocketAddress getSocketAddress() {
        return null;
    }

    @Override
    public void setBlockingExecutor(Executor executor) {
    }

    @Override
    public String getBoundAddress() {
        return this.connectURI;
    }

    @Override
    public DispatchQueue getDispatchQueue() {
        return this.dispatchQueue;
    }

    @Override
    public void setDispatchQueue(DispatchQueue dispatchQueue) {
        this.dispatchQueue = dispatchQueue;
    }

    @Override
    public void suspend() {
        this.acceptSource.suspend();
    }

    @Override
    public void resume() {
        this.acceptSource.resume();
    }

    @Override
    public void setTransportServerListener(TransportServerListener transportServerListener) {
        this.listener = transportServerListener;
    }

    @Override
    @Deprecated
    public void start(Runnable runnable) throws Exception {
        start((Task) new TaskWrapper(runnable));
    }

    @Override
    @Deprecated
    public void stop(Runnable runnable) throws Exception {
        stop((Task) new TaskWrapper(runnable));
    }

    @Override
    public void start(Task task) throws Exception {
        CustomDispatchSource<PipeTransport, LinkedList<PipeTransport>> customDispatchSourceCreateSource = Dispatch.createSource(EventAggregators.linkedList(), this.dispatchQueue);
        this.acceptSource = customDispatchSourceCreateSource;
        customDispatchSourceCreateSource.setEventHandler(new Task() {
            @Override
            public void run() {
                Iterator it = ((LinkedList) PipeTransportServer.this.acceptSource.getData()).iterator();
                while (it.hasNext()) {
                    try {
                        PipeTransportServer.this.listener.onAccept((PipeTransport) it.next());
                    } catch (Exception e) {
                        PipeTransportServer.this.listener.onAcceptError(e);
                    }
                }
            }
        });
        this.acceptSource.resume();
        if (task != null) {
            this.dispatchQueue.execute(task);
        }
    }

    @Override
    public void stop(Task task) throws Exception {
        PipeTransportRegistry.unbind(this);
        this.acceptSource.setCancelHandler(task);
        this.acceptSource.cancel();
    }

    public void setConnectURI(String str) {
        this.connectURI = str;
    }

    public void setName(String str) {
        this.name = str;
    }

    public String getName() {
        return this.name;
    }

    public PipeTransport connect() {
        String str = this.connectURI.toString() + "#" + this.connectionCounter.incrementAndGet();
        PipeTransport pipeTransportCreateClientTransport = createClientTransport();
        PipeTransport pipeTransportCreateServerTransport = createServerTransport();
        pipeTransportCreateClientTransport.peer = pipeTransportCreateServerTransport;
        pipeTransportCreateServerTransport.peer = pipeTransportCreateClientTransport;
        pipeTransportCreateClientTransport.setRemoteAddress(str);
        pipeTransportCreateServerTransport.setRemoteAddress(str);
        pipeTransportCreateServerTransport.setMarshal(this.marshal);
        this.acceptSource.merge(pipeTransportCreateServerTransport);
        return pipeTransportCreateClientTransport;
    }

    protected PipeTransport createClientTransport() {
        return new PipeTransport(this);
    }

    protected PipeTransport createServerTransport() {
        return new PipeTransport(this);
    }

    public boolean isMarshal() {
        return this.marshal;
    }

    public void setMarshal(boolean z) {
        this.marshal = z;
    }
}
