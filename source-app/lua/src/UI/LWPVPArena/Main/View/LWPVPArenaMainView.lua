local LWPVPArenaMainView = BaseClass("LWPVPArenaMainView", UIBaseView)
local base = UIBaseView
local UIPeakPageWrapper = require("UI.LWPVPArena.Main.Component.Peak.LWPVPArenaPeakPageWrapper")
local UIRewardsPanel = require("UI.LWPVPArena.Main.Component.Peak.LWPVPArenaPeakRewardsPanel")
local UIRecordsPanel = require("UI.LWPVPArena.Main.Component.Peak.LWPVPArenaPeakRecordsPanel")
local UIInfoPanel = require("UI.LWPVPArena.Main.Component.Peak.LWPVPArenaPeakInfoPanel")
local LW3V3ArenaPageWrapper = require("UI.LWPVPArena.Main.Component.Arena3V3.LW3V3ArenaPageWrapper")
local LWNewbieArenaV2PageWrapper = require("UI.LWPVPArena.Main.Component.NewbieArenaV2.LWNewbieArenaV2PageWrapper")
local UINewPeakPage = require("UI.LWPVPArena.Main.Component.NewPeakArena.LWNewPVPArenaPeakPage")
local UINewGalePage = require("UI.LWPVPArena.Main.Component.NewGaleArena.LWNewPVPArenaGalePage")
local Localization = CS.GameEntry.Localization
local PeakRewardsPanelPrefabPath = "Assets/Main/Prefabs/UI/LWPVPArena/panelRewards.prefab"
local PeakRecordPanelPrefabPath = "Assets/Main/Prefabs/UI/LWPVPArena/panelRecords.prefab"
local PeakInfoPanelPrefabPath = "Assets/Main/Prefabs/UI/LWPVPArena/panelInfo.prefab"
local compBook = {
  {
    path = "root/imgTopBg/txtTitle",
    name = "txtTitle",
    type = UIText
  },
  {
    path = "root/tabScroll",
    name = "tabScroll",
    type = UIScrollRect
  },
  {
    path = "root/tabScroll/Viewport/Content/tabPeakArena/tabPeakArena_off",
    name = "tabPeakArenaOff",
    type = UIButton
  },
  {
    path = "root/tabScroll/Viewport/Content/tabPeakArena/tabPeakArena_on",
    name = "tabPeakArenaOn",
    type = UIBaseContainer
  },
  {
    path = "root/tabScroll/Viewport/Content/tabPeakArena/tabPeakArena_off/txtPeakArena_off",
    name = "txtPeakArena_off",
    type = UIText
  },
  {
    path = "root/tabScroll/Viewport/Content/tabPeakArena/tabPeakArena_on/txtPeakArena_on",
    name = "txtPeakArena_on",
    type = UIText
  },
  {
    path = "root/tabScroll/Viewport/Content/tabPeakArena/RedDot1",
    name = "peakArenaRedDot",
    type = UIBaseContainer
  },
  {
    path = "root/tabScroll/Viewport/Content/tabPeakArena/RedDot1/RedDotTxt1",
    name = "peakArenaRedDotTxt",
    type = UIText
  },
  {
    path = "root/tabScroll/Viewport/Content/tabPeakArena",
    name = "tabPeakArena",
    type = UIBaseContainer
  },
  {
    path = "root/btnBack",
    name = "btnBack",
    type = UIButton
  },
  {
    path = "root/pagePeakArena",
    name = "pagePeakArena",
    type = UIPeakPageWrapper
  },
  {
    path = "panelRewards",
    name = "panelRewards",
    type = UIBaseContainer
  },
  {
    path = "panelRecords",
    name = "panelRecords",
    type = UIBaseContainer
  },
  {
    path = "panelInfo",
    name = "panelInfo",
    type = UIBaseContainer
  },
  {
    path = "root/tabScroll/Viewport/Content/tab3V3Arena/tab3V3Arena_off",
    name = "tab3V3ArenaOff",
    type = UIButton
  },
  {
    path = "root/tabScroll/Viewport/Content/tab3V3Arena/tab3V3Arena_on",
    name = "tab3V3ArenaOn",
    type = UIBaseContainer
  },
  {
    path = "root/tabScroll/Viewport/Content/tab3V3Arena/tab3V3Arena_off/txt3V3Arena_off",
    name = "txt3V3Arena_off",
    type = UIText
  },
  {
    path = "root/tabScroll/Viewport/Content/tab3V3Arena/tab3V3Arena_on/txt3V3Arena_on",
    name = "txt3V3Arena_on",
    type = UIText
  },
  {
    path = "root/tabScroll/Viewport/Content/tab3V3Arena/RedDot2",
    name = "arena3V3RedDot",
    type = UIBaseContainer
  },
  {
    path = "root/tabScroll/Viewport/Content/tab3V3Arena/RedDot2/RedDotTxt2",
    name = "arena3V3RedDotTxt",
    type = UIText
  },
  {
    path = "root/tabScroll/Viewport/Content/tab3V3Arena",
    name = "tab3V3Arena",
    type = UIBaseContainer
  },
  {
    path = "root/page3V3Arena",
    name = "page3V3Arena",
    type = LW3V3ArenaPageWrapper
  },
  {
    path = "root/tabScroll/Viewport/Content/tabNewbieArenaV2/tabNewbieArena_off",
    name = "tabNewbieArenaOff",
    type = UIButton
  },
  {
    path = "root/tabScroll/Viewport/Content/tabNewbieArenaV2/tabNewbieArena_on",
    name = "tabNewbieArenaOn",
    type = UIBaseContainer
  },
  {
    path = "root/tabScroll/Viewport/Content/tabNewbieArenaV2/tabNewbieArena_off/txtNewbieArena_off",
    name = "txtNewbieArenaOff",
    type = UIText
  },
  {
    path = "root/tabScroll/Viewport/Content/tabNewbieArenaV2/tabNewbieArena_on/txtNewbieArena_on",
    name = "txtNewbieArenaOn",
    type = UIText
  },
  {
    path = "root/tabScroll/Viewport/Content/tabNewbieArenaV2/RedDot3",
    name = "newbieArenaRedDot",
    type = UIBaseContainer
  },
  {
    path = "root/tabScroll/Viewport/Content/tabNewbieArenaV2/RedDot3/RedDotTxt3",
    name = "newbieArenaRedDotTxt",
    type = UIText
  },
  {
    path = "root/tabScroll/Viewport/Content/tabNewbieArenaV2",
    name = "tabNewbieArena",
    type = UIBaseContainer
  },
  {
    path = "root/pageNewbieArenaV2",
    name = "pageNewbieArena",
    type = LWNewbieArenaV2PageWrapper
  },
  {
    path = "root/imgBg",
    name = "imgBg",
    type = UIBaseComponent
  },
  {
    path = "root/tabScroll/Viewport/Content/tabNewPeakArena/tabNewPeakArena_off",
    name = "tabNewPeakArenaOff",
    type = UIButton
  },
  {
    path = "root/tabScroll/Viewport/Content/tabNewPeakArena/tabNewPeakArena_on",
    name = "tabNewPeakArenaOn",
    type = UIBaseContainer
  },
  {
    path = "root/tabScroll/Viewport/Content/tabNewPeakArena/tabNewPeakArena_off/txtNewPeakArena_off",
    name = "txtNewPeakArena_off",
    type = UIText
  },
  {
    path = "root/tabScroll/Viewport/Content/tabNewPeakArena/tabNewPeakArena_on/txtNewPeakArena_on",
    name = "txtNewPeakArena_on",
    type = UIText
  },
  {
    path = "root/tabScroll/Viewport/Content/tabNewPeakArena/RedDot4",
    name = "newPeakArenaRedDot",
    type = UIBaseContainer
  },
  {
    path = "root/tabScroll/Viewport/Content/tabNewPeakArena/RedDot4/RedDotTxt4",
    name = "newPeakArenaRedDotTxt",
    type = UIText
  },
  {
    path = "root/tabScroll/Viewport/Content/tabNewPeakArena",
    name = "tabNewPeakArena",
    type = UIBaseContainer
  },
  {
    path = "root/pageNewPeakArena",
    name = "pageNewPeakArena",
    type = UINewPeakPage
  },
  {
    path = "root/tabScroll/Viewport/Content/tabNewGaleArena/tabNewGaleArena_off",
    name = "tabNewGaleArenaOff",
    type = UIButton
  },
  {
    path = "root/tabScroll/Viewport/Content/tabNewGaleArena/tabNewGaleArena_on",
    name = "tabNewGaleArenaOn",
    type = UIBaseContainer
  },
  {
    path = "root/tabScroll/Viewport/Content/tabNewGaleArena/tabNewGaleArena_off/txtNewGaleArena_off",
    name = "txtNewGaleArena_off",
    type = UIText
  },
  {
    path = "root/tabScroll/Viewport/Content/tabNewGaleArena/tabNewGaleArena_on/txtNewGaleArena_on",
    name = "txtNewGaleArena_on",
    type = UIText
  },
  {
    path = "root/tabScroll/Viewport/Content/tabNewGaleArena/RedDot5",
    name = "newGaleArenaRedDot",
    type = UIBaseContainer
  },
  {
    path = "root/tabScroll/Viewport/Content/tabNewGaleArena/RedDot5/RedDotTxt5",
    name = "newGaleArenaRedDotTxt",
    type = UIText
  },
  {
    path = "root/tabScroll/Viewport/Content/tabNewGaleArena",
    name = "tabNewGaleArena",
    type = UIBaseContainer
  },
  {
    path = "root/pageNewGaleArenaRoot",
    name = "pageNewGaleArena",
    type = UINewGalePage
  }
}

