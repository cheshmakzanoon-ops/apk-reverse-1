package net.aihelp.data.model.init;

import org.json.JSONObject;

public class PrivacyControlEntity {
    private int countryCode = 1;
    private int operator = 1;
    private int networkType = 1;
    private int deviceModel = 1;
    private int totalSpacePhone = 1;
    private int batteryStatus = 1;
    private int osVersion = 1;
    private int freeSpacePhone = 1;
    private int batteryPower = 1;
    private int applicationIdentifier = 1;
    private int applicationVersion = 1;
    private int applicationName = 1;
    private int serverId = 1;
    private int totalMemory = 1;
    private int availableMemory = 1;

    public boolean getCountryCode() {
        return this.countryCode == 1;
    }

    public boolean getOperator() {
        return this.operator == 1;
    }

    public boolean getNetworkType() {
        return this.networkType == 1;
    }

    public boolean getDeviceModel() {
        return this.deviceModel == 1;
    }

    public boolean getTotalSpacePhone() {
        return this.totalSpacePhone == 1;
    }

    public boolean getBatteryStatus() {
        return this.batteryStatus == 1;
    }

    public boolean getOsVersion() {
        return this.osVersion == 1;
    }

    public boolean getFreeSpacePhone() {
        return this.freeSpacePhone == 1;
    }

    public boolean getBatteryPower() {
        return this.batteryPower == 1;
    }

    public boolean getApplicationIdentifier() {
        return this.applicationIdentifier == 1;
    }

    public boolean getApplicationVersion() {
        return this.applicationVersion == 1;
    }

    public boolean getApplicationName() {
        return this.applicationName == 1;
    }

    public boolean getServerId() {
        return this.serverId == 1;
    }

    public boolean getAvailableMemory() {
        return this.availableMemory == 1;
    }

    public boolean getTotalMemory() {
        return this.totalMemory == 1;
    }

    public void setCountryCode(int i) {
        this.countryCode = i;
    }

    public void setOperator(int i) {
        this.operator = i;
    }

    public void setNetworkType(int i) {
        this.networkType = i;
    }

    public void setDeviceModel(int i) {
        this.deviceModel = i;
    }

    public void setTotalSpacePhone(int i) {
        this.totalSpacePhone = i;
    }

    public void setBatteryStatus(int i) {
        this.batteryStatus = i;
    }

    public void setOsVersion(int i) {
        this.osVersion = i;
    }

    public void setFreeSpacePhone(int i) {
        this.freeSpacePhone = i;
    }

    public void setBatteryPower(int i) {
        this.batteryPower = i;
    }

    public void setApplicationIdentifier(int i) {
        this.applicationIdentifier = i;
    }

    public void setApplicationVersion(int i) {
        this.applicationVersion = i;
    }

    public void setApplicationName(int i) {
        this.applicationName = i;
    }

    public void setServerId(int i) {
        this.serverId = i;
    }

    public void setTotalMemory(int i) {
        this.totalMemory = i;
    }

    public void setAvailableMemory(int i) {
        this.availableMemory = i;
    }

    public String toJsonString() {
        JSONObject jSONObject = new JSONObject();
        try {
            jSONObject.put("countryCode", this.countryCode);
            jSONObject.put("operator", this.operator);
            jSONObject.put("networkType", this.networkType);
            jSONObject.put("deviceModel", this.deviceModel);
            jSONObject.put("totalSpacePhone", this.totalSpacePhone);
            jSONObject.put("batteryStatus", this.batteryStatus);
            jSONObject.put("osVersion", this.osVersion);
            jSONObject.put("freeSpacePhone", this.freeSpacePhone);
            jSONObject.put("batteryPower", this.batteryPower);
            jSONObject.put("applicationIdentifier", this.applicationIdentifier);
            jSONObject.put("applicationVersion", this.applicationVersion);
            jSONObject.put("applicationName", this.applicationName);
            jSONObject.put("serverId", this.serverId);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return jSONObject.toString();
    }
}
