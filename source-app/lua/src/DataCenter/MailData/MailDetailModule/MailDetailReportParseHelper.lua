local BuffMgr = require("DataCenter.MailData.MailDetailModule.MailDetailBuffMgr")
local ActionItem = require("DataCenter.MailData.MailDetailModule.MailDetailActionItem")
local MailDetailReportParseHelper = {}

function MailDetailReportParseHelper:InitData()
  self._minIndex = 0
  self._maxIndex = 0
  self._allDetails = {}
  self._healthList = {}
end

function MailDetailReportParseHelper:AddEffectData(effectlist, roundIdx)
  if self._allDetails[roundIdx] == nil then
    self._allDetails[roundIdx] = {}
  end
  self._allDetails[roundIdx].BUFF = effectlist
end

function MailDetailReportParseHelper:AddActionData(actionlist, roundIdx)
  if self._allDetails[roundIdx] == nil then
    self._allDetails[roundIdx] = {}
  end
  self._allDetails[roundIdx].ACTION = actionlist
end

function MailDetailReportParseHelper:AddLeftSpecialSkill(skillList, roundIdx)
  if skillList == nil or #skillList <= 0 then
    return
  end
  if self._allDetails[roundIdx] == nil then
    self._allDetails[roundIdx] = {}
  end
  self._allDetails[roundIdx].SPECIAL_SELF = skillList
end

function MailDetailReportParseHelper:AddRightSpecialSkill(skillList, roundIdx)
  if skillList == nil or #skillList <= 0 then
    return
  end
  if self._allDetails[roundIdx] == nil then
    self._allDetails[roundIdx] = {}
  end
  self._allDetails[roundIdx].SPECIAL_OTHER = skillList
end