function LWPVPArenaMainView:RequestBaseInfo()
  SFSNetwork.SendMessage(MsgDefines.GetPVPArenaInfo)
end

function LWPVPArenaMainView:CheckTabsValid()
  self.tabsValid = {}
  self.tabsValid[PVPArenaType.PeakArena] = DataCenter.LWPVPArenaManager.state ~= PVPArenaState.Invalide
  self.tabsValid[PVPArenaType.Arena3V3] = DataCenter.LW3V3ArenaManager.state ~= PVPArenaState.Invalide
  self.tabsValid[PVPArenaType.NewbieArenaV2] = DataCenter.LWNewbieArenaV2Manager:GetState() ~= ActivityArenaState.None
  self.tabsValid[PVPArenaType.NewPeakArena] = DataCenter.NewPeakArenaManager.state ~= NewPeakArenaState.Invalide
  self.tabsValid[PVPArenaType.NewGaleArena] = DataCenter.NewGaleArenaManager.state ~= NewPeakArenaState.Invalide
  for k, v in pairs(self.tabs) do
    if v then
      v:SetActive(self.tabsValid[k])
    end
  end
end

function LWPVPArenaMainView:OnCreate()
  base.OnCreate(self)
  self.arenaCompletedTab = nil
  self:ComponentDefine()
  local gotoTab, pagePara1 = self:GetUserData()
  self:CheckTabsValid()
  if gotoTab == nil then
    if DataCenter.NewPeakArenaManager.arenaMainGotoTab then
      gotoTab = DataCenter.NewPeakArenaManager.arenaMainGotoTab
    else
      local arena3V3State = DataCenter.LW3V3ArenaManager.state
      local newPeakArenaState = DataCenter.NewPeakArenaManager.state
      local peakArenaState = DataCenter.LWPVPArenaManager.state
      if newPeakArenaState ~= NewPeakArenaState.Invalide then
        gotoTab = PVPArenaType.NewPeakArena
      elseif peakArenaState == PVPArenaState.Open then
        gotoTab = PVPArenaType.PeakArena
      elseif arena3V3State == PVPArenaState.Open then
        gotoTab = PVPArenaType.Arena3V3
      end
    end
  end
  if not self.tabsValid[gotoTab] then
    for k, v in pairs(self.tabsValid) do
      if v then
        gotoTab = k
        break
      end
    end
  end
  local fullNum = 0
  local curNum = 0
  for i, v in ipairs(self.tabList) do
    if self.tabsValid[v] then
      fullNum = fullNum + 1
    end
    if v == gotoTab then
      curNum = fullNum
    end
  end
  if 1 < fullNum and 0 < curNum then
    self.tabScroll:SetHorizontalNormalizedPosition((curNum - 1) / (fullNum - 1))
  end
  self:RequestBaseInfo()
  self:SwitchTab(gotoTab, pagePara1, true)
  self:RefreshRedDot()
