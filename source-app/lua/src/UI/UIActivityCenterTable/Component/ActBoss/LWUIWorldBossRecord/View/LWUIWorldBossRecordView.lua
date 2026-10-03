local base = UIBaseView
local LWUIWorldBossRecordView = BaseClass("LWUIWorldBossRecordView", base)
local LWUIWorldBossRecordItemRender = require("UI.UIActivityCenterTable.Component.ActBoss.LWUIWorldBossRecord.Component.LWUIWorldBossRecordItemRender")
local LWUIWorldBossRecordTabItemRender = require("UI.UIActivityCenterTable.Component.ActBoss.LWUIWorldBossRecord.Component.LWUIWorldBossRecordTabItemRender")
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local panelBtn_path = "panel"
local titleText_path = "PopUpContent/TitleText"
local closeBtn_path = "PopUpContent/CloseBtn"
local tabScrollView_path = "PopUpContent/TopContent/TabScrollView"
local highestRecordTimeText_path = "PopUpContent/HighestRecordContent/HighestRecordTimeText"
local highestRecordDamageText_path = "PopUpContent/HighestRecordContent/HighestRecordDamageText"
local highestRecordTipsText_path = "PopUpContent/HighestRecordContent/Mjc_saiji2_paihangbang_paiming_bg_jian/HighestRecordTipsText"
local highestRecordHeroContent_path = "PopUpContent/HighestRecordContent/HighestRecordHeroContent"
local uiHeroCellObj_path = "PopUpContent/HighestRecordContent/UIHeroCellSmall"
local playBtn_path = "PopUpContent/HighestRecordContent/PlayBtn"
local tipsText_path = "PopUpContent/TipsText"
local recordScrollView_path = "PopUpContent/RecordScrollView"
local emptyText_path = "PopUpContent/EmptyText"
local highestRecordContent_path = "PopUpContent/HighestRecordContent"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  SFSNetwork.SendMessage(MsgDefines.ActBossBattleReport)
  self:ReInit()
end

local function OnDestroy(self)
  self:RemoveTabScroll()
  self:RemoveRecordScroll()
  self:RemoveHighestRecordHero()
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
  self.highestRecordTimeText = self:AddComponent(UIText, highestRecordTimeText_path)
  self.highestRecordDamageText = self:AddComponent(UIText, highestRecordDamageText_path)
  self.highestRecordTipsText = self:AddComponent(UIText, highestRecordTipsText_path)
  self.highestRecordHeroContent = self:AddComponent(UIBaseContainer, highestRecordHeroContent_path)
  self.uiHeroCellObj = self:AddComponent(UIBaseContainer, uiHeroCellObj_path)
  self.playBtn = self:AddComponent(UIButton, playBtn_path)
  self.tipsText = self:AddComponent(UIText, tipsText_path)
  self.recordScrollView = self:AddComponent(UIScrollView, recordScrollView_path)
  self.emptyText = self:AddComponent(UIText, emptyText_path)
  self.highestRecordContent = self:AddComponent(UIBaseContainer, highestRecordContent_path)
  self.titleText:SetLocalText("wantedBoss_record_title")
  self.tipsText:SetLocalText("wantedBoss_record_lastXtimes_title", LuaEntry.DataConfig:TryGetNum("world_boss", "k5", 5))
  self.highestRecordTipsText:SetLocalText("wantedBoss_record_highest")
  self.emptyText:SetLocalText("wantedBoss_record_empty")
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.panelBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.playBtn:SetOnClick(function()
    if self.highestBattleReportData then
      local isAddressMode = BattleReportUtil.IsAddressMode(self.highestBattleReportData.reportAddress)
      local address = self.highestBattleReportData.reportAddress or ""
      BattleReportUtil.Create(self.highestBattleReportData.reportId, PVEEnterType.Default, true, isAddressMode, address, BattleReportPreviewEnterType.ActWorldBossBattleRecord)
    end
  end)
  self.tabScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnTabItemMoveIn(itemObj, index)
  end)
  self.tabScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnTabItemMoveOut(itemObj, index)
  end)
  self.recordScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRecordItemMoveIn(itemObj, index)
  end)
  self.recordScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRecordItemMoveOut(itemObj, index)
  end)
  self.heroCellObj = self.transform:Find(uiHeroCellObj_path).gameObject
  self.heroCellObj:GameObjectCreatePool()
