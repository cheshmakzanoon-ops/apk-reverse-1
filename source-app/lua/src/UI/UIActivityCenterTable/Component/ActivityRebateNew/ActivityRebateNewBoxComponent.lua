local base = UIBaseContainer
local ActivityRebateNewBoxComponent = BaseClass("ActivityRebateNewBoxComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function ActivityRebateNewBoxComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ActivityRebateNewBoxComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ActivityRebateNewBoxComponent:ComponentDefine()
  self.textScore = self:AddComponent(UIText, "TextBox")
  self.compItem = self:AddComponent(UICommonResItem, "UICommonResItem")
  self.compFinished = self:AddComponent(UIBaseContainer, "finishContent")
  self.compCanClaim = self:AddComponent(UIBaseContainer, "effectContentCanClaim")
  self.btnClaim = self:AddComponent(UIButton, "ClaimBtn")
  self.btnClaim:SetOnClick(function()
    self:OnBtnClaimClick()
  end)
end

function ActivityRebateNewBoxComponent:ComponentDestroy()
  self.textScore = nil
  self.compItem = nil
  self.compFinished = nil
  self.compCanClaim = nil
  self.btnClaim = nil
end

function ActivityRebateNewBoxComponent:DataDefine()
  self.activityId = 0
  self.data = nil
end

function ActivityRebateNewBoxComponent:DataDestroy()
  self.activityId = nil
  self.data = nil
end

function ActivityRebateNewBoxComponent:OnAddListener()
  base.OnAddListener(self)
end

function ActivityRebateNewBoxComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function ActivityRebateNewBoxComponent:SetData(data, activityId)
  self.data = data
  self.activityId = activityId
  if self.data == nil or self.activityId == nil then
    return
  end
  self:UpdateAll()
end

function ActivityRebateNewBoxComponent:UpdateAll()
  if self.data == nil or self.activityId == nil then
    return
  end
  self.textScore:SetText(tostring(self.data.score))
  local state = DataCenter.ActivityRebateNewManager:GetProgressBoxState(self.data.index, self.activityId)
  self.compCanClaim:SetActive(state == 1)
  self.btnClaim:SetActive(state == 1)
  self.compFinished:SetActive(state == 2)
  local rewards = DataCenter.ActivityRebateNewManager:GetProgressBoxRewardData(self.data.rewardId)
  if rewards[1] ~= nil then
    self.compItem:ReInit(rewards[1])
  end
end

function ActivityRebateNewBoxComponent:OnBtnClaimClick()
  if self.data ~= nil and self.activityId ~= nil then
    local state = DataCenter.ActivityRebateNewManager:GetProgressBoxState(self.data.index, self.activityId)
    if state == 1 then
      DataCenter.ActivityRebateNewManager:SendClaimProgress(self.data.index, self.activityId)
    end
  end
end

return ActivityRebateNewBoxComponent
