local base = require("UI.UIInvasionSummonProgress.Component.InvasionSummonProgressItemBase")
local InvasionSummonProgressPopItem = BaseClass("InvasionSummonProgressPopItem", base)
local DataCenter = _ENV.DataCenter
local monster_head_path = "Bg/HeadGroup/MonsterHead"
local name_path = "Bg/HeadGroup/Name"

local function OnCreate(self)
  base.OnCreate(self)
end

local function OnDestroy(self)
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.monster_head = self:AddComponent(UIImage, monster_head_path)
  self.name = self:AddComponent(UITextMeshProUGUIEx, name_path)
end

local function ComponentDestroy(self)
  self.monster_head = nil
  self.name = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function AddListeners(self)
end

local function RemoveListeners(self)
end

local function ReInit(self, curProgress)
  if curProgress then
    self.progress = curProgress
    local actData = DataCenter.ActivityMonsterInvasionDataManager:GetActivityData()
    if actData then
      local monsterId = actData.summonBossId
      if monsterId then
        local name = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.Monster), monsterId, "name")
        name = name or ""
        self.name:SetLocalText(name)
      end
      self:InitHeadIcon(actData.iconArr, 3)
      self:UpdateProgress()
    end
  end
end

local function OnItemClick(self)
  local activityId = DataCenter.ActivityMonsterInvasionDataManager:GetInvasionActivityId()
  if activityId then
    GoToUtil.GotoOpenView(UIWindowNames.UIActivityCenterTable, activityId)
  end
end

local function DisplayProgressTween(self, targetVal)
  local curVal = self.progress
  if targetVal and targetVal > curVal then
    self:DoProgressTween(curVal, targetVal, 0.8)
    self.progress = targetVal
  end
end

InvasionSummonProgressPopItem.OnCreate = OnCreate
InvasionSummonProgressPopItem.OnDestroy = OnDestroy
InvasionSummonProgressPopItem.ComponentDefine = ComponentDefine
InvasionSummonProgressPopItem.ComponentDestroy = ComponentDestroy
InvasionSummonProgressPopItem.DataDefine = DataDefine
InvasionSummonProgressPopItem.DataDestroy = DataDestroy
InvasionSummonProgressPopItem.AddListeners = AddListeners
InvasionSummonProgressPopItem.RemoveListeners = RemoveListeners
InvasionSummonProgressPopItem.ReInit = ReInit
InvasionSummonProgressPopItem.OnItemClick = OnItemClick
InvasionSummonProgressPopItem.DisplayProgressTween = DisplayProgressTween
return InvasionSummonProgressPopItem
