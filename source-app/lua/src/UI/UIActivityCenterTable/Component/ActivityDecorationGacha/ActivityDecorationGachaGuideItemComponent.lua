local base = UIBaseContainer
local ActivityDecorationGachaGuideItemComponent = BaseClass("ActivityDecorationGachaGuideItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function ActivityDecorationGachaGuideItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ActivityDecorationGachaGuideItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ActivityDecorationGachaGuideItemComponent:ComponentDefine()
  self.imgDecoration = self:AddComponent(UIImage, "Background/DecorationImage")
  self.text = self:AddComponent(UIText, "Text")
end

function ActivityDecorationGachaGuideItemComponent:ComponentDestroy()
  self.imgDecoration = nil
  self.text = nil
end

function ActivityDecorationGachaGuideItemComponent:DataDefine()
end

function ActivityDecorationGachaGuideItemComponent:DataDestroy()
end

function ActivityDecorationGachaGuideItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function ActivityDecorationGachaGuideItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function ActivityDecorationGachaGuideItemComponent:ReInit(data)
  if data == nil then
    return
  end
  self.imgDecoration:LoadSpriteAuto(data:GetDecorationImage())
  self.text:SetText(data:GetDecorationName())
end

return ActivityDecorationGachaGuideItemComponent