end

function LWPVPArenaMainView:OnDestroy()
  self.arenaCompletedTab = nil
  self.__waitingForMsg = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWPVPArenaMainView:ComponentDestroy()
  self:OnDestroyPeakPanelRewards()
  self:OnDestroyPeakPanelRecords()
  self:OnDestroyPeakPanelInfos()
  self:ClearCompsByBook(compBook)
end

function LWPVPArenaMainView:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.txtTitle:SetText(Localization:GetString("372255"))
  self.txtPeakArena_off:SetText(Localization:GetString("801102"))
  self.txtPeakArena_on:SetText(Localization:GetString("801102"))
  local newbieArenaV2Info = DataCenter.LWNewbieArenaV2Manager.info
  if newbieArenaV2Info ~= nil then
    local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(newbieArenaV2Info.id)
    if activityData ~= nil then
      local tabName = Localization:GetString(activityData.name)
      self.txtNewbieArenaOff:SetText(tabName)
      self.txtNewbieArenaOn:SetText(tabName)
    end
  end
  self.txtNewPeakArena_off:SetText(Localization:GetString("new_arena_name_1"))
  self.txtNewPeakArena_on:SetText(Localization:GetString("new_arena_name_1"))
  self.txtNewGaleArena_off:SetText(Localization:GetString("gale_arena_name_1"))
  self.txtNewGaleArena_on:SetText(Localization:GetString("gale_arena_name_1"))
  self.panelRewards:SetActive(false)
  self.panelRecords:SetActive(false)
  self.btnBack:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.tabPeakArenaOff:SetOnClick(function()
    self:SwitchTab(PVPArenaType.PeakArena)
  end)
  self.tab3V3ArenaOff:SetOnClick(function()
    self:SwitchTab(PVPArenaType.Arena3V3)
  end)
  self.tabNewbieArenaOff:SetOnClick(function()
    self:SwitchTab(PVPArenaType.NewbieArenaV2)
  end)
  self.tabNewPeakArenaOff:SetOnClick(function()
    self:SwitchTab(PVPArenaType.NewPeakArena)
  end)
  self.tabNewGaleArenaOff:SetOnClick(function()
    self:SwitchTab(PVPArenaType.NewGaleArena)
  end)
  self.tabList = {
    [1] = PVPArenaType.NewbieArenaV2,
    [2] = PVPArenaType.NewPeakArena,
    [3] = PVPArenaType.NewGaleArena,
    [4] = PVPArenaType.PeakArena,
    [5] = PVPArenaType.Arena3V3
  }
  self.tabs = {
    [PVPArenaType.PeakArena] = self.tabPeakArena,
    [PVPArenaType.Arena3V3] = self.tab3V3Arena,
    [PVPArenaType.NewbieArenaV2] = self.tabNewbieArena,
    [PVPArenaType.NewPeakArena] = self.tabNewPeakArena,
    [PVPArenaType.NewGaleArena] = self.tabNewGaleArena
  }
  self.tabsOn = {
    [PVPArenaType.PeakArena] = self.tabPeakArenaOn,
    [PVPArenaType.Arena3V3] = self.tab3V3ArenaOn,
    [PVPArenaType.NewbieArenaV2] = self.tabNewbieArenaOn,
    [PVPArenaType.NewPeakArena] = self.tabNewPeakArenaOn,
    [PVPArenaType.NewGaleArena] = self.tabNewGaleArenaOn
  }
  self.tabsOff = {
    [PVPArenaType.PeakArena] = self.tabPeakArenaOff,
    [PVPArenaType.Arena3V3] = self.tab3V3ArenaOff,
    [PVPArenaType.NewbieArenaV2] = self.tabNewbieArenaOff,
    [PVPArenaType.NewPeakArena] = self.tabNewPeakArenaOff,
    [PVPArenaType.NewGaleArena] = self.tabNewGaleArenaOff
  }
  self.pages = {
    [PVPArenaType.PeakArena] = self.pagePeakArena,
    [PVPArenaType.Arena3V3] = self.page3V3Arena,
    [PVPArenaType.NewbieArenaV2] = self.pageNewbieArena,
    [PVPArenaType.NewPeakArena] = self.pageNewPeakArena,
    [PVPArenaType.NewGaleArena] = self.pageNewGaleArena
  }
