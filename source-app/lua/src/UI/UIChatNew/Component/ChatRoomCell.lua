local ChatRoomCell = BaseClass("ChatRoomCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ChatViewController = require("UI.UIChatNew.Controller.ChatViewUtils")
local ChatHead = require("UI.UIChatNew.Component.ChatHead")
local UIAdaptReddot = require("UI.UICommon.Component.UIAdaptReddot")
local _cp_selectedImage = "SelectedImage"
local _cp_objPlayerHead = "SlidingNode/UIPlayerHead"
local _cp_imgPlayerHead = "SlidingNode/UIPlayerHead/HeadIcon"
local _cp_IconImage = "SlidingNode/Image/IconImage"
local _cp_reddot = "SlidingNode/AdaptReddot"
local _cp_nameText = "SlidingNode/NameText"
local _cp_SlidingNode = "SlidingNode"
local _cp_addBtn = "AddButton"
local _cp_txtAddBtn = "AddButton/txtAddButton"
local _cp_bgBtn = "SlidingNode/Button"
local normal_bg_path = "normalBg"
local private_head_path = "PrivateChat"
local private_text_path = "PrivateChat/PrivateChatTitle"
local private_arrow_down_path = "PrivateChat/arrowDown"
local private_arrow_right_path = "PrivateChat/arrowRight"

function ChatRoomCell:ComponentDefine()
  self._selectedImage = self:AddComponent(UIImage, _cp_selectedImage)
  self._objPlayerHead = self:AddComponent(ChatHead, _cp_objPlayerHead)
  self._txtAddBtn = self:AddComponent(UIText, _cp_txtAddBtn)
  self._iconImage = self:AddComponent(UIImage, _cp_IconImage)
  self._reddot = self:AddComponent(UIAdaptReddot, _cp_reddot)
  self._nameText = self:AddComponent(UIText, _cp_nameText)
  self.normal_bg = self:AddComponent(UIImage, normal_bg_path)
  self.private_head_root = self:AddComponent(UIButton, private_head_path)
  self.private_text = self:AddComponent(UIText, private_text_path)
  self.private_arrow_down = self:AddComponent(UIImage, private_arrow_down_path)
  self.private_arrow_right = self:AddComponent(UIImage, private_arrow_right_path)
  self.private_head_root:SetOnClick(function()
    self:OnShowPrivateClick()
  end)
  self._slidingNode = self:AddComponent(UIBaseContainer, _cp_SlidingNode)
  self._addBtn = self:AddComponent(UIButton, _cp_addBtn)
  self._bgBtn = self:AddComponent(UIButton_LongPress, _cp_bgBtn)
  self._bgBtn:SetClickAction(function()
    self:Selected()
  end)
  self._bgBtn:SetLongPressAction(function()
    if not self:IsPrivateChat() then
      return
    end
    local param = {}
    param.targetPos = self._bgBtn.transform
    param.cellItem = self
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatRoomCellOperatorView, {anim = false}, param)
  end)
  self._addBtn:SetOnClick(BindCallback(self, self.CreateNewRoom))
  self._chatViewController = ChatViewController:GetInstance()
  self._objPlayerHead._headBtn:SetOnClick(function()
    if self._userInfo then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, self._userInfo.uid)
    end
  end)
end

function ChatRoomCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self._txtAddBtn:SetLocalText(290043)
end

function ChatRoomCell:OnEnable()
  base.OnEnable(self)
end

function ChatRoomCell:OnDisable()
  base.OnDisable(self)
end

