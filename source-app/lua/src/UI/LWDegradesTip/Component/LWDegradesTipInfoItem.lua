local LWDegradesTipInfoItem = BaseClass("LWDegradesTipInfoItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function LWDegradesTipInfoItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWDegradesTipInfoItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWDegradesTipInfoItem:ComponentDefine()
  local soldier_icon_src_path = "SoldierIconSrc"
  local soldier_level_src_path = "SoldierLevelSrc"
  local soldier_icon_dest_path = "SoldierIconDest"
  local soldier_level_dest_path = "SoldierLevelDest"
  local degrades_count_path = "DegradesCount"
  self.soldier_icon_src = self:AddComponent(UIImage, soldier_icon_src_path)
  self.soldier_level_src = self:AddComponent(UITextMeshProUGUIEx, soldier_level_src_path)
  self.soldier_icon_dest = self:AddComponent(UIImage, soldier_icon_dest_path)
  self.soldier_level_dest = self:AddComponent(UITextMeshProUGUIEx, soldier_level_dest_path)
  self.degrades_count = self:AddComponent(UITextMeshProUGUIEx, degrades_count_path)
end

function LWDegradesTipInfoItem:ComponentDestroy()
  self.soldier_icon_src = nil
  self.soldier_level_src = nil
  self.soldier_icon_dest = nil
  self.soldier_level_dest = nil
  self.degrades_count = nil
end

function LWDegradesTipInfoItem:SetData(data)
  local srcMeta = DataCenter.SoldierDataManager:GetTemplate(data.soldierId)
  self.soldier_level_src:SetLocalText("300665", srcMeta.lv)
  self.soldier_icon_src:LoadSprite(string.format(LoadPath.ItemPath, srcMeta.icon))
  local destMeta = DataCenter.SoldierDataManager:GetSoldierTemplateByLevel(srcMeta.lv - 1)
  self.soldier_level_dest:SetLocalText("300665", destMeta.lv)
  self.soldier_icon_dest:LoadSprite(string.format(LoadPath.ItemPath, destMeta.icon))
  self.degrades_count:SetText(string.format("x%d", data.degrade))
end

return LWDegradesTipInfoItem
