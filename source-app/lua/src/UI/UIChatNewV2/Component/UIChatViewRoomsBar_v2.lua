local base = UIBaseContainer
local UIChatViewRoomsBar_v2 = BaseClass("UIChatViewRoomsBar_v2", base)
local UIChatViewTabBtn = require("UI.UIChatNewV2.Component.UIChatViewTabButton_v2")
local Localization = CS.GameEntry.Localization
local compBook = {
  {
    path = "singleRoom",
    name = "singleRoom",
    type = UIBaseContainer
  },
  {
    path = "singleRoom/txtSingleRoom",
    name = "txtSingleRoom",
    type = UITextMeshProUGUIEx
  },
  {
    path = "scrollRooms",
    name = "scrollRooms",
    type = UIScrollRect
  },
  {
    path = "scrollRooms/Viewport/Content",
    name = "layoutRooms",
    rawType = CS.BidirectionalHorizontalLayoutGroup
  },
  {
    path = "scrollRoomsL2",
    name = "scrollRoomsL2",
    type = UIScrollRect
  },
  {
    path = "scrollRoomsL2/Viewport/Content",
    name = "layoutRoomsL2",
    rawType = CS.BidirectionalHorizontalLayoutGroup
  },
  {
    path = "tabTemplate",
    name = "tabTemplate",
    type = nil,
    active = false
  },
  {
    path = "tabTemplateL2",
    name = "tabTemplateL2",
    type = nil,
    active = false
  },
  {
    path = "singleRoom/roomTipBtn",
    name = "roomTipBtn",
    type = UIButton,
    onClick = function(self)
      self:OnClickTipBtn()
    end
  },
  {
    path = "singleRoom/roomNameBtn",
    name = "roomNameBtn",
    type = UIButton,
    onClick = function(self)
      self:OnClickRoomNameBtn()
    end
  },
  {
    path = "singleRoom/roomTipBtn/roomTipIcon",
    name = "roomTipIcon",
    type = UIImage
  }
}
local Notice_Tab_List = {
  "alliance_announcement_list_update",
  "alliance_announcement_list_pinned"
}
local roomTipBtnConfig = {
  [ChatRoomCategory.PRIVATE] = {
    icon = "Assets/Main/Sprites/UI/LWChat_v2/DefaultSkin/ChatItems/mjc_tongyong_anniu_xiao_xiangqing01.png",
    roomNameClick = function(room)
      if not room then
        return
      end
      if room:isPrivateChat() or room.group == ChatGroupType.GROUP_TMPRoom then
        local userInfo = room:getPrivateOtherMember()
        if userInfo then
          UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true, hideTop = false}, userInfo.uid)
        end
      end
    end,
    tipBtnClick = function(room)
      if not room then
        return
      end
      if room:isPrivateChat() or room.group == ChatGroupType.GROUP_TMPRoom then
        local userInfo = room:getPrivateOtherMember()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWChangeRemarkName, {anim = true}, userInfo.uid, userInfo.userName)
      elseif room.group == ChatGroupType.GROUP_CUSTOM_GROUP then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIGroupChatSetting, {anim = true}, room)
      end
    end
  }
}

function UIChatViewRoomsBar_v2:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.roomSet = nil
  self.tabL2 = 1
end

function UIChatViewRoomsBar_v2:OnDestroy()
  self.roomSet = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIChatViewRoomsBar_v2:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UPDATE_MSG_USERINFO, self.OnChatUserInfoUpdate)
  self:AddUIListener(EventId.CHAT_ROOM_REDDONT_UPDATE, self.UpdateTabsReddot)
end

function UIChatViewRoomsBar_v2:OnRemoveListener()
  self:RemoveUIListener(EventId.UPDATE_MSG_USERINFO, self.OnChatUserInfoUpdate)
  self:RemoveUIListener(EventId.CHAT_ROOM_REDDONT_UPDATE, self.UpdateTabsReddot)
  base.OnRemoveListener(self)
end

