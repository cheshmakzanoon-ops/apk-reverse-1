local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_TruckRobShare = BaseClass("TruckRobShare", IChatItemPost)
local base = IChatItemPost
local rapidjson = require("rapidjson")

function ChatItemPost_TruckRobShare:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemPost_TruckRobShare:ComponentDefine()
  self._shareNode = self:AddComponent(UIButton, "")
  self._shareNode:SetOnClick(BindCallback(self, self.OnClickBg))
  self.shareMsg = self:AddComponent(UIText, "ShareIconNode/ShareMsg")
  self.titleMsg = self:AddComponent(UIText, "ShareIconNode/TitleMsg")
  self.quality = self:AddComponent(UIImage, "ShareIconNode/TitleMsg/Quality")
end

function ChatItemPost_TruckRobShare:OnClickBg()
  if self._chatData.post == PostType.Truck_Send_Record and self.trainUuid then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTruckRecordDetail, {anim = true}, self.trainUuid, self.trainServerId)
  end
end

function ChatItemPost_TruckRobShare:OnLoaded()
  local chatdata = self:ChatData()
  if chatdata == nil then
    return
  end
  self._chatData = chatdata
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

function ChatItemPost_TruckRobShare:OnRecycle()
  self.data = nil
end

return ChatItemPost_TruckRobShare
