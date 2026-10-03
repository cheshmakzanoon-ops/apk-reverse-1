local IChatItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatItemAllianceTaskShare = BaseClass("ChatItemAllianceTaskShare", IChatItem)
local base = IChatItem
local Localization = CS.GameEntry.Localization
local ChatHead = require("UI.UIChatNew.Component.ChatHead")
local ChatUserName = require("UI.UIChatNew.Component.ChatItem.ChatUserName")
local rapidjson = require("rapidjson")
local _cp_chatHead = "ChatHead"
local _cp_ShareTitle = "ChatShareNode/ShareTitle"
local _cp_shareMsg = "ChatShareNode/ShareIconNode/ShareMsg/ShareMsg"
local _cp_shareNode = "ChatShareNode"
local _cp_chatNameLayout = "ChatNameLayout"
local _cp_prog = "ChatShareNode/ShareIconNode/Progress"
local _cp_progTxt = "ChatShareNode/ShareIconNode/Progress/Txt_Progress"
local start_time_path = "ChatShareNode/ShareIconNode/startTime"
local UnityOutLine = typeof(CS.UnityEngine.UI.Outline)

function ChatItemAllianceTaskShare:ComponentDefine()
  self._chatHead = self:AddComponent(ChatHead, _cp_chatHead)
  self._shareTitle = self:AddComponent(UIText, _cp_ShareTitle)
  self._shareMsg = self:AddComponent(UIText, _cp_shareMsg)
  self._shareNode = self:AddComponent(UIButton, _cp_shareNode)
  self._shareNode:SetOnClick(BindCallback(self, self.OnClickBg))
  self._chatNameLayout = self:AddComponent(ChatUserName, _cp_chatNameLayout)
  self._shareProg = self:AddComponent(UISlider, _cp_prog)
  self._shareProgTxt = self:AddComponent(UIText, _cp_progTxt)
  self.countDownTxt = self:AddComponent(UIText, start_time_path)
end

function ChatItemAllianceTaskShare:OnClickBg()
  if self.attachInfo ~= nil then
    EventManager:GetInstance():Broadcast(ChatEventEnum.LF_CloseChatView, true)
    local taskId = self.attachInfo.taskId
    local season_group = GetTableData(TableName.AllianceTask, taskId, "season_group")
    if self.attachInfo.isSeason or season_group ~= nil and season_group ~= 0 then
      local tempIndex = DataCenter.AllianceSeasonTaskManager:GetTaskIndex(taskId)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceTask, {anim = true, hideTop = true}, tempIndex, true)
    else
      local tempIndex = DataCenter.AllianceTaskManager:GetTaskIndex(taskId)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceTask, {anim = true, hideTop = true}, tempIndex, false)
    end
  end
end

function ChatItemAllianceTaskShare:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemAllianceTaskShare:OnDestroy()
  self:DelTimer()
  base.OnDestroy(self)
end

function ChatItemAllianceTaskShare:UpdateItem(chatdata, index)
  base.UpdateItem(self, chatdata, index)
  if chatdata == nil then
    return
  end
  local attachmentId = chatdata.attachmentId or ""
  local tabAttachment = rapidjson.decode(attachmentId) or {}
  self.attachInfo = tabAttachment
  local msgTb = chatdata:getMessageParam(false)
  self._shareTitle:SetLocalText(msgTb.taskName)
  self._shareMsg:SetLocalText(310000)
  local maxProg = msgTb.maxProg or 100
  self._shareProg:SetValue(msgTb.curProg / maxProg)
  self._shareProgTxt:SetText(msgTb.curProg .. "/" .. maxProg)
  if msgTb.tempTime and msgTb.tempTime > UITimeManager:GetInstance():GetServerTime() then
    self.endTime = msgTb.tempTime
    self:SetRemainTime()
    self:AddTimer()
  else
    self.countDownTxt:SetLocalText("390980")
  end
  local senderUid = chatdata.senderUid
  local _userInfo = ChatManager2:GetInstance().User:getChatUserInfo(senderUid, true)
  if self._chatNameLayout then
    self._chatNameLayout:UpdateName(_userInfo, chatdata)
  end
end

function ChatItemAllianceTaskShare:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.SetRemainTime, self, false, false, false)
  end
  self.timer:Start()
end

function ChatItemAllianceTaskShare:SetRemainTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.endTime - curTime
  if 0 < remainTime then
    self.countDownTxt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self:DelTimer()
    self.countDownTxt:SetLocalText("390980")
  end
end

function ChatItemAllianceTaskShare:DelTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

return ChatItemAllianceTaskShare
