local UIImage = BaseClass("UIImage", UIBaseComponent)
local base = UIBaseComponent
local UnityImage = typeof(CS.UnityEngine.UI.Image)

local function OnCreate(self, cs_comp)
  base.OnCreate(self)
  if not cs_comp then
    self.unity_image = self.gameObject:GetComponent(UnityImage)
  else
    self.unity_image = cs_comp
  end
end

local function LoadSprite(self, sprite_path, default_sprite)
  if not self:CheckPath(sprite_path) then
    return false
  end
  if self.spritePath == sprite_path then
    return false
  end
  if IsNull(self.unity_image) then
    return false
  end
  self.spritePath = sprite_path
  self.unity_image:LoadSprite(sprite_path, default_sprite)
  return true
end

local function CheckPath(self, path)
  if string.IsNullOrEmpty(path) then
    Logger.LogError("LoadSprite:error path == null ")
    return false
  end
  local filename = string.match(path, "([^/]+)$")
  if string.IsNullOrEmpty(filename) then
    Logger.LogError("LoadSprite:error path: " .. path)
    return false
  end
  if string.find(filename, "%.") == 1 then
    Logger.LogError("LoadSprite:error path: " .. path)
    return false
  end
  return true
end

function UIImage:LoadSpriteAsync(sprite_path, default_sprite)
  if not self:CheckPath(sprite_path) then
    return false
  end
  if self.spritePath == sprite_path then
    return false
  end
  if IsNull(self.unity_image) then
    return false
  end
  self.spritePath = sprite_path
  self.unity_image:LoadSpriteAsync(sprite_path, default_sprite)
end

function UIImage:LoadSpriteAsyncWithCallback(sprite_path, callback, default_sprite)
  if not self:CheckPath(sprite_path) then
    return false
  end
  if self.spritePath == sprite_path then
    return false
  end
  if IsNull(self.unity_image) then
    return false
  end
  self.spritePath = sprite_path
  local assetPath = sprite_path
  local nameLength = #sprite_path
  if 4 < nameLength and string.find(sprite_path, ".png", nameLength - 3, true) == nil then
    assetPath = sprite_path .. ".png"
  end
  local isReady = UIUtil.CheckAssetDownloaded(assetPath)
  if isReady then
    self.unity_image:LoadSprite(assetPath, default_sprite)
    if type(callback) == "function" then
      callback()
    end
    return true
  end
  self.unity_image:LoadSpriteAsync(assetPath, callback, default_sprite)
  return true
end

function UIImage:LoadSpriteAsyncEx(sprite_path, default_sprite)
  if not self:CheckPath(sprite_path) then
    return
  end
  if self.spritePath == sprite_path then
    return
  end
  if IsNull(self.unity_image) then
    return
  end
  self.spritePath = sprite_path
  self.unity_image:LoadSpriteAsync(sprite_path, default_sprite)
end

function UIImage:LoadSpriteAuto(sprite_path, default_sprite)
  if not self:CheckPath(sprite_path) then
    return false
  end
  if self.spritePath == sprite_path then
    return false
  end
  if IsNull(self.unity_image) then
    return false
  end
  self.spritePath = sprite_path
  local assetPath = sprite_path
  local nameLength = #sprite_path
  if 4 < nameLength and string.find(sprite_path, ".png", nameLength - 3, true) == nil then
    assetPath = sprite_path .. ".png"
  end
  local isReady = UIUtil.CheckAssetDownloaded(assetPath)
  if isReady then
    self.unity_image:LoadSprite(assetPath, default_sprite)
  else
    self.unity_image:LoadSpriteAsync(assetPath, default_sprite)
  end
  return true
end

local function OnDestroy(self)
  self.unity_image = nil
  self.spritePath = nil
  base.OnDestroy(self)
end

local function SetFillAmount(self, value)
  if IsNull(self.unity_image) then
    return
  end
  self.unity_image.fillAmount = value
end

local function GetFillAmount(self)
  if IsNull(self.unity_image) then
    return 0
  end
  return self.unity_image.fillAmount
end

local function SetMaterial(self, value)
  if IsNull(self.unity_image) then
    return
  end
  self.unity_image.material = value
