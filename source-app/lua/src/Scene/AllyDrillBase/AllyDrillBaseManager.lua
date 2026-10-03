local AllyDrillBaseManager = BaseClass("AllyDrillBaseManager")
local DrillBase = require("Scene.AllyDrillBase.AllyDrillBase")

function AllyDrillBaseManager:__init(owner)
  self.allBase = {}
  self.needShowCreateEffectUuid = nil
  self.moveBase = nil
  self:AddListener()
end

function AllyDrillBaseManager:__delete()
  self.needShowCreateEffectUuid = nil
  self:RemoveListener()
  self:Destroy()
end

function AllyDrillBaseManager:Destroy()
  if self.updateSecTimer then
    self.updateSecTimer:Stop()
    self.updateSecTimer = nil
  end
  for _, v in pairs(self.allBase) do
    v:Destroy()
  end
  self:RemoveMoveDrillBase()
  self.allBase = {}
end

function AllyDrillBaseManager:EnterWorld()
  if self.updateSecTimer == nil then
    self.updateSecTimer = TimerManager:GetInstance():GetTimer(1, self.OnUpdateSec, self, false, false, false)
    self.updateSecTimer:Start()
  end
end

function AllyDrillBaseManager:ExitWorld()
  self:Destroy()
end

function AllyDrillBaseManager:AddListener()
  function self.FuncRefreshMyDrillView(stage)
    self:RefreshMyDrillView(stage)
  end
  
  EventManager:GetInstance():AddListener(EventId.OnAllyDrillStageChange, self.FuncRefreshMyDrillView)
  
  function self.FuncOnAllyDrillBaseCreate(uuid)
    self:OnAllyDrillBaseCreate(uuid)
  end
  
  EventManager:GetInstance():AddListener(EventId.OnAllyDrillBaseCreate, self.FuncOnAllyDrillBaseCreate)
  
  function self.FuncOnDonateSuccess(msg)
    self:OnDonateSuccess(msg)
  end
  
  EventManager:GetInstance():AddListener(EventId.OnAllyDrillDonateSuccess, self.FuncOnDonateSuccess)
  
  function self.OnBossAttack(matchUUID)
    self:RefreshAllyBaseWhenBossAttack(matchUUID)
  end
  
  EventManager:GetInstance():AddListener(EventId.ActBossAttack, self.OnBossAttack)
  EventManager:GetInstance():AddListenerWithSelf(EventId.OnAllyDrillInfoRefresh, self.OnAllyDrillInfoRefresh, self)
end

function AllyDrillBaseManager:RemoveListener()
  EventManager:GetInstance():RemoveListener(EventId.OnAllyDrillStageChange, self.FuncRefreshMyDrillView)
  EventManager:GetInstance():RemoveListener(EventId.OnAllyDrillBaseCreate, self.FuncOnAllyDrillBaseCreate)
  EventManager:GetInstance():RemoveListener(EventId.OnAllyDrillDonateSuccess, self.FuncOnDonateSuccess)
  EventManager:GetInstance():RemoveListener(EventId.ActBossAttack, self.OnBossAttack)
  EventManager:GetInstance():RemoveListener(EventId.OnAllyDrillInfoRefresh, self.OnAllyDrillInfoRefresh)
end

function AllyDrillBaseManager:OnUpdateSec()
  for _, v in pairs(self.allBase) do
    v:OnUpdateSec()
  end
  if self.moveBase then
    self.moveBase:OnUpdateSec()
  end
end

function AllyDrillBaseManager:CreateAllyDrillBase(march, transform)
  local uuid = march.uuid
  local drillBase = self.allBase[uuid]
  if drillBase then
    drillBase:Refresh(march, transform)
  else
    self.allBase[uuid] = DrillBase.New(march, transform)
  end
end

function AllyDrillBaseManager:RemoveAllyDrillBase(uuid)
  local drillBase = self.allBase[uuid]
  if drillBase then
    drillBase:Destroy()
    self.allBase[uuid] = nil
  end
end

