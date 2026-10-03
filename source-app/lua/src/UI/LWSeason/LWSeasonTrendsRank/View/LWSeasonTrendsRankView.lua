local LWSeasonTrendsRankView = BaseClass("LWSeasonTrendsRankView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWSeasonTrendsRankItem = require("UI.LWSeason.LWSeasonTrendsRank.Component.LWSeasonTrendsRankItem")
local text_title_path = "Root/TopBar/TextTitle"
local btn_back_path = "Root/BottomBar/BtnBack"
local rank_des_path = "Root/ScrollView/select/rankDes"
local name_des_path = "Root/ScrollView/select/nameDes"
local power_des_path = "Root/ScrollView/select/powerDes"
local self_data_path = "Root/SelfData"
local info_btn_path = "Root/TopBar/InfoBtn"
local btn_rank_reward_path = "Root/BottomBar/BtnRankReward"
local scroll_path = "Root/ScrollView"
local tab_btns_path = "Root/tabBtns"
local tab_path = "Root/tabBtns/Viewport/ConditionBtns/Tab%d"
local empty_des_path = "emptyDes"
local desc_path = "Root/tabBtns/Viewport/Desc"
local tabNameKey = {
  [1] = "393080",
  [2] = "129046"
}

function LWSeasonTrendsRankView:OnCreate()
  base.OnCreate(self)
  self.rankPanelType, self.param, self.rankIndex, self.descStr = self:GetUserData()
  self.rankIndex = self.rankIndex and self.rankIndex or 1
  self.ctrl:TrendsRankCtrlSetData(self.rankPanelType, self.param)
  self.txt_title = self:AddComponent(UIText, text_title_path)
  self.name_des = self:AddComponent(UIText, name_des_path)
  self.power_des = self:AddComponent(UIText, power_des_path)
  self.rank_des = self:AddComponent(UIText, rank_des_path)
  self.close_btn = self:AddComponent(UIButton, btn_back_path)
  self.tab_btns = self:AddComponent(UIBaseContainer, tab_btns_path)
  self.empty_des = self:AddComponent(UITextMeshProUGUIEx, empty_des_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  if self.descStr then
    self.desc:SetText(self.descStr)
  else
    self.desc:SetText("")
  end
  self.self_data = self:AddComponent(LWSeasonTrendsRankItem, self_data_path)
  self.ScrollView = self:AddComponent(UIScrollView, scroll_path)
  self.ScrollView:SetFixedItemSize(750, 135)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
  self.btn_rank_reward = self:AddComponent(UIButton, btn_rank_reward_path)
  self.btn_rank_reward:SetOnClick(function()
    self:RequestRewardInfo()
  end)
  self.tabflag = self.ctrl:TabState(self.param)
  self.tab_btns:SetActive(self.tabflag ~= nil)
  self.selectIndex = self.rankIndex ~= nil and self.rankIndex or 1
  self.tabs = {}
  if self.tabflag then
    for i = 1, 4 do
      local tab = {}
      local rootPath = string.format(tab_path, i)
      tab.tab = self:AddComponent(UIBaseContainer, rootPath)
      tab.tab_select = tab.tab:AddComponent(UIBaseContainer, "select")
      tab.tab_name = tab.tab:AddComponent(UIText, "activityName")
      local tabKey = tabNameKey[i]
      if self.tabflag[i] then
        local rankConfig = LocalController:instance():getLine(TableName.LW_Season_rank, self.tabflag[i])
        if rankConfig and not string.IsNullOrEmpty(rankConfig.rank_type_title_key) then
          tabKey = rankConfig.rank_type_title_key
        end
      end
      tab.tab_name:SetText(Localization:GetString(tabKey))
      tab.tab_btn = tab.tab:AddComponent(UIButton, "TypeButton")
      local index = i
      tab.tab_btn:SetOnClick(function()
        self:DoSelectTabIndex(index)
      end)
      self.tabs[i] = tab
      tab.tab:SetActive(self.tabflag[i])
    end
  end
  self:RefreshBar()
  self:RefreshContent()
end

function LWSeasonTrendsRankView:OnDestroy()
  self:ClearScroll()
  self.txt_title = nil
  self.name_des = nil
  self.power_des = nil
  self.rank_des = nil
  self.close_btn = nil
  self.ScrollView = nil
  self.rankList = nil
  self.tab_btns = nil
  self.empty_des = nil
  self.btn_rank_reward = nil
  base.OnDestroy(self)
end

function LWSeasonTrendsRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonTrendRankRewardInfoUpdate, self.OpenRewardWindow)
  self:AddUIListener(EventId.LWSeasonWastedlandChallengeRankRewardInfoUpdate, self.OpenRewardWindow)
  self:AddUIListener(EventId.LWSeasonWastedlandChallengeRankInfoUpdate, self.RefreshRankInfo)
  self:AddUIListener(EventId.LWSeasonTrendRankInfoUpdate, self.RefreshRankInfo)
  self:AddUIListener(EventId.ActNuclearRankReweardUpdate, self.OpenRewardWindow)
  self:AddUIListener(EventId.ActNuclearBuildStartPersonalRankUpdate, self.RefreshRankInfo)
  self:AddUIListener(EventId.ActNuclearPersonalDamageRankUpdate, self.RefreshRankInfo)
  self:AddUIListener(EventId.BloodyNightRankRefresh, self.RefreshBloodyNightRankInfo)
  self:AddUIListener(EventId.WestwardExpansionRankRefresh, self.RefreshWestwardExpansionRankInfo)
end

function LWSeasonTrendsRankView:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonTrendRankRewardInfoUpdate, self.OpenRewardWindow)
  self:RemoveUIListener(EventId.LWSeasonWastedlandChallengeRankRewardInfoUpdate, self.OpenRewardWindow)
  self:RemoveUIListener(EventId.LWSeasonWastedlandChallengeRankInfoUpdate, self.RefreshRankInfo)
  self:RemoveUIListener(EventId.LWSeasonTrendRankInfoUpdate, self.RefreshRankInfo)
  self:RemoveUIListener(EventId.ActNuclearRankReweardUpdate, self.OpenRewardWindow)
  self:RemoveUIListener(EventId.ActNuclearBuildStartPersonalRankUpdate, self.RefreshRankInfo)
  self:RemoveUIListener(EventId.ActNuclearPersonalDamageRankUpdate, self.RefreshRankInfo)
  self:RemoveUIListener(EventId.BloodyNightRankRefresh, self.RefreshBloodyNightRankInfo)
  self:RemoveUIListener(EventId.WestwardExpansionRankRefresh, self.RefreshWestwardExpansionRankInfo)
  base.OnRemoveListener(self)
