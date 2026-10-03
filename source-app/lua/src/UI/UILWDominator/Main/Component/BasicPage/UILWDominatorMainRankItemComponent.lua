local base = UIBaseContainer
local UILWDominatorMainRankItemComponent = BaseClass("UILWDominatorMainRankItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWDominatorMainRankItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWDominatorMainRankItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDominatorMainRankItemComponent:ComponentDefine()
  self.compIcon = self:AddComponent(UIBaseContainer, "Icon")
end

function UILWDominatorMainRankItemComponent:ComponentDestroy()
  self.compIcon = nil
end

function UILWDominatorMainRankItemComponent:DataDefine()
end

function UILWDominatorMainRankItemComponent:DataDestroy()
end

function UILWDominatorMainRankItemComponent:SetOn()
  if self.compIcon then
    self.compIcon:SetActive(true)
  end
end

function UILWDominatorMainRankItemComponent:SetOff()
  if self.compIcon then
    self.compIcon:SetActive(false)
  end
end

function UILWDominatorMainRankItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWDominatorMainRankItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

return UILWDominatorMainRankItemComponent
