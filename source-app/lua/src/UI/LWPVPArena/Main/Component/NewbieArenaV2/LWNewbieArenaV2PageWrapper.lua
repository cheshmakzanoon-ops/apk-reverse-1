local LWNewbieArenaV2PageWrapper = BaseClass("LWNewbieArenaV2PageWrapper", UIBaseContainer)
local UINewbieArenaV2Page = require("UI.LWPVPArena.Main.Component.NewbieArenaV2.LWNewbieArenaV2Page")
local base = UIBaseContainer
local NewbieArenaPagePrefabPath = "Assets/Main/Prefabs/UI/LWPVPArena/LWUIArenaNewbieV2Page.prefab"

local function OnCreate(self)
  base.OnCreate(self)
end

local function OnDestroy(self)
  self:OnDestroyNewbieArenaPage()
  base.OnDestroy(self)
end

local function Init(self, pagePara1, isInit)
  self:LoadNewbieArenaPage(pagePara1)
end

local function OnDestroyNewbieArenaPage(self)
  if self.req then
    self:RemoveComponents(UINewbieArenaV2Page)
    self:GameObjectDestroy(self.req)
    self.req = nil
  end
end

local function LoadNewbieArenaPage(self, pagePara1)
  if self.req == nil then
    self.req = self:GameObjectInstantiateAsync(NewbieArenaPagePrefabPath, function(request)
      local go = request.gameObject
      go.transform:SetParent(self.transform)
      go.transform:Set_localScale(1, 1, 1)
      go.transform:Set_localPosition(0, 0, 0)
      go.transform:Set_anchorMin(0, 0)
      go.transform:Set_anchorMax(1, 1)
      go.transform:Set_offsetMin(0, 0)
      go.transform:Set_offsetMax(0, 0)
      self.newbieArenaPage = self:AddComponent(UINewbieArenaV2Page, go.name)
      self.newbieArenaPage:SetActive(true)
      self.newbieArenaPage:Init(pagePara1)
      EventManager:GetInstance():Broadcast(EventId.GF_enter_pvp_arena, PVPArenaType.NewbieArenaV2)
    end)
  elseif self.newbieArenaPage then
    self.newbieArenaPage:SetActive(true)
    self.newbieArenaPage:Init(pagePara1)
    EventManager:GetInstance():Broadcast(EventId.GF_enter_pvp_arena, PVPArenaType.NewbieArenaV2)
  end
end

LWNewbieArenaV2PageWrapper.OnCreate = OnCreate
LWNewbieArenaV2PageWrapper.OnDestroy = OnDestroy
LWNewbieArenaV2PageWrapper.OnDestroyNewbieArenaPage = OnDestroyNewbieArenaPage
LWNewbieArenaV2PageWrapper.LoadNewbieArenaPage = LoadNewbieArenaPage
LWNewbieArenaV2PageWrapper.Init = Init
return LWNewbieArenaV2PageWrapper
