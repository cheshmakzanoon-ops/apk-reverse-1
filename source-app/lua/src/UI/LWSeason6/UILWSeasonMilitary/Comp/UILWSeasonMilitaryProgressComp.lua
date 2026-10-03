local p_trans_anchor_path = "p_trans_anchor"
local p_go_star_1_path = "p_go_star_1"
local p_go_star_2_path = "p_go_star_2"
local p_go_star_3_path = "p_go_star_3"
local p_go_star_4_path = "p_go_star_4"
local p_go_star_5_path = "p_go_star_5"
local UILWSeasonMilitaryStarCell = require("UI.LWSeason6.UILWSeasonMilitary.Cell.UILWSeasonMilitaryStarCell")
local base = UIBaseContainer
local UILWSeasonMilitaryProgressComp = BaseClass("UILWSeasonMilitaryProgressComp", UIBaseContainer)

function UILWSeasonMilitaryProgressComp:ComponentDefine()
  self.p_trans_anchor = self:AddComponent(UIBaseContainer, p_trans_anchor_path)
  self.p_comp_star_1 = self:AddComponent(UILWSeasonMilitaryStarCell, p_go_star_1_path)
  self.p_comp_star_2 = self:AddComponent(UILWSeasonMilitaryStarCell, p_go_star_2_path)
  self.p_comp_star_3 = self:AddComponent(UILWSeasonMilitaryStarCell, p_go_star_3_path)
  self.p_comp_star_4 = self:AddComponent(UILWSeasonMilitaryStarCell, p_go_star_4_path)
  self.p_comp_star_5 = self:AddComponent(UILWSeasonMilitaryStarCell, p_go_star_5_path)
  self.itemStars = {
    self.p_comp_star_1,
    self.p_comp_star_2,
    self.p_comp_star_3,
    self.p_comp_star_4,
    self.p_comp_star_5
  }
end

function UILWSeasonMilitaryProgressComp:ComponentDestroy()
  self.p_trans_anchor = nil
  self.p_comp_star_1 = nil
  self.p_comp_star_2 = nil
  self.p_comp_star_3 = nil
  self.p_comp_star_4 = nil
  self.p_comp_star_5 = nil
  self.itemStars = {}
end

function UILWSeasonMilitaryProgressComp:DataDefine()
  self.DefaultAngle = 30
end

function UILWSeasonMilitaryProgressComp:DataDestroy()
end

function UILWSeasonMilitaryProgressComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWSeasonMilitaryProgressComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonMilitaryProgressComp:OnAddListener()
  base.OnAddListener(self)
end

function UILWSeasonMilitaryProgressComp:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWSeasonMilitaryProgressComp:SetStar(curNum, maxNum, anim, angle)
  local radius = Mathf.Abs(self.p_trans_anchor:GetLocalPosition().y)
  angle = checknumber(angle) > 0 and angle or self.DefaultAngle
  if checknumber(self.MaxNum) ~= maxNum then
    self:CreateCircleLayout(radius, maxNum, angle)
  end
  for i = 1, table.count(self.itemStars) do
    self.itemStars[i]:SetState(curNum >= i, maxNum >= i, anim and i > self.CurNum and curNum >= i)
  end
  self.CurNum = curNum
  self.MaxNum = maxNum
end

function UILWSeasonMilitaryProgressComp:CreateCircleLayout(radius, maxNum, angle)
  local baseAngle = -90
  local midIndex = (maxNum + 1) / 2
  for i = 1, maxNum do
    local go = self.itemStars[i]
    go:SetActive(true)
    local trans = go.transform
    local offsetAngle = (i - midIndex) * angle
    local finalAngle = baseAngle + offsetAngle
    local radians = math.rad(finalAngle)
    local x = math.cos(radians) * radius
    local y = math.sin(radians) * radius
    trans.localPosition = Vector3(x, y, 0)
  end
  for i = maxNum + 1, table.count(self.itemStars) do
    self.itemStars[i]:SetActive(false)
  end
end

return UILWSeasonMilitaryProgressComp