function MailDetailReportParseHelper:SetIndexRange(detailData)
  local roundReports = self._roundReports
  local effectReports = self._effectReports
  if not table.IsNullOrEmpty(roundReports) then
    self._minIndex = roundReports[1].round
    self._maxIndex = roundReports[#roundReports].round
  end
  if not table.IsNullOrEmpty(effectReports) then
    local e_minIndex = effectReports[1].baseReport.round
    local e_maxIndex = effectReports[#effectReports].baseReport.round
    self._minIndex = e_minIndex < self._minIndex and e_minIndex or self._minIndex
    self._maxIndex = e_maxIndex < self._maxIndex and self._maxIndex or e_maxIndex
  end
end

function MailDetailReportParseHelper:GetActionList(findIndex)
  local roundList = {}
  
  local function InsertActionItem(actionItem)
    local tbCnt = table.count(roundList)
    if tbCnt == 0 then
      return false
    end
    for i = tbCnt, 1, -1 do
      local _action = roundList[i]
      if _action:IsBelongThisSkill(actionItem) then
        _action:AddSkillTarget(actionItem)
        return true
      end
    end
    return false
  end
  
  for key, reportItem in pairs(self._roundReports) do
    if reportItem ~= nil and reportItem.round == findIndex then
      local actionItem = ActionItem.New()
      actionItem:InitData(reportItem, self._playerInfos)
      if actionItem:IsSubActionItem() then
        local a = 1
      end
      if actionItem:IsSubActionItem() and InsertActionItem(actionItem) then
      else
        roundList[#roundList + 1] = actionItem
      end
      self._roundReports[key] = nil
    elseif reportItem ~= nil and findIndex < reportItem.round then
      break
    end
  end
  return roundList
end

function MailDetailReportParseHelper:GetEffectList(findIndex)
  local effectList = {}
  for key, effectItem in pairs(self._effectReports) do
    if effectItem ~= nil and effectItem.baseReport ~= nil and effectItem.baseReport.round == findIndex then
      effectList[#effectList + 1] = effectItem
      self._roundReports[key] = nil
    elseif effectItem ~= nil and effectItem.baseReport ~= nil and findIndex < effectItem.baseReport.round then
      break
    end
  end
  return effectList
end

function MailDetailReportParseHelper:InitPlayerInfo(playerInfos)
  playerInfos = playerInfos or {}
  if self._playerInfos == nil then
    self._playerInfos = {}
  end
  for _, userinfo in pairs(playerInfos) do
    self._playerInfos[userinfo.index] = userinfo
  end
end

function MailDetailReportParseHelper:ClearData()
  self:InitData()
  BuffMgr:ClearData()
end

function MailDetailReportParseHelper:ParseData(detailData, selfHealth, otherHealth, selfSpSkillList, otherSpSkillList)
  BuffMgr:ClearData()
  self:InitData()
  self._roundReports = detailData.roundReports or {}
  self._effectReports = detailData.effectReports or {}
  self:InitPlayerInfo(detailData.playerInfos)
  self:SetIndexRange(detailData)
  local initSelfHealth = selfHealth
  local initOtherHealth = otherHealth
  for index = self._minIndex, self._maxIndex do
    if 1 < index then
      local beforeHealth = self._healthList[index - 1]
      if beforeHealth ~= nil then
        local LSkillList = self:GetSpecialSkillList(selfHealth, beforeHealth.self.total, selfSpSkillList)
        self:AddLeftSpecialSkill(LSkillList, index)
        local RSkillList = self:GetSpecialSkillList(otherHealth, beforeHealth.other.total, otherSpSkillList)
        self:AddRightSpecialSkill(RSkillList, index)
      end
    end
    local effectList = self:GetEffectList(index)
    for k, effectitem in pairs(effectList) do
      BuffMgr:AddBuffItem(effectitem, self._playerInfos)
    end
    local activeBuff = BuffMgr:GetActiveBuffList(index)
    self:AddEffectData(activeBuff, index)
    local actionlist = self:GetActionList(index)
    self:AddActionData(actionlist, index)
    local myValue = 0
    local otherValue = 0
    for _, actionItem in pairs(actionlist) do
      if actionItem:GetActionItemType() == eMailDetailActionType.USE_SKILL then
        local subItem = actionItem:GetSkillTarget()
        for _, v in pairs(subItem) do
          local actionValue = v:GetValue()
          if not table.IsNullOrEmpty(actionValue) then
            local side = actionValue.side
            local value = actionValue.value
            if side == eMailDetailTroopSide.Self then
              myValue = myValue + value
            else
              otherValue = otherValue + value
            end
          end
        end
      end
      local actionValue = actionItem:GetValue()
      if not table.IsNullOrEmpty(actionValue) then
        local side = actionValue.side
        local value = actionValue.value
        if side == eMailDetailTroopSide.Self then
          myValue = myValue + value
        else
          otherValue = otherValue + value
        end
      end
    end
    local param_self = {}
    param_self.total = initSelfHealth
    param_self.demage = myValue
    local param_other = {}
    param_other.total = initOtherHealth
    param_other.demage = otherValue
    local param_index = {}
    param_index.self = param_self
    param_index.other = param_other
    self._healthList[index] = param_index
    if initSelfHealth <= 0 or initOtherHealth <= 0 then
      self._maxIndex = index
      break
    end
    initSelfHealth = initSelfHealth + myValue
    initSelfHealth = 0 < initSelfHealth and initSelfHealth or 0
    initOtherHealth = initOtherHealth + otherValue
    initOtherHealth = 0 < initOtherHealth and initOtherHealth or 0
  end
end

function MailDetailReportParseHelper:GetHealthByIndex(roundIdx)
  return self._healthList[roundIdx] or {}
end

function MailDetailReportParseHelper:GetMinIndex()
  return self._minIndex or 0
end

function MailDetailReportParseHelper:GetMaxIndex()
  return self._maxIndex or 0
end

function MailDetailReportParseHelper:GetInfoByIndex(index)
  return self._allDetails[index] or {}
end

function MailDetailReportParseHelper:GetSpecialSkillList(initHealth, curHealth, skillList)
  if skillList == nil or #skillList <= 0 then
    return {}
  end
  local showSkillList = {}
  local percent = curHealth * 100 / math.max(1, initHealth)
  for i = 1, #skillList do
    local skillData = skillList[i]
    local minPercent = skillData.minPercent
    local maxPercent = skillData.maxPercent
    if maxPercent ~= nil and maxPercent ~= nil and percent <= maxPercent and percent >= minPercent then
      table.insert(showSkillList, skillData)
    end
  end
  return showSkillList
end

return MailDetailReportParseHelper
