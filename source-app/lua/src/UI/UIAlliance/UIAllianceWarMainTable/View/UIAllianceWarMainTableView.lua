local AllianceWarEventItem = require("UI.UIAlliance.UIAllianceWarMainTable.Component.AllianceWarEventItemComponent")
local LWAllianceWarItem = require("UI.UIAlliance.UIAllianceWarMainTable.Component.LWAllianceWarItem")
local UIPersonalWarning = require("UI.UIAlliance.UIAllianceWarMainTable.Component.UIPersonalWarning")
local AllyView = require("UI.UIAlliance.UIAllianceWarMainTable.Component.AllyView")
local UIAllianceWarMainTableView = BaseClass("UIAllianceWarMainTableView", UIBaseView)
local base = UIBaseView
local close_btn_path = "Root/BottomBar/BtnBack"
local scrollView_personal_path = "Root/PersonalScrollView"
local content_personal_path = "Root/PersonalScrollView/ContentPersonal"
local scrollView_alliance_path = "Root/AllianceScrollView"
local content_alliance_path = "Root/AllianceScrollView/View/ContentAlliance"
local war_event_scroll_path = "Root/WarEventScroll"
local war_event_content_path = "Root/WarEventScroll/View/WarEventContent"
local OneKeyIgnore_txt_path = "Root/OneKeyIgnore_Txt"
local OneKeyIgnore_btn_path = "Root/OneKeyIgnore_Txt/OneKeyIgnore_Btn"
local contentBg_path = "Root/ImageBg"
local contentTxt_path = "Root/ImageBg/TxtContect"
local toogle1_path = "Root/TabHolder/Tab/Toggle1"
local toogle2_path = "Root/TabHolder/Tab/Toggle2"
local toogle3_path = "Root/TabHolder/Tab/Toggle3"
local autoRally_path = "Root/BottomBar/autoRally"
local autoRallyBtn_path = "Root/BottomBar/autoRally/autoRallyBtn"
local autoRallyName_path = "Root/BottomBar/autoRally/txtBg/autoRallyTxt"
local autoRallyTime_path = "Root/BottomBar/autoRally/txtBg/autoRallyLeftTime"
local autoRallyRed_path = "Root/BottomBar/autoRally/autoRallyBtn/autoRallyRed"
local AllyScrollView = "Root/AllyScrollView"
local Title_path = "Root/TopBar/TextTitle"
local new_msg_btn_path = "Root/BottomBar/newMsgTip/newMsgBtn"
local LWAlWarItem_path = "Assets/Main/Prefabs/UI/Alliance/LWAlWarItem.prefab"
local manual_refresh_path = "Root/BottomBar/manualRefresh"
local manual_refresh_btn_path = "Root/BottomBar/manualRefresh/manualRefreshBtn"
local manual_refresh_red_path = "Root/BottomBar/manualRefresh/manualRefreshBtn/manualRefreshRed"
local manual_refresh_red_txt_path = "Root/BottomBar/manualRefresh/manualRefreshBtn/manualRefreshRed/manualRefreshRedTxt"
local manual_refresh_txt_path = "Root/BottomBar/manualRefresh/manualRefreshTxt"
local no_reminder_path = "Root/BottomBar/NoReminder"
local toggle_path = "Root/BottomBar/NoReminder/CloseAllToggle"
local checkmark_path = "Root/BottomBar/NoReminder/CloseAllToggle/Background/Checkmark"
local ring_bell_path = "Root/BottomBar/NoReminder/ringBell"
local fire_path = "Root/TabHolder/Tab/Toggle1/fire"
local eff_ui_alliancewar_unselect_path = "Root/TabHolder/Tab/Toggle1/fire/Eff_ui_alliancewar_unselect"
local eff_ui_alliancewar_select_path = "Root/TabHolder/Tab/Toggle1/fire/Eff_ui_alliancewar_select"

