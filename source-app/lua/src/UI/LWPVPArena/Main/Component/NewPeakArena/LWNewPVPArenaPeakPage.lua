local LWNewPVPArenaPeakPage = BaseClass("LWNewPVPArenaPeakPage", UIBaseContainer)
local base = UIBaseContainer
local NewPeakArena = require("UI.LWPVPArena.Main.Component.NewPeakArena.NewPeakArena")
local NewPeakArenaPrefabPath = "Assets/Main/Prefabs/NewPeakArena/NewPeakArena.prefab"
local NewPeakArenaPreview = require("UI.LWPVPArena.Main.Component.NewPeakArena.NewPeakArenaPreview")
local NewPeakArenaPreviewPrefabPath = "Assets/Main/Prefabs/NewPeakArena/NewPeakArenaPreView.prefab"

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
  self.soundId = DataCenter.LWSoundManager:PlaySound(62270, false)
end

local function OnDisable(self)
  base.OnDisable(self)
  if self.soundId then
    DataCenter.LWSoundManager:StopSound(self.soundId)
    self.soundId = nil
  end
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
  self:AddUIListener(EventId.NewPeakArenaInfoRefresh, self.Refresh)
  self:AddUIListener(EventId.NewPeakArenaGetRankList, self.RefreshPage)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.NewPeakArenaInfoRefresh, self.Refresh)
  self:RemoveUIListener(EventId.NewPeakArenaGetRankList, self.RefreshPage)
end

local function Init(self, pagePara1, isInit)
  if self.holder.imgBg then
    self.holder.imgBg:SetActive(false)
  end
  self.pagePara1 = pagePara1
  self:Refresh(isInit)
end

local function Refresh(self, isInit)
  if not isInit and DataCenter.NewPeakArenaManager.state ~= NewPeakArenaState.FirstPreview then
    SFSNetwork.SendMessage(MsgDefines.NewArenaRankList)
  end
  if DataCenter.NewPeakArenaManager.state == NewPeakArenaState.FirstPreview or DataCenter.NewPeakArenaManager.rankData then
    self:RefreshPage()
  end
end

local function RefreshPage(self)
  local state = DataCenter.NewPeakArenaManager.state
  if state == NewPeakArenaState.FirstPreview or state == NewPeakArenaState.Preview or state == NewPeakArenaState.Finshed or DataCenter.NewPeakArenaManager.rankData.curRank == 0 or DataCenter.NewPeakArenaManager.rankData.players == nil then
    if self.newPeakArena then
      self.newPeakArena:SetActive(false)
    end
    if self.previewReq == nil then
      self.previewReq = self:GameObjectInstantiateAsync(NewPeakArenaPreviewPrefabPath, function(request)
        local go = request.gameObject
        go.transform:SetParent(self.transform)
        go.transform:Set_localScale(1, 1, 1)
        go.transform:Set_localPosition(0, 0, 0)
        go.transform:Set_anchorMin(0, 0)
        go.transform:Set_anchorMax(1, 1)
        go.transform:Set_offsetMin(0, 0)
        go.transform:Set_offsetMax(0, 0)
        self.newPeakArenaPreview = self:AddComponent(NewPeakArenaPreview, go.name)
        local state = DataCenter.NewPeakArenaManager.state
        self.newPeakArenaPreview:SetActive(state == NewPeakArenaState.FirstPreview or NewPeakArenaState.Preview)
        self.newPeakArenaPreview:Init(self.pagePara1)
        self.pagePara1 = nil
        EventManager:GetInstance():Broadcast(EventId.GF_enter_pvp_arena, PVPArenaType.NewPeakArena)
      end)
    elseif self.newPeakArenaPreview then
      self.newPeakArenaPreview:SetActive(true)
      self.newPeakArenaPreview:Refresh(self.pagePara1)
      self.pagePara1 = nil
      EventManager:GetInstance():Broadcast(EventId.GF_enter_pvp_arena, PVPArenaType.NewPeakArena)
    end
  elseif state == NewPeakArenaState.Open then
    if self.newPeakArenaPreview then
      self.newPeakArenaPreview:SetActive(false)
    end
    if self.req == nil then
      self.req = self:GameObjectInstantiateAsync(NewPeakArenaPrefabPath, function(request)
        local go = request.gameObject
        go.transform:SetParent(self.transform)
        go.transform:Set_localScale(1, 1, 1)
        go.transform:Set_localPosition(0, 0, 0)
        go.transform:Set_anchorMin(0, 0)
        go.transform:Set_anchorMax(1, 1)
        go.transform:Set_offsetMin(0, 0)
        go.transform:Set_offsetMax(0, 0)
        self.newPeakArena = self:AddComponent(NewPeakArena, go.name)
        local nowState = DataCenter.NewPeakArenaManager.state
        if nowState == NewPeakArenaState.Open then
          self.newPeakArena:SetActive(true)
          self.newPeakArena:Init(self.pagePara1)
          self.pagePara1 = nil
        else
          self:RefreshPage()
        end
        EventManager:GetInstance():Broadcast(EventId.GF_enter_pvp_arena, PVPArenaType.NewPeakArena)
      end)
    elseif self.newPeakArena then
      self.newPeakArena:SetActive(true)
      self.newPeakArena:Refresh(self.pagePara1)
      self.pagePara1 = nil
      EventManager:GetInstance():Broadcast(EventId.GF_enter_pvp_arena, PVPArenaType.NewPeakArena)
    end
  end
end

local function ClearAsyncGameObject(self)
  self:RemoveComponents(NewPeakArena)
  if self.req then
    self:GameObjectDestroy(self.req)
  end
  self.req = nil
  self.newPeakArena = nil
  self:RemoveComponents(NewPeakArenaPreview)
  if self.previewReq then
    self:GameObjectDestroy(self.previewReq)
  end
  self.previewReq = nil
  self.newPeakArenaPreview = nil
end

LWNewPVPArenaPeakPage.OnCreate = OnCreate
LWNewPVPArenaPeakPage.OnDestroy = OnDestroy
LWNewPVPArenaPeakPage.OnEnable = OnEnable
LWNewPVPArenaPeakPage.OnDisable = OnDisable
LWNewPVPArenaPeakPage.ComponentDefine = ComponentDefine
LWNewPVPArenaPeakPage.ComponentDestroy = ComponentDestroy
LWNewPVPArenaPeakPage.DataDefine = DataDefine
LWNewPVPArenaPeakPage.DataDestroy = DataDestroy
LWNewPVPArenaPeakPage.OnAddListener = OnAddListener
LWNewPVPArenaPeakPage.OnRemoveListener = OnRemoveListener
LWNewPVPArenaPeakPage.Init = Init
LWNewPVPArenaPeakPage.Refresh = Refresh
LWNewPVPArenaPeakPage.RefreshPage = RefreshPage
LWNewPVPArenaPeakPage.ClearAsyncGameObject = ClearAsyncGameObject
return LWNewPVPArenaPeakPage
