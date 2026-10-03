local base = UIBaseContainer
local LWUICommonActivityRulesPicGuideItemComponent = BaseClass("LWUICommonActivityRulesPicGuideItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LWUICommonActivityRulesPicGuideItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUICommonActivityRulesPicGuideItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUICommonActivityRulesPicGuideItemComponent:ComponentDefine()
  self.layoutElementImgContent = self:AddComponent(UILayoutElement, "ImgContent")
  self.rawImgImg = self:AddComponent(UIRawImage, "ImgContent/Img")
  self.text = self:AddComponent(UITextMeshProUGUIEx, "Text")
  self.compLineContent = self:AddComponent(UIBaseComponent, "LineContent")
end

function LWUICommonActivityRulesPicGuideItemComponent:ComponentDestroy()
  self.layoutElementImgContent = nil
  self.rawImgImg = nil
  self.text = nil
  self.compLineContent = nil
end

function LWUICommonActivityRulesPicGuideItemComponent:DataDefine()
end

function LWUICommonActivityRulesPicGuideItemComponent:DataDestroy()
end

function LWUICommonActivityRulesPicGuideItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function LWUICommonActivityRulesPicGuideItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUICommonActivityRulesPicGuideItemComponent:ReInit(picGuideId, isShowLine)
  self.id = picGuideId
  local line = LocalController:instance():getLine(TableName.ACTIVITY_PIC_GUIDE, self.id)
  if not line then
    return
  end
  local isShowImage = not string.IsNullOrEmpty(line.pic)
  self.layoutElementImgContent:SetActive(isShowImage)
  if isShowImage then
    self.rawImgImg:LoadSprite(line.pic)
    self.rawImgImg:SetNativeSize()
    local imgSize = self.rawImgImg:GetSizeDelta()
    local imgH = imgSize.y
    self.layoutElementImgContent:SetPreferredHeight(imgH)
    self.layoutElementImgContent:SetMinHeight(imgH)
  end
  local isShowText = not string.IsNullOrEmpty(line.key)
  self.text:SetActive(isShowText)
  if isShowText then
    self.text:SetLocalText(line.key)
  end
  self.compLineContent:SetActive(isShowLine ~= nil and isShowLine == true)
end

return LWUICommonActivityRulesPicGuideItemComponent
