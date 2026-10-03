local UILWSeasonMakeFriendsHistoryView = BaseClass("UILWSeasonMakeFriendsHistoryView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local HistoryItem = require("UI.LWSeason6.MakeFriends.UILWSeasonMakeFriendsHistory.Component.UILWSeasonMakeFriendsHistoryItem")
local InviteItem = require("UI.LWSeason6.MakeFriends.UILWSeasonMakeFriendsHistory.Component.UILWSeasonMakeFriendsHistoryInviteItem")
local panel_path = "panel"
local title_text_path = "safeArea/Common_img_title/titleText"
local close_btn_path = "safeArea/CloseBtn"
local middle_content_container_path = "safeArea/MiddleContentContainer"
local svTask_path = "safeArea/MiddleContentContainer/ScrollView"
local svTaskCont_path = "safeArea/MiddleContentContainer/ScrollView/Viewport/Content"
local loading_path = "safeArea/MiddleContentContainer/loading"
local tab1_path = "safeArea/MiddleContentContainer/TabLayout/Tab1"
local tab2_path = "safeArea/MiddleContentContainer/TabLayout/Tab2"
local tab3_path = "safeArea/MiddleContentContainer/TabLayout/Tab3"
local red_pot1_path = "safeArea/MiddleContentContainer/TabLayout/Tab1/RedPot1"
local red_pot2_path = "safeArea/MiddleContentContainer/TabLayout/Tab2/RedPot2"
local red_pot3_path = "safeArea/MiddleContentContainer/TabLayout/Tab3/RedPot3"
local op_user_txt_path = "safeArea/MiddleContentContainer/OpUserTxt"
local refuse_it_btn_path = "safeArea/MiddleContentContainer/RefuseItBtn"
local refuse_helper_path = "safeArea/MiddleContentContainer/RefuseItBtn/RefuseHelper"
local refuse_it_select_path = "safeArea/MiddleContentContainer/RefuseItBtn/RefuseHelper/RefuseItSelect"
local no_log_txt_path = "safeArea/empty/noLogTxt"

function UILWSeasonMakeFriendsHistoryView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.initMode = true
  DataCenter.SeasonAllyFriendManager:IsLogPublic(2, true)
  DataCenter.SeasonAllyFriendManager:IsLogPublic(3, true)
  if DataCenter.AllianceBaseDataManager:IsR4orR5() then
    self.op_user_txt:SetActive(true)
    self.refuse_it_btn:SetActive(true)
  else
    self.op_user_txt:SetActive(false)
    self.refuse_it_btn:SetActive(false)
  end
  self.tab1:SetOnValueChanged(function(t)
    if t then
      self:OnClickTab(1)
    end
  end)
  self.tab2:SetOnValueChanged(function(t)
    if t then
      self:OnClickTab(2)
    end
  end)
  self.tab3:SetOnValueChanged(function(t)
    if t then
      self:OnClickTab(3)
    end
  end)
  self.tab1:SetIsOn(true)
  if self.selectIndex == nil then
    self:OnClickTab(1)
  end
  self.initMode = false
end

function UILWSeasonMakeFriendsHistoryView:OnDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UILWSeasonMakeFriendsHistoryView:ComponentDefine()
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.middle_content_container = self:AddComponent(UIBaseContainer, middle_content_container_path)
  self.title_text:SetLocalText("s6_alliance_ally_btn03")
  self.svTaskN = self:AddComponent(UILoopListView2, svTask_path)
  self.svTaskCont = self:AddComponent(UIBaseContainer, svTaskCont_path)
  self.svTaskN:InitListView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
  self.tab1 = self:AddComponent(UIToggle, tab1_path)
  self.tab2 = self:AddComponent(UIToggle, tab2_path)
  self.tab3 = self:AddComponent(UIToggle, tab3_path)
  self.red_pot1 = self:AddComponent(UIImage, red_pot1_path)
  self.red_pot2 = self:AddComponent(UIImage, red_pot2_path)
  self.red_pot3 = self:AddComponent(UIImage, red_pot3_path)
  self.no_log_txt = self:AddComponent(UIText, no_log_txt_path)
  self.no_log_txt:SetLocalText(372266)
  self.no_log_txt:SetActive(false)
  self.loading = self:AddComponent(UIImage, loading_path)
  self.loading:SetActive(true)
  self.refuse_helper = self:AddComponent(UITextMeshProUGUIEx, refuse_helper_path)
  self.refuse_it_btn = self:AddComponent(UIButton, refuse_it_btn_path)
  self.op_user_txt = self:AddComponent(UITextMeshProUGUIEx, op_user_txt_path)
  self.refuse_it_btn:SetOnClick(function()
    self.refuse_it_select:SetIsOn(not self.isLogPublic)
  end)
  self.refuse_it_select = self:AddComponent(UIToggle, refuse_it_select_path)
  self.refuse_it_select:SetOnValueChanged(function(value)
    if self.isLogPublic ~= value then
      SFSNetwork.SendMessage(MsgDefines.SetAllianceAllyLogPermission, self.selectIndex, value and 1 or 0)
    end
  end)
end

function UILWSeasonMakeFriendsHistoryView:ComponentDestroy()
  self.title_text = nil
  self.close_btn = nil
  self.middle_content_container = nil
  self.taskCellList = nil
  self.loading = nil
  self.svTaskN = nil
  self.svTaskCont = nil
  self.no_log_txt = nil
  self.tab1 = nil
  self.tab2 = nil
  self.tab3 = nil
  self.red_pot1 = nil
  self.red_pot2 = nil
  self.red_pot3 = nil
  self.refuse_helper = nil
  self.refuse_it_btn = nil
  self.op_user_txt = nil
  self.refuse_it_select = nil
end

function UILWSeasonMakeFriendsHistoryView:DataDefine()
  self.logList = {}
  self.selectIndex = nil
end

function UILWSeasonMakeFriendsHistoryView:DataDestroy()
  self.logList = nil
  self.selectIndex = nil
end

function UILWSeasonMakeFriendsHistoryView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MFAllyLogUpdate, self.RefreshAll)
  self:AddUIListener(EventId.MFAllyLogPermissionUpdate, self.OnLogPermissionUpdate)
