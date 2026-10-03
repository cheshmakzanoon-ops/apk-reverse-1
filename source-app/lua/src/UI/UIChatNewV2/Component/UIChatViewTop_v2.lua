local base = UIBaseContainer
local UIChatViewTop_v2 = BaseClass("UIChatViewTop_v2", base)
local UIChatViewTabBtn = require("UI.UIChatNewV2.Component.UIChatViewTabButton_v2")
local Localization = CS.GameEntry.Localization
local UIActValentineCountDownItemComponent = require("UI.LWUIActValentineCountDown.UIActValentineCountDownItemComponent")
local UIAdaptReddot = require("UI.UICommon.Component.UIAdaptReddot")
local compBook = {
  {
    path = "txtWindow",
    name = "txtWindow",
    type = UITextMeshProUGUIEx,
    textKey = 110053
  },
  {
    path = "layoutBtns/btnNotice",
    name = "btnNotice",
    type = UIButton,
    onClick = function(self)
      self:OnClickNotice()
    end,
    active = false
  },
  {
    path = "layoutBtns/btnSettings",
    name = "btnSettings",
    type = UIButton,
    onClick = function(self)
      self:OnClickSettings()
    end,
    active = true
  },
  {
    path = "layoutBtns/btnNews",
    name = "btnNews",
    type = UIButton,
    onClick = function(self)
      self:OnClickNews()
    end,
    active = true
  },
  {
    path = "layoutBtns/btnSettings/dotSetting",
    name = "dotSettings",
    type = UIImage,
    active = false
  },
  {
    path = "layoutBtns/groupChatBtn",
    name = "groupChatBtn",
    type = UIButton,
    onClick = function(self)
      self:OnClickGroupChat()
    end,
    active = true
  },
  {
    path = "layoutBtns/btnNews/dotNews",
    name = "dotNews",
    type = UIImage,
    active = false
  },
  {
    path = "layoutBtns/btnNews/newsDotTip",
    name = "newsDotTip",
    type = UIImage,
    active = false
  },
  {
    path = "layoutTabs",
    name = "layoutTabs",
    type = nil
  },
  {
    path = "tabTemplate",
    name = "tabTemplate",
    type = nil,
    active = false
  },
  {
    path = "layoutBtns/btnNews/dotNews/imgDot/txtNum",
    name = "dotTxtNum",
    type = UIText
  },
  {
    path = "",
    name = "topLayoutElement",
    type = UILayoutElement
  },
  {
    path = "layoutBtns/postMoment",
    name = "postMoment",
    type = UIButton,
    onClick = function(self)
      self:OnClickPostMoment()
    end,
    active = false
  },
  {
    path = "layoutBtns/postMoment/dotPostMoment",
    name = "dotPostMoment",
    type = UIImage,
    active = false
  },
  {
    path = "layoutBtns/momentMsg",
    name = "momentMsg",
    type = UIButton,
    onClick = function(self)
      self:OnClickMomentMsg()
    end,
    active = true
  },
  {
    path = "layoutBtns/ValentineNode",
    name = "valentineNode",
    type = UIBaseContainer,
    active = false
  },
  {
    path = "layoutBtns/momentMsg/dotMsg",
    name = "dotMomentMsg",
    type = UIAdaptReddot,
    active = false
  }
}
local defaultMinHeight = 190

function UIChatViewTop_v2:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:UpdateNewsCenterBtnState()
  self:SetLayouTabState(true)
  self:UpdateSettingState()
  self:UpdateGroupChatSate()
end

function UIChatViewTop_v2:OnDestroy()
  self:ClearValentineCountDown()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIChatViewTop_v2:IsOpenRedPacket(info)
  if info:IsOpenInTime() and info:IsInOpenServers() then
    return true
  end
end

function UIChatViewTop_v2:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.tabComps = {}
  for i = 1, 10 do
    local tabTrans = self.layoutTabs.transform:Find("tab_" .. i)
    if IsNull(tabTrans) then
      break
    end
    local tabComp = self:AddComponent(UIChatViewTabBtn, tabTrans.gameObject)
    table.insert(self.tabComps, tabComp)
    tabComp:SetActive(false)
  end
end

