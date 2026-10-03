local LWUIMigrationView_ScoreDetailItem = BaseClass("LWUIMigrationView_ScoreDetailItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroCellBig = require("UI.UIHero2.Common.UIHeroCellBig")
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")

function LWUIMigrationView_ScoreDetailItem:OnCreate()
  base.OnCreate(self)
  self.hero = self:AddComponent(UIBaseComponent, "Hero")
  self.heroCell = self:AddComponent(UIHeroCellBig, "Hero/UIHeroCellBig")
  self.text_hero_formation = self:AddComponent(UIText, "Hero/FormationTag/FormationText")
  self.soldier = self:AddComponent(UIBaseComponent, "Soldier")
  self.img_bg_soldier = self:AddComponent(UIImage, "Soldier/Bg")
  self.img_icon_soldier = self:AddComponent(UIImage, "Soldier/Icon")
  self.text_cnt_soldier = self:AddComponent(UIText, "Soldier/CntText")
  self.text_lv_soldier = self:AddComponent(UIText, "Soldier/LvText")
  self.text_team_soldier = self:AddComponent(UIText, "Soldier/TeamText")
  self.text_power = self:AddComponent(UIText, "PowerText")
end

function LWUIMigrationView_ScoreDetailItem:OnDestroy()
  base.OnDestroy(self)
end

function LWUIMigrationView_ScoreDetailItem:SetHero(info)
  self.soldier:SetActive(false)
  self.hero:SetActive(true)
  self.text_power:SetText(string.GetFormattedStr(info.power))
  self.heroCell:InitWithConfigId(info.heroId, nil, info.level, info.rankLv, info.weaponLevel)
  if info.formationId and info.formationId > 0 then
    self.text_hero_formation.transform.parent.gameObject:SetActive(true)
    self.text_hero_formation:SetText(info.formationId)
  else
    self.text_hero_formation.transform.parent.gameObject:SetActive(false)
  end
end

function LWUIMigrationView_ScoreDetailItem:SetSoldier(info)
  self.hero:SetActive(false)
  self.soldier:SetActive(true)
  self.text_power:SetText(string.GetFormattedStr(info.power))
  local config = DataCenter.SoldierDataManager:GetTemplate(info.soldierId)
  self.img_bg_soldier:LoadSpriteAuto(UIUtil.GetItemQualityBg(config ~= nil and config.quality or 1))
  self.img_icon_soldier:LoadSpriteAuto(string.format(LoadPath.ItemPath, config ~= nil and config.icon or ""))
  self.text_cnt_soldier:SetText(info.number)
  self.text_lv_soldier:SetLocalText(140002, config ~= nil and config.lv or 1)
  self.text_team_soldier:SetText(Localization:GetString("457590") .. info.index)
end

return LWUIMigrationView_ScoreDetailItem
