local base = UIBaseContainer
local UIBanquetItemDropProbabilityItem_Box_Info = BaseClass("UIBanquetItemDropProbabilityItem_Box_Info", base)
local M = UIBanquetItemDropProbabilityItem_Box_Info

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function M:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.resItem = self:AddComponent(UICommonResItem, "UICommonResItem")
  self.textMonsterName = self:AddComponent(UITextMeshProUGUIEx, "monsterName")
  self.textMonsterDesc = self:AddComponent(UITextMeshProUGUIEx, "monsterDesc")
end

function M:ComponentDestroy()
  self.resItem = nil
  self.textMonsterName = nil
  self.textMonsterDesc = nil
end

function M:SetData(data)
  local param = {}
  param.itemId = data.para1
  param.count = 0
  param.rewardType = RewardType.GOODS
  self.resItem:ReInit(param)
  self.resItem:SetItemCountActive(false)
  local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(data.para1)
  if itemTemplate then
    self.textMonsterName:SetText(itemTemplate:GetName())
  end
  self.textMonsterDesc:SetLocalText(data.content_text)
end

return UIBanquetItemDropProbabilityItem_Box_Info
