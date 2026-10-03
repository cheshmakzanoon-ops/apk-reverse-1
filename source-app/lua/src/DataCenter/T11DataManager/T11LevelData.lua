local T11LevelData = BaseClass("T11LevelData")
local T11StageData = require("DataCenter.T11DataManager.T11StageData")
local T11UpgradeData = require("DataCenter.T11DataManager.T11UpgradeData")
local T11EquipGroupData = require("DataCenter.T11DataManager.T11EquipGroupData")

local function __init(self)
  self.curProgressId = 0
  self.allEquipDataList = {}
  self.allStateConfigDic = {}
  self.stageData = T11StageData.New()
  self.upgradeData = T11UpgradeData.New()
  self.equipGroupData = T11EquipGroupData.New()
end

local function __delete(self)
  self.curProgressId = nil
  self.stageData = nil
  self.upgradeData = nil
  self.equipGroupData = nil
  self.allStateConfigDic = nil
end

function T11LevelData:UpdateData(stage, progressId)
  T11Util.ShowLog(string.format("T11LevelData.UpdateData stage:%s progressId:%s", stage, progressId))
  self.stageData:UpdateData(stage)
  self.upgradeData:UpdateData(progressId)
  self.equipGroupData:UpdateData(stage)
end

function T11LevelData:GetEquipGroupData()
  return self.equipGroupData
end

function T11LevelData:IsInBreakStageState()
  if not self.upgradeData then
    return false
  end
  return self.upgradeData:IsInBreakStageState()
end

T11LevelData.__init = __init
T11LevelData.__delete = __delete
return T11LevelData
