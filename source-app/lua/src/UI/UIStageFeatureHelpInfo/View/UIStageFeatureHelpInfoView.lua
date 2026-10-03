local UIStageFeatureHelpInfoView = BaseClass("UIStageFeatureHelpInfoView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIStageFeatureHelpInfoItem = require("UI.UIStageFeatureHelpInfo.Component.UIStageFeatureHelpInfoItem")
local TabType = {HelpToMe = 1, HelpFromMe = 2}

function UIStageFeatureHelpInfoView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIStageFeatureHelpInfoView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIStageFeatureHelpInfoView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.compTabHelpFromMeOn = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.btnTabHelpFromMeOff = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnTabHelpFromMeOff:SetOnClick(function()
    self:OnBtnTabHelpFromMeOffClick()
  end)
  self.compTabHelpToMeOn = self.viewSkin:AddComponent(self, UIBaseComponent, 6)
  self.btnTabHelpToMeOff = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnTabHelpToMeOff:SetOnClick(function()
    self:OnBtnTabHelpToMeOffClick()
  end)
  self.textTimesDes = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.scrollView = self.viewSkin:AddComponent(self, UIScrollView, 9)
  self.textEmptyTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.btnJoin = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnJoin:SetOnClick(function()
    self:OnBtnJoinClick()
  end)
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemCreateCell(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemDeleteCell(itemObj, index)
  end)
  self.tabsOn = {
    [TabType.HelpToMe] = self.compTabHelpToMeOn,
    [TabType.HelpFromMe] = self.compTabHelpFromMeOn
  }
  self.tabsOff = {
    [TabType.HelpToMe] = self.btnTabHelpToMeOff,
    [TabType.HelpFromMe] = self.btnTabHelpFromMeOff
  }
  self:SwitchTab(TabType.HelpToMe)
  self.btnJoin:SetActive(false)
end

function UIStageFeatureHelpInfoView:ComponentDestroy()
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(UIStageFeatureHelpInfoItem)
  self.scrollCellPool = {}
  self.viewSkin = nil
  self.btnPanel = nil
  self.textTitle = nil
  self.btnClose = nil
  self.compTabHelpFromMeOn = nil
  self.btnTabHelpFromMeOff = nil
  self.compTabHelpToMeOn = nil
  self.btnTabHelpToMeOff = nil
  self.textTimesDes = nil
  self.scrollView = nil
  self.textEmptyTip = nil
  self.btnJoin = nil
end

function UIStageFeatureHelpInfoView:DataDefine()
end

function UIStageFeatureHelpInfoView:DataDestroy()
end

function UIStageFeatureHelpInfoView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PlaneFeatureGetHelpToMe, self.OnGetHelpToMeInfo)
  self:AddUIListener(EventId.PlaneFeatureGetHelpFromMe, self.OnGetHelpFromMeInfo)
  self:AddUIListener(EventId.PlaneFeatureAcceptInviteSuccess, self.OnAcceptInviteSuccess)
  self:AddUIListener(EventId.PlaneFeatureAcceptResultSuccess, self.OnAcceptHelpResult)
end

function UIStageFeatureHelpInfoView:OnRemoveListener()
  self:RemoveUIListener(EventId.PlaneFeatureGetHelpToMe, self.OnGetHelpToMeInfo)
  self:RemoveUIListener(EventId.PlaneFeatureGetHelpFromMe, self.OnGetHelpFromMeInfo)
  self:RemoveUIListener(EventId.PlaneFeatureAcceptInviteSuccess, self.OnAcceptInviteSuccess)
  self:RemoveUIListener(EventId.PlaneFeatureAcceptResultSuccess, self.OnAcceptHelpResult)
  base.OnRemoveListener(self)
end

function UIStageFeatureHelpInfoView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIStageFeatureHelpInfoView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIStageFeatureHelpInfoView:OnBtnTabHelpFromMeOffClick()
  self:SwitchTab(TabType.HelpFromMe)
end

function UIStageFeatureHelpInfoView:OnBtnTabHelpToMeOffClick()
  self:SwitchTab(TabType.HelpToMe)
end

function UIStageFeatureHelpInfoView:SwitchTab(type)
  if self.curTab == type then
    return
  end
  self.curTab = type
  for k, v in pairs(self.tabsOn) do
    v:SetActive(k == type)
  end
  for k, v in pairs(self.tabsOff) do
    v:SetActive(k ~= type)
  end
  if type == TabType.HelpToMe then
    SFSNetwork.SendMessage(MsgDefines.PlaneFeatureHelpToMe)
  else
    SFSNetwork.SendMessage(MsgDefines.PlaneFeatureHelpFromMe)
  end
end

function UIStageFeatureHelpInfoView:OnGetHelpToMeInfo(message)
  if self.curTab ~= TabType.HelpToMe then
    return
  end
  self:RefreshView(message)
