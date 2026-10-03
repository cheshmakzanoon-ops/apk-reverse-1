local base = UIBaseView
local LWSeasonBossLoginRecordView = BaseClass("LWSeasonBossLoginRecordView", base)
local LWSeasonBossLoginRecordItemRender = require("UI.LWSeason1.LWSeasonBossLoginRecord.Component.LWSeasonBossLoginRecordItemRender")
local LWSeasonBossLoginRecordTabItemRender = require("UI.LWSeason1.LWSeasonBossLoginRecord.Component.LWSeasonBossLoginRecordTabItemRender")
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
  SFSNetwork.SendMessage(MsgDefines.GetSeasonVirusAttackRecord)
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
  self:ShowTabView()
  self:OnTabItemClick(1)
end

local function SetShowState(self, hasData)
  self.emptyText:SetActive(not hasData)
  self.highestRecordContent:SetActive(hasData)
  self.tipsText:SetActive(hasData)
  self.recordScrollView:SetActive(hasData)
end

local function GetTabViewData(self)
  if table.count(self.tabViewDataList) == 0 then
    local actBoss, seasonBoss = DataCenter.LWSeasonBossLoginDataManager:GetBossData()
    if actBoss ~= nil then
      local bossName = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.Monster), actBoss.monsterId, "name")
      table.insert(self.tabViewDataList, {
        title = bossName,
        activityId = DataCenter.ActBossDataManager.activityId
      })
    end
    if seasonBoss ~= nil then
      local bossName = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.Monster), seasonBoss.monsterId, "name")
      table.insert(self.tabViewDataList, {
        title = bossName,
        activityId = DataCenter.LWSeasonBossLoginDataManager.activityId
      })
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
  local itemRender = self.tabScrollView:AddComponent(LWSeasonBossLoginRecordTabItemRender, itemObj)
  if itemRender ~= nil then
    itemRender:InitData(index, self.tabViewDataList[index], self.curTabIndex)
  end
end

local function OnTabItemMoveOut(self, itemObj, index)
  self.tabScrollView:RemoveComponent(itemObj.name, LWSeasonBossLoginRecordTabItemRender)
end

local function RemoveTabScroll(self)
  self.tabScrollView:ClearCells()
  self.tabScrollView:RemoveComponents(LWSeasonBossLoginRecordTabItemRender)
end

local function OnTabItemClick(self, index)
  if self.curTabIndex == nil or self.curTabIndex ~= index then
    self.curTabIndex = index
  else
    return
  end
  self:ShowCurTabTypeBattleRecordView()
end

local function ShowCurTabTypeBattleRecordView(self)
  self.highestBattleReportData = nil
  self.battleReportViewList = {}
  local curTabActivityId = self.tabViewDataList[self.curTabIndex].activityId
  local battleReportList = DataCenter.LWSeasonBossLoginDataManager:GetBossBattleReportDataByActId(curTabActivityId) or {}
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
  local itemRender = self.recordScrollView:AddComponent(LWSeasonBossLoginRecordItemRender, itemObj)
  if itemRender ~= nil then
    itemRender:InitData(index, self.battleReportViewList[index])
  end
end

local function OnRecordItemMoveOut(self, itemObj, index)
  self.recordScrollView:RemoveComponent(itemObj.name, LWSeasonBossLoginRecordItemRender)
end

local function RemoveRecordScroll(self)
  self.recordScrollView:ClearCells()
  self.recordScrollView:RemoveComponents(LWSeasonBossLoginRecordItemRender)
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

LWSeasonBossLoginRecordView.OnCreate = OnCreate
LWSeasonBossLoginRecordView.OnDestroy = OnDestroy
LWSeasonBossLoginRecordView.OnEnable = OnEnable
LWSeasonBossLoginRecordView.OnDisable = OnDisable
LWSeasonBossLoginRecordView.ComponentDefine = ComponentDefine
LWSeasonBossLoginRecordView.ComponentDestroy = ComponentDestroy
LWSeasonBossLoginRecordView.DataDefine = DataDefine
LWSeasonBossLoginRecordView.DataDestroy = DataDestroy
LWSeasonBossLoginRecordView.OnAddListener = OnAddListener
LWSeasonBossLoginRecordView.OnRemoveListener = OnRemoveListener
LWSeasonBossLoginRecordView.OnRefreshActBossBattleReportView = OnRefreshActBossBattleReportView
LWSeasonBossLoginRecordView.ReInit = ReInit
LWSeasonBossLoginRecordView.SetShowState = SetShowState
LWSeasonBossLoginRecordView.GetTabViewData = GetTabViewData
LWSeasonBossLoginRecordView.ShowTabView = ShowTabView
LWSeasonBossLoginRecordView.OnTabItemMoveIn = OnTabItemMoveIn
LWSeasonBossLoginRecordView.OnTabItemMoveOut = OnTabItemMoveOut
LWSeasonBossLoginRecordView.RemoveTabScroll = RemoveTabScroll
LWSeasonBossLoginRecordView.OnTabItemClick = OnTabItemClick
LWSeasonBossLoginRecordView.ShowCurTabTypeBattleRecordView = ShowCurTabTypeBattleRecordView
LWSeasonBossLoginRecordView.OnRecordItemMoveIn = OnRecordItemMoveIn
LWSeasonBossLoginRecordView.OnRecordItemMoveOut = OnRecordItemMoveOut
LWSeasonBossLoginRecordView.RemoveRecordScroll = RemoveRecordScroll
LWSeasonBossLoginRecordView.ShowHighestRecordView = ShowHighestRecordView
LWSeasonBossLoginRecordView.RemoveHighestRecordHero = RemoveHighestRecordHero
return LWSeasonBossLoginRecordView