end

function LWPVPArenaMainView:SwitchTab(tab, pagePara1, isInit)
  if self.currTab == tab then
    return
  end
  self.currTab = tab
  DataCenter.NewPeakArenaManager.arenaMainGotoTab = tab
  for k, v in pairs(self.tabsOn) do
    v:SetActive(k == tab)
  end
  for k, v in pairs(self.tabsOff) do
    v:SetActive(k ~= tab)
  end
  for k, v in pairs(self.pages) do
    v:SetActive(k == tab)
    if k == tab then
      self.imgBg:SetActive(true)
      v:Init(pagePara1, isInit)
    end
  end
end

function LWPVPArenaMainView:Refresh(arenaData)
  self.pagePeakArena:Refresh(arenaData)
end

function LWPVPArenaMainView:OnGetArenaRewardPreview(rewardsData)
  self.panelRecords:SetActive(false)
  self.panelRewards:SetActive(true)
  self:OnLoadPeakPanelRewards(rewardsData)
end

function LWPVPArenaMainView:OnGetArenaRecords(recordsData)
  self.panelRewards:SetActive(false)
  self.panelRecords:SetActive(true)
  self:OnLoadPeakPanelRecords(recordsData)
end

function LWPVPArenaMainView:Challenge(otherUid)
  if self.__waitingForMsg then
    return
  end
  if DataCenter.LWPVPArenaManager.battleTimes <= 0 then
    UIUtil.ShowTipsId(801110)
  else
    self.__waitingForMsg = true
    SFSNetwork.SendMessage(MsgDefines.GetPVPArenaBattlePreivew, otherUid)
  end