end

function UILWSeasonMakeFriendsHistoryView:OnRemoveListener()
  self:RemoveUIListener(EventId.MFAllyLogUpdate, self.RefreshAll)
  self:RemoveUIListener(EventId.MFAllyLogPermissionUpdate, self.OnLogPermissionUpdate)
  base.OnRemoveListener(self)
end

function UILWSeasonMakeFriendsHistoryView:OnLogPermissionUpdate()
  self.isLogPublic = DataCenter.SeasonAllyFriendManager:IsLogPublic(self.selectIndex, false)
  if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
    return
  end
  if self.selectIndex == 1 then
    self.refuse_it_btn:SetActive(false)
    self.op_user_txt:SetActive(false)
  elseif self.selectIndex == 2 or self.selectIndex == 3 then
    local data = DataCenter.SeasonAllyFriendManager:GetAllyLogPermission(self.selectIndex)
    self.refuse_it_btn:SetActive(true)
    self.refuse_it_select:SetIsOn(self.isLogPublic)
    if data and data.lastLogOpUser and data.lastLogOpUser.uid ~= nil and data.lastLogOpUser.uid ~= "" then
      self.op_user_txt:SetActive(true)
      local strTime = UITimeManager:GetInstance():GetServerTimeByUTC(data.lastLogOpTime, false)
      if data.logPublic == 1 then
        local strInfo = Localization:GetString("s6_alliance_ally_desc50", data.lastLogOpUser.name)
        self.op_user_txt:SetText(strTime .. " " .. strInfo)
      else
        local strInfo = Localization:GetString("s6_alliance_ally_desc51", data.lastLogOpUser.name)
        self.op_user_txt:SetText(strTime .. " " .. strInfo)
      end
    else
      self.op_user_txt:SetActive(false)
    end
  end
