local CircleImage = BaseClass("CircleImage", UIBaseComponent)
local base = UIBaseComponent
local UnityImage = typeof(CS.CircleImage)

local function OnCreate(self)
  base.OnCreate(self)
  self.unity_image = self.gameObject:GetComponent(UnityImage)
end

local function LoadSprite(self, sprite_path, default_sprite)
  if self.spritePath == sprite_path then
    return
  end
  self.spritePath = sprite_path
  self.unity_image:LoadSprite(sprite_path, default_sprite)
end

local function SetIsCircle(self, state)
  self.unity_image.isCircle = state
end

local function OnDestroy(self)
  self.unity_image = nil
  base.OnDestroy(self)
end

CircleImage.OnCreate = OnCreate
CircleImage.LoadSprite = LoadSprite
CircleImage.OnDestroy = OnDestroy
CircleImage.SetIsCircle = SetIsCircle
return CircleImage
