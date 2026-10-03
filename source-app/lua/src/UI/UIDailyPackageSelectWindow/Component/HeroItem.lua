local HeroItem = BaseClass("HeroItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self.heroIcon = self:AddComponent(UIImage, "Mask/HeroIcon")
  self.focusFrame = self:AddComponent(UIImage, "FocusFrame")
  self.heroTypeIcon = self:AddComponent(UIImage, "HeroTypeIcon")
  self.heroJobIcon = self:AddComponent(UIImage, "HeroJobIcon")
  self.selecting = self:AddComponent(UIImage, "Selecting")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    if self.clickCallback then
      self.clickCallback(self, self.templateId)
    end
  end)
  self.uniqueWeaponBg = self:AddComponent(UIBaseContainer, "uniqueWeaponBg")
  self.heroShadow = self:AddComponent(UIBaseContainer, "heroShadow")
  self.uniqueShadow = self:AddComponent(UIBaseContainer, "uniqueShadow")
  self.redDot = self:AddComponent(UIImage, "red")
  self.redDot:SetActive(false)
end

local function OnDestroy(self)
  base.OnDestroy(self)
  self.heroIcon = nil
  self.focusFrame = nil
  self.heroTypeIcon = nil
  self.heroJobIcon = nil
  self.selecting = nil
  self.btn = nil
  self.uniqueWeaponBg = nil
  self.heroShadow = nil
  self.uniqueShadow = nil
end

local function ReInit(self, templateId, clickCallback, index)
  self.clickCallback = clickCallback
  self.index = index
  if not templateId then
    self:SetActive(false)
    self.templateId = nil
  else
    self:SetActive(true)
    self.templateId = templateId
    local template = DataCenter.DailyPackageTemplateManager:GetTemplate(templateId)
    if not template then
      self:SetActive(false)
      return
    end
    self:SetActive(true)
    local heroId = template:GetHeroId()
    local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(heroId)
    if not heroTemplate then
      self:SetActive(false)
      return
    end
    local heroModelId = heroTemplate.appearance
    if template.content_type == DailyPackageType.HeroAwaken then
      heroModelId = template.awaken_appearance
    end
    local heroIconPath = HeroUtils.GetHeroIconPath(heroModelId, HeroIconType.half_portrait)
    self.heroIcon:LoadSpriteAuto(heroIconPath)
    local isUseGoldTypeIcon = HeroUtils.IsUseGoldTypeIconByDailyPackageType(template.content_type)
    self.heroTypeIcon:LoadSpriteAuto(HeroUtils.GetHeroTypeIcon(heroTemplate.type, isUseGoldTypeIcon))
    self.heroJobIcon:LoadSpriteAuto(HeroUtils.GetHeroJobIcon(heroTemplate.job, 2))
    self.uniqueWeaponBg:SetActive(template.content_type == DailyPackageType.HeroUniqueWeapon)
    self.heroShadow:SetActive(template.content_type == DailyPackageType.Hero)
    self.uniqueShadow:SetActive(template.content_type == DailyPackageType.HeroUniqueWeapon)
    self.redDot:SetActive(not DataCenter.DailyPackageManager:IsReaded(template.id))
  end
end

local function SetFocus(self, focus)
  self.focusFrame:SetActive(focus)
  self.focused = focus
  if self.focused and not DataCenter.DailyPackageManager:IsReaded(self.templateId) then
    DataCenter.DailyPackageManager:MarkAsReaded(self.templateId)
  end
end

local function SetSelecting(self, selecting)
  self.selecting:SetActive(selecting)
end

local function SetRedDotVisible(self, visible)
  self.redDot:SetActive(visible)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshWelfareRedDot, self.RefreshRedDot)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshWelfareRedDot, self.RefreshRedDot)
end

local function RefreshRedDot(self)
  self.redDot:SetActive(not DataCenter.DailyPackageManager:IsReaded(self.templateId))
end

HeroItem.OnCreate = OnCreate
HeroItem.OnDestroy = OnDestroy
HeroItem.ReInit = ReInit
HeroItem.SetFocus = SetFocus
HeroItem.SetSelecting = SetSelecting
HeroItem.SetRedDotVisible = SetRedDotVisible
HeroItem.OnAddListener = OnAddListener
HeroItem.OnRemoveListener = OnRemoveListener
HeroItem.RefreshRedDot = RefreshRedDot
return HeroItem
