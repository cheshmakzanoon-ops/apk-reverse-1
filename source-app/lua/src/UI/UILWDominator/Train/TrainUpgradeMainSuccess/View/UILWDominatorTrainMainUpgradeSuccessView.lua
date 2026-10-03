local UILWDominatorTrainMainUpgradeSuccessView = BaseClass("UILWDominatorTrainMainUpgradeSuccessView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UILWDominatorTrainMainUpgradeSuccessView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

function UILWDominatorTrainMainUpgradeSuccessView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDominatorTrainMainUpgradeSuccessView:ComponentDefine()
  self.btnPanel = self:AddComponent(UIButton, "Panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTitleTxt = self:AddComponent(UIText, "Content/bgContent1/UICommonRewardPopUp/Panel/ImgTitleBg/TextTitle")
  self.textTitleTxt:SetText(Localization:GetString("dominator_cure_title_1"))
  self.textInitText = self:AddComponent(UIText, "Content/bgContent1/Layout/InitText")
  self.textInitText:SetText(Localization:GetString("dominator_train_rating_desc_6"))
  self.compPreBg = self:AddComponent(UIBaseContainer, "Content/bgContent1/Layout/PreBg")
  self.imgPreIcon = self:AddComponent(UIImage, "Content/bgContent1/Layout/PreBg/PreIcon")
  self.compArrow = self:AddComponent(UIBaseContainer, "Content/bgContent1/Layout/arrow")
  self.compNewBg = self:AddComponent(UIBaseContainer, "Content/bgContent1/Layout/NewBg")
  self.imgNewIcon = self:AddComponent(UIImage, "Content/bgContent1/Layout/NewBg/NewIcon")
  self.textClose = self:AddComponent(UIText, "Content/bgContent1/CloseText")
  self.textClose:SetText(Localization:GetString("dominator_cure_desc_9"))
  self.textNew = self:AddComponent(UIText, "Content/bgContent1/Layout/NewBg/NewText")
  self.textPre = self:AddComponent(UIText, "Content/bgContent1/Layout/PreBg/PreText")
  self.imgIconColorLeft = self:AddComponent(UIImage, "Content/bgContent1/Layout/PreBg/Ef_ui_glow_quality_color_left/icon_color_left")
  self.imgIconColorRight = self:AddComponent(UIImage, "Content/bgContent1/Layout/NewBg/Ef_ui_glow_quality_color_right/icon_color_right")
  self.imgBaseLeft = self:AddComponent(UIImage, "Content/bgContent1/Layout/PreBg/Ef_ui_glow_quality_color_left/base_left")
  self.imgGlowLeft = self:AddComponent(UIImage, "Content/bgContent1/Layout/PreBg/Ef_ui_glow_quality_color_left/glow_left")
  self.imgBaseRight = self:AddComponent(UIImage, "Content/bgContent1/Layout/NewBg/Ef_ui_glow_quality_color_right/base_right")
  self.imgGlowRight = self:AddComponent(UIImage, "Content/bgContent1/Layout/NewBg/Ef_ui_glow_quality_color_right/glow_right")
end

function UILWDominatorTrainMainUpgradeSuccessView:ComponentDestroy()
  self.btnPanel = nil
  self.textTitleTxt = nil
  self.compPreBg = nil
  self.imgPreIcon = nil
  self.compArrow = nil
  self.compNewBg = nil
  self.imgNewIcon = nil
  self.textClose = nil
  self.textNew = nil
  self.textPre = nil
  self.textInitText = nil
  self.imgIconColorLeft = nil
  self.imgIconColorRight = nil
  self.imgBaseLeft = nil
  self.imgGlowLeft = nil
  self.imgBaseRight = nil
  self.imgGlowRight = nil
end

function UILWDominatorTrainMainUpgradeSuccessView:DataDefine()
end

function UILWDominatorTrainMainUpgradeSuccessView:DataDestroy()
end

function UILWDominatorTrainMainUpgradeSuccessView:OnAddListener()
  base.OnAddListener(self)
end

function UILWDominatorTrainMainUpgradeSuccessView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWDominatorTrainMainUpgradeSuccessView:OnOpen()
  self.param = self:GetUserData()
  if self.param == nil or self.param.preTrainTemplate == nil or self.param.curTrainTemplate == nil then
    return
  end
  local isInit = self.param.preTrainTemplate.level_order == 0
  self.compPreBg:SetActive(not isInit)
  self.textInitText:SetActive(isInit)
  if not isInit then
    self.imgPreIcon:LoadSprite(self.param.preTrainTemplate:GetNumberIconPath())
    self.textPre:SetText(self.param.preTrainTemplate:GetColoredName(false))
    local ret, r, g, b, a = self.param.preTrainTemplate:GetQualityImageColorRGBA()
    if ret then
      self.imgIconColorLeft:SetColorRGBA255(r, g, b, a)
      self.imgBaseLeft:SetColorRGBA255(r, g, b, a)
      self.imgGlowLeft:SetColorRGBA255(r, g, b, a)
    end
  end
  self.imgNewIcon:LoadSprite(self.param.curTrainTemplate:GetNumberIconPath())
  self.textNew:SetText(self.param.curTrainTemplate:GetColoredName(false))
  local ret, r, g, b, a = self.param.curTrainTemplate:GetQualityImageColorRGBA()
  if ret then
    self.imgIconColorRight:SetColorRGBA255(r, g, b, a)
    self.imgBaseRight:SetColorRGBA255(r, g, b, a)
    self.imgGlowRight:SetColorRGBA255(r, g, b, a)
  end
end

function UILWDominatorTrainMainUpgradeSuccessView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

return UILWDominatorTrainMainUpgradeSuccessView