function ChatRoomCell:OnAddListener()
  base.OnAddListener(self)
  local ChatEventEnum = _ENV.ChatEventEnum
  self:AddUIListener(EventId.UPDATE_MSG_USERINFO, self.UpdateUserInfoWithNew)
  self:AddUIListener(ChatEventEnum.CHAT_RECIEVE_ROOM_MSG, self.UpdateNewMsgHint)
  self:AddUIListener(EventId.GetRedPacketUpdate, self.UpdateNewMsgHint)
  self:AddUIListener(EventId.OnGetNewAllianceAutoInvite, self.UpdateNewMsgHint)
  self:AddUIListener(EventId.UpdateChatQuestRed, self.UpdateChatQuestRed)
  self:AddUIListener(ChatEventEnum.CHAT_CHECK_UI_MAIN_RED_POINT, self.UpdatePrivateReddot)
  self:AddUIListener(ChatEventEnum.CHAT_ROOM_SEL, self.RefreshChatSignal)
end

function ChatRoomCell:OnRemoveListener()
  local ChatEventEnum = _ENV.ChatEventEnum
  self:RemoveUIListener(EventId.UPDATE_MSG_USERINFO, self.UpdateUserInfoWithNew)
  self:RemoveUIListener(ChatEventEnum.CHAT_RECIEVE_ROOM_MSG, self.UpdateNewMsgHint)
  self:RemoveUIListener(EventId.GetRedPacketUpdate, self.UpdateNewMsgHint)
  self:RemoveUIListener(EventId.OnGetNewAllianceAutoInvite, self.UpdateNewMsgHint)
  self:RemoveUIListener(EventId.UpdateChatQuestRed, self.UpdateChatQuestRed)
  self:RemoveUIListener(ChatEventEnum.CHAT_CHECK_UI_MAIN_RED_POINT, self.UpdatePrivateReddot)
  self:RemoveUIListener(ChatEventEnum.CHAT_ROOM_SEL, self.RefreshChatSignal)
  base.OnRemoveListener(self)
end

function ChatRoomCell:RefreshChatSignal(curRoomId)
  if self.roomId ~= nil then
    self:SetSelect(self.roomId == curRoomId)
  end
end

function ChatRoomCell:UpdateUserInfoWithNew(userInfo)
  if userInfo == nil then
    return
  end
  if string.contains(self._roomData.roomId, userInfo.uid) then
    self:UpdateRoomName()
    self:UpdateLastChat()
  end
end

function ChatRoomCell:UpdateRoomName()
  if self._roomData:isPrivateChat() then
    self._nameText.unity_text.fontSize = 24
  else
    self._nameText.unity_text.fontSize = 28
  end
  self._nameText:SetSizeDeltaXY(156 - self._reddot.dotW, 65.2)
  self._nameText:SetText(self._roomData:getRoomName())
end

function ChatRoomCell:IsQuestCell()
  if not table.IsNullOrEmpty(self._roomData) and self._roomData.group == ChatGroupType.GROUP_QUEST then
    return true
  end
  return false
end

function ChatRoomCell:OnShowPrivateClick()
  self.show_private_chat = not self.show_private_chat
  CS.GameEntry.Setting:SetBool("show_private_chat_" .. LuaEntry.Player.uid, self.show_private_chat)
  self:UpdatePrivateReddot()
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_REFRESH_CHANNEL)
end

function ChatRoomCell:setData(roomData, index, roomId)
  local isChatCount = type(roomData) == "number"
  self._roomData = roomData
  if self._roomData ~= nil and not isChatCount then
    self.roomId = roomData.roomId
    self._slidingNode:SetActive(true)
    self._addBtn:SetActive(false)
    self.normal_bg:SetActive(true)
    self.private_head_root:SetActive(false)
    self:InitState()
    self:InitRoomIconAndName()
    self:SetSizeDelta(Vector2.New(260, 100))
  elseif isChatCount then
    local show_private_chat = CS.GameEntry.Setting:GetBool("show_private_chat_" .. LuaEntry.Player.uid, true)
    self._slidingNode:SetActive(false)
    self._selectedImage:SetActive(false)
    self._addBtn:SetActive(false)
    self._objPlayerHead:SetActive(false)
    self.normal_bg:SetActive(false)
    self.private_head_root:SetActive(true)
    self:SetSizeDelta(Vector2.New(260, 60))
    self.private_arrow_down:SetActive(show_private_chat)
    self.private_arrow_right:SetActive(not show_private_chat)
    self.private_text:SetText(Localization:GetString("290038") .. " (" .. roomData .. ")")
    self._roomData = nil
    self.isPrivateChatGroup = true
    self.show_private_chat = show_private_chat
    self:UpdatePrivateReddot()
  else
    self.roomId = roomId
    self.normal_bg:SetActive(true)
    self._objPlayerHead:SetActive(false)
    self:SetSelect(false)
    self._addBtn:SetActive(true)
    self.private_head_root:SetActive(false)
    self:SetSizeDelta(Vector2.New(260, 100))
  end
