local LW3V3ArenaPageWrapper = BaseClass("LW3V3ArenaPageWrapper", UIBaseContainer)
local UI3V3Page = require("UI.LWPVPArena.Main.Component.Arena3V3.LW3V3ArenaPage")
local base = UIBaseContainer
local Area3V3PagePrefabPath = "Assets/Main/Prefabs/UI/LWPVPArena/LWUI3V3CampaignPage.prefab"

local function OnCreate(self)
  base.OnCreate(self)
end

local function OnDestroy(self)
  self:OnDestroy3V3ArenaPage()
  base.OnDestroy(self)
end

local function Init(self, pagePara1, isInit)
  self:Load3V3ArenaPage(pagePara1)
end

local function OnDestroy3V3ArenaPage(self)
  if self.req then
    self:RemoveComponents(UI3V3Page)
    self:GameObjectDestroy(self.req)
    self.req = nil
  end
end

local function Load3V3ArenaPage(self, pagePara1)
  if self.req == nil then
    self.req = self:GameObjectInstantiateAsync(Area3V3PagePrefabPath, function(request)
      local go = request.gameObject
      go.transform:SetParent(self.transform)
      go.transform:Set_localScale(1, 1, 1)
      go.transform:Set_localPosition(0, 0, 0)
      go.transform:Set_anchorMin(0, 0)
      go.transform:Set_anchorMax(1, 1)
      go.transform:Set_offsetMin(0, 0)
      go.transform:Set_offsetMax(0, 0)
      self.arena3V3Page = self:AddComponent(UI3V3Page, go.name)
      self.arena3V3Page:SetActive(true)
      self.arena3V3Page:Init(pagePara1)
      EventManager:GetInstance():Broadcast(EventId.GF_enter_pvp_arena, PVPArenaType.Arena3V3)
    end)
  elseif self.arena3V3Page then
    self.arena3V3Page:SetActive(true)
    self.arena3V3Page:Init(pagePara1)
    EventManager:GetInstance():Broadcast(EventId.GF_enter_pvp_arena, PVPArenaType.Arena3V3)
  end
end

LW3V3ArenaPageWrapper.OnCreate = OnCreate
LW3V3ArenaPageWrapper.OnDestroy = OnDestroy
LW3V3ArenaPageWrapper.OnDestroy3V3ArenaPage = OnDestroy3V3ArenaPage
LW3V3ArenaPageWrapper.Load3V3ArenaPage = Load3V3ArenaPage
LW3V3ArenaPageWrapper.Init = Init
return LW3V3ArenaPageWrapper
