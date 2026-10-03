local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_DigTreasureShare = BaseClass("DigTreasureShare", IChatItemPost)
local base = IChatItemPost
local rapidjson = require("rapidjson")

function ChatItemPost_DigTreasureShare:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self._chatData = nil
  self.seqId = nil
  self.roomId = nil
end

function ChatItemPost_DigTreasureShare:ComponentDefine()
  self.texProgress = self:AddComponent(UITextMeshProUGUIEx, "content/textProgress")
  self.sliderProgress = self:AddComponent(UISlider, "content/Slider")
  self.textDesc = self:AddComponent(UITextMeshProUGUIEx, "content/textDesc")
  self.btnHelp = self:AddComponent(UIButton, "content/btnHelp")
  self.btnHelp:SetOnClick(function()
    self:OnClickHelp()
  end)
  self.textBtnHelp = self:AddComponent(UITextMeshProUGUIEx, "content/btnHelp/Text")
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "content/textTitle")
  self.icon = self:AddComponent(UICommonResItem, "content/UICommonResItem")
end

function ChatItemPost_DigTreasureShare:OnLoaded()
  local chatData = self:ChatData()
  if chatData == nil then
    return
  end
  if chatData.post ~= PostType.DigTreasure then
    return
  end
  self._chatData = chatData
  self.seqId = chatData:getSeqId()
  self.roomId = chatData.roomId
  self._userInfo = ChatManager2:GetInstance().User:getChatUserInfo(self._chatData.senderUid, true)
  self.maxTimes = rapidjson.decode(chatData.extra.customJsonParam).max
  self.textTitle:SetLocalText("treasure_map_help_01")
  self.textDesc:SetLocalText("treasure_map_help_02")
  local itemId = DataCenter.DigTreasureManager:GetUseItemId()
  local param = {}
  param.rewardType = RewardType.GOODS
  param.itemId = itemId
  self.icon:ReInit(param)
  self:RefreshView()
end

function ChatItemPost_DigTreasureShare:RefreshView()
  if not self._chatData then
    return
  end
  if self._chatData and self._chatData.clientUpdateExtra ~= nil then
    self.uidList = string.split(self._chatData.clientUpdateExtra, ";")
  else
    self.uidList = {}
  end
  local helpNum = self:GetHelpNum()
  self.texProgress:SetText(string.format("%d/%d", helpNum, self.maxTimes))
  self.sliderProgress:SetValue(helpNum / self.maxTimes)
  if self._chatData:isMyChat() then
    CS.UIGray.SetGray(self.btnHelp.transform, true, false)
    self.textBtnHelp:SetLocalText("treasure_map_help_05")
  else
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local isSameDay = UITimeManager:GetInstance():IsSameDayForServer(curTime // 1000, (self._chatData.serverTime or 0) // 1000)
    if isSameDay then
      if self:IsHelped() then
        self.textBtnHelp:SetLocalText("treasure_map_help_04")
        CS.UIGray.SetGray(self.btnHelp.transform, true, false)
      else
        self.textBtnHelp:SetLocalText("treasure_map_help_03")
        CS.UIGray.SetGray(self.btnHelp.transform, false, true)
      end
    else
      self.textBtnHelp:SetLocalText("red_pocket_desc6")
      CS.UIGray.SetGray(self.btnHelp.transform, true, false)
    end
  end
end

function ChatItemPost_DigTreasureShare:GetHelpNum()
  if not self.uidList then
    return 0
  end
  local uidNum = #self.uidList
  return uidNum
end

function ChatItemPost_DigTreasureShare:IsHelped()
  if not self.uidList then
    return false
  end
  for i, v in ipairs(self.uidList) do
    if v == LuaEntry.Player.uid then
      return true
    end
  end
  return false
end

function ChatItemPost_DigTreasureShare:OnUpdateMsg(chatData)
  if chatData and chatData.seqId == self.seqId and chatData.roomId == self.roomId then
    self._chatData = chatData
    self:RefreshView()
  end
end

function ChatItemPost_DigTreasureShare:OnDeleteMsg(chatData)
  if chatData and chatData.seqId == self.seqId and chatData.roomid == self.roomId then
    CS.UIGray.SetGray(self.btnHelp.transform, true, false)
    self.texProgress:SetText(string.format("%d/%d", self.maxTimes, self.maxTimes))
    self.sliderProgress:SetValue(1)
    self.textBtnHelp:SetLocalText("red_pocket_desc6")
  end
end

function ChatItemPost_DigTreasureShare:OnClickHelp()
  if self._chatData:isMyChat() then
    return
  end
  if self:GetHelpNum() >= self.maxTimes then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.DigTreasureGiveHammer, self._chatData.senderUid)
end

function ChatItemPost_DigTreasureShare:OnHelpSuccess(uid)
  if self._chatData and uid == self._chatData.senderUid then
    self.textBtnHelp:SetLocalText("treasure_map_help_04")
    CS.UIGray.SetGray(self.btnHelp.transform, true, false)
  end
end

function ChatItemPost_DigTreasureShare:OnRecycle()
  self._chatData = nil
  self.seqId = nil
  self.roomId = nil
end

function ChatItemPost_DigTreasureShare:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateMsg)
  self:AddUIListener(ChatEventEnum.CHAT_DEL_MSG, self.OnDeleteMsg)
  self:AddUIListener(EventId.OnPassDay, self.RefreshView)
  self:AddUIListener(EventId.DigTreasureHelpSuccess, self.OnHelpSuccess)
end

function ChatItemPost_DigTreasureShare:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateMsg)
  self:RemoveUIListener(ChatEventEnum.CHAT_DEL_MSG, self.OnDeleteMsg)
  self:RemoveUIListener(EventId.OnPassDay, self.RefreshView)
  self:RemoveUIListener(EventId.DigTreasureHelpSuccess, self.OnHelpSuccess)
  base.OnRemoveListener(self)
end

return ChatItemPost_DigTreasureShare
