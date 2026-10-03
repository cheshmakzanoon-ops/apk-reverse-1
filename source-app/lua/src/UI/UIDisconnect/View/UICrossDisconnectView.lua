local UICrossDisconnectView = BaseClass("UICrossDisconnectView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local raycast_path = "GameObject"
local wifi_path = "WifiCircleBg"

local function OnCreate(self)
  base.OnCreate(self)
  self.raycast = self.transform:Find(raycast_path)
  self.wifi = self.transform:Find(wifi_path)
end

local function OnDestroy(self)
  if self.reconnectTimer ~= nil then
    self.reconnectTimer:Stop()
    self.reconnectTimer = nil
  end
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  local _, errorCode = self:GetUserData()
  self.errorCode = errorCode
  Logger.LogInfo("NetworkCross \230\137\147\229\188\128\230\150\173\231\186\191\233\135\141\232\191\158\231\149\140\233\157\162 : " .. LuaEntry.Player:GetCurServerId())
  if CS.GameEntry.NetworkCross.BConnected and CS.GameEntry.NetworkCross.Logined then
    Logger.LogInfo("NetworkCross \231\189\145\231\187\156\232\191\152\230\152\175\232\191\158\231\157\128\231\154\132\239\188\129\239\188\129\239\188\129")
    self:CloseView()
  else
    self.raycast.gameObject:SetActive(false)
    self.wifi.gameObject:SetActive(false)
    Logger.LogInfo("NetworkCross \231\189\145\231\187\156\229\183\178\231\187\143\230\150\173\229\188\128\228\186\134\239\188\129\239\188\129\239\188\129errorCode=" .. errorCode)
    if BattleFieldUtil.BTestJump() then
      CS.GameEntry.NetworkCross:RemoveConnect()
      self:CloseView()
      return
    end
    self.wifi.gameObject:SetActive(true)
    self.reconnectTimer = TimerManager:GetInstance():GetTimer(10, self.OnShowWifi, self, true, false, false)
    self.reconnectTimer:Start()
  end
end

local function DoBack()
  if BattleFieldUtil.InBattleField() then
    CrossServerUtil.OnBackSelfServerFromDragonWorld()
    DataCenter.AllianceWarDataManager:CleanDragonWar()
    DataCenter.WorldMarchDataManager:CleanDragonWar()
    SceneUtils.ChangeToCity(function()
      LuaEntry.Player:SetBattleFieldPointId(-1)
    end)
  elseif not LuaEntry.Player:IsInSelfServer() and UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIMoveCity) then
    local pointId = LuaEntry.Player:GetMainWorldPos()
    local position = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
    GoToUtil.GotoWorldPos(position, MoveCityCameraHeight, nil, function()
      GoToUtil.CloseAllWindows()
      CrossServerUtil.SetLastJumpToParam(nil)
    end, LuaEntry.Player:GetSelfServerId())
  else
    CrossServerUtil.BackToSrcServer()
  end
end

local function OnShowWifi(self)
  self.raycast.gameObject:SetActive(true)
  self.wifi.gameObject:SetActive(true)
  self.reconnectTimer = TimerManager:GetInstance():GetTimer(10, self.OnReconnectTimeOut, self, true, false, false)
  self.reconnectTimer:Start()
end

local function OnReconnectTimeOut(self)
  self:CloseView()
  CS.GameEntry.NetworkCross:RemoveConnect()
  local msg = Localization:GetString("Desert_strom_tips1062", LuaEntry.Player:GetSelfServerId())
  if not string.IsNullOrEmpty(self.errorCode) then
    msg = string.format("%s(%s)", msg, self.errorCode)
  end
  UIUtil.ShowMessage(msg, 2, 129091, GameDialogDefine.BACK, function()
    CS.GameEntry.NetworkCross:DoConnect()
  end, DoBack, DoBack)
end

local function OnDisable(self)
  if self.reconnectTimer ~= nil then
    self.reconnectTimer:Stop()
    self.reconnectTimer = nil
  end
  base.OnDisable(self)
end

local function OnEventClose(self)
  Logger.Log("NetworkCross onEventClose \229\133\179\233\151\173\230\150\173\231\186\191\233\135\141\232\191\158\231\149\140\233\157\162")
  self:CloseView()
end

local function CloseView(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICrossDisconnect)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.CloseCrossDisconnectView, self.OnEventClose)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.CloseCrossDisconnectView, self.OnEventClose)
end

UICrossDisconnectView.OnCreate = OnCreate
UICrossDisconnectView.OnDestroy = OnDestroy
UICrossDisconnectView.OnEnable = OnEnable
UICrossDisconnectView.OnDisable = OnDisable
UICrossDisconnectView.OnAddListener = OnAddListener
UICrossDisconnectView.OnRemoveListener = OnRemoveListener
UICrossDisconnectView.OnEventClose = OnEventClose
UICrossDisconnectView.CloseView = CloseView
UICrossDisconnectView.OnReconnectTimeOut = OnReconnectTimeOut
UICrossDisconnectView.OnShowWifi = OnShowWifi
return UICrossDisconnectView
