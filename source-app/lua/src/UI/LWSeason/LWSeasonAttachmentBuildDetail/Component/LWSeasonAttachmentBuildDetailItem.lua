local LWSeasonAttachmentBuildDetailItem = BaseClass("LWSeasonAttachmentBuildDetailItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local res_item_path = "ResItem"
local desc_text_path = "DescText"

function LWSeasonAttachmentBuildDetailItem:OnCreate()
  base.OnCreate(self)
  self.res_item = self:AddComponent(UICommonResItem, res_item_path)
  self.desc_text = self:AddComponent(UIText, desc_text_path)
end

function LWSeasonAttachmentBuildDetailItem:OnDestroy()
  base.OnDestroy(self)
end

function LWSeasonAttachmentBuildDetailItem:ReInit(param)
  self.res_item:ReInit(param)
  if param and param.itemName then
    if param.isLocal then
      self.desc_text:SetText(param.itemName)
    else
      self.desc_text:SetLocalText(param.itemName)
    end
  elseif param and param.itemId then
    local rewardType = param.rewardType or RewardType.GOODS
    if rewardType == RewardType.GOODS then
      local goods = DataCenter.ItemTemplateManager:GetItemTemplate(param.itemId)
      if goods ~= nil then
        local name = DataCenter.ItemTemplateManager:GetName(goods.id)
        self.desc_text:SetText(name)
      else
        local resName = GetTableData(TableName.Resource, param.itemId, "name")
        self.desc_text:SetLocalText(resName)
      end
    elseif rewardType == RewardType.RESOURCE_ITEM then
      local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(param.itemId)
      if template then
        self.desc_text:SetLocalText(template.name)
      end
    elseif rewardType == RewardType.HERO then
      local line = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), param.itemId)
      if line then
        self.desc_text:SetLocalText(line:getValue("name"))
      end
    elseif rewardType == RewardType.Building then
      local line = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.Building), param.itemId)
      if line then
        self.desc_text:SetLocalText(line:getValue("name"))
      end
    end
  end
end

return LWSeasonAttachmentBuildDetailItem
