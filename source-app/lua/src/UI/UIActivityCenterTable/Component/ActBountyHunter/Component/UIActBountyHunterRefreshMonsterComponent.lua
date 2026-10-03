local base = UIBaseContainer
local UIActBountyHunterRefreshMonsterComponent = BaseClass("UIActBountyHunterRefreshMonsterComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIActBountyHunterRefreshMonsterComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActBountyHunterRefreshMonsterComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActBountyHunterRefreshMonsterComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.simpleAnimationRefreshMonster = self.viewSkin:AddComponent(self, UISimpleAnimation, 1)
  self.btnRefreshMonster = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnRefreshMonster:SetOnClick(function()
    self:OnBtnRefreshMonsterClick()
  end)
  self.textRefreshMonsterCount = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
end

function UIActBountyHunterRefreshMonsterComponent:ComponentDestroy()
  self.viewSkin = nil
  self.simpleAnimationRefreshMonster = nil
  self.btnRefreshMonster = nil
  self.textRefreshMonsterCount = nil
end

function UIActBountyHunterRefreshMonsterComponent:DataDefine()
  self.isOn = nil
  self.activityData = nil
  self.onBtnClick = nil
end

function UIActBountyHunterRefreshMonsterComponent:DataDestroy()
  self.isOn = nil
  self.activityData = nil
  self.onBtnClick = nil
end

function UIActBountyHunterRefreshMonsterComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIActBountyHunterRefreshMonsterComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIActBountyHunterRefreshMonsterComponent:ReInit(activityData, onBtnClick)
  self.activityData = activityData
  self.onBtnClick = onBtnClick
  self.isOn = nil
end

function UIActBountyHunterRefreshMonsterComponent:SetIsOn(isOn)
  local isPlayChangeAnim = self.isOn ~= nil and isOn ~= self.isOn
  if isOn then
    if isPlayChangeAnim then
      self.simpleAnimationRefreshMonster:Play("in")
    else
      self.simpleAnimationRefreshMonster:Play("loop")
    end
  elseif isPlayChangeAnim then
    self.simpleAnimationRefreshMonster:Play("out")
  else
    self.simpleAnimationRefreshMonster:Play("loop2")
  end
  self.isOn = isOn
end

function UIActBountyHunterRefreshMonsterComponent:RefreshCountText()
  if self.activityData == nil then
    return
  end
  self.textRefreshMonsterCount:SetText("\195\151" .. tostring(self.activityData:GetRefreshItemCount()))
end

function UIActBountyHunterRefreshMonsterComponent:OnBtnRefreshMonsterClick()
  if self.onBtnClick then
    self.onBtnClick()
  end
end

return UIActBountyHunterRefreshMonsterComponent