end

local function ComponentDestroy(self)
  self.panelBtn = nil
  self.titleText = nil
  self.closeBtn = nil
  self.tabScrollView = nil
  self.highestRecordTimeText = nil
  self.highestRecordDamageText = nil
  self.highestRecordTipsText = nil
  self.highestRecordHeroContent = nil
  self.uiHeroCellObj = nil
  self.playBtn = nil
  self.tipsText = nil
  self.recordScrollView = nil
  self.emptyText = nil
  self.highestRecordContent = nil
  self.heroCellObj = nil
end

local function DataDefine(self)
  self.curTabIndex = 1
  self.tabViewDataList = {}
  self.battleReportViewList = {}
  self.highestBattleReportData = nil
end

local function DataDestroy(self)
  self.curTabIndex = nil
  self.tabViewDataList = nil
  self.battleReportViewList = nil
  self.highestBattleReportData = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshActBossBattleReportData, self.OnRefreshActBossBattleReportView)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshActBossBattleReportData, self.OnRefreshActBossBattleReportView)
  base.OnRemoveListener(self)
end

local function OnRefreshActBossBattleReportView(self)
  self:ShowCurTabTypeBattleRecordView()
end

local function ReInit(self)
  self:GetTabViewData()
  self.curTabIndex = 1
  local tabCount = table.count(self.tabViewDataList)
  for i = 1, tabCount do
    local activityId = self.tabViewDataList[i]
    local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.WorldBoss.Type)
    if table.count(actList) > 0 then
      local actData = actList[1]
      if tonumber(actData.id) == activityId then
        self.curTabIndex = i
        break
      end
    end
  end
  self:ShowTabView()
  self:OnTabItemClick(self.curTabIndex)
end

local function SetShowState(self, hasData)
  self.emptyText:SetActive(not hasData)
  self.highestRecordContent:SetActive(hasData)
  self.tipsText:SetActive(hasData)
  self.recordScrollView:SetActive(hasData)
end

local function GetTabViewData(self)
  if table.count(self.tabViewDataList) == 0 then
    local tabStr = LuaEntry.DataConfig:TryGetStr("world_boss", "k4")
    if not string.IsNullOrEmpty(tabStr) then
      local tabArr = string.split(tabStr, ";")
      for i = 1, table.count(tabArr) do
        table.insert(self.tabViewDataList, tonumber(tabArr[i]))
      end
    end
  end
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
  local itemRender = self.tabScrollView:AddComponent(LWUIWorldBossRecordTabItemRender, itemObj)
  if itemRender ~= nil then
    itemRender:InitData(index, self.tabViewDataList[index], self.curTabIndex)
  end
end

local function OnTabItemMoveOut(self, itemObj, index)
  self.tabScrollView:RemoveComponent(itemObj.name, LWUIWorldBossRecordTabItemRender)
end

local function RemoveTabScroll(self)
  self.tabScrollView:ClearCells()
  self.tabScrollView:RemoveComponents(LWUIWorldBossRecordTabItemRender)
end

local function OnTabItemClick(self, index)
  self.curTabIndex = index
  self:ShowCurTabTypeBattleRecordView()
end

local function ShowCurTabTypeBattleRecordView(self)
  self.highestBattleReportData = nil
  self.battleReportViewList = {}
  local curTabActivityId = self.tabViewDataList[self.curTabIndex]
  local battleReportList = DataCenter.ActBossDataManager:GetBossBattleReportDataByActId(curTabActivityId)
  local battleReportCount = table.count(battleReportList)
  self:SetShowState(0 < battleReportCount)
  if 0 < battleReportCount then
    for i = 1, battleReportCount do
      if i == 1 then
        self.highestBattleReportData = battleReportList[i]
      else
        table.insert(self.battleReportViewList, battleReportList[i])
      end
    end
  end
  self:ShowHighestRecordView()
  local viewCount = table.count(self.battleReportViewList)
  if 0 < viewCount then
    self:RemoveRecordScroll()
    self.recordScrollView:SetTotalCount(viewCount)
    self.recordScrollView:RefillCells()
  end
