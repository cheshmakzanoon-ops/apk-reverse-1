local base = UIBaseContainer
local LWUISheepIUseItem = BaseClass("LWUISheepIUseItem", base)
local img_quality_path = "ImgQuality"
local img_icon_path = "img_icon"
local txt_name_path = "txt_name"
local txt_des_path = "txt_des"
local txt_count_path = "txt_count"
local btn_use_path = "btn_use"

function LWUISheepIUseItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWUISheepIUseItem:OnDestroy()
  self.itemId = nil
  self.itemType = nil
  self.parent = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUISheepIUseItem:ComponentDefine()
  self.img_icon = self:AddComponent(UIImage, img_icon_path)
  self.txt_name = self:AddComponent(UITextMeshProUGUIEx, txt_name_path)
  self.txt_des = self:AddComponent(UITextMeshProUGUIEx, txt_des_path)
  self.txt_count = self:AddComponent(UITextMeshProUGUIEx, txt_count_path)
  self.btn_use = self:AddComponent(UIButton, btn_use_path)
  self.img_quality = self:AddComponent(UIImage, img_quality_path)
  self.btn_use:SetOnClick(BindCallback(self, self.OnClickUse))
end

function LWUISheepIUseItem:ComponentDestroy()
  self.img_icon = nil
  self.txt_name = nil
  self.txt_des = nil
  self.txt_count = nil
  self.btn_use = nil
  self.img_quality = nil
end

function LWUISheepIUseItem:SetData(itemId, itemType, parent)
  self.itemId = itemId
  self.itemType = itemType
  self.parent = parent
  local template = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
  local name = DataCenter.ItemTemplateManager:GetName(itemId)
  local icon = DataCenter.ItemTemplateManager:GetIconPath(itemId)
  local des = DataCenter.ItemTemplateManager:GetDes(itemId)
  self.img_quality:LoadSprite(UIUtil.GetItemQualityBg(template.color))
  local count = DataCenter.ItemData:GetItemCount(itemId)
  self.txt_name:SetText(name)
  self.img_icon:LoadSprite(icon)
  self.txt_count:SetLocalText("season_s4_activity_1200010_desc16", count)
  self.txt_des:SetText(des)
end

function LWUISheepIUseItem:OnClickUse()
  self.parent:OnClickUse(self.itemType)
end

return LWUISheepIUseItem