end

function UILWSeasonMakeFriendsHistoryView:OnClickTab(index)
  SFSNetwork.SendMessage(MsgDefines.FetchAllianceAllyLogList, 1, index, 1, 3)
  self.selectIndex = index
  self:ClearScroll()
  self:RefreshAll()
  self.skipRefresh = true
  EventManager:GetInstance():Broadcast(EventId.MFAllyLogUpdate)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.refuse_helper.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.middle_content_container.rectTransform)
  self.skipRefresh = false
end

function UILWSeasonMakeFriendsHistoryView:RefreshRedPoint()
  local mgr = DataCenter.SeasonAllyFriendManager
  self.red_pot1:SetActive(self.selectIndex ~= 1 and mgr:GetNewLogCount(1) > 0)
  self.red_pot2:SetActive(self.selectIndex ~= 2 and 0 < mgr:GetNewLogCount(2))
  self.red_pot3:SetActive(self.selectIndex ~= 3 and 0 < mgr:GetNewLogCount(3))
end

function UILWSeasonMakeFriendsHistoryView:RefreshAll()
  if self.skipRefresh == true then
    return
  end
  self:RefreshRedPoint()
  self:OnLogPermissionUpdate()
  if self.selectIndex == nil then
    self.loading:SetActive(true)
    self.no_log_txt:SetActive(false)
    return
  end
  local data = DataCenter.SeasonAllyFriendManager:GetOpLog(self.selectIndex)
  if self.initMode and data == nil then
    self.loading:SetActive(true)
    self.no_log_txt:SetActive(false)
    self.op_user_txt:SetActive(false)
    self.refuse_it_btn:SetActive(false)
    return
  end
  self.logList = data and data.dataList or nil
  self.loading:SetActive(false)
  if self.logList and #self.logList > 0 then
    self.no_log_txt:SetActive(false)
    self.svTaskN:SetListItemCount(#self.logList, self.initMode, false)
    self.svTaskN:RefreshAllShownItem()
  else
    self.no_log_txt:SetLocalText("avatar_tips004")
    self.no_log_txt:SetActive(true)
    self.op_user_txt:SetActive(false)
    self.refuse_it_btn:SetActive(false)
  end
end

function UILWSeasonMakeFriendsHistoryView:ClearScroll()
  self.svTaskCont:RemoveComponents(HistoryItem)
  self.svTaskCont:RemoveComponents(InviteItem)
  self.svTaskN:ClearAllItems()
  self.logList = nil
end

function UILWSeasonMakeFriendsHistoryView:GetScrollItem(listView, index)
  local count = table.count(self.logList)
  index = index + 1
  if index < 1 or count < index then
    return nil
  end
  local logData = self.logList[index]
  if logData == nil then
    return nil
  end
  if self.selectIndex == 1 and toInt(logData.subType) < 200 then
    local item = listView:NewListViewItem("LogItem")
    local script = self.svTaskCont:GetComponent(item.gameObject.name, HistoryItem)
    if script == nil then
      local objectName = UIUtil.GetLoopListItemIndex()
      item.gameObject.name = objectName
      script = self.svTaskCont:AddComponent(HistoryItem, objectName)
    end
    script:SetActive(true)
    script:ReInit(self.selectIndex, index, logData)
    return item
  elseif (self.selectIndex == 2 or self.selectIndex == 3) and toInt(logData.subType) >= 200 then
    local item = listView:NewListViewItem("InviteItem")
    local script = self.svTaskCont:GetComponent(item.gameObject.name, InviteItem)
    if script == nil then
      local objectName = UIUtil.GetLoopListItemIndex()
      item.gameObject.name = objectName
      script = self.svTaskCont:AddComponent(InviteItem, objectName)
    end
    script:SetActive(true)
    script:ReInit(self.selectIndex, index, logData)
    return item
  end
  return nil
end

return UILWSeasonMakeFriendsHistoryView