function UIChatViewTop_v2:ComponentDestroy()
  self:ClearCompsByBook(compBook)
  self.tabComps = nil
end

function UIChatViewTop_v2:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnNewsReadStateChanged, self.UpdateNewsCenterBtnState)
  self:AddUIListener(EventId.CHAT_NEWSCENTER_ADDPUSH, self.UpdateNewsCenterBtnState)
  self:AddUIListener(EventId.OnPushNewNews, self.UpdateNewsCenterBtnState)
  self:AddUIListener(EventId.UIPushSettingChange, self.UpdateSettingState)
  self:AddUIListener(EventId.UpdateAIHelpRedPoint, self.UpdateSettingState)
  self:AddUIListener(EventId.CHAT_NEWSCENTER_REDDOTSETTING_UPDATA, self.UpdateNewsCenterBtnState)
  self:AddUIListener(EventId.CHAT_MOMENT_NOTICE_REDDOT, self.UpdateMomentMsgRedDot)
end

function UIChatViewTop_v2:OnRemoveListener()
  self:RemoveUIListener(EventId.UIPushSettingChange, self.UpdateSettingState)
  self:RemoveUIListener(EventId.OnNewsReadStateChanged, self.UpdateNewsCenterBtnState)
  self:RemoveUIListener(EventId.CHAT_NEWSCENTER_ADDPUSH, self.UpdateNewsCenterBtnState)
  self:RemoveUIListener(EventId.OnPushNewNews, self.UpdateNewsCenterBtnState)
  self:RemoveUIListener(EventId.CHAT_MOMENT_NOTICE_REDDOT, self.UpdateMomentMsgRedDot)
  self:RemoveUIListener(EventId.UpdateAIHelpRedPoint, self.UpdateSettingState)
  self:RemoveUIListener(EventId.CHAT_NEWSCENTER_REDDOTSETTING_UPDATA, self.UpdateNewsCenterBtnState)
  base.OnRemoveListener(self)
end

function UIChatViewTop_v2:UpdateTabs(roomSets)
  local tabIdx = 1
  self.tabCompDic = {}
  for _, roomSet in ipairs(roomSets) do
    if roomSet.rooms ~= nil and (#roomSet.rooms ~= 0 or roomSet.category == ChatRoomCategory.PRIVATE) then
      local tabComp = self.tabComps[tabIdx]
      if not tabComp then
        local tabGo
        local tabTrans = self.layoutTabs.transform:Find("tab_" .. tabIdx)
        if not IsNull(tabTrans) then
          tabGo = tabTrans.gameObject
        else
          tabGo = CS.UnityEngine.GameObject.Instantiate(self.tabTemplate, self.layoutTabs.transform)
          tabGo.name = "tab_" .. tabIdx
        end
        tabComp = self:AddComponent(UIChatViewTabBtn, tabGo)
        table.insert(self.tabComps, tabComp)
      end
      tabComp:SetData(roomSet)
      tabComp:SetText(roomSet.textKey, true)
      tabComp:SetIsOn(roomSet.selected)
      local type, number = roomSet:GetUnreadNumber()
      tabComp:SetRedDotType(type)
      tabComp:SetReddotNumber(number)
      tabComp:SetOnClick(self.OnClickTab, self)
      tabComp:SetActive(true)
      tabIdx = tabIdx + 1
      self.tabCompDic[roomSet.category] = tabComp
    end
  end
  for i = tabIdx, #self.tabComps do
    if self.tabComps[i] then
      self.tabComps[i]:SetData(nil)
      self.tabComps[i]:SetOnClick(nil)
      self.tabComps[i]:SetActive(false)
    end
  end
end

function UIChatViewTop_v2:UpdateGroupChatSate()
  self.groupChatBtn:SetActive(ChatInterface.IsDuringSeason() and ChatInterface.GetGroupChatIsOpen())
end

function UIChatViewTop_v2:UpdateMomentMsgRedDot()
  local roomSet = self.view:GetSelectedRoomSet()
  if not roomSet then
    return
  end
  local momentRoomSet = self.view:GetRoomSet(ChatRoomCategory.MOMENT)
  if momentRoomSet then
    local redType, number = momentRoomSet:GetUnreadNumber()
    local tabComp = self.tabCompDic and self.tabCompDic[momentRoomSet.category]
    if tabComp then
      tabComp:SetRedDotType(redType)
      tabComp:SetReddotNumber(number)
    end
  end
  local moment = ChatInterface.getMoment()
  if not moment then
    return
  end
  local commentCount = moment:GetRedDot(MomentPushType.NoticeComment) or 0
  local likeCount = moment:GetRedDot(MomentPushType.NoticeLike) or 0
  if 0 < commentCount then
    self.dotMomentMsg:SetRedDotType(UnreadNotificationType.ShowUnreadCount)
    self.dotMomentMsg:SetNumber(commentCount)
  else
    self.dotMomentMsg:SetRedDotType(UnreadNotificationType.ShowUnreadDot)
    self.dotMomentMsg:SetNumber(likeCount)
  end
end

function UIChatViewTop_v2:OnClickGroupChat()
  local selfLevel = DataCenter.BuildManager:GetMainLevel()
  local openLv = LuaEntry.DataConfig:TryGetNum("chat_group_limit", "k3")
  if selfLevel >= openLv then
    local param = {
      openType = GroupMemberOpenType.CreateRooom
    }
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatGroupSelectMember, {anim = true}, param)
  else
    UIUtil.ShowTips(Localization:GetString("group_create_notice", openLv))
  end