end

function ChatRoomCell:InitState()
  if self._roomData == nil then
    return
  end
  local currentRoomId = self._chatViewController:GetCurrentRoomId()
  local roomId = self._roomData.roomId
  if currentRoomId == roomId then
    self:SetSelect(true)
    EventManager:GetInstance():Broadcast(ChatEventEnum.LF_UPDATE_UIMAIN_CHAT_MSG)
  else
    self:SetSelect(false)
  end
  self:UpdateLastChat()
end

function ChatRoomCell:SetSelect(isSelect)
  self._selectedImage:SetActive(isSelect)
end

function ChatRoomCell:InitRoomIconAndName()
  if self._roomData == nil then
    return
  end
  self:UpdateRoomName()
  self:CheckHeadState()
end

function ChatRoomCell:IsPrivateChat()
  if self._roomData.group == "country" then
    return false
  elseif self._roomData.group == "alliance" then
    return false
  elseif self._roomData.group == ChatGroupType.GROUP_CROSS_SERVER then
    return false
  elseif self._roomData.group == QuestRoomGroup then
    return false
  elseif self._roomData.group == RadarRoomGroup then
    return false
  elseif self._roomData:IsGmRoom() then
    return false
  else
    return true
  end
end

function ChatRoomCell:CheckHeadState()
  if self._roomData.group == "country" then
    self._objPlayerHead:SetActive(false)
    self._iconImage:SetActive(true)
    self:SetIcon("Assets/Main/Sprites/UI/UIChatNew3/zyf_liaotian_shijie.png")
  elseif self._roomData.group == "alliance" then
    self._objPlayerHead:SetActive(false)
    self._iconImage:SetActive(true)
    self:SetIcon("Assets/Main/Sprites/UI/UIChatNew3/zyf_liaotian_lianmeng.png")
  elseif self._roomData.group == QuestRoomGroup then
    self._objPlayerHead:SetActive(false)
    self._iconImage:SetActive(true)
    self:SetIcon("Assets/Main/Sprites/UI/UIChatNew3/zyf_liaotian_xitong.png")
  elseif self._roomData.group == RadarRoomGroup then
    self._objPlayerHead:SetActive(false)
    self._iconImage:SetActive(true)
    self:SetIcon("Assets/Main/Sprites/UI/UIChatNew3/zyf_liaotian_xitong.png")
  elseif self._roomData.group == ChatGroupType.GROUP_AL_AUTO_INVITE then
    self._objPlayerHead:SetActive(false)
    self._iconImage:SetActive(true)
    self:SetIcon("Assets/Main/Sprites/UI/UIChatNew3/zyf_liaotian_lianmeng.png")
  elseif self._roomData.group == ChatGroupType.GROUP_LANGUAGE then
    self._objPlayerHead:SetActive(false)
    self._iconImage:SetActive(true)
    self:SetIcon("Assets/Main/Sprites/UI/UIChatNew3/zyf_liaotian_guojia.png")
  elseif self._roomData.group == ChatGroupType.GROUP_CROSS_SERVER then
    self._objPlayerHead:SetActive(false)
    self._iconImage:SetActive(true)
    self:SetIcon("Assets/Main/Sprites/UI/UIChatNew3/zyf_liaotian_zhanqu.png")
  elseif self._roomData.group == ChatGroupType.GROUP_DRAGON_SELF_SERVER then
    self._objPlayerHead:SetActive(false)
    self._iconImage:SetActive(true)
    self:SetIcon("Assets/Main/Sprites/UI/UIChatNew3/zyf_liaotian_team.png")
  elseif self._roomData.group == ChatGroupType.GROUP_DRAGON_ALL_SERVER then
    self._objPlayerHead:SetActive(false)
    self._iconImage:SetActive(true)
    self:SetIcon("Assets/Main/Sprites/UI/UIChatNew3/zyf_liaotian_zhanchang.png")
  elseif self._roomData.group == ChatGroupType.GROUP_CUSTOM then
    local roomId = self._roomData.roomId
    local character_id = string.match(roomId, "custom_ai_(%d+)_")
    if character_id ~= nil and character_id ~= "" then
      local theCharacterData = DataCenter.LWChatAIManager:GetChatAICharacterData(character_id)
      self._objPlayerHead:SetActive(true)
      self._iconImage:SetActive(false)
      if self._objPlayerHead ~= nil then
        self._objPlayerHead:UpdateForAI({
          post = PostType.ChatGPT_Assistant_Private,
          theCharacterData = theCharacterData
        }, theCharacterData)
      end
    else
      self._objPlayerHead:SetActive(true)
      self:ShowUserHead()
      self._iconImage:SetActive(false)
    end
  elseif self._roomData:IsGmRoom() then
    self._objPlayerHead:SetActive(true)
    self:ShowGmIcon()
    self._iconImage:SetActive(false)
  else
    self._objPlayerHead:SetActive(true)
    self:ShowUserHead()
    self._iconImage:SetActive(false)
  end
