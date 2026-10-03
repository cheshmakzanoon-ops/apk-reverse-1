local UIBattleFieldUpdateNoteItem = BaseClass("UIBattleFieldUpdateNoteItem", UIBaseContainer)
local base = UIBaseContainer
local big_image_path = "BigImage"
local index_bg_path = "IndexBg"
local index_text_path = "IndexBg/IndexText"
local title_text_path = "TextScrollRect/ViewPort/TitleText"

function UIBattleFieldUpdateNoteItem:OnCreate()
  base.OnCreate(self)
  self.big_image = self:AddComponent(UIRawImage, big_image_path)
  self.index_bg = self:AddComponent(UIBaseComponent, index_bg_path)
  self.index_text = self:AddComponent(UITextMeshProUGUIEx, index_text_path)
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
end

function UIBattleFieldUpdateNoteItem:OnDestroy()
  self.big_image = nil
  self.icon = nil
  self.title_text = nil
  base.OnDestroy(self)
end

function UIBattleFieldUpdateNoteItem:ReInit(v, index, max)
  self.title_text:SetLocalText(v.desc)
  self.index_text:SetText(index .. "/" .. max)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.index_text.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.index_bg.rectTransform)
  self.big_image:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldDesertTexturePath, v.pic))
end

return UIBattleFieldUpdateNoteItem
