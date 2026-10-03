local base = UIBaseContainer
local UITreasureChestItem = BaseClass("UITreasureChestItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UITreasureChestItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UITreasureChestItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UITreasureChestItem:ComponentDefine()
  self.btnUITreasureChestItem = self:AddComponent(UIButton, "")
  self.btnUITreasureChestItem:SetOnClick(function()
    self:OnBtnUITreasureChestItemClick()
  end)
  self.RootAnimation = self.transform:Find("Root"):GetComponent(typeof(CS.SimpleAnimation))
end

function UITreasureChestItem:ComponentDestroy()
  self.btnUITreasureChestItem = nil
end

function UITreasureChestItem:DataDefine()
end

function UITreasureChestItem:DataDestroy()
  self.targetPosition = nil
  self.startPosition = nil
  self.sumTime = 0
  self.direction = nil
  self.showSwitchEffected = nil
end

function UITreasureChestItem:OnAddListener()
  base.OnAddListener(self)
end

function UITreasureChestItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UITreasureChestItem:OnBtnUITreasureChestItemClick()
  self.view:OnClickBox(self.index)
end

function UITreasureChestItem:GetCurPosition()
  return self.transform.position
end

function UITreasureChestItem:Update()
  local deltaTime = Time.deltaTime
  if self.targetPosition and self.startPosition then
    self.sumTime = self.sumTime + deltaTime
    local switchTime = self.switchTime or 1
    local factor = self:SmoothStep(0, switchTime, self.sumTime)
    self.transform.position = Vector3.Lerp(self.startPosition, self.targetPosition, factor)
    local scaleDelta = 0.15 * self.direction
    local scaleFactor = 1 + scaleDelta * (1 - Mathf.Abs(2 * (factor - 0.5)))
    self.transform:Set_localScale(scaleFactor, scaleFactor, 1)
    if 0 < self.direction and 0.3 < factor and not self.showSwitchEffected then
      self.showSwitchEffected = true
      self.view:ShowSwitchEffect(0.5 * self.targetPosition.x + self.startPosition.x * 0.5, 0.5 * self.targetPosition.y + self.startPosition.y * 0.5, self.startPosition.z)
    end
    if 1 <= factor then
      self.targetPosition = nil
      self.startPosition = nil
      self.sumTime = 0
      if 0 < self.direction then
        self.view:HideSwitchEffect()
      end
    end
  end
end

function UITreasureChestItem:PlayAnimation(animationName)
  if self.RootAnimation then
    local animLen = self.RootAnimation:GetClipLength(animationName)
    self.RootAnimation:Play(animationName)
    return animLen
  end
  return 0
end

function UITreasureChestItem:SetData(index)
  self.index = index
end

function UITreasureChestItem:CloseBox()
  return self:PlayAnimation("close")
end

function UITreasureChestItem:OpenBoxWithBigReward()
  return self:PlayAnimation("idle")
end

function UITreasureChestItem:OpenBoxWithNormalReward()
  return self:PlayAnimation("idle02")
end

function UITreasureChestItem:CloseBoxBigReward()
  return self:PlayAnimation("into")
end

function UITreasureChestItem:CloseBoxNormalReward()
  return self:PlayAnimation("into02")
end

function UITreasureChestItem:ClickBox()
  return self:PlayAnimation("click")
end

function UITreasureChestItem:OpenBigRewardBox()
  return self:PlayAnimation("open")
end

function UITreasureChestItem:OpenNormalRewardBox()
  return self:PlayAnimation("open02")
end

function UITreasureChestItem:SmoothStep(t1, t2, x)
  if t1 == t2 then
    return 1
  end
  x = Mathf.Clamp01((x - t1) / (t2 - t1))
  return x * x * (3 - 2 * x)
end

function UITreasureChestItem:IsMoving()
  return self.targetPosition ~= nil and self.startPosition ~= nil
end

function UITreasureChestItem:AnimToMoveTargetPosition(targetPosition, time, direction)
  self.switchTime = time
  if targetPosition then
    self.targetPosition = targetPosition
    self.startPosition = self.transform.position
    self.sumTime = 0
    self.direction = direction
    self.showSwitchEffected = false
    if 0 < self.direction then
      self.transform:SetAsLastSibling()
    else
      self.transform:SetAsFirstSibling()
    end
  end
end

return UITreasureChestItem
