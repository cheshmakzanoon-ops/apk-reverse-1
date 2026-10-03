local UIMultipleParkourRankView = BaseClass("UIMultipleParkourRankView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIMultipleParkourRankWinner = require("UI.UIMultipleParkourRank.Component.UIMultipleParkourRankWinner")
local UIMultipleParkourRankViewItem = require("UI.UIMultipleParkourRank.Component.UIMultipleParkourRankViewItem")
local bg_path = "panel"
local txt_title_path = "panel/bg/txtTitle"
local close_btn_path = "panel/bg/CloseBtn"
local tab_alliance_off_path = "panel/bg/tabs/tabAlliance/tabAlliance_off"
local txt_tab_alliance_off_path = "panel/bg/tabs/tabAlliance/tabAlliance_off/txtTabAlliance_off"
local tab_alliance_on_path = "panel/bg/tabs/tabAlliance/tabAlliance_on"
local txt_tab_alliance_on_path = "panel/bg/tabs/tabAlliance/tabAlliance_on/txtTabAlliance_on"
local tab_server_off_path = "panel/bg/tabs/tabServer/tabServer_off"
local txt_tab_server_off_path = "panel/bg/tabs/tabServer/tabServer_off/txtTabServer_off"
local tab_server_on_path = "panel/bg/tabs/tabServer/tabServer_on"
local txt_tab_server_on_path = "panel/bg/tabs/tabServer/tabServer_on/txtTabServer_on"
local gold_path = "panel/bg/winners/gold"
local silver_path = "panel/bg/winners/silver"
local bronze_path = "panel/bg/winners/bronze"
local scroll_rank_path = "panel/bg/scrollRank"
local self_rank_path = "panel/bg/selfRank"
local empty_tip_path = "panel/bg/emptyTip"
local RankType = {AllianceRank = 1, ServerRank = 2}

function UIMultipleParkourRankView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIMultipleParkourRankView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIMultipleParkourRankView:ComponentDefine()
  self.bg = self:AddComponent(UIButton, bg_path)
  self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.tab_alliance_off = self:AddComponent(UIButton, tab_alliance_off_path)
  self.txt_tab_alliance_off = self:AddComponent(UITextMeshProUGUIEx, txt_tab_alliance_off_path)
  self.tab_alliance_on = self:AddComponent(UIImage, tab_alliance_on_path)
  self.txt_tab_alliance_on = self:AddComponent(UITextMeshProUGUIEx, txt_tab_alliance_on_path)
  self.tab_server_off = self:AddComponent(UIButton, tab_server_off_path)
  self.txt_tab_server_off = self:AddComponent(UITextMeshProUGUIEx, txt_tab_server_off_path)
  self.tab_server_on = self:AddComponent(UIImage, tab_server_on_path)
  self.txt_tab_server_on = self:AddComponent(UITextMeshProUGUIEx, txt_tab_server_on_path)
  self.txt_title:SetText(Localization:GetString("multiply_door_tips_010"))
  local alncTabKey = Localization:GetString("multiply_door_tips_002")
  self.txt_tab_alliance_off:SetText(alncTabKey)
  self.txt_tab_alliance_on:SetText(alncTabKey)
  local serverTabKey = Localization:GetString("multiply_door_tips_003")
  self.txt_tab_server_off:SetText(serverTabKey)
  self.txt_tab_server_on:SetText(serverTabKey)
  self.tab_alliance_off:SetOnClick(function()
    self:SwitchTab(RankType.AllianceRank)
  end)
  self.tab_server_off:SetOnClick(function()
    self:SwitchTab(RankType.ServerRank)
  end)
  self.tabsOn = {
    [RankType.AllianceRank] = self.tab_alliance_on,
    [RankType.ServerRank] = self.tab_server_on
  }
  self.tabsOff = {
    [RankType.AllianceRank] = self.tab_alliance_off,
    [RankType.ServerRank] = self.tab_server_off
  }
  self.bg:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.gold = self:AddComponent(UIMultipleParkourRankWinner, gold_path)
  self.silver = self:AddComponent(UIMultipleParkourRankWinner, silver_path)
  self.bronze = self:AddComponent(UIMultipleParkourRankWinner, bronze_path)
  self.winnerComps = {
    self.gold,
    self.silver,
    self.bronze
  }
  self.scroll_rank = self:AddComponent(UIScrollView, scroll_rank_path)
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.scroll_rank:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemCreateCell(itemObj, index)
  end)
  self.scroll_rank:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemDeleteCell(itemObj, index)
  end)
  self.self_rank = self:AddComponent(UIMultipleParkourRankViewItem, self_rank_path)
  self.empty_tip = self:AddComponent(UITextMeshProUGUIEx, empty_tip_path)
  self.empty_tip:SetText(Localization:GetString("multiply_door_tips_025"))
  self:SwitchTab(RankType.AllianceRank)
