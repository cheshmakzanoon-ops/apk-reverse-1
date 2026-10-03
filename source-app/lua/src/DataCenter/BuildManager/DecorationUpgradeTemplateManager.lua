local DecorationUpgradeTemplateManager = BaseClass("DecorationUpgradeTemplateManager")
local DecorationBuildingUpgradeTemplate = require("DataCenter.BuildManager.DecorationBuildingUpgradeTemplate")

local function __init(self)
  self.decoGroupDetailDic = {}
  self.decoGroupProgressDic = {}
  self.isInitialized = false
end

local function __delete(self)
  self.decoGroupDetailDic = nil
  self.decoGroupProgressDic = nil
  self.isInitialized = nil
end

local function InitData(self)
  self.decoGroupDetailDic = {}
  LocalController:instance():visitTable(TableName.DECORATION_UPGRADE, function(id, lineData)
    local templateData = DecorationBuildingUpgradeTemplate.New()
    templateData:UpdateData(lineData)
    local group = templateData.group
    if not group then
      return
    end
    local groupDetailDic = self.decoGroupDetailDic[group]
    if not groupDetailDic then
      groupDetailDic = {}
      self.decoGroupDetailDic[group] = groupDetailDic
    end
    local groupDataList = self.decoGroupProgressDic[group]
    if not groupDataList then
      groupDataList = {}
      self.decoGroupProgressDic[group] = groupDataList
    end
    table.insert(groupDataList, templateData)
    local bLv = templateData.level
    local lvDic = groupDetailDic[bLv]
    if not lvDic then
      lvDic = {}
      groupDetailDic[bLv] = lvDic
    end
    local progressIndex = templateData.progressIndex
    lvDic[progressIndex] = templateData
  end)
  self.isInitialized = true
end

local function GetGroupInfo(self, groupId)
  if not self.isInitialized then
    self:InitData()
  end
  return self.decoGroupDetailDic[groupId]
end

local function GetLvInfo(self, groupId, lv)
  if not self.isInitialized then
    self:InitData()
  end
  local groupInfo = self:GetGroupInfo(groupId)
  if not groupInfo then
    return nil
  end
  return groupInfo[lv]
end

local function GetProgressInfo(self, groupId, lv, progressIndex)
  if not self.isInitialized then
    self:InitData()
  end
  local lvInfo = self:GetLvInfo(groupId, lv)
  if not lvInfo then
    return nil
  end
  return lvInfo[progressIndex]
end

local function GetMaxProgressInfo(self, groupId, lv)
  if not self.isInitialized then
    self:InitData()
  end
  local ret
  local allProgressList = self:GetLvInfo(groupId, lv)
  if not allProgressList then
    return ret
  end
  for _, v in pairs(allProgressList) do
    if not ret or v.progressIndex > ret.progressIndex then
      ret = v
    end
  end
  return ret
end

local function GetAllDataListByGroupId(self, groupId)
  if not self.isInitialized then
    self:InitData()
  end
  return self.decoGroupProgressDic[groupId]
end

local function GetLvAndStageInfoByProgress(self, groupId, level, progress, isAutoLvUp)
  if not self.isInitialized then
    self:InitData()
  end
  local curTmpData
  local allLvProgressInfoList = self:GetLvInfo(groupId, level)
  if allLvProgressInfoList then
    for _, v in ipairs(allLvProgressInfoList) do
      local curStageNeedProgress = v.stage_need
      if progress < curStageNeedProgress or not isAutoLvUp and progress <= curStageNeedProgress then
        curTmpData = v
        break
      end
    end
  end
  return curTmpData
end

local function GetSingleStarEffect(self, groupId, level, progressIndex)
  local curProgressInfo = self:GetProgressInfo(groupId, level, progressIndex)
  local prevIndexProgressInfo = self:GetProgressInfo(groupId, level, progressIndex - 1)
  local curStarEff = curProgressInfo:GetEffectFromStar()
  if not prevIndexProgressInfo or not prevIndexProgressInfo:GetEffectFromStar() then
    return curStarEff
  end
  local prevStarEff = prevIndexProgressInfo:GetEffectFromStar()
  local deltaStarEff = curStarEff
  for k, v in pairs(deltaStarEff) do
    local effectId = k
    local val = v
    if table.containsKey(prevStarEff, effectId) then
      val = val - prevStarEff[effectId]
      deltaStarEff[effectId] = val
    end
  end
  return deltaStarEff
end

DecorationUpgradeTemplateManager.__init = __init
DecorationUpgradeTemplateManager.__delete = __delete
DecorationUpgradeTemplateManager.InitData = InitData
DecorationUpgradeTemplateManager.GetGroupInfo = GetGroupInfo
DecorationUpgradeTemplateManager.GetLvInfo = GetLvInfo
DecorationUpgradeTemplateManager.GetProgressInfo = GetProgressInfo
DecorationUpgradeTemplateManager.GetMaxProgressInfo = GetMaxProgressInfo
DecorationUpgradeTemplateManager.GetAllDataListByGroupId = GetAllDataListByGroupId
DecorationUpgradeTemplateManager.GetLvAndStageInfoByProgress = GetLvAndStageInfoByProgress
DecorationUpgradeTemplateManager.GetSingleStarEffect = GetSingleStarEffect
return DecorationUpgradeTemplateManager
