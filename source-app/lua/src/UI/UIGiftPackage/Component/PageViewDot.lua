local PageViewDot = BaseClass("PageViewDot", UIBaseContainer)
local base = UIBaseContainer

local function OnCreate(self, ...)
  base.OnCreate(self)
  self:OnSpawn(...)
end

local function OnSpawn(self, ...)
end

local function MyCallback(self, image)
end

local function OnClick(self, toggle_btn, real_index, check)
end

local function OnDestroy(self)
  self.num_text = nil
  self.image_icon = nil
  base.OnDestroy(self)
end

PageViewDot.OnCreate = OnCreate
PageViewDot.OnDestroy = OnDestroy
PageViewDot.OnSpawn = OnSpawn
PageViewDot.OnClick = OnClick
PageViewDot.MyCallback = MyCallback
return PageViewDot
