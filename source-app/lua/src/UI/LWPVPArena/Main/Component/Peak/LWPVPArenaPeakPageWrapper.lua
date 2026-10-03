local LWPVPArenaPeakPageWrapper = BaseClass("LWPVPArenaPeakPageWrapper", UIBaseContainer)
local UIPeakPage = require("UI.LWPVPArena.Main.Component.Peak.LWPVPArenaPeakPage")
local base = UIBaseContainer
local AreaPeakPagePrefabPath = "Assets/Main/Prefabs/UI/LWPVPArena/LWPVPPeakArena.prefab"

local function OnCreate(self)
  base.OnCreate(self)
end

local function OnDestroy(self)
  self:OnDestroyArenaPeakPage()
  base.OnDestroy(self)
end

local function Init(self, pagePara1, isInit)
  self:LoadArenaPeakPage(pagePara1)
end

local function Refresh(self, arenaData)
  if self.peakPage then
    self.peakPage:Refresh(arenaData)
  end
end

local function OnDestroyArenaPeakPage(self)
  if self.req then
    self:RemoveComponents(UIPeakPage)
    self:GameObjectDestroy(self.req)
    self.req = nil
  end
end

local function LoadArenaPeakPage(self, pagePara1)
  if self.req == nil then
    self.req = self:GameObjectInstantiateAsync(AreaPeakPagePrefabPath, function(request)
      local go = request.gameObject
      go.transform:SetParent(self.transform)
      go.transform:Set_localScale(1, 1, 1)
      go.transform:Set_localPosition(0, 0, 0)
      go.transform:Set_anchorMin(0, 0)
      go.transform:Set_anchorMax(1, 1)
      go.transform:Set_offsetMin(0, 0)
      go.transform:Set_offsetMax(0, 0)
      self.peakPage = self:AddComponent(UIPeakPage, go.name)
      self.peakPage:SetActive(true)
      self.peakPage:Init(pagePara1)
      EventManager:GetInstance():Broadcast(EventId.GF_enter_pvp_arena, PVPArenaType.PeakArena)
    end)
  elseif self.peakPage then
    self.peakPage:SetActive(true)
    self.peakPage:Init(pagePara1)
    EventManager:GetInstance():Broadcast(EventId.GF_enter_pvp_arena, PVPArenaType.PeakArena)
  end
end

LWPVPArenaPeakPageWrapper.OnCreate = OnCreate
LWPVPArenaPeakPageWrapper.OnDestroy = OnDestroy
LWPVPArenaPeakPageWrapper.OnDestroyArenaPeakPage = OnDestroyArenaPeakPage
LWPVPArenaPeakPageWrapper.LoadArenaPeakPage = LoadArenaPeakPage
LWPVPArenaPeakPageWrapper.Init = Init
LWPVPArenaPeakPageWrapper.Refresh = Refresh
return LWPVPArenaPeakPageWrapper
