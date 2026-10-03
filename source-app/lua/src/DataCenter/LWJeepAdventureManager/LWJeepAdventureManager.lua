local LWJeepAdventureManager = BaseClass("LWJeepAdventureManager")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.isBattleBackMark = nil
  self.pageType = nil
end

local function __delete(self)
  self.isBattleBackMark = nil
  self.pageType = nil
end

local function GetStageMetaByType(self, stageId, pageType)
  if pageType == JeepAdventurePageType.TowerUp then
    return DataCenter.TowerUpTemplateManager:GetTowerUpUnlockTemplate(stageId)
  elseif pageType == JeepAdventurePageType.Domintor then
    return DataCenter.DominatorUpTemplateManager:GetDominatorUpUnlockTemplate(stageId)
  end
end

local function GetCurStageIdByType(self, pageType)
  if pageType == JeepAdventurePageType.TowerUp then
    return DataCenter.LWTowerUpStageManager:GetCurStageId()
  elseif pageType == JeepAdventurePageType.Domintor then
    return DataCenter.LWDominatorUpStageManager:GetCurStageId()
  end
end

local function GetUnGetRewardNumByType(self, checkId, pageType)
  if pageType == JeepAdventurePageType.TowerUp then
    return DataCenter.LWTowerUpStageManager:GetUnGetRewardNum(checkId)
  elseif pageType == JeepAdventurePageType.Domintor then
    return DataCenter.LWDominatorUpStageManager:GetUnGetRewardNum(checkId)
  end
end

local function GetRankTypeByPageType(self, pageType)
  if pageType == JeepAdventurePageType.TowerUp then
    return RankingTypeServer.PVE_STAGE
  elseif pageType == JeepAdventurePageType.Domintor then
    return RankingTypeServer.DOMINATOR_UP_PVE
  end
end

local function CanGetFirstReward(self, checkId, pageType)
  if pageType == JeepAdventurePageType.TowerUp then
    return DataCenter.LWTowerUpStageManager:CanGetFirstReward(checkId)
  elseif pageType == JeepAdventurePageType.Domintor then
    return DataCenter.LWDominatorUpStageManager:CanGetFirstReward(checkId)
  end
end

local function EnterBattle(self, curStageId, pageType)
  local targetStageId = curStageId
  self.pageType = pageType
  local targetStageMeta = DataCenter.LWJeepAdventureManager:GetStageMetaByType(targetStageId, pageType)
  if targetStageMeta then
    if targetStageMeta.type == TowerupBattleType.Zombie then
      local levelId = targetStageMeta.level_id
      DataCenter.ZombieBattleManager:Destroy()
      DataCenter.LWBattleManager:Destroy()
      local param = {}
      param.type = PVEType.Barrage
      param.enterType = PVEEnterType.TowerupJeepAdventure
      param.levelId = levelId
      param.extraData = {}
      param.extraData.cfgId = targetStageId
      param.extraData.pageType = pageType
      DataCenter.ZombieBattleManager:Enter(param)
    elseif targetStageMeta.type == TowerupBattleType.FakePVP then
      DataCenter.ZombieBattleManager:Destroy()
      DataCenter.LWBattleManager:Destroy()
      local levelId = targetStageMeta.level_id
      local param = {}
      param.type = PVEType.FakePVP
      param.enterType = PVEEnterType.TowerupJeepAdventure
      param.levelId = levelId
      param.sceneId = targetStageMeta.scene_id
      param.extraData = {}
      param.extraData.cfgId = targetStageId
      param.extraData.pageType = pageType
      DataCenter.LWBattleManager:Enter(param)
    elseif targetStageMeta.type == TowerupBattleType.Parkour then
      DataCenter.ZombieBattleManager:Destroy()
      DataCenter.LWBattleManager:Destroy()
      local levelId = targetStageMeta.level_id
      local param = {}
      param.type = PVEType.Parkour
      param.enterType = PVEEnterType.TowerupJeepAdventure
      param.levelId = levelId
      param.extraData = {}
      param.extraData.cfgId = targetStageId
      param.extraData.pageType = pageType
      DataCenter.LWBattleManager:Enter(param)
    end
  end
end

local function GetDetailParam(self, pageType)
  if pageType == JeepAdventurePageType.TowerUp then
    return {
      activityRulesStr = Localization:GetString("456812")
    }
  elseif pageType == JeepAdventurePageType.Domintor then
    return {
      activityRulesStr = Localization:GetString("armed_truck_dominator_rule")
    }
  end
end

local function GetNowUnGetRewardNumByType(self, pageType)
  local checkId = self:GetCurStageIdByType(pageType)
  return self:GetUnGetRewardNumByType(checkId, pageType)
end