function AllyDrillBaseManager:RefreshAllyDrillBase(march)
  local drillBase = self.allBase[march.uuid]
  if drillBase then
    drillBase:RefreshBossInfo(march.allianceBossInfo or march.allianceBoss)
  end
end

function AllyDrillBaseManager:GetDrillBase(uuid)
  return self.allBase[uuid]
end

function AllyDrillBaseManager:RefreshAllyBaseWhenBossAttack(marchUUid)
  local march = CS.SceneManager.World:GetMarch(marchUUid)
  for i, v in pairs(self.allBase) do
    v:CheckDoAttack(march)
  end
end

function AllyDrillBaseManager:DoReactionWhenSingleMarchChange(marchUUid)
  local march = CS.SceneManager.World:GetMarch(marchUUid)
  for i, v in pairs(self.allBase) do
    v:DoReactionWhenSingleMarchChange(march)
  end
end

function AllyDrillBaseManager:IsOccupied(x, y)
  for _, v in pairs(self.allBase) do
    if v:IsOccupied(x, y) then
      return true
    end
  end
  return false
end

function AllyDrillBaseManager:RefreshMyDrillView(stage)
  for _, v in pairs(self.allBase) do
    if v:IsMine() then
      v:RefreshByActInfo(stage)
      break
    end
  end
end

function AllyDrillBaseManager:OnAllyDrillBaseCreate(uuid)
  local drillBase = self.allBase[uuid]
  if drillBase then
    drillBase:ShowCreateEffect()
  else
    self.needShowCreateEffectUuid = uuid
  end
end

function AllyDrillBaseManager:OnDonateSuccess(msg)
  for key, value in pairs(self.allBase) do
    local isMine = value.marchInfo.allianceUid == LuaEntry.Player.allianceId
    if isMine then
      value:OnDonateSuccess()
      break
    end
  end
end

function AllyDrillBaseManager:CheckNeedShowCreateEffect(uuid)
  return uuid == self.needShowCreateEffectUuid
end

function AllyDrillBaseManager:ClearNeedShowCreateEffect()
  self.needShowCreateEffectUuid = nil
end

function AllyDrillBaseManager:CreateMoveDrillBase(march, transform)
  self:RemoveMoveDrillBase()
  self.moveBase = DrillBase.New(march, transform, true)
end

function AllyDrillBaseManager:RemoveMoveDrillBase()
  if self.moveBase then
    self.moveBase:Destroy()
    self.moveBase = nil
  end
end

function AllyDrillBaseManager:CheckDrillBaseIsMove(uuid)
  if self.moveBase and self.moveBase.uuid == uuid then
    return true
  end
  return false
end

function AllyDrillBaseManager:ShowSkillEffect(msg)
  for key, value in pairs(self.allBase) do
    if value.marchInfo.allianceUid == msg.allianceId then
      value:ShowSkillEffect(msg.type or 0)
      break
    end
  end
end

function AllyDrillBaseManager:ShowCritTipEffect(msg)
  if msg == nil or msg.arr and #msg.arr == 0 then
    return
  end
  local alId = msg.arr[1].allianceId
  for key, value in pairs(self.allBase) do
    if value.marchInfo.allianceUid == alId then
      value:ShowCritTipEffect(msg.arr)
      break
    end
  end
end

function AllyDrillBaseManager:RefreshRoadHogDamage(msg)
  for _, v in pairs(self.allBase) do
    if v:IsMine() and v:IsRoadHog() then
      v:RefreshRoadHogDamage(msg)
      break
    end
  end
end

function AllyDrillBaseManager:OnAllyDrillInfoRefresh(msg)
  for _, v in pairs(self.allBase) do
    if v:IsMine() and v:IsRoadHog() then
      v:OnAllyDrillInfoRefresh(msg)
      break
    end
  end
end

function AllyDrillBaseManager:PlayRoadHogBornAnim()
  for _, v in pairs(self.allBase) do
    if v:IsMine() and v:IsRoadHog() then
      v:PlayRoadHogBornAnim()
      break
    end
  end
end

return AllyDrillBaseManager
