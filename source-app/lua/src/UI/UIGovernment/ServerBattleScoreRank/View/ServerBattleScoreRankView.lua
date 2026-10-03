local ServerBattleScoreRankView = BaseClass("ServerBattleScoreRankView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local RankListItem = require("UI.UIGovernment.ServerBattleScoreRank.Component.SeverBattleScoreRankListItem")
local lastActiveTab = 1
local btn_back_path = "Root/BottomBar/BtnBack"
local text_title_path = "Root/TopBar/TextTitle"
local rank_des_path = "Root/PackList/select/rankDes"
local name_des_path = "Root/PackList/select/nameDes"
local power_des_path = "Root/PackList/select/powerDes"
local tab_item1_path = "Root/TopBar/Tab/TabItem1"
local tab_item2_path = "Root/TopBar/Tab/TabItem2"
local text_tab1_path = "Root/TopBar/Tab/TabItem1/Condition1Select/Condition1"
local text_tab1_un_path = "Root/TopBar/Tab/TabItem1/Condition1Dark"
local text_tab2_path = "Root/TopBar/Tab/TabItem2/Condition2Select/Condition2"
local text_tab2_un_path = "Root/TopBar/Tab/TabItem2/Condition2Dark"
local scroll_path = "Root/PackList"
local content_path = "Root/PackList/Viewport/Content"
local self_data_path = "Root/SelfData"

function ServerBattleScoreRankView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  self.param = param
  self.flagGlobal = 0
  self:ComponentDefine()
end

function ServerBattleScoreRankView:OnDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ServerBattleScoreRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PlayerRank, self.RefreshRankList)
  self:AddUIListener(EventId.AllianceRank, self.RefreshRankList)
  self:AddUIListener(EventId.RefreshRankingData, self.RefreshRankList)
end

function ServerBattleScoreRankView:OnRemoveListener()
  self:RemoveUIListener(EventId.PlayerRank, self.RefreshRankList)
  self:RemoveUIListener(EventId.AllianceRank, self.RefreshRankList)
  self:RemoveUIListener(EventId.RefreshRankingData, self.RefreshRankList)
  base.OnRemoveListener(self)
end

function ServerBattleScoreRankView:ComponentDefine()
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.rank_des = self:AddComponent(UIText, rank_des_path)
  self.name_des = self:AddComponent(UIText, name_des_path)
  self.power_des = self:AddComponent(UIText, power_des_path)
  self.tab_item1 = self:AddComponent(UIToggle, tab_item1_path)
  self.tab_item2 = self:AddComponent(UIToggle, tab_item2_path)
  self.text_tab1 = self:AddComponent(UIText, text_tab1_path)
  self.text_tab1_un = self:AddComponent(UIText, text_tab1_un_path)
  self.text_tab2 = self:AddComponent(UIText, text_tab2_path)
  self.text_tab2_un = self:AddComponent(UIText, text_tab2_un_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.self_data = self:AddComponent(RankListItem, self_data_path)
  self.ScrollView = self:AddComponent(UIScrollView, scroll_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
  if self.serverId == nil then
    self.serverId = LuaEntry.Player:GetSourceServerId()
  end
  self.tab_item1:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabChanged(1)
    end
  end)
  self.tab_item2:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabChanged(2)
    end
  end)
  self:OnShow()
end

function ServerBattleScoreRankView:ComponentDestroy()
  self.btn_back = nil
  self.tabActive = nil
end

function ServerBattleScoreRankView:OnShow()
  self.text_title:SetLocalText("zone_war_score_rank_title")
  self.text_tab1:SetLocalText("zone_war_score_rank_alliance")
  self.text_tab1_un:SetLocalText("zone_war_score_rank_alliance")
  self.text_tab2:SetLocalText("zone_war_score_rank_person")
  self.text_tab2_un:SetLocalText("zone_war_score_rank_person")
  lastActiveTab = self:GetUserData() or 1
  if lastActiveTab == 1 then
    self.tab_item1:SetIsOn(true)
  else
    self.tab_item2:SetIsOn(true)
  end
  if self.tabActive == nil then
    self:OnTabChanged(lastActiveTab)
  end
end

function ServerBattleScoreRankView:OnTabChanged(index)
  lastActiveTab = index
  self.tabActive = index
  if index == 1 then
    self.rank_des:SetText(Localization:GetString("302043"))
    self.name_des:SetText(Localization:GetString("100031"))
    self.power_des:SetText(Localization:GetString("zone_war_score_rank_tab03"))
    SFSNetwork.SendMessage(MsgDefines.CrossKingRoundAllianceScoreRank)
    self.theType = SeverBattleScoreRankType.ALLIANCE
  elseif index == 2 then
    self.rank_des:SetText(Localization:GetString("302043"))
    self.name_des:SetText(Localization:GetString("100031"))
    self.power_des:SetText(Localization:GetString("zone_war_score_rank_tab03"))
    SFSNetwork.SendMessage(MsgDefines.CrossKingRoundPersonScoreRank)
    self.theType = SeverBattleScoreRankType.PERSON
  end
  self:RefreshRankList()
end

function ServerBattleScoreRankView:RefreshRankList()
  if self.tabActive == nil then
    return
  end
  self:ClearScroll()
  if self.theType == nil then
    self.rankList = nil
  else
    self.rankList = DataCenter.ZoneWarManager:GetCrossKingRoundRank(self.theType)
    if #self.rankList > 0 then
      self.ScrollView:SetTotalCount(#self.rankList)
      self.ScrollView:RefillCells()
    end
  end
  self:RefreshSelfContent()
end

function ServerBattleScoreRankView:RefreshSelfContent()
  if self.tabActive == 3 or self.serverId ~= LuaEntry.Player:GetSourceServerId() then
    self.self_data:SetActive(false)
    self.ScrollView.transform.offsetMin = Vector2.New(0, 200)
    return
  else
    self.ScrollView.transform.offsetMin = Vector2.New(0, 350)
  end
  local currentData
  local theType = self.theType
  if theType == SeverBattleScoreRankType.PERSON then
    for i, v in ipairs(self.rankList) do
      if v.uid == LuaEntry.Player.uid then
        currentData = v
        break
      end
    end
  elseif theType == SeverBattleScoreRankType.ALLIANCE then
    for i, v in ipairs(self.rankList) do
      if v.allianceId == LuaEntry.Player.allianceId then
        currentData = v
        break
      end
    end
  end
  if currentData == nil then
    self.self_data:SetActive(false)
    return
  end
  self.self_data:SetItemShow(self.flagGlobal, currentData, true, self.theType == SeverBattleScoreRankType.ALLIANCE)
  self.self_data:SetActive(true)
end

function ServerBattleScoreRankView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(RankListItem, itemObj)
  if cellItem ~= nil then
    cellItem:SetItemShow(self.flagGlobal, self.rankList[index], false, self.theType == SeverBattleScoreRankType.ALLIANCE)
  end
end

function ServerBattleScoreRankView:OnRankItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, RankListItem)
end

function ServerBattleScoreRankView:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(RankListItem)
end

function ServerBattleScoreRankView:OnPlayerDetailClick(serverId, playerUid)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, {serverId = serverId, uid = playerUid})
end

function ServerBattleScoreRankView:OnAllianceDetailClick(serverId, allianceId, allianceName)
  UIUtil.TryShowAllianceInfo(serverId, allianceId, allianceName)
end

return ServerBattleScoreRankView
