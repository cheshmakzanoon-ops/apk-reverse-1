local MailKillItem = BaseClass("MailKillItem", UIBaseContainer)
local base = UIBaseContainer
local quality_bg_path = "QualityBg"
local icon_path = "Icon"
local level_path = "level"
local count_path = "count"

function MailKillItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function MailKillItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MailKillItem:ComponentDefine()
  self.quality_bg = self:AddComponent(UIImage, quality_bg_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.level = self:AddComponent(UITextMeshProUGUIEx, level_path)
  self.count = self:AddComponent(UITextMeshProUGUIEx, count_path)
end

function MailKillItem:ComponentDestroy()
end

function MailKillItem:SetData(configId, count)
  local soldierMeta = DataCenter.SoldierDataManager:GetTemplate(configId)
  if soldierMeta == nil then
    return
  end
  self.quality_bg:LoadSprite(UIUtil.GetItemQualityBg(soldierMeta.quality))
  self.icon:LoadSprite(string.format(LoadPath.ItemPath, soldierMeta.icon))
  self.level:SetLocalText("300665", soldierMeta.lv)
  self.count:SetText("\195\151" .. count)
end

function MailKillItem:OnEnable()
  base.OnEnable(self)
end

function MailKillItem:OnDisable()
  base.OnDisable(self)
end

function MailKillItem:OnAddListener()
  base.OnAddListener(self)
end

function MailKillItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

return MailKillItem
