local base = UIBaseContainer
local UIChatViewPrivateListItem_v2 = BaseClass("UIChatViewPrivateListItem_v2", base)
local UIPrivateLayoutBtnItem = require("UI.UIChatNewV2.Component.UIPrivateLayoutBtnItem")
local Localization = CS.GameEntry.Localization
local UIChatHead = require("UI.UIChatNew.Component.ChatHead")
local UIAdaptReddot = require("UI.UICommon.Component.UIAdaptReddot")
local GroupHead = require("UI/UIChatNewV2/Component/GroupHead")
local oneWidth = 125
local off = 10
local topImagePath = "Assets/Main/Sprites/UI/LWChat_v2/DefaultSkin/ChatWindow/zyf_siliaozhiding_tiao.png"
local ValentineMatchReadPath = "Assets/Main/Sprites/UI/UIActValentineSendGiftChatBg/lrb_2026QRJ_liaotian_yidu.png"
local ValentineMatchUnReadPath = "Assets/Main/Sprites/UI/UIActValentineSendGiftChatBg/lrb_2026QRJ_liaotian_weidu.png"
local path = {
  def = "Assets/Main/Sprites/UI/LWChat_v2/DefaultSkin/ChatWindow/sj_liaotian_reddot.png",
  dot = "Assets/Main/Sprites/UI/LWChat_v2/DefaultSkin/ChatItems/zyf_liaotian_miandarao_dian.png"
}
local deleteData = {
  imgName = "ChatNotice/sj_liaotian_shanchu",
  text = "100190",
  type = PrivateSlidingType.Delete
}
local blockData = {
  imgName = "ChatNotice/sj_liaotian_lahei",
  text = "290007",
  type = PrivateSlidingType.Block
}
local boardData = {
  imgName = "ChatNotice/zyf_liaotian_pin_icon",
  text = "convo_unpin_set",
  type = PrivateSlidingType.Pinned
}
local privateConfig = {
  boardData,
  deleteData,
  blockData
}
local groupChatConfig = {deleteData}
local compBook = {
  {
    path = "board",
    name = "board",
    type = UIButton,
    onClick = function(self)
      self:OnClickBoard()
    end
  },
  {
    path = "board/imgOff",
    name = "imgOff",
    type = UIImage
  },
  {
    path = "board/imgOn",
    name = "imgOn",
    type = UIImage
  },
  {
    path = "board/imgTop",
    name = "imgTop",
    type = UIImage
  },
  {
    path = "board/ChatHead",
    name = "head",
    type = UIChatHead
  },
  {
    path = "board/txtName",
    name = "txtName",
    type = UIText
  },
  {
    path = "board/txtTime",
    name = "txtTime",
    type = UIText
  },
  {
    path = "board/layout/reddot",
    name = "reddot",
    type = UIAdaptReddot
  },
  {
    path = "btnBatchSelect",
    name = "btnBatchSelect",
    type = UIButton,
    onClick = function(self)
      self:OnClickBatchSelect()
    end
  },
  {
    path = "btnBatchSelect/btnBatchSelectImg",
    name = "btnBatchSelectImg",
    type = UIImage
  },
  {
    path = "board/groupHeadCom",
    name = "groupHead",
    type = GroupHead
  },
  {
    path = "btnsLayout",
    name = "btnsLayout",
    type = UIBaseContainer
  },
  {
    path = "board/notClickMask",
    name = "notClickMask",
    type = UIImage
  },
  {
    path = "btnBatchSelect/notClick",
    name = "notClickImg",
    type = UIImage
  },
  {
    path = "board/layout/reddot/imgDot",
    name = "redIcon",
    type = UIImage
  },
  {
    path = "board/Image",
    name = "disturbIcon",
    type = UIImage
  },
  {
    path = "board/imgSkin",
    name = "imgSkin",
    type = UIImage
  },
  {
    path = "board/layout/gift",
    name = "gift",
    type = UIBaseComponent
  },
  {
    path = "board/layout/gift/giftIcon",
    name = "giftIcon",
    type = UIImage
  },
  {
    path = "board/layout/gift/giftBg",
    name = "giftBg",
    type = UIImage
  },
  {
    path = "board/MigrationSign",
    name = "migrationSign",
    type = UIBaseComponent,
    active = false
  }
}

