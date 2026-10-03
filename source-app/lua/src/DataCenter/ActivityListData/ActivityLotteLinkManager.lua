local ActivityLotteLinkManager = BaseClass("ActivityLotteLinkManager")
local Localization = CS.GameEntry.Localization

local function AddListeners(self)
  function self.GenLotteVisitorFunc()
    self:CheckGenAndRemoveLotteVisitor()
  end
  
  function self.DeleteVisitorCheckFunc()
    self:CheckDeleteVisitorOnPassDay()
  end
  
  EventManager:GetInstance():AddListener(EventId.LottleActivityGenVisitorCheck, self.GenLotteVisitorFunc)
  EventManager:GetInstance():AddListener(EventId.OnEnterCity, self.GenLotteVisitorFunc)
  EventManager:GetInstance():AddListener(EventId.OnPassDay, self.DeleteVisitorCheckFunc)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.LottleActivityGenVisitorCheck, self.GenLotteVisitorFunc)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self.GenLotteVisitorFunc)
  EventManager:GetInstance():RemoveListener(EventId.OnPassDay, self.DeleteVisitorCheckFunc)
end

local function __init(self)
  AddListeners(self)
end

local function __delete(self)
  RemoveListener(self)
  self.activityData = nil
  self.fakeVisitorData = nil
  self.isNeedShowLotteAct = nil
end

local function CheckIsNeedShowLotteLink(self, actData)
  self.isNeedShowLotteAct = false
  if actData == nil or actData.para_1 == nil then
    return false
  end
  self.activityData = actData
  local curSelectLanguage = Localization.Language
  local allLanguage = CS.GameFramework.Localization.Language
  local curLangIndex = curSelectLanguage.value__
  if not (curSelectLanguage and allLanguage) or not curLangIndex then
    return false
  end
  local allowLanguageInfo = string.split(actData.para_1, ",")
  if table.count(allowLanguageInfo) <= 0 then
    return false
  end
  for _, language in ipairs(allowLanguageInfo) do
    if table.containsKey(allLanguage, language) then
      local langIndex = allLanguage[language].value__
      if langIndex == curLangIndex then
        self.isNeedShowLotteAct = true
        return true
      end
    end
  end
  return false
end

local function CheckGenAndRemoveLotteVisitor(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if not (self.activityData and self.activityData.para_5) or curTime >= self.activityData.endTime or not self.isNeedShowLotteAct then
    self:DeleteLotteVisitor()
    return
  end
  local visitorEventId = self.activityData.para_5
  local fakeUid = string.format("activity_%s_%s_fake", self.activityData.id, visitorEventId)
  self.fakeVisitorData = DataCenter.CityVisitorManager:CreateOneFakeVisitorDataByEventId(visitorEventId, fakeUid)
  if not self.fakeVisitorData then
    return
  end
  DataCenter.CityVisitorManager:AddVisitor(self.fakeVisitorData, nil, 1)
  if SceneUtils.GetIsInCity() then
    DataCenter.CityVisitorManager:ReGenVisitors()
  end
end

local function CheckDeleteVisitorOnPassDay(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if not self.activityData or curTime >= self.activityData.endTime then
    self:DeleteLotteVisitor()
    return
  end
end

local function DeleteLotteVisitor(self)
  if not self.fakeVisitorData or not SceneUtils.GetIsInCity() then
    return
  end
  local uid = self.fakeVisitorData.uid
  local type = self.fakeVisitorData.type
  local operate = 1
  DataCenter.CityVisitorManager:PlayVisitorFinishAni(uid, type, operate)
end

local function IsNeedShowRedPoint(self)
  if not self.isNeedShowLotteAct or self.activityData == nil then
    return false
  end
  local curState = -1
  local state1EndTimestamp = -1
  local btnStateInfo = self.activityData.para_6
  local btnStateInfoArr = string.split(btnStateInfo, ";")
  if 2 <= #btnStateInfoArr then
    curState = tonumber(btnStateInfoArr[1])
    state1EndTimestamp = tonumber(btnStateInfoArr[2]) * 1000
  else
    return false
  end
  if curState ~= 1 then
    return false
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if state1EndTimestamp <= curTime then
    return false
  end
  local prevState = CommonUtil.PlayerPrefsGetInt("LOTTE_TICKET_STATE", -1)
  return curState ~= prevState
end

ActivityLotteLinkManager.__init = __init
ActivityLotteLinkManager.__delete = __delete
ActivityLotteLinkManager.CheckIsNeedShowLotteLink = CheckIsNeedShowLotteLink
ActivityLotteLinkManager.CheckGenAndRemoveLotteVisitor = CheckGenAndRemoveLotteVisitor
ActivityLotteLinkManager.DeleteLotteVisitor = DeleteLotteVisitor
ActivityLotteLinkManager.CheckDeleteVisitorOnPassDay = CheckDeleteVisitorOnPassDay
ActivityLotteLinkManager.IsNeedShowRedPoint = IsNeedShowRedPoint
return ActivityLotteLinkManager
