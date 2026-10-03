local base = UIBaseContainer
local UILWBoxItemDrawProbabilityItemComponent = BaseClass("UILWBoxItemDrawProbabilityItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWBoxItemDrawProbabilityItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWBoxItemDrawProbabilityItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWBoxItemDrawProbabilityItemComponent:ComponentDefine()
  self.compUICommonResItem = self:AddComponent(UICommonResItem, "UICommonResItem")
  self.textTitle = self:AddComponent(UIText, "TitleText")
  self.textDes = self:AddComponent(UIText, "DesText")
  self.compTag = self:AddComponent(UIBaseContainer, "Tag")
end

function UILWBoxItemDrawProbabilityItemComponent:ComponentDestroy()
  self.compUICommonResItem = nil
  self.textTitle = nil
  self.textDes = nil
  self.compTag = nil
end

function UILWBoxItemDrawProbabilityItemComponent:DataDefine()
end

function UILWBoxItemDrawProbabilityItemComponent:DataDestroy()
end

function UILWBoxItemDrawProbabilityItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWBoxItemDrawProbabilityItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWBoxItemDrawProbabilityItemComponent:ReInit(groupId, rewardData)
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
  self.compUICommonResItem:ReInit(rewardData)
  local probability = self.template:GetProbability(rewardData.index)
  self.textTitle:SetText(Localization:GetString("activity_torch_relay_desc_22", string.formatDecimal(probability * 100, 1) .. "%"))
  self.textDes:SetText(Localization:GetString("activity_torch_relay_desc_40", tostring(self.data:GetCurCount(rewardData.index)), tostring(rewardData.limit)))
  self.compTag:SetActive(self.template:IsBigReward(rewardData.index))
end

return UILWBoxItemDrawProbabilityItemComponent
