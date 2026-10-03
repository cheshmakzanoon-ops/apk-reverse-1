local WorkerRankTemplateManager = BaseClass("WorkerRankTemplateManager")
local WorkerRankTemplate = require("DataCenter.WorkerData.WorkerRankTemplate")
local RankCfgSplitNum = 100

local function __init(self)
  local vipWorkerIds = {13303, 13304}
  local vipWorkerRankIds = {51123, 51124}
  self.vipWorkerIdToRankId = {}
  self.vipWorkerRankIdToId = {}
  for i, vipWorkerId in ipairs(vipWorkerIds) do
    self.vipWorkerIdToRankId[vipWorkerId] = vipWorkerRankIds[i]
    self.vipWorkerRankIdToId[vipWorkerRankIds[i]] = vipWorkerId
  end
  self.templateDic = nil
end

local function __delete(self)
  self.templateDic = nil
end

local function RankIdToWorkerId(self, rankId)
  local workerId = rankId
  if self.vipWorkerRankIdToId[rankId] then
    workerId = self.vipWorkerRankIdToId[rankId]
  end
  return workerId
end

local function WorkerIdToRankId(self, workerId)
  local rankId = workerId
  if self.vipWorkerIdToRankId[workerId] then
    rankId = self.vipWorkerIdToRankId[workerId]
  end
  return rankId
end

local function CfgIdToRankId(self, cfgId)
  local rankId = math.floor(cfgId / RankCfgSplitNum)
  return rankId
end

local function GetTemplateByIdAndRank(self, id, rank)
  if self.templateDic == nil then
    self.templateDic = {}
  end
  if self.templateDic[id] == nil then
    self.templateDic[id] = {}
  end
  if self.templateDic[id][rank] == nil then
    local rankId = self:WorkerIdToRankId(id)
    local cfgId = rankId * RankCfgSplitNum + rank
    local lineData = LocalController:instance():getLine(TableName.LW_Worker_Rank, cfgId)
    if lineData then
      local item = WorkerRankTemplate.New()
      item:InitData(lineData)
      self.templateDic[id][rank] = item
    end
  end
  return self.templateDic[id][rank]
end

WorkerRankTemplateManager.__init = __init
WorkerRankTemplateManager.__delete = __delete
WorkerRankTemplateManager.RankIdToWorkerId = RankIdToWorkerId
WorkerRankTemplateManager.WorkerIdToRankId = WorkerIdToRankId
WorkerRankTemplateManager.CfgIdToRankId = CfgIdToRankId
WorkerRankTemplateManager.GetTemplateByIdAndRank = GetTemplateByIdAndRank
return WorkerRankTemplateManager
