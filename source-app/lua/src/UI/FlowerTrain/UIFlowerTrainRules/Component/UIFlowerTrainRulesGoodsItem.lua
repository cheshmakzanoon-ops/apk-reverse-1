local base = UIBaseContainer
local UIFlowerTrainRulesGoodsItem = BaseClass("UIFlowerTrainRulesGoodsItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIFlowerTrainRulesGoodsItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIFlowerTrainRulesGoodsItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIFlowerTrainRulesGoodsItem:ComponentDefine()
  self.compUICommonResItem = self:AddComponent(UICommonResItem, "UICommonResItem")
  self.textProbability = self:AddComponent(UIText, "HaveContent/ProbabilityText")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function UIFlowerTrainRulesGoodsItem:ComponentDestroy()
  self.compUICommonResItem = nil
  self.textProbability = nil
  self.btn = nil
end

function UIFlowerTrainRulesGoodsItem:DataDefine()
end

function UIFlowerTrainRulesGoodsItem:DataDestroy()
end

function UIFlowerTrainRulesGoodsItem:OnAddListener()
  base.OnAddListener(self)
end

function UIFlowerTrainRulesGoodsItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIFlowerTrainRulesGoodsItem:ReInit(activityId, template)
  if template == nil then
    return
  end
  local para = {}
  para.rewardType = RewardType.GOODS
  para.itemId = template.para1
  para.count = template.num
  self.compUICommonResItem:ReInit(para)
  local probabilityStr = string.formatDecimal(template.drop_show / 100, 2) .. "%"
  self.textProbability:SetText(probabilityStr)
end

function UIFlowerTrainRulesGoodsItem:OnBtnClick()
  self.compUICommonResItem:OnBtnClick()
end

return UIFlowerTrainRulesGoodsItem