function UIAllianceWarMainTableView:OnCreate()
  base.OnCreate(self)
  SFSNetwork.SendMessage(MsgDefines.GetAllianceAutoJoinRallyInfo)
  self.type, self.arrowUuid, self.param = self:GetUserData()
  self.needMoveTo = self.arrowUuid and self.type == 2
  DataCenter.AllianceWarDataManager:SetAllAllianceWarOld()
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    EventManager:GetInstance():BroadcastDeferred(EventId.UpdateMainUIRallyTipRedPoint)
    self.ctrl:OnCloseClick()
  end)
  self._scrollView_personal = self:AddComponent(UIBaseContainer, scrollView_personal_path)
  self._personal_content = self:AddComponent(GridInfinityScrollView, content_personal_path)
  self._alliance_content = self:AddComponent(UIBaseContainer, content_alliance_path)
  self.contentBg = self:AddComponent(UIText, contentBg_path)
  self.contentTxt = self:AddComponent(UIText, contentTxt_path)
  self.OneKeyIgnore_txt = self:AddComponent(UIText, OneKeyIgnore_txt_path)
  self.OneKeyIgnore_btn = self:AddComponent(UIButton, OneKeyIgnore_btn_path)
  self.OneKeyIgnore_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnHideWarning()
  end)
  self.redPoint = {}
  self.toogle1 = self:AddComponent(UIToggle, toogle1_path)
  local warEvents = DataCenter.AllianceWarEventDataManager:GetWarEventsDict() or {}
  self.toogle1:SetActive(table.count(warEvents) > 0)
  if table.count(warEvents) > 0 then
    DataCenter.AllianceWarEventDataManager:PullWarEventData()
  end
  self.toogle1:SetOnValueChanged(function(tf)
    if tf then
      if not self.toogle1.selecting then
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_UI_General_Click_2nd, false)
      end
      self:ToggleControlBorS(1)
    end
    self.toogle1.selecting = false
  end)
  self.toogle1.choose = self.toogle1:AddComponent(UIBaseContainer, "Choose")
  self.toogle1.redPoint = self.toogle1:AddComponent(UIBaseContainer, "ImgWarn")
  self.toogle1.title = self.toogle1:AddComponent(UIText, "Txt")
  table.insert(self.redPoint, self.toogle1.redPoint)
  self.toogle2 = self:AddComponent(UIToggle, toogle2_path)
  self.toogle2:SetOnValueChanged(function(tf)
    if tf then
      if not self.toogle2.selecting then
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_UI_General_Click_2nd, false)
      end
      self:ToggleControlBorS(2)
    end
    self.toogle2.selecting = false
  end)
  self.toogle2.choose = self.toogle2:AddComponent(UIBaseContainer, "Choose")
  self.toogle2.redPoint = self.toogle2:AddComponent(UIBaseContainer, "ImgWarn")
  self.toogle2.title = self.toogle2:AddComponent(UIText, "Txt")
  table.insert(self.redPoint, self.toogle2.redPoint)
  self.toogle3 = self:AddComponent(UIToggle, toogle3_path)
  self.toogle3:SetOnValueChanged(function(tf)
    if tf then
      if not self.toogle3.selecting then
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_UI_General_Click_2nd, false)
      end
      self:ToggleControlBorS(3)
    end
    self.toogle3.selecting = false
  end)
  self.toogle3.choose = self.toogle3:AddComponent(UIBaseContainer, "Choose")
  self.toogle3.redPoint = self.toogle3:AddComponent(UIBaseContainer, "ImgWarn")
  self.toogle3.title = self.toogle3:AddComponent(UIText, "Txt")
  table.insert(self.redPoint, self.toogle3.redPoint)
  self.autoRallyN = self:AddComponent(UIBaseContainer, autoRally_path)
  self.autoRallyBtnN = self:AddComponent(UIButton, autoRallyBtn_path)
  self.autoRallyBtnN:SetOnClick(function()
    self:OnClickAutoRallyBtn()
  end)
  self.autoRallyNameN = self:AddComponent(UIText, autoRallyName_path)
  self.autoRallyNameN:SetLocalText(143565)
  self.autoRallyTimeN = self:AddComponent(UIText, autoRallyTime_path)
  self.autoRallyRedN = self:AddComponent(UIBaseContainer, autoRallyRed_path)
  self._allyView = self:AddComponent(AllyView, AllyScrollView)
  self._scrollView_ally = self:AddComponent(UIScrollRect, AllyScrollView)
  self._scrollView_ally:AddValueChangeListener(function(vec2)
    if math.abs(vec2.y) <= 0.1 then
      self:HideNewMsgBtn()
    end
  end)
  self.new_msg_btn = self:AddComponent(UIButton, new_msg_btn_path)
  self.new_msg_btn:SetOnClick(function()
    self:OnNewMsgClick()
  end)
  self.manualRefreshObj = self.transform:Find(manual_refresh_path).gameObject
  UIUtil.InitBtn(self, manual_refresh_btn_path, self.OnClickedManualRefresh)
  UIUtil.InitText(self, manual_refresh_txt_path, "new_arena_tips_25")
  self.manualRedCount = UIUtil.InitText(self, manual_refresh_red_txt_path)
  self.manualRefreshObj:SetActive(false)
  self.toogle1.title:SetLocalText("alliance_war_notice_UI_01")
  self.toogle2.title:SetLocalText(141024)
  self.toogle3.title:SetLocalText(455057)
  self.title = self:AddComponent(UIText, Title_path)
  self.title:SetLocalText(454134)
  self.cell = {}
  self.alCellPool = {}
  self._scrollView_alliance = self:AddComponent(UIScrollView, scrollView_alliance_path)
  self._scrollView_alliance:SetOnValueChanged(function(vec2)
    if math.abs(vec2.y) <= 0.1 then
      self:HideNewMsgBtn()
    end
  end)
  self._scrollView_alliance:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self._scrollView_alliance:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.expandItem = {}
  self.scrollViewSizePosY = -self._scrollView_alliance.rectTransform.rect.height
  self._scrollView_warEvent = self:AddComponent(UIScrollView, war_event_scroll_path)
  self._scrollView_warEvent:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateWarEventCell(itemObj, index)
  end)
  self._scrollView_warEvent:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteWarEventCell(itemObj, index)
  end)
  self.no_reminder = self:AddComponent(UITextMeshProUGUIEx, no_reminder_path)
  self.no_reminder:SetLocalText("alliance_war_notice_UI_13")
  self.checkmark = self:AddComponent(UIBaseComponent, checkmark_path)
  self.ring_bell = self:AddComponent(UIImage, ring_bell_path)
  self.toggle = self:AddComponent(UIButton, toggle_path)
  self.toggle:SetOnClick(function()
    self:OnClickCloseAllToggle()
  end)
  self.fire = self:AddComponent(UIBaseComponent, fire_path)
  self.fire:SetActive(DataCenter.AllianceWarEventDataManager:CheckHasReminder())
  self.eff_ui_alliancewar_unselect = self:AddComponent(UIBaseComponent, eff_ui_alliancewar_unselect_path)
  self.eff_ui_alliancewar_select = self:AddComponent(UIBaseComponent, eff_ui_alliancewar_select_path)
