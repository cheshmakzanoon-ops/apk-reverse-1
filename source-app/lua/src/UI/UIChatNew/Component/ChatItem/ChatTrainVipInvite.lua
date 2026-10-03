local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_TrainVipInvite = BaseClass("ChatTrainVipInvite", IChatItemPost)
local base = IChatItemPost
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local UIGray = CS.UIGray
local bg_path = "Bg"
local bg_lucky_path = "Bg_lucky"
local texts_path = "Texts"
local desc_path = "Texts/Desc"
local icon_path = "Icon"
local num_path = "Icon/Num"
local ChatConfig = {
  Right = {
    Width = 496,
    Icon = 330,
    Text = 20
  },
  Left = {
    Width = 616,
    Icon = 20,
    Text = 160
  }
}

function ChatItemPost_TrainVipInvite:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemPost_TrainVipInvite:ComponentDefine()
  self.root = self:AddComponent(UIBaseContainer, "")
  self.bg = self:AddComponent(UIImage, bg_path)
  self.bg_lucky = self:AddComponent(UIImage, bg_lucky_path)
  self.receive_btn = self:AddComponent(UIButton, "")
  self.texts = self:AddComponent(UIBaseContainer, texts_path)
  self.desc = self:AddComponent(UIText, desc_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.timeText = self:AddComponent(UITextMeshProUGUIEx, num_path)
  self.receive_btn:SetOnClick(BindCallback(self, self.OnSendBtnClick))
  ChatInterface.SetEmojiTextProperty(self.desc, true)
end

function ChatItemPost_TrainVipInvite:ComponentDestroy()
  self:StopTimer()
  self.root = nil
  self.bg = nil
  self.receive_btn = nil
  self.texts = nil
  self.desc = nil
  self.icon = nil
  self.timeText = nil
  self.bg_lucky = nil
  self.gray = nil
end

function ChatItemPost_TrainVipInvite:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateMsg)
end

function ChatItemPost_TrainVipInvite:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateMsg)
  base.OnRemoveListener(self)
end

function ChatItemPost_TrainVipInvite:OnSendBtnClick()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local time = self.endTime - curTime
  if time <= 0 or self.gray then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITrainVIPBeInvitedPop, {anim = true}, self.vipType)
end

function ChatItemPost_TrainVipInvite:OnLoaded()
  local _chatdata = self:ChatData()
  if _chatdata == nil then
    return
  end
  self:Refresh(_chatdata)
end

function ChatItemPost_TrainVipInvite:Refresh(chatData)
  self:StopTimer()
  self._chatData = chatData
  local isMyChat = self._chatData:isMyChat()
  self.receive_btn:SetEnable(not isMyChat)
  local customJsonParam = self._chatData.extra and self._chatData.extra.customJsonParam
  if customJsonParam == nil then
    return
  end
  local extraJson
  if type(self._chatData.extra.customJsonParam) == "string" then
    extraJson = rapidjson.decode(self._chatData.extra.customJsonParam)
  elseif type(self._chatData.extra.customJsonParam) == "table" then
    extraJson = self._chatData.extra.customJsonParam
  else
    return
  end
  self.vipType = extraJson.vipType
  self.endTime = extraJson.endTime
  self.desc:SetLocalText("alliance_train_vip044")
  if self.vipType == TrainVipType.isBigBro then
    self.bg:SetActive(true)
    self.bg_lucky:SetActive(false)
  else
    self.bg:SetActive(false)
    self.bg_lucky:SetActive(true)
  end
  self:RefreshGrayState()
end

function ChatItemPost_TrainVipInvite:RefreshGrayState()
  local isMyChat = self._chatData:isMyChat()
  local platform = DataCenter.LWAllyStationDataManager:GetPlatform(1)
  local trainData = DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self._chatData and self._chatData.clientUpdateExtra and self._chatData.clientUpdateExtra == "1" then
    self.timeText:SetLocalText("alliance_train_vip048")
    self:SetGray(true)
  elseif trainData and trainData.vipInfo then
    if (trainData.vipInfo.vipId == LuaEntry.Player.uid or isMyChat) and platform and self.endTime == platform.vipInvite.endTime then
      self.timeText:SetLocalText("alliance_train_vip048")
      self:SetGray(true)
    else
      self.timeText:SetLocalText("alliance_train_vip045")
      self:SetGray(true)
    end
  elseif platform and platform.vipInvite then
    if self.endTime ~= platform.vipInvite.endTime then
      self.timeText:SetLocalText("alliance_train_vip045")
      self:SetGray(true)
      return
    end
    if platform.vipInvite.vipId == LuaEntry.Player.uid or isMyChat then
      if curTime < platform.vipInvite.endTime then
        if self.timer == nil then
          self:StartTimer()
        end
        self:SetGray(false)
      else
        self.timeText:SetLocalText("alliance_train_vip045")
        self:SetGray(true)
      end
    end
  else
    self.timeText:SetLocalText("alliance_train_vip045")
    self:SetGray(true)
  end
end

function ChatItemPost_TrainVipInvite:SetGray(value)
  UIGray.SetGray(self.icon.transform, value, true)
  self.gray = value
  if value then
    self:StopTimer()
  end
end

function ChatItemPost_TrainVipInvite:OnRecycle()
  self:StopTimer()
end

function ChatItemPost_TrainVipInvite:RefreshTime()
  if not self.timeText or not self.endTime then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local time = self.endTime - curTime
  if time <= 0 then
    UIGray.SetGray(self.icon.transform, true, true)
    self.timeText:SetLocalText("alliance_train_vip045")
    self.gray = true
    self:StopTimer()
  else
    self.timeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(time))
    self:RefreshGrayState()
  end
end

function ChatItemPost_TrainVipInvite:StartTimer()
  self.timeText:SetText("")
  
  function self.TimerAction()
    self:RefreshTime()
  end
  
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.TimerAction, self, false, false, false)
  end
  self.timer:Start()
end

function ChatItemPost_TrainVipInvite:StopTimer()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

function ChatItemPost_TrainVipInvite:RefreshState()
end

function ChatItemPost_TrainVipInvite:OnUpdateMsg(chatData)
  if chatData and self._chatData and chatData.seqId == self._chatData.seqId and chatData.roomId == self._chatData.roomId then
    self:Refresh(chatData)
  end
end

return ChatItemPost_TrainVipInvite
