local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatZombieAttackCityAssistanceDefend = BaseClass("ChatZombieAttackCityAssistanceDefend", IChatItemPost)
local base = IChatItemPost
local rapidjson = require("rapidjson")
local Localization = CS.GameEntry.Localization
local btn_path = "btnlayout/ZanBtn"
local gift_btn_path = "btnlayout/GiftBtn"
local liked_img_path = "LikedImg"
local desc_text_path = "DesText"
local active_anim_path = "LikedImg/ActiveAnim"
local likeSticker_path = "LikeStickerDynamic"

function ChatZombieAttackCityAssistanceDefend:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatZombieAttackCityAssistanceDefend:OnDestroy()
  self:ClearTimer()
  base.OnDestroy(self)
end

function ChatZombieAttackCityAssistanceDefend:ComponentDefine()
  self.likedImg = self:AddComponent(UIButton, liked_img_path)
  self.desc = self:AddComponent(UIText, desc_text_path)
  self.heart_effect = self:AddComponent(UIBaseContainer, active_anim_path)
  self.heart_effect:SetActive(false)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:Interactive()
  end)
  self.likedImg:SetOnClick(function()
    self:OnClickLikeImg()
  end)
  self.likeSticker = self:AddComponent(UIBaseContainer, likeSticker_path)
  self.gift_btn = self:AddComponent(UIButton, gift_btn_path)
  self.gift_btn:SetOnClick(function()
    self:OnGiftBtnClick()
  end)
end

function ChatZombieAttackCityAssistanceDefend:OnLoaded()
  local chatData = self:ChatData()
  self.seqId = chatData:getSeqId()
  self.roomId = chatData.roomId
  self.curLike = false
  self:Refresh(chatData)
end

function ChatZombieAttackCityAssistanceDefend:Refresh(chatData)
  self._chatData = chatData
  local isMyChat = self._chatData:isMyChat()
  self.btn:SetActive(false)
  self.gift_btn:SetActive(false)
  if chatData and chatData.clientUpdateExtra and chatData.clientUpdateExtra == "liked" then
    self.likedImg:SetActive(true)
    self.curLike = true
  else
    self.likedImg:SetActive(false)
    if not isMyChat then
      self.btn:SetActive(true)
    end
  end
  if not isMyChat then
    self.gift_btn:SetActive(true)
  end
  if chatData and chatData.extra and chatData.extra.monsterId then
    local monsterId = chatData.extra.monsterId
    if monsterId then
      local cfg = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterId)
      if cfg then
        self.desc:SetLocalText("gift_tips_2", cfg.level)
      end
    end
  end
  if isMyChat then
    self.desc:SetAnchoredPositionXY(150, 0)
    self.likedImg:SetAnchoredPositionXY(10, -15)
    self.likeSticker:SetAnchoredPositionXY(15, -13)
    self.likeSticker:SetLocalScaleXYZ(1, 1, 1)
  else
    self.desc:SetAnchoredPositionXY(21, 0)
    self.likedImg:SetAnchoredPositionXY(453, -15)
    self.likeSticker:SetAnchoredPositionXY(490, -13)
    self.likeSticker:SetLocalScaleXYZ(-1, 1, 1)
  end
end

function ChatZombieAttackCityAssistanceDefend:OnRecycle()
end

function ChatZombieAttackCityAssistanceDefend:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateMsg)
end

function ChatZombieAttackCityAssistanceDefend:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateMsg)
  base.OnRemoveListener(self)
end

function ChatZombieAttackCityAssistanceDefend:OnUpdateMsg(chatData)
  if chatData and chatData.seqId == self.seqId and chatData.roomId == self.roomId then
    local oldLike = self.curLike
    self:Refresh(chatData)
    if oldLike ~= self.curLike and self.curLike == true then
      self.heart_effect:SetActive(true)
      self:ClearTimer()
      self.timer = TimerManager:GetInstance():DelayInvoke(function()
        if self and self.heart_effect then
          self.heart_effect:SetActive(false)
          self.timer = nil
        end
      end)
    end
  end
end

function ChatZombieAttackCityAssistanceDefend:Interactive()
  if self._chatData then
    local seqId = self.seqId
    local senderUid = self._chatData.senderUid
    local roomId = self._chatData.roomId
    local name = self._chatData:getSenderName()
    local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self._chatData.senderUid, name)
    ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.ChatUpdate, roomId, seqId, "liked")
  end
end

function ChatZombieAttackCityAssistanceDefend:OnGiftBtnClick()
  if self._chatData then
    DataCenter.GiftSystemManager:OpenOperationView({
      windowType = GiftSystemConst.WindowType.Send,
      targetUid = self._chatData.senderUid,
      targetServerId = LuaEntry.Player.serverId
    })
  end
end

function ChatZombieAttackCityAssistanceDefend:ClearTimer()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

function ChatZombieAttackCityAssistanceDefend:OnClickLikeImg()
  if self._chatData then
    local isMyChat = self._chatData:isMyChat()
    if isMyChat then
      local roomData = ChatInterface.getRoomData(self._chatData.roomId)
      local targetMemberId = roomData:GetPrivateUser()
      local userInfo = ChatManager2:GetInstance().User:getChatUserInfo(targetMemberId, true)
      if userInfo then
        local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(userInfo.uid, userInfo.userName)
      end
    else
      local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self._chatData.senderUid, self._chatData:getSenderName())
    end
  end
end

return ChatZombieAttackCityAssistanceDefend