end

function LWPVPArenaMainView:ShowInfo(titleID, contentID)
  self.panelInfo:SetActive(true)
  self:OnLoadPeakPanelInfos(titleID, contentID)
end

function LWPVPArenaMainView:CloseAllPopups()
  self.panelInfo:SetActive(false)
  self.panelRewards:SetActive(false)
  self.panelRecords:SetActive(false)
end

function LWPVPArenaMainView:OnArenaInfoUpdate()
  self:RefreshRedDot()
end

function LWPVPArenaMainView:OnArenaPageInitFinish(pvpArenaType)
  self.arenaCompletedTab = pvpArenaType
end

function LWPVPArenaMainView:RefreshRedDot()
  local redDotCount = 0
  if DataCenter.LWPVPArenaManager.state == PVPArenaState.Open and DataCenter.LWPVPArenaManager:CanChallange() then
    if 0 < DataCenter.LWPVPArenaManager.battleTimes then
      redDotCount = DataCenter.LWPVPArenaManager.battleTimes
    end
    if 0 < DataCenter.LWPVPArenaManager.defLoseTimes then
      redDotCount = redDotCount + DataCenter.LWPVPArenaManager.defLoseTimes
    end
  end
  self.peakArenaRedDot:SetActive(0 < redDotCount)
  self.peakArenaRedDotTxt:SetText(redDotCount)
  redDotCount = DataCenter.LW3V3ArenaManager:GetRedDotCount()
  self.arena3V3RedDot:SetActive(0 < redDotCount)
  self.arena3V3RedDotTxt:SetText(redDotCount)
  redDotCount = DataCenter.NewPeakArenaManager:GetRedDotCount()
  self.newPeakArenaRedDot:SetActive(0 < redDotCount)
  self.newPeakArenaRedDotTxt:SetText(redDotCount)
  redDotCount = DataCenter.NewGaleArenaManager:GetRedDotCount()
  self.newGaleArenaRedDot:SetActive(0 < redDotCount)
  self.newGaleArenaRedDotTxt:SetText(redDotCount)
  redDotCount = DataCenter.LWNewbieArenaV2Manager:GetRedDotCount()
  self.newbieArenaRedDot:SetActive(0 < redDotCount)
  self.newbieArenaRedDotTxt:SetText(redDotCount)
end

function LWPVPArenaMainView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ArenaRefreshRedPoint, self.RefreshRedDot)
  self:AddUIListener(EventId.PVPArenaInfoUpdate, self.OnArenaInfoUpdate)
  self:AddUIListener(EventId.ActivityArenaInfoUpdate, self.OnArenaInfoUpdate)
  self:AddUIListener(EventId.GF_enter_pvp_arena, self.OnArenaPageInitFinish)
end

function LWPVPArenaMainView:OnRemoveListener()
  self:RemoveUIListener(EventId.ArenaRefreshRedPoint, self.RefreshRedDot)
  self:RemoveUIListener(EventId.PVPArenaInfoUpdate, self.OnArenaInfoUpdate)
  self:RemoveUIListener(EventId.ActivityArenaInfoUpdate, self.OnArenaInfoUpdate)
  self:RemoveUIListener(EventId.GF_enter_pvp_arena, self.OnArenaPageInitFinish)
  base.OnRemoveListener(self)
end

