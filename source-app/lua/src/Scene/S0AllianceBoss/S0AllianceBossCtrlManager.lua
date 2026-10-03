local S0AllianceBossCtrlManager = BaseClass("S0AllianceBossCtrlManager", CEventable)
local S0AllianceBossActionCtrl = require("Scene.S0AllianceBoss.S0AllianceBossActionCtrl")
local S0AllianceBossBuildActionCtrl = require("Scene.S0AllianceBoss.Building.S0AllianceBossBuildActionCtrl")

local function __init(self, owner)
  self.bossActionCtrls = {}
  self.buildingCtrls = {}
  self.movingModelCtrl = nil
  self.updateTimer = nil
  self.updateSecTimer = nil
  self:AddListeners()
end

local function __delete(self)
  self:RemoveListeners()
  self:Dispose()
end

local function Dispose(self)
  if self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
  if self.updateSecTimer then
    self.updateSecTimer:Stop()
    self.updateSecTimer = nil
  end
  if self.bossActionCtrls then
    for _, v in pairs(self.bossActionCtrls) do
      v:Destroy()
    end
    self.bossActionCtrls = nil
  end
  if self.buildingCtrls then
    for _, v in pairs(self.buildingCtrls) do
      v:Destroy()
    end
    self.buildingCtrls = nil
  end
end

local function EnterWorld(self)
  self.bossActionCtrls = {}
  self.buildingCtrls = {}
  if self.updateTimer == nil then
    function self.updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
  if self.updateSecTimer == nil then
    self.updateSecTimer = TimerManager:GetInstance():GetTimer(1, self.OnUpdateSec, self, false, false, false)
    self.updateSecTimer:Start()
  end
end

local function ExitWorld(self)
  self:Dispose()
end

local function AddListeners(self)
  self:RegisterEvent(EventId.OnS0AllianceBossDonateSuccess, self.OnBuildDonatedSuccess)
  self:RegisterEvent(EventId.OnS0AllianceBossMarchInfoChanged, self.OnPlayerDamageUpdate)
end

local function RemoveListeners(self)
  self:UnregisterEvent(EventId.OnS0AllianceBossDonateSuccess)
  self:UnregisterEvent(EventId.OnS0AllianceBossMarchInfoChanged)
end

local function OnUpdateSec(self)
  if self.bossActionCtrls then
    for _, v in pairs(self.bossActionCtrls) do
      v:OnUpdateSec()
    end
  end
end

local function OnUpdate(self)
  if self.bossActionCtrls then
    for _, v in pairs(self.bossActionCtrls) do
      v:OnUpdate()
    end
  end
end

local function CreateBossActionCtrl(self, march, transform)
  if march and transform then
    local uuid = march.uuid
    local ctrl = self.bossActionCtrls[uuid]
    if ctrl then
      ctrl:Destroy()
    else
      self.bossActionCtrls[uuid] = S0AllianceBossActionCtrl.New(march, transform)
    end
  end
end

local function RemoveBossActionCtrl(self, uuid)
  if uuid then
    local ctrl = self.bossActionCtrls[uuid]
    if ctrl then
      ctrl:Destroy()
      self.bossActionCtrls[uuid] = nil
    end
  end
end

local function RefreshBossActionCtrl(self, march)
  if march then
    local ctrl = self.bossActionCtrls[march.uuid]
    if ctrl then
      ctrl:RefreshMarchInfo(march)
      EventManager:GetInstance():Broadcast(EventId.OnS0AllianceBossMarchInfoChanged, march.uuid)
    end
  end
end

local function GetBossActionCtrl(self, uuid)
  return uuid and self.bossActionCtrls[uuid]
end

local function CreateBuildingCtrl(self, uuid, transform)
  if uuid and transform then
    local ctrl = self.buildingCtrls[uuid]
    if ctrl then
      ctrl:Refresh(uuid, transform)
    else
      self.buildingCtrls[uuid] = S0AllianceBossBuildActionCtrl.New(uuid, transform)
    end
  end
end

local function RemoveBuildingCtrl(self, uuid)
  if uuid then
    local ctrl = self.buildingCtrls[uuid]
    if ctrl then
      ctrl:Destroy()
      self.buildingCtrls[uuid] = nil
    end
  end
end

local function OnBuildDonatedSuccess(self, uuid)
  if uuid then
    local ctrl = self.buildingCtrls[uuid]
    if ctrl then
      ctrl:OnBuildDonatedSuccess(uuid)
    end
  end
end

local function OnPlayerDamageUpdate(self, uuid)
  if uuid then
    local ctrl = self.bossActionCtrls[uuid]
    if ctrl then
      ctrl:RefreshHpSlider()
    end
  end
end

local function SetBuildingState(self, uuid, hide, cancel)
  if uuid then
    local ctrl = self.buildingCtrls[uuid]
    if ctrl then
      ctrl:SetBuildingState(hide, cancel)
    end
  end
end

local function SetBossState(self, uuid, hide, cancel)
  if uuid then
    local ctrl = self.bossActionCtrls[uuid]
    if ctrl then
      ctrl:SetBossState(hide, cancel)
    end
  end
end

S0AllianceBossCtrlManager.__init = __init
S0AllianceBossCtrlManager.__delete = __delete
S0AllianceBossCtrlManager.Dispose = Dispose
S0AllianceBossCtrlManager.EnterWorld = EnterWorld
S0AllianceBossCtrlManager.ExitWorld = ExitWorld
S0AllianceBossCtrlManager.AddListeners = AddListeners
S0AllianceBossCtrlManager.RemoveListeners = RemoveListeners
S0AllianceBossCtrlManager.OnUpdateSec = OnUpdateSec
S0AllianceBossCtrlManager.OnUpdate = OnUpdate
S0AllianceBossCtrlManager.CreateBossActionCtrl = CreateBossActionCtrl
S0AllianceBossCtrlManager.RemoveBossActionCtrl = RemoveBossActionCtrl
S0AllianceBossCtrlManager.RefreshBossActionCtrl = RefreshBossActionCtrl
S0AllianceBossCtrlManager.GetBossActionCtrl = GetBossActionCtrl
S0AllianceBossCtrlManager.CreateBuildingCtrl = CreateBuildingCtrl
S0AllianceBossCtrlManager.RemoveBuildingCtrl = RemoveBuildingCtrl
S0AllianceBossCtrlManager.OnBuildDonatedSuccess = OnBuildDonatedSuccess
S0AllianceBossCtrlManager.OnPlayerDamageUpdate = OnPlayerDamageUpdate
S0AllianceBossCtrlManager.SetBuildingState = SetBuildingState
S0AllianceBossCtrlManager.SetBossState = SetBossState
return S0AllianceBossCtrlManager
