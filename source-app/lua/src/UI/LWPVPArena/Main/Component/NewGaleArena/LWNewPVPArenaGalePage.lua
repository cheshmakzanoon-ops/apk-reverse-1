local LWNewPVPArenaGalePage = BaseClass("LWNewPVPArenaGalePage", UIBaseContainer)
local base = UIBaseContainer
local NewGaleArena = require("UI.LWPVPArena.Main.Component.NewGaleArena.NewGaleArena")
local NewGaleArenaPrefabPath = "Assets/Main/Prefabs/NewGaleArena/NewGaleArena.prefab"
local NewGaleArenaPreview = require("UI.LWPVPArena.Main.Component.NewGaleArena.NewGaleArenaPreview")
local NewGaleArenaPreviewPrefabPath = "Assets/Main/Prefabs/NewGaleArena/NewGaleArenaPreView.prefab"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
end

local function ComponentDestroy(self)
  self:ClearAsyncGameObject()
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  self:AddUIListener(EventId.NewGaleArenaInfoRefresh, self.Refresh)
  self:AddUIListener(EventId.NewGaleArenaGetRankList, self.RefreshPage)
  self:AddUIListener(EventId.OnPassDay, self.OnPassDay)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.NewGaleArenaInfoRefresh, self.Refresh)
  self:RemoveUIListener(EventId.NewGaleArenaGetRankList, self.RefreshPage)
  self:RemoveUIListener(EventId.OnPassDay, self.OnPassDay)
end

local function Init(self, pagePara1, isInit)
  if self.holder.imgBg then
    self.holder.imgBg:SetActive(false)
  end
  self.pagePara1 = pagePara1
  self:Refresh(isInit)
end

local function Refresh(self, isInit)
  if not isInit and DataCenter.NewGaleArenaManager.state ~= NewPeakArenaState.FirstPreview then
    SFSNetwork.SendMessage(MsgDefines.GaleArenaRankList)
    return
  end
  if DataCenter.NewGaleArenaManager.state == NewPeakArenaState.FirstPreview or DataCenter.NewGaleArenaManager.rankData then
    self:RefreshPage()
  end
end

local function RefreshPage(self)
  local state = DataCenter.NewGaleArenaManager.state
  if state == NewPeakArenaState.FirstPreview or state == NewPeakArenaState.Preview or state == NewPeakArenaState.Finshed or DataCenter.NewGaleArenaManager.rankData.curRank == 0 or DataCenter.NewGaleArenaManager.rankData.players == nil then
    if self.NewGaleArena then
      self.NewGaleArena:SetActive(false)
    end
    if self.previewReq == nil then
      self.previewReq = self:GameObjectInstantiateAsync(NewGaleArenaPreviewPrefabPath, function(request)
        local go = request.gameObject
        go.transform:SetParent(self.transform)
        go.transform:Set_localScale(1, 1, 1)
        go.transform:Set_localPosition(0, 0, 0)
        go.transform:Set_anchorMin(0, 0)
        go.transform:Set_anchorMax(1, 1)
        go.transform:Set_offsetMin(0, 0)
        go.transform:Set_offsetMax(0, 0)
        self.NewGaleArenaPreview = self:AddComponent(NewGaleArenaPreview, go.name)
        local state = DataCenter.NewGaleArenaManager.state
        self.NewGaleArenaPreview:SetActive(state == NewPeakArenaState.FirstPreview or state == NewPeakArenaState.Preview)
        self.NewGaleArenaPreview:Init(self.pagePara1)
        self.pagePara1 = nil
        EventManager:GetInstance():Broadcast(EventId.GF_enter_pvp_arena, PVPArenaType.NewGaleArena)
      end)
    elseif self.NewGaleArenaPreview then
      self.NewGaleArenaPreview:SetActive(true)
      self.NewGaleArenaPreview:Refresh(self.pagePara1)
      self.pagePara1 = nil
      EventManager:GetInstance():Broadcast(EventId.GF_enter_pvp_arena, PVPArenaType.NewGaleArena)
    end
  elseif state == NewPeakArenaState.Open then
    if self.NewGaleArenaPreview then
      self.NewGaleArenaPreview:SetActive(false)
    end
    if self.req == nil then
      self.req = self:GameObjectInstantiateAsync(NewGaleArenaPrefabPath, function(request)
        local go = request.gameObject
        go.transform:SetParent(self.transform)
        go.transform:Set_localScale(1, 1, 1)
        go.transform:Set_localPosition(0, 0, 0)
        go.transform:Set_anchorMin(0, 0)
        go.transform:Set_anchorMax(1, 1)
        go.transform:Set_offsetMin(0, 0)
        go.transform:Set_offsetMax(0, 0)
        self.NewGaleArena = self:AddComponent(NewGaleArena, go.name)
        local nowState = DataCenter.NewGaleArenaManager.state
        if nowState == NewPeakArenaState.Open then
          self.NewGaleArena:SetActive(true)
          self.NewGaleArena:Init(self.pagePara1)
          self.pagePara1 = nil
        else
          self:RefreshPage()
        end
        EventManager:GetInstance():Broadcast(EventId.GF_enter_pvp_arena, PVPArenaType.NewGaleArena)
      end)
    elseif self.NewGaleArena then
      self.NewGaleArena:SetActive(true)
      self.NewGaleArena:Refresh(self.pagePara1)
      self.pagePara1 = nil
      EventManager:GetInstance():Broadcast(EventId.GF_enter_pvp_arena, PVPArenaType.NewGaleArena)
    end
  end
end

local function OnPassDay(self)
  SFSNetwork.SendMessage(MsgDefines.GaleArenaRankList)
end

local function ClearAsyncGameObject(self)
  self:RemoveComponents(NewGaleArena)
  if self.req then
    self:GameObjectDestroy(self.req)
  end
  self.req = nil
  self.NewGaleArena = nil
  self:RemoveComponents(NewGaleArenaPreview)
  if self.previewReq then
    self:GameObjectDestroy(self.previewReq)
  end
  self.previewReq = nil
  self.NewGaleArenaPreview = nil
end

LWNewPVPArenaGalePage.OnCreate = OnCreate
LWNewPVPArenaGalePage.OnDestroy = OnDestroy
LWNewPVPArenaGalePage.OnEnable = OnEnable
LWNewPVPArenaGalePage.OnDisable = OnDisable
LWNewPVPArenaGalePage.ComponentDefine = ComponentDefine
LWNewPVPArenaGalePage.ComponentDestroy = ComponentDestroy
LWNewPVPArenaGalePage.DataDefine = DataDefine
LWNewPVPArenaGalePage.DataDestroy = DataDestroy
LWNewPVPArenaGalePage.OnAddListener = OnAddListener
LWNewPVPArenaGalePage.OnRemoveListener = OnRemoveListener
LWNewPVPArenaGalePage.Init = Init
LWNewPVPArenaGalePage.Refresh = Refresh
LWNewPVPArenaGalePage.RefreshPage = RefreshPage
LWNewPVPArenaGalePage.OnPassDay = OnPassDay
LWNewPVPArenaGalePage.ClearAsyncGameObject = ClearAsyncGameObject
return LWNewPVPArenaGalePage
