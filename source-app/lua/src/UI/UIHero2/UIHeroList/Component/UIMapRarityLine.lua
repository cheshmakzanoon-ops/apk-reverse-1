local UIMapRarityLine = BaseClass("UIMapRarityLine", UIBaseContainer)
local base = UIBaseContainer

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.imgRarity = self:AddComponent(UIImage, "ImgRarity")
end

local function ComponentDestroy(self)
  self.imgRarity = nil
end

local function SetData(self, rarity)
  self.imgRarity:LoadSprite(HeroUtils.GetRarityIconName(rarity))
end

UIMapRarityLine.OnCreate = OnCreate
UIMapRarityLine.OnDestroy = OnDestroy
UIMapRarityLine.ComponentDefine = ComponentDefine
UIMapRarityLine.ComponentDestroy = ComponentDestroy
UIMapRarityLine.SetData = SetData
return UIMapRarityLine
