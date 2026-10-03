local UILWSeasonMakeFriendsSearchAllianceView = BaseClass("UILWSeasonMakeFriendsSearchAllianceView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local SearchAllianceItem = require("UI.LWSeason6.MakeFriends.UILWSeasonMakeFriendsSearchAlliance.Component.UILWSeasonMakeFriendsSearchAllianceItem")
local SearchChoose = require("UI.LWSeason6.MakeFriends.UILWSeasonMakeFriendsSearchAlliance.Component.UILWSeasonMakeFriendsSearchChoose")
local LWSeasonHorseMessage = require("UI.LWSeasonShared.Component.LWSeasonHorseMessage")
local text_title_path = "Root/TopBar/TextTitle"
local btn_back_path = "Root/BottomBar/BtnBack"
local select_mode_path = "Root/SelectMode"
local scroll_view1_path = "Root/ScrollView1"
local scroll_view2_path = "Root/ScrollView2"
local tab_path = "Root/TopBar/Tab"
local tab_item1_path = "Root/TopBar/Tab/TabItem1"
local tab_item2_path = "Root/TopBar/Tab/TabItem2"
local tab2_path = "Root/TopBar/Tab2"
local toggle1_path = "Root/TopBar/Tab2/toggle1"
local toggle2_path = "Root/TopBar/Tab2/toggle2"
local red_point1_path = "Root/TopBar/Tab2/RedPoint1"
local red_point2_path = "Root/TopBar/Tab2/RedPoint2"
local tips_text_path = "Root/TipsText"
local tips_cd_path = "Root/TipsCD"
local cd_icon_btn_path = "Root/TipsCD/cdIconBtn"
local empty_path = "Root/Empty"
local p_btn_help1_path = "Root/TopBar/p_btn_help1"
local red_point_root_path = "Root/TopBar/Tab/TabItem2/RedPointNum"
local red_point_text_path = "Root/TopBar/Tab/TabItem2/RedPointNum/Text"
local horse_root_path = "Root/Bg/HorseRoot"

function UILWSeasonMakeFriendsSearchAllianceView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.tabIndexShown = 0
  self.filterServerId = 0
  self.filterFactionType = 0
  self.activeServerId1 = nil
  self.activeFactionType1 = nil
  self.activeServerId2 = nil
  self.activeFactionType2 = nil
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(self.scroll_view, itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(self.scroll_view, itemObj, index)
  end)
  self.scroll_view_send:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(self.scroll_view_send, itemObj, index)
  end)
  self.scroll_view_send:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(self.scroll_view_send, itemObj, index)
  end)
  self.activeServerId = LuaEntry.Player:GetSourceServerId()
  self.tab_item1:SetIsOn(true)
  self.toggle1:SetIsOn(true)
  self:SwitchTab(1)
end

function UILWSeasonMakeFriendsSearchAllianceView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonMakeFriendsSearchAllianceView:OnEnable()
  base.OnEnable(self)
  SFSNetwork.SendMessage(MsgDefines.FetchAllianceAllyCombinedList)
  SFSNetwork.SendMessage(MsgDefines.FetchAllianceAllyRecordList)
end

function UILWSeasonMakeFriendsSearchAllianceView:OnDisable()
  base.OnDisable(self)
end

function UILWSeasonMakeFriendsSearchAllianceView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MFAllyMessageUpdate, self.OnAllyNoticeMessage)
  self:AddUIListener(EventId.MFAllyCombinedListUpdate, self.UpdateData)
end

function UILWSeasonMakeFriendsSearchAllianceView:OnRemoveListener()
  self:RemoveUIListener(EventId.MFAllyMessageUpdate, self.OnAllyNoticeMessage)
  self:RemoveUIListener(EventId.MFAllyCombinedListUpdate, self.UpdateData)
  base.OnRemoveListener(self)
end

