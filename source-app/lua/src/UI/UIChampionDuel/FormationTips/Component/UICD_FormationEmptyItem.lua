local UICD_FormationEmptyItem = BaseClass("UICD_FormationEmptyItem", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCell = require("UI.UIHero2.Common.UIHeroCellBig")

function UICD_FormationEmptyItem:OnCreate()
  base.OnCreate(self)
  self.warning = self:AddComponent(UIBaseComponent, "Warning")
  self.text_idx = self:AddComponent(UIText, "Tag/IdxText")
  self.cells = {}
  for i = 1, 5 do
    local cell = self:AddComponent(UIHeroCell, "Empty" .. i .. "/UIHeroCellBig" .. i)
    cell:DisableRedPoint()
    self.cells[i] = cell
  end
  self.btn_go = self:AddComponent(UIButton, "Btn")
  self.btn_go:SetOnClick(BindCallback(self, self.OnClickGoFormation))
  self.text_btn_go = self:AddComponent(UIText, "Btn/BtnText")
  self.text_btn_go:SetLocalText("110003")
end

function UICD_FormationEmptyItem:OnDestroy()
  self.warning = nil
  self.text_idx = nil
  self.cells = {}
  self.btn_go = nil
  self.text_btn_go = nil
  base.OnDestroy(self)
end

function UICD_FormationEmptyItem:OnClickGoFormation()
  if self.order ~= nil then
    EventManager:GetInstance():Broadcast(EventId.ChampionDuelSquadChoose, self.order)
  end
end

function UICD_FormationEmptyItem:ReInit(order, team)
  self.order = order
  self.team = team
  self.warning:SetActive(team:GetEmptySlotIndex())
  self.text_idx:SetText(order)
  for i = 1, 5 do
    local cell = self.cells[i]
    local uuid = team:GetLocalHeroAtSlotIndex(i)
    cell:SetActive(uuid ~= nil)
    if uuid ~= nil then
      cell:SetData(uuid)
    end
  end
end

return UICD_FormationEmptyItem
