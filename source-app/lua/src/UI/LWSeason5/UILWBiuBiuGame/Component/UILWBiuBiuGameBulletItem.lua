local base = UIBaseContainer
local UILWBiuBiuGameBulletItem = BaseClass("UILWBiuBiuGameBulletItem.lua", base)
local img_icon_path = "img_icon"

function UILWBiuBiuGameBulletItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.index = nil
end

function UILWBiuBiuGameBulletItem:OnDestroy()
  self.index = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWBiuBiuGameBulletItem:ComponentDefine()
  self.img_icon = self:AddComponent(UIImage, img_icon_path)
end

function UILWBiuBiuGameBulletItem:ComponentDestroy()
  self.img_icon = nil
end

function UILWBiuBiuGameBulletItem:InitData(index)
  self.index = index
end

function UILWBiuBiuGameBulletItem:RefreshUI(bulletCount)
  self.img_icon:SetActive(bulletCount < self.index)
end

return UILWBiuBiuGameBulletItem