function UIChatViewRoomsBar_v2:OnChatUserInfoUpdate()
  if self.singleRoom:GetActive() and self.roomSet and self.roomSet.category == ChatRoomCategory.PRIVATE then
    self.txtSingleRoom:SetText(self.roomSet.currRoom:getRoomName())
  end
end

function UIChatViewRoomsBar_v2:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.tabComps = {}
  for i = 1, 10 do
    local tabTrans = self.layoutRooms.transform:Find("tab_" .. i)
    if IsNull(tabTrans) then
      break
    end
    local tabComp = self:AddComponent(UIChatViewTabBtn, tabTrans.gameObject)
    table.insert(self.tabComps, tabComp)
    tabComp:SetActive(false)
  end
  self.tabCompsL2 = {}
  for i = 1, 10 do
    local tabTrans = self.layoutRoomsL2.transform:Find("tab_" .. i .. "_L2")
    if IsNull(tabTrans) then
      break
    end
    local tabComp = self:AddComponent(UIChatViewTabBtn, tabTrans.gameObject)
    table.insert(self.tabCompsL2, tabComp)
    tabComp:SetActive(false)
  end
end

function UIChatViewRoomsBar_v2:ComponentDestroy()
  self:ClearCompsByBook(compBook)
  self.tabComps = nil
  self.tabCompsL2 = nil
end

function UIChatViewRoomsBar_v2:OnClickTipBtn()
  if self.roomSet and self.roomSet.category then
    local config = roomTipBtnConfig[self.roomSet.category]
    if config and config.tipBtnClick then
      config.tipBtnClick(self.roomSet.currRoom)
    end
  end
end

function UIChatViewRoomsBar_v2:OnClickRoomNameBtn()
  if self.roomSet and self.roomSet.category then
    local config = roomTipBtnConfig[self.roomSet.category]
    if config and config.roomNameClick then
      config.roomNameClick(self.roomSet.currRoom)
    end
  end
end

function UIChatViewRoomsBar_v2:UpdateTabs(roomSet, scrollToActive)
  self.roomSet = roomSet
  if roomSet.category == ChatRoomCategory.PRIVATE then
    self.scrollRooms:SetActive(false)
    self.scrollRoomsL2:SetActive(false)
    self.singleRoom:SetActive(true)
    self.txtSingleRoom:SetText(roomSet.currRoom:getRoomName())
  elseif #roomSet.rooms == 1 then
    self.scrollRooms:SetActive(false)
    self.scrollRoomsL2:SetActive(false)
    self.singleRoom:SetActive(true)
    self.txtSingleRoom:SetText(roomSet.rooms[1]:getRoomName())
  else
    self.singleRoom:SetActive(false)
    self.scrollRooms:SetActive(true)
    if roomSet.currRoom ~= nil and roomSet.currRoom.category == ChatRoomCategory.ALLIANCE and roomSet.currRoom.group == "notice" then
      self.scrollRoomsL2:SetActive(true)
      self:UpdateUpdateTabsL2()
    else
      self.scrollRoomsL2:SetActive(false)
    end
    local tabIdx = 1
    local roomCnt = #roomSet.rooms
    local targetIndex
    for _, room in ipairs(roomSet.rooms) do
      local tabComp = self.tabComps[tabIdx]
      if not tabComp then
        local tabGo
        local tabTrans = self.layoutRooms.transform:Find("tab_" .. tabIdx)
        if not IsNull(tabTrans) then
          tabGo = tabTrans.gameObject
        else
          tabGo = CS.UnityEngine.GameObject.Instantiate(self.tabTemplate, self.layoutRooms.transform)
          tabGo.name = "tab_" .. tabIdx
        end
        tabComp = self:AddComponent(UIChatViewTabBtn, tabGo)
        table.insert(self.tabComps, tabComp)
      end
      tabComp:SetData(room)
      tabComp:SetText(room:getRoomName())
      tabComp:SetIsOn(roomSet.currRoom.roomId == room.roomId)
      tabComp:SetOnClick(self.OnClickTab, self)
      self:SetRedDotType(room, tabComp)
      tabComp:SetReddotNumber(room:getNewMsgNum())
      tabComp:SetCountLine(3 < roomCnt)
      tabComp:SetSizeDeltaXY(roomCnt == 2 and 394 or roomCnt == 3 and 263 or 230, 64)
      tabComp:SetActive(true)
      tabIdx = tabIdx + 1
      if roomSet.currRoom.roomId == room.roomId and 3 < roomCnt then
        targetIndex = _
      end
    end
    if scrollToActive and targetIndex then
      self.scrollRooms:SetHorizontalNormalizedPosition((targetIndex - 1) / (roomCnt - 1))
    end
    for i = tabIdx, #self.tabComps do
      if self.tabComps[i] then
        self.tabComps[i]:SetActive(false)
      end
    end
  end
  local config = roomTipBtnConfig[self.roomSet.category]
  if config then
    self.roomTipBtn:SetActive(true)
    self.roomTipIcon:LoadSprite(config.icon)
  else
    self.roomTipBtn:SetActive(false)
  end
