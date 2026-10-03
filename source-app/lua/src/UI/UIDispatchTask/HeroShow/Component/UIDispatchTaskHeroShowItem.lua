local UIDispatchTaskHeroShowItem = BaseClass("UIDispatchTaskHeroShowItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local text_path = "Text"
local hero_icon_path = "HeroIcon"

function UIDispatchTaskHeroShowItem:OnCreate()
  base.OnCreate(self)
  self.text = self:AddComponent(UITextMeshProUGUIEx, text_path)
  self.hero_icon = self:AddComponent(UIImage, hero_icon_path)
end

function UIDispatchTaskHeroShowItem:OnDestroy()
  self.text = nil
  self.hero_icon = nil
  base.OnDestroy(self)
end

function UIDispatchTaskHeroShowItem:SetData(heroUuid)
  local hero = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
  if hero then
    local iconPath = HeroUtils.GetHeroIconPath(hero.modelId, iconType)
    self.hero_icon:LoadSpriteAuto(iconPath)
  end
end

function UIDispatchTaskHeroShowItem:SetText(text)
  if not string.IsNullOrEmpty(text) then
    self.text:SetText(Localization:GetString(text))
  end
end

return UIDispatchTaskHeroShowItem