function UILWSeasonMakeFriendsSearchAllianceView:ComponentDefine()
  self.text_title = self:AddComponent(UITextMeshProUGUIEx, text_title_path)
  self.text_title:SetLocalText("s6_alliance_ally_btn02")
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.select_mode = self:AddComponent(SearchChoose, select_mode_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view1_path)
  self.scroll_view_send = self:AddComponent(UIScrollView, scroll_view2_path)
  self.empty = self:AddComponent(UITextMeshProUGUIEx, empty_path)
  self.red_point_root = self:AddComponent(UIBaseContainer, red_point_root_path)
  self.red_point_text = self:AddComponent(UITextMeshProUGUIEx, red_point_text_path)
  self.horse_root = self:AddComponent(LWSeasonHorseMessage, horse_root_path)
  self.p_btn_help1 = self:AddComponent(UIButton, p_btn_help1_path)
  self.p_btn_help1:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, {
      howToPlayList = {600001}
    })
  end)
  self.tips_text = self:AddComponent(UITextMeshProUGUIEx, tips_text_path)
  self.tips_cd = self:AddComponent(UITextMeshProUGUIEx, tips_cd_path)
  self.cd_icon_btn = self:AddComponent(UIButton, cd_icon_btn_path)
  self.cd_icon_btn:SetOnClick(function()
    local now = UITimeManager:GetInstance():GetServerTime()
    if self.countDownTimeStr and self.cd ~= nil and now < self.cd then
      local msg = Localization:GetString("s6_alliance_ally_tips04", self.countDownTimeStr)
      UIUtil.ShowTips(msg, 3, nil, nil, false, 400)
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonMakeFriendsDetailCD)
  end)
  self.tips_text:SetLocalText("s6_alliance_ally_desc24")
  self.tab1 = self:AddComponent(UIBaseContainer, tab_path)
  self.tab_item1 = self:AddComponent(UIToggle, tab_item1_path)
  self.tab_item2 = self:AddComponent(UIToggle, tab_item2_path)
  self.tab_item1:SetOnValueChanged(function(tf)
    if tf then
      self:SwitchTab(1)
    end
  end)
  self.tab_item2:SetOnValueChanged(function(tf)
    if tf then
      self:SwitchTab(2)
    end
  end)
  self.tab2 = self:AddComponent(UIImage, tab2_path)
  self.toggle1 = self:AddComponent(UIToggle, toggle1_path)
  self.toggle2 = self:AddComponent(UIToggle, toggle2_path)
  self.red_point1 = self:AddComponent(UIImage, red_point1_path)
  self.red_point2 = self:AddComponent(UIImage, red_point2_path)
  self.toggle1:SetOnValueChanged(function(tf)
    if tf then
      self:SwitchTab(1)
    end
  end)
  self.toggle2:SetOnValueChanged(function(tf)
    if tf then
      self:SwitchTab(2)
      self.red_point_root:SetActive(false)
    end
  end)
  self.tab1:SetActive(true)
  self.tab2:SetActive(false)
  self:UpdateRedNum()
end

function UILWSeasonMakeFriendsSearchAllianceView:ComponentDestroy()
  self:ClearScroll()
  self.btn_back = nil
  self.text_title = nil
  self.select_mode = nil
  self.scroll_view = nil
  self.horse_root = nil
  self.empty = nil
  self.p_btn_help1 = nil
  self.red_point_root = nil
  self.red_point_text = nil
  self.tips_text = nil
  self.tips_cd = nil
  self.cd_icon_btn = nil
  self.tab1 = nil
  self.tab_item1 = nil
  self.tab_item2 = nil
  self.tab2 = nil
  self.toggle1 = nil
  self.toggle2 = nil
  self.red_point1 = nil
  self.red_point2 = nil
end

function UILWSeasonMakeFriendsSearchAllianceView:UpdateRedNum()
  if self.red_point_root then
    local allyCombinedList = DataCenter.SeasonAllyFriendManager:GetAllyCombinedList()
    if allyCombinedList == nil then
      self.red_point_root:SetActive(false)
    else
      local dataCount = table.count(allyCombinedList.recList)
      if dataCount == 0 then
        self.red_point_root:SetActive(false)
      else
        self.red_point_root:SetActive(true)
        self.red_point_text:SetText(tostring(dataCount))
      end
    end
  end