end

function UIChatViewRoomsBar_v2:UpdateUpdateTabsL2()
  if self.roomSet.currRoom then
    if self.roomSet.currRoom.noticeTab then
      self.tabL2 = self.roomSet.currRoom.noticeTab
    else
      self.roomSet.currRoom.noticeTab = self.tabL2
    end
  end
  for i = 1, #Notice_Tab_List do
    local tabCompL2 = self.tabCompsL2[i]
    if not tabCompL2 then
      local tabGo
      local tabTrans = self.layoutRoomsL2.transform:Find("tab_" .. i .. "_L2")
      if not IsNull(tabTrans) then
        tabGo = tabTrans.gameObject
      else
        tabGo = CS.UnityEngine.GameObject.Instantiate(self.tabTemplateL2, self.layoutRoomsL2.transform)
        tabGo.name = "tab_" .. i .. "_L2"
      end
      tabCompL2 = self:AddComponent(UIChatViewTabBtn, tabGo)
      table.insert(self.tabCompsL2, tabCompL2)
    end
    tabCompL2:SetText(Localization:GetString(Notice_Tab_List[i]))
    tabCompL2:SetIsOn(self.tabL2 == i)
    tabCompL2:SetOnClick(self.OnClickTabL2, self)
    tabCompL2:SetSizeDeltaXY(386, 64)
    tabCompL2:SetActive(true)
  end
end

function UIChatViewRoomsBar_v2:SetRedDotType(room, tabComp)
  if not room or not tabComp then
    return
  end
  local type = ChatManager2:GetInstance().Room:GetRoomRedDotType(room.group)
  tabComp:SetRedDotType(type)
end

function UIChatViewRoomsBar_v2:UpdateTabsReddot()
  for _, tabComp in ipairs(self.tabComps) do
    self:SetRedDotType(tabComp.data, tabComp)
    tabComp:SetReddotNumber(tabComp.data and tabComp.data:getNewMsgNum() or 0)
  end
end

function UIChatViewRoomsBar_v2:OnClickTab(tabComp)
  if tabComp.isOn then
    return
  end
  self.roomSet.currRoom = tabComp.data
  if GMUtils.GetBool(GMConst.DebugClickLogWarning, false) then
    local _roomId = string.format("[Debug][\232\129\138\229\164\169]group:%s, id:%s", tabComp.data.group, tabComp.data.roomId)
    UIUtil.ShowTips(_roomId)
  end
  self.view:SelectRoom(tabComp.data)
end

function UIChatViewRoomsBar_v2:OnClickTabL2(tabComp)
  if tabComp.isOn then
    return
  end
  local currRoom = self.roomSet.currRoom
  self.tabL2 = 1
  if currRoom ~= nil and currRoom.category == ChatRoomCategory.ALLIANCE and currRoom.group == "notice" then
    self.tabL2 = tabComp.gameObject.name == "tab_1_L2" and 1 or 2
    currRoom.noticeTab = self.tabL2
  end
  self.view:SelectRoom(currRoom)
end

return UIChatViewRoomsBar_v2