end

function UIAllianceWarMainTableView:OnDestroy()
  self:ClearWarEventScroll()
  self._scrollView_ally = nil
  self.new_msg_btn = nil
  self.close_btn = nil
  self.toogle1.redPoint = nil
  self.toogle1 = nil
  self.toogle2.redPoint = nil
  self.toogle2 = nil
  self.toogle3.redPoint = nil
  self.toogle3 = nil
  self.OneKeyIgnore_txt = nil
  self.OneKeyIgnore_btn = nil
  self.personalObj = nil
  self.manualRedCount = nil
  self:DelTimer()
  self:ClearScroll()
  self._personal_content:SetAnchoredPositionXY(self._personal_content:GetAnchoredPositionX(), 0)
  self._personal_content:Dispose()
  self:ClearAllCellAllianceItem()
  self.type = nil
  self.changedWar = nil
  self.changedWarCached = nil
  self.no_reminder = nil
  self.toggle = nil
  self.checkmark = nil
  self.ring_bell = nil
  base.OnDestroy(self)
end

function UIAllianceWarMainTableView:OnEnable()
  base.OnEnable(self)
  self:OnRefreshAfterEnable()
end

function UIAllianceWarMainTableView:OnRefreshAfterEnable()
  self.openTimeStamp = UITimeManager:GetInstance():GetServerTime()
  self.isList = false
  for i = 1, #self.redPoint do
    self.redPoint[i]:SetActive(false)
  end
  if self.type == 1 then
    self:ToggleControlBorS(1)
    return
  elseif self.type == 2 then
    self:ToggleControlBorS(2)
    return
  elseif self.type == 3 then
    self:ToggleControlBorS(3)
    return
  end
  local warEvents = DataCenter.AllianceWarEventDataManager:GetWarEventsDict() or {}
  if table.count(warEvents) > 0 then
    self:ToggleControlBorS(1)
    return
  end
  for i = 3, 2, -1 do
    if i == 3 and 0 < DataCenter.AllianceAlertDataManager:GetAlertNum() then
      self:ToggleControlBorS(i)
      return
    end
    local list = self.ctrl:GetAllianceWarIdList(i, self.arrowUuid, true)
    if 0 < #list then
      self.isList = true
      self:ToggleControlBorS(i)
      return
    end
  end
  if not self.isList then
    self:ToggleControlBorS(2)
    self.openTimeStamp = nil
  end
