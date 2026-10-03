local p_img_military_icon_path = "p_img_military_icon"
local p_trans_root_progress_path = "progress/p_trans_root_progress"
local UILWSeasonMilitaryProgressComp = require("UI.LWSeason6.UILWSeasonMilitary.Comp.UILWSeasonMilitaryProgressComp")
local base = UIBaseContainer
local UILWSeasonMilitaryLevelComp = BaseClass("UILWSeasonMilitaryLevelComp", UIBaseContainer)

function UILWSeasonMilitaryLevelComp:ComponentDefine()
  self.compCanvas = self:AddComponent(UICanvasGroup, "")
  self.p_img_military_icon = self:AddComponent(UIImage, p_img_military_icon_path)
  self.p_trans_root_progress = self:AddComponent(UILWSeasonMilitaryProgressComp, p_trans_root_progress_path)
  self.p_anim = self:AddComponent(UISimpleAnimation, "")
end

function UILWSeasonMilitaryLevelComp:ComponentDestroy()
  self.compCanvas = nil
  self.p_img_military_icon = nil
  self.p_trans_root_progress = nil
  self.p_anim = nil
end

function UILWSeasonMilitaryLevelComp:DataDefine()
end

function UILWSeasonMilitaryLevelComp:DataDestroy()
end

function UILWSeasonMilitaryLevelComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWSeasonMilitaryLevelComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonMilitaryLevelComp:ReInit(level, serverId, angle)
  if self:InitData(level, angle, serverId) then
    self:InitUi()
  end
end

function UILWSeasonMilitaryLevelComp:InitData(level, angle, serverId)
  self.Level = checknumber(level)
  self.Angle = checknumber(angle)
  self.ServeId = serverId
  self.Cell = DataCenter.SeasonMilitaryManager:GetLevelCellTmp(self.Level)
  return self.Cell ~= nil
end

function UILWSeasonMilitaryLevelComp:InitUi()
  self.p_img_military_icon:LoadSpriteAsync(self.Cell:GetIcon(self.ServeId))
  local curNum, totalNum = DataCenter.SeasonMilitaryManager:GetLevelStarNum(self.Level)
  self.p_trans_root_progress:SetStar(curNum, totalNum, false, self.Angle)
end

function UILWSeasonMilitaryLevelComp:PlayAnimationReturnTime(animName)
  if self.p_anim ~= nil and IsNotNull(self.p_anim.simpleAnimation) then
    return self.p_anim:PlayAnimationReturnTime(animName)
  end
  return false, 0
end

function UILWSeasonMilitaryLevelComp:ResetAnim()
  if self.p_anim ~= nil and IsNotNull(self.p_anim.simpleAnimation) then
    self.p_anim:Stop()
  end
  self.transform.anchoredPosition = CS.UnityEngine.Vector2.zero
  if self.compCanvas ~= nil then
    self.compCanvas:SetAlpha(1)
  end
end

return UILWSeasonMilitaryLevelComp