function UIChatViewPrivateListItem_v2:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  local dlgComponent = ChatInterface.isTestingServer() and UITextMeshProUGUIEx or UIText
  self.txtMsg = self:AddComponent(dlgComponent, "board/txtMsg")
  self.theItem = self.transform:Find("btnItem").gameObject
  self.theItem:GameObjectCreatePool()
  if ChatInterface.isTestingServer() then
    ChatInterface.SetEmojiTextProperty(self.txtMsg)
  end
  
  function self.__onUpdate()
    self:OnUpdate()
  end
  
  UpdateManager:GetInstance():AddUpdate(self.__onUpdate)
  self.imgSkin:SetActive(false)
end

function UIChatViewPrivateListItem_v2:OnDestroy()
  self.userInfo = nil
  UpdateManager:GetInstance():RemoveUpdate(self.__onUpdate)
  self.btnsLayout:RemoveComponents(UIPrivateLayoutBtnItem)
  self.theItem:GameObjectRecycleAll()
  self.__onUpdate = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
  self.shell = nil
  self.room = nil
end

function UIChatViewPrivateListItem_v2:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function UIChatViewPrivateListItem_v2:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UIChatViewPrivateListItem_v2:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SCREEN_TOUCH_MOVE, self.OnScreenTouchMove)
  self:AddUIListener(EventId.UPDATE_MSG_USERINFO, self.OnUserInfoUpdate)
  self:AddUIListener(EventId.CHAT_ROOM_NOTDISTURD_UPDATE, self.OnRoomNotDisturdUpdate)
  self:AddUIListener(EventId.ActMigrationMarkPlayerUpdate, self.RefreshMigrationSign)
end

function UIChatViewPrivateListItem_v2:OnRemoveListener()
  self:RemoveUIListener(EventId.SCREEN_TOUCH_MOVE, self.OnScreenTouchMove)
  self:RemoveUIListener(EventId.UPDATE_MSG_USERINFO, self.OnUserInfoUpdate)
  self:RemoveUIListener(EventId.CHAT_ROOM_NOTDISTURD_UPDATE, self.OnRoomNotDisturdUpdate)
  self:RemoveUIListener(EventId.ActMigrationMarkPlayerUpdate, self.RefreshMigrationSign)
  base.OnRemoveListener(self)
end

function UIChatViewPrivateListItem_v2:OnRoomNotDisturdUpdate(room)
  if not room or not self.room then
    return
  end
  if self.room.roomId == room.roomId then
    self:UpdateNotDisturbingIcon()
  end
end

local __emptyMsg = {}

