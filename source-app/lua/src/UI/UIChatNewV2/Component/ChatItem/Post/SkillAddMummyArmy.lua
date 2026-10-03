local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_SkillAddMummyArmy = BaseClass("SkillAddMummyArmy", IChatItemPost)
local base = IChatItemPost
local rapidjson = require("rapidjson")
local Localization = CS.GameEntry.Localization
local btn_path = "ZanBtn"
local liked_img_path = "LikedImg"
local desc_text_path = "DesText"
local active_anim_path = "LikedImg/ActiveAnim"
local likeSticker_path = "LikeStickerDynamic"

function ChatItemPost_SkillAddMummyArmy:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemPost_SkillAddMummyArmy:ComponentDefine()
  self.bg = self:AddComponent(UIImage, "")
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
end

function ChatItemPost_SkillAddMummyArmy:OnLoaded()
  local chatData = self:ChatData()
  self.seqId = chatData:getSeqId()
  self.roomId = chatData.roomId
  self:Refresh(chatData)
end

function ChatItemPost_SkillAddMummyArmy:Refresh(chatData)
  self._chatData = chatData
  local isMyChat = self._chatData:isMyChat()
  self.btn:SetActive(false)
  if chatData and chatData.clientUpdateExtra and chatData.clientUpdateExtra == "liked" then
    self.likedImg:SetActive(true)
  else
    self.likedImg:SetActive(false)
    if not isMyChat then
      self.btn:SetActive(true)
    end
  end
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
    if jsonObj then
      self.desc:SetText(Localization:GetString(jsonObj.dialogId, chatData.extra.addNum or 0))
    end
  end
  if isMyChat then
    self.bg:LoadSprite(string.format(LoadPath.LWChatFolder, "zyf_liaotian_kuang2"))
    self.desc:SetAnchoredPositionXY(130, -25)
    self.likedImg:SetAnchoredPositionXY(10, -15)
    self.likeSticker:SetAnchoredPositionXY(33, -51)
    self.likeSticker:SetLocalScaleXYZ(1, 1, 1)
  else
    self.bg:LoadSprite(string.format(LoadPath.LWChatFolder, "zyf_liaotian_kuang1"))
    self.desc:SetAnchoredPositionXY(21, -25)
    self.likedImg:SetAnchoredPositionXY(463, -15)
    self.likeSticker:SetAnchoredPositionXY(472, -51)
    self.likeSticker:SetLocalScaleXYZ(-1, 1, 1)
  end
end

function ChatItemPost_SkillAddMummyArmy:OnRecycle()
end

function ChatItemPost_SkillAddMummyArmy:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateMsg)
end

function ChatItemPost_SkillAddMummyArmy:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateMsg)
  base.OnRemoveListener(self)
end

function ChatItemPost_SkillAddMummyArmy:OnUpdateMsg(chatData)
  if chatData and chatData.seqId == self.seqId and chatData.roomId == self.roomId then
    self:Refresh(chatData)
  end
end

function ChatItemPost_SkillAddMummyArmy:Interactive()
  if self._chatData then
    local seqId = self.seqId
    local senderUid = self._chatData.senderUid
    local roomId = self._chatData.roomId
    local name = self._chatData:getSenderName()
    local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self._chatData.senderUid, name)
    DataCenter.BuildHelpStopFireManager:HelpStopFireChatInteractive(seqId, senderUid, roomId, senderUid, InteractiveUtil.ThumbsUpType.SkillAddMummyArmy, showName, function()
      self.likedImg:SetActive(true)
      self.heart_effect:SetActive(true)
      TimerManager:GetInstance():DelayInvoke(function()
        if self and self.heart_effect then
          self.heart_effect:SetActive(false)
        end
      end)
    end, "season_s3_callback_tips_10")
  end
end

function ChatItemPost_SkillAddMummyArmy:OnClickLikeImg()
  if self._chatData then
    local isMyChat = self._chatData:isMyChat()
    if isMyChat then
      local roomData = ChatInterface.getRoomData(self._chatData.roomId)
      local targetMemberId = roomData:GetPrivateUser()
      local userInfo = ChatManager2:GetInstance().User:getChatUserInfo(targetMemberId, true)
      if userInfo then
        local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(userInfo.uid, userInfo.userName)
        UIUtil.ShowTips(Localization:GetString("season_s3_callback_tips_12", showName))
      end
    else
      local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self._chatData.senderUid, self._chatData:getSenderName())
      UIUtil.ShowTips(Localization:GetString("season_s3_callback_tips_11", showName))
    end
  end
end

return ChatItemPost_SkillAddMummyArmy
