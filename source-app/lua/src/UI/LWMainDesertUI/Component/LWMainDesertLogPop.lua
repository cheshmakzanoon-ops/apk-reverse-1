local LWMainDesertLogPop = BaseClass("LWMainDesertLogPop", UIBaseContainer)
local base = UIBaseContainer
local LWMainDesertLogPopItem = require("UI.LWMainDesertUI.Component.LWMainDesertLogPopItem")

function LWMainDesertLogPop:OnCreate()
  base.OnCreate(self)
  self.logPopCnt = 0
  self.itemObjs = {}
  self.battleBehaviors = {}
  self.timers = {}
  self.theItem = self.transform:Find("Item").gameObject
  self.theItem:GameObjectCreatePool()
end

function LWMainDesertLogPop:OnDestroy()
  self.logPopCnt = 0
  self.battleBehaviors = {}
  self.theItem:GameObjectRecycleAll()
  self.theItem = nil
  self:RemoveComponents(LWMainDesertLogPopItem)
  base.OnDestroy(self)
end

function LWMainDesertLogPop:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DragonBattleBehaviorNotify, self.OnBehaviorNotify)
end

function LWMainDesertLogPop:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.DragonBattleBehaviorNotify, self.OnBehaviorNotify)
end

local function SortBattleBehaviors(a, b)
  local vA = a.leftUid
  local vB = b.leftUid
  if vA ~= vB then
    local myUid = LuaEntry.Player:GetUid()
    if vA == myUid then
      return true
    end
    if vB == myUid then
      return false
    end
  end
  vA = a.leftScore
  vB = b.leftScore
  if vA ~= vB then
    return vA > vB
  end
end

function LWMainDesertLogPop:OnBehaviorNotify(data)
  table.insert(self.battleBehaviors, data)
  table.sort(self.battleBehaviors, SortBattleBehaviors)
  self:UpdateLogPop()
end

function LWMainDesertLogPop:PopOnLogPop()
  if table.IsNullOrEmpty(self.battleBehaviors) then
    return nil
  end
  local logData = table.remove(self.battleBehaviors, 1)
  return logData
end

function LWMainDesertLogPop:UpdateLogPop()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local curNum = 0
  local checkTime = 2000
  if self.lastPopTime1 == nil or checkTime < curTime - self.lastPopTime1 then
    curNum = 1
  elseif self.lastPopTime2 == nil or checkTime < curTime - self.lastPopTime2 then
    curNum = 2
  else
    self.battleBehaviors = {}
    return
  end
  local logData = self:PopOnLogPop()
  if logData == nil then
    return
  end
  local obj = self.theItem:GameObjectSpawn(self.transform)
  local key = "item" .. self.logPopCnt
  self.logPopCnt = self.logPopCnt + 1
  obj.name = key
  if curNum == 1 then
    self.lastPopTime1 = curTime
    if self.itemObj1 ~= nil then
      self.itemObj1:GameObjectRecycle()
      self:RemoveComponent(self.itemObj1.name, LWMainDesertLogPopItem)
    end
    self.itemObj1 = obj
  elseif curNum == 2 then
    self.lastPopTime2 = curTime
    if self.itemObj2 ~= nil then
      self.itemObj2:GameObjectRecycle()
      self:RemoveComponent(self.itemObj2.name, LWMainDesertLogPopItem)
    end
    self.itemObj2 = obj
  end
  local item = self:AddComponent(LWMainDesertLogPopItem, key)
  item:SetActive(true)
  item:ReInit(logData)
  item:PlayAnim(function()
    if obj and not IsNull(obj.gameObject) then
      obj.gameObject:GameObjectRecycle()
    end
    if curNum == 1 then
      self.itemObj1 = nil
    elseif curNum == 2 then
      self.itemObj2 = nil
    end
    self:RemoveComponent(key, LWMainDesertLogPopItem)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
  end)
end

return LWMainDesertLogPop
