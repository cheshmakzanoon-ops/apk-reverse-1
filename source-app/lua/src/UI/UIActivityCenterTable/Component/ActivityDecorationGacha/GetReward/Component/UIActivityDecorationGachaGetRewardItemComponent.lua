local base = UIBaseContainer
local UIActivityDecorationGachaGetRewardItemComponent = BaseClass("UIActivityDecorationGachaGetRewardItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIActivityDecorationGachaGetRewardItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActivityDecorationGachaGetRewardItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActivityDecorationGachaGetRewardItemComponent:ComponentDefine()
  self.anim = self:AddComponent(UIAnimator, "")
  self.compUICommonResItem = self:AddComponent(UICommonResItem, "UICommonResItem")
  self.animatorCritical = self:AddComponent(UIAnimator, "Critical")
  self.imgCritical = self:AddComponent(UIImage, "Critical")
end

function UIActivityDecorationGachaGetRewardItemComponent:ComponentDestroy()
  self:RemoveCritEffect()
  self.compUICommonResItem = nil
  self.animatorCritical = nil
  self.imgCritical = nil
  self.anim = nil
end

function UIActivityDecorationGachaGetRewardItemComponent:DataDefine()
  self.data = nil
  self.index = nil
end

function UIActivityDecorationGachaGetRewardItemComponent:DataDestroy()
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  self.data = nil
  self.index = nil
end

function UIActivityDecorationGachaGetRewardItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIActivityDecorationGachaGetRewardItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIActivityDecorationGachaGetRewardItemComponent:ReInit(data, index)
  self.data = data
  self.index = index
  self:SetActive(false)
end

function UIActivityDecorationGachaGetRewardItemComponent:ShowInTime(delayTime)
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.delayTimer = nil
    self:ShowItem()
  end, delayTime)
end

function UIActivityDecorationGachaGetRewardItemComponent:ShowItem()
  if self.data == nil then
    return
  end
  self:SetActive(true)
  if not table.IsNullOrEmpty(self.data.rewardData) then
    local resParam = self.data.rewardData[1]
    resParam.isDecorateGacha = true
    self.compUICommonResItem:ReInit(resParam)
  end
  local showCrit = false
  if self.data.multi ~= nil and 1 < self.data.multi then
    showCrit = true
  end
  self.imgCritical:SetActive(showCrit)
  if showCrit then
    local image = RewardCriticalEffectImage[self.data.multi]
    if image ~= nil then
      self.imgCritical:LoadSprite(image)
    end
    self:AddCritEffect()
    self.animatorCritical:Play("Eff_ui_ActSlotMachineMain_5times")
  else
    self:RemoveCritEffect()
  end
  local isBigReward = DataCenter.ActivityDecorationGachaManager:IsBigReward(self.data.pos)
  if isBigReward then
    self.anim:Play("dajiang")
  else
    self.anim:Play("xiaojiang")
  end
  local logStr = "ActivityDecorationGachaGetRewardView ShowItem index: " .. self.index
  Logger.LogInfo(logStr)
end

function UIActivityDecorationGachaGetRewardItemComponent:AddCritEffect()
  if self.effectRequest ~= nil then
    return
  end
  self.effectRequest = self:GameObjectInstantiateAsync("Assets/_Art_LastWar/Effect/Prefab/UI/laba/Eff_ui_s_common_baoji.prefab", function(request)
    if request.isError or self.imgCritical == nil then
      return
    end
    local go = request.gameObject
    go.transform:SetParent(self.imgCritical.transform)
    go.transform:Set_localPosition(0, 0, 0)
    go.name = "effect"
  end)
end

function UIActivityDecorationGachaGetRewardItemComponent:RemoveCritEffect()
  if self.effectRequest ~= nil then
    self:GameObjectDestroy(self.effectRequest)
    self.effectRequest = nil
  end
end

return UIActivityDecorationGachaGetRewardItemComponent
