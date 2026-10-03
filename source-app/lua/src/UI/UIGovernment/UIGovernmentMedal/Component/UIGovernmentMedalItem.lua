local UIGovernmentMedalItem = BaseClass("UIGovernmentMedalItem", UIToggle)
local base = UIToggle

function UIGovernmentMedalItem:OnCreate()
  base.OnCreate(self)
  self.icon = self:AddComponent(UIImage, "Icon")
  self.inUse = self:AddComponent(UIImage, "IsMy")
end

function UIGovernmentMedalItem:OnDestroy()
  base.OnDestroy(self)
end

function UIGovernmentMedalItem:ReInit(index, dataConfig)
  self.index = index
  self.cfg = dataConfig
  self.inUse:SetActive(self.cfg ~= nil and self.cfg.curUse == 1)
  if dataConfig.cfgId then
    local itemCfg = DataCenter.ItemTemplateManager:GetItemTemplate(dataConfig.cfgId)
    if itemCfg ~= nil then
      self.icon:LoadSprite(string.format(LoadPath.ItemPath, itemCfg.icon))
    end
  end
end

function UIGovernmentMedalItem:RefreshUI()
  self.inUse:SetActive(self.cfg ~= nil and self.cfg.curUse == 1)
end

return UIGovernmentMedalItem
