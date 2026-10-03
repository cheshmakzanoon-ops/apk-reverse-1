local LWQuestionnaireManager = BaseClass("LWQuestionnaireManager")
local LWQuestionnaireInfo = require("DataCenter.LWQuestionnaire.LWQuestionnaireInfo")

function LWQuestionnaireManager:__init()
  self.allQuestionnaires = {}
  self.localCacheQuestionnaireUuidDict = nil
end

function LWQuestionnaireManager:__delete()
  self.allQuestionnaires = nil
  self.localCacheQuestionnaireUuidDict = nil
end

function LWQuestionnaireManager:SendMsgInquiryList()
  SFSNetwork.SendMessage(MsgDefines.InquiryList)
end

function LWQuestionnaireManager:SendMsgInquiryGoTo(targetUuid)
  SFSNetwork.SendMessage(MsgDefines.InquiryGoTo, targetUuid)
end

function LWQuestionnaireManager:SendMsgInquiryReward(targetUuid)
  Logger.LogInfo("LWQuestionnaireManager:SendMsgInquiryReward: targetUuid = " .. tostring(targetUuid))
  SFSNetwork.SendMessage(MsgDefines.InquiryReward, targetUuid)
end

function LWQuestionnaireManager:UpdateQuestionnaireInfo(message)
  local questionnaireList = message.list
  if questionnaireList ~= nil then
    self.allQuestionnaires = {}
    for i, v in pairs(questionnaireList) do
      local questionnaireInfo = LWQuestionnaireInfo.New()
      questionnaireInfo:InitData(v)
      self.allQuestionnaires[questionnaireInfo.uuid] = questionnaireInfo
    end
    EventManager:GetInstance():Broadcast(EventId.QuestionnaireDataMainUIRefresh)
    EventManager:GetInstance():Broadcast(EventId.GetQuestionnaireInfoData)
  end
end

function LWQuestionnaireManager:HasReturnQuestionnaireNeedPrompt()
  local data
  for i, v in pairs(self.allQuestionnaires) do
    if v.type == QuestionnaireType.Return and not v:IsInvalid() and v.firstEnterQuestionnaireTime == 0 and v.status == QuestionnaireRewardStatus.NotAvailable then
      data = v
      break
    end
  end
  return data
end

function LWQuestionnaireManager:GetQuestionnaireInfoByUuid(uuid)
  if self.allQuestionnaires[uuid] ~= nil then
    return self.allQuestionnaires[uuid]
  end
  return nil
end

function LWQuestionnaireManager:RefreshQuestionnaireRewardStatus(targetUuid, status)
  local questionnaireInfo = self:GetQuestionnaireInfoByUuid(targetUuid)
  if questionnaireInfo ~= nil then
    questionnaireInfo:SetRewardState(status)
  end
end

function LWQuestionnaireManager:RefreshQuestionnaireFirstEnterTime(targetUuid)
  local questionnaireInfo = self:GetQuestionnaireInfoByUuid(targetUuid)
  if questionnaireInfo ~= nil then
    questionnaireInfo:SetFirstEnterQuestionnaireTime()
  end
end

function LWQuestionnaireManager:GetAllCanShowQuestionnaireList()
  local canShowList = {}
  local count = table.count(self.allQuestionnaires)
  if 0 < count then
    for uuid, questionnaireInfo in pairs(self.allQuestionnaires) do
      if not questionnaireInfo:IsInvalid() then
        table.insert(canShowList, uuid)
      end
    end
  end
  return canShowList
end

function LWQuestionnaireManager:GetRedDotCount()
  local redDotCount = 0
  local rewardDotCount = 0
  local count = table.count(self.allQuestionnaires)
  if 0 < count then
    for uuid, questionnaireInfo in pairs(self.allQuestionnaires) do
      if not questionnaireInfo:IsInvalid() and questionnaireInfo:HasRedDot() then
        if questionnaireInfo:HasRewardRedDot() then
          rewardDotCount = rewardDotCount + 1
        elseif questionnaireInfo:HasGoToRedDot() then
          redDotCount = redDotCount + 1
        end
      end
    end
  end
  return redDotCount + rewardDotCount, rewardDotCount, redDotCount
end

function LWQuestionnaireManager:SetQuestionnaireRedDotMark()
  local save = false
  local count = table.count(self.allQuestionnaires)
  if 0 < count then
    for uuid, questionnaireInfo in pairs(self.allQuestionnaires) do
      if not questionnaireInfo:IsInvalid() and questionnaireInfo:HasRedDot() then
        if self.localCacheQuestionnaireUuidDict == nil then
          self.localCacheQuestionnaireUuidDict = {}
        end
        if self.localCacheQuestionnaireUuidDict[questionnaireInfo.uuid] == nil then
          self.localCacheQuestionnaireUuidDict[questionnaireInfo.uuid] = true
          save = true
        end
      end
    end
  end
  if save then
    CommonUtil.PlayerPrefsSetTable(SettingKeys.QUESTIONNAIRE_RED_DOT, self.localCacheQuestionnaireUuidDict)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

function LWQuestionnaireManager:SetOneQuestionnaireRedDotMark(targetUuid)
  local questionnaireInfo = self:GetQuestionnaireInfoByUuid(targetUuid)
  if questionnaireInfo ~= nil then
    if self.localCacheQuestionnaireUuidDict == nil then
      self.localCacheQuestionnaireUuidDict = {}
    end
    if self.localCacheQuestionnaireUuidDict[questionnaireInfo.uuid] == nil then
      self.localCacheQuestionnaireUuidDict[questionnaireInfo.uuid] = true
      CommonUtil.PlayerPrefsSetTable(SettingKeys.QUESTIONNAIRE_RED_DOT, self.localCacheQuestionnaireUuidDict)
      EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
    end
  end
end

function LWQuestionnaireManager:GetQuestionnaireRedDotMark(targetUuid)
  if self.localCacheQuestionnaireUuidDict == nil then
    self.localCacheQuestionnaireUuidDict = CommonUtil.PlayerPrefsGetTable(SettingKeys.QUESTIONNAIRE_RED_DOT, {})
  end
  if self.localCacheQuestionnaireUuidDict[targetUuid] then
    return self.localCacheQuestionnaireUuidDict[targetUuid]
  end
  return false
end

return LWQuestionnaireManager
