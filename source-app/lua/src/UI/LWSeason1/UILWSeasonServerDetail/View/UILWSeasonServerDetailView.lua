local UILWSeasonServerDetailView = BaseClass("UILWSeasonServerDetailView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local DetailItemAlliance = require("UI.LWSeason1.UILWSeasonServerDetail.Component.UILWSeasonServerDetailItemAlliance")
local DetailItemBuild = require("UI.LWSeason1.UILWSeasonServerDetail.Component.UILWSeasonServerDetailItemBuild")
local UIServerBattleZoneInfo = require("UI.UIGovernment.ServerBattleMain.Component.UIServerBattleZoneInfo")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local title1_path = "PopUpTitle/TopBar/Info1/title1"
local info_btn1_path = "PopUpTitle/TopBar/Info1/InfoBtn1"
local value1_path = "PopUpTitle/TopBar/Info1/bg/Value1"
local rank_text1_path = "PopUpTitle/TopBar/Info1/bg/RankText1"
local title2_path = "PopUpTitle/TopBar/Info2/title2"
local info_btn2_path = "PopUpTitle/TopBar/Info2/InfoBtn2"
local value2_path = "PopUpTitle/TopBar/Info2/bg/Value2"
local rank_text2_path = "PopUpTitle/TopBar/Info2/bg/RankText2"
local title3_path = "PopUpTitle/TopBar/Info3/title3"
local value3_path = "PopUpTitle/TopBar/Info3/bg/Value3"
local rank_text3_path = "PopUpTitle/TopBar/Info3/bg/RankText3"
local title4_path = "PopUpTitle/TopBar/Info4/title4"
local value4_path = "PopUpTitle/TopBar/Info4/bg/Value4"
local rank_text4_path = "PopUpTitle/TopBar/Info4/bg/RankText4"
local btn_go_path = "PopUpTitle/Root/BtnGo"
local go_text_path = "PopUpTitle/Root/BtnGo/GoText"
local zone_item_up_path = "PopUpTitle/TopBar/ZoneItemUp"
local toggle1_path = "PopUpTitle/Root/Tab/toggle1"
local toggle2_path = "PopUpTitle/Root/Tab/toggle2"
local scroll_view_path = "PopUpTitle/Root/ScrollView"
local content_path = "PopUpTitle/Root/ScrollView/Viewport/Content"
local no_data_path = "PopUpTitle/Root/ScrollView/noData"

function UILWSeasonServerDetailView:OnCreate()
  base.OnCreate(self)
  local jumpParam = self:GetUserData()
  self.isViewMode = jumpParam.viewMode
  self.jumpTo = jumpParam.pos
  self.pointId = jumpParam.pointId
  self.serverId = toInt(jumpParam.serverId)
  self.putMode = jumpParam.putMode
  self.buildId = jumpParam.buildId
  if self.serverId > 0 then
    SFSNetwork.SendMessage(MsgDefines.FetchServerInfo, self.serverId)
    SFSNetwork.SendMessage(MsgDefines.GetCrossServerKingInfo, tostring(self.serverId))
  end
  self:ComponentDefine()
  self:UpdateData()
end

function UILWSeasonServerDetailView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonServerDetailView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonUpdateServerDetail, self.UpdateData)
  self:AddUIListener(EventId.OnGetServerKingData, self.OnGetServerKingData)
end

function UILWSeasonServerDetailView:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonUpdateServerDetail, self.UpdateData)
  self:RemoveUIListener(EventId.OnGetServerKingData, self.OnGetServerKingData)
  base.OnRemoveListener(self)
end

