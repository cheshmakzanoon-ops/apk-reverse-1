local UIDisconnectView = BaseClass("UIDisconnectView", UIBaseView)
local base = UIBaseView
local wifi_path = "WifiCircleBg"

local function OnCreate(self)
  base.OnCreate(self)
  self.wifi = self.transform:Find(wifi_path)
end

local function OnDestroy(self)
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  Logger.LogInfo("[UIDisconnectView] Open")
  if CS.GameEntry.Network.IsConnected then
    Logger.LogInfo("[UIDisconnectView] Network.IsConnected = true")
    self.wifi.gameObject:SetActive(false)
    self.showLoadingTimer = TimerManager:GetInstance():GetTimer(2, self.OnShowLoading, self, true, false, false)
    self.showLoadingTimer:Start()
    self.ctrl:SendLoginInit()
  else
    Logger.LogInfo("[UIDisconnectView] Network.IsConnected = false")
    self.wifi.gameObject:SetActive(true)
    CS.ApplicationLaunch.Instance.Loading:ReConnect()
    self.reconnectTimer = TimerManager:GetInstance():GetTimer(10, self.OnReconnectTimeOut, self, true, false, false)
    self.reconnectTimer:Start()
  end
end

local function OnShowLoading(self)
  Logger.LogInfo("[UIDisconnectView] Force disconnect and retry")
  self.wifi.gameObject:SetActive(true)
  CS.ApplicationLaunch.Instance.Loading:ReConnect()
  self.gotoLoadingTimer = TimerManager:GetInstance():GetTimer(10, self.GotoLoadingView, self, true, false, false)
  self.gotoLoadingTimer:Start()
end

local function OnReconnectTimeOut(self)
  self:GotoLoadingView()
end

local function OnDisable(self)
  base.OnDisable(self)
  if self.showLoadingTimer ~= nil then
    self.showLoadingTimer:Stop()
    self.showLoadingTimer = nil
  end
  if self.gotoLoadingTimer ~= nil then
    self.gotoLoadingTimer:Stop()
    self.gotoLoadingTimer = nil
  end
  if self.reconnectTimer ~= nil then
    self.reconnectTimer:Stop()
    self.reconnectTimer = nil
  end
end

local function GotoLoadingView(self)
  Logger.LogInfo("[UIDisconnectView] Reload Game")
  self.ctrl:CloseSelf()
  CS.ApplicationLaunch.Instance:ReloadGame()
end

local function OnEventClose(self)
  Logger.LogInfo("[UIDisconnectView] Event close")
  self.ctrl:CloseSelf()
end

local function OnNetError(self)
  Logger.LogInfo("[UIDisconnectView] OnNetError")
  self:GotoLoadingView()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.Net_Connect_Error, self.OnNetError)
  self:AddUIListener(EventId.Net_Server_Status, self.OnNetError)
  self:AddUIListener(EventId.LoginInitError, self.OnNetError)
  self:AddUIListener(EventId.LoginCommandError, self.OnNetError)
  self:AddUIListener(EventId.CloseDisconnectView, self.OnEventClose)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.Net_Connect_Error, self.OnNetError)
  self:RemoveUIListener(EventId.Net_Server_Status, self.OnNetError)
  self:RemoveUIListener(EventId.LoginInitError, self.OnNetError)
  self:RemoveUIListener(EventId.LoginCommandError, self.OnNetError)
  self:RemoveUIListener(EventId.CloseDisconnectView, self.OnEventClose)
end

UIDisconnectView.OnCreate = OnCreate
UIDisconnectView.OnDestroy = OnDestroy
UIDisconnectView.OnEnable = OnEnable
UIDisconnectView.OnDisable = OnDisable
UIDisconnectView.OnAddListener = OnAddListener
UIDisconnectView.OnRemoveListener = OnRemoveListener
UIDisconnectView.OnEventClose = OnEventClose
UIDisconnectView.GotoLoadingView = GotoLoadingView
UIDisconnectView.OnNetError = OnNetError
UIDisconnectView.OnShowLoading = OnShowLoading
UIDisconnectView.OnReconnectTimeOut = OnReconnectTimeOut
return UIDisconnectView
