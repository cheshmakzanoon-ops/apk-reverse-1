local base = UIBaseContainer
local UILWBoxItemDrawItemComponent = BaseClass("UILWBoxItemDrawItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWBoxItemDrawItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWBoxItemDrawItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWBoxItemDrawItemComponent:ComponentDefine()
  self.compUICommonResItem = self:AddComponent(UICommonResItem, "UICommonResItem")
  self.textNum = self:AddComponent(UIText, "NumText")
  self.compTag = self:AddComponent(UIBaseContainer, "Tag")
  self.compHighlight = self:AddComponent(UIBaseContainer, "Highlight")
  self.getCountsFlag = self:AddComponent(UIBaseContainer, "getCountsFlag")
  self.getCountsText = self:AddComponent(UIText, "getCountsFlag/bg/getCounts")
  self.vfxNode = self:AddComponent(UIVfx, "Fx", EffectAssets.TorchRelayBoxPropsGet)
end

function UILWBoxItemDrawItemComponent:ComponentDestroy()
  self.compUICommonResItem = nil
  self.textNum = nil
  self.compTag = nil
  self.compHighlight = nil
end

function UILWBoxItemDrawItemComponent:DataDefine()
end

function UILWBoxItemDrawItemComponent:DataDestroy()
  self:StopTimer()
end

function UILWBoxItemDrawItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWBoxItemDrawItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWBoxItemDrawItemComponent:ReInit(groupId, rewardData)
  if rewardData == nil then
    return
  end
  self.groupId = groupId
  self.data = DataCenter.BoxItemDrawManager:GetUserData(self.groupId)
  if self.data == nil then
    return
  end
  self.template = self.data:GetTemplate(self.data:GetCurRound())
  if self.template == nil then
    return
  end
  self.compHighlight:SetActive(false)
  self.compUICommonResItem:ReInit(rewardData)
  self.textNum:SetText(tostring(self.data:GetCurCount(rewardData.index)) .. "/" .. tostring(rewardData.limit))
  self.compTag:SetActive(self.template:IsBigReward(rewardData.index))
  self.getCounts = 0
  self.getCountsFlag:SetActive(false)
end

function UILWBoxItemDrawItemComponent:HideHighlight()
  if self.compHighlight then
    self.compHighlight:SetActive(false)
  end
end

function UILWBoxItemDrawItemComponent:ShowHighlight(delayHideTime)
  self:StopTimer()
  if self.compHighlight then
    self.compHighlight:SetActive(true)
    if 0 < delayHideTime then
      self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
        if self.compHighlight then
          self.compHighlight:SetActive(false)
        end
      end, delayHideTime)
    end
  end
end

function UILWBoxItemDrawItemComponent:AddGetCounts()
  self.getCounts = self.getCounts + 1
  self.getCountsText:SetText(self.getCounts)
  self.getCountsFlag:SetActive(true)
end

function UILWBoxItemDrawItemComponent:ShowGetVfx()
  if self.vfxNode then
    self.vfxNode:Replay()
  end
end

function UILWBoxItemDrawItemComponent:StopTimer()
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

return UILWBoxItemDrawItemComponent