end

local function OnRecordItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local itemRender = self.recordScrollView:AddComponent(LWUIWorldBossRecordItemRender, itemObj)
  if itemRender ~= nil then
    itemRender:InitData(index, self.battleReportViewList[index])
  end
end

local function OnRecordItemMoveOut(self, itemObj, index)
  self.recordScrollView:RemoveComponent(itemObj.name, LWUIWorldBossRecordItemRender)
end

local function RemoveRecordScroll(self)
  self.recordScrollView:ClearCells()
  self.recordScrollView:RemoveComponents(LWUIWorldBossRecordItemRender)
end

local function ShowHighestRecordView(self)
  if self.highestBattleReportData then
    local _strTime = UITimeManager:GetInstance():TimeStampToTimeForLocal(self.highestBattleReportData.time)
    self.highestRecordTimeText:SetText(_strTime)
    self.highestRecordDamageText:SetText(string.GetFormattedSeparatorNum(self.highestBattleReportData.damage))
    self:RemoveHighestRecordHero()
    for i = 1, table.count(self.highestBattleReportData.heroList) do
      local armyHeroInfo = self.highestBattleReportData.heroList[i]
      local goObj = self.heroCellObj:GameObjectSpawn(self.highestRecordHeroContent.transform)
      goObj.name = "item_" .. i
      goObj:SetActive(true)
      local itemRender = self.highestRecordHeroContent:AddComponent(UIHeroCellSmall, goObj.name)
      itemRender:InitWithConfigId(armyHeroInfo.heroId, armyHeroInfo.heroQuality, armyHeroInfo.heroLevel, armyHeroInfo.rankLv, armyHeroInfo.weaponLevel, armyHeroInfo.awakenLv, armyHeroInfo.heroSkinId)
    end
  end
end

local function RemoveHighestRecordHero(self)
  self.highestRecordHeroContent:RemoveComponents(UIHeroCellSmall)
  self.heroCellObj:GameObjectRecycleAll()
end

LWUIWorldBossRecordView.OnCreate = OnCreate
LWUIWorldBossRecordView.OnDestroy = OnDestroy
LWUIWorldBossRecordView.OnEnable = OnEnable
LWUIWorldBossRecordView.OnDisable = OnDisable
LWUIWorldBossRecordView.ComponentDefine = ComponentDefine
LWUIWorldBossRecordView.ComponentDestroy = ComponentDestroy
LWUIWorldBossRecordView.DataDefine = DataDefine
LWUIWorldBossRecordView.DataDestroy = DataDestroy
LWUIWorldBossRecordView.OnAddListener = OnAddListener
LWUIWorldBossRecordView.OnRemoveListener = OnRemoveListener
LWUIWorldBossRecordView.OnRefreshActBossBattleReportView = OnRefreshActBossBattleReportView
LWUIWorldBossRecordView.ReInit = ReInit
LWUIWorldBossRecordView.SetShowState = SetShowState
LWUIWorldBossRecordView.GetTabViewData = GetTabViewData
LWUIWorldBossRecordView.ShowTabView = ShowTabView
LWUIWorldBossRecordView.OnTabItemMoveIn = OnTabItemMoveIn
LWUIWorldBossRecordView.OnTabItemMoveOut = OnTabItemMoveOut
LWUIWorldBossRecordView.RemoveTabScroll = RemoveTabScroll
LWUIWorldBossRecordView.OnTabItemClick = OnTabItemClick
LWUIWorldBossRecordView.ShowCurTabTypeBattleRecordView = ShowCurTabTypeBattleRecordView
LWUIWorldBossRecordView.OnRecordItemMoveIn = OnRecordItemMoveIn
LWUIWorldBossRecordView.OnRecordItemMoveOut = OnRecordItemMoveOut
LWUIWorldBossRecordView.RemoveRecordScroll = RemoveRecordScroll
LWUIWorldBossRecordView.ShowHighestRecordView = ShowHighestRecordView
LWUIWorldBossRecordView.RemoveHighestRecordHero = RemoveHighestRecordHero
return LWUIWorldBossRecordView