end

function LWSeasonTrendsRankView:RefreshContent()
  self.btn_rank_reward:SetActive(self.ctrl:CheckRewardBtnStat(self.rankIndex))
  self.descInfo = self.ctrl:GetActivityDescription(self.rankPanelType, self.param, self.rankIndex)
  self.info_btn:SetActive(not string.IsNullOrEmpty(self.descInfo.desc))
  self.info_btn:SetOnClick(function()
    if not string.IsNullOrEmpty(self.descInfo.desc) then
      local param = {}
      param.activityRulesStr = self.descInfo.desc
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
    end
  end)
  self.txt_title:SetText(self.descInfo.title)
  self.rank_des:SetLocalText(361013)
  self.name_des:SetText(self.descInfo.content1)
  self.power_des:SetText(self.descInfo.content2)
  self:RefreshRankList(true)
end

function LWSeasonTrendsRankView:RefreshRankList(sendMsg)
  self:ClearScroll()
  self.rankList = self.ctrl:GetSeasonTrendsRankList(self.rankPanelType, self.param, sendMsg, self.rankIndex)
  local flag = #self.rankList > 0
  if flag then
    self.ScrollView:SetTotalCount(#self.rankList)
    self.ScrollView:RefillCells()
  end
  self.empty_des:SetActive(not flag)
  self:RefreshSelfContent()
end

function LWSeasonTrendsRankView:RefreshSelfContent()
  local currentData
  for i = 1, #self.rankList do
    if self.rankList[i].uid == LuaEntry.Player.uid then
      currentData = self.rankList[i]
    end
  end
  if currentData == nil then
    currentData = self.ctrl:GetSelfData(self.rankPanelType, self.param, self.rankIndex)
  end
  local globalFlag = self.ctrl:GetGlobalByType(self.rankPanelType)
  self.self_data:SetActive(true)
  self.self_data:SetItemShow(globalFlag, currentData, true)
end

function LWSeasonTrendsRankView:Init()
end

function LWSeasonTrendsRankView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(LWSeasonTrendsRankItem, itemObj)
  if cellItem ~= nil then
    local globalFlag = self.ctrl:GetGlobalByType(self.rankPanelType)
    cellItem:SetItemShow(globalFlag, self.rankList[index], false)
  end
end

function LWSeasonTrendsRankView:OnRankItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, LWSeasonTrendsRankItem)
end

function LWSeasonTrendsRankView:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(LWSeasonTrendsRankItem)
end

function LWSeasonTrendsRankView:RequestRewardInfo()
  if not self:OpenRewardWindow() then
    self.ctrl:OpenRewardLogic(self.rankPanelType, self.param, self.rankIndex)
  end
end

function LWSeasonTrendsRankView:OpenRewardWindow()
  local reward = self.ctrl:GetWasteLandRankRewardList(self.rankIndex)
  if reward and 0 < #reward then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUICommonRankReward, {anim = true}, reward)
    return true
  end
  return false
end

function LWSeasonTrendsRankView:RefreshRankInfo(activityId)
  if activityId == self.param then
    self:RefreshRankList()
  end
end

function LWSeasonTrendsRankView:RefreshBloodyNightRankInfo(rankId)
  if self.rankPanelType == CommonRankPanelType.BloodyNightRank then
    local rankIdList = DataCenter.BloodyNightDataManager:GetStageRankCfgIdList()
    if rankIdList and rankIdList[self.rankIndex] == rankId then
      self:RefreshRankList()
    end
  end
end

function LWSeasonTrendsRankView:RefreshWestwardExpansionRankInfo()
  if self.rankPanelType == CommonRankPanelType.WestwardExpansionRank then
    self:RefreshRankList()
  end
end

function LWSeasonTrendsRankView:DoSelectTabIndex(index)
  if index ~= self.selectIndex then
    self.selectIndex = index
  else
    return
  end
  self.rankIndex = self.selectIndex
  self:RefreshBar()
  self:RefreshContent()
end

function LWSeasonTrendsRankView:RefreshBar()
  for i = 1, #self.tabs do
    if self.tabs[i] ~= nil then
      self.tabs[i].tab_select:SetActive(i == self.selectIndex)
    end
  end
end

function LWSeasonTrendsRankView:OnAllianceDetailClick(serverId, allianceId, allianceName)
  UIUtil.TryShowAllianceInfo(serverId, allianceId, allianceName)
end

return LWSeasonTrendsRankView