function UIChatViewPrivateListItem_v2:UpdateItem(shell)
  if not shell or not shell.room then
    return
  end
  self.btnsLayout:RemoveComponents(UIPrivateLayoutBtnItem)
  self.theItem:GameObjectRecycleAll()
  self:SetSizeDeltaXY(self.view.middle:GetSizeDelta().x or DefaultScreenWidth, self:GetSizeDelta().y)
  self.shell = shell
  self.room = shell.room
  local roomName = self:TryGetRoomName()
  self.txtName:SetText(roomName)
  local latestMsg = self.room.msgs[#self.room.msgs]
  self:UpdateBtnLayout(shell)
  local txtMsgStr = ""
  if not latestMsg then
    if self.room:IsKickedRoom() then
      local hintMsg = ChatInterface.getString("290013", ChatInterface.getString("290018"))
      txtMsgStr = hintMsg
    end
  elseif latestMsg.post == PostType.Text_Normal then
    local isEmojiFormatMsg = self.view.ctrl:CheckIsEmojiFormatMsg(latestMsg.msg)
    if isEmojiFormatMsg and not latestMsg.extra.isNormalMsg then
      txtMsgStr = "[emoji]"
    else
      txtMsgStr = latestMsg.msg
    end
  else
    local str = Localization:GetString("2900046")
    local success, result = pcall(function()
      return latestMsg:getMessageWithExtra(false)
    end)
    if success then
      str = result
    end
    txtMsgStr = str
  end
  local isHaveAt = false
  if self.room:GetAtSeqId() then
    isHaveAt = true
  end
  self.txtMsg.unity_tmpro:SetInputHtmlTagEmpty()
  if isHaveAt then
    local atStr = Localization:GetString("at_convo_list_display")
    local atStrLen = string.word_count(atStr)
    self.txtMsg.unity_tmpro:AddInputHtmlTag("color=#099b4a", "/color", 0, 0 + atStrLen - 1)
    self.txtMsg:SetText(atStr .. txtMsgStr)
  else
    self.txtMsg:SetText(txtMsgStr)
  end
  if self.room.lastMsgTime and 0 < self.room.lastMsgTime then
    self.txtTime:SetText(UITimeManager:GetInstance():ConvertServerTimeToLocalTime(self.room.lastMsgTime))
  else
    self.txtTime:SetText("")
  end
  local userInfo
  if self.room.group == ChatGroupType.GROUP_CUSTOM_GROUP then
    self.head:SetActive(false)
    self.groupHead:SetActive(true)
    self.groupHead:UpdateGroupHeadList(self.room.memberList, true)
  else
    self.head:SetActive(true)
    self.groupHead:SetActive(false)
    userInfo = self.room:getPrivateOtherMember()
    self.head:UpdateHead(userInfo, __emptyMsg)
  end
  self.userInfo = userInfo
  local count = self.room:getNewMsgNum()
  local unreadCount = math.floor(count)
  self:UpdateRedDot()
  local stickyRoomList = ChatInterface.getRoomMgr():GetAllRoomTop()
  local viewShowType = DataCenter.ChatPrivateDataManager:GetShowType()
  local imgTopIsSameAsNormal = true
  local boardOffsetIsSameAsNormal = true
  local btnBatchSelectIsSameAsNormal = true
  self.notClickMask:SetActive(false)
  self.notClickImg:SetActive(false)
  if viewShowType == ChatPrivateListShowType.Search then
    imgTopIsSameAsNormal = false
    self.imgTop:SetActive(false)
  elseif viewShowType == ChatPrivateListShowType.BatchDel then
    imgTopIsSameAsNormal = false
    self.imgTop:SetActive(false)
    boardOffsetIsSameAsNormal = false
    local isMirror = CommonUtil.IsArabicAutoMirrorOpen()
    if not isMirror then
      self.board:SetOffsetMinXY(70, 0)
      self.board:SetOffsetMaxXY(-15, 0)
    else
      self.board:SetOffsetMinXY(15, 0)
      self.board:SetOffsetMaxXY(-70, 0)
    end
    self.notClickMask:SetActive(self.room.group == ChatGroupType.GROUP_CUSTOM_GROUP)
    self.notClickImg:SetActive(self.room.group == ChatGroupType.GROUP_CUSTOM_GROUP)
    btnBatchSelectIsSameAsNormal = false
    self.btnBatchSelect:SetActive(true)
    self:RefreshBatchSelectView()
  end
  if imgTopIsSameAsNormal then
    if self.room.group == ChatGroupType.GROUP_CUSTOM_GROUP then
      self.imgTop:SetActive(stickyRoomList[self.room.roomId] ~= nil)
    else
      self.imgTop:SetActive(stickyRoomList[tostring(userInfo.uid)] ~= nil)
    end
  end
  local isValentineMatch = userInfo ~= nil and DataCenter.ValentineDataManager:GetIfMatchSuccess(userInfo.uid) and ChatInterface.GetChatTheme() == ChatUIThemeConfig.ChatMode.Normal
  if isValentineMatch then
    if 0 < unreadCount then
      self.imgSkin:LoadSpriteAsync(ValentineMatchUnReadPath)
    else
      self.imgSkin:LoadSpriteAsync(ValentineMatchReadPath)
    end
    self.imgSkin:SetActive(true)
  else
    self.imgSkin:SetActive(false)
  end
  if boardOffsetIsSameAsNormal then
    self:OnUpdate()
  end
  if btnBatchSelectIsSameAsNormal then
    self.btnBatchSelect:SetActive(false)
  end
  if self.shell and self.shell.parent then
    self.shell.parent:GetRoomLast(self.room.roomId)
  end
  self:UpdateNotDisturbingIcon()
  self:RefreshMigrationSign()
end

function UIChatViewPrivateListItem_v2:RefreshMigrationSign()
  if self.migrationSign ~= nil then
    local isMigrationSign = self.userInfo ~= nil and DataCenter.ActMigrationManager:IsPlayerMarked(self.userInfo.uid) or false
    self.migrationSign:SetActive(isMigrationSign)
  end
end

function UIChatViewPrivateListItem_v2:UpdateRedDot()
  local count = self.room:getNewMsgNum()
  if self.room.giftInfo then
    self.gift:SetActive(true)
    local giftIcon = DataCenter.GiftSystemManager:GetGiftIconByGroup(self.room.giftInfo.itemId, self.room.giftInfo.num)
    local qualityIcon = DataCenter.GiftSystemManager:QualityIcon(self.room.giftInfo.itemId)
    self.giftBg:LoadSpriteAsync(qualityIcon)
    self.giftIcon:LoadSpriteAsync(giftIcon)
  else
    self.gift:SetActive(false)
  end
  local unreadCount = math.floor(count)
  self.reddot:SetNumber(unreadCount)
  self.imgOn:SetActive(0 < unreadCount)
  self.imgOff:SetActive(unreadCount <= 0)
end

function UIChatViewPrivateListItem_v2:UpdateNotDisturbingIcon()
  if self.room:GetNotDisturbing() then
    self.redIcon:LoadSprite(path.dot)
    self.disturbIcon:SetActive(true)
  else
    self.redIcon:LoadSprite(path.def)
    self.disturbIcon:SetActive(false)
  end
  self:UpdateLayout()
end

function UIChatViewPrivateListItem_v2:UpdateLayout()
  local maxWidth = 500
  local spacing = 15
  local textRT = self.txtName.rectTransform
  local iconRT = self.disturbIcon.rectTransform
  local preferred = self.txtName.unity_tmpro:GetPreferredValues(maxWidth, 0)
  local textWidth = math.min(preferred.x, maxWidth)
  textRT:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, textWidth)
  local iconPos = iconRT.anchoredPosition
  iconPos.x = textRT.anchoredPosition.x + textWidth + spacing
  iconPos.y = -19
  iconRT.anchoredPosition = iconPos
