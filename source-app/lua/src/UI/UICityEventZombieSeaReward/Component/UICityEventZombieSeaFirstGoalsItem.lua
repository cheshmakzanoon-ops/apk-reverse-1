local UICityEventZombieSeaFirstGoalsItem = BaseClass("UICityEventZombieSeaFirstGoalsItem", UIBaseContainer)
local base = UIBaseContainer
local closePath = "Close"
local openedPath = "Opened"
local effectPath = "GoalItemEffectGo"

function UICityEventZombieSeaFirstGoalsItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UICityEventZombieSeaFirstGoalsItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICityEventZombieSeaFirstGoalsItem:ComponentDefine()
  self.close = self:AddComponent(UIBaseContainer, closePath)
  self.opened = self:AddComponent(UIBaseContainer, openedPath)
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
  end)
  self.effect = self:AddComponent(UIBaseContainer, effectPath)
end

function UICityEventZombieSeaFirstGoalsItem:ComponentDestroy()
  self.close = nil
  self.opened = nil
  self.btn = nil
  self.effect = nil
end

function UICityEventZombieSeaFirstGoalsItem:DataDefine()
  self.isSend = false
end

function UICityEventZombieSeaFirstGoalsItem:DataDestroy()
end

function UICityEventZombieSeaFirstGoalsItem:SetData(index)
  self.index = index
  self.isSend = false
end

function UICityEventZombieSeaFirstGoalsItem:SetState(state)
  self.state = state
  self.close:SetActive(self.state == TaskState.NoComplete)
  self.opened:SetActive(self.state ~= TaskState.NoComplete)
  self.isSend = false
  self.effect:SetActive(self.state == TaskState.CanReceive)
end

return UICityEventZombieSeaFirstGoalsItem
