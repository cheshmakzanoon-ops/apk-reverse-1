local LWSeasonHintItem = BaseClass("LWSeasonHintItem", UIBaseContainer)
local base = UIBaseContainer

function LWSeasonHintItem:OnCreate()
  base.OnCreate(self)
  self.title = self:AddComponent(UIText, "title")
  self.desc = self:AddComponent(UIText, "desc")
  self.icon = self:AddComponent(UIImage, "icon")
end

function LWSeasonHintItem:OnDestroy()
  self.title = nil
  self.desc = nil
  self.icon = nil
  base.OnDestroy(self)
end

function LWSeasonHintItem:ReInit(index, theType, imgPath, title, desc)
  self.title:SetLocalText(title)
  self.desc:SetLocalText(desc)
  if self.icon then
    if string.sub(imgPath, 1, 7) == "Assets/" then
      self.icon:LoadSprite(imgPath)
    else
      self.icon:LoadSprite("Assets/Main/Sprites/UI/UISeasonHint/" .. imgPath .. ".png")
    end
  end
end

return LWSeasonHintItem