end

function UIChatViewTop_v2:OnClickPostMoment()
  local isFirstPost = CommonUtil.PlayerPrefsGetBool("FirstPostMoment", true)
  if isFirstPost then
    UIUtil.ShowMessage(Localization:GetString("moment_privacy_des"), 2, "moment_privacy_btn", GameDialogDefine.CANCEL, function()
      CommonUtil.PlayerPrefsSetBool("FirstPostMoment", false)
      local roomId = ChatManager2:GetInstance().Room:GetFriendsCircleRoomId(LuaEntry.Player.uid)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPostCircleFriend, {anim = true}, roomId)
    end)
  else
    local roomId = ChatManager2:GetInstance().Room:GetFriendsCircleRoomId(LuaEntry.Player.uid)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPostCircleFriend, {anim = true}, roomId)
  end
end

function UIChatViewTop_v2:OnClickMomentMsg()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWMomentPush, {anim = true})
end

function UIChatViewTop_v2:UpdateTabsReddot()
  for _, tabComp in ipairs(self.tabComps) do
    if tabComp.data then
      local type, number = tabComp.data:GetUnreadNumber()
      tabComp:SetRedDotType(type)
      tabComp:SetReddotNumber(number)
    else
      tabComp:SetReddotNumber(0)
    end
  end
end

function UIChatViewTop_v2:UpdateNewsCenterBtnState()
  local serverUnlock = LuaEntry.DataConfig:CheckSwitch("world_news")
  if serverUnlock then
    self.btnNews:SetActive(true)
    local newsRed = DataCenter.LWNewsCenterManager:GetNewsRed()
    if newsRed then
      self.newsDotTip:SetActive(true)
    else
      self.newsDotTip:SetActive(false)
      if DataCenter.LWNewsCenterManager:GetNotRedSetting(ChatNewsCenterTabType.World) and ChatInterface.IsDuringSeason() then
        self.dotNews:SetActive(false)
      else
        local count = DataCenter.LWNewsCenterManager:GetRedDontCount()
        self.dotTxtNum:SetText(count)
        self.dotNews:SetActive(0 < count)
      end
    end
  else
    self.btnNews:SetActive(false)
  end
end

function UIChatViewTop_v2:UpdateSettingState()
  local pushRed = DataCenter.PushSettingsManager:HasNewPushUnread()
  local customerServiceRed = false
  if ChatInterface.ServiceBubbleIsOpen() then
    customerServiceRed = DataCenter.LWCustomerServiceManager:GetCustomerServiceRedPointData()
  end
  self.dotSettings:SetActive(pushRed or customerServiceRed)
end

