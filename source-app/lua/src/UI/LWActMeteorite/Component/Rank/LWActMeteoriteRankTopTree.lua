local base = UIBaseContainer
local LWActMeteoriteRankTopTree = BaseClass("LWActMeteoriteRankTopTree", base)
local LWActMeteoriteRankTopItem = require("UI.LWActMeteorite.Component.Rank.LWActMeteoriteRankTopItem")
local first_path = "First"
local second_path = "Second"
local third_path = "Third"

function LWActMeteoriteRankTopTree:OnCreate()
  base.OnCreate(self)
  self.first = self:AddComponent(LWActMeteoriteRankTopItem, first_path)
  self.second = self:AddComponent(LWActMeteoriteRankTopItem, second_path)
  self.third = self:AddComponent(LWActMeteoriteRankTopItem, third_path)
end

function LWActMeteoriteRankTopTree:OnDestroy()
  self.first = nil
  self.second = nil
  self.third = nil
  base.OnDestroy(self)
end

function LWActMeteoriteRankTopTree:SetData(info1, info2, info3)
  self.first:SetData(info1)
  self.second:SetData(info2)
  self.third:SetData(info3)
end

return LWActMeteoriteRankTopTree