end

function UIAllianceWarMainTableView:OnDisable()
  base.OnDisable(self)
  self:ClearScroll()
  self.ctrl:ClearAllianceWarRecord()
end

function UIAllianceWarMainTableView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceWarUpdate, self.OnRefreshAlliance)
  self:AddUIListener(EventId.ALLIANCE_WAR_DELETE, self.OnRefreshAlliance)
  self:AddUIListener(EventId.MarchItemTargetMeUpdate, self.OnRefreshAlliance)
  self:AddUIListener(EventId.AllianceQuitOK, self.AllianceQuit)
  self:AddUIListener(EventId.NoticeMainViewUpdateMarch, self.OnRefreshAlliance)
  self:AddUIListener(EventId.UpdateAlertData, self.OnRefreshAlliance)
  self:AddUIListener(EventId.UpdateAllianceAutoRallyInfo, self.RefreshAutoRally)
  self:AddUIListener(EventId.UpdateAlertRedPoint, self.OnRefeshRedPoint)
  self:AddUIListener(EventId.AllianceWarEventReminderChange, self.OnReminderChange)
  self:AddUIListener(EventId.AllianceWarEventRefresh, self.OnWarEventRefresh)
end

function UIAllianceWarMainTableView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceWarUpdate, self.OnRefreshAlliance)
  self:RemoveUIListener(EventId.ALLIANCE_WAR_DELETE, self.OnRefreshAlliance)
  self:RemoveUIListener(EventId.MarchItemTargetMeUpdate, self.OnRefreshAlliance)
  self:RemoveUIListener(EventId.AllianceQuitOK, self.AllianceQuit)
  self:RemoveUIListener(EventId.NoticeMainViewUpdateMarch, self.OnRefreshAlliance)
  self:RemoveUIListener(EventId.UpdateAlertData, self.OnRefreshAlliance)
  self:RemoveUIListener(EventId.UpdateAllianceAutoRallyInfo, self.RefreshAutoRally)
  self:RemoveUIListener(EventId.UpdateAlertRedPoint, self.OnRefeshRedPoint)
  self:RemoveUIListener(EventId.AllianceWarEventReminderChange, self.OnReminderChange)
  self:RemoveUIListener(EventId.AllianceWarEventRefresh, self.OnWarEventRefresh)
end

function UIAllianceWarMainTableView:ClearScroll()
  self._scrollView_personal:RemoveComponents(UIPersonalWarning)
  self._personal_content:DestroyChildNode()
  self:ClearAllCellAllianceItem()
end

function UIAllianceWarMainTableView:AllianceQuit()
  self.ctrl:CloseSelf()
end

function UIAllianceWarMainTableView:OnWarEventRefresh()
  if self.toogle1:GetIsOn() then
    self:RefreshWarEventList()
  end
  self.fire:SetActive(DataCenter.AllianceWarEventDataManager:CheckHasReminder())
end

function UIAllianceWarMainTableView:OnRefreshAlliance(state)
  if self.toogle1:GetIsOn() then
  elseif self.toogle2:GetIsOn() then
    self:RefreshAllCellAllianceItem(false)
    self.OneKeyIgnore_txt:SetActive(false)
  elseif self.toogle3:GetIsOn() then
    self._allyView:SetActive(true)
    self._allyView:ReInit()
    self.OneKeyIgnore_txt:SetActive(false)
  end
end

function UIAllianceWarMainTableView:OnRefresh(index)
  self.listGOPersonal = {}
  self.listGOAlliance = {}
  self:CreateList(index)
end

function UIAllianceWarMainTableView:CreateList(index)
  self._scrollView_warEvent:SetActive(index == 1)
  self._scrollView_alliance:SetActive(index == 2)
  self._allyView:SetActive(index == 3)
  self.list = self.ctrl:GetAllianceWarIdList(index, self.arrowUuid, true)
  self:ShowEmptyLang(not next(self.list))
  self.personalObj = {}
  if self.list ~= nil then
    if index == 1 then
      self:RefreshWarEventList()
    elseif index == 2 then
      self:ShowAllianceWar()
    elseif index == 3 then
      self._allyView:ReInit()
    end
  end
