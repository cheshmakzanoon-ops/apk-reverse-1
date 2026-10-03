local UICD_KnockoutCell = BaseClass("UICD_KnockoutCell", UIBaseContainer)
local base = UIBaseContainer
local UICD_KnockoutItem = require("UI.UIChampionDuel.Component.Knockout.UICD_KnockoutItem")
local line_light1_path = "LineLight1"
local line_light2_path = "LineLight2"
local item1_path = "Item1"
local item2_path = "Item2"
local item3_path = "Item3"

function UICD_KnockoutCell:OnCreate()
  base.OnCreate(self)
  self.line_light1 = self:AddComponent(UIBaseContainer, line_light1_path)
  self.line_light2 = self:AddComponent(UIBaseContainer, line_light2_path)
  self.item1 = self:AddComponent(UICD_KnockoutItem, item1_path)
  self.item2 = self:AddComponent(UICD_KnockoutItem, item2_path)
  self.item3 = self:AddComponent(UICD_KnockoutItem, item3_path)
end

function UICD_KnockoutCell:OnDestroy()
  self.line_light1 = nil
  self.line_light2 = nil
  self.item1 = nil
  self.item1 = nil
  self.item1 = nil
  base.OnDestroy(self)
end

function UICD_KnockoutCell:ReInit(group, spIndex)
  local winner = group.winner
  local teamA = group.teamA
  self.item1:ReInit(teamA, winner)
  local teamB = group.teamB
  self.item2:ReInit(teamB, winner)
  local winnerTeam
  if winner == teamA.uid then
    winnerTeam = teamA
    self.line_light1:SetActive(true)
    self.line_light2:SetActive(false)
  elseif winner == teamB.uid then
    winnerTeam = teamB
    self.line_light1:SetActive(false)
    self.line_light2:SetActive(true)
  else
    self.line_light1:SetActive(false)
    self.line_light2:SetActive(false)
  end
  self.item3:ReInit(winnerTeam, winner, spIndex)
  if spIndex ~= nil then
    self.item3:SetScore(group.point or 0, group.targetPoint or 0, spIndex)
  end
end

return UICD_KnockoutCell
