local base = UIBaseContainer
local CommonResultGetStrongerSpecialListComponent = BaseClass("CommonResultGetStrongerSpecialListComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local DEFAULT_FUNC_BTN_ICON = "Assets/Main/Sprites/UI/LWUIStageFeatureChapter/wxy_qianxian_yaoqing_qianwang.png"
local DEFAULT_BG_SPECIAL_ICON = "Assets/Main/Sprites/UI/CommonCombatResultNew/zyf_jiesuan_bianqiang_UR.png"

function CommonResultGetStrongerSpecialListComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function CommonResultGetStrongerSpecialListComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function CommonResultGetStrongerSpecialListComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgHeroHead = self.viewSkin:AddComponent(self, UIImage, 1)
  self.imgBgSpecial = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textTxtGetStrongerWay = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.imgBtnGoTo = self.viewSkin:AddComponent(self, UIImage, 4)
  self.btnGoTo = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnGoTo:SetOnClick(function()
    self:OnBtnGoToClick()
  end)
  self.rootSimpleAnimation = self.viewSkin:AddComponent(self, UISimpleAnimation, 6)
  self.canvasGroupImgBg = self.viewSkin:AddComponent(self, UICanvasGroup, 7)
  self.btnBgSpecial = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnBgSpecial:SetOnClick(function()
    self:OnBtnBgSpecialClick()
  end)
end

function CommonResultGetStrongerSpecialListComponent:ComponentDestroy()
  self.viewSkin = nil
  self.imgHeroHead = nil
  self.imgBgSpecial = nil
  self.textTxtGetStrongerWay = nil
  self.imgBtnGoTo = nil
  self.btnGoTo = nil
  self.rootSimpleAnimation = nil
  self.canvasGroupImgBg = nil
  self.btnBgSpecial = nil
end

function CommonResultGetStrongerSpecialListComponent:DataDefine()
end

function CommonResultGetStrongerSpecialListComponent:DataDestroy()
  self.funcGO = nil
  self.data = nil
end

function CommonResultGetStrongerSpecialListComponent:OnAddListener()
  base.OnAddListener(self)
end

function CommonResultGetStrongerSpecialListComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function CommonResultGetStrongerSpecialListComponent:OnBtnGoToClick()
  if self.funcGO then
    self.funcGO(self.data)
  end
end

function CommonResultGetStrongerSpecialListComponent:GetBtnGoPos()
  return self.btnGoTo.transform.position
end

function CommonResultGetStrongerSpecialListComponent:ReInit(data)
  if not data then
    return
  end
  self.data = data
  if data.icon then
    self.imgHeroHead:LoadSpriteAsync(data.icon)
  end
  self.textTxtGetStrongerWay:SetText(data.name or "")
  if data.funcIcon then
    self.imgBtnGoTo:LoadSpriteAsync(data.funcIcon)
  else
    self.imgBtnGoTo:LoadSpriteAsync(DEFAULT_FUNC_BTN_ICON)
  end
  if data.bgSpec then
    self.imgBgSpecial:LoadSpriteAsync(data.bgSpec)
  else
    self.imgBgSpecial:LoadSpriteAsync(DEFAULT_BG_SPECIAL_ICON)
  end
  self.funcGO = data.funcGO
end

function CommonResultGetStrongerSpecialListComponent:SetRootAlpha(alpha)
  if self.canvasGroupImgBg then
    self.canvasGroupImgBg:SetAlpha(alpha)
  end
end

function CommonResultGetStrongerSpecialListComponent:RewindPlayRootAnimation(animationName)
  if self.rootSimpleAnimation then
    self.rootSimpleAnimation:Rewind(animationName)
    self.rootSimpleAnimation:Play(animationName)
  end
end

function CommonResultGetStrongerSpecialListComponent:StopRootAnimation()
  if self.rootSimpleAnimation then
    self.rootSimpleAnimation:Stop()
  end
end

function CommonResultGetStrongerSpecialListComponent:OnBtnBgSpecialClick()
  self:OnBtnGoToClick()
end

return CommonResultGetStrongerSpecialListComponent
