local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_PostMilitaryPayShare = BaseClass("PostMilitaryPayShare", IChatItemPost)
local base = IChatItemPost
local rapidjson = require("rapidjson")
local Localization = CS.GameEntry.Localization
local UICommonHorseLampTMP = require("UI.UICommonTMPHorseRaceLamp.Component.UICommonHorseLampTMP")

function ChatItemPost_PostMilitaryPayShare:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemPost_PostMilitaryPayShare:ComponentDefine()
  self.root = self:AddComponent(UIButton, "")
  self.root:SetOnClick(function()
    self:GoToTaskPanel()
  end)
  self.imgBg = self:AddComponent(UIImage, "bg/img1")
  self.imgBox = self:AddComponent(UIImage, "bg/img2")
  self.commonHorseLampTMP = self:AddComponent(UICommonHorseLampTMP, "UICommonHorseLampTMP")
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "UICommonHorseLampTMP/NameText")
  self.textCountdown = self:AddComponent(UITextMeshProUGUIEx, "textCountdown")
  self.textDes = self:AddComponent(UITextMeshProUGUIEx, "textDes")
  self.textProgress = self:AddComponent(UITextMeshProUGUIEx, "textProgress")
  self.slider = self:AddComponent(UISlider, "slider")
end

function ChatItemPost_PostMilitaryPayShare:OnLoaded()
  local chatData = self:ChatData()
  self.seqId = chatData:getSeqId()
  self.roomId = chatData.roomId
  self:Refresh(chatData)
  self:SetUIStyle(chatData)
  self:SetRemainTime()
  self:AddTimer()
end

function ChatItemPost_PostMilitaryPayShare:Refresh(chatData)
  self._chatData = chatData
  local isMyChat = self._chatData:isMyChat()
  if self._chatData then
    if self._chatData.extra and self._chatData.extra.customJsonParam then
      self.data = rapidjson.decode(self._chatData.extra.customJsonParam)
      self.configId = tonumber(self.data.configId)
      self.endTime = tonumber(self.data.endTimeStamp)
    end
    if self._chatData.clientUpdateExtra then
      self.score = tonumber(self._chatData.clientUpdateExtra)
    end
  end
  if self.configId and self.configId > 0 then
    local template = DataCenter.AlliancePayTemplateManager:GetTemplate(self.configId)
    local conditionTable = template.conditionTable
    local showCondition = template.share_condition
    self.maxScore = conditionTable[showCondition] or 0
    local color = template.color
    self.imgBox:LoadSprite(string.format(LoadPath.LWAllianceMilitaryPayIconPath, AllianceSalaryRewardImage[color]))
  end
  self.textDes:SetLocalText("alliance_pay_conditionName_2")
  self.textProgress:SetText(string.format("%d/%d", self.score or 0, self.maxScore or 0))
  self.commonHorseLampTMP:SetLocalTextWithLength("alliance_pay_desc_daily", 495, NoRollingAlignment.Left)
  self.slider:SetValue((self.score or 0) / (self.maxScore or 1))
end

function ChatItemPost_PostMilitaryPayShare:OnRecycle()
  self:DelTimer()
end

function ChatItemPost_PostMilitaryPayShare:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateMsg)
end

function ChatItemPost_PostMilitaryPayShare:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateMsg)
  base.OnRemoveListener(self)
end

function ChatItemPost_PostMilitaryPayShare:OnUpdateMsg(chatData)
  if chatData and chatData.seqId == self.seqId and chatData.roomId == self.roomId then
    self:Refresh(chatData)
  end
end

function ChatItemPost_PostMilitaryPayShare:AddTimer()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime >= self.endTime then
    return
  end
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.SetRemainTime, self, false, false, false)
  end
  self.timer:Start()
end

function ChatItemPost_PostMilitaryPayShare:SetRemainTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.endTime - curTime
  if 0 < remainTime then
    self.textCountdown:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self:DelTimer()
    self.textCountdown:SetLocalText("390843")
  end
end

function ChatItemPost_PostMilitaryPayShare:DelTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function ChatItemPost_PostMilitaryPayShare:GoToTaskPanel()
  GoToUtil.GotoOpenView(UIWindowNames.UILWQuestList, UIQuestTab.Daily)
end

function ChatItemPost_PostMilitaryPayShare:SetUIStyle(chatData)
  local isMyChat = chatData:isMyChat()
  if isMyChat then
    self.imgBg:LoadSprite(ChatInterface.GetChatUIPath(UIAssets.ChatItemBg_right))
    self.textTitle:SetColorHex("626e8a")
  else
    self.imgBg:LoadSprite(ChatInterface.GetChatUIPath(UIAssets.ChatItemBg_left))
    self.textTitle:SetColorHex("a29791")
  end
end

return ChatItemPost_PostMilitaryPayShare
