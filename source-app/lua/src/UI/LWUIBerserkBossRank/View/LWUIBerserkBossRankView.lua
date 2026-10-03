local base = UIBaseView
local LWUIBerserkBossRankView = BaseClass("LWUIBerserkBossRankView", base)
local LWUIBerserkBossRankTabItemRender = require("UI.LWUIBerserkBossRank.Component.LWUIBerserkBossRankTabItemRender")
local LWUIBerserkBossTotalPersonalDamageRankPage = require("UI.LWUIBerserkBossRank.Component.LWUIBerserkBossTotalPersonalDamageRankPage")
local LWUIBerserkBossRankItemRender = require("UI.LWUIBerserkBossRank.Component.LWUIBerserkBossRankItemRender")
local personalTotalDamageAniName = "Eff_LWUIBerserkBossRankPanelShow"
local panelBtn_path = "panel"
local titleText_path = "PopUpContent/TitleText"
local closeBtn_path = "PopUpContent/CloseBtn"
local tabScrollView_path = "PopUpContent/TopContent/TabScrollView"
local totalPersonalDamageRankPage_path = "PopUpContent/TotalPersonalDamageRankPage"
local otherDamageRankPage_path = "PopUpContent/OtherDamageRankPage"
local rankLoopListView_path = "PopUpContent/OtherDamageRankPage/RankScrollView"
local rankScrollContent_path = "PopUpContent/OtherDamageRankPage/RankScrollView/Viewport/RankScrollContent"
local selfRank_path = "PopUpContent/SelfRank"
local emptyRankTipsText_path = "PopUpContent/EmptyRankTipsText"
local tabContent_path = "PopUpContent/TopContent/TabScrollView/Viewport/TabContent"
local panelAni_path = ""

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.jumpToRankTabType, self.jumpToBossUuid = self:GetUserData()
  self:ReInit()
end

local function OnDestroy(self)
  self:ClearRankLoopView()
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
  self.panelBtn = self:AddComponent(UIButton, panelBtn_path)
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.tabScrollView = self:AddComponent(UIScrollView, tabScrollView_path)
  self.totalPersonalDamageRankPage = self:AddComponent(UIBaseContainer, totalPersonalDamageRankPage_path)
  self.otherDamageRankPage = self:AddComponent(UIBaseContainer, otherDamageRankPage_path)
  self.rankLoopListView = self:AddComponent(UILoopListView2, rankLoopListView_path)
  self.rankScrollContent = self:AddComponent(UIBaseContainer, rankScrollContent_path)
  self.selfRank = self:AddComponent(UIBaseContainer, selfRank_path)
  self.emptyRankTipsText = self:AddComponent(UIText, emptyRankTipsText_path)
  self.tabContent = self:AddComponent(UIBaseContainer, tabContent_path)
  self.panelAni = self:AddComponent(UIAnimator, panelAni_path)
  self.titleText:SetLocalText("activity_berserkboss_title_06")
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.panelBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.tabScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnTabItemMoveIn(itemObj, index)
  end)
  self.tabScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnTabItemMoveOut(itemObj, index)
  end)
  self.totalPersonalDamageRankPageView = self:AddComponent(LWUIBerserkBossTotalPersonalDamageRankPage, totalPersonalDamageRankPage_path)
  self.selfRankView = self:AddComponent(LWUIBerserkBossRankItemRender, selfRank_path)
  self.rankLoopListView:InitListView(0, function(listView, index)
    return self:OnGetItemByIndex(listView, index)
  end)
end

local function ComponentDestroy(self)
  self.panelBtn = nil
  self.titleText = nil
  self.closeBtn = nil
  self.tabScrollView = nil
  self.totalPersonalDamageRankPage = nil
  self.otherDamageRankPage = nil
  self.rankLoopListView = nil
  self.rankScrollContent = nil
  self.selfRank = nil
  self.emptyRankTipsText = nil
  self.tabContent = nil
  self.panelAni = nil
  self.totalPersonalDamageRankPageView = nil
  self.selfRankView = nil
end

local function DataDefine(self)
  self.curTabIndex = 1
  self.curTabData = nil
  self.rankDataDict = {}
  self.isPlayRankAni = true
