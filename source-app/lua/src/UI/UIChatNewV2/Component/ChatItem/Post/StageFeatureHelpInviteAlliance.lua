local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_StageFeatureHelpInviteAlliance = BaseClass("StageFeatureHelpInviteAlliance", IChatItemPost)
local base = IChatItemPost
local rapidjson = require("rapidjson")
local Localization = CS.GameEntry.Localization

function ChatItemPost_StageFeatureHelpInviteAlliance:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemPost_StageFeatureHelpInviteAlliance:ComponentDefine()
  self.img2 = self:AddComponent(UIImage, "bg/img2")
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "textTitle")
  self.textDes = self:AddComponent(UITextMeshProUGUIEx, "textDes")
  self.textCountdown = self:AddComponent(UITextMeshProUGUIEx, "textCountdown")
  self.btnHelp = self:AddComponent(UIButton, "btnHelp")
  self.btnHelp:SetOnClick(function()
    self:OnClickHelp()
  end)
end

function ChatItemPost_StageFeatureHelpInviteAlliance:OnLoaded()
  local chatData = self:ChatData()
  self.seqId = chatData:getSeqId()
  self.roomId = chatData.roomId
  self:Refresh(chatData)
  self:SetUIStyle(chatData)
  self:SetRemainTime()
  self:AddTimer()
end

function ChatItemPost_StageFeatureHelpInviteAlliance:Refresh(chatData)
  self._chatData = chatData
  local isMyChat = self._chatData:isMyChat()
  if self._chatData then
    if self._chatData.extra and self._chatData.extra.customJsonParam then
      self.data = rapidjson.decode(self._chatData.extra.customJsonParam)
      self.uuid = tonumber(self.data.uuid)
      self.stageId = self.data.stageId
      local name = DataCenter.LWStageFeatureChapterManager:GetStageFeatureName(self.stageId)
      self.textTitle:SetText(name)
      self.textDes:SetLocalText("frontline_help_chat_02")
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
  self.isAccept = DataCenter.LWStageFeatureChapterManager:CheckAcceptInviteUuidExist(self.uuid)
  if isMyChat or isExpired or self.isAccept then
    self.btnHelp:SetActive(false)
    if self.isAccept then
      self.textCountdown:SetLocalText("frontline_help_message_16")
    end
  else
    self.btnHelp:SetActive(true)
  end
end

function ChatItemPost_StageFeatureHelpInviteAlliance:OnRecycle()
  self:DelTimer()
end

function ChatItemPost_StageFeatureHelpInviteAlliance:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PlaneFeatureAcceptAllianceInvite, self.OnAcceptInviteSuccess)
end

function ChatItemPost_StageFeatureHelpInviteAlliance:OnRemoveListener()
  self:RemoveUIListener(EventId.PlaneFeatureAcceptAllianceInvite, self.OnAcceptInviteSuccess)
  base.OnRemoveListener(self)
end

function ChatItemPost_StageFeatureHelpInviteAlliance:OnAcceptInviteSuccess(uuid)
  if not uuid then
    return
  end
  local isSelf = uuid == self.uuid
  if not isSelf then
    return
  end
  self.isAccept = true
  self.btnHelp:SetActive(false)
  self.textCountdown:SetLocalText("frontline_help_message_16")
end

function ChatItemPost_StageFeatureHelpInviteAlliance:OnUpdateMsg(chatData)
  if chatData and chatData.seqId == self.seqId and chatData.roomId == self.roomId then
    self:Refresh(chatData)
  end
end

function ChatItemPost_StageFeatureHelpInviteAlliance:OnClickHelp()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime >= self.endTime then
    UIUtil.ShowTipsId(390843)
    return
  end
  local param = {}
  param.uuid = self.uuid
  param.stageId = self.stageId
  param.endTime = self.endTime
  param.senderInfo = self._chatData:getSenderInfo()
  param.fromAlliance = true
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIStageFeatureHelpInvite, {anim = false}, param)
end

function ChatItemPost_StageFeatureHelpInviteAlliance:AddTimer()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime >= self.endTime then
    return
  end
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.SetRemainTime, self, false, false, false)
  end
  self.timer:Start()
end

function ChatItemPost_StageFeatureHelpInviteAlliance:SetRemainTime()
  if self.isAccept then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.endTime - curTime
  if 0 < remainTime then
    self.textCountdown:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self:DelTimer()
    self.textCountdown:SetLocalText("390843")
  end
end

function ChatItemPost_StageFeatureHelpInviteAlliance:DelTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function ChatItemPost_StageFeatureHelpInviteAlliance:SetUIStyle(chatData)
  local isMyChat = chatData:isMyChat()
  if isMyChat then
    self.img2:SetAnchoredPositionXY(-175.5, 27.5)
    self.textTitle:SetAnchoredPositionXY(79, 68.8)
    self.textDes:SetAnchoredPositionXY(-100, 44.6)
    self.textCountdown:SetAnchoredPositionXY(-100, -39)
  else
    self.img2:SetAnchoredPositionXY(191, 27.5)
    self.textTitle:SetAnchoredPositionXY(-58, 68.8)
    self.textDes:SetAnchoredPositionXY(-238, 44.6)
    self.textCountdown:SetAnchoredPositionXY(-238, -39)
  end
end

return ChatItemPost_StageFeatureHelpInviteAlliance