function LWPVPArenaMainView:OnDestroyPeakPanelRewards()
  if self.peakRewardsPanelReq then
    self.panelRewards:RemoveComponents(UIRewardsPanel)
    self:GameObjectDestroy(self.peakRewardsPanelReq)
    self.peakRewardsPanelReq = nil
  end
end

function LWPVPArenaMainView:OnLoadPeakPanelRewards(rewardsData)
  if self.peakRewardsPanelReq == nil then
    self.peakRewardsPanelReq = self:GameObjectInstantiateAsync(PeakRewardsPanelPrefabPath, function(request)
      local go = request.gameObject
      go.transform:SetParent(self.panelRewards.transform)
      go.transform:Set_localScale(1, 1, 1)
      go.transform:Set_localPosition(0, 0, 0)
      go.transform:Set_anchorMin(0, 0)
      go.transform:Set_anchorMax(1, 1)
      go.transform:Set_offsetMin(0, 0)
      go.transform:Set_offsetMax(0, 0)
      self.peakArenaRewardsPanel = self.panelRewards:AddComponent(UIRewardsPanel, go.name)
      self.peakArenaRewardsPanel:SetActive(true)
      self.peakArenaRewardsPanel:Refresh(rewardsData)
    end)
  elseif self.peakArenaRewardsPanel then
    self.peakArenaRewardsPanel:Refresh(rewardsData)
  end
end

function LWPVPArenaMainView:OnDestroyPeakPanelRecords()
  if self.peakRecordsPanelReq then
    self.panelRecords:RemoveComponents(UIRecordsPanel)
    self:GameObjectDestroy(self.peakRecordsPanelReq)
    self.peakRecordsPanelReq = nil
  end
end

function LWPVPArenaMainView:OnLoadPeakPanelRecords(recordsData)
  if self.peakRecordsPanelReq == nil then
    self.peakRecordsPanelReq = self:GameObjectInstantiateAsync(PeakRecordPanelPrefabPath, function(request)
      local go = request.gameObject
      go.transform:SetParent(self.panelRecords.transform)
      go.transform:Set_localScale(1, 1, 1)
      go.transform:Set_localPosition(0, 0, 0)
      go.transform:Set_anchorMin(0, 0)
      go.transform:Set_anchorMax(1, 1)
      go.transform:Set_offsetMin(0, 0)
      go.transform:Set_offsetMax(0, 0)
      self.peakArenaRecordsPanel = self.panelRecords:AddComponent(UIRecordsPanel, go.name)
      self.peakArenaRecordsPanel:SetActive(true)
      self.peakArenaRecordsPanel:Refresh(recordsData)
      self.peakArenaRecordsPanel:RefreshChallengeTimes(DataCenter.LWPVPArenaManager.battleTimes, DataCenter.LWPVPArenaManager.max_limit)
    end)
  elseif self.peakArenaRecordsPanel then
    self.peakArenaRecordsPanel:Refresh(recordsData)
    self.peakArenaRecordsPanel:RefreshChallengeTimes(DataCenter.LWPVPArenaManager.battleTimes, DataCenter.LWPVPArenaManager.max_limit)
  end
end

function LWPVPArenaMainView:OnDestroyPeakPanelInfos()
  if self.peakInfosPanelReq then
    self.panelInfo:RemoveComponents(UIInfoPanel)
    self:GameObjectDestroy(self.peakInfosPanelReq)
    self.peakInfosPanelReq = nil
  end
end

function LWPVPArenaMainView:OnLoadPeakPanelInfos(titleID, contentID)
  if self.peakInfosPanelReq == nil then
    self.peakInfosPanelReq = self:GameObjectInstantiateAsync(PeakInfoPanelPrefabPath, function(request)
      local go = request.gameObject
      go.transform:SetParent(self.panelInfo.transform)
      go.transform:Set_localScale(1, 1, 1)
      go.transform:Set_localPosition(0, 0, 0)
      go.transform:Set_anchorMin(0, 0)
      go.transform:Set_anchorMax(1, 1)
      go.transform:Set_offsetMin(0, 0)
      go.transform:Set_offsetMax(0, 0)
      self.peakArenaInfosPanel = self.panelInfo:AddComponent(UIInfoPanel, go.name)
      self.peakArenaInfosPanel:SetActive(true)
      self.peakArenaInfosPanel:Refresh(titleID, contentID)
    end)
  elseif self.peakArenaInfosPanel then
    self.peakArenaInfosPanel:Refresh(titleID, contentID)
  end
end

return LWPVPArenaMainView
