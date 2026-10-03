local base = UIBaseContainer
local UIBoxItemTipsCellComponent = BaseClass("UIBoxItemTipsCellComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIBoxItemTipsCellComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBoxItemTipsCellComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBoxItemTipsCellComponent:ComponentDefine()
  self.compUICommonResItem = self:AddComponent(UICommonResItem, "UICommonResItem")
  self.textProbability = self:AddComponent(UIText, "ProbabilityText")
  self.compProbabilityBaseImage = self:AddComponent(UIBaseContainer, "ProbabilityBaseImage")
end

function UIBoxItemTipsCellComponent:ComponentDestroy()
  self.compUICommonResItem = nil
  self.textProbability = nil
  self.compProbabilityBaseImage = nil
end

function UIBoxItemTipsCellComponent:DataDefine()
end

function UIBoxItemTipsCellComponent:DataDestroy()
end

function UIBoxItemTipsCellComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIBoxItemTipsCellComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIBoxItemTipsCellComponent:ReInit(data)
  self.compUICommonResItem:ReInit(data.itemData)
  local showProbability = data.probability ~= nil
  self.textProbability:SetActive(showProbability)
  self.compProbabilityBaseImage:SetActive(showProbability)
  if showProbability then
    local str = string.format("%.2f", data.probability * 100) .. "%"
    str = string.removeExtraDecimals(str)
    self.textProbability:SetText(str)
  end
end

return UIBoxItemTipsCellComponent
