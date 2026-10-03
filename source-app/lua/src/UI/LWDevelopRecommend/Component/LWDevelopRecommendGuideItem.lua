local LWDevelopRecommendGuideItem = BaseClass("LWDevelopRecommendGuideItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function LWDevelopRecommendGuideItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWDevelopRecommendGuideItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWDevelopRecommendGuideItem:ComponentDefine()
  self.imgIcon = self:AddComponent(UIImage, "GuideItemIconBase/GuideItemIcon")
  self.text = self:AddComponent(UIText, "GuideItemDescriptionBase/GuideItemDescription")
  self.btn = self:AddComponent(UIButton, "GuideItemBtn")
  self.btn:SetOnClick(function()
    self:OnGotoClick()
  end)
  self.textBtn = self:AddComponent(UIText, "GuideItemBtn/Btn/GuideItemBtnText")
  self.textBtn:SetLocalText("develop_guide_tip1")
end

function LWDevelopRecommendGuideItem:ComponentDestroy()
  self.imgIcon = nil
  self.text = nil
  self.btn = nil
end

function LWDevelopRecommendGuideItem:DataDefine()
end

function LWDevelopRecommendGuideItem:DataDestroy()
  self.sourceType = nil
  self.data = nil
end

function LWDevelopRecommendGuideItem:OnGotoClick()
  if self.data ~= nil then
    self.data:OnGotoClick()
  end
end

function LWDevelopRecommendGuideItem:UpdateAllUI(data)
  self.sourceType = data
  self.data = DataCenter.LWDevelopRecommendManager:GetScoreConfigTemplateDataBySourceType(self.sourceType)
  if self.data == nil then
    return
  end
  self.imgIcon:LoadSprite(self.data:GetIconPath())
  self.text:SetLocalText(self.data:GetDescription())
end

return LWDevelopRecommendGuideItem
