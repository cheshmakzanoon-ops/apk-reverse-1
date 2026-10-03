local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_FormationShare = BaseClass("FormationShare", IChatItemPost)
local base = IChatItemPost
local Localization = CS.GameEntry.Localization
local ChatHeroItem = require("UI.UIChatNew.Component.ChatItem.ChatHeroItem")
local rapidjson = require("rapidjson")
local ChatViewController = require("UI.UIChatNew.Controller.ChatViewUtils")
local _cp_ShareTitle = "Image/ShareTitle"
local _cp_heroShareList = "GameObject"
local hero_item_1 = "GameObject/heroItem1"
local hero_item_2 = "GameObject/heroItem2"
local hero_item_3 = "GameObject/heroItem3"
local hero_item_4 = "GameObject/heroItem4"
local hero_item_5 = "GameObject/heroItem5"
local _cp_shareNode = ""
local up_btn_path = "clickObj/good"
local down_btn_path = "clickObj/bad"
local up_img_path = "clickObj/good/goodIcon"
local up_num_path = "clickObj/good/goodNum"
local down_img_path = "clickObj/bad/badIcon"
local down_num_path = "clickObj/bad/badNum"
local UnityOutLine = typeof(CS.UnityEngine.UI.Outline)

function ChatItemPost_FormationShare:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemPost_FormationShare:ComponentDefine()
  self._shareTitle = self:AddComponent(UIText, _cp_ShareTitle)
  self._shareTitleOutline = self._shareTitle.gameObject:GetComponent(UnityOutLine)
  self._shareNode = self:AddComponent(UIButton, _cp_shareNode)
  self._shareNode:SetOnClick(BindCallback(self, self.OnClickBg))
  self.upNode = self:AddComponent(UIButton, up_btn_path)
  self.upNode:SetOnClick(BindCallback(self, self.OnUp))
  self.up_anim = self:AddComponent(UIAnimator, up_img_path)
  self.down_anim = self:AddComponent(UIAnimator, down_img_path)
  self.downNode = self:AddComponent(UIButton, down_btn_path)
  self.downNode:SetOnClick(BindCallback(self, self.OnDown))
  self.up_num = self:AddComponent(UIText, up_num_path)
  self.down_num = self:AddComponent(UIText, down_num_path)
  self.heroList = {}
  local heroItem1 = self:AddComponent(ChatHeroItem, hero_item_1)
  self.heroList[1] = heroItem1
  local heroItem2 = self:AddComponent(ChatHeroItem, hero_item_2)
  self.heroList[2] = heroItem2
  local heroItem3 = self:AddComponent(ChatHeroItem, hero_item_3)
  self.heroList[3] = heroItem3
  local heroItem4 = self:AddComponent(ChatHeroItem, hero_item_4)
  self.heroList[4] = heroItem4
  local heroItem5 = self:AddComponent(ChatHeroItem, hero_item_5)
  self.heroList[5] = heroItem5
  self.canClick = false
end

function ChatItemPost_FormationShare:OnClickBg()
  if self.formationData ~= nil then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationShare, {anim = true}, self.formationData)
  end
end

function ChatItemPost_FormationShare:OnLoaded()
  local chatdata = self:ChatData()
  if chatdata == nil then
    return
  end
  self.seqId = chatdata:getSeqId()
  self.upNum = chatdata:getLikeNum()
  self.downNum = chatdata:getDisLikeNum()
  if self.upNum ~= nil and self.upNum > 0 then
    self.up_num:SetText(string.GetFormattedSeperatorNum(self.upNum))
  else
    self.up_num:SetText("0")
  end
  if self.downNum ~= nil and self.downNum > 0 then
    self.down_num:SetText(string.GetFormattedSeperatorNum(self.downNum))
  else
    self.down_num:SetText("0")
  end
  self.canClick = false
  local attachmentId = chatdata.attachmentId or ""
  local data = rapidjson.decode(attachmentId) or nil
  if data == nil then
    return
  end
  self.formationData = data.para
  self._shareTitle:SetLocalText(110184)
  local senderUid = chatdata.senderUid
  self.msgTimeStamp = chatdata.serverTime
  self:RefreshButton()
  local _userInfo = ChatManager2:GetInstance().User:getChatUserInfo(senderUid, true)
  if self._chatNameLayout then
    self._chatNameLayout:UpdateName(_userInfo, chatdata)
  end
  if self.formationData ~= nil then
    local heroList = self.formationData.heroList
    for k, v in pairs(self.heroList) do
      local key = tostring(k)
      if heroList ~= nil and heroList[key] ~= nil then
        v:ReInit(heroList[key])
      else
        v:ReInit()
      end
    end
  end
  self:UpdateTopOffset()
