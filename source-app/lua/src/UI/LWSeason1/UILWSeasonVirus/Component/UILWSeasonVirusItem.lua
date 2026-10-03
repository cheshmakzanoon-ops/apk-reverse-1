local UILWSeasonVirusItem = BaseClass("UILWSeasonVirusItem", UIBaseContainer)
local base = UIBaseContainer

function UILWSeasonVirusItem:OnCreate()
  base.OnCreate(self)
  self.title = self:AddComponent(UIText, "title")
  self.desc = self:AddComponent(UIText, "desc")
  self.icon = self:AddComponent(UIImage, "icon")
end

function UILWSeasonVirusItem:OnDestroy()
  self.title = nil
  self.desc = nil
  self.icon = nil
  base.OnDestroy(self)
end

function UILWSeasonVirusItem:ReInit(index, theType, imgPath, title, desc)
  self.title:SetLocalText(title)
  self.desc:SetLocalText(desc)
  if self.icon then
    if imgPath == "Assets/Main/TextureEx/Season/Activity/Mjc_saijibingdu_pop_baozhuang_tu.png" then
      self.icon:LoadSpriteAuto("Assets/Main/Sprites/UI/UISeasonHint/Mjc_saijibingdu_pop_baozhuang_tu.png")
    elseif string.sub(imgPath, 1, 7) == "Assets/" then
      self.icon:LoadSpriteAuto(imgPath)
    else
      self.icon:LoadSpriteAuto("Assets/Main/Sprites/UI/UISeasonHint/" .. imgPath .. ".png")
    end
  end
end

return UILWSeasonVirusItem
