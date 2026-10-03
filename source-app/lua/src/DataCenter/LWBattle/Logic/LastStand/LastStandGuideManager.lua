local LastStandGuideManager = BaseClass("LastStandGuideManager", CEventable)
local LastStandGuideTemplate = require("DataCenter.LWBattle.Logic.LastStand.LastStandGuideTemplate")

function LastStandGuideManager:__init(logic, groupId)
  self.logic = logic
  self.groupId = groupId
  self:TryInitGuideTemplate(groupId)
  self.enterTime = UITimeManager:GetInstance():GetServerSeconds()
  self.curGuideBuildingUid = nil
end

function LastStandGuideManager:OnUpdate(deltaTime)
  if self.curGuideStep == nil or self.guideList == nil or self.curGuideStep > #self.guideList then
    return
  end
  local guideInfo = self.guideList[self.curGuideStep]
  if guideInfo == nil then
    return
  end
  if guideInfo.IsTriggered == false then
    local canTrigger = self:CheckCondition(self.curGuideStep)
    if canTrigger then
      guideInfo.IsTriggered = true
      self.curGuideStep = self.curGuideStep + 1
      self.logic:HideGuideArrow()
      self.logic:HideGuideText()
      self:StopGuideEffect()
      self:DoAction(guideInfo)
    end
  end
end

function LastStandGuideManager:DoAction(guideInfo)
  if not (guideInfo and guideInfo.template) or table.IsNullOrEmpty(guideInfo.template.actionList) then
    return
  end
  for i, v in ipairs(guideInfo.template.actionList) do
    self:DoSingleAction(v)
  end
end

function LastStandGuideManager:DoSingleAction(actionInfo)
  local type = actionInfo.actionType
  if type == LastStandActionType.GuideToTarget then
    local targetPos = actionInfo.targetPos
    self.logic:ShowGuideArrow(targetPos)
    self:ShowGuideEffect(targetPos)
  elseif type == LastStandActionType.CreateSolider then
    local num = actionInfo.createSoliderNum or 1
    for i = 1, num do
      self.logic.buildingMgr:AddSoliderToArmyYard()
    end
  elseif type == LastStandActionType.ShowTips then
    self.logic:ShowGuideText(actionInfo.tipsId)
  end
end

function LastStandGuideManager:TryInitGuideTemplate(groupId)
  if self.guideTemplateDict == nil then
    self.guideTemplateDict = {}
    self.guideList = {}
    LocalController:instance():visitTable(TableName.lw_last_stand_guide, function(id, lineData)
      local groupID = lineData.group
      if groupID == groupId and self.guideTemplateDict[id] == nil and lineData ~= nil then
        local template = LastStandGuideTemplate.New()
        template:UpdateData(lineData)
        self.guideTemplateDict[id] = template
        local guideInfo = {IsTriggered = false, template = template}
        table.insert(self.guideList, guideInfo)
      end
    end)
    table.sort(self.guideList, function(a, b)
      return a.template.id < b.template.id
    end)
    if #self.guideList > 0 then
      self.curGuideStep = 1
    end
  end
end

function LastStandGuideManager:CheckCondition(step)
  local guideInfo = self.guideList[step]
  if guideInfo == nil then
    return false
  end
  local conditionList = guideInfo.template.conditionsList
  for i, v in ipairs(conditionList) do
    local type = v.conditionType
    local param = v.conditionParam
    local result = self:CheckConditionByType(type, param)
    if result == false then
      return false
    end
  end
  return true
end

function LastStandGuideManager:CheckConditionByType(type, param)
  if type == LastStandGuideConditionType.CoinEnough then
    local needCoin = param or 0
    local curCoin = self.logic:GetCoin()
    return needCoin <= curCoin
  elseif type == LastStandGuideConditionType.BuildingDone then
    local buildingId = param or 0
    local isBuildingDone = self.logic.buildingMgr:IsBuildingDone(buildingId)
    return isBuildingDone
  elseif type == LastStandGuideConditionType.EnterLevelTime then
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    local needTime = param or 0
    return needTime <= curTime - self.enterTime
  elseif type == LastStandGuideConditionType.SoliderNum then
    local needNum = param or 0
    local curNum = self.logic.team.teamUnitCount
    return needNum <= curNum
  elseif type == LastStandGuideConditionType.KillMonsterNum then
    local needNum = param or 0
    local curNum = self.logic:GetKillMonsterNum()
    return needNum <= curNum
  end
end

function LastStandGuideManager:ShowGuideEffect(pos)
  local nearestBuilding = self.logic.buildingMgr:GetNearestBuilding(pos)
  if nearestBuilding and nearestBuilding.ShowGuideAnim then
    nearestBuilding:ShowGuideAnim()
    self.curGuideBuildingUid = nearestBuilding.guid
  end
end

function LastStandGuideManager:StopGuideEffect()
  if self.curGuideBuildingUid then
    local building = self.logic.buildingMgr:GetBuildingByUid(self.curGuideBuildingUid)
    if building and building.StopGuideAnim then
      building:StopGuideAnim()
    end
    self.curGuideBuildingUid = nil
  end
end

return LastStandGuideManager
