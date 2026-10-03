local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_RedPackage = BaseClass("ChatItemPost_RedPackage", IChatItemPost)
local base = IChatItemPost
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")

function ChatItemPost_RedPackage:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemPost_RedPackage:ComponentDefine()
  self.bgIcon = self:AddComponent(UIRawImage, "bg")
  self.titleText = self:AddComponent(UITextMeshProUGUIEx, "title")
  self.icon = self:AddComponent(UIImage, "icon")
  self.contentText = self:AddComponent(UITextMeshProUGUIEx, "content")
  self.countText = self:AddComponent(UITextMeshProUGUIEx, "count")
  self.like = self:AddComponent(UIBaseComponent, "like")
  self.likeText = self:AddComponent(UITextMeshProUGUIEx, "like/num")
  self.likeIcon = self:AddComponent(UIImage, "like/likeIcon")
  self.likeBg = self:AddComponent(UIImage, "like/likeBg")
  self.btn = self:AddComponent(UIButton, "")
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
  self.chatUpNum = 0
end

function ChatItemPost_RedPackage:OnLoaded()
  self:RefreshView(self:ChatData())
end

function ChatItemPost_RedPackage:OnUpdateRoomMsg(chatData)
  if chatData then
    if chatData.seqId ~= self._chatData:getSeqId() or chatData.post ~= PostType.RedPackge_New then
      return
    end
    self:RefreshView(chatData)
  end
end

function ChatItemPost_RedPackage:RefreshView(chatData)
  if chatData == nil then
    return
  end
  self._chatData = chatData
  self._userInfo = ChatManager2:GetInstance().User:getChatUserInfo(self._chatData.senderUid)
  if self._chatData.extra ~= nil and self._chatData.extra.customJsonParam ~= nil then
    self.extraJson = rapidjson.decode(self._chatData.extra.customJsonParam)
  end
  self.uids = {}
  if self.extraJson.packetId then
    self.redPocketTemp = DataCenter.RedPacketTemplateManager:GetTemplate(self.extraJson.packetId)
  else
    self.redPocketTemp = DataCenter.RedPacketTemplateManager:GetTemplateByGoodsId(self.extraJson.goodsId, true)
  end
  self.titleText:SetLocalText(self.redPocketTemp:GetName())
  if self.redPocketTemp.type == RedPacketType.LuckyWithoutBuff or self.redPocketTemp.type == RedPacketType.LuckyBuff then
    local item_desc = ""
    if self.extraJson.luckSiphonId then
      local lucky_config = DataCenter.LuckyBuffManager:GetLuckyConfigById(self.extraJson.luckSiphonId) or {}
      local reward_item_list = lucky_config.para1 or {}
      local reward_item_id = reward_item_list[2]
      local reward_item_count = reward_item_list[3]
      if 1 < reward_item_count then
        item_desc = string.format("%s*%d", DataCenter.ItemTemplateManager:GetName(reward_item_id), reward_item_count)
      else
        item_desc = string.format("%s", DataCenter.ItemTemplateManager:GetName(reward_item_id))
      end
    end
    self.contentText:SetLocalText(self.redPocketTemp.chat_desc, item_desc)
  else
    self.contentText:SetLocalText(self.redPocketTemp.chat_desc)
  end
  self.chatUpNum = 0
  if self._chatData.clientUpdateExtra then
    local temp = string.split(self._chatData.clientUpdateExtra, "|")
    if not string.IsNullOrEmpty(temp[2]) then
      self.uids = string.split(temp[2], ",")
    end
    self.chatUpNum = tonumber(temp[3]) or 0
  end
  if self.redPocketTemp and self.redPocketTemp.like_type == 1 then
    self.like:SetActive(true)
    self.likeText:SetText(self.chatUpNum)
    self.likeBg:SetActive(false)
    self.likeIcon:SetLocalScaleXYZ(1, 1, 1)
    if self.redPocketTemp.type == RedPacketType.Birthday then
      self.likeIcon:LoadSprite("Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/zyf_shengrixitong_dangao_anniu_2.png")
      self.likeBg:SetActive(true)
      self.likeBg:LoadSprite("Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/zyf_shengrixitong_anniu_di.png")
      self.likeBg:SetNativeSize()
      self.likeIcon:SetLocalScaleXYZ(0.5, 0.5, 0.5)
      self.likeBg:SetLocalScaleXYZ(0.5, 0.5, 0.5)
    else
      self.likeIcon:LoadSprite("Assets/Main/Sprites/UI/UIChatNew1/icon_great_light.png")
    end
    self.likeIcon:SetNativeSize()
  else
    self.like:SetActive(false)
  end
  if self:GetIsNone() or self:GetIsOverdue() then
    self.bgIcon:LoadSpriteAsync(self.redPocketTemp.GetPath(self.redPocketTemp.chat_bg_2, true))
    self.icon:LoadSpriteAsync(self.redPocketTemp.GetPath(self.redPocketTemp.chat_empty_icon))
  else
    self.bgIcon:LoadSpriteAsync(self.redPocketTemp.GetPath(self.redPocketTemp.chat_bg, true))
    self.icon:LoadSpriteAsync(self.redPocketTemp.GetPath(self.redPocketTemp.chat_icon))
  end
  if self:GetIsReceive() then
    self.icon:LoadSpriteAsync(self.redPocketTemp.GetPath(self.redPocketTemp.chat_empty_icon))
  end
  local default = self.extraJson.hasRob and 1 or 0
  local num = 0
  for _, uid in ipairs(self.uids) do
    if not string.IsNullOrEmpty(uid) then
      num = num + 1
    end
  end
  local count = math.max(num, default)
  self.countText:SetText(count .. "/" .. self.redPocketTemp.num)
  if DataCenter.RedPacketManager:CheckIsBirthdayTypeByChatData(self._chatData) then
    EventManager:GetInstance():Broadcast(EventId.OnChatBirthdayRedPacketShow, self._chatData)
  end
end

function ChatItemPost_RedPackage:GetIsOverdue()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.expiredTime = tonumber(self.extraJson.expiredTime)
  local time = self.expiredTime - curTime
  if time <= 0 then
    return true
  end
end

function ChatItemPost_RedPackage:GetIsNone()
  if self.uids and #self.uids >= self.redPocketTemp.num then
    return true
  end
end

function ChatItemPost_RedPackage:GetIsReceive()
  for i = 1, #self.uids do
    if self.uids[i] == LuaEntry.Player.uid then
      return true
    end
  end
end

function ChatItemPost_RedPackage:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateRoomMsg)
end

function ChatItemPost_RedPackage:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateRoomMsg)
  base.OnRemoveListener(self)
end

function ChatItemPost_RedPackage:OnRecycle()
end

function ChatItemPost_RedPackage:HandleLongPress()
  return true
end

return ChatItemPost_RedPackage
