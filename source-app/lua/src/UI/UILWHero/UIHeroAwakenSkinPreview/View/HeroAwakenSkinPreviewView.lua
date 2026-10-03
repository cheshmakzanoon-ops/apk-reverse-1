local base = UIBaseView
local HeroAwakenSkinPreviewView = BaseClass("HeroAwakenSkinPreviewView", base)
local Localization = CS.GameEntry.Localization

function HeroAwakenSkinPreviewView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

function HeroAwakenSkinPreviewView:OnDestroy()
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.HeroAwakenSkillPreview) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.HeroAwakenSkillPreview)
  end
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function HeroAwakenSkinPreviewView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.rawImgHeroSpineBg = self.viewSkin:AddComponent(self, UIRawImage, 1)
  self.textHeroNickName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textHeroName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textContent = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnBack = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.btnAwakenSkill = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnAwakenSkill:SetOnClick(function()
    self:OnBtnAwakenSkillClick()
  end)
  self.textBody = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textBody:SetLocalText("hero_awaken_btn_26")
end

function HeroAwakenSkinPreviewView:ComponentDestroy()
  self.viewSkin = nil
  self.rawImgHeroSpineBg = nil
  self.textHeroNickName = nil
  self.textHeroName = nil
  self.textContent = nil
  self.btnBack = nil
  self.btnAwakenSkill = nil
  self.textBody = nil
end

function HeroAwakenSkinPreviewView:DataDefine()
  self.heroData = nil
end

function HeroAwakenSkinPreviewView:DataDestroy()
  self.heroData = nil
end

function HeroAwakenSkinPreviewView:OnOpen()
  self.heroData = self:GetUserData()
  if not self.heroData then
    Logger.LogError("HeroAwakenSkinPreviewView heroData is nil")
    self.ctrl:CloseSelf()
    return
  end
  local awakenTemplate = self.heroData:GetHeroAwakenTemplate()
  if not awakenTemplate then
    Logger.LogError("HeroAwakenSkinPreviewView awakenTemplate is nil, heroId:" .. self.heroData.heroId)
    self.ctrl:CloseSelf()
    return
  end
  local spineBgPath = awakenTemplate.spine_preview_pic
  if string.IsNullOrEmpty(spineBgPath) then
    self.rawImgHeroSpineBg:SetActive(false)
  else
    self.rawImgHeroSpineBg:LoadSpriteAsync(spineBgPath)
    self.rawImgHeroSpineBg:SetActive(true)
  end
  self.textHeroNickName:SetLocalText(awakenTemplate.new_hero_brief)
  self.textHeroName:SetText(self.heroData:GetName())
  self.textContent:SetLocalText(awakenTemplate.spine_preview_key)
end

function HeroAwakenSkinPreviewView:OnBtnBackClick()
  self.ctrl:CloseSelf()
end

function HeroAwakenSkinPreviewView:OnBtnAwakenSkillClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.HeroAwakenSkillPreview, {anim = true}, self.heroData)
end

return HeroAwakenSkinPreviewView
