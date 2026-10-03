local base = UIBaseContainer
local ZombieBattleWinTypeNormalRender = BaseClass("ZombieBattleWinTypeNormalRender", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local Const = require("Scene.LWBattle.Const")
local default_icon = "Icon"
local KillEffect = "Kill"

function ZombieBattleWinTypeNormalRender:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ZombieBattleWinTypeNormalRender:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ZombieBattleWinTypeNormalRender:ComponentDefine()
  self.icon = self:AddComponent(UIImage, default_icon)
  self.killEffect = self:AddComponent(UIImage, KillEffect)
  self.canvasGroup = self:TryAddComponent(UICanvasGroup, "")
end

function ZombieBattleWinTypeNormalRender:ComponentDestroy()
  self.icon = nil
  self.killEffect = nil
  self.canvasGroup = nil
end

function ZombieBattleWinTypeNormalRender:DataDefine()
  self.showKilled = false
end

function ZombieBattleWinTypeNormalRender:DataDestroy()
  self.winType = nil
  self.winType2Index = nil
  self.showKilled = false
end

function ZombieBattleWinTypeNormalRender:GetType()
  return self.winType
end

function ZombieBattleWinTypeNormalRender:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.BarrageWinConditionRefresh, self.UpdateWinConditionBar)
end

function ZombieBattleWinTypeNormalRender:OnRemoveListener()
  self:RemoveUIListener(EventId.BarrageWinConditionRefresh, self.UpdateWinConditionBar)
  base.OnRemoveListener(self)
end

function ZombieBattleWinTypeNormalRender:InitData(winType, winType2Index)
  self.winType = winType
  self.winType2Index = winType2Index or 1
  self.icon:SetActive(true)
  self.killEffect:SetActive(false)
  self:UpdateWinConditionBar(winType)
end

function ZombieBattleWinTypeNormalRender:UpdateWinConditionBar(winType)
  if self.winType ~= winType then
    return
  end
  local battleMgr = DataCenter.ZombieBattleManager
  local showKill = false
  if winType == Const.StageWinType.KillBoss then
    showKill = battleMgr.killBossNum >= self.winType2Index
  end
  if showKill and not self.showKilled then
    self.icon:SetActive(false)
    self.killEffect:SetActive(true)
    self.showKilled = true
  end
end

return ZombieBattleWinTypeNormalRender
