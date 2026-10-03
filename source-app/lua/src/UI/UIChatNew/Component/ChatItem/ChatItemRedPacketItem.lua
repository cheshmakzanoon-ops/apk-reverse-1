local IChatItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatItemRedPacketItem = BaseClass("ChatItemRedPacketItem", IChatItem)
local ChatHead = require("UI.UIChatNew.Component.ChatHead")
local ChatUserName = require("UI.UIChatNew.Component.ChatItem.ChatUserName")
local rapidjson = require("rapidjson")
local Localization = CS.GameEntry.Localization
local base = IChatItem
local UIGray = CS.UIGray

function ChatItemRedPacketItem:ComponentDefine()
  self._chatHead = self:AddComponent(ChatHead, "ChatHead")
  self._chatUserName = self:AddComponent(ChatUserName, "ChatNameLayout")
  self.bgIcon = self:AddComponent(UIImage, "ChatRedPacket/bg")
  self.titleText = self:AddComponent(UITextMeshProUGUIEx, "ChatRedPacket/title")
  self.icon = self:AddComponent(UIImage, "ChatRedPacket/icon")
  self.contentText = self:AddComponent(UITextMeshProUGUIEx, "ChatRedPacket/content")
  self.countText = self:AddComponent(UITextMeshProUGUIEx, "ChatRedPacket/count")
  self.btn = self:AddComponent(UIButton, "ChatRedPacket")
  self.btn:SetOnClick(function()
    if ChatManager2:GetInstance():CanNotPickRedPacket(self.extraJson) then
      UIUtil.ShowTipsId("zone_war_government_04")
    else
      if self.extraJson ~= nil then
        local redPocketTemp = DataCenter.RedPacketTemplateManager:GetTemplateByGoodsId(self.extraJson.goodsId)
        if redPocketTemp ~= nil and not redPocketTemp:Condition(true) then
          return
        end
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIRedPacketOperation, {anim = true}, {
        extraJson = self.extraJson,
        chatData = self._chatData
      })
    end
  end)
end

function ChatItemRedPacketItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateRoomMsg)
end

function ChatItemRedPacketItem:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateRoomMsg)
  base.OnRemoveListener(self)
end

function ChatItemRedPacketItem:OnUpdateRoomMsg(chatData)
  if chatData then
    if chatData:getSeqId() ~= self._chatData:getSeqId() or chatData.post ~= PostType.RedPackge_New then
      return
    end
    self:UpdateItem(chatData)
  end
end

function ChatItemRedPacketItem:OnCreate()
  base.OnCreate(self)
  self.uids = {}
  self:ComponentDefine()
end

function ChatItemRedPacketItem:UpdateItem(chatData)
  self._chatData = chatData
  self.seqId = chatData:getSeqId()
  self._userInfo = ChatManager2:GetInstance().User:getChatUserInfo(self._chatData.senderUid)
  self.data = chatData:getMessageParam()
  if self._chatData.extra ~= nil and self._chatData.extra.customJsonParam ~= nil then
    self.extraJson = rapidjson.decode(self._chatData.extra.customJsonParam)
  end
  self:RefreshView()
end

function ChatItemRedPacketItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function ChatItemRedPacketItem:GetIsOverdue()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.expiredTime = tonumber(self.extraJson.expiredTime)
  local time = self.expiredTime - curTime
  if time <= 0 then
    return true
  end
end

function ChatItemRedPacketItem:GetIsNone()
  if self.uids and #self.uids >= self.redPocketTemp.num then
    return true
  end
end

function ChatItemRedPacketItem:GetIsReceive()
  for i = 1, #self.uids do
    if self.uids[i] == LuaEntry.Player.uid then
      return true
    end
  end
end

function ChatItemRedPacketItem:RefreshView()
  self.uids = {}
  self._chatHead:UpdateHead(self._userInfo, self._chatData)
  self._chatUserName:UpdateName(self._userInfo, self._chatData)
  if self.extraJson.packetId then
    self.redPocketTemp = DataCenter.RedPacketTemplateManager:GetTemplate(self.extraJson.packetId)
  else
    self.redPocketTemp = DataCenter.RedPacketTemplateManager:GetTemplateByGoodsId(self.extraJson.goodsId, true)
  end
  self.titleText:SetLocalText(self.redPocketTemp:GetName())
  self.contentText:SetLocalText(self.redPocketTemp.chat_desc)
  if self._chatData.clientUpdateExtra then
    local temp = string.split(self._chatData.clientUpdateExtra, "|")
    if not string.IsNullOrEmpty(temp[2]) then
      self.uids = string.split(temp[2], ",")
    end
  end
  if self:GetIsNone() or self:GetIsOverdue() then
    self.bgIcon:LoadSpriteAsync(self.redPocketTemp.GetPath(self.redPocketTemp.chat_bg_2))
    self.icon:LoadSpriteAsync(self.redPocketTemp.GetPath(self.redPocketTemp.chat_empty_icon))
  else
    self.bgIcon:LoadSpriteAsync(self.redPocketTemp.GetPath(self.redPocketTemp.chat_bg))
    self.icon:LoadSpriteAsync(self.redPocketTemp.GetPath(self.redPocketTemp.chat_icon))
  end
  if self:GetIsReceive() then
    self.icon:LoadSprite(self.redPocketTemp.GetPath(self.redPocketTemp.chat_empty_icon))
  end
  local default = self.extraJson.hasRob and 1 or 0
  local count = math.max(#self.uids, default)
  self.countText:SetText(count .. "/" .. self.redPocketTemp.num)
end

function ChatItemRedPacketItem:ComponentDestroy()
end

function ChatItemRedPacketItem:DataDestroy()
end

return ChatItemRedPacketItem
