local BattleFieldMainSign = BaseClass("BattleFieldMainSign", UIAsyncContainer)
local base = UIAsyncContainer
local SignItem = require("UI.BattleFieldBase.MainSign.BattleFieldMainSignItem")
local PREFAB_ARBITER_SKILL = "Assets/Main/Prefabs/UI/BF_Epidemic/Battle/SignArbiterSkill.prefab"
local CLS_ARBITER_SKILL = "UI.LWMainEpidemicZoneUI.Component.SignArbiterSkill"
local PREFAB_ACHIEVEMENT = "Assets/Main/Prefabs/UI/ActivityCenter/WinterStorm/S0/BattleSignAchievementCell.prefab"
local CLS_ACHIEVEMENT = "UI.LWMainWinterStormUI.Component.BattleSignAchievementCell"

function BattleFieldMainSign:OnCreate()
  base.OnCreate(self)
  self.itemObjs = {}
  self.curOrderCnt = 2
  self.logPopCnt = 0
  self.baList = {}
  self.theItem = self.transform:Find("Item").gameObject
  self.theItem:GameObjectCreatePool()
  self.theItem:SetActive(false)
end

function BattleFieldMainSign:OnDestroy()
  self:HideArbiter()
  self:HideBattleAchievement()
  self.theItem:GameObjectRecycleAll()
  self.theItem = nil
  self:RemoveComponents(SignItem)
  self.itemObjs = nil
  self.logPopCnt = 0
  self.baList = nil
  self.compBA = nil
  self.compAS = nil
  self.arbiterRefreshFunc = nil
  base.OnDestroy(self)
end

function BattleFieldMainSign:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.EpidemicBattleSkillArbiter, self.RefreshArbiter)
  self:AddUIListener(EventId.BattleFieldPingAdd, self.OnOrderNotify)
  self:AddUIListener(EventId.WinterStormBattleAchievementNew, self.OnBattleAchievement)
end

function BattleFieldMainSign:OnRemoveListener()
  self:RemoveUIListener(EventId.EpidemicBattleSkillArbiter, self.RefreshArbiter)
  self:RemoveUIListener(EventId.BattleFieldPingAdd, self.OnOrderNotify)
  self:RemoveUIListener(EventId.WinterStormBattleAchievementNew, self.OnBattleAchievement)
  base.OnRemoveListener(self)
end

function BattleFieldMainSign:UpdateData()
  self:RefreshArbiter()
end

function BattleFieldMainSign:RemoveOneItem(obj)
  if IsNull(obj) then
    return
  end
  local name = obj.name
  for i, v in ipairs(self.itemObjs) do
    if v.name == name then
      obj:GameObjectRecycle()
      self:RemoveComponent(name, SignItem)
      table.remove(self.itemObjs, i)
      break
    end
  end
end

function BattleFieldMainSign:OnOrderNotify(order)
  local showCnt = self.curOrderCnt
  if #self.itemObjs == showCnt then
    self:RemoveOneItem(self.itemObjs[1])
  end
  local obj = self.theItem:GameObjectSpawn(self.transform)
  local key = "item" .. self.logPopCnt
  obj.name = key
  self.logPopCnt = self.logPopCnt + 1
  table.insert(self.itemObjs, obj)
  local item = self:AddComponent(SignItem, key)
  item:SetActive(true)
  item:ReInit(order)
  item:PlayAnim(function()
    self:RemoveOneItem(obj)
  end)
end

function BattleFieldMainSign:HideArbiter()
  if self.arbiterDelay then
    self.arbiterDelay:Stop()
    self.arbiterDelay = nil
  end
  if self.compAS then
    self.compAS:SetActive(false)
  end
  self.curOrderCnt = 2
end

function BattleFieldMainSign:RefreshArbiter()
  if not BattleFieldUtil.InBattleField(BattleFieldType.EpidemicZone) then
    return
  end
  local ActMgr = DataCenter.ActEpidemicZoneManager
  local battleInfo = ActMgr:GetBattleInfo()
  local eTime = battleInfo.arbiterSkillEndTime
  local remainTime = (eTime - UITimeManager:GetInstance():GetServerTime()) / 1000
  local uid = battleInfo.arbiterUid
  local bPlaying = not string.IsNullOrEmpty(uid) and 3 < remainTime
  if not bPlaying then
    self:HideArbiter()
    return
  end
  if self.compAS == nil then
    if self.arbiterRefreshFunc == nil then
      self.arbiterRefreshFunc = BindCallback(self, self.RefreshArbiter)
    end
    self.compAS = self:LoadComponentAsync(CLS_ARBITER_SKILL, PREFAB_ARBITER_SKILL, self, self.arbiterRefreshFunc)
    return
  end
  if not self.compAS:AsyncLoadDone() then
    return
  end
  self.compAS:SetActive(true)
  self.compAS:SetInfo(uid)
  if self.arbiterDelay then
    self.arbiterDelay:Stop()
    self.arbiterDelay = nil
  end
  self.arbiterDelay = TimerManager:GetInstance():DelayInvoke(function()
    self:HideArbiter()
  end, 3)
  self.curOrderCnt = 1
  if #self.itemObjs > self.curOrderCnt then
    self:RemoveOneItem(self.itemObjs[1])
  end
end

local function SortBA(a, b)
  if a.priority ~= b.priority then
    return a.priority < b.priority
  end
  return a.id < b.id
end

function BattleFieldMainSign:OnBattleAchievement(info)
  if not BattleFieldUtil.InBattleField(BattleFieldType.WinterStorm) then
    return
  end
  if info ~= nil then
    info.priority = LocalController:instance():getIntValue(TableName.LW_BattleField_Achievement, info.id, "priority", 0)
    table.insert(self.baList, info)
    if #self.baList > 1 then
      table.sort(self.baList, SortBA)
    end
  end
  if self.compBA then
    self:CheckPlayBattleAchievement()
    return
  end
  self.compBA = self:LoadComponentAsync(CLS_ACHIEVEMENT, PREFAB_ACHIEVEMENT, self, function()
    self:CheckPlayBattleAchievement()
  end)
end

function BattleFieldMainSign:CheckPlayBattleAchievement()
  if self.compBA == nil or self.delayBA ~= nil or not self.compBA:AsyncLoadDone() then
    return
  end
  local info = self.baList[1]
  if info == nil then
    self:HideBattleAchievement()
    return
  end
  local left = self.compBA:CheckLeftMin()
  if 0 <= left then
    table.remove(self.baList, 1)
    self.compBA:SetData(info)
    self.curOrderCnt = 1
    if #self.itemObjs > self.curOrderCnt then
      self:RemoveOneItem(self.itemObjs[1])
    end
    return
  end
  self.delayBA = TimerManager:GetInstance():DelayInvoke(function()
    self.delayBA = nil
    self:CheckPlayBattleAchievement()
  end, left * -1)
end

function BattleFieldMainSign:HideBattleAchievement()
  if self.delayBA ~= nil then
    self.delayBA:Stop()
    self.delayBA = nil
  end
  if self.compBA ~= nil then
    self.compBA:SetData(nil)
  end
  self.curOrderCnt = 2
end

return BattleFieldMainSign
