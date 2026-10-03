local LWQuestionnaireInfo = BaseClass("LWQuestionnaireInfo")

function LWQuestionnaireInfo:__init()
  self.uuid = ""
  self.title = ""
  self.jumpURL = ""
  self.reward = {}
  self.type = 0
  self.startTime = 0
  self.endTime = 0
  self.expiredTime = 0
  self.status = 0
  self.firstEnterQuestionnaireTime = 0
  self.showRewardList = nil
end

function LWQuestionnaireInfo:__delete()
  self.uuid = nil
  self.title = nil
  self.jumpURL = nil
  self.reward = nil
  self.type = nil
  self.startTime = nil
  self.endTime = nil
  self.expiredTime = nil
  self.status = nil
  self.firstEnterQuestionnaireTime = nil
  self.showRewardList = nil
end

function LWQuestionnaireInfo:InitData(message)
  if message.uuid then
    self.uuid = message.uuid
  end
  if message.title then
    self.title = message.title
  end
  if message.jumpURL then
    self.jumpURL = message.jumpURL
  end
  if message.reward then
    self.reward = message.reward
  end
  if message.type then
    self.type = message.type
  end
  if message.startTime then
    self.startTime = message.startTime
  end
  if message.endTime then
    self.endTime = message.endTime
  end
  if message.rewardTime then
    self.expiredTime = message.rewardTime
  end
  if message.getReward then
    local info = message.getReward
    if info.status then
      self.status = info.status
    end
    if info.time then
      self.firstEnterQuestionnaireTime = info.time
    end
  end
end

function LWQuestionnaireInfo:SetRewardState(newStatus)
  self.status = newStatus
end

function LWQuestionnaireInfo:SetFirstEnterQuestionnaireTime()
  self.firstEnterQuestionnaireTime = UITimeManager:GetInstance():GetServerTime()
end

function LWQuestionnaireInfo:IsInvalid()
  local currentTime = UITimeManager:GetInstance():GetServerTime()
  if self.type == QuestionnaireType.Permanent then
    if self.firstEnterQuestionnaireTime > 0 then
      local tempTime = currentTime - self.firstEnterQuestionnaireTime
      if tempTime > self.expiredTime then
        return true
      end
    end
  elseif self.type == QuestionnaireType.LimitedTime then
    if currentTime > self.startTime and currentTime >= self.endTime then
      return true
    end
  elseif self.type == QuestionnaireType.Return and currentTime > self.startTime and currentTime >= self.endTime then
    return true
  end
  return false
end

function LWQuestionnaireInfo:GetShowRewardList()
  if self.showRewardList == nil then
    self.showRewardList = DataCenter.RewardManager:ReturnRewardParamForMessage(self.reward)
  end
  return self.showRewardList
end

function LWQuestionnaireInfo:HasRedDot()
  return self:HasGoToRedDot() or self:HasRewardRedDot()
end

function LWQuestionnaireInfo:HasGoToRedDot()
  local mark = DataCenter.LWQuestionnaireManager:GetQuestionnaireRedDotMark(self.uuid)
  return not mark and self.firstEnterQuestionnaireTime == 0
end

function LWQuestionnaireInfo:HasRewardRedDot()
  if self.showRewardList == nil then
    self.showRewardList = DataCenter.RewardManager:ReturnRewardParamForMessage(self.reward)
  end
  if self.showRewardList ~= nil and #self.showRewardList > 0 then
    return self.status == QuestionnaireRewardStatus.CanReceive
  else
    return false
  end
end

return LWQuestionnaireInfo