end

function UIStageFeatureHelpInfoView:OnGetHelpFromMeInfo(message)
  if self.curTab ~= TabType.HelpFromMe then
    return
  end
  self:RefreshView(message)
end

function UIStageFeatureHelpInfoView:RefreshView(message)
  local isInAlliance = LuaEntry.Player:IsInAlliance()
  self.btnJoin:SetActive(not isInAlliance)
  local count = 0
  if not (isInAlliance and message and message.list) or #message.list == 0 then
    self.textEmptyTip:SetActive(true)
    if not isInAlliance then
      self.textEmptyTip:SetLocalText("frontline_help_tips_14")
    else
      self.textEmptyTip:SetLocalText("activity_breakthrough_tips_34")
    end
    self.scrollView:SetActive(false)
  else
    self.textEmptyTip:SetActive(false)
    self.scrollView:SetActive(false)
    self.helpDataList = {}
    count = #message.list
    local list = message.list
    for i = 1, count do
      table.insert(self.helpDataList, list[i])
    end
    table.sort(self.helpDataList, function(a, b)
      return a.startTime > b.startTime
    end)
    if 0 < count then
      self.scrollView:SetActive(true)
      self.scrollView:SetTotalCount(count)
      self.scrollView:RefillCells()
    else
      self.scrollView:SetActive(false)
    end
  end
  local curTimes = 0
  if self.curTab == TabType.HelpToMe then
    curTimes = message.helpTimes or 0
    self:SetTimesDes(curTimes)
  else
    curTimes = message.beHelpedTimes or 0
    self:SetTimesDes(curTimes)
  end
end

function UIStageFeatureHelpInfoView:SetTimesDes(curTimes)
  if self.curTab == TabType.HelpToMe then
    local maxTimes = DataCenter.LWStageFeatureChapterManager.todayHelpedMaxCount or 0
    local str = string.format("%d/%d", curTimes, maxTimes)
    self.textTimesDes:SetLocalText("frontline_help_message_15", str)
  else
    local maxTimes = DataCenter.LWStageFeatureChapterManager.todayAcceptResultMaxCount or 0
    local str = string.format("%d/%d", curTimes, maxTimes)
    self.textTimesDes:SetLocalText("frontline_help_message_14", str)
  end
end

function UIStageFeatureHelpInfoView:OnItemCreateCell(itemObj, index)
  local item = self.scrollCellPool[itemObj.name]
  if not item then
    local name = tostring(self.itemIndex)
    itemObj.name = name
    item = self.scrollView:AddComponent(UIStageFeatureHelpInfoItem, itemObj)
    self.scrollCellPool[name] = item
    self.itemIndex = self.itemIndex + 1
  end
  local helpData = self.helpDataList[index]
  item:Refresh(helpData, self.curTab)
end

function UIStageFeatureHelpInfoView:OnItemDeleteCell(itemObj, index)
  local item = self.scrollCellPool[itemObj.name]
  if item then
    self.scrollView:RemoveComponent(itemObj)
  end
end

function UIStageFeatureHelpInfoView:OnAcceptInviteSuccess(message)
  if self.curTab == TabType.HelpFromMe or not message then
    return
  end
  if not self.helpDataList or #self.helpDataList == 0 then
    return
  end
  local uuid = message.uuid
  for i, v in ipairs(self.helpDataList) do
    if v.uuid == uuid then
      v.state = message.state or StageFeatureHelpInfoState.AcceptInvite
      v.endTime = message.endTime or 0
      break
    end
  end
  self.scrollView:RefillCells()
  local helpInfo = DataCenter.LWStageFeatureChapterManager:GetHelpUserInfo()
  local curTimes = helpInfo.helpTimes
  self:SetTimesDes(curTimes)
end

function UIStageFeatureHelpInfoView:OnAcceptHelpResult(message)
  if self.curTab == TabType.HelpToMe or not message then
    return
  end
  if not self.helpDataList or #self.helpDataList == 0 then
    return
  end
  local uuid = message.uuid
  for i, v in ipairs(self.helpDataList) do
    if v.uuid == uuid then
      v.state = message.state or StageFeatureHelpInfoState.AcceptResult
      break
    end
  end
  self.scrollView:RefillCells()
  local helpInfo = DataCenter.LWStageFeatureChapterManager:GetHelpUserInfo()
  local curTimes = helpInfo.beHelpedTimes
  self:SetTimesDes(curTimes)
end

function UIStageFeatureHelpInfoView:OnBtnJoinClick()
  self.ctrl:CloseSelf()
  if LuaEntry.Player:IsFirstJoinAlliance() == true then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, {guide = false})
  end
end

return UIStageFeatureHelpInfoView