end

local function DataDestroy(self)
  self.curTabIndex = nil
  self.curTabData = nil
  self.rankDataDict = nil
  self.isPlayRankAni = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetBerserkBossRankInfoData, self.OnGetBerserkBossRankInfoData)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.GetBerserkBossRankInfoData, self.OnGetBerserkBossRankInfoData)
  base.OnRemoveListener(self)
end

local function OnGetBerserkBossRankInfoData(self, rankType)
  local curRankType = self:GetRankTypeByRankTabType()
  if curRankType == rankType then
    self:RefreshShowCurRankView()
  end
end

local function ReInit(self)
  self.tabViewDataList = self.ctrl:GetTabViewData()
  if self.jumpToRankTabType ~= nil then
    local count = table.count(self.tabViewDataList)
    for i = 1, count do
      local tabData = self.tabViewDataList[i]
      if tabData.tabType == self.jumpToRankTabType then
        if self.jumpToRankTabType ~= LWUIBerserkBossRankTabType.Boss then
          self.curTabIndex = i
          break
        elseif self.jumpToBossUuid == tabData.bossUuid then
          self.curTabIndex = i
          break
        end
      end
    end
  end
  self:ShowTabView()
  self:OnTabItemClick(self.curTabIndex)
end

local function ShowTabView(self)
  self:RemoveTabScroll()
  local tabCount = table.count(self.tabViewDataList)
  if 0 < tabCount then
    self.tabScrollView:SetTotalCount(tabCount)
    self.tabScrollView:RefillCells()
  end
end

local function OnTabItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local itemRender = self.tabScrollView:AddComponent(LWUIBerserkBossRankTabItemRender, itemObj)
  if itemRender ~= nil then
    itemRender:InitData(index, self.tabViewDataList[index], self.curTabIndex)
  end
end

local function OnTabItemMoveOut(self, itemObj, index)
  self.tabScrollView:RemoveComponent(itemObj.name, LWUIBerserkBossRankTabItemRender)
end

local function RemoveTabScroll(self)
  self.tabScrollView:ClearCells()
  self.tabScrollView:RemoveComponents(LWUIBerserkBossRankTabItemRender)
end

local function OnTabItemClick(self, index)
  self.curTabIndex = index
  self.curTabData = self.tabViewDataList[index]
  local rankType = self:GetRankTypeByRankTabType()
  DataCenter.LWBerserkBossManager:RequestBerserkBossRankInfo(rankType, self.curTabData.bossUuid, 1, 100)
  self.isPlayRankAni = true
  self:RefreshShowCurRankView()
end

local function RefreshShowCurRankView(self)
  local rankType = self:GetRankTypeByRankTabType()
  self.rankDataDict = DataCenter.LWBerserkBossManager:GetRankDataByTypeAndBossUuid(rankType, self.curTabData.bossUuid)
  local showCount = table.count(self.rankDataDict)
  if showCount == 0 then
    self.emptyRankTipsText:SetLocalText("activity_berserkboss_desc_05")
    self.totalPersonalDamageRankPageView:SetActive(false)
    self.otherDamageRankPage:SetActive(false)
    self.selfRankView:SetActive(false)
    return
  end
  self.emptyRankTipsText:SetText("")
  self.totalPersonalDamageRankPageView:SetActive(self.curTabData.tabType == LWUIBerserkBossRankTabType.TotalPersonalDamage)
  self.otherDamageRankPage:SetActive(self.curTabData.tabType ~= LWUIBerserkBossRankTabType.TotalPersonalDamage)
  if self.curTabData.tabType == LWUIBerserkBossRankTabType.TotalPersonalDamage then
    if self.isPlayRankAni then
      self.panelAni:Play(personalTotalDamageAniName, 0, 0, 0)
    end
    self.totalPersonalDamageRankPageView:RefreshViewData(self.rankDataDict, self.isPlayRankAni)
    self.isPlayRankAni = false
  elseif 0 < showCount then
    self.rankLoopListView:SetListItemCount(showCount, false, false)
    self.rankLoopListView:RefreshAllShownItem()
  end
  self:RefreshSelfRankView()
