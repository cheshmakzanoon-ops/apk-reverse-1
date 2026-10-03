local LWSeasonDesertRankView = BaseClass("LWSeasonDesertRankView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local LWSeasonDesertRankItem = require("UI.LWSeason.LWSeasonDesertRank.Component.LWSeasonDesertRankItem")
local RankListItem = require("UI.UIRank.UIRankDetailList.Component.RankListItem")
local lastActiveTab = 1
local btn_back_path = "Root/BottomBar/BtnBack"
local text_title_path = "Root/TopBar/TextTitle"
local rank_des_path = "Root/PackList/select/rankDes"
local name_des_path = "Root/PackList/select/nameDes"
local power_des_path = "Root/PackList/select/powerDes"
local tab_item1_path = "Root/TopBar/Tab/TabItem1"
local tab_item2_path = "Root/TopBar/Tab/TabItem2"
local scroll_path = "Root/PackList"
local content_path = "Root/PackList/Viewport/Content"
local self_data_path = "Root/SelfData"

function LWSeasonDesertRankView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  self.param = param
  self.flagGlobal = 0
  self:ComponentDefine()
end

function LWSeasonDesertRankView:OnDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWSeasonDesertRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PlayerRank, self.RefreshRankList)
  self:AddUIListener(EventId.AllianceRank, self.RefreshRankList)
  self:AddUIListener(EventId.RefreshRankingData, self.RefreshRankList)
end

function LWSeasonDesertRankView:OnRemoveListener()
  self:RemoveUIListener(EventId.PlayerRank, self.RefreshRankList)
  self:RemoveUIListener(EventId.AllianceRank, self.RefreshRankList)
  self:RemoveUIListener(EventId.RefreshRankingData, self.RefreshRankList)
  base.OnRemoveListener(self)
end

function LWSeasonDesertRankView:ComponentDefine()
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.text_title:SetText("\227\128\144\229\138\191\229\138\155\229\128\188\230\142\146\232\161\140\230\166\156\227\128\145")
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.rank_des = self:AddComponent(UIText, rank_des_path)
  self.name_des = self:AddComponent(UIText, name_des_path)
  self.power_des = self:AddComponent(UIText, power_des_path)
  self.tab_item1 = self:AddComponent(UIToggle, tab_item1_path)
  self.tab_item2 = self:AddComponent(UIToggle, tab_item2_path)
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
  if lastActiveTab == 1 then
    self.tab_item1:SetIsOn(true)
  else
    self.tab_item2:SetIsOn(true)
  end
  if self.tabActive == nil then
    self:OnTabChanged(lastActiveTab)
  end
end

function LWSeasonDesertRankView:ComponentDestroy()
  self.btn_back = nil
  self.tabActive = nil
end

function LWSeasonDesertRankView:OnTabChanged(index)
  lastActiveTab = index
  self.tabActive = index
  if index == 1 then
    self.rank_des:SetText(Localization:GetString("302043"))
    self.name_des:SetText(Localization:GetString("100031"))
    self.power_des:SetText(Localization:GetString("100644"))
    DataCenter.RankDataManager:fetchRankData(0, RankingTypeServer.POWER_ALLIANCE, self.serverId)
    self.theType = RankingTypeServer.POWER_ALLIANCE
  elseif index == 2 then
    self.rank_des:SetText(Localization:GetString("302043"))
    self.name_des:SetText(Localization:GetString("100031"))
    self.power_des:SetText(Localization:GetString("100644"))
    DataCenter.RankDataManager:fetchRankData(0, RankingTypeServer.POWER, self.serverId)
    self.theType = RankingTypeServer.POWER
  end
  self:RefreshRankList()
end

function LWSeasonDesertRankView:RefreshRankList()
  if self.tabActive == nil then
    return
  end
  self:ClearScroll()
  if self.theType == nil then
    self.rankList = nil
  else
    self.rankList = self.ctrl:GetRankList(0, self.theType, self.serverId)
    if #self.rankList > 0 then
      self.ScrollView:SetTotalCount(#self.rankList)
      self.ScrollView:RefillCells()
    end
  end
  self:RefreshSelfContent()
end

function LWSeasonDesertRankView:RefreshSelfContent()
  if self.tabActive == 3 or self.serverId ~= LuaEntry.Player:GetSourceServerId() then
    self.self_data:SetActive(false)
    self.ScrollView.transform.offsetMin = Vector2.New(0, 200)
    return
  else
    self.ScrollView.transform.offsetMin = Vector2.New(0, 350)
  end
  local currentData
  local theType = self.theType
  for i = 1, #self.rankList do
    if theType == RankingTypeServer.KILL or theType == RankingTypeServer.HERO_TOTAL_POWER or theType == RankingTypeServer.PVE_STAGE or theType == RankingTypeServer.ONE_HERO_POWER or theType == RankingTypeServer.POWER or theType == RankingTypeServer.BUILDING then
      if self.rankList[i].uid == LuaEntry.Player.uid then
        currentData = self.rankList[i]
      end
    elseif (theType == RankingTypeServer.POWER_ALLIANCE or theType == RankingTypeServer.KILL_ALLIANCE) and self.rankList[i].uid == LuaEntry.Player.allianceId then
      currentData = self.rankList[i]
    end
  end
  if currentData == nil then
    currentData = self.ctrl:GetSelfData(self.flagGlobal, theType)
  end
  self.self_data:SetActive(true)
  self.self_data:SetItemShow(self.flagGlobal, currentData, true)
end

function LWSeasonDesertRankView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(RankListItem, itemObj)
  if cellItem ~= nil then
    cellItem:SetItemShow(self.flagGlobal, self.rankList[index], false)
  end
end

function LWSeasonDesertRankView:OnRankItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, RankListItem)
end

function LWSeasonDesertRankView:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(RankListItem)
end

function LWSeasonDesertRankView:OnPlayerDetailClick(serverId, playerUid)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, {serverId = serverId, uid = playerUid})
end

function LWSeasonDesertRankView:OnAllianceDetailClick(serverId, allianceId, allianceName)
  UIUtil.TryShowAllianceInfo(serverId, allianceId, allianceName)
end

return LWSeasonDesertRankView
