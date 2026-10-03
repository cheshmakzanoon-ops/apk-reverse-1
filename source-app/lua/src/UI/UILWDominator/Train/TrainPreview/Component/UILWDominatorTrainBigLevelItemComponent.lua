local base = UIBaseContainer
local UILWDominatorTrainBigLevelItemComponent = BaseClass("UILWDominatorTrainBigLevelItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWDominatorTrainBigLevelItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWDominatorTrainBigLevelItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDominatorTrainBigLevelItemComponent:ReInit(template)
  self.template = template
  if self.template == nil then
    return
  end
  self.imgCurLevelIcon:LoadSprite(self.template:GetNumberIconPath())
  local ret, r, g, b, a = self.template:GetQualityImageColorRGBA()
  if ret then
    self.imgBase1:SetColorRGBA255(r, g, b, a)
    self.imgBase2:SetColorRGBA255(r, g, b, a)
    self.imgGlow:SetColorRGBA255(r, g, b, a)
  end
end

function UILWDominatorTrainBigLevelItemComponent:ComponentDefine()
  self.imgBase1 = self:AddComponent(UIImage, "Base1")
  self.imgBase2 = self:AddComponent(UIImage, "Base2")
  self.imgCurLevelIcon = self:AddComponent(UIImage, "CurLevelIcon")
  self.imgGlow = self:AddComponent(UIImage, "Glow")
end

function UILWDominatorTrainBigLevelItemComponent:ComponentDestroy()
  self.imgBase1 = nil
  self.imgBase2 = nil
  self.imgCurLevelIcon = nil
  self.imgGlow = nil
end

function UILWDominatorTrainBigLevelItemComponent:DataDefine()
end

function UILWDominatorTrainBigLevelItemComponent:DataDestroy()
end

function UILWDominatorTrainBigLevelItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWDominatorTrainBigLevelItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

return UILWDominatorTrainBigLevelItemComponent
