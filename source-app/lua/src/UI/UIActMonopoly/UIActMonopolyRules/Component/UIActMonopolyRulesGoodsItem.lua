local base = UIBaseContainer
local UIActMonopolyRulesGoodsItem = BaseClass("UIActMonopolyRulesGoodsItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIActMonopolyRulesGoodsItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActMonopolyRulesGoodsItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActMonopolyRulesGoodsItem:ComponentDefine()
  self.compUICommonResItem = self:AddComponent(UICommonResItem, "UICommonResItem")
  self.textProbability = self:AddComponent(UIText, "HaveContent/ProbabilityText")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function UIActMonopolyRulesGoodsItem:ComponentDestroy()
  self.compUICommonResItem = nil
  self.textProbability = nil
  self.btn = nil
end

function UIActMonopolyRulesGoodsItem:DataDefine()
end

function UIActMonopolyRulesGoodsItem:DataDestroy()
end

function UIActMonopolyRulesGoodsItem:OnAddListener()
  base.OnAddListener(self)
end

function UIActMonopolyRulesGoodsItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIActMonopolyRulesGoodsItem:ReInit(activityId, template)
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

function UIActMonopolyRulesGoodsItem:OnBtnClick()
  self.compUICommonResItem:OnBtnClick()
end

return UIActMonopolyRulesGoodsItem
