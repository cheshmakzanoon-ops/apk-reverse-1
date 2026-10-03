local base = UIBaseContainer
local CommonResulHeroEntryListComponent = BaseClass("CommonResulHeroEntryListComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")

function CommonResulHeroEntryListComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function CommonResulHeroEntryListComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function CommonResulHeroEntryListComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compUIHeroCellSmall = self.viewSkin:AddComponent(self, UIHeroCellSmall, 1)
  self.textTxtHeroName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textTxtDmgNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.imgInner = self.viewSkin:AddComponent(self, UIImage, 4)
  self.imgNodeDeathMask = self.viewSkin:AddComponent(self, UIImage, 5)
  self.imgProgressBar = self.viewSkin:AddComponent(self, UIImage, 6)
  self.canvasGroupImgBg = self.viewSkin:AddComponent(self, UICanvasGroup, 7)
  self.rootSimpleAnimation = self.viewSkin:AddComponent(self, UISimpleAnimation, 8)
end

function CommonResulHeroEntryListComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compUIHeroCellSmall = nil
  self.textTxtHeroName = nil
  self.textTxtDmgNum = nil
  self.imgInner = nil
  self.imgNodeDeathMask = nil
  self.imgProgressBar = nil
  self.canvasGroupImgBg = nil
  self.rootSimpleAnimation = nil
end

function CommonResulHeroEntryListComponent:DataDefine()
end

function CommonResulHeroEntryListComponent:DataDestroy()
  if not IsNull(self.tween) then
    self.tween:Kill()
    self.tween = nil
  end
end

function CommonResulHeroEntryListComponent:OnAddListener()
  base.OnAddListener(self)
end

function CommonResulHeroEntryListComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function CommonResulHeroEntryListComponent:ReInit(data)
  if not data then
    return
  end
  if not IsNull(self.tween) then
    self.tween:Kill()
    self.tween = nil
  end
  if data.heroData then
    local heroData = data.heroData
    if heroData.fromTemplate then
      local uniqueWeaponLv = 0
      if heroData.GetUniqueWeaponLv then
        uniqueWeaponLv = heroData:GetUniqueWeaponLv()
      end
      self.compUIHeroCellSmall:InitWithConfigId(heroData.heroId, nil, heroData.level, heroData:GetRank(), uniqueWeaponLv, heroData:GetHeroAwakenRankLevel(), heroData:GetSkinId())
    else
      self.compUIHeroCellSmall:SetData(heroData.uuid)
    end
  end
  self.textTxtHeroName:SetText(Localization:GetString(data.heroData and data.heroData.firstName or ""))
  self.textTxtDmgNum:SetText(0)
  local barSize = self.imgProgressBar:GetSizeDelta()
  self.imgInner:SetSizeDelta(Vector2.New(0, barSize.y))
  self.progress = 0
  local maxValue = data.maxValue
  if maxValue <= 0 then
    maxValue = 1
  end
  local percent = (data.value or 0) / maxValue
  self.tween = CS.DG.Tweening.DOTween.To(function()
    return self.progress
  end, function(p)
    local value = data.value or 0
    self.progress = value
    local pValue = value * p
    self.textTxtDmgNum:SetText(string.GetFormattedStr(pValue))
    self.imgInner:SetSizeDelta(Vector2(p * percent * barSize.x, barSize.y))
  end, 1, percent * 1):SetEase(CS.DG.Tweening.Ease.OutCubic)
  if data.heroDeath then
    self.imgNodeDeathMask:SetActive(true)
  else
    self.imgNodeDeathMask:SetActive(false)
  end
end

function CommonResulHeroEntryListComponent:SetRootAlpha(alpha)
  if self.canvasGroupImgBg then
    self.canvasGroupImgBg:SetAlpha(alpha)
  end
end

function CommonResulHeroEntryListComponent:RewindPlayRootAnimation(animationName)
  if self.rootSimpleAnimation then
    self.rootSimpleAnimation:Rewind(animationName)
    self.rootSimpleAnimation:Play(animationName)
  end
end

function CommonResulHeroEntryListComponent:StopRootAnimation()
  if self.rootSimpleAnimation then
    self.rootSimpleAnimation:Stop()
  end
end

return CommonResulHeroEntryListComponent
