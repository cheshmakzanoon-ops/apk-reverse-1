local MailHeroItem = BaseClass("MailHeroItem", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local u_i_hero_cell_small_path = "UIHeroCellSmall"
local slider_path = "Slider"
local hp_num_path = "Slider/hpNum"

function MailHeroItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function MailHeroItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MailHeroItem:ComponentDefine()
  self.hero_cell_small = self:AddComponent(UIHeroCellSmall, u_i_hero_cell_small_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.hp_num = self:AddComponent(UITextMeshProUGUIEx, hp_num_path)
end

function MailHeroItem:ComponentDestroy()
end

function MailHeroItem:SetData(heroId, level, rankId, value, percent, weaponLevel, awakenLv, heroSkinId)
  self.hero_cell_small:SetActive(heroId)
  self.slider:SetActive(heroId)
  if not heroId then
    return
  end
  self.hero_cell_small:InitWithConfigId(heroId, nil, level, rankId, weaponLevel, awakenLv, heroSkinId)
  self.hp_num:SetText(string.GetFormattedSeparatorNum(value))
  self.slider:SetValue(percent)
end

return MailHeroItem