end

function UIMultipleParkourRankView:OnItemCreateCell(itemObj, index)
  local item = self.scrollCellPool[itemObj.name]
  if not item then
    local name = tostring(self.itemIndex)
    itemObj.name = name
    item = self.scroll_rank:AddComponent(UIMultipleParkourRankViewItem, itemObj)
    self.scrollCellPool[name] = item
    self.itemIndex = self.itemIndex + 1
  end
  local rankData = self.rankDatas[index]
  item:Refresh(rankData, self.curTab)
end

function UIMultipleParkourRankView:OnItemDeleteCell(itemObj, index)
end

function UIMultipleParkourRankView:DataDefine()
end

function UIMultipleParkourRankView:ComponentDestroy()
  self.scroll_rank:ClearCells()
  self.scroll_rank:RemoveComponents(UIMultipleParkourRankViewItem)
  self.scrollCellPool = {}
  self.bg = nil
  self.txt_title = nil
  self.close_btn = nil
  self.tab_alliance_off = nil
  self.txt_tab_alliance_off = nil
  self.tab_alliance_on = nil
  self.txt_tab_alliance_on = nil
  self.tab_server_off = nil
  self.txt_tab_server_off = nil
  self.tab_server_on = nil
  self.txt_tab_server_on = nil
  self.gold = nil
  self.silver = nil
  self.bronze = nil
  self.scroll_rank = nil
  self.self_rank = nil
  self.empty_tip = nil
end

function UIMultipleParkourRankView:DataDestroy()
end

function UIMultipleParkourRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MultipleParkourGetRank, self.OnMultipleParkourGetRank)
end

function UIMultipleParkourRankView:OnRemoveListener()
  self:RemoveUIListener(EventId.MultipleParkourGetRank, self.OnMultipleParkourGetRank)
  base.OnRemoveListener(self)
end

function UIMultipleParkourRankView:ReInit()
end

function UIMultipleParkourRankView:SwitchTab(type)
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
  for i, v in ipairs(self.winnerComps) do
    v:SetActive(false)
  end
  self.scroll_rank:SetActive(false)
  self.self_rank:SetActive(false)
  self.empty_tip:SetActive(false)
  self:RefreshView()
end

function UIMultipleParkourRankView:RefreshView()
  if self.curTab == RankType.AllianceRank and not LuaEntry.Player:IsInAlliance() then
    self.empty_tip:SetText(Localization:GetString("multiply_door_tips_027"))
    self.empty_tip:SetActive(true)
    return
  end
  SFSNetwork.SendMessage(MsgDefines.MultipleParkourGetRank, self.curTab)
end

function UIMultipleParkourRankView:OnMultipleParkourGetRank(info)
  if not info or not info.rankList then
    return
  end
  if not info.type then
    return
  end
  if info.type ~= self.curTab then
    return
  end
  self:Refresh(info)
end

function UIMultipleParkourRankView:Refresh(info)
  if not info or not info.rankList then
    return
  end
  self.rankDatas = {}
  local rankList = info.rankList
  local count = #rankList
  if count == 0 then
    self.empty_tip:SetText(Localization:GetString("multiply_door_tips_025"))
    self.empty_tip:SetActive(true)
  else
    self.empty_tip:SetActive(false)
  end
  local selfData
  local selfRank = info.selfRank or 0
  if 0 < selfRank and count >= selfRank then
    selfData = rankList[selfRank]
  end
  for i = 1, 3 do
    local data = rankList[i]
    if data then
      self.winnerComps[i]:SetActive(true)
      self.winnerComps[i]:Refresh(data, self.curTab)
    else
      self.winnerComps[i]:SetActive(false)
    end
  end
  for i = 4, count do
    table.insert(self.rankDatas, rankList[i])
  end
  local rankCount = #self.rankDatas
  self.scroll_rank:SetTotalCount(rankCount)
  if 0 < rankCount then
    self.scroll_rank:RefillCells()
    self.scroll_rank:SetActive(true)
  end
  if selfData then
    self.self_rank:Refresh(selfData, self.curTab)
  else
    local selfLevel = info.selfLevel or 0
    self.self_rank:RefreshSelfUnlisted(selfRank, selfLevel, self.curTab)
  end
  self.self_rank:SetActive(true)
end

return UIMultipleParkourRankView
