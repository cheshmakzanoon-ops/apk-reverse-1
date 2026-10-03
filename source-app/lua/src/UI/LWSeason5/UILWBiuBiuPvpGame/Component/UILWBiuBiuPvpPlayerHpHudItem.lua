local base = UIBaseContainer
local UILWBiuBiuPvpPlayerHpHudItem = BaseClass("UILWBiuBiuPvpPlayerHpHudItem.lua", base)
local slider_back_ground_path = "Slider_BackGround"
local slider_self_path = "Slider_Self"
local slider_target_path = "Slider_Target"
local fengge_path = "fengge"

function UILWBiuBiuPvpPlayerHpHudItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.isMe = nil
  self.genViews = {}
  self.tweens = {}
end

function UILWBiuBiuPvpPlayerHpHudItem:OnDestroy()
  self:ComponentDestroy()
  self.genViews = nil
  if self.tweens ~= nil then
    for _, v in pairs(self.tweens) do
      v:Kill()
    end
    self.tweens = nil
  end
  base.OnDestroy(self)
end

function UILWBiuBiuPvpPlayerHpHudItem:ComponentDefine()
  self.slider_back_ground = self:AddComponent(UISlider, slider_back_ground_path)
  self.slider_self = self:AddComponent(UISlider, slider_self_path)
  self.slider_target = self:AddComponent(UISlider, slider_target_path)
  self.fengge = self:AddComponent(UIImage, fengge_path)
  self.go_fengge = self.fengge.gameObject
  self.go_fengge:GameObjectCreatePool()
end

function UILWBiuBiuPvpPlayerHpHudItem:ComponentDestroy()
  self.slider_back_ground = nil
  self.slider_self = nil
  self.slider_target = nil
  self.fengge = nil
  self.go_fengge:GameObjectRecycleAll()
  self.go_fengge = nil
end

function UILWBiuBiuPvpPlayerHpHudItem:GetSelfSlider()
  return self.isMe and self.slider_self or self.slider_target
end

function UILWBiuBiuPvpPlayerHpHudItem:GetTargetSlider()
  return self.isMe and self.slider_target or self.slider_self
end

function UILWBiuBiuPvpPlayerHpHudItem:Refresh(isMe, curHp, maxHp)
  self.isMe = isMe
  local selfSlider = self:GetSelfSlider()
  local targetSlider = self:GetTargetSlider()
  selfSlider:SetActive(true)
  targetSlider:SetActive(false)
  self:SetSizeDeltaX(48 * maxHp)
  self:RefreshFenGe(maxHp)
  self:ClearTween()
  local curValue = curHp / maxHp
  table.insert(self.tweens, selfSlider:DOValue(curValue, 0.05))
  table.insert(self.tweens, self.slider_back_ground:DOValue(curValue, 0.2))
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
end

function UILWBiuBiuPvpPlayerHpHudItem:RefreshFenGe(maxHp)
  for index = 1, maxHp - 1 do
    local fenGeView = self.genViews[index]
    if fenGeView == nil then
      fenGeView = self.go_fengge:GameObjectSpawn(self.rectTransform)
      fenGeView = fenGeView:GetComponent(typeof(CS.UnityEngine.RectTransform))
      self.genViews[index] = fenGeView
    end
    fenGeView.gameObject:SetActive(true)
    fenGeView.anchoredPosition = Vector2.New(47 * index, self.fengge:GetAnchoredPositionY())
  end
end

function UILWBiuBiuPvpPlayerHpHudItem:ClearTween()
  if self.tweens ~= nil then
    for _, v in pairs(self.tweens) do
      v:Kill()
    end
    self.tweens = {}
  end
end

return UILWBiuBiuPvpPlayerHpHudItem
