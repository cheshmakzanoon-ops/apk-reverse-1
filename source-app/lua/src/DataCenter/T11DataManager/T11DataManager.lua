local T11DataManager = BaseClass("T11DataManager")
local T11LevelData = require("DataCenter.T11DataManager.T11LevelData")
local T11SoldierData = require("DataCenter.T11DataManager.T11SoldierData")
local T11PreviewData = require("DataCenter.T11DataManager.T11SoldierPreviewData")

local function __init(self)
  self.curStage = 0
  self.curProgressId = 0
  self.elevenCd = 0
  self.curT11LevelData = T11LevelData.New()
  self.soldierData = T11SoldierData.New()
  self.previewData = T11PreviewData.New()
  self.stageEquipIdsDic = nil
end

local function __delete(self)
  self.curStage = nil
  self.curProgressId = nil
  self.elevenCd = nil
  self.curT11LevelData = nil
  self.soldierData = nil
  self.previewData = nil
  self.stageEquipIdsDic = nil
end

function T11DataManager:InitData(t)
  self:InitMessage(t)
end

function T11DataManager:InitMessage(msg)
  local t11Info = msg.soldierElevenInfo
  if not t11Info then
    return
  end
  self:ParseStageEquipConfig()
  self:UpdateT11LvData(t11Info)
end

function T11DataManager:UpdateT11LvData(serverData)
  if not serverData then
    T11Util.ShowLog("T11DataManager:UpdateT11LvData serverData is nil")
    return
  end
  T11Util.ShowLog("T11DataManager:UpdateT11LvData")
  self.curStage = serverData.stage or 0
  self.curProgressId = serverData.progressId or 0
  self.elevenCd = serverData.elevenCd or 0
  self.power = serverData.power
  self.curT11LevelData:UpdateData(self.curStage, self.curProgressId)
end

function T11DataManager:ParseStageEquipConfig()
  if self.stageEquipIdsDic then
    return
  end
  self.stageEquipIdsDic = {}
  LocalController:instance():visitTable(TableName.T11_Equip_Config, function(id, lineData)
    if lineData ~= nil then
      local stage = lineData.stage
      local equipId = lineData.id
      local equipIdList = self.stageEquipIdsDic[stage]
      if not equipIdList then
        equipIdList = {}
        self.stageEquipIdsDic[stage] = equipIdList
      end
      table.insert(equipIdList, equipId)
    end
  end)
  for _, v in pairs(self.stageEquipIdsDic) do
    table.sort(v)
  end
end

function T11DataManager:GetCurBreakQueueInfo()
  local queueData = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.T11Break)
  return queueData
end

function T11DataManager:GetCurBreakQueueState()
  local queueData = self:GetCurBreakQueueInfo()
  if not queueData then
    return NewQueueState.Free
  end
  return queueData:GetQueueState()
end

function T11DataManager:GetCurT11UpgradeState()
  local curState = T11UnlockState.Unknown
  local isUnlockT11 = T11Util.IsUnlockT11()
  if not isUnlockT11 then
    curState = self:GetCurT11UnlockState()
  else
    curState = self:GetCurSkillUpgradeState()
  end
  return curState
end

function T11DataManager:GetCurT11UnlockState()
  local curState = T11UnlockState.Unknown
  local curBreakQueueState = self:GetCurBreakQueueState()
  if curBreakQueueState == NewQueueState.Free then
    local isInBreakableState = self.curT11LevelData:IsInBreakStageState()
    curState = isInBreakableState and T11UnlockState.T11Unlockable or T11UnlockState.T11UnlockProgressUpgrade
  else
    local isQueueFinish = curBreakQueueState == NewQueueState.Finish
    curState = isQueueFinish and T11UnlockState.T11UnlockConfirmComplete or T11UnlockState.T11Unlocking
  end
  return curState
end

function T11DataManager:GetCurSkillUpgradeState()
  if T11Util.IsMaxStage() then
    return T11UnlockState.T11MaxStage
  end
  local curState = T11UnlockState.Unknown
  local curBreakQueueState = self:GetCurBreakQueueState()
  if curBreakQueueState == NewQueueState.Free then
    local isInBreakableState = self.curT11LevelData:IsInBreakStageState()
    curState = isInBreakableState and T11UnlockState.SkillBreakable or T11UnlockState.SkillProgressUpgrade
  else
    local isQueueFinish = curBreakQueueState == NewQueueState.Finish
    curState = isQueueFinish and T11UnlockState.SkillBreakConfirmComplete or T11UnlockState.SkillBreaking
  end
  return curState
end

function T11DataManager:GetT11LvlData()
  return self.curT11LevelData
end

function T11DataManager:GetCurStageAllEquipIdList(stage)
  if not table.containsKey(self.stageEquipIdsDic, stage) then
    T11Util.ShowLog("T11DataManager:GetCurStageAllEquipIdList stageEquipIdsDic is nil")
    return {}
  end
  return self.stageEquipIdsDic[stage]
end

function T11DataManager:GetSoldierTmpData()
  return self.soldierData:GetAllSoldierDataTmpInfo()
end

function T11DataManager:GetPreviewData()
  return self.previewData:GetPreviewData()
end

function T11DataManager:UpdateNextSwitchTime(time)
  if not time or time <= 0 then
    Logger.LogError("T11DataManager:UpdateNextSwitchTime time is nil or less than 0")
    return
  end
  self.elevenCd = time
end

function T11DataManager:GetNextSwitchTime()
  if self.elevenCd <= 0 then
    return 0
  end
  return self.elevenCd
end

function T11DataManager:GetT11SearchPower()
  return self.power or 0
end

T11DataManager.__init = __init
T11DataManager.__delete = __delete
return T11DataManager
