local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_FireworkGift = BaseClass("ChatItemPost_FireworkGift", IChatItemPost)
local base = IChatItemPost
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")

function ChatItemPost_FireworkGift:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemPost_FireworkGift:ComponentDefine()
  self.bgIcon = self:AddComponent(UIRawImage, "anim_root/bg")
  self.titleText = self:AddComponent(UITextMeshProUGUIEx, "anim_root/title")
  self.icon = self:AddComponent(UIImage, "anim_root/icon/icon1")
  self.fireworkEffect1 = self:AddComponent(UIImage, "anim_root/icon/Eff_ui_firework_firecraker_01")
  self.fireworkEffect2 = self:AddComponent(UIImage, "anim_root/icon/Eff_ui_firework_firecraker_02")
  self.fireworkEffect3 = self:AddComponent(UIImage, "anim_root/icon/Eff_ui_firework_firecraker_03")
  self.fireworkEffect1:SetActive(false)
  self.fireworkEffect2:SetActive(false)
  self.fireworkEffect3:SetActive(false)
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    if not self:GetIsOverdue() then
      local isAllTaken = #self.uids >= self.fireworkBoxMaxNum
      if self:GetIsReceive() or isAllTaken then
        local viewData = {
          uuid = self.extraJson.uuid,
          ownerUid = self.extraJson.ownerUid
        }
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIFireworkGiftRecord, {anim = true}, viewData)
      else
        local data = {
          uuid = self.extraJson.uuid,
          ownerUid = self.extraJson.ownerUid
        }
        SFSNetwork.SendMessage(MsgDefines.FindFireworksGiftWorldPoint, data)
      end
    else
      UIUtil.ShowTipsId("alliance_duel_gacha_tips_1018")
    end
  end)
end

function ChatItemPost_FireworkGift:UpdateItem(_chat_data, _index)
  self:RefreshView(_chat_data)
end

function ChatItemPost_FireworkGift:OnUpdateRoomMsg(chatData)
  if chatData then
    if chatData.seqId ~= self._chatData:getSeqId() or chatData.post ~= PostType.FIREWORK_GIFT_REWARD then
      return
    end
    self:RefreshView(chatData)
  end
end

function ChatItemPost_FireworkGift:RefreshView(chatData)
  if chatData == nil then
    return
  end
  self._chatData = chatData
  self._userInfo = ChatManager2:GetInstance().User:getChatUserInfo(self._chatData.senderUid)
  if self._chatData.extra ~= nil and self._chatData.extra.customJsonParam ~= nil then
    self.extraJson = rapidjson.decode(self._chatData.extra.customJsonParam)
    local existTime = LuaEntry.DataConfig:TryGetNum("fireworks", "k2", 120)
    self.extraJson.expiredTime = self._chatData.serverTime + existTime * 60 * 1000
  end
  self.uids = {}
  if self.extraJson and self.extraJson.configId then
    self.fireworkLineData = LocalController:instance():getLine(TableName.Firework, self.extraJson.configId)
    if self.fireworkLineData then
      local goodsTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(self.extraJson.configId)
      if goodsTemplate then
        self.fireworkEffect1:SetActive(goodsTemplate.color == 3)
        self.fireworkEffect2:SetActive(goodsTemplate.color == 4)
        self.fireworkEffect3:SetActive(goodsTemplate.color == 5)
        self.icon:LoadSprite(string.format(LoadPath.ItemPath, goodsTemplate.icon))
      end
      local rewardListStr = self.fireworkLineData.reward
      local rewardList = string.split(rewardListStr, "|")
      self.extraJson.index = self.extraJson.index or 0
      local boxDataStr = rewardList[self.extraJson.index + 1]
      if boxDataStr then
        local boxDataList = string.split(boxDataStr, ";")
        if 3 <= #boxDataList then
          self.fireworkBoxMaxNum = tonumber(boxDataList[3])
        end
      end
    end
  end
  local name
  if self._userInfo then
    name = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self._userInfo.uid, self._userInfo.userName)
  end
  self.titleText:SetLocalText("firework_interface_1009", name)
  if self._chatData.clientUpdateExtra then
    self.uids = {}
    local tempList = string.split(self._chatData.clientUpdateExtra, "|")
    for k, v in ipairs(tempList) do
      table.insert(self.uids, v)
    end
  end
end

function ChatItemPost_FireworkGift:GetIsOverdue()
  if not self.extraJson.expiredTime or self.extraJson.expiredTime <= 0 then
    return false
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.expiredTime = tonumber(self.extraJson.expiredTime) or 0
  local time = self.expiredTime - curTime
  if time <= 0 then
    return true
  end
end

function ChatItemPost_FireworkGift:GetIsNone()
  if self.uids and #self.uids >= self.fireworkBoxMaxNum then
    return true
  end
end

function ChatItemPost_FireworkGift:GetIsReceive()
  for i = 1, #self.uids do
    if self.uids[i] == LuaEntry.Player.uid then
      return true
    end
  end
end

function ChatItemPost_FireworkGift:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateRoomMsg)
end

function ChatItemPost_FireworkGift:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateRoomMsg)
  base.OnRemoveListener(self)
end

function ChatItemPost_FireworkGift:OnRecycle()
end

function ChatItemPost_FireworkGift:HandleLongPress()
  return true
end

return ChatItemPost_FireworkGift
