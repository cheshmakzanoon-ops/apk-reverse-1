local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_AllianceTaskShare = BaseClass("AllianceTaskShare", IChatItemPost)
local base = IChatItemPost
local rapidjson = require("rapidjson")
local _cp_ShareTitle = "ShareTitle"
local _cp_shareMsg = "ShareIconNode/ShareMsg/ShareMsg"
local _cp_shareNode = ""
local _cp_prog = "ShareIconNode/Progress"
local _cp_progTxt = "ShareIconNode/Progress/Txt_Progress"
local start_time_path = "ShareIconNode/startTime"

function ChatItemPost_AllianceTaskShare:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemPost_AllianceTaskShare:ComponentDefine()
  self._shareTitle = self:AddComponent(UIText, _cp_ShareTitle)
  self._shareMsg = self:AddComponent(UIText, _cp_shareMsg)
  self._shareNode = self:AddComponent(UIButton, _cp_shareNode)
  self._shareNode:SetOnClick(BindCallback(self, self.OnClickBg))
  self._shareProg = self:AddComponent(UISlider, _cp_prog)
  self._shareProgTxt = self:AddComponent(UIText, _cp_progTxt)
  self.countDownTxt = self:AddComponent(UIText, start_time_path)
end

function ChatItemPost_AllianceTaskShare:OnClickBg()
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

function ChatItemPost_AllianceTaskShare:OnLoaded()
  local chatdata = self:ChatData()
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

function ChatItemPost_AllianceTaskShare:OnRecycle()
  self:DelTimer()
end

function ChatItemPost_AllianceTaskShare:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.SetRemainTime, self, false, false, false)
  end
  self.timer:Start()
end

function ChatItemPost_AllianceTaskShare:SetRemainTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.endTime - curTime
  if 0 < remainTime then
    self.countDownTxt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self:DelTimer()
    self.countDownTxt:SetLocalText("390980")
  end
end

function ChatItemPost_AllianceTaskShare:DelTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

return ChatItemPost_AllianceTaskShare