end

function UIAllianceWarMainTableView:OnInitPersonScroll(go, index)
  local item = self._scrollView_personal:AddComponent(UIPersonalWarning, go)
  go.gameObject:SetActive(false)
  self.listGOPersonal[go] = item
end

function UIAllianceWarMainTableView:OnUpdatePersonScroll(go, index)
  local sub = self.list[index + 1]
  local cellItem = self.listGOPersonal[go]
  if sub == nil then
    go.gameObject:SetActive(false)
    return
  end
  cellItem:SetData(sub)
  cellItem:RefreshData()
  cellItem:SetBtnSeeState(true)
  go.gameObject:SetActive(true)
end

function UIAllianceWarMainTableView:OnDestroyPersonItem(go, index)
end

function UIAllianceWarMainTableView:ToggleControlBorS(index)
  self.toogle1.choose:SetActive(self.toogle1:GetIsOn())
  self.toogle2.choose:SetActive(self.toogle2:GetIsOn())
  self.toogle3.choose:SetActive(self.toogle3:GetIsOn())
  self.toogle1:SetIsOn(index == 1)
  self.toogle2:SetIsOn(index == 2)
  self.toogle3:SetIsOn(index == 3)
  self:OnRefresh(index)
  self.no_reminder:SetActive(index == 1)
  self.eff_ui_alliancewar_select:SetActive(index == 1)
  self.eff_ui_alliancewar_unselect:SetActive(index ~= 1)
  if self.toogle1:GetIsOn() then
    self.autoRallyN:SetActive(false)
    self.manualRefreshObj:SetActive(false)
    self:RefreshCloseAllToggle()
    self.contentTxt:SetLocalText(141028)
  elseif self.toogle2:GetIsOn() then
    self.contentTxt:SetLocalText(128028)
    self.autoRallyN:SetActive(false)
  elseif self.toogle3:GetIsOn() then
    self.contentTxt:SetLocalText(141028)
    self.autoRallyN:SetActive(false)
    self.manualRefreshObj:SetActive(false)
  end
end

function UIAllianceWarMainTableView:RefreshAutoRally()
  local autoInfo = DataCenter.AllianceBaseDataManager:GetAutoRallyInfo()
  if autoInfo and autoInfo.endTime then
    local serverTime = UITimeManager:GetInstance():GetServerTime()
    self.autoRallyEndTime = autoInfo.endTime
    if serverTime < autoInfo.endTime then
      self:AddTimer()
      self:SetRemainTime()
    else
      self:DelTimer()
      self:SetRemainTime()
    end
  end
  local redCount = DataCenter.AllianceBaseDataManager:CheckIfShowAutoRallyRed()
  self.autoRallyRedN:SetActive(redCount and 0 < redCount)
end

function UIAllianceWarMainTableView:AddTimer()
  function self.TimerAction()
    self:SetRemainTime()
  end
  
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.TimerAction, self, false, false, false)
  end
  self.timer:Start()
end

function UIAllianceWarMainTableView:SetRemainTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.autoRallyEndTime - curTime
  if 0 < remainTime then
    self.autoRallyTimeN:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self.autoRallyTimeN:SetText("")
    self:DelTimer()
  end
end

function UIAllianceWarMainTableView:DelTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function UIAllianceWarMainTableView:OnHideWarning()
  local list = self.ctrl:GetAllianceWarIdList(1, self.arrowUuid)
  if next(list) then
    for i = 1, #list do
      if type(list[i]) == "number" then
        DataCenter.AllianceWarDataManager:SetIgnoreList(list[i], 2)
      else
        DataCenter.RadarAlarmDataManager:AddToCancelList(list[i].uuid, true)
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.IgnoreTargetForMineMarch, false)
  for i, v in pairs(self.listGOPersonal) do
    self.listGOPersonal[i]:SetRelieve()
  end
  UIUtil.ShowTipsId(141026)
end

function UIAllianceWarMainTableView:OnClickAutoRallyBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceAutoJoinRally, {anim = true})
end