end

function UIChatViewPrivateListItem_v2:OnBtnItemClick(btnType)
  if btnType == PrivateSlidingType.Delete then
    self:OnClickDelete()
  elseif btnType == PrivateSlidingType.Block then
    self:OnClickBlock()
  elseif btnType == PrivateSlidingType.Pinned then
    self:OnClickPinned()
  end
end

function UIChatViewPrivateListItem_v2:UpdateBtnLayout(shell)
  self.btnConfig = privateConfig
  if self.room.group == ChatGroupType.GROUP_CUSTOM_GROUP then
    self.btnConfig = {
      boardData,
      {
        imgName = "ChatNotice/sj_liaotian_shanchu",
        text = "group_setting_btn_leave",
        type = PrivateSlidingType.Delete
      }
    }
  end
  local goItem, theName, theItem
  for i = 1, #self.btnConfig do
    if self.btnConfig[i].type == PrivateSlidingType.Pinned then
      if shell.stickyTime and shell.stickyTime > 0 then
        self.btnConfig[i].text = "convo_unpin_set"
        self.btnConfig[i].imgName = "ChatNotice/zyf_liaotian_unpin_icon"
      else
        self.btnConfig[i].text = "convo_top_set"
        self.btnConfig[i].imgName = "ChatNotice/zyf_liaotian_pin_icon"
      end
    end
    self.btnConfig[i].fun = function()
      self:OnBtnItemClick(self.btnConfig[i].type)
    end
    theName = "item_" .. i
    goItem = self.theItem:GameObjectSpawn(self.btnsLayout.transform)
    goItem.name = theName
    goItem:SetActive(true)
    theItem = self.btnsLayout:AddComponent(UIPrivateLayoutBtnItem, theName)
    theItem:ParseInfoByNight(self.btnConfig[i])
  end
end

function UIChatViewPrivateListItem_v2:OnClickPinned()
  if self.room:IsKickedRoom() then
    UIUtil.ShowTipsId("group_chat_remove_tips")
    return
  end
  local isDelete = self.shell.stickyTime and self.shell.stickyTime > 0
  local otherUser = self.room:getPrivateOtherMember()
  local roomKey = self.room.roomId
  if self.room.group == ChatGroupType.GROUP_CUSTOM and otherUser then
    roomKey = otherUser.uid
  end
  local isPinned = ChatManager2:GetInstance().Room:RoomTop(roomKey, self.room.group, not isDelete)
  if not isPinned then
    return
  end
  self.view.middle.listPrivate:OnItemSlideToTargetPos(self.shell, false)
  EventManager:GetInstance():Broadcast(EventId.Chat_GetFriendList)
