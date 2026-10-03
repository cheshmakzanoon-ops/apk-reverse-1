local LWTrailTowerTemplateManager = BaseClass("LWTrailTowerTemplateManager")
local LWTrailTowerTemplate = require("DataCenter.LWTrailTowerManager.LWTrailTowerTemplate")
local LWTrailTowerBuffTemplate = require("DataCenter.LWTrailTowerManager.LWTrailTowerBuffTemplate")
local Localization = CS.GameEntry.Localization

function LWTrailTowerTemplateManager:__init()
  self.trailTowerTemplateDic = {}
  self.trailTowerBuffTemplateDic = {}
  self.initTrailTowerTemplate = false
  self.initTrailTowerBuffTemplate = false
end

function LWTrailTowerTemplateManager:__delete()
  self.trailTowerLevelTemplateDic = nil
  self.trailTowerBuffTemplateDic = nil
  self.initTrailTowerTemplate = nil
  self.initTrailTowerBuffTemplate = nil
end

function LWTrailTowerTemplateManager:Startup()
end

function LWTrailTowerTemplateManager:InitAllTemplate()
  self.initTrailTowerTemplate = true
  self.trailTowerTemplateDic = {}
  LocalController:instance():visitTable(TableName.LW_Trail_Tower, function(id, lineData)
    local item = LWTrailTowerTemplate.New()
    item:InitData(lineData)
    self.trailTowerTemplateDic[id] = item
  end)
end

function LWTrailTowerTemplateManager:InitBuffTemplate()
  self.initTrailTowerBuffTemplate = true
  self.trailTowerBuffTemplateDic = {}
  LocalController:instance():visitTable(TableName.LW_TrailTower_Buff, function(id, lineData)
    local item = LWTrailTowerBuffTemplate.New()
    item:InitData(lineData)
    self.trailTowerBuffTemplateDic[id] = item
  end)
end

function LWTrailTowerTemplateManager:GetTrailTowerTemplateById(trailTowerId)
  if not self.initTrailTowerTemplate then
    self:InitAllTemplate()
  end
  if self.trailTowerTemplateDic[trailTowerId] ~= nil then
    return self.trailTowerTemplateDic[trailTowerId]
  end
  return nil
end

function LWTrailTowerTemplateManager:GetTrailTowerLevelTemplateList(trailTowerId, levelGroup)
  local trailTowerTemplate = self:GetTrailTowerTemplateById(trailTowerId)
  if trailTowerTemplate ~= nil then
    return trailTowerTemplate:GetTrailTowerLevelTemplateList(levelGroup)
  end
  return nil
end

function LWTrailTowerTemplateManager:GetTrailTowerLevelTemplate(trailTowerId, levelGroup, targetStageId)
  local trailTowerTemplate = self:GetTrailTowerTemplateById(trailTowerId)
  if trailTowerTemplate ~= nil then
    return trailTowerTemplate:GetTrailTowerLevelTemplate(levelGroup, targetStageId)
  end
  return nil
end

function LWTrailTowerTemplateManager:GetTrailTowerLevelTemplateByOrder(trailTowerId, levelGroup, targetOrder)
  local trailTowerTemplate = self:GetTrailTowerTemplateById(trailTowerId)
  if trailTowerTemplate ~= nil then
    return trailTowerTemplate:GetTrailTowerLevelTemplateByOrder(levelGroup, targetOrder)
  end
  return nil
end

function LWTrailTowerTemplateManager:JudgeTrailTowerUnlockCondition(trailTowerId)
  local trailTowerTemplate = self:GetTrailTowerTemplateById(trailTowerId)
  local conditions = trailTowerTemplate ~= nil and trailTowerTemplate:GetCondition() or {}
  local isFinish = true
  local conditionTips = ""
  for i = 1, #conditions do
    local conditionData = conditions[i]
    if conditionData.conditionType == 1 then
      local trailTowerInfo = DataCenter.LWTrailTowerManager:GetTrailTowerInfoById(conditionData.param1)
      if trailTowerInfo ~= nil and trailTowerInfo.passGroup < conditionData.param2 then
        isFinish = false
        local targetTrailTowerTemplate = self:GetTrailTowerTemplateById(conditionData.param1)
        local trailTowerName = targetTrailTowerTemplate ~= nil and Localization:GetString(targetTrailTowerTemplate.name) or conditionData.param1
        conditionTips = Localization:GetString("trialtower_023", trailTowerName, conditionData.param2)
        break
      end
    end
  end
  return isFinish, conditionTips
end

function LWTrailTowerTemplateManager:GetCanShowTrailTowerBuffTemplateList()
  if not self.initTrailTowerBuffTemplate then
    self:InitBuffTemplate()
  end
  local displayBuffTemplateList = {}
  for k, trailTowerBuffTemplate in pairs(self.trailTowerBuffTemplateDic) do
    local isOpen = trailTowerBuffTemplate:IsOpen()
    local isEnd = trailTowerBuffTemplate:IsEnd()
    if isOpen and not isEnd then
      table.insert(displayBuffTemplateList, trailTowerBuffTemplate)
    end
  end
  return displayBuffTemplateList
end

return LWTrailTowerTemplateManager