function UIAllianceWarMainTableView:ForceRebuildLayoutAlliance()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self._alliance_content.rectTransform)
end

function UIAllianceWarMainTableView:OnRefeshRedPoint()
  if self._scrollView_alliance:GetActive() == true then
    self.redPoint[3]:SetActive(DataCenter.AllianceAlertDataManager:GetAlertNum() > 0)
    if self.new_msg_btn:GetActive() == false then
      self.new_msg_btn:SetActive(0 < DataCenter.AllianceWarDataManager:GetAlertNum())
    end
    return
  end
  if self._allyView:GetActive() then
    self.redPoint[2]:SetActive(0 < DataCenter.AllianceWarDataManager:GetAlertNum())
    if self.new_msg_btn:GetActive() == false then
      self.new_msg_btn:SetActive(DataCenter.AllianceAlertDataManager:GetAlertNum() > 0)
    end
  end
end

function UIAllianceWarMainTableView:OnNewMsgClick()
  self.new_msg_btn:SetActive(false)
  if self._scrollView_alliance:GetActive() == true then
    self._scrollView_alliance:SetVerticalNormalizedPosition(0)
    return
  end
  if self._scrollView_warEvent:GetActive() == true then
    self._scrollView_warEvent:SetVerticalNormalizedPosition(0)
    return
  end
  if self._allyView:GetActive() then
    self._scrollView_ally:SetVerticalNormalizedPosition(0)
    return
  end
end

function UIAllianceWarMainTableView:HideNewMsgBtn()
  if self.new_msg_btn:GetActive() == true then
    self.new_msg_btn:SetActive(false)
  end
end

function UIAllianceWarMainTableView:RefreshWarEventList()
  self:ClearWarEventScroll()
  self.warEvents = self.ctrl:GetWarEventsList()
  local count = #self.warEvents or 0
  self._scrollView_warEvent:SetTotalCount(count)
  if 0 < count then
    self._scrollView_warEvent:RefillCells()
  end
end

function UIAllianceWarMainTableView:ShowAllianceWar()
  self:RefreshAllCellAllianceItem(true)
  local count = #self.id_list or 0
  self._scrollView_alliance:SetTotalCount(count)
  if 0 < count then
    if self.needMoveTo then
      self.needMoveTo = false
      if 3 < count then
        local index = table.indexof(self.id_list, self.arrowUuid)
        if index then
          index = index >= count - 2 and count - 2 or index
          self._scrollView_alliance:RefillCells(index, false)
          return
        end
      end
    end
    self._scrollView_alliance:RefillCells()
  end
end

