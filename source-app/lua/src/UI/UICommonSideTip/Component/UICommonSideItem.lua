local UICommonSideItem = BaseClass("UICommonSideItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local text_path = "Text"
local hero_icon_path = "HeroIcon"

function UICommonSideItem:OnCreate()
  base.OnCreate(self)
  self.text = self:AddComponent(UITextMeshProUGUIEx, text_path)
  self.hero_icon = self:AddComponent(UIImage, hero_icon_path)
end

function UICommonSideItem:OnDestroy()
  self.text = nil
  self.hero_icon = nil
  base.OnDestroy(self)
end

function UICommonSideItem:SetData(heroModelId)
  if heroModelId then
    local iconPath = HeroUtils.GetHeroIconPath(heroModelId)
    self.hero_icon:LoadSpriteAuto(iconPath)
  end
end

function UICommonSideItem:SetText(text)
  if not string.IsNullOrEmpty(text) then
    self.text:SetText(Localization:GetString(text))
  end
end

return UICommonSideItem
