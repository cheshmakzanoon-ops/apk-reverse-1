local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_StageFeatureHelpAccept = BaseClass("StageFeatureHelpAccept", IChatItemPost)
local base = IChatItemPost
local rapidjson = require("rapidjson")
local Localization = CS.GameEntry.Localization

function ChatItemPost_StageFeatureHelpAccept:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemPost_StageFeatureHelpAccept:ComponentDefine()
  self.img2 = self:AddComponent(UIImage, "bg/img2")
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "textTitle")
  self.textDes = self:AddComponent(UITextMeshProUGUIEx, "textDes")
  self.textCountdown = self:AddComponent(UITextMeshProUGUIEx, "textCountdown")
  self.btnHelp = self:AddComponent(UIButton, "btnHelp")
  self.btnHelp:SetOnClick(function()
    self:OnClickHelp()
  end)
end

function ChatItemPost_StageFeatureHelpAccept:OnLoaded()
  local chatData = self:ChatData()
  self.seqId = chatData:getSeqId()
  self.roomId = chatData.roomId
  self:Refresh(chatData)
  self:SetUIStyle(chatData)
  if chatData and chatData:isMyChat() and not self.isComplete then
    self:SetRemainTime()
    self:AddTimer()
  else
    self.textCountdown:SetText("")
  end
end

function ChatItemPost_StageFeatureHelpAccept:Refresh(chatData)
  self._chatData = chatData
  self.senderInfo = self._chatData:getSenderInfo()
  local isMyChat = self._chatData:isMyChat()
  if self._chatData then
    if self._chatData.extra and self._chatData.extra.customJsonParam then
      self.uuid = tonumber(self._chatData.extra.customJsonParam.uuid)
      self.stageId = self._chatData.extra.customJsonParam.stageId
    end
    if self._chatData.clientUpdateExtra then
      local arr = string.split(self._chatData.clientUpdateExtra, ";")
      self.state = tonumber(arr[1])
      self.endTime = tonumber(arr[2])
      self.isComplete = self.state == StageFeatureHelpInfoState.Complete
    end
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local isExpired = self.endTime and curTime >= self.endTime
  if isMyChat and not self.isComplete and not isExpired then
    self.btnHelp:SetActive(true)
  else
    self.btnHelp:SetActive(false)
  end
  self.textTitle:SetLocalText("frontline_help_chat_04")
  self.textDes:SetLocalText("frontline_help_chat_05")
end

function ChatItemPost_StageFeatureHelpAccept:OnRecycle()
  self:DelTimer()
end

function ChatItemPost_StageFeatureHelpAccept:OnAddListener()
  base.OnAddListener(self)
end

function ChatItemPost_StageFeatureHelpAccept:OnRemoveListener()
  base.OnRemoveListener(self)
end

function ChatItemPost_StageFeatureHelpAccept:OnUpdateMsg(chatData)
  if chatData and chatData.seqId == self.seqId and chatData.roomId == self.roomId then
    self:Refresh(chatData)
  end
end

function ChatItemPost_StageFeatureHelpAccept:OnClickHelp()
  local isMyChat = self._chatData:isMyChat()
  if not isMyChat then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime >= self.endTime then
    UIUtil.ShowTipsId(390843)
    return
  end
  DataCenter.LWStageFeatureChapterManager:GoToHelp(self.uuid, self.stageId)
end

function ChatItemPost_StageFeatureHelpAccept:AddTimer()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime >= self.endTime then
    return
  end
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.SetRemainTime, self, false, false, false)
  end
  self.timer:Start()
end

function ChatItemPost_StageFeatureHelpAccept:SetRemainTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.endTime - curTime
  if 0 < remainTime then
    self.textCountdown:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self:DelTimer()
    self.textCountdown:SetLocalText("390843")
  end
end

function ChatItemPost_StageFeatureHelpAccept:DelTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function ChatItemPost_StageFeatureHelpAccept:SetUIStyle(chatData)
  local isMyChat = chatData:isMyChat()
  if isMyChat then
    self.img2:SetAnchoredPositionXY(-176, 60)
    self.textTitle:SetAnchoredPositionXY(63, 67.36)
    self.textDes:SetAnchoredPositionXY(-117, 46)
    self.textCountdown:SetAnchoredPositionXY(-117, -13.3)
  else
    self.img2:SetAnchoredPositionXY(195, 60)
    self.textTitle:SetAnchoredPositionXY(-71.4, 67.36)
    self.textDes:SetAnchoredPositionXY(-250.4, 46)
    self.textCountdown:SetAnchoredPositionXY(359.7, -13.3)
  end
end

return ChatItemPost_StageFeatureHelpAccept
