local base = UIBaseContainer
local AllyDuelScoreGachaRulesGoodsItemComponent = BaseClass("AllyDuelScoreGachaRulesGoodsItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function AllyDuelScoreGachaRulesGoodsItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function AllyDuelScoreGachaRulesGoodsItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AllyDuelScoreGachaRulesGoodsItemComponent:ComponentDefine()
  self.compUICommonResItem = self:AddComponent(UICommonResItem, "UICommonResItem")
  self.textProbability = self:AddComponent(UIText, "HaveContent/ProbabilityText")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function AllyDuelScoreGachaRulesGoodsItemComponent:ComponentDestroy()
  self.compUICommonResItem = nil
  self.textProbability = nil
  self.btn = nil
end

function AllyDuelScoreGachaRulesGoodsItemComponent:DataDefine()
end

function AllyDuelScoreGachaRulesGoodsItemComponent:DataDestroy()
end

function AllyDuelScoreGachaRulesGoodsItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function AllyDuelScoreGachaRulesGoodsItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function AllyDuelScoreGachaRulesGoodsItemComponent:ReInit(configId, template)
  if template == nil then
    return
  end
  local para = {}
  para.rewardType = RewardType.GOODS
  para.itemId = template.itemId
  para.count = template.itemCount
  self.compUICommonResItem:ReInit(para)
  local totalProp = DataCenter.AllyDuelScoreGachaManager:GetTotalProbability(configId)
  local probabilityStr = 0 < totalProp and string.formatDecimal(template.showPara / totalProp * 100, 2) .. "%" or ""
  self.textProbability:SetText(probabilityStr)
end

function AllyDuelScoreGachaRulesGoodsItemComponent:OnBtnClick()
  self.compUICommonResItem:OnBtnClick()
end

return AllyDuelScoreGachaRulesGoodsItemComponent
