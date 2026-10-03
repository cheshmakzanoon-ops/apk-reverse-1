local NpcQAManager = BaseClass("NpcQAManager")

local function __init(self)
  self.currentQAId = nil
  self.allReward = {}
  self.nextTime = 0
  self.param = {}
  self.visibleFlag = true
end

local function __delete(self)
  self:RemoveDelayTimer()
  self.currentQAId = nil
  self.nextTime = nil
  self.param = nil
  self.allReward = nil
end

local function InitQAData(self, message)
  if message.npcQuestion ~= nil then
    self:UpdateQAData(message.npcQuestion)
  end
  DataCenter.NpcQABubbleManager:StartUp()
end

local function ResetQA(self)
  self.currentQAId = DataCenter.NpcQATemplateManager:GetRandomQAId(self.param)
end

local function SetNpcQAVisible(self, flag)
  self.visibleFlag = flag
end

local function GetCurrentQA(self)
  if not self.visibleFlag then
    return nil
  end
  local isOpen = LuaEntry.DataConfig:CheckSwitch("npcquiz_switch")
  if not isOpen then
    return nil
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if now < self.nextTime then
    return nil
  end
  if self.currentQAId == nil then
    self:ResetQA()
  end
  return self.currentQAId
end

local function AddDelayTimer(self)
  self:RemoveDelayTimer()
  local now = UITimeManager:GetInstance():GetServerTime()
  if now < self.nextTime then
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      DataCenter.NpcQABubbleManager:DoWhenQuestionNeedRefresh()
      self:RemoveDelayTimer()
    end, (self.nextTime - now + 1000) / 1000)
  end
end

local function RemoveDelayTimer(self)
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

local function UpdateQAData(self, message)
  if message ~= nil then
    if message.nextTime ~= nil then
      self.nextTime = message.nextTime
      self:AddDelayTimer()
    end
    if message.param ~= nil then
      self.param = {}
      if message.param ~= "" then
        local tmp = string.split(message.param, ";")
        table.walk(tmp, function(_, v)
          self.param[v] = 1
        end)
      end
    end
  end
end

local function SendQAToServer(self, questionId, chooseIndex)
  SFSNetwork.SendMessage(MsgDefines.UserNpcQuestion, questionId, chooseIndex)
end

local function DoWhenQAResultBack(self, message)
  if message == nil then
    return
  end
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  local reward = message.reward
  if reward ~= nil then
    DataCenter.RewardManager:ShowCommonReward(message)
    DataCenter.RewardManager:AddRewardsAndRes(message)
  end
  self:UpdateQAData(message)
  self:ResetQA()
  DataCenter.NpcQABubbleManager:DoWhenQuestionNeedRefresh()
end

local function GetRewardData(self, questionId)
  local questionTemp = DataCenter.NpcQATemplateManager:GetNpcQATemplate(questionId)
  if questionTemp ~= nil then
    return questionTemp.reward_true
  end
  return nil
end

NpcQAManager.__init = __init
NpcQAManager.__delete = __delete
NpcQAManager.ResetQA = ResetQA
NpcQAManager.GetCurrentQA = GetCurrentQA
NpcQAManager.UpdateQAData = UpdateQAData
NpcQAManager.SendQAToServer = SendQAToServer
NpcQAManager.DoWhenQAResultBack = DoWhenQAResultBack
NpcQAManager.InitQAData = InitQAData
NpcQAManager.GetRewardData = GetRewardData
NpcQAManager.SetNpcQAVisible = SetNpcQAVisible
NpcQAManager.AddDelayTimer = AddDelayTimer
NpcQAManager.RemoveDelayTimer = RemoveDelayTimer
return NpcQAManager