function UIAllianceWarMainTableView:RefreshAllCellAllianceItem(force)
  local oldCount = self._scrollView_alliance.unity_scroll_view.totalCount
  self.id_list, self.changedWar = self.ctrl:GetAllianceWarIdList(2, self.arrowUuid, force)
  local newCount = #self.id_list or 0
  local moveIndex = -1
  local pre_Id_List = self:CaclInnerItem(oldCount < newCount)
  local flag = pre_Id_List and 0 < #pre_Id_List or false
  if flag then
    for i, v in ipairs(pre_Id_List) do
      local tIndex = table.indexof(self.id_list, v)
      if tIndex then
        moveIndex = tIndex
        break
      end
    end
  end
  if (#self.id_list or 0) ~= oldCount then
    local num = #self.id_list or 0
    self._scrollView_alliance:SetTotalCount(num)
    if moveIndex ~= -1 then
      self._scrollView_alliance:RefillCells(moveIndex, false)
    else
      self._scrollView_alliance:RefreshCells()
    end
  else
    self._scrollView_alliance:RefreshCells()
  end
  DataCenter.AllianceWarDataManager:UpdateLastReadTimeS()
  if self.changedWar and self.changedWar.count then
    self.manualRefreshObj:SetActive(true)
    self.manualRedCount:SetText(tostring(self.changedWar.count))
  else
    self.manualRefreshObj:SetActive(false)
  end
  self:ShowEmptyLang(#self.id_list <= 0)
end

local itemIndex = 1

function UIAllianceWarMainTableView:ShowEmptyLang(isShow)
  self.contentBg:SetActive(isShow)
  if isShow and self.openTimeStamp and self.param == "FromMainUI" and UITimeManager:GetInstance():GetServerTime() < self.openTimeStamp + 500 then
    UIUtil.ShowTipsId("world_tip10011")
    self.openTimeStamp = nil
  end
end

function UIAllianceWarMainTableView:ClearAllCellAllianceItem()
  self._scrollView_alliance:ClearCells()
  self._scrollView_alliance:RemoveComponents(LWAllianceWarItem)
  self.cells = {}
  self.alCellPool = {}
  itemIndex = 1
end

function UIAllianceWarMainTableView:OnCreateCell(itemObj, index)
  self.cells = self.cells or {}
  local cellItem = self.alCellPool[itemObj.name]
  if not cellItem then
    local name = tostring(itemIndex)
    itemObj.name = name
    cellItem = self._scrollView_alliance:AddComponent(LWAllianceWarItem, itemObj)
    self.alCellPool[name] = cellItem
    itemIndex = itemIndex + 1
  end
  local uuid = self.id_list[index]
  local isNew = self.changedWarCached and self.changedWarCached[uuid]
  cellItem:RefreshData({
    uuid = uuid,
    isNew = isNew,
    itemIndex = index
  })
  self.cells[index] = cellItem
end

function UIAllianceWarMainTableView:OnDeleteCell(itemObj, index)
  local cell = self.cells[index]
  if cell then
    cell:OnRecycle()
  end
  self.cells[index] = nil
end

function UIAllianceWarMainTableView:CaclInnerItem(addFlag)
  if self.cells == nil or self.id_list == nil or #self.id_list < 3 then
    return nil
  end
  local pos = self._alliance_content.rectTransform.anchoredPosition.y
  local offset = 0
  local result = {}
  local keys = {}
  for k, v in pairs(self.cells) do
    table.insert(keys, k)
  end
  table.sort(keys)
  for i, v in ipairs(keys) do
    local item = self.cells[v]
    if item.rectTransform then
      local y = item.rectTransform.sizeDelta.y
      local add = false
      if addFlag then
        local a = pos - y
        if a < 0 then
          table.insert(result, #result + 1, item.uuid)
          add = true
        end
      end
      offset = offset + y
      if not add and pos <= 0 then
        table.insert(result, #result + 1, item.uuid)
      end
      pos = pos - y
      if pos < self.scrollViewSizePosY then
        break
      end
    end
  end
  local msg = ""
  for i, v in ipairs(result) do
    msg = msg .. v
  end
  Logger.Log(msg)
  return result
end

function UIAllianceWarMainTableView:OnClickedManualRefresh()
  self.changedWarCached = self.changedWar
  self:ShowAllianceWar()
end

function UIAllianceWarMainTableView:ClearWarEventScroll()
  self._scrollView_warEvent:ClearCells()
  self._scrollView_warEvent:RemoveComponents(AllianceWarEventItem)
end

function UIAllianceWarMainTableView:OnCreateWarEventCell(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self._scrollView_warEvent:AddComponent(AllianceWarEventItem, itemObj)
  cellItem:SetData(self.warEvents[index])
  self.warEvents[index]:SetSeen()
end

function UIAllianceWarMainTableView:OnDeleteWarEventCell(itemObj, index)
  self._scrollView_warEvent:RemoveComponent(itemObj.name, AllianceWarEventItem)
end

function UIAllianceWarMainTableView:OnClickCloseAllToggle()
  if DataCenter.AllianceWarEventDataManager:CheckHasReminder() then
    for _, v in pairs(self.warEvents) do
      v:SetReminder(false)
    end
  else
    for _, v in pairs(self.warEvents) do
      v:SetReminder(true)
    end
  end
end

function UIAllianceWarMainTableView:RefreshCloseAllToggle()
  local hasRemind = DataCenter.AllianceWarEventDataManager:CheckHasReminder()
  self.checkmark:SetActive(not hasRemind)
  self.ring_bell:LoadSprite(hasRemind and "Assets/Main/Sprites/UI/UIAllianceWarEvent/mjc_lianmengzhanshi_icon_tixing1.png" or "Assets/Main/Sprites/UI/UIAllianceWarEvent/mjc_lianmengzhanshi_icon_tixing2.png")
end

function UIAllianceWarMainTableView:OnReminderChange()
  if self.toogle1:GetIsOn() then
    self:RefreshCloseAllToggle()
  end
  self.fire:SetActive(DataCenter.AllianceWarEventDataManager:CheckHasReminder())
end

return UIAllianceWarMainTableView