function UILWSeasonServerDetailView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UITextMeshProUGUIEx, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.dialog_title_text:SetLocalText("s1_zone_info01")
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.btn_go = self:AddComponent(UIButton, btn_go_path)
  self.btn_text = self:AddComponent(UITextMeshProUGUIEx, go_text_path)
  self.zoneItem = self:AddComponent(UIServerBattleZoneInfo, zone_item_up_path)
  self.btn_go:SetOnClick(function()
    self:OnClickGo()
  end)
  self.no_data = self:AddComponent(UITextMeshProUGUIEx, no_data_path)
  self.title1 = self:AddComponent(UITextMeshProUGUIEx, title1_path)
  self.info_btn1 = self:AddComponent(UIButton, info_btn1_path)
  self.value1 = self:AddComponent(UITextMeshProUGUIEx, value1_path)
  self.rank_text1 = self:AddComponent(UITextMeshProUGUIEx, rank_text1_path)
  self.title2 = self:AddComponent(UITextMeshProUGUIEx, title2_path)
  self.info_btn2 = self:AddComponent(UIButton, info_btn2_path)
  self.value2 = self:AddComponent(UITextMeshProUGUIEx, value2_path)
  self.rank_text2 = self:AddComponent(UITextMeshProUGUIEx, rank_text2_path)
  self.title3 = self:AddComponent(UITextMeshProUGUIEx, title3_path)
  self.value3 = self:AddComponent(UITextMeshProUGUIEx, value3_path)
  self.rank_text3 = self:AddComponent(UITextMeshProUGUIEx, rank_text3_path)
  self.title4 = self:AddComponent(UITextMeshProUGUIEx, title4_path)
  self.value4 = self:AddComponent(UITextMeshProUGUIEx, value4_path)
  self.rank_text4 = self:AddComponent(UITextMeshProUGUIEx, rank_text4_path)
  self.items = {}
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.ScrollView = self:AddComponent(UILoopListView2, scroll_view_path)
  self.ScrollView:InitListView(0, function(listview, index)
    return self:TryGetScrollItem(listview, index)
  end)
  self.toggle1 = self:AddComponent(UIToggle, toggle1_path)
  self.toggle2 = self:AddComponent(UIToggle, toggle2_path)
  self.toggle1:SetIsOn(true)
  self.toggle1:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabChanged(1)
    end
  end)
  self.toggle2:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabChanged(2)
    end
  end)
  self.info_btn1:SetOnClick(function()
    UIUtil.ShowButtonTips(self.info_btn1, nil, "s1_zone_info_ui05", false)
  end)
  self.info_btn2:SetOnClick(function()
    UIUtil.ShowButtonTips(self.info_btn2, nil, "s1_zone_info_ui06", false)
  end)
end

function UILWSeasonServerDetailView:OnTabChanged(tabIndex)
  local dataCount = 0
  local serverData = DataCenter.SeasonDataManager:GetServerDetail(self.serverId)
  self.activeTabIndex = tabIndex
  if serverData then
    if tabIndex == 1 then
      self.dataList = serverData.otherZoneFortressInfo
    else
      self.dataList = serverData.selfZoneInfo
    end
    dataCount = table.count(self.dataList)
  end
  if 0 < dataCount then
    self.no_data:SetActive(false)
    self.ScrollView:SetListItemCount(dataCount, true, false)
    self.ScrollView:RefreshAllShownItem()
  else
    self.content:RemoveComponents(DetailItemBuild)
    self.content:RemoveComponents(DetailItemAlliance)
    self.ScrollView:ClearAllItems()
    self.no_data:SetActive(true)
    if self.activeTabIndex == 1 then
      self.no_data:SetLocalText("s1_zone_info_ui09")
    else
      self.no_data:SetLocalText("avatar_tips004")
    end
  end
end

function UILWSeasonServerDetailView:ComponentDestroy()
  self.items = {}
  self.content:RemoveComponents(DetailItemBuild)
  self.content:RemoveComponents(DetailItemAlliance)
  self.ScrollView:ClearAllItems()
  self.no_data = nil
  self.btn_back = nil
  self.btn_go = nil
  self.btn_text = nil
  self.zoneItem = nil
  self.title1 = nil
  self.info_btn1 = nil
  self.value1 = nil
  self.rank_text1 = nil
  self.title2 = nil
  self.info_btn2 = nil
  self.value2 = nil
  self.rank_text2 = nil
  self.title3 = nil
  self.value3 = nil
  self.rank_text3 = nil
  self.title4 = nil
  self.value4 = nil
  self.rank_text4 = nil
  self.toggle1 = nil
  self.toggle2 = nil
  self.ScrollView = nil
  self.content = nil
end

function UILWSeasonServerDetailView:TryGetScrollItem(listview, index)
  local dataList = self.dataList
  if dataList == nil or #dataList <= 0 then
    return nil
  end
  index = index + 1
  if index < 1 or index > #dataList then
    return nil
  end
  local csItem
  local data = dataList[index]
  local theScript
  if self.activeTabIndex == 1 then
    csItem = listview:NewListViewItem("AttackItem")
    theScript = DetailItemBuild
  elseif self.activeTabIndex == 2 then
    csItem = listview:NewListViewItem("AllianceItem")
    theScript = DetailItemAlliance
  end
  if self.items[csItem] == nil then
    local nameStr = "Cell" .. UIUtil.GetLoopListItemIndex()
    csItem.gameObject.name = nameStr
    self.items[csItem] = self.content:AddComponent(theScript, nameStr)
  end
  if self.items[csItem] ~= nil then
    self.items[csItem]:ReInit(index, data, self.serverId)
  end
  return csItem
