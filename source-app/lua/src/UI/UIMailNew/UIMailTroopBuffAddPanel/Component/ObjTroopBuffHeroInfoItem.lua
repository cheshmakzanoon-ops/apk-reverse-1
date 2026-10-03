local UIHeroCell = require("UI.UIHero2.Common.UIHeroCellSmall")
local ObjTroopBuffSkillItem = require("UI.UIMailNew.UIMailTroopBuffAddPanel.Component.ObjTroopBuffSkillItem")
local ObjTroopBuffHeroInfoItem = BaseClass("ObjTroopBuffHeroInfoItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local hero_path = "UIHeroCellSmall"
local _cp_txtHeroLv = "objName/txtHeroLv"
local _cp_txtHeroName = "objName/txtHeroName"
local _cp_objSkillList = "objSkillList"
local _cp_heroSkill = "template/objHeroSkill"

function ObjTroopBuffHeroInfoItem:OnCreate()
  base.OnCreate(self)
  self.heroBase = self:AddComponent(UIHeroCell, hero_path)
  self._txtHeroLv = self:AddComponent(UIText, _cp_txtHeroLv)
  self._txtHeroName = self:AddComponent(UIText, _cp_txtHeroName)
  self._objSkillList = self:AddComponent(UIBaseContainer, _cp_objSkillList)
  self._prefab = self.transform:Find(_cp_heroSkill).gameObject
end

function ObjTroopBuffHeroInfoItem:SetData(herodata)
  local heroId = herodata.heroId
  local heroLv = herodata.heroLevel
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
  self._txtHeroName:SetText(heroname)
  local herolv = Localization:GetString("300665", heroLv)
  self._txtHeroLv:SetText(herolv)
  self:Recycle()
  local skillInfos = herodata.skillInfos or {}
  for _, skillInfo in pairs(skillInfos) do
    self:AddBuffItem(skillInfo)
  end
end

function ObjTroopBuffHeroInfoItem:AddBuffItem(skillInfoProto)
  local item = self._prefab:GameObjectSpawn(self._objSkillList.transform)
  NameCount = NameCount + 1
  item.name = NameCount
  local obj = self._objSkillList:AddComponent(ObjTroopBuffSkillItem, item.name)
  obj:SetData(skillInfoProto)
end

function ObjTroopBuffHeroInfoItem:Recycle()
  self._prefab.gameObject:GameObjectRecycleAll()
  self._objSkillList:RemoveComponents(ObjTroopBuffSkillItem)
end

function ObjTroopBuffHeroInfoItem:OnDestroy()
  self:Recycle()
end

return ObjTroopBuffHeroInfoItem