end

function ChatRoomCell:SetIcon(path)
  self._iconImage:LoadSprite(path)
end

function ChatRoomCell:ShowGmIcon()
  local userInfo = ChatInterface.getUserMgr():CreateUserInfo()
  userInfo.uid = ChatGMUserId
  if self._objPlayerHead ~= nil then
    self._objPlayerHead:UpdateHead(userInfo)
  end
end

function ChatRoomCell:ShowUserHead()
  local senderUid = ""
  local memberList = self._roomData.memberList or {}
  for _, memUid in pairs(memberList) do
    if memUid ~= LuaEntry.Player.uid then
      senderUid = memUid
      break
    end
  end
  if string.IsNullOrEmpty(senderUid) then
    return
  end
  self._userInfo = ChatInterface.getUserData(senderUid)
  if self._objPlayerHead ~= nil then
    local chatData = {}
    self._objPlayerHead:UpdateHead(self._userInfo, chatData)
  end
end

function ChatRoomCell:UpdatePrivateRoomIcon()
end

function ChatRoomCell:UpdateChatQuestRed(num)
  self:UpdateNewMsgHint(num)
end

function ChatRoomCell:UpdateLastChat(tmpRoomId)
  tmpRoomId = tmpRoomId or ""
  if self._roomData == nil then
    return
  end
  local roomId = self._roomData.roomId
  if tmpRoomId ~= "" and tmpRoomId ~= roomId then
    return
  end
  self:UpdateNewMsgHint()
end

function ChatRoomCell:UpdatePrivateReddot()
end