end

local function OnGetItemByIndex(self, listView, index)
  local count = table.count(self.rankDataDict)
  index = index + 1
  if index < 1 or count < index then
    return nil
  end
  local item = listView:NewListViewItem("LWUIBerserkBossRankItemRender")
  local script = self.rankScrollContent:GetComponent(item.gameObject.name, LWUIBerserkBossRankItemRender)
  if script == nil then
    NameCount = NameCount + 1
    local objectName = tostring(NameCount)
    item.gameObject.name = objectName
    script = self.rankScrollContent:AddComponent(LWUIBerserkBossRankItemRender, objectName)
  end
  script:SetActive(true)
  local rankType = self:GetRankTypeByRankTabType()
  local rankData = self.rankDataDict[index]
  script:InitData(rankType, rankData, self.curTabData.tabType)
  return item
end

local function ClearRankLoopView(self)
  self.rankScrollContent:RemoveComponents(LWUIBerserkBossRankItemRender)
  self.rankLoopListView:ClearAllItems()
end

local function GetRankTypeByRankTabType(self)
  local rankType = LWUIBerserkBossRankType.Personal
  if self.curTabData then
    if self.curTabData.tabType == LWUIBerserkBossRankTabType.Boss or self.curTabData.tabType == LWUIBerserkBossRankTabType.TotalPersonalDamage then
      rankType = LWUIBerserkBossRankType.Personal
    else
      rankType = LWUIBerserkBossRankType.Alliance
    end
  end
  return rankType
end

local function RefreshSelfRankView(self)
  self.selfRankView:SetActive(true)
  if self.curTabData.tabType == LWUIBerserkBossRankTabType.TotalAllianceDamage then
    local selfAllianceRankInfo = DataCenter.LWBerserkBossManager:GetSelfAllianceRankInfo()
    if selfAllianceRankInfo ~= nil then
      self.selfRankView:InitData(LWUIBerserkBossRankType.Alliance, selfAllianceRankInfo, self.curTabData.tabType)
    end
  else
    local selfRankInfo = DataCenter.LWBerserkBossManager:GetSelfRankInfo()
    if selfRankInfo ~= nil then
      self.selfRankView:InitData(LWUIBerserkBossRankType.Personal, selfRankInfo, self.curTabData.tabType)
    end
  end
end

LWUIBerserkBossRankView.OnCreate = OnCreate
LWUIBerserkBossRankView.OnDestroy = OnDestroy
LWUIBerserkBossRankView.OnEnable = OnEnable
LWUIBerserkBossRankView.OnDisable = OnDisable
LWUIBerserkBossRankView.ComponentDefine = ComponentDefine
LWUIBerserkBossRankView.ComponentDestroy = ComponentDestroy
LWUIBerserkBossRankView.DataDefine = DataDefine
LWUIBerserkBossRankView.DataDestroy = DataDestroy
LWUIBerserkBossRankView.ReInit = ReInit
LWUIBerserkBossRankView.ShowTabView = ShowTabView
LWUIBerserkBossRankView.OnTabItemMoveIn = OnTabItemMoveIn
LWUIBerserkBossRankView.OnTabItemMoveOut = OnTabItemMoveOut
LWUIBerserkBossRankView.RemoveTabScroll = RemoveTabScroll
LWUIBerserkBossRankView.OnTabItemClick = OnTabItemClick
LWUIBerserkBossRankView.OnGetItemByIndex = OnGetItemByIndex
LWUIBerserkBossRankView.GetRankTypeByRankTabType = GetRankTypeByRankTabType
LWUIBerserkBossRankView.RefreshSelfRankView = RefreshSelfRankView
LWUIBerserkBossRankView.RefreshShowCurRankView = RefreshShowCurRankView
LWUIBerserkBossRankView.OnAddListener = OnAddListener
LWUIBerserkBossRankView.OnRemoveListener = OnRemoveListener
LWUIBerserkBossRankView.OnGetBerserkBossRankInfoData = OnGetBerserkBossRankInfoData
LWUIBerserkBossRankView.ClearRankLoopView = ClearRankLoopView
return LWUIBerserkBossRankView
