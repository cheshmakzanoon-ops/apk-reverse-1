local BuffMgr = require("Scene.BattlePveModule.MailDetailParseModule.PveMailDetailBuffMgr")
local ActionItem = require("Scene.BattlePveModule.MailDetailParseModule.PveMailDetailActionItem")
local MailDetailReportParseHelper = BaseClass("MailDetailReportParseHelper")
local Const = require("Scene.BattlePveModule.Const")

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
  self._allDetails[roundIdx][Const.Define.BUFF] = effectlist
end

function MailDetailReportParseHelper:AddActionData(skill, normal, roundIdx)
  if self._allDetails[roundIdx] == nil then
    self._allDetails[roundIdx] = {}
  end
  self._allDetails[roundIdx][Const.Define.SKILL] = skill
  local normalAtk = {}
  for _, v in pairs(normal) do
    local t_index = tostring(v:GetTargetIndex())
    if normalAtk[t_index] == nil then
      local item = v:GetValue()
      if item.value ~= nil then
        normalAtk[t_index] = item.value
      end
    else
      local item = v:GetValue()
      if item.value ~= nil then
        normalAtk[t_index] = normalAtk[t_index] + item.value
      end
    end
  end
  self._allDetails[roundIdx][Const.Define.NORMAL_ATK] = normalAtk
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
  local _skillroundList = {}
  local _normalAtkList = {}
  
  local function InsertActionItem(actionItem)
    local tbCnt = table.count(_skillroundList)
    if tbCnt == 0 then
      return false
    end
    for i = tbCnt, 1, -1 do
      local _action = _skillroundList[i]
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
      if actionItem:IsSubActionItem() and InsertActionItem(actionItem) then
      elseif actionItem:GetActionItemType() == eMailDetailActionType.USE_SKILL then
        _skillroundList[#_skillroundList + 1] = actionItem
      else
        _normalAtkList[#_normalAtkList + 1] = actionItem
      end
      self._roundReports[key] = nil
    elseif reportItem ~= nil and findIndex < reportItem.round then
      break
    end
  end
  return _skillroundList, _normalAtkList
end

function MailDetailReportParseHelper:GetEffectList(findIndex)
  local effectList = {}
  for key, effectItem in pairs(self._effectReports) do
    if effectItem ~= nil and effectItem.baseReport ~= nil and effectItem.baseReport.round == findIndex then
      effectList[#effectList + 1] = effectItem
      self._effectReports[key] = nil
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

function MailDetailReportParseHelper:GetPlayerInfo()
  return self._playerInfos
end

function MailDetailReportParseHelper:GetCampTypeByTriggerIndex(value, needExchange)
  local userinfo = self._playerInfos[value] or {}
  if userinfo.isSelf == true then
    return needExchange and Const.CampType.Target or Const.CampType.Player
  else
    return needExchange and Const.CampType.Player or Const.CampType.Target
  end
end

function MailDetailReportParseHelper:ClearData()
  self:InitData()
  BuffMgr:ClearData()
end

function MailDetailReportParseHelper:AnalyseRoundAndEffect()
  local realEffectList = {}
  for key, effectItem in pairs(self._effectReports) do
    realEffectList[#realEffectList + 1] = effectItem
    self._effectReports[key] = nil
  end
  for key, reportItem in pairs(self._roundReports) do
    if reportItem ~= nil and reportItem.type == eMailDetailActionType.ADD_EFFECT then
      local oneData = {}
      local time = reportItem.param
      oneData.baseReport = reportItem
      oneData.time = time
      realEffectList[#realEffectList + 1] = oneData
      self._roundReports[key] = nil
    end
  end
  table.sort(realEffectList, function(a, b)
    if a.baseReport.round < b.baseReport.round then
      return true
    end
    return false
  end)
  self._effectReports = realEffectList
end

function MailDetailReportParseHelper:ParseData(detailData, selfHealth, otherHealth)
  BuffMgr:ClearData()
  self:InitData()
  self._roundReports = detailData.roundReports or {}
  self._effectReports = detailData.effectReports or {}
  self:InitPlayerInfo(detailData.playerInfos)
  self:AnalyseRoundAndEffect()
  self:SetIndexRange(detailData)
  for index = self._minIndex, self._maxIndex do
    local effectList = self:GetEffectList(index)
    for k, effectitem in pairs(effectList) do
      BuffMgr:AddBuffItem(effectitem, self._playerInfos)
    end
    local skill, normal = self:GetActionList(index)
    for _, effectItem in pairs(effectList) do
      local skillUser
      for _, skill_item in pairs(skill) do
        if (skill_item:IsSubSkill(effectItem.baseReport.skillId) or skill_item:GetSkillId() == effectItem.baseReport.skillId) and skill_item:GetTriggerIndex() == effectItem.baseReport.triggerIndex and skill_item:GetHeroId() == effectItem.baseReport.heroId then
          skillUser = skill_item
          break
        end
      end
      if skillUser ~= nil then
        local actionItem = ActionItem.New()
        actionItem:InitData(effectItem.baseReport, self._playerInfos)
        skillUser:AddSkillTarget(actionItem)
      else
        local actionItem = ActionItem.New()
        actionItem:InitData(effectItem.baseReport, self._playerInfos)
        skill[#skill + 1] = actionItem
      end
    end
    self:AddActionData(skill, normal, index)
  end
end

function MailDetailReportParseHelper:GetBuffListByRoundIndex(index)
  return BuffMgr:GetBuffListByRoundIndex(index)
end

function MailDetailReportParseHelper:GetMinIndex()
  return self._minIndex or 0
end

function MailDetailReportParseHelper:GetMaxIndex()
  return self._maxIndex or 0
end

function MailDetailReportParseHelper:GetAtkInfoByIndex(index)
  return self._allDetails[index] or {}
end

return MailDetailReportParseHelper
