local base = UIBaseView
local GoldTreeRank = BaseClass("GoldTreeRank", base)
local Localization = CS.GameEntry.Localization
local SeasonGoldTreeRankItem = require("UI.LWSeason.LWSeasonGoldTree.GoldTreeRank.Component.SeasonGoldTreeRankItem")
local SeasonGoldTreeWinnerItem = require("UI.LWSeason.LWSeasonGoldTree.GoldTreeRank.Component.SeasonGoldTreeWinnerItem")
local __icon = "Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_diandeng_dianchi_05.png"
local btnBack_path = "root/btnBack"
local btnReward_path = "root/btnReward"
local btnHelp_path = "root/imgTopBg/helpBtn"
local txtTitle_path = "root/imgTopBg/txtTitle"
local scrollView_path = "root/content/content1/List/ScrollView"
local selfData_path = "root/content/content1/List/SelfData"
local emptyDes_path = "root/content/content1/emptyDes"
local win1_path = "root/content/content1/winners/gold"
local win2_path = "root/content/content1/winners/silver"
local win3_path = "root/content/content1/winners/bronze"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.serverId, self.treeId = self:GetUserData()
  self:RefreshView(true)
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.btnBack = self:AddComponent(UIButton, btnBack_path)
  self.btnReward = self:AddComponent(UIButton, btnReward_path)
  self.btnHelp = self:AddComponent(UIButton, btnHelp_path)
  self.txtTitle = self:AddComponent(UIText, txtTitle_path)
  self.scrollView = self:AddComponent(UIScrollView, scrollView_path)
  self.selfData = self:AddComponent(UIBaseContainer, selfData_path)
  self.emptyDes = self:AddComponent(UIText, emptyDes_path)
  self.win1 = self:AddComponent(UIBaseContainer, win1_path)
  self.win2 = self:AddComponent(UIBaseContainer, win2_path)
  self.win3 = self:AddComponent(UIBaseContainer, win3_path)
  self.btnBack:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.btnReward:SetOnClick(BindCallback(self, self.OnClickReward))
  self.txtTitle:SetLocalText("season_s4_golden_tree_UI_33")
  self.btnHelp:SetOnClick(function()
    local strTips = DataCenter.SeasonGoldTreeTemplateManager:GetGoldTreeTemp("rank_help") or ""
    if not string.IsNullOrEmpty(strTips) then
      UIUtil.ShowIntro(Localization:GetString(2000047), Localization:GetString(2000048), Localization:GetString(strTips))
    end
  end)
  self.win1 = self:AddComponent(SeasonGoldTreeWinnerItem, win1_path)
  self.win2 = self:AddComponent(SeasonGoldTreeWinnerItem, win2_path)
  self.win3 = self:AddComponent(SeasonGoldTreeWinnerItem, win3_path)
  self.selfData = self:AddComponent(SeasonGoldTreeRankItem, selfData_path)
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self.btnBack = nil
  self.btnReward = nil
  self.btnHelp = nil
  self.txtTitle = nil
  self.scrollView = nil
  self.selfData = nil
  self.emptyDes = nil
  self.win1 = nil
  self.win2 = nil
  self.win3 = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function GoldTreeRank:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GoldTreePowerRank, self.GoldTreePowerRank)
end

function GoldTreeRank:OnRemoveListener()
  self:RemoveUIListener(EventId.GoldTreePowerRank, self.GoldTreePowerRank)
  base.OnRemoveListener(self)
end

function GoldTreeRank:GoldTreePowerRank()
  self:RefreshView()
end

function GoldTreeRank:OnClickReward()
  UIManager:GetInstance():OpenWindow(UIWindowNames.GoldTreeReward, {anim = true})
end

function GoldTreeRank:RefreshView(sendMsg)
  self:ClearScroll()
  if sendMsg then
    SFSNetwork.SendMessage(MsgDefines.GoldTreePowerRankView, self.treeId, self.serverId)
  end
  self.data = DataCenter.SeasonGoldTreeManager.rankData
  local rankList = self.data and self.data.ranks or {}
  self.win1:Refresh(rankList[1], __icon)
  self.win2:Refresh(rankList[2], __icon)
  self.win3:Refresh(rankList[3], __icon)
  local count = #rankList or 0
  self.emptyDes:SetActive(count <= 0)
  count = count - 3
  self.rankList = {}
  if count and 0 < count then
    for i = 1, count do
      self.rankList[i] = rankList[i + 3]
    end
    self.scrollView:SetTotalCount(count)
    self.scrollView:RefillCells()
  end
  self:RefreshSelfContent()
end

function GoldTreeRank:RefreshSelfContent()
  local currentData = self.data and self.data.selfData
  if currentData then
    self.selfData:SetItemShow(currentData, __icon)
    self.selfData:SetActive(true)
  else
    self.selfData:SetActive(false)
  end
end

function GoldTreeRank:ClearScroll()
  self.scrollView:RemoveComponents(SeasonGoldTreeRankItem)
  self.scrollView:ClearCells()
end

function GoldTreeRank:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollView:AddComponent(SeasonGoldTreeRankItem, itemObj)
  if cellItem then
    cellItem:SetItemShow(self.rankList[index], __icon)
  end
end

function GoldTreeRank:OnRankItemMoveOut(itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, SeasonGoldTreeRankItem)
end

GoldTreeRank.OnCreate = OnCreate
GoldTreeRank.OnDestroy = OnDestroy
GoldTreeRank.OnEnable = OnEnable
GoldTreeRank.OnDisable = OnDisable
GoldTreeRank.ComponentDefine = ComponentDefine
GoldTreeRank.ComponentDestroy = ComponentDestroy
GoldTreeRank.DataDefine = DataDefine
GoldTreeRank.DataDestroy = DataDestroy
return GoldTreeRank
