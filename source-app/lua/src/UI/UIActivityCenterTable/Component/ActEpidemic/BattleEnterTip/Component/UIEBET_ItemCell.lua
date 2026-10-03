local UIEBET_ItemCell = BaseClass("UIEBET_ItemCell", UIBaseContainer)
local base = UIBaseContainer
local big_image_path = "BigImage"
local icon_path = "detail/Icon"
local title_text_path = "detail/TextScrollRect/ViewPort/TitleText"

function UIEBET_ItemCell:OnCreate()
  base.OnCreate(self)
  self.big_image = self:AddComponent(UIRawImage, big_image_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
end

function UIEBET_ItemCell:OnDestroy()
  self.big_image = nil
  self.icon = nil
  self.title_text = nil
  base.OnDestroy(self)
end

function UIEBET_ItemCell:ReInit(v)
  self.title_text:SetLocalText(v.desc)
  self.big_image:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldDesertTexturePath, v.big_pic))
  if v.small_pic ~= nil and v.small_pic ~= "" then
    self.icon:SetActive(true)
    if string.contains(v.small_pic, "zyf_shuomingjiemian") then
      self.icon:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldDesertDetailPath, v.small_pic))
    elseif string.contains(v.small_pic, "_jianzhuxiangqing_") then
      self.icon:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldDesertDetailPath, v.small_pic))
    else
      self.icon:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldDesertPath, v.small_pic))
    end
  else
    self.icon:SetActive(false)
  end
end

return UIEBET_ItemCell