end

local function GetMaterial(self)
  if IsNull(self.unity_image) then
    return nil
  end
  return self.unity_image.material
end

local function GetImage(self)
  if IsNull(self.unity_image) then
    return nil
  end
  return self.unity_image.sprite
end

local function SetImage(self, value)
  if IsNull(self.unity_image) then
    return
  end
  self.unity_image.sprite = value
end

function UIImage:SetColorHex(hexValue)
  self:SetColor(UIUtil.HexToColor(hexValue))
end

local function SetColor(self, value)
  if IsNull(self.unity_image) then
    return
  end
  self.unity_image:Set_color(value.r or 1, value.g or 1, value.b or 1, value.a or 1)
end

local function SetColorRGBA(self, r, g, b, a)
  if IsNull(self.unity_image) then
    return
  end
  self.unity_image:Set_color(r or 1, g or 1, b or 1, a or 1)
end

local function SetColorRGBA255(self, r, g, b, a)
  if IsNull(self.unity_image) then
    return
  end
  self.unity_image:Set_color((r or 255) / 255, (g or 255) / 255, (b or 255) / 255, (a or 255) / 255)
end

local function GetColorRGBA(self)
  if IsNull(self.unity_image) then
    return Color.New(0, 0, 0, 0)
  end
  return self.unity_image:Get_color()
end

local function GetColor(self)
  local r, g, b, a = self:GetColorRGBA()
  return Color.New(r, g, b, a)
end

local function SetAlpha(self, value)
  local color = self:GetColor()
  self:SetColorRGBA(color.r, color.g, color.b, value)
end

local function SetNativeSize(self)
  if IsNull(self.unity_image) then
    return
  end
  self.unity_image:SetNativeSize()
end

local function SetAspectSize(self, size)
  if IsNull(self.unity_image) then
    return
  end
  self.unity_image.preserveAspect = true
  self:SetSizeDeltaXY(size, size)
end

local function SetEnable(self, enable)
  if IsNull(self.unity_image) then
    return
  end
  self.unity_image.enabled = enable
end

local function SetRaycastTarget(self, raycastTarget)
  if IsNull(self.unity_image) then
    return
  end
  self.unity_image.raycastTarget = raycastTarget
end

local function SetMaskable(self, maskable)
  self.unity_image.maskable = maskable
end

function UIImage:SetFlipX(status)
  local x, y, z = self:GetLocalScaleXYZ()
  if status then
    self:SetLocalScaleXYZ(-math.abs(x), y, z)
  else
    self:SetLocalScaleXYZ(math.abs(x), y, z)
  end
end

function UIImage:SetFlipY(status)
  local x, y, z = self:GetLocalScaleXYZ()
  if status then
    self:SetLocalScaleXYZ(x, -math.abs(y), z)
  else
    self:SetLocalScaleXYZ(x, math.abs(y), z)
  end
end

function UIImage:DOFade(to, duration)
  return self.unity_image:DOFade(to, duration)
end

function UIImage:SetGrayNotRecursively(setGray)
  CS.UIGray.SetGrayNotRecursively(self.unity_image, setGray)
end

UIImage.OnCreate = OnCreate
UIImage.LoadSprite = LoadSprite
UIImage.OnDestroy = OnDestroy
UIImage.SetFillAmount = SetFillAmount
UIImage.GetFillAmount = GetFillAmount
UIImage.SetMaterial = SetMaterial
UIImage.GetMaterial = GetMaterial
UIImage.GetImage = GetImage
UIImage.SetImage = SetImage
UIImage.SetColor = SetColor
UIImage.SetColorRGBA = SetColorRGBA
UIImage.SetColorRGBA255 = SetColorRGBA255
UIImage.GetColorRGBA = GetColorRGBA
UIImage.GetColor = GetColor
UIImage.SetAlpha = SetAlpha
UIImage.SetNativeSize = SetNativeSize
UIImage.SetEnable = SetEnable
UIImage.SetRaycastTarget = SetRaycastTarget
UIImage.SetMaskable = SetMaskable
UIImage.SetAspectSize = SetAspectSize
UIImage.CheckPath = CheckPath
return UIImage
