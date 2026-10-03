local base = UIBaseContainer
local CommonResultGoToListComponent = BaseClass("CommonResultGoToListComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local DEFAULT_FUNC_BTN_ICON = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_5.png"

function CommonResultGoToListComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function CommonResultGoToListComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function CommonResultGoToListComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 1)
  self.btnFunction = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnFunction:SetOnClick(function()
    self:OnBtnFunctionClick()
  end)
  self.textTxtFunction = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textTxtInfo = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 5)
  self.rootSimpleAnimation = self.viewSkin:AddComponent(self, UISimpleAnimation, 6)
  self.canvasGroupImgBg = self.viewSkin:AddComponent(self, UICanvasGroup, 7)
end

function CommonResultGoToListComponent:ComponentDestroy()
  self.viewSkin = nil
  self.imgIcon = nil
  self.btnFunction = nil
  self.textTxtFunction = nil
  self.textTxtInfo = nil
  self.imgBg = nil
  self.rootSimpleAnimation = nil
  self.canvasGroupImgBg = nil
end

function CommonResultGoToListComponent:DataDefine()
end

function CommonResultGoToListComponent:DataDestroy()
  self.funcGO = nil
end

function CommonResultGoToListComponent:OnAddListener()
  base.OnAddListener(self)
end

function CommonResultGoToListComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function CommonResultGoToListComponent:OnBtnFunctionClick()
  if self.funcGO then
    self.funcGO()
  end
end

function CommonResultGoToListComponent:ReInit(data)
  if not data then
    return
  end
  if data.icon then
    self.imgIcon:LoadSpriteAsync(data.icon)
  end
  self.textTxtInfo:SetText(data.name or "")
  if data.funcIcon then
    self.imgBg:LoadSpriteAsync(data.funcIcon)
  else
    self.imgBg:LoadSpriteAsync(DEFAULT_FUNC_BTN_ICON)
  end
  self.funcGO = data.funcGO
  self.textTxtFunction:SetText(data.funcTxt or "")
end

function CommonResultGoToListComponent:SetRootAlpha(alpha)
  if self.canvasGroupImgBg then
    self.canvasGroupImgBg:SetAlpha(alpha)
  end
end

function CommonResultGoToListComponent:RewindPlayRootAnimation(animationName)
  if self.rootSimpleAnimation then
    self.rootSimpleAnimation:Rewind(animationName)
    self.rootSimpleAnimation:Play(animationName)
  end
end

function CommonResultGoToListComponent:StopRootAnimation()
  if self.rootSimpleAnimation then
    self.rootSimpleAnimation:Stop()
  end
end

return CommonResultGoToListComponent