function ChatRoomCell:UpdateNewMsgHint(num)
  self:UpdatePrivateReddot()
  if self._roomData == nil then
    return
  end
  local roomId = self._roomData.roomId
  local roomMgr = ChatInterface.getRoomMgr()
  local roomData = roomMgr:GetRoomData(roomId)
  local count = 0
  if roomData then
    count = roomData:getNewMsgNum()
  end
  local currentRoomId = self._chatViewController:GetCurrentRoomId()
  local otherNum = 0
  if self._roomData.group == "alliance" then
    otherNum = DataCenter.AllianceRedPacketManager:GetValidRedPacketNum()
    count = count + otherNum
  elseif self._roomData.group == "quest" then
    local chapterList = DataCenter.ChapterTaskManager:GetAllChapterTask()
    if not next(chapterList) then
      local list = DataCenter.TaskManager:GetAllMainTask()
      for i = 1, #list do
        if list[i].state == TaskState.CanReceive then
          otherNum = otherNum + 1
        end
      end
      if num and currentRoomId == roomId then
        otherNum = otherNum - num
      end
      count = count + otherNum
    end
  elseif self._roomData.group == ChatGroupType.GROUP_AL_AUTO_INVITE then
    local unreadCount = DataCenter.AllianceAutoInviteManager:GetUnreadCount()
    count = unreadCount
  end
  if 0 < count then
    if currentRoomId == roomId then
      self._reddot:SetNumber(otherNum)
    else
      self._reddot:SetNumber(count)
    end
  else
    if 0 < self._reddot.num and self._roomData.group == "custom" then
      self.view:NeedAskForPushPermission("ASK_FOR_PUSH_by_PRIVATE_CHAT")
    end
    self._reddot:SetNumber(count)
  end
  self:UpdateRoomName()
end

function ChatRoomCell:Selected()
  if self._roomData == nil then
    return
  end
  if self._roomData.roomId == self._chatViewController:GetCurrentRoomId() then
    return
  end
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_SelectTab, false)
  local roomId = self._roomData.roomId
  EventManager:GetInstance():Broadcast(ChatEventEnum.LF_ChatCellSelect, roomId)
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_CHECK_UI_MAIN_RED_POINT)
end

function ChatRoomCell:RestoreStateAndSidingNode()
  self:InitState()
end

function ChatRoomCell:CreateNewRoom()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatSearchPerson)
end

function ChatRoomCell:DelClick()
  local roomId = self._roomData.roomId
  local room = ChatInterface.getRoomData(roomId)
  local Event = EventManager:GetInstance()
  if room == nil or self._roomData.group == ChatGroupType.GROUP_TMPRoom then
    self.view:DelRoom(roomId)
    Event:Broadcast(ChatEventEnum.CHAT_REFRESH_CHANNEL, roomId)
  end
  if room ~= nil and room:isCustomRoom() then
    if self._roomData:isMyCreateRoom() then
      Event:Broadcast(ChatEventEnum.CHAT_ROOM_DISMISS, roomId)
    else
      Event:Broadcast(ChatEventEnum.QUIT_ROOM_COMMAND, roomId)
    end
  end
end

function ChatRoomCell:GetRoomId()
  return self._roomData.roomId or ""
end

function ChatRoomCell:UpdateItem(_chatdata)
  local a = 1
end

function ChatRoomCell:IsReceiver(vec2Pos)
  if self:IsQuestCell() then
    return false
  end
  local localPoint = CS.PointUtils.ScreenPointToLocalPointInRectangle(self.rectTransform, vec2Pos, nil)
  local width = self.rectTransform.rect.width
  local height = self.rectTransform.rect.height
  local pivot = self.rectTransform.pivot
  local innerX = localPoint.x + width * pivot.x
  local innerY = localPoint.y + height * pivot.y
  if 0 < innerX and width > innerX and 0 < innerY and height > innerY then
    return true
  end
  return false
end

function ChatRoomCell:OnBeginDrag(eventData)
end

function ChatRoomCell:OnDrag(eventData)
end

function ChatRoomCell:OnEndDrag(eventData)
end

function ChatRoomCell:ResetLeftAlign()
end

function ChatRoomCell:Update1000MS()
  if self.isPrivateChatGroup and not self.show_private_chat then
    self:UpdatePrivateReddot()
  end
end

return ChatRoomCell
