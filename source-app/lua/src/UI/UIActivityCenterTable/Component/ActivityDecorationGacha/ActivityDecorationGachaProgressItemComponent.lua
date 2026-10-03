local base = UIBaseContainer
local ActivityDecorationGachaProgressItemComponent = BaseClass("ActivityDecorationGachaProgressItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function ActivityDecorationGachaProgressItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ActivityDecorationGachaProgressItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ActivityDecorationGachaProgressItemComponent:ComponentDefine()
  self.textNum1 = self:AddComponent(UIText, "num1")
  self.textNum2 = self:AddComponent(UIText, "num2")
  self.compUICommonResItem = self:AddComponent(UICommonResItem, "rewardContent/UICommonResItem")
  self.compRewardContent = self:AddComponent(UIBaseContainer, "rewardContent")
  self.btn = self:AddComponent(UIButton, "rewardContent/clickMask")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.compHaveGet = self:AddComponent(UIBaseContainer, "rewardContent/haveGet")
end

function ActivityDecorationGachaProgressItemComponent:ComponentDestroy()
  self:RemoveHighLight()
  self.textNum1 = nil
  self.textNum2 = nil
  self.compUICommonResItem = nil
  self.compRewardContent = nil
  self.btn = nil
  self.compHaveGet = nil
end

function ActivityDecorationGachaProgressItemComponent:DataDefine()
end

function ActivityDecorationGachaProgressItemComponent:DataDestroy()
end

function ActivityDecorationGachaProgressItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function ActivityDecorationGachaProgressItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function ActivityDecorationGachaProgressItemComponent:ReInit(data, activityId)
  if data == nil or activityId == nil then
    return
  end
  self.data = data
  self.activityId = activityId
  if self.data.reward ~= nil and self.data.reward[1] ~= nil then
    local rewardType = self.data.reward[1].type
    local itemId = self.data.reward[1].value.id
    local itemNum = self.data.reward[1].value.num
    local rewardData = {
      rewardType = rewardType,
      itemId = itemId,
      count = itemNum
    }
    self.compUICommonResItem:ReInit(rewardData)
  end
  self.textNum1:SetText(tostring(data.target))
  self.textNum2:SetText(tostring(data.target))
  local activityData = DataCenter.ActivityDecorationGachaManager:GetActivityData(activityId)
  if activityData == nil then
    return
  end
  local state = activityData:GetProgressState(data.index)
  self.textNum2:SetActive(state == 0)
  self.textNum1:SetActive(state ~= 0)
  if state == 0 then
    self.compHaveGet:SetActive(false)
  elseif state == 1 then
    self.compHaveGet:SetActive(false)
    self:AddHighLight()
  else
    self.compHaveGet:SetActive(true)
    self:RemoveHighLight()
  end
end

function ActivityDecorationGachaProgressItemComponent:AddHighLight()
  if self.effectRequest ~= nil then
    return
  end
  self.effectRequest = self:GameObjectInstantiateAsync(EffectAssets.ItemCanGetEffect, function(request)
    if request.isError or self.compRewardContent == nil then
      return
    end
    local go = request.gameObject
    go.transform:SetParent(self.compRewardContent.transform)
    go.transform:Set_localPosition(0, 0, 0)
    go.transform:Set_localScale(0.85, 0.85, 0.85)
    go.name = "effect"
  end)
end

function ActivityDecorationGachaProgressItemComponent:RemoveHighLight()
  if self.effectRequest ~= nil then
    self:GameObjectDestroy(self.effectRequest)
    self.effectRequest = nil
  end
end

function ActivityDecorationGachaProgressItemComponent:OnBtnClick()
  if self.data == nil or self.activityId == nil then
    return
  end
  local activityData = DataCenter.ActivityDecorationGachaManager:GetActivityData(self.activityId)
  if activityData == nil then
    return
  end
  local state = activityData:GetProgressState(self.data.index)
  if state == 1 then
    DataCenter.ActivityDecorationGachaManager:SendClaimProgressMessage(self.activityId, self.data.index)
    return
  end
  self.compUICommonResItem:OnBtnClick()
  PostEventLog.Track(PostEventLog.Defines.ActivityDecorationGachaOpenProgress, {
    activityId = tostring(self.activityId),
    index = self.data.index
  })
end

return ActivityDecorationGachaProgressItemComponent