end

function UIChatViewPrivateListItem_v2:OnUpdate()
  if not self.shell then
    return
  end
  local viewShowType = DataCenter.ChatPrivateDataManager:GetShowType()
  if viewShowType == ChatPrivateListShowType.BatchDel then
    return
  end
  local weight = self.shell.__slideWeight or 0
  self.board:SetOffsetMinXY(15 - (oneWidth * #self.btnConfig + off) * weight, 0)
  self.board:SetOffsetMaxXY(-15 - (oneWidth * #self.btnConfig + off) * weight, 0)
end

function UIChatViewPrivateListItem_v2:OnClickBlock()
  if not self.room then
    return
  end
  local otherUser = self.room:getPrivateOtherMember()
  UIUtil.ShowMessage(Localization:GetString("290008", otherUser.userName), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    self.room:readMsg(self.room.lastSeqId)
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_BLOCK_COMMAND, otherUser.uid)
  end)
end

function UIChatViewPrivateListItem_v2:OnClickDelete()
  if not self.room then
    return
  end
  if self.room.group == ChatGroupType.GROUP_CUSTOM_GROUP then
    if #self.room.memberList > 1 and self.room.owner == LuaEntry.Player.uid then
      UIUtil.ShowTipsId("group_leave_tips1")
    else
      UIUtil.ShowMessage(Localization:GetString("group_leave_tips2"), 2, "110043", GameDialogDefine.CANCEL, function()
        ChatManager2:GetInstance().Room:RoomTop(self.room.roomId, self.room.group, false)
        ChatManager2:GetInstance().Net:SendSFSMessage(ChatMsgDefines.ChatRoomQuit, self.room.roomId, self.room.group)
      end)
    end
    return
  end
  UIUtil.ShowMessage(Localization:GetString("delete_room_notice"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    local stickyList = CommonUtil.PlayerPrefsGetTable("PRIVATE_CHAT_STICKY_LIST", {})
    local member = self.room:getPrivateOtherMember()
    if stickyList[tostring(member and member.uid)] then
      stickyList[tostring(member and member.uid)] = nil
      CommonUtil.PlayerPrefsSetTable("PRIVATE_CHAT_STICKY_LIST", stickyList)
      local hasMsg = self.room.msgs and self.room.lastSeqId >= 1
      if hasMsg then
        EventManager:GetInstance():Broadcast(ChatEventEnum.QUIT_ROOM_COMMAND, self.room.roomId)
      else
        EventManager:GetInstance():Broadcast(ChatEventEnum.Chat_QuitRoom, {
          category = ChatRoomCategory.PRIVATE
        })
      end
    else
      EventManager:GetInstance():Broadcast(ChatEventEnum.QUIT_ROOM_COMMAND, self.room.roomId)
    end
  end)
end

function UIChatViewPrivateListItem_v2:GetListPrivateActive()
  if self.view then
    return self.view.middle.listPrivate:GetActive()
  end
  return false
end

function UIChatViewPrivateListItem_v2:OnClickBoard()
  local viewShowType = DataCenter.ChatPrivateDataManager:GetShowType()
  if viewShowType == ChatPrivateListShowType.BatchDel then
    self:OnClickBatchSelect()
  else
    self.view:SelectRoom(self.room)
  end
end

function UIChatViewPrivateListItem_v2:OnClickBatchSelect()
  if self.room.group == ChatGroupType.GROUP_CUSTOM_GROUP then
    return
  end
  local isSelected = DataCenter.ChatPrivateDataManager:CheckRoomInBatchDel(self.room.roomId)
  if isSelected then
    DataCenter.ChatPrivateDataManager:UnSelectRoomInBatchDel(self.room.roomId)
    self:RefreshBatchSelectView()
    EventManager:GetInstance():Broadcast(EventId.ChatPrivateBatchDelSelectChange)
  else
    local isCanSelect = DataCenter.ChatPrivateDataManager:CheckCanSelectRoomInBatchDel()
    if isCanSelect then
      DataCenter.ChatPrivateDataManager:SelectRoomInBatchDel(self.room.roomId)
      self:RefreshBatchSelectView()
      EventManager:GetInstance():Broadcast(EventId.ChatPrivateBatchDelSelectChange)
    else
      UIUtil.ShowTipsId("multiple_selection_tips_limit")
    end
  end
end

local __DirLeft = Vector2.New(-1, 0)

function UIChatViewPrivateListItem_v2:OnScreenTouchMove(touchInfo)
  if not self.room or not self:GetListPrivateActive() then
    return
  end
  local viewShowType = DataCenter.ChatPrivateDataManager:GetShowType()
  if viewShowType == ChatPrivateListShowType.BatchDel then
    return
  end
  if CS.UnityEngine.RectTransformUtility.RectangleContainsScreenPoint(self.board.transform, touchInfo.pointerPos, CS.GameEntry.UICamera) then
    local dir = touchInfo.deltaPos.normalized
    local mag = touchInfo.deltaPos.magnitude
    local direction = CommonUtil.IsArabicAutoMirrorOpen() and -__DirLeft or __DirLeft
    local dot = Vector2.Dot(dir, direction)
    local trigger = (0.95 <= dot or dot <= -0.95) and 20 <= mag
    if trigger and self.view then
      self.view.middle.listPrivate:OnItemSlideToTargetPos(self.shell, 0 < dot)
    end
  end
end

function UIChatViewPrivateListItem_v2:OnUserInfoUpdate()
  if self.room then
    local userInfo = self.room:getPrivateOtherMember()
    self.userInfo = userInfo
    self.head:UpdateHead(userInfo, __emptyMsg)
    local roomName = self:TryGetRoomName()
    self.txtName:SetText(roomName)
    self:UpdateLayout()
    self:RefreshMigrationSign()
  end
end

function UIChatViewPrivateListItem_v2:TryGetRoomName()
  local roomName = ""
  local viewShowType = DataCenter.ChatPrivateDataManager:GetShowType()
  if viewShowType == ChatPrivateListShowType.Search then
    roomName = self.room:getRoomName()
    local searchTxt = DataCenter.ChatPrivateSearchDataManager.sendSearchTxt
    local targetMemberId = self.room:GetPrivateUser()
    local chatUserInfo = ChatManager2:GetInstance().User:getChatUserInfo(targetMemberId)
    if chatUserInfo then
      local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(chatUserInfo.uid, chatUserInfo.userName)
      local showNameUpper = string.upper(showName)
      local searchTxtUpper = string.upper(searchTxt)
      local findStart, findEnd = string.find(showNameUpper, searchTxtUpper)
      if findStart and findEnd then
        local needReplaceTxt = string.sub(showName, findStart, findEnd)
        showName = string.gsub(showName, needReplaceTxt, "<color=#099b4a>" .. needReplaceTxt .. "</color>")
      end
      if not string.IsNullOrEmpty(chatUserInfo.allianceSimpleName) then
        local alSimpleNameShow = chatUserInfo.allianceSimpleName
        local alSimpleNameShowUpper = string.upper(alSimpleNameShow)
        local findStart, findEnd = string.find(alSimpleNameShowUpper, searchTxtUpper)
        if findStart and findEnd then
          local needReplaceTxt = string.sub(alSimpleNameShow, findStart, findEnd)
          alSimpleNameShow = string.gsub(alSimpleNameShow, needReplaceTxt, "<color=#099b4a>" .. needReplaceTxt .. "</color>")
        end
        roomName = string.format("(%s)%s", alSimpleNameShow, showName)
      else
        roomName = string.format("%s", showName)
      end
    elseif self.room.group == ChatGroupType.GROUP_CUSTOM_GROUP then
      local showName = self.room:getRoomName()
      local showNameUpper = string.upper(showName)
      local searchTxtUpper = string.upper(searchTxt)
      local findStart, findEnd = string.find(showNameUpper, searchTxtUpper)
      if findStart and findEnd then
        local needReplaceTxt = string.sub(showName, findStart, findEnd)
        showName = string.gsub(showName, needReplaceTxt, "<color=#099b4a>" .. needReplaceTxt .. "</color>")
      end
      roomName = showName
    end
  else
    roomName = self.room:getRoomName()
  end
  return roomName
end

function UIChatViewPrivateListItem_v2:RefreshBatchSelectView()
  local isSelected = DataCenter.ChatPrivateDataManager:CheckRoomInBatchDel(self.room.roomId)
  self.btnBatchSelectImg:SetActive(isSelected)
  self.imgOn:SetActive(isSelected)
  self.imgOff:SetActive(not isSelected)
end

return UIChatViewPrivateListItem_v2