local function GetNearlyFirstRewardByType(self, pageType)
  if pageType == JeepAdventurePageType.TowerUp then
    return DataCenter.LWTowerUpStageManager:GetNearlyFirstReward()
  elseif pageType == JeepAdventurePageType.Domintor then
    return DataCenter.LWDominatorUpStageManager:GetNearlyFirstReward()
  end
end

local function GetFirstRewardStageByType(self, pageType)
  if pageType == JeepAdventurePageType.TowerUp then
    return DataCenter.TowerUpTemplateManager:GetFirstRewardStage()
  elseif pageType == JeepAdventurePageType.Domintor then
    return DataCenter.DominatorUpTemplateManager:GetFirstRewardStage()
  end
end

local function GetStageFirstRewardType(self, checkId, pageType)
  if pageType == JeepAdventurePageType.TowerUp then
    return DataCenter.LWTowerUpStageManager:GetStageFirstRewardType(checkId)
  elseif pageType == JeepAdventurePageType.Domintor then
    return DataCenter.LWDominatorUpStageManager:GetStageFirstRewardType(checkId)
  end
end

local function GetCanSweepByType(self, pageType)
  if pageType == JeepAdventurePageType.TowerUp then
    local unlockStageId = LuaEntry.DataConfig:TryGetNum("stage_idle_reward", "k7")
    local can = true
    local str
    if unlockStageId > DataCenter.LWTowerUpStageManager:GetCurStageId() then
      can = false
      local cfg = self:GetStageMetaByType(unlockStageId, pageType)
      str = Localization:GetString("armed_truck_reward_setting_battle_1", cfg:GetName())
    elseif not DataCenter.TowerUpSaveDataManager:IsCanAutoNextStageTowerUp() then
      can = false
      str = Localization:GetString("armed_truck_reward_setting_battle_car")
    end
    return can, str
  elseif pageType == JeepAdventurePageType.Domintor then
    return DataCenter.TowerUpSaveDataManager:IsCanAutoNextStageDominator(), Localization:GetString("armed_truck_reward_setting_battle")
  end
end

local function OneClickSweepByType(self, cfgId, pageType)
  if pageType == JeepAdventurePageType.TowerUp then
    SFSNetwork.SendMessage(MsgDefines.LWSaveTowerupRecord, cfgId, 1)
  elseif pageType == JeepAdventurePageType.Domintor then
    SFSNetwork.SendMessage(MsgDefines.LWSaveDominatorUpRecord, cfgId, 1)
  end
end

local function GetCurStageMetaByType(self, pageType)
  return self:GetStageMetaByType(self:GetCurStageIdByType(pageType), pageType)
end

local function GetLastFirstRewardByType(self, pageType)
  if pageType == JeepAdventurePageType.TowerUp then
    return DataCenter.LWTowerUpStageManager:GetLastFirstReward()
  elseif pageType == JeepAdventurePageType.Domintor then
    return DataCenter.LWDominatorUpStageManager:GetLastFirstReward()
  end
end

local function GetBackSwitchOn(self)
  return LuaEntry.DataConfig:CheckSwitch("truck_scene_return")
end

local function SetBattleBackMark(self, mark)
  self.isBattleBackMark = mark
end

local function GetBattleBackMark(self)
  local mark = self.isBattleBackMark
  self.isBattleBackMark = nil
  return mark
end

LWJeepAdventureManager.__init = __init
LWJeepAdventureManager.__delete = __delete
LWJeepAdventureManager.GetStageMetaByType = GetStageMetaByType
LWJeepAdventureManager.GetCurStageIdByType = GetCurStageIdByType
LWJeepAdventureManager.GetUnGetRewardNumByType = GetUnGetRewardNumByType
LWJeepAdventureManager.GetRankTypeByPageType = GetRankTypeByPageType
LWJeepAdventureManager.CanGetFirstReward = CanGetFirstReward
LWJeepAdventureManager.EnterBattle = EnterBattle
LWJeepAdventureManager.GetDetailParam = GetDetailParam
LWJeepAdventureManager.GetNowUnGetRewardNumByType = GetNowUnGetRewardNumByType
LWJeepAdventureManager.GetNearlyFirstRewardByType = GetNearlyFirstRewardByType
LWJeepAdventureManager.GetFirstRewardStageByType = GetFirstRewardStageByType
LWJeepAdventureManager.GetStageFirstRewardType = GetStageFirstRewardType
LWJeepAdventureManager.GetCanSweepByType = GetCanSweepByType
LWJeepAdventureManager.OneClickSweepByType = OneClickSweepByType
LWJeepAdventureManager.GetCurStageMetaByType = GetCurStageMetaByType
LWJeepAdventureManager.GetLastFirstRewardByType = GetLastFirstRewardByType
LWJeepAdventureManager.GetBackSwitchOn = GetBackSwitchOn
LWJeepAdventureManager.SetBattleBackMark = SetBattleBackMark
LWJeepAdventureManager.GetBattleBackMark = GetBattleBackMark
return LWJeepAdventureManager
