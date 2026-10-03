local T11StageData = BaseClass("T11StageData")
local T11StageTemplate = require("DataCenter.T11DataManager.Template.T11StageTemplate")

local function __init(self)
  self.curStageTmp = nil
  self.curStage = nil
  self.allStateConfigDic = {}
  self.minStage = 9999
  self.maxStage = 0
  self.stageList = {}
end

local function __delete(self)
  self.curStageTmp = nil
  self.curStage = nil
  self.allStateConfigDic = nil
  self.minStage = nil
  self.maxStage = nil
  self.stageList = nil
end

function T11StageData:UpdateData(stage)
  self.curStage = stage
  self:InitStageData()
  if 0 < stage then
    self.curStageTmp = self:GetTmpByStage(stage)
  else
    self.curStageTmp = nil
  end
  T11Util.ShowLog("T11StageData:UpdateData curStage:" .. stage)
end

function T11StageData:GetCurStage()
  return self.curStage or 0
end

function T11StageData:GetCurStageTmp()
  return self.curStageTmp
end

function T11StageData:GetNextStageTmp()
  local nextStage = self:GetCurStage() + 1
  return self:GetTmpByStage(nextStage)
end

function T11StageData:GetNextStageUpgradeCostData()
  local nextStageTmp = self:GetNextStageTmp()
  if not nextStageTmp then
    Logger.LogError("T11StageData:GetNextStageUpgradeCostData nextStageTmp is nil")
    return
  end
  return nextStageTmp:GetCostDataAfterParse()
end

function T11StageData:GetTmpByStage(stage)
  if not table.containsKey(self.allStateConfigDic, stage) then
    T11Util.ShowLog("T11StageData:GetTmpByStage allStateConfigDic not contain stage:" .. stage)
    return
  end
  return self.allStateConfigDic[stage]
end

function T11StageData:InitStageData()
  if table.IsNullOrEmpty(self.allStateConfigDic) then
    self.allStateConfigDic = {}
    LocalController:instance():visitTable(TableName.T11_Stage_Config, function(id, lineData)
      if lineData ~= nil then
        local template = T11StageTemplate.New()
        template:UpdateData(lineData)
        local tStage = template.stage
        self.allStateConfigDic[tStage] = template
        self.minStage = math.min(self.minStage, tStage)
        self.maxStage = math.max(self.maxStage, tStage)
        table.insert(self.stageList, tStage)
      end
    end)
  end
end

function T11StageData:GetMinStage()
  return self.minStage or 0
end

function T11StageData:GetMaxStage()
  return self.maxStage or 0
end

function T11StageData:GetStageList()
  return self.stageList or {}
end

T11StageData.__init = __init
T11StageData.__delete = __delete
return T11StageData
