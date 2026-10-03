local IChatItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatItemTrain = BaseClass("ChatItemTrain", IChatItem)
local base = IChatItem
local Localization = CS.GameEntry.Localization
local ChatHead = require("UI.UIChatNew.Component.ChatHead")
local ChatUserName = require("UI.UIChatNew.Component.ChatItem.ChatUserName")
local rapidjson = require("rapidjson")
local _cp_chatHead = "ChatHead"
local _cp_shareNode = "ChatShareNode"
local _cp_chatNameLayout = "ChatNameLayout"

function ChatItemTrain:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemTrain:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ChatItemTrain:ComponentDefine()
  self._chatHead = self:AddComponent(ChatHead, _cp_chatHead)
  self._shareNode = self:AddComponent(UIButton, _cp_shareNode)
  self._shareNode:SetOnClick(BindCallback(self, self.OnClickBg))
  self._chatNameLayout = self:AddComponent(ChatUserName, _cp_chatNameLayout)
  self.title = self:AddComponent(UIText, "ChatShareNode/title")
  self.hp = self:AddComponent(UIText, "ChatShareNode/hp")
  self.name = self:AddComponent(UIText, "ChatShareNode/name")
  self.level = self:AddComponent(UIText, "ChatShareNode/level")
  self.power = self:AddComponent(UIText, "ChatShareNode/power")
  self.head = self:AddComponent(UICommonHead, "ChatShareNode/DriverHead")
end

function ChatItemTrain:ComponentDestroy()
  self.data = nil
end

function ChatItemTrain:OnClickBg()
  RailwayUtil.JumpToTrainByMarchUuid(self.data.marchUuid, self.data.serverId, self.data.worldId)
end

function ChatItemTrain:UpdateItem(chatdata, index)
  base.UpdateItem(self, chatdata, index)
  if chatdata == nil then
    return
  end
  local senderUid = chatdata.senderUid
  local _userInfo = ChatManager2:GetInstance().User:getChatUserInfo(senderUid, true)
  if self._chatNameLayout then
    self._chatNameLayout:UpdateName(_userInfo, chatdata)
  end
  local data = rapidjson.decode(chatdata.attachmentId)
  self.title:SetLocalText(458623, UIUtil.FormatAllianceAndName(data.abbr, data.name, data.uid))
  self.hp:SetLocalText("457581", math.floor(data.completeness * 100))
  self.head:SetHeadAndFrame(data.uid, data.headPic, data.headPicVer, false, data.headSkinId, data.headSkinET)
  self.name:SetText(UIUtil.FormatAllianceAndName(data.abbr, data.name, data.uid))
  self.level:SetText("Lv." .. data.level)
  self.power:SetText(string.GetFormattedSeparatorNum(data.ownerPower))
  self.data = data
end

return ChatItemTrain
