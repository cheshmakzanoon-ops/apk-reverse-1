local MailBattleReportPVPHelper = require("DataCenter.MailData.DataExtModule.MailBattleReportPVPHelper")
local MailBattleReportPVEHelper = BaseClass("MailBattleReportPVEHelper", MailBattleReportPVPHelper)
local base = MailBattleReportPVPHelper
local MailBattleParseHelper = require("DataCenter.MailData.MailBattleParseHelper")

function MailBattleReportPVEHelper:__init()
  base.__init(self)
  self.monsterLevelList = {}
  self.monsterSkillStarList = {}
  self.monsterCampList = {}
  self.monsterSkillLevelList = {}
  self.monsterSoldierLevelList = {}
  self.hasResistance = 0
  self.needResistance = 0
  self.monsterHeroStar = 0
  self.pveType = MailPVEType.NormalMonster
  self.templateType = 1
end

function MailBattleReportPVEHelper:__delete()
  self.monsterLevelList = nil
  self.monsterSkillStarList = nil
  self.monsterCampList = nil
  self.monsterSkillLevelList = nil
  self.monsterSoldierLevelList = nil
  self.hasResistance = nil
  self.needResistance = nil
  self.monsterHeroStar = nil
  self.pveType = nil
  self.templateType = nil
  base.__delete(self)
end

local function InitDataByLWArmyId(self, armyId)
  local armyTemplate = DataCenter.LWArmyTemplateManager:GetArmyTemplate(armyId)
  if armyTemplate then
    self.enemyTacticalBattlePower = armyTemplate.rec_uav_power
    self.enemyHeroEquipmentBattlePower = armyTemplate.rec_equip_power
    self.enemyTechBattlePower = armyTemplate.rec_sci_power
    self.enemyHonorWallBattlePower = armyTemplate.rec_honor_power
    if armyTemplate.line_up then
      for i = 1, table.count(armyTemplate.line_up) do
        if armyTemplate.line_up[i] then
          local heroData = armyTemplate.line_up[i].heroData
          table.insert(self.monsterLevelList, heroData.level)
          table.insert(self.monsterSkillStarList, heroData.skillStar)
          table.insert(self.monsterSkillLevelList, heroData.skillLevel)
          local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(heroData.metaId)
          table.insert(self.monsterCampList, heroTemplate.type)
          local soldierData = armyTemplate.line_up[i].soldierData
          local soldierDataTemplate = DataCenter.SoldierDataManager:GetTemplate(soldierData.metaId)
          table.insert(self.monsterSoldierLevelList, soldierDataTemplate.lv)
          self.monsterHeroStar = self.monsterHeroStar + heroData.rank
        end
      end
    end
  end
end

function MailBattleReportPVEHelper:Init(battleReport, player, hero, weapon, isSolo)
  base.Init(self, battleReport, player, hero, weapon, isSolo)
  local battlePlayer
  if isSolo then
    battlePlayer = battleReport.player
  else
    battlePlayer = battleReport.pb_BattleReport.player
  end
  for k, p in pairs(battlePlayer) do
    if not p.user then
      local monsterArmyType = p.armyType
      if monsterArmyType == MailTargetType.Monster then
        local monsterId = p.contentId
        local monsterTemplate = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterId)
        if monsterTemplate then
          if monsterTemplate.type == 3 and monsterTemplate.special == 0 then
            self.pveType = MailPVEType.MonsterBoss
          elseif monsterTemplate.type == 8 and monsterTemplate.special == 11 then
            self.pveType = MailPVEType.WalkMonsterBoss
          elseif monsterTemplate.type == 1 or monsterTemplate.type == 2 or monsterTemplate.type == 5 then
            self.pveType = MailPVEType.NormalMonster
          elseif monsterTemplate.type == 7 then
            self.pveType = MailPVEType.MonsterInvasion
          elseif monsterTemplate.type == 3 and monsterTemplate.special == 7 then
            self.pveType = MailPVEType.GeneralTrialAllyBoss
          elseif monsterTemplate.type == 5 and monsterTemplate.special == 6 then
            self.pveType = MailPVEType.GeneralTrialNormal
          end
        end
      elseif monsterArmyType == MailTargetType.SeasonDesert then
        self.pveType = MailPVEType.SeasonLand
      elseif monsterArmyType == MailTargetType.AllianceCity then
        self.pveType = MailPVEType.CityMonster
      end
    end
  end
  for k, p in pairs(player) do
    if not p.user then
      local monsterArmyType = p.armyType
      if monsterArmyType == MailTargetType.Monster then
      elseif monsterArmyType == MailTargetType.SeasonDesert then
        local desertTemplate = DataCenter.DesertTemplateManager:GetTemplate(p.contentId)
        if desertTemplate then
          local armyId = desertTemplate.desert_army
          InitDataByLWArmyId(self, armyId)
        end
      elseif monsterArmyType == MailTargetType.Army then
        local armyId = p.contentId
        InitDataByLWArmyId(self, armyId)
      end
      if p.effects then
        table.walk(p.effects, function(k, v)
          if v.effectId == EffectDefine.APS_SEASON_DESERT_RESISTANCE then
            self.needResistance = v.value or 0
          end
        end)
      end
    elseif p.effects then
      table.walk(p.effects, function(k, v)
        if v.effectId == EffectDefine.APS_SEASON_DESERT_RESISTANCE then
          self.hasResistance = v.value or 0
        end
      end)
    end
  end
  self.initSuccess = true
end

return MailBattleReportPVEHelper
