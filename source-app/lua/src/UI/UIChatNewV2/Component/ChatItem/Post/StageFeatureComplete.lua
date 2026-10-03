local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_StageFeatureComplete = BaseClass("StageFeatureComplete", IChatItemPost)
local base = IChatItemPost
local rapidjson = require("rapidjson")
local Localization = CS.GameEntry.Localization
local state = {Unaccepted = 0, Accepted = 1}

function ChatItemPost_StageFeatureComplete:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemPost_StageFeatureComplete:ComponentDefine()
  self.img2 = self:AddComponent(UIImage, "bg/img2")
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "textTitle")
  self.textDes = self:AddComponent(UITextMeshProUGUIEx, "textDes")
  self.btnOpenResultPanel = self:AddComponent(UIButton, "bg/img1")
  self.btnOpenResultPanel:SetOnClick(function()
    self:OpenResultPanel()
  end)
  self.textCountdown = self:AddComponent(UITextMeshProUGUIEx, "textCountdown")
  self.btn = self:AddComponent(UIButton, "btn")
  self.btn:SetOnClick(function()
    self:OpenResultPanel()
  end)
end

function ChatItemPost_StageFeatureComplete:OnLoaded()
  local chatData = self:ChatData()
  self.seqId = chatData:getSeqId()
  self.roomId = chatData.roomId
  self:Refresh(chatData)
  self:SetUIStyle(chatData)
  if chatData and not chatData:isMyChat() then
    self:SetRemainTime()
    self:AddTimer()
    self:CheckNeedAutoOpen()
  else
    self.textCountdown:SetText("")
  end
end

function ChatItemPost_StageFeatureComplete:Refresh(chatData)
  self._chatData = chatData
  if self._chatData and self._chatData.extra and self._chatData.extra.customJsonParam then
    self.uuid = self._chatData.extra.customJsonParam.uuid
    self.stageId = self._chatData.extra.customJsonParam.stageId
    self.soldierNum = self._chatData.extra.customJsonParam.soldier or 0
    self.endTime = self._chatData.extra.customJsonParam.endTime
    self.textTitle:SetLocalText("frontline_help_chat_07")
    local name = DataCenter.LWStageFeatureChapterManager:GetStageFeatureName(self.stageId)
    self.textDes:SetLocalText("frontline_help_chat_08", name, self.soldierNum)
    self.state = tonumber(chatData.clientUpdateExtra)
  end
end

function ChatItemPost_StageFeatureComplete:OnRecycle()
  self:DelTimer()
end

function ChatItemPost_StageFeatureComplete:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateMsg)
end

function ChatItemPost_StageFeatureComplete:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateMsg)
  base.OnRemoveListener(self)
end

function ChatItemPost_StageFeatureComplete:OnUpdateMsg(chatData)
  if chatData and chatData.seqId == self.seqId and chatData.roomId == self.roomId then
    self:Refresh(chatData)
  end
end

function ChatItemPost_StageFeatureComplete:OpenResultPanel()
  local isMyChat = self._chatData:isMyChat()
  if isMyChat then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime >= self.endTime then
    UIUtil.ShowTipsId("390843")
    return
  end
  local param = {}
  param.uuid = self.uuid
  param.stageId = self.stageId
  param.endTime = self.endTime
  param.senderInfo = self._chatData:getSenderInfo()
  param.soldierNum = self.soldierNum
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIStageFeatureHelpResult, {anim = false}, param)
end

function ChatItemPost_StageFeatureComplete:AddTimer()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime >= self.endTime then
    return
  end
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.SetRemainTime, self, false, false, false)
  end
  self.timer:Start()
end

function ChatItemPost_StageFeatureComplete:SetRemainTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.endTime - curTime
  if 0 < remainTime then
    self.textCountdown:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self:DelTimer()
    self.textCountdown:SetLocalText("390843")
  end
end

function ChatItemPost_StageFeatureComplete:DelTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function ChatItemPost_StageFeatureComplete:SetUIStyle(chatData)
  local isMyChat = chatData:isMyChat()
  if isMyChat then
    self.img2:SetAnchoredPositionXY(-178, 74)
    self.textTitle:SetAnchoredPositionXY(75.6, 105)
    self.textDes:SetAnchoredPositionXY(-110, 73)
    self.textCountdown:SetAnchoredPositionXY(-110, -64)
    self.btn:SetActive(false)
  else
    self.img2:SetAnchoredPositionXY(187.61, 74)
    self.textTitle:SetAnchoredPositionXY(-66.5, 105)
    self.textDes:SetAnchoredPositionXY(-252, 73)
    self.textCountdown:SetAnchoredPositionXY(-252.6, -64)
    self.btn:SetActive(true)
  end
end

function ChatItemPost_StageFeatureComplete:CheckNeedAutoOpen()
  if not self.state or self.state == state.Accepted then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime >= self.endTime then
    return
  end
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIStageFeatureHelpResult) then
    return
  end
  self:OpenResultPanel()
end

return ChatItemPost_StageFeatureComplete
