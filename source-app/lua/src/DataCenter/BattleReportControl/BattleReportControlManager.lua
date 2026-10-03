local BattleReportControlManager = BaseClass("BattleReportControlManager")

local function __init(self)
  self:InitAllTemplate()
end

local function __delete(self)
end

local function InitAllTemplate(self)
  self.templateDict = {}
  LocalController:instance():visitTable(TableName.LW_Battle_Report_Control, function(id, lineData)
    if lineData ~= nil then
      self.templateDict[id] = {}
      self.templateDict[id][MailBattleReportType.City] = tonumber(lineData.vs_human)
      self.templateDict[id][MailBattleReportType.AllianceCity] = tonumber(lineData.vs_alliance_city)
      self.templateDict[id][MailBattleReportType.Jungle] = tonumber(lineData.vs_monster)
      self.templateDict[id][MailBattleReportType.ActBoss] = tonumber(lineData.vs_boss)
      self.templateDict[id][MailBattleReportType.Default] = tonumber(lineData.vs_default)
      self.templateDict[id][MailBattleReportType.RUNNING_BOSS_ATTACK_CITY] = tonumber(lineData.be_attacked_boss)
      self.templateDict[id][MailBattleReportType.BLOOD_QUEEN_MONSTER_ATTACK_CITY] = tonumber(lineData.be_attacked_boss)
      self.templateDict[id][MailBattleReportType.ZOMBIE_RUSH_BOSS_ATTACK_CITY] = tonumber(lineData.be_attacked_boss)
      self.templateDict[id][MailBattleReportType.DARK_KNIGHT_MONSTER_ATTACK_ALLIANCE_CITY] = tonumber(lineData.be_attacked_boss)
      self.templateDict[id][MailBattleReportType.ACT_BERSERK_BOSS] = tonumber(lineData.vs_boss)
      self.templateDict[id][MailBattleReportType.DARK_KNIGHT_MONSTER_ATTACK_ALLIANCE_BUILDING] = tonumber(lineData.be_attacked_boss)
      self.templateDict[id][MailBattleReportType.MUMMY_MONSTER_ATTACK_AL_BUILDING] = tonumber(lineData.be_attacked_boss)
      self.templateDict[id][MailBattleReportType.DARKNESS_MONSTER_ATTACK_CITY] = tonumber(lineData.be_attacked_boss)
      self.templateDict[id][MailBattleReportType.DARKNESS_MONSTER_ATTACK_AL_BUILDING] = tonumber(lineData.be_attacked_boss)
      self.templateDict[id][MailBattleReportType.BEHEMOTH_BOSS_ATTACK_ALLIANCE_CITY] = tonumber(lineData.be_attacked_boss)
      self.templateDict[id][MailBattleReportType.BEHEMOTH_BOSS_ATTACK_BOSS] = tonumber(lineData.be_attacked_boss)
      self.templateDict[id][MailBattleReportType.MONSTER_INVASION_BOSS] = tonumber(lineData.vs_boss)
      self.templateDict[id][MailBattleReportType.ALLIANCE_BOSS] = tonumber(lineData.vs_boss)
      self.templateDict[id][MailBattleReportType.SANDWORM] = tonumber(lineData.vs_monster)
      self.templateDict[id][MailBattleReportType.SANDWORM_SMALL] = tonumber(lineData.vs_monster)
      self.templateDict[id][MailBattleReportType.MUSE_MUMMY] = tonumber(lineData.be_attacked_boss)
      self.templateDict[id][MailBattleReportType.MUMMY_PATROL] = tonumber(lineData.be_attacked_boss)
      self.templateDict[id][MailBattleReportType.ALLIANCE_MONSTER_CHALLENGE_KIROV] = tonumber(lineData.vs_boss)
      self.templateDict[id][MailBattleReportType.CITY_BATTLE_S1_REST_ATTACK_MONSTER] = tonumber(lineData.vs_boss)
      self.templateDict[id][MailBattleReportType.ALLIANCE_BOSS_S0] = tonumber(lineData.vs_monster)
    end
  end)
end

local function NeedShow(self, region, mailType)
  if region == UIMailRegion.ReplayBtn then
    if mailType == MailBattleReportType.AllianceCity or mailType == MailBattleReportType.CITY_STRONGHOLD or mailType == MailBattleReportType.ROB_STRONGHOLD_BANK then
      return false
    end
    if mailType == MailBattleReportType.SEASON_DESERT_BATTLE or mailType == MailBattleReportType.SEASON_AL_BUILDING_BATTLE then
      return false
    end
  end
  if not (region and mailType) or not self.templateDict[region] then
    return true
  end
  if self.templateDict[region][mailType] then
    return self.templateDict[region][mailType] > 0
  end
  return 0 < self.templateDict[region][MailBattleReportType.Default]
end

BattleReportControlManager.__init = __init
BattleReportControlManager.__delete = __delete
BattleReportControlManager.InitAllTemplate = InitAllTemplate
BattleReportControlManager.NeedShow = NeedShow
return BattleReportControlManager
