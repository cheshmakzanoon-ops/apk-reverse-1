local base = UIBaseContainer
local UILWDominatorTrainMainUpgradeComponent = BaseClass("UILWDominatorTrainMainUpgradeComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWDominatorTrainMainUpgradeComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWDominatorTrainMainUpgradeComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDominatorTrainMainUpgradeComponent:ComponentDefine()
  self.imgBg = self:AddComponent(UIImage, "Bg")
  self.textTitle = self:AddComponent(UIText, "TitleText")
  self.compOKIcon = self:AddComponent(UIBaseContainer, "OKIcon")
end

function UILWDominatorTrainMainUpgradeComponent:ComponentDestroy()
  self.imgBg = nil
  self.textTitle = nil
  self.compOKIcon = nil
end

function UILWDominatorTrainMainUpgradeComponent:DataDefine()
end

function UILWDominatorTrainMainUpgradeComponent:DataDestroy()
end

function UILWDominatorTrainMainUpgradeComponent:ReInit(levelTemplate)
  if levelTemplate == nil then
    return
  end
  self.textTitle:SetText(levelTemplate:GetRequireText())
  local isOK = levelTemplate:IsRequireOK()
  if isOK then
    self.textTitle:SetColorRGBA255(0, 255, 0, 255)
  else
    self.textTitle:SetColorRGBA255(255, 0, 0, 255)
  end
  self.compOKIcon:SetActive(isOK)
end

function UILWDominatorTrainMainUpgradeComponent:SetBgActive(isActive)
  self.imgBg:SetActive(isActive)
end

function UILWDominatorTrainMainUpgradeComponent:SetColorRGBA255(r, g, b, a)
  self.imgBg:SetColorRGBA255(r, g, b, a)
end

function UILWDominatorTrainMainUpgradeComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWDominatorTrainMainUpgradeComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

return UILWDominatorTrainMainUpgradeComponent
