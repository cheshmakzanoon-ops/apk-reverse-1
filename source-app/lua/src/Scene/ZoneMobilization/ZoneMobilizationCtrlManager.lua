local ZoneMobilizationCtrlManager = BaseClass("ZoneMobilizationCtrlManager")
local ZoneMobilizationModelCtrl = require("Scene.ZoneMobilization.ZoneMobilizationModelCtrl")
local ZMBossActionCtrl = require("Scene.ZoneMobilization.ZMBoss.ZMBossActionCtrl")
local ZMBuildingCtrl = require("Scene.ZoneMobilization.ZMBuilding.ZMBuildingCtrl")
local DataCenter = _ENV.DataCenter

local function __init(self, owner)
  self.bossActionCtrl = nil
  self.buildingCtrl = nil
  self.movingModelCtrl = nil
  self.bossUuid = 0
  self.buildingUuid = 0
  self.updateTimer = nil
  self.updateSecTimer = nil
  self.markCreate = nil
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
  if self.bossActionCtrl then
    self.bossActionCtrl:Delete()
  end
  self.bossActionCtrl = nil
  if self.buildingCtrl then
    self.buildingCtrl:Delete()
  end
  self.buildingCtrl = nil
  self.bossUuid = nil
  self.buildingUuid = nil
  self.markCreate = nil
end

local function EnterWorld(self)
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
  EventManager:GetInstance():AddListener(EventId.ZoneMobilizationBossAttack, self.OnBossAttack)
  EventManager:GetInstance():AddListener(EventId.ZoneMobilizationBossHpLost, self.OnBossHpLost)
  EventManager:GetInstance():AddListener(EventId.OnZoneMobilizationBossDeadOrRun, self.OnBossDeadOrRun)
  EventManager:GetInstance():AddListener(EventId.ZoneMobilizationDonateSuccess, self.OnBuildDonatedSuccess)
end

local function RemoveListeners(self)
  EventManager:GetInstance():RemoveListener(EventId.ZoneMobilizationBossAttack, self.OnBossAttack)
  EventManager:GetInstance():RemoveListener(EventId.ZoneMobilizationBossHpLost, self.OnBossHpLost)
  EventManager:GetInstance():RemoveListener(EventId.OnZoneMobilizationBossDeadOrRun, self.OnBossDeadOrRun)
  EventManager:GetInstance():RemoveListener(EventId.ZoneMobilizationDonateSuccess, self.OnBuildDonatedSuccess)
end

local function OnUpdateSec(self)
  if self.bossActionCtrl then
    self.bossActionCtrl:OnUpdateSec()
  end
end

local function OnUpdate(self)
  local deltaTime = Time.deltaTime
  if self.bossActionCtrl then
    self.bossActionCtrl:OnUpdate(deltaTime)
  end
  if self.buildingCtrl then
    self.buildingCtrl:OnUpdate(deltaTime)
  end
end

local function CreateBossActionCtrl(self, march, transform)
  if march and transform then
    if self.bossActionCtrl then
      self.bossActionCtrl:Delete()
    end
    self.bossUuid = march.uuid
    self.bossActionCtrl = ZMBossActionCtrl.New(march, transform)
  end
end

local function RemoveBossActionCtrl(self, uuid)
  if uuid and uuid == self.bossUuid and self.bossActionCtrl then
    self.bossActionCtrl:Delete()
    self.bossActionCtrl = nil
    self.bossUuid = nil
  end
end

local function RefreshBossActionCtrl(self, march)
  if march and self.bossUuid == march.uuid and self.bossActionCtrl then
    self.bossActionCtrl:RefreshMarchInfo(march)
    EventManager:GetInstance():Broadcast(EventId.OnZoneMobilizationBossMarchInfoChanged, march.uuid)
  end
end

local function GetBossActionCtrl(self, uuid)
  if self.bossUuid == uuid then
    return self.bossActionCtrl
  end
end

local function CreateBuildingCtrl(self, uuid, transform)
  if uuid and transform then
    if self.buildingCtrl then
      self.buildingCtrl:Refresh(uuid, transform)
    else
      self.buildingCtrl = ZMBuildingCtrl.New(uuid, transform, self.markCreate)
      self.markCreate = nil
      self.buildingUuid = uuid
    end
  end
end

