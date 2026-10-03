local UIHeroCell = require("UI.UIHero2.Common.UIHeroCellSmall")
local MailHeroItem_HeroInfo = BaseClass("MailHeroItem_HeroInfo", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local hero_path = "objInfo/UIHeroCellSmall"
local _cp_txtHeroName = "objInfo/txtHeroName"
local _cp_txtExpAdd = "objInfo/txtExpAdd"
local _cp_txtHeroLevel = "objInfo/txtHeroLevel"
local _cp_txtNoHero = "txtNoHero"
local _cp_objInfo = "objInfo"

function MailHeroItem_HeroInfo:OnCreate()
  base.OnCreate(self)
  self.heroBase = self:AddComponent(UIHeroCell, hero_path)
  self._txtHeroName = self:AddComponent(UIText, _cp_txtHeroName)
  self._txtExpAdd = self:AddComponent(UIText, _cp_txtExpAdd)
  self._txtNoHero = self:AddComponent(UIText, _cp_txtNoHero)
  self._txtHeroLevel = self:AddComponent(UIText, _cp_txtHeroLevel)
  self._objInfo = self:AddComponent(UIBaseContainer, _cp_objInfo)
  self._txtNoHero:SetLocalText(182047)
end

function MailHeroItem_HeroInfo:SetData(herodata)
  if herodata == nil then
    self._objInfo:SetActive(false)
    self._txtNoHero:SetActive(true)
    return
  else
    self._txtNoHero:SetActive(false)
    self._objInfo:SetActive(true)
  end
  local heroId = herodata.heroId
  local heroLv = herodata.heroLevel
  local expAdd = herodata.expAdd or 0
  local heroQuality = herodata.heroQuality or 0
  local skillInfos = herodata.skillInfos or {}
  local rankLv = herodata.rankLv or 0
  local stage = herodata.stage or 0
  local curMilitaryRankId = 0
  local config = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), heroId)
  if config == nil then
    Logger.LogError("hero config not found! heroId:" .. heroId)
    return
  end
  local maxMilitaryRankId = config.max_rank_level or 1
  for rankId = 1, maxMilitaryRankId do
    local mailLevel = GetTableData(TableName.HeroMilitaryRankLv, rankId, "level")
    if rankLv == mailLevel then
      curMilitaryRankId = rankId
      break
    end
  end
  self.heroBase:InitWithConfigId(heroId, heroQuality, heroLv, nil, skillInfos, curMilitaryRankId)
  local heroname = GetTableData(HeroUtils.GetHeroXmlName(), heroId, "name")
  heroname = Localization:GetString(heroname)
  local heroLevel = Localization:GetString("300665", heroLv)
  self._txtHeroLevel:SetText(heroLevel)
  self._txtHeroName:SetText(heroname)
  if 0 < expAdd then
    self._txtExpAdd:SetText(Localization:GetString("100332") .. "+" .. expAdd)
  else
    self._txtExpAdd:SetText("")
  end
end

return MailHeroItem_HeroInfo
