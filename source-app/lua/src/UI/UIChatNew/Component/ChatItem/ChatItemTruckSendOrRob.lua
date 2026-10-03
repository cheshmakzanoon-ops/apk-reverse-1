local IChatItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatItemTruckSendOrRob = BaseClass("ChatItemTruckSendOrRob", IChatItem)
local base = IChatItem
local Localization = CS.GameEntry.Localization
local ChatHead = require("UI.UIChatNew.Component.ChatHead")
local ChatUserName = require("UI.UIChatNew.Component.ChatItem.ChatUserName")
local rapidjson = require("rapidjson")
local _cp_chatHead = "ChatHead"
local _cp_shareNode = "ChatShareNode"
local _cp_chatNameLayout = "ChatNameLayout"

function ChatItemTruckSendOrRob:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemTruckSendOrRob:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ChatItemTruckSendOrRob:ComponentDefine()
  self._chatHead = self:AddComponent(ChatHead, _cp_chatHead)
  self._shareNode = self:AddComponent(UIButton, _cp_shareNode)
  self._shareNode:SetOnClick(BindCallback(self, self.OnClickBg))
  self._chatNameLayout = self:AddComponent(ChatUserName, _cp_chatNameLayout)
  self.shareMsg = self:AddComponent(UIText, "ChatShareNode/ShareIconNode/ShareMsg")
  self.titleMsg = self:AddComponent(UIText, "ChatShareNode/ShareIconNode/TitleMsg")
  self.quality = self:AddComponent(UIImage, "ChatShareNode/ShareIconNode/TitleMsg/Quality")
end

function ChatItemTruckSendOrRob:ComponentDestroy()
  self.data = nil
end

function ChatItemTruckSendOrRob:OnClickBg()
  if self._chatData.post == PostType.Truck_Send_Record and self.trainUuid then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTruckRecordDetail, {anim = true}, self.trainUuid, self.trainServerId)
  end
end

function ChatItemTruckSendOrRob:UpdateItem(chatdata, index)
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
  self.trainUuid = data.trainUuid
  self.trainServerId = data.trainServerId
  self.reportUid = data.reportUid
  if data.quality then
    self.quality:LoadSprite(QualityImagePath[data.quality])
  end
  self.quality:SetNativeSize()
  self.titleMsg:SetLocalText("city_trade_tips1005")
  local otherName = ""
  if string.IsNullOrEmpty(data.fullName) then
    if string.IsNullOrEmpty(data.otherAbbr) then
      otherName = data.otherName
    else
      otherName = "[" .. data.otherAbbr .. "]" .. data.otherName
    end
  else
    otherName = data.fullName
  end
  if data.truckState == TruckStateType.Safe then
    self.shareMsg:SetLocalText("city_trade_tips1006")
  elseif data.truckState == TruckStateType.Robed then
    self.shareMsg:SetLocalText("city_trade_tips1007", otherName)
  elseif data.truckState == TruckStateType.DefendSuccess then
    self.shareMsg:SetLocalText("city_trade_tips1008", otherName)
  end
  self.data = data
end

return ChatItemTruckSendOrRob
