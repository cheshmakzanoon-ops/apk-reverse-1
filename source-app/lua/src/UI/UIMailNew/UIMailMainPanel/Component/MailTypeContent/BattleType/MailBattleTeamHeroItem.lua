local UIHeroCell = require("UI.UIHero2.Common.UIHeroCellSmall")
local MailBattleTeamHeroItem = BaseClass("MailBattleTeamHeroItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local hero_path = "UIHeroCellSmall"
local _cp_heroRank = "UIHeroCellSmall/ImgRank"

function MailBattleTeamHeroItem:OnCreate()
  base.OnCreate(self)
  self.heroBase = self:AddComponent(UIHeroCell, hero_path)
  self._imgRank = self:AddComponent(UIImage, _cp_heroRank)
end

function MailBattleTeamHeroItem:SetData(herodata)
  if herodata == nil then
    return
  end
  local heroId = herodata.heroId
  local heroLv = herodata.heroLevel
  local heroQuality = herodata.heroQuality or 0
  local skillInfos = herodata.skillInfos or {}
  local rankLv = herodata.rankLv or 0
  local stage = herodata.stage or 0
  local curMilitaryRankId = HeroUtils.GetRankIdByLvAndStage(heroId, rankLv, stage)
  self.heroBase:InitWithConfigId(heroId, heroQuality, heroLv, nil, skillInfos, curMilitaryRankId)
end

return MailBattleTeamHeroItem
