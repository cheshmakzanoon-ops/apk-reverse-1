local TowerUpBaseTemplate = BaseClass("TowerUpBaseTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.id = -1
  self.isElite = false
  self.type = -1
  self.level_id = -1
  self.scene_id = -1
  self.idle_reward_stageid = -1
  self.first_rewarad = nil
  self.seasonData = nil
  self.reward_show = nil
end

local function __delete(self)
  self.id = nil
  self.isElite = nil
  self.type = nil
  self.level_id = nil
  self.scene_id = nil
  self.idle_reward_stageid = nil
  self.first_rewarad = nil
  self.seasonData = nil
  self.reward_show = nil
  self.rewardShowDataList = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  local isElite = row:getValue("is_elite")
  self.isElite = isElite == 1
  self.type = row:getValue("type")
  self.level_id = row:getValue("level_id")
  local scene_id = row:getValue("scene_id")
  if string.IsNullOrEmpty(scene_id) then
    self.scene_id = 0
  else
    self.scene_id = toInt(scene_id)
  end
  self.idle_reward_stageid = row:getValue("idle_reward_stageid")
  local first_rewarad = row:getValue("first_reward")
  if not string.IsNullOrEmpty(first_rewarad) then
    self.first_rewarad = tonumber(first_rewarad)
  end
  local season_condition = row:getValue("season_condition")
  if not string.IsNullOrEmpty(season_condition) then
    local split = string.split(season_condition, "|")
    self.season_condition = {}
    self.season_condition.season = split[1]
    self.season_condition.day = split[2]
  end
  self.reward_show = row:getValue("first_reward_show") or ""
end

local function GetName(self)
  local id = -1
  local line = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage), self.idle_reward_stageid)
  if line then
    id = line.level
  end
  return id
end

local function IsUnlock(self)
  local unlock = true
  if self.season_condition then
    unlock = DataCenter.SeasonDataManager:CheckNowSeasonArrive(self.season_condition.season, self.season_condition.day)
  end
  return unlock
end

local function GetStageRewardShowData(self)
  if self.rewardShowDataList == nil then
    self.rewardShowDataList = DataCenter.RewardManager:ParseRewardsStr(self.reward_show)
  end
  return self.rewardShowDataList
end

TowerUpBaseTemplate.__init = __init
TowerUpBaseTemplate.__delete = __delete
TowerUpBaseTemplate.InitData = InitData
TowerUpBaseTemplate.GetName = GetName
TowerUpBaseTemplate.IsUnlock = IsUnlock
TowerUpBaseTemplate.GetStageRewardShowData = GetStageRewardShowData
return TowerUpBaseTemplate