end

function ChatItemPost_FormationShare:GetTopOffset()
  if self._chatNameLayout then
    return self._chatNameLayout:GetTopOffset()
  else
    return 0
  end
end

function ChatItemPost_FormationShare:UpdateTopOffset()
  local initOffset = 32
  local initSizeY = 227
  local topOffset = self:GetTopOffset()
  local sizeX, _ = self.rectTransform:Get_sizeDelta()
  self.rectTransform:Set_sizeDelta(sizeX, initSizeY + topOffset)
  self:SetTransPosY(self._shareNode.rectTransform, -(initOffset + topOffset))
end

function ChatItemPost_FormationShare:OnDown()
  local deltaTime = ChatManager2:GetInstance():GetGiveLikeMsgTime(self.seqId)
  local k1 = LuaEntry.DataConfig:TryGetNum("thumbs_up", "k1")
  local realLeftTime = deltaTime + k1
  if 0 < realLeftTime then
    local delta = UITimeManager:GetInstance():MilliSecondToFmtString(realLeftTime * 1000)
    UIUtil.ShowTips(Localization:GetString("121068", delta))
    return
  end
  local _roomId = self._chatData.roomId
  local msgTable = {
    roomId = _roomId,
    msgSeq = self.seqId,
    interactDislike = 1
  }
  if string.IsNullOrEmpty(_roomId) or ChatViewController:GetInstance():IsTmpPrivateChat(_roomId) or _roomId == ChatGMRoomId then
    local tui = ChatViewController:GetInstance():GetPrivateUserInfo()
    if tui == nil then
      return
    end
    msgTable.toUid = tui.uid
  end
  ChatManager2:GetInstance():SetGiveLikeMsgTime(self.seqId)
  ChatManager2:GetInstance():SetGiveLikeAnim(self.seqId, 2)
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SEND_ROOM_MSG_UP_COMMAND, msgTable)
end

function ChatItemPost_FormationShare:OnUp()
  local deltaTime = ChatManager2:GetInstance():GetGiveLikeMsgTime(self.seqId)
  local k1 = LuaEntry.DataConfig:TryGetNum("thumbs_up", "k1")
  local realLeftTime = deltaTime + k1
  if 0 < realLeftTime then
    local delta = UITimeManager:GetInstance():MilliSecondToFmtString(realLeftTime * 1000)
    UIUtil.ShowTips(Localization:GetString("121068", delta))
    return
  end
  local _roomId = self._chatData.roomId
  local msgTable = {
    roomId = _roomId,
    msgSeq = self.seqId,
    interactLike = 1
  }
  if string.IsNullOrEmpty(_roomId) or ChatViewController:GetInstance():IsTmpPrivateChat(_roomId) or _roomId == ChatGMRoomId then
    local tui = ChatViewController:GetInstance():GetPrivateUserInfo()
    if tui == nil then
      return
    end
    msgTable.toUid = tui.uid
  end
  ChatManager2:GetInstance():SetGiveLikeMsgTime(self.seqId)
  ChatManager2:GetInstance():SetGiveLikeAnim(self.seqId, 1)
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SEND_ROOM_MSG_UP_COMMAND, msgTable)
end

function ChatItemPost_FormationShare:RefreshButton()
  local anim = ChatManager2:GetInstance():GetGiveLikeAnim(self.seqId)
  if 0 < anim then
    if anim == 1 then
      local ret, time = self.up_anim:PlayAnimationReturnTime("V_ui_dianzan_anim")
      ChatManager2:GetInstance():SetGiveLikeAnim(self.seqId, 0)
    elseif anim == 2 then
      local ret, time = self.down_anim:PlayAnimationReturnTime("V_ui_diancai_anim")
      ChatManager2:GetInstance():SetGiveLikeAnim(self.seqId, 0)
    end
  else
    self.up_anim:Play("V_ui_dianzan_finish", 0, 0)
    self.down_anim:Play("V_ui_diancai_finish", 0, 0)
  end
end

function ChatItemPost_FormationShare:OnRecycle()
end

return ChatItemPost_FormationShare