end

function UILWSeasonServerDetailView:OnGetServerKingData()
  if self.serverId then
    local thePresident = DataCenter.GovernmentManager.CrossKingdomKing[self.serverId]
    local kingInfo = DataCenter.GovernmentManager:GetCrossServerKingInfo(self.serverId)
    local cfgId = kingInfo and kingInfo.badges.cfgId or 511001
    local status = 0
    if LuaEntry.Player:GetSourceServerId() == self.serverId then
      status = 2
    end
    local king = kingInfo and kingInfo.king or thePresident
    self.zoneItem:ReInit(king, ServerBattleType.VS4, status, self.serverId, {cfgId = cfgId})
  end
end

function UILWSeasonServerDetailView:UpdateData()
  local serverData = DataCenter.SeasonDataManager:GetServerDetail(self.serverId)
  if self.isViewMode then
    self.btn_text:SetLocalText("110036")
    self.btn_go:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_3.png")
  else
    self.btn_text:SetLocalText("2000229")
    self.btn_go:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_2.png")
  end
  self.title1:SetLocalText("s1_zone_info_ui01")
  if serverData then
    self.value1:SetText(string.GetFormattedStr2(toInt(serverData.serverForceScore)))
    if serverData.serverForceRank > 0 then
      self.rank_text1:SetLocalText("801140", serverData.serverForceRank)
    else
      self.rank_text1:SetText("")
    end
  else
    self.value1:SetText("")
    self.rank_text1:SetText("")
  end
  self.title2:SetLocalText("s1_zone_info_ui02")
  if serverData then
    self.value2:SetText(string.percentage(toInt(serverData.totalScore), serverData.totalNum, 2))
    if 0 < serverData.totalRank then
      self.rank_text2:SetLocalText("801140", serverData.totalRank)
    else
      self.rank_text2:SetText("")
    end
  else
    self.value2:SetText("")
    self.rank_text2:SetText("")
  end
  self.title3:SetLocalText("s1_zone_info_ui03")
  if serverData then
    self.value3:SetText(string.percentage(toInt(serverData.localScore), serverData.totalNum, 2))
    if 0 < serverData.localRank then
      self.rank_text3:SetLocalText("801140", serverData.localRank)
    else
      self.rank_text3:SetText("")
    end
  else
    self.value3:SetText("")
    self.rank_text3:SetText("")
  end
  self.title4:SetLocalText("s1_zone_info_ui04")
  if serverData then
    self.value4:SetText(string.percentage(toInt(serverData.crossScore), serverData.totalNum, 2))
    if 0 < serverData.crossRank then
      self.rank_text4:SetLocalText("801140", serverData.crossRank)
    else
      self.rank_text4:SetText("")
    end
  else
    self.value4:SetText("")
    self.rank_text4:SetText("")
  end
  self:OnGetServerKingData()
  if self.dataList == nil then
    self.toggle1:SetIsOn(true)
    self:OnTabChanged(1)
  end
end

function UILWSeasonServerDetailView:OnClickGo()
  local serverId = self.serverId
  if serverId == 0 then
    UIUtil.ShowTipsId("avatar_tips006")
    return
  end
  local position = self.jumpTo
  local gotoPointIndex = self.pointId
  local useViewMode = self.isViewMode
  local putMode = self.putMode
  local buildId = self.buildId
  if putMode == JumpServerMode.PutAllianceBuild and buildId ~= nil then
    SeasonUtil.PutAllianceBuild(serverId, buildId, gotoPointIndex, position)
    return
  end
  GoToUtil.CloseAllWindows()
  if LuaEntry.Player:GetSelfServerId() == serverId then
    GoToUtil.GotoWorldPos(position, MoveCityCameraHeight, nil, function()
    end, serverId)
  elseif LuaEntry.Player:GetSourceServerId() == serverId then
    CrossServerUtil.BackToSrcServer()
  elseif useViewMode then
    GoToUtil.GotoWorldPos(position, MoveCityCameraHeight, nil, function()
    end, serverId)
  else
    CrossServerUtil.JumpToServerByServerId(serverId, MoveCrossServerType.SeasonBattleDesert, gotoPointIndex)
  end
end

return UILWSeasonServerDetailView
