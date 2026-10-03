local base = UIBaseContainer
local ActivityDecorationGachaRulesGoodsItemComponent = BaseClass("ActivityDecorationGachaRulesGoodsItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function ActivityDecorationGachaRulesGoodsItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ActivityDecorationGachaRulesGoodsItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ActivityDecorationGachaRulesGoodsItemComponent:ComponentDefine()
  self.compUICommonResItem = self:AddComponent(UICommonResItem, "UICommonResItem")
  self.textProbability = self:AddComponent(UIText, "HaveContent/ProbabilityText")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function ActivityDecorationGachaRulesGoodsItemComponent:ComponentDestroy()
  self.compUICommonResItem = nil
  self.textProbability = nil
  self.btn = nil
end

function ActivityDecorationGachaRulesGoodsItemComponent:DataDefine()
end

function ActivityDecorationGachaRulesGoodsItemComponent:DataDestroy()
end

function ActivityDecorationGachaRulesGoodsItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function ActivityDecorationGachaRulesGoodsItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function ActivityDecorationGachaRulesGoodsItemComponent:ReInit(activityId, template)
  if template == nil then
    return
  end
  local para = {}
  para.rewardType = RewardType.GOODS
  para.itemId = template.para1
  para.count = template.num
  self.compUICommonResItem:ReInit(para)
  local probabilityStr = string.formatDecimal(template.dropShow / 100, 2) .. "%"
  self.textProbability:SetText(probabilityStr)
end

function ActivityDecorationGachaRulesGoodsItemComponent:OnBtnClick()
  self.compUICommonResItem:OnBtnClick()
end

return ActivityDecorationGachaRulesGoodsItemComponent
