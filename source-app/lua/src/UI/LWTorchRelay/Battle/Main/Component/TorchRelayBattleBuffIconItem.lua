local TorchRelayBattleBuffIconItem = BaseClass("TorchRelayBattleBuffIconItem", UIBaseContainer)
local base = UIBaseContainer
local icon_path = "Icon"

function TorchRelayBattleBuffIconItem:OnCreate()
  base.OnCreate(self)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.imgProgressMid = self:AddComponent(UIImage, "progressMid")
  self.imgProgressBorder = self:AddComponent(UIImage, "progressBorder")
  self.compVfxNode = self:AddComponent(UIVfx, "vfxNode")
  self.imgProgressMid:SetActive(false)
  self.imgProgressBorder:SetActive(false)
end

function TorchRelayBattleBuffIconItem:OnDestroy()
  self.icon = nil
  self.imgProgressMid = nil
  self.imgProgressBorder = nil
  self.compVfxNode = nil
  base.OnDestroy(self)
end

function TorchRelayBattleBuffIconItem:OnEnable()
  base.OnEnable(self)
end

function TorchRelayBattleBuffIconItem:OnDisable()
  self.imgProgressMid:SetActive(false)
  self.imgProgressBorder:SetActive(false)
  base.OnDisable(self)
end

function TorchRelayBattleBuffIconItem:SetData(buffData)
  local iconPath = buffData.iconPath
  self.icon:LoadSprite(iconPath)
  self.state = buffData.state
  if self.state == TorchRelayBuffState.SpeedAdd or self.state == TorchRelayBuffState.AutoCollect or self.state == TorchRelayBuffState.Invincible then
    self.imgProgressMid:SetActive(true)
    self.imgProgressBorder:SetActive(true)
    self.compVfxNode:PlayByStay(EffectAssets.TorchRelayBuffIconProgress)
  end
end

function TorchRelayBattleBuffIconItem:UpdateResidueTime(residueTime, duration)
  if self.state == TorchRelayBuffState.Defend then
    return
  end
  if 0 < duration then
    local value = math.max(0, residueTime / duration)
    self.imgProgressMid:SetFillAmount(value)
    self.imgProgressBorder:SetFillAmount(value)
  else
    Logger.LogError("duration \228\184\141\232\175\165\229\176\143\228\186\142\231\173\137\228\186\1420 \229\190\136\232\175\161\229\188\130")
  end
end

return TorchRelayBattleBuffIconItem
