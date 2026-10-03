local LWSeasonAllianceRankTabItem = BaseClass("LWSeasonAllianceRankTabItem", UIToggle)
local base = UIToggle
local condition_dark_path = "ConditionDark"
local condition_path = "ConditionSelect/Condition"

function LWSeasonAllianceRankTabItem:OnCreate()
  base.OnCreate(self)
  self.condition_dark = self:AddComponent(UIText, condition_dark_path)
  self.condition = self:AddComponent(UIText, condition_path)
  self.eventId = nil
  self:SetOnValueChanged(function(tf)
    if tf and self.eventId then
      if not self.selecting then
        DataCenter.LWSoundManager:PlaySound(6100022, false)
      end
      self.view:OnTabChanged(self.eventId, nil)
    end
    self.selecting = false
  end)
end

function LWSeasonAllianceRankTabItem:OnDestroy()
  self.eventId = nil
  base.OnDestroy(self)
end

function LWSeasonAllianceRankTabItem:SetTabIndex(eventId)
  self.eventId = eventId
  local heroEventMeta = LocalController:instance():getLine(TableName.HeroEvent, self.eventId)
  if heroEventMeta then
    self.condition_dark:SetLocalText(heroEventMeta.name)
    self.condition:SetLocalText(heroEventMeta.name)
  else
    self:SetActive(false)
  end
end

return LWSeasonAllianceRankTabItem