end

function UILWSeasonMakeFriendsSearchAllianceView:OnItemMoveIn(scroll_view, itemObj, index)
  itemObj.name = tostring(index)
  local item = scroll_view:AddComponent(SearchAllianceItem, itemObj)
  if item then
    local data = self.dataList[index]
    item:SetData(self.tabIndex, index, data)
  end
end

function UILWSeasonMakeFriendsSearchAllianceView:OnItemMoveOut(scroll_view, itemObj, index)
  scroll_view:RemoveComponent(itemObj.name, SearchAllianceItem)
end

function UILWSeasonMakeFriendsSearchAllianceView:ClearScroll()
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(SearchAllianceItem)
  self.scroll_view_send:ClearCells()
  self.scroll_view_send:RemoveComponents(SearchAllianceItem)
end

function UILWSeasonMakeFriendsSearchAllianceView:OnAllyNoticeMessage(dataList)
  if dataList == nil or #dataList == 0 then
    return
  end
  if self.horse_root then
    local msgList = {}
    for _, dataShow in ipairs(dataList) do
      if dataShow and dataShow.allianceInfo1 and dataShow.allianceInfo2 then
        local msg
        local name1 = UIUtil.FormatAllianceAndName(dataShow.allianceInfo1.abbr)
        local name2 = UIUtil.FormatAllianceAndName(dataShow.allianceInfo2.abbr)
        if dataShow.allianceInfo1.camp == 1 then
          msg = Localization:GetString("s6_alliance_ally_tips8", name1, name2)
        elseif dataShow.allianceInfo1.camp == 2 then
          msg = Localization:GetString("s6_alliance_ally_tips9", name1, name2)
        end
        if msg then
          table.insert(msgList, msg)
        end
      end
    end
    if 0 < #msgList then
      self.horse_root:SetMessageList(msgList)
    end
  end
end

function UILWSeasonMakeFriendsSearchAllianceView:Update1000MS()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.cd ~= nil and curTime < self.cd then
    local leftTime = self.cd - curTime
    if leftTime < 0 then
      self.cd = nil
      self.tips_cd:SetLocalText("s6_alliance_ally_desc10")
      return
    end
    local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
    self.tips_cd:SetLocalText("s6_alliance_ally_desc09", countDownTimeStr)
    self.countDownTimeStr = countDownTimeStr
  else
    self.countDownTimeStr = nil
    self.tips_cd:SetLocalText("s6_alliance_ally_desc10")
  end
end

function UILWSeasonMakeFriendsSearchAllianceView:SwitchTab(tabIndex)
  if self.tabIndex == tabIndex or tabIndex ~= 1 and tabIndex ~= 2 then
    return
  end
  self.tabIndex = tabIndex
  self.inSwitch = true
  if self.tabIndex == 1 then
    self.select_mode:SetSelectIndex(self.activeServerId1, self.activeFactionType1)
  else
    self.select_mode:SetSelectIndex(self.activeServerId2, self.activeFactionType2)
  end
  self.inSwitch = false
  self:UpdateData(true)
end

function UILWSeasonMakeFriendsSearchAllianceView:RefreshUI(serverId, factionType)
  if self.tabIndex ~= 1 and self.tabIndex ~= 2 then
    return
  end
  if self.tabIndex == 1 then
    self.activeServerId1 = serverId
    self.activeFactionType1 = factionType
  else
    self.activeServerId2 = serverId
    self.activeFactionType2 = factionType
  end
  self:UpdateData(true)
end

