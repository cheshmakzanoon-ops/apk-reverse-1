local UIHeroPVPArena3V3Container = BaseClass("UIHeroPVPArena3V3Container", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UIHeroPVPArena3V3Container:OnCreate(isDef)
  base.OnCreate(self)
  self:ComponentDefine()
  self.isDef = isDef
  if not isDef then
    self.isDef = true
  end
end

function UIHeroPVPArena3V3Container:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIHeroPVPArena3V3Container:ComponentDefine()
  local pageTogglePath = "Pages/PageToggle%d"
  local pageToggleSelectedPath = "Pages/PageToggle%d/Selected%d"
  local pageToggleUnselectedPath = "Pages/PageToggle%d/Unselected%d"
  self.pageToggles = {}
  self.pageToggleSelecteds = {}
  self.pageToggleUnselecteds = {}
  for i = 1, 3 do
    self.pageToggles[i] = self:AddComponent(UIBaseContainer, string.format(pageTogglePath, i))
    self.pageToggleSelecteds[i] = self:AddComponent(UIBaseContainer, string.format(pageToggleSelectedPath, i, i))
    self.pageToggleUnselecteds[i] = self:AddComponent(UIButton, string.format(pageToggleUnselectedPath, i, i))
    self.pageToggleUnselecteds[i]:SetOnClick(function()
      self.view:ChangeSquadIndex(i)
    end)
  end
  self.orderBtn = self:AddComponent(UIButton, "OrderBtn")
  self.orderBtn:SetOnClick(function()
    self:OnOrderBtnClick()
  end)
  self.saveBtn = self:AddComponent(UIButton, "SaveBtn")
  self.saveBtn:SetOnClick(function()
    self.view:OnSaveBtnClick()
  end)
end

function UIHeroPVPArena3V3Container:ComponentDestroy()
end

function UIHeroPVPArena3V3Container:RefreshShow(squadIndex, source)
  self.squadIndex = squadIndex
  self.source = source
  if not self.squadIndex then
    return
  end
  for i = 1, 3 do
    self.pageToggleSelecteds[i]:SetActive(self.squadIndex == i)
    self.pageToggleUnselecteds[i]:SetActive(self.squadIndex ~= i)
  end
  self.orderBtn:SetActive(self.source ~= EnterHeroSquadPanelWay.ChampionDuel)
end

function UIHeroPVPArena3V3Container:OnOrderBtnClick()
  if self.source and self.source == EnterHeroSquadPanelWay.KOFDefence then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWKOFDefenseTeamOrder)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWArena3V3DefenseTeamOrder)
  end
end

return UIHeroPVPArena3V3Container
