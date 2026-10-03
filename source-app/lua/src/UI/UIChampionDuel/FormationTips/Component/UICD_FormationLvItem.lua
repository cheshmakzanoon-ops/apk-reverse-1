local UICD_FormationLvItem = BaseClass("UICD_FormationLvItem", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCell = require("UI.UIHero2.Common.UIHeroCellSmall")

function UICD_FormationLvItem:OnCreate()
  base.OnCreate(self)
  self.heroCell = self:AddComponent(UIHeroCell, "UIHeroCellSmall")
  self.btn_go = self:AddComponent(UIButton, "Btn")
  self.btn_go:SetOnClick(BindCallback(self, self.OnClickGoFormation))
  self.text_btn_go = self:AddComponent(UIText, "Btn/BtnText")
  self.text_btn_go:SetLocalText("110003")
end

function UICD_FormationLvItem:OnDestroy()
  self.heroCell = nil
  self.btn_go = nil
  self.text_btn_go = nil
  base.OnDestroy(self)
end

function UICD_FormationLvItem:OnClickGoFormation()
  if self.uuid ~= nil then
    local order = DataCenter.ChampionDuelManager:GetHeroInSelfTeamOrder(self.uuid)
    EventManager:GetInstance():Broadcast(EventId.ChampionDuelSquadChoose, order)
  end
end

function UICD_FormationLvItem:ReInit(uuid)
  self.uuid = uuid
  local heroInfo = DataCenter.HeroDataManager:GetHeroByUuid(uuid)
  self.heroCell:SetHeroData(heroInfo)
end

return UICD_FormationLvItem
