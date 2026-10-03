local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_StageFeatureHelpInvite = BaseClass("StageFeatureHelpInvite", IChatItemPost)
local base = IChatItemPost
local rapidjson = require("rapidjson")
local Localization = CS.GameEntry.Localization

function ChatItemPost_StageFeatureHelpInvite:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemPost_StageFeatureHelpInvite:ComponentDefine()
  self.root = self:AddComponent(UIBaseContainer, "")
  self.img2 = self:AddComponent(UIImage, "bg/img2")
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "Texts/textTitle2")
  self.textCountdown = self:AddComponent(UITextMeshProUGUIEx, "Texts/textCountdown2")
  self.textDes = self:AddComponent(UITextMeshProUGUIEx, "Texts/textDes2")
  self.btnHelp = self:AddComponent(UIButton, "btnHelp")
  self.btnHelp:SetOnClick(function()
    self:OnClickHelp()
  end)
  self.texts = self:AddComponent(UIBaseContainer, "Texts")
end

function ChatItemPost_StageFeatureHelpInvite:OnLoaded()
  local chatData = self:ChatData()
  self.seqId = chatData:getSeqId()
  self.roomId = chatData.roomId
  self:Refresh(chatData)
  self:SetUIStyle(chatData)
  self:SetRemainTime()
  self:AddTimer()
  self:SetRootHeight()
end

function ChatItemPost_StageFeatureHelpInvite:Refresh(chatData)
  self._chatData = chatData
  local isMyChat = self._chatData:isMyChat()
  if self._chatData then
    if self._chatData.extra and self._chatData.extra.customJsonParam then
      self.uuid = tonumber(self._chatData.extra.customJsonParam.uuid)
      self.stageId = self._chatData.extra.customJsonParam.stageId
      local name = DataCenter.LWStageFeatureChapterManager:GetStageFeatureName(self.stageId)
      self.textTitle:SetText(name)
    end
    if self._chatData.clientUpdateExtra then
      local arr = string.split(self._chatData.clientUpdateExtra, ";")
      self.state = tonumber(arr[1])
      self.endTime = tonumber(arr[2])
      self.isAccept = self.state == StageFeatureHelpInfoState.AcceptInvite
    end
  end
  self.textDes:SetLocalText("frontline_help_chat_02")
  if self.isAccept then
    self.textCountdown:SetLocalText("frontline_help_message_16")
  else
    self.textCountdown:SetText("")
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local isExpired = self.endTime and curTime >= self.endTime
  if isMyChat or self.isAccept or isExpired then
    self.btnHelp:SetActive(false)
  else
    self.btnHelp:SetActive(true)
  end
end

function ChatItemPost_StageFeatureHelpInvite:OnRecycle()
  self:DelTimer()
end

function ChatItemPost_StageFeatureHelpInvite:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateMsg)
end

function ChatItemPost_StageFeatureHelpInvite:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateMsg)
  base.OnRemoveListener(self)
end

function ChatItemPost_StageFeatureHelpInvite:OnUpdateMsg(chatData)
  if chatData and chatData.seqId == self.seqId and chatData.roomId == self.roomId then
    self:Refresh(chatData)
  end
end

function ChatItemPost_StageFeatureHelpInvite:OnClickHelp()
  local param = {}
  param.uuid = self.uuid
  param.stageId = self.stageId
  param.endTime = self.endTime
  param.senderInfo = self._chatData:getSenderInfo()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIStageFeatureHelpInvite, {anim = false}, param)
end

function ChatItemPost_StageFeatureHelpInvite:AddTimer()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime >= self.endTime then
    return
  end
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.SetRemainTime, self, false, false, false)
  end
  self.timer:Start()
end

function ChatItemPost_StageFeatureHelpInvite:SetRemainTime()
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

function ChatItemPost_StageFeatureHelpInvite:DelTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function ChatItemPost_StageFeatureHelpInvite:SetUIStyle(chatData)
  local isMyChat = chatData:isMyChat()
  if isMyChat then
    self.img2:SetAnchoredPositionXY(-175.5, 27.5)
    self.textTitle:SetAnchoredPositionXY(79, 61)
    self.textDes:SetAnchoredPositionXY(-100, 34)
    self.textCountdown:SetAnchoredPositionXY(-100, -39)
    self.texts:SetAnchoredPositionXY(169, -7.9)
  else
    self.img2:SetAnchoredPositionXY(191, 27.5)
    self.textTitle:SetAnchoredPositionXY(-58, 61)
    self.textDes:SetAnchoredPositionXY(-238, 34)
    self.textCountdown:SetAnchoredPositionXY(-238, -39)
    self.texts:SetAnchoredPositionXY(31, -7.9)
  end
end

function ChatItemPost_StageFeatureHelpInvite:SetRootHeight()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.texts.transform)
  local txtContX, txtContY = self.texts:GetSizeDeltaXY()
  local itemHeight = txtContY + 25
  itemHeight = math.max(itemHeight, 193)
  self.root:SetSizeDeltaY(itemHeight)
end

return ChatItemPost_StageFeatureHelpInvite