function UILWSeasonMakeFriendsSearchAllianceView:CheckDataByFilter(filterServerId, filterFactionType)
  local allyCombinedList = DataCenter.SeasonAllyFriendManager:GetAllyCombinedList()
  local dataList = {}
  if allyCombinedList ~= nil then
    local all_data
    if self.tabIndex == 1 and allyCombinedList.sendList ~= nil then
      all_data = allyCombinedList.sendList
    elseif self.tabIndex == 2 and allyCombinedList.recList ~= nil then
      all_data = allyCombinedList.recList
    end
    if all_data then
      if filterServerId then
        for _, v in ipairs(all_data) do
          if v.serverId == filterServerId then
            table.insert(dataList, v)
          end
        end
      elseif filterFactionType then
        local factionMgr = DataCenter.SeasonFactionWarDataManager
        for _, v in ipairs(all_data) do
          if filterFactionType == factionMgr:GetCampIdByServerId(v.serverId) then
            table.insert(dataList, v)
          end
        end
      else
        for _, v in ipairs(all_data) do
          table.insert(dataList, v)
        end
      end
    end
  end
  return dataList
end

function UILWSeasonMakeFriendsSearchAllianceView:UpdateData(fromUser)
  self.cd = DataCenter.SeasonAllyFriendManager:GetAllyCooldownEndTime()
  if self.inSwitch then
    return
  end
  if self.tabIndex == 1 then
    if fromUser and self.tabIndexShown == self.tabIndex and self.filterServerId == self.activeServerId1 and self.filterFactionType == self.activeFactionType1 then
      return
    end
    self.tips_text:SetLocalText("s6_alliance_ally_desc07")
    self.scroll_view:SetVerticalNormalizedPosition(1)
    self.select_mode:SetActive(true)
    self.scroll_view_send:SetActive(false)
    self.scroll_view:ClearCells()
    self.scroll_view:RemoveComponents(SearchAllianceItem)
    self.filterServerId = self.activeServerId1
    self.filterFactionType = self.activeFactionType1
    self.dataList = self:CheckDataByFilter(self.filterServerId, self.filterFactionType)
    local count = #self.dataList
    if 0 < count then
      table.sort(self.dataList, function(a, b)
        if a.applyBaseInfo == nil and b.applyBaseInfo == nil then
          return a.power > b.power
        end
        if a.applyBaseInfo ~= nil and b.applyBaseInfo == nil then
          return true
        end
        if a.applyBaseInfo == nil and b.applyBaseInfo ~= nil then
          return false
        end
        return a.applyBaseInfo.expireTime > b.applyBaseInfo.expireTime
      end)
      self.empty:SetActive(false)
      self.scroll_view:SetActive(true)
      self.scroll_view:SetTotalCount(count)
      self.scroll_view:RefillCells()
    else
      self.scroll_view:SetActive(false)
      self.empty:SetActive(true)
      self.empty:SetLocalText("390167")
    end
  elseif self.tabIndex == 2 then
    if fromUser and self.tabIndexShown == self.tabIndex and self.filterServerId == self.activeServerId2 and self.filterFactionType == self.activeFactionType2 then
      return
    end
    self.tips_cd:SetLocalText("s6_alliance_ally_desc10")
    self.tips_text:SetLocalText("s6_alliance_ally_desc28")
    self.scroll_view_send:SetVerticalNormalizedPosition(1)
    self.scroll_view:SetActive(false)
    self.select_mode:SetActive(true)
    self.scroll_view_send:ClearCells()
    self.scroll_view_send:RemoveComponents(SearchAllianceItem)
    self.dataList = {}
    self.filterServerId = self.activeServerId2
    self.filterFactionType = self.activeFactionType2
    self.dataList = self:CheckDataByFilter(self.filterServerId, self.filterFactionType)
    local count = #self.dataList
    if 0 < count then
      table.sort(self.dataList, function(a, b)
        return a.applyBaseInfo.expireTime > b.applyBaseInfo.expireTime
      end)
      self.empty:SetActive(false)
      self.scroll_view_send:SetActive(true)
      self.scroll_view_send:SetTotalCount(count)
      self.scroll_view_send:RefillCells()
      self.red_point_root:SetActive(false)
    else
      self.scroll_view_send:SetActive(false)
      self.empty:SetActive(true)
      self.empty:SetLocalText("390154")
      self.red_point_root:SetActive(false)
    end
  end
  self.tabIndexShown = self.tabIndex
  self:Update1000MS()
  self:UpdateRedNum()
end

return UILWSeasonMakeFriendsSearchAllianceView