function UIChatViewTop_v2:UpdateTopBtns()
  local roomSet = self.view:GetSelectedRoomSet()
  self.postMoment:SetActive(roomSet.category == ChatRoomCategory.MOMENT)
  self.momentMsg:SetActive(roomSet.category == ChatRoomCategory.MOMENT)
  self.btnNews:SetActive(roomSet.category ~= ChatRoomCategory.MOMENT)
  if roomSet.category == ChatRoomCategory.MOMENT then
    self:UpdateMomentMsgRedDot()
    self.groupChatBtn:SetActive(false)
  else
    self:UpdateGroupChatSate()
  end
  self.btnNotice:SetActive(false)
  local showValentineCountDown = DataCenter.ValentineDataManager:GetAnyMatchSuccess() and roomSet and roomSet.category == ChatRoomCategory.PRIVATE
  self.valentineNode:SetActive(showValentineCountDown)
  if showValentineCountDown then
    self:InitValentineCountDown()
  end
end

function UIChatViewTop_v2:UpdateAllianceNoticeBtnState()
  self:UpdateTopBtns()
end

function UIChatViewTop_v2:OnClickNotice()
  local canChat = DataCenter.LWRefundPunishManager:GetCanChat()
  if not canChat then
    return
  end
  self.view:ShowAllianceNoticePopup()
end

function UIChatViewTop_v2:OnClickNews()
  local clientUnlock, tipId = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.NewsCenter)
  if clientUnlock then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWNewsCenter, {anim = false})
  else
    UIUtil.ShowTipsId(tipId)
  end
end

function UIChatViewTop_v2:OnClickSettings()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChannelSetting)
end

function UIChatViewTop_v2:OnClickTab(tabComp)
  if tabComp.isOn then
    return
  end
  for _, comp in ipairs(self.tabComps) do
    if comp.data then
      comp.data.selected = comp == tabComp
    end
  end
  if tabComp.data.category == ChatRoomCategory.MOMENT then
    PostEventLog.Track(PostEventLog.Defines.MomentTabEnter)
  end
  if tabComp.data.category == ChatRoomCategory.PRIVATE then
    DataCenter.ChatPrivateDataManager:OnTabSelectPrivate()
    self.view:ShowPrivateRoomList()
  else
    DataCenter.ChatPrivateDataManager:SetToNormalData()
    if ChatInterface.IsChatRoomDebug() then
      if tabComp.data and tabComp.data.currRoom and string.IsNullOrEmpty(tabComp.data.currRoom.category) then
        Logger.LogError("activityRoom is Close ------------> tabComp.data.currRoom.category is nil  roomId : " .. tabComp.data.currRoom.roomId .. " group : " .. tabComp.data.currRoom.group)
      elseif not tabComp.data then
        Logger.LogError("activityRoom is Close ------------> tabComp.data is nil ")
      end
    end
    self.view:SelectRoom(tabComp.data.currRoom)
  end
end

function UIChatViewTop_v2:SetLayouTabState(isShow)
  self.topLayoutElement.unity_LayoutElement.minHeight = isShow and defaultMinHeight or 100
  self.layoutTabs:SetActive(isShow)
end

function UIChatViewTop_v2:ClearValentineCountDown()
  self.valentineNode:RemoveComponents(UIActValentineCountDownItemComponent)
  if self.valentineNodeReq then
    self:GameObjectDestroy(self.valentineNodeReq)
    self.valentineNodeReq = nil
  end
end

function UIChatViewTop_v2:InitValentineCountDown()
  if not IsNull(self.valentineNodeReq) then
    return
  end
  self.valentineNode:SetActive(true)
  local valentineCountDownNode = "Assets/Main/Prefabs/UI/ActivityCenter/Valentine/UIActValentineCountDownItem.prefab"
  self.valentineNodeReq = self:GameObjectInstantiateAsync(valentineCountDownNode, function(req)
    if req == nil then
      return
    end
    local obj = req.gameObject
    if IsNull(obj) then
      return
    end
    NameCount = NameCount + 1
    local nodeName = "valentine_CountDown" .. NameCount
    obj.name = nodeName
    obj:SetActive(true)
    obj.transform:SetParent(self.valentineNode.transform)
    obj.transform:Set_localPosition(0, 0, 0)
    obj.transform:Set_localScale(1, 1, 1)
    obj.transform:Set_pivot(0.5, 0.5)
    local cell = self.valentineNode:AddComponent(UIActValentineCountDownItemComponent, nodeName)
    cell:ReInit()
  end)
end

return UIChatViewTop_v2
