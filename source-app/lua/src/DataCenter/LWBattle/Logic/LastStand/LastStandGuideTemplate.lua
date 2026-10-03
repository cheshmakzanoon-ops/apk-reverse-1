local LastStandGuideTemplate = BaseClass("LastStandGuideTemplate")

function LastStandGuideTemplate:__init()
  self.id = 0
  self.group = 0
  self.conditions = ""
  self.action = 0
end

function LastStandGuideTemplate:__delete()
  self.id = nil
  self.group = nil
  self.conditions = nil
  self.action = nil
end

function LastStandGuideTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.group = rowData:getValue("group") or 0
  self.conditions = rowData:getValue("conditions") or ""
  self.action = rowData:getValue("action") or 0
  local allConditions = string.split(self.conditions, ";")
  self.conditionsList = {}
  for i, v in ipairs(allConditions) do
    local conditionInfo = {}
    local conditionsStrArr = string.split(v, "|")
    conditionInfo.conditionType = tonumber(conditionsStrArr[1]) or 0
    conditionInfo.conditionParam = tonumber(conditionsStrArr[2]) or 0
    table.insert(self.conditionsList, conditionInfo)
  end
  local allActions = string.split(self.action, ";")
  self.actionList = {}
  for i, v in ipairs(allActions) do
    local actionInfo = {}
    local actionStrArr = string.split(v, "|")
    actionInfo.actionType = tonumber(actionStrArr[1]) or 0
    if actionInfo.actionType == LastStandActionType.GuideToTarget then
      local posArr = string.split(actionStrArr[2], ",")
      actionInfo.targetPos = {}
      actionInfo.targetPos.x = tonumber(posArr[1]) or 0
      actionInfo.targetPos.y = 0
      actionInfo.targetPos.z = tonumber(posArr[2]) or 0
    elseif actionInfo.actionType == LastStandActionType.CreateSolider then
      actionInfo.createSoliderNum = tonumber(actionStrArr[2]) or 0
    elseif actionInfo.actionType == LastStandActionType.ShowTips then
      actionInfo.tipsId = actionStrArr[2] or ""
    end
    table.insert(self.actionList, actionInfo)
  end
end

return LastStandGuideTemplate
