local base = UIBaseContainer
local ParkourWinTypeNormalRender = BaseClass("ParkourWinTypeNormalRender", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local Const = require("Scene.LWBattle.Const")
local default_icon = "Icon"
local KillEffect = "Kill"

function ParkourWinTypeNormalRender:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ParkourWinTypeNormalRender:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ParkourWinTypeNormalRender:ComponentDefine()
  self.icon = self:AddComponent(UIImage, default_icon)
  self.killEffect = self:AddComponent(UIImage, KillEffect)
end

function ParkourWinTypeNormalRender:ComponentDestroy()
  self.icon = nil
  self.killEffect = nil
end

function ParkourWinTypeNormalRender:DataDefine()
  self.showKilled = false
end

function ParkourWinTypeNormalRender:DataDestroy()
  self.winType = nil
  self.winType2Index = nil
  self.showKilled = false
end

function ParkourWinTypeNormalRender:GetType()
  return self.winType
end

function ParkourWinTypeNormalRender:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ParkourWinConditionRefresh, self.UpdateWinConditionBar)
end

function ParkourWinTypeNormalRender:OnRemoveListener()
  self:RemoveUIListener(EventId.ParkourWinConditionRefresh, self.UpdateWinConditionBar)
  base.OnRemoveListener(self)
end

function ParkourWinTypeNormalRender:InitData(winType, winType2Index)
  self.winType = winType
  self.winType2Index = winType2Index or 1
  self.icon:SetActive(true)
  self.killEffect:SetActive(false)
  self:UpdateWinConditionBar(winType)
end

function ParkourWinTypeNormalRender:UpdateWinConditionBar(winType)
  if self.winType ~= winType then
    return
  end
  local battleMgr = DataCenter.LWBattleManager.logic
  local winCondition = DataCenter.LWBattleManager.logic:GetWinConditionDataByWinType(winType)
  if winCondition == nil then
    return
  end
  local showKill = false
  if winType == Const.ParkourWinType.KillBoss then
    showKill = battleMgr.killBossNum >= self.winType2Index
  elseif winType == Const.ParkourWinType.BlastStandingWaterBottle then
    showKill = battleMgr.blastStandingWaterBottleNum == self.winType2Index
  end
  if showKill and not self.showKilled then
    self.icon:SetActive(false)
    self.killEffect:SetActive(true)
    self.showKilled = true
  end
end

return ParkourWinTypeNormalRender
