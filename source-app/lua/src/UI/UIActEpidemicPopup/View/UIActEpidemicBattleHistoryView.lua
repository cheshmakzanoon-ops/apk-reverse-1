local UIActEpidemicBattleHistoryView = BaseClass("UIActEpidemicBattleHistoryView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIActEpidemicBattleHistoryItem = require("UI.UIActEpidemicPopup.Component.UIActEpidemicBattleHistoryItem")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  DataCenter.ActEpidemicZoneManager:RequestActivityBattleHistory()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "UICommonPopUpTitle/Common_img_title/titleText")
  self.textTmpLossCount = self:AddComponent(UITextMeshProUGUIEx, "PanelRect/ScrollRect/TmpLossCount")
  self.textTmpTotalBattleCount = self:AddComponent(UITextMeshProUGUIEx, "PanelRect/ScrollRect/TmpTotalBattleCount")
  self.textTmpWinCount = self:AddComponent(UITextMeshProUGUIEx, "PanelRect/ScrollRect/TmpWinCount")
  self.scrollViewScrollView = self:AddComponent(UIScrollView, "PanelRect/ScrollRect/ScrollView")
  self.btnClose = self:AddComponent(UIButton, "UICommonPopUpTitle/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textEmpty = self:AddComponent(UITextMeshProUGUIEx, "UICommonPopUpTitle/EmptyText")
  self.btnPanel = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTitle:SetLocalText("winter_battlefield_interface_tips1028")
  self.scrollViewScrollView:SetFixedItemSize(730, 400)
  self.scrollViewScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollViewScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.scrollViewScrollView:SetOnEndDrag(function(eventData)
    local nPos = self.scrollViewScrollView:GetVerticalNormalizedPosition()
    if 1.02 < nPos then
      DataCenter.ActEpidemicZoneManager:RequestActivityBattleHistory()
      if self.lastCount and self.lastCount > 0 then
        self.requestedNewHistory = true
      end
    end
  end)
  self:RefreshScrollView()
  self.textEmpty:SetLocalText("champion_duel_tips1131")
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self.textTitle = nil
  self.textTmpLossCount = nil
  self.textTmpTotalBattleCount = nil
  self.textTmpWinCount = nil
  self.scrollViewScrollView = nil
  self.btnClose = nil
  self.textEmpty = nil
  self.btnPanel = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.requestedNewHistory = nil
  self.lastCount = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.EpidemicActBattleHistoryList, self.OnEpidemicActBattleHistoryList)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.EpidemicActBattleHistoryList, self.OnEpidemicActBattleHistoryList)
  base.OnRemoveListener(self)
end

function UIActEpidemicBattleHistoryView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIActEpidemicBattleHistoryView:OnEpidemicActBattleHistoryList()
  self:RefreshScrollView()
end

function UIActEpidemicBattleHistoryView:RefreshScrollView(fromEnd)
  self.battleHistory = DataCenter.ActEpidemicZoneManager:GetBattleHistory() or {}
  local loss = self.battleHistory.failCount or 0
  local total = self.battleHistory.totalCount or 0
  local win = self.battleHistory.winCount or 0
  self.textTmpLossCount:SetText(string.format("%s : %s", Localization:GetString("winter_battlefield_interface_tips1029"), win))
  self.textTmpTotalBattleCount:SetText(string.format("%s : %s", Localization:GetString("winter_battlefield_interface_tips1030"), total))
  self.textTmpWinCount:SetText(string.format("%s : %s", Localization:GetString("YiBianJinQu_battle_record_tips_1"), loss))
  self.battleList = self.battleHistory.list or {}
  if 0 < #self.battleList then
    self.scrollViewScrollView:SetTotalCount(#self.battleList)
    if self.requestedNewHistory then
      self.scrollViewScrollView:RefillCellsFromEnd(1)
      self.requestedNewHistory = nil
    else
      self.scrollViewScrollView:RefillCells(1)
    end
    self.textEmpty:SetActive(false)
    self.lastCount = #self.battleList
  else
    self.textEmpty:SetActive(true)
  end
end

function UIActEpidemicBattleHistoryView:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollViewScrollView:AddComponent(UIActEpidemicBattleHistoryItem, itemObj)
  local data = self.battleList[index]
  if cellItem ~= nil and data then
    cellItem:ReInit(index, data)
  end
end

function UIActEpidemicBattleHistoryView:OnItemMoveOut(itemObj, index)
  self.scrollViewScrollView:RemoveComponent(itemObj.name, UIActEpidemicBattleHistoryItem)
end

function UIActEpidemicBattleHistoryView:ClearScroll()
  self.scrollViewScrollView:ClearCells()
  self.scrollViewScrollView:RemoveComponents(UIActEpidemicBattleHistoryItem)
end

function UIActEpidemicBattleHistoryView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

UIActEpidemicBattleHistoryView.OnCreate = OnCreate
UIActEpidemicBattleHistoryView.OnDestroy = OnDestroy
UIActEpidemicBattleHistoryView.OnEnable = OnEnable
UIActEpidemicBattleHistoryView.OnDisable = OnDisable
UIActEpidemicBattleHistoryView.ComponentDefine = ComponentDefine
UIActEpidemicBattleHistoryView.ComponentDestroy = ComponentDestroy
UIActEpidemicBattleHistoryView.DataDefine = DataDefine
UIActEpidemicBattleHistoryView.DataDestroy = DataDestroy
UIActEpidemicBattleHistoryView.OnAddListener = OnAddListener
UIActEpidemicBattleHistoryView.OnRemoveListener = OnRemoveListener
return UIActEpidemicBattleHistoryView
