local base = UIBaseContainer
local UIGiftSearchPrivateListItem = BaseClass("UIGiftSearchPrivateListItem", base)
local UIPrivateLayoutBtnItem = require("UI.UIChatNewV2.Component.UIPrivateLayoutBtnItem")
local Localization = CS.GameEntry.Localization
local UIChatHead = require("UI.UIChatNew.Component.ChatHead")
local UIAdaptReddot = require("UI.UICommon.Component.UIAdaptReddot")
local GroupHead = require("UI/UIChatNewV2/Component/GroupHead")
local oneWidth = 125
local off = 10
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
    path = "board/reddot",
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
    path = "board/reddot/imgDot",
    name = "redIcon",
    type = UIImage
  },
  {
    path = "board/Image",
    name = "disturbIcon",
    type = UIImage
  }
}

function UIGiftSearchPrivateListItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  local dlgComponent = ChatInterface.isTestingServer() and UITextMeshProUGUIEx or UIText
  self.txtMsg = self:AddComponent(dlgComponent, "board/txtMsg")
  self.theItem = self.transform:Find("btnItem").gameObject
  self.theItem:GameObjectCreatePool()
  if ChatInterface.isTestingServer() then
    ChatInterface.SetEmojiTextProperty(self.txtMsg)
  end
end

function UIGiftSearchPrivateListItem:OnDestroy()
  self.btnsLayout:RemoveComponents(UIPrivateLayoutBtnItem)
  self.theItem:GameObjectRecycleAll()
  self:ComponentDestroy()
  base.OnDestroy(self)
  self.shell = nil
  self.room = nil
end

function UIGiftSearchPrivateListItem:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function UIGiftSearchPrivateListItem:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UIGiftSearchPrivateListItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UPDATE_MSG_USERINFO, self.OnUserInfoUpdate)
  self:AddUIListener(EventId.CHAT_ROOM_NOTDISTURD_UPDATE, self.OnRoomNotDisturdUpdate)
end

function UIGiftSearchPrivateListItem:OnRemoveListener()
  self:RemoveUIListener(EventId.UPDATE_MSG_USERINFO, self.OnUserInfoUpdate)
  self:RemoveUIListener(EventId.CHAT_ROOM_NOTDISTURD_UPDATE, self.OnRoomNotDisturdUpdate)
  base.OnRemoveListener(self)
end

function UIGiftSearchPrivateListItem:OnRoomNotDisturdUpdate(room)
  if not room or not self.room then
    return
  end
  if self.room.roomId == room.roomId then
    self:UpdateNotDisturbingIcon()
  end
end

local __emptyMsg = {}

function UIGiftSearchPrivateListItem:UpdateItem(shell)
  if not shell or not shell.room then
    return
  end
  self.btnsLayout:RemoveComponents(UIPrivateLayoutBtnItem)
  self.theItem:GameObjectRecycleAll()
  self:SetSizeDeltaXY(self.view.img_bg:GetSizeDelta().x or DefaultScreenWidth, self:GetSizeDelta().y)
  self.shell = shell
  self.room = shell.room
  local roomName = self:TryGetRoomName()
  self.txtName:SetText(roomName)
  local latestMsg = self.room.msgs[#self.room.msgs]
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
  local count = self.room:getNewMsgNum()
  local unreadCount = math.floor(count)
  self.reddot:SetNumber(unreadCount)
  self.imgOn:SetActive(0 < unreadCount)
  self.imgOff:SetActive(unreadCount <= 0)
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
  if boardOffsetIsSameAsNormal then
    self:Update()
  end
  if btnBatchSelectIsSameAsNormal then
    self.btnBatchSelect:SetActive(false)
  end
  if self.shell and self.shell.parent then
    self.shell.parent:GetRoomLast(self.room.roomId)
  end
  self:UpdateNotDisturbingIcon()
end

function UIGiftSearchPrivateListItem:UpdateNotDisturbingIcon()
  if self.room:GetNotDisturbing() then
    self.redIcon:LoadSprite(path.dot)
    self.disturbIcon:SetActive(true)
  else
    self.redIcon:LoadSprite(path.def)
    self.disturbIcon:SetActive(false)
  end
  self:UpdateLayout()
end

function UIGiftSearchPrivateListItem:UpdateLayout()
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

function UIGiftSearchPrivateListItem:OnBtnItemClick(btnType)
end

function UIGiftSearchPrivateListItem:Update()
end

function UIGiftSearchPrivateListItem:GetListPrivateActive()
  if self.view then
    return self.view.scrollRooms:GetActive()
  end
  return false
end

function UIGiftSearchPrivateListItem:OnClickBoard()
  if not self.room then
    return
  end
  local userdata = {}
  userdata.roomId = self.room.roomId
  local member = self.room:getPrivateOtherMember()
  local selectId = self.view.selectGiftId
  GoToUtil.OpenChatView(true, {anim = false}, userdata)
  DataCenter.GiftSystemManager:OpenOperationView({
    windowType = GiftSystemConst.WindowType.Send,
    targetUid = member.uid,
    targetServerId = member.serverId,
    defaultSelectId = selectId
  })
end

function UIGiftSearchPrivateListItem:OnClickBatchSelect()
end

function UIGiftSearchPrivateListItem:OnUserInfoUpdate()
  if self.room then
    local userInfo = self.room:getPrivateOtherMember()
    self.head:UpdateHead(userInfo, __emptyMsg)
    local roomName = self:TryGetRoomName()
    self.txtName:SetText(roomName)
    self:UpdateLayout()
  end
end

function UIGiftSearchPrivateListItem:TryGetRoomName()
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

function UIGiftSearchPrivateListItem:RefreshBatchSelectView()
end

return UIGiftSearchPrivateListItem
