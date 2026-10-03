local base = UIBaseContainer
local CommonResultGetStrongerListComponent = BaseClass("CommonResultGetStrongerListComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local DEFAULT_FUNC_BTN_ICON = "Assets/Main/Sprites/UI/LWUIStageFeatureChapter/wxy_qianxian_yaoqing_qianwang.png"

function CommonResultGetStrongerListComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function CommonResultGetStrongerListComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function CommonResultGetStrongerListComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 1)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textTxtGetStrongerWay = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.btnGoTo = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnGoTo:SetOnClick(function()
    self:OnBtnGoToClick()
  end)
  self.imgBtn = self.viewSkin:AddComponent(self, UIImage, 5)
  self.animatorBtnGoTo = self.viewSkin:AddComponent(self, UIAnimator, 6)
  self.compEffHighLight = self.viewSkin:AddComponent(self, UIBaseComponent, 7)
  self.rootSimpleAnimation = self.viewSkin:AddComponent(self, UISimpleAnimation, 8)
  self.canvasGroupImgBg = self.viewSkin:AddComponent(self, UICanvasGroup, 9)
  self.simpleAnimationEffCommonTuijian = self.viewSkin:AddComponent(self, UISimpleAnimation, 10)
end

function CommonResultGetStrongerListComponent:ComponentDestroy()
  self.viewSkin = nil
  self.imgBg = nil
  self.imgIcon = nil
  self.textTxtGetStrongerWay = nil
  self.btnGoTo = nil
  self.imgBtn = nil
  self.animatorBtnGoTo = nil
  self.compEffHighLight = nil
  self.rootSimpleAnimation = nil
  self.canvasGroupImgBg = nil
  self.simpleAnimationEffCommonTuijian = nil
end

function CommonResultGetStrongerListComponent:DataDefine()
end

function CommonResultGetStrongerListComponent:DataDestroy()
  self.funcGO = nil
  self.data = nil
end

function CommonResultGetStrongerListComponent:OnAddListener()
  base.OnAddListener(self)
end

function CommonResultGetStrongerListComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function CommonResultGetStrongerListComponent:OnBtnGoToClick()
  if self.funcGO then
    self.funcGO(self.data)
  end
end

function CommonResultGetStrongerListComponent:GetBtnGoPos()
  return self.btnGoTo.transform.position
end

function CommonResultGetStrongerListComponent:ReInit(data)
  if not data then
    return
  end
  self.data = data
  if data.icon then
    self.imgIcon:LoadSpriteAsync(data.icon)
  end
  self.textTxtGetStrongerWay:SetText(data.name or "")
  if data.funcIcon then
    self.imgBtn:LoadSpriteAsync(data.funcIcon)
  else
    self.imgBtn:LoadSpriteAsync(DEFAULT_FUNC_BTN_ICON)
  end
  self.funcGO = data.funcGO
  local highLight = data.highLight or false
  self.animatorBtnGoTo:Enable(highLight)
  self.compEffHighLight:SetActive(false)
  if highLight then
    self.compEffHighLight:SetActive(true)
    local isFlip = CommonUtil.IsArabicAutoMirrorOpen()
    local aniName = isFlip and "flip" or "Default"
    self.simpleAnimationEffCommonTuijian:Rewind(aniName)
    self.simpleAnimationEffCommonTuijian:Play(aniName)
  end
end

function CommonResultGetStrongerListComponent:SetRootAlpha(alpha)
  if self.canvasGroupImgBg then
    self.canvasGroupImgBg:SetAlpha(alpha)
  end
end

function CommonResultGetStrongerListComponent:RewindPlayRootAnimation(animationName)
  if self.rootSimpleAnimation then
    self.rootSimpleAnimation:Rewind(animationName)
    self.rootSimpleAnimation:Play(animationName)
  end
end

function CommonResultGetStrongerListComponent:StopRootAnimation()
  if self.rootSimpleAnimation then
    self.rootSimpleAnimation:Stop()
  end
end

return CommonResultGetStrongerListComponent
