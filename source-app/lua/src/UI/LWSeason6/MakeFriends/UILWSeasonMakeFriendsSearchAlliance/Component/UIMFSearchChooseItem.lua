local UIMFSearchChooseItem = BaseClass("UIMFSearchChooseItem", UIToggle)
local base = UIToggle
local Localization = CS.GameEntry.Localization

function UIMFSearchChooseItem:OnCreate()
  base.OnCreate(self)
  self.txt = self:AddComponent(UITextMeshProUGUIEx, "Txt")
  self.item_btn = self:AddComponent(UIButton, "ItemBtn")
  self.item_btn:SetOnClick(function()
    self:SetIsOn(true)
  end)
end

function UIMFSearchChooseItem:OnDestroy()
  self.txt = nil
  self.item_btn = nil
  base.OnDestroy(self)
end

function UIMFSearchChooseItem:ReInit(serverId, factionType)
  if serverId then
    self.theTextStr = "#" .. serverId
  elseif factionType then
    local factionMgr = DataCenter.SeasonFactionWarDataManager
    self.theTextStr = factionMgr:GetCampName(factionType)
  else
    self.theTextStr = Localization:GetString("s6_alliance_ally_limit_desc08")
  end
  self.txt:SetText(self.theTextStr)
  self.serverId = serverId
  self.factionType = factionType
end

function UIMFSearchChooseItem:GetTxt()
  return self.theTextStr or "???"
end

return UIMFSearchChooseItem