local function RemoveBuildingCtrl(self, uuid)
  if uuid and uuid == self.buildingUuid and self.buildingCtrl then
    self.buildingCtrl:Delete()
    self.buildingCtrl = nil
    self.buildingUuid = nil
  end
end

local function OnBossAttack(msg)
  local self = DataCenter.ZoneMobilizationCtrlManager
  local uuid = msg and msg.uuid
  if uuid == self.bossUuid and self.bossActionCtrl then
    self.bossActionCtrl:ChangeAttackState()
  end
end

local function OnBossHpLost(t)
  local self = DataCenter.ZoneMobilizationCtrlManager
  if t and t.uuid and t.uuid == self.bossUuid and self.bossActionCtrl then
    self.bossActionCtrl:OnHurt(t)
  end
end

local function OnZoneMobilizationPutFinished(self, action)
  if action then
    if action == 0 then
      if self.buildingCtrl then
        self.buildingCtrl:ChangeToBornState()
      end
      self.markCreate = action
    elseif action == 1 and self.bossActionCtrl then
      self.bossActionCtrl:ChangeToBornState()
    end
  end
end

local function OnBossDeadOrRun(t)
  local self = DataCenter.ZoneMobilizationCtrlManager
  if t and t.uuid and t.uuid == self.bossUuid and self.bossActionCtrl then
    self.bossActionCtrl:OnBossDeadOrRun(t.type)
  end
end

local function OnWorldPointInfoChanged(self, uuid)
  if uuid and uuid == self.buildingUuid and self.buildingCtrl then
    self.buildingCtrl:OnWorldPointInfoChanged(uuid)
  end
end

local function OnBuildDonatedSuccess(message)
  local self = DataCenter.ZoneMobilizationCtrlManager
  if message and self.buildingCtrl then
    self.buildingCtrl:OnBuildDonatedSuccess(message)
  end
end

local function CreateMovingModel(self, transform)
  self:RemoveMovingModel()
  self.movingModelCtrl = ZoneMobilizationModelCtrl.New(nil, transform)
end

local function RemoveMovingModel(self)
  if self.movingModelCtrl then
    self.movingModelCtrl:Delete()
    self.movingModelCtrl = nil
  end
end

ZoneMobilizationCtrlManager.__init = __init
ZoneMobilizationCtrlManager.__delete = __delete
ZoneMobilizationCtrlManager.Dispose = Dispose
ZoneMobilizationCtrlManager.EnterWorld = EnterWorld
ZoneMobilizationCtrlManager.ExitWorld = ExitWorld
ZoneMobilizationCtrlManager.AddListeners = AddListeners
ZoneMobilizationCtrlManager.RemoveListeners = RemoveListeners
ZoneMobilizationCtrlManager.OnUpdateSec = OnUpdateSec
ZoneMobilizationCtrlManager.OnUpdate = OnUpdate
ZoneMobilizationCtrlManager.CreateBossActionCtrl = CreateBossActionCtrl
ZoneMobilizationCtrlManager.RemoveBossActionCtrl = RemoveBossActionCtrl
ZoneMobilizationCtrlManager.RefreshBossActionCtrl = RefreshBossActionCtrl
ZoneMobilizationCtrlManager.GetBossActionCtrl = GetBossActionCtrl
ZoneMobilizationCtrlManager.CreateMovingModel = CreateMovingModel
ZoneMobilizationCtrlManager.RemoveMovingModel = RemoveMovingModel
ZoneMobilizationCtrlManager.OnBossAttack = OnBossAttack
ZoneMobilizationCtrlManager.OnBossHpLost = OnBossHpLost
ZoneMobilizationCtrlManager.OnBossDeadOrRun = OnBossDeadOrRun
ZoneMobilizationCtrlManager.CreateBuildingCtrl = CreateBuildingCtrl
ZoneMobilizationCtrlManager.RemoveBuildingCtrl = RemoveBuildingCtrl
ZoneMobilizationCtrlManager.OnWorldPointInfoChanged = OnWorldPointInfoChanged
ZoneMobilizationCtrlManager.OnBuildDonatedSuccess = OnBuildDonatedSuccess
ZoneMobilizationCtrlManager.OnZoneMobilizationPutFinished = OnZoneMobilizationPutFinished
return ZoneMobilizationCtrlManager
