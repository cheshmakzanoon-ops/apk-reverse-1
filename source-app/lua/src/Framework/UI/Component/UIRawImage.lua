local UIRawImage = BaseClass("UIRawImage", UIBaseComponent)
local base = UIBaseComponent
local UnityRawImage = typeof(CS.UnityEngine.UI.RawImage)
local ResourceManager = CS.GameEntry.Resource
local imageLink = {}

local function LoadDefaultSize(self)
  if self.transform and self.defaultWidth and self.defaultHeight then
    local rect = self.transform.sizeDelta
    rect.x = self.defaultWidth
    rect.y = self.defaultHeight
    self.transform.sizeDelta = rect
  end
end

local function SaveDefaultSize(self)
  if self.transform then
    local rect = self.transform.sizeDelta
    self.defaultWidth = rect.x
    self.defaultHeight = rect.y
  end
end

local function SizeFit(self)
  if not self.autoSizeFitMode then
    return
  end
  if not self.defaultWidth or not self.defaultHeight then
    return
  end
  if self.defaultWidth == 0 or self.defaultHeight == 0 then
    return
  end
  local defaultRatio = self.defaultWidth / self.defaultHeight
  local mainTex = self.unityRawImage.mainTexture
  if not mainTex then
    return
  end
  local texWidth, texHeight = mainTex.width, mainTex.height
  if texHeight <= 0 then
    return
  end
  local texRatio = texWidth / texHeight
  local ratioRatio = texRatio / defaultRatio
  if 1.01 < ratioRatio then
    local rect = self.transform.sizeDelta
    rect.x = self.defaultWidth
    rect.y = self.defaultHeight / ratioRatio
    self.transform.sizeDelta = rect
  elseif ratioRatio < 0.99 then
    local rect = self.transform.sizeDelta
    rect.x = self.defaultWidth * ratioRatio
    rect.y = self.defaultHeight
    self.transform.sizeDelta = rect
  end
end

local function OnCreate(self)
  base.OnCreate(self)
  self.unityRawImage = self.gameObject:GetComponent(UnityRawImage)
  self.autoSizeFitMode = nil
end

local function OnDestroy(self)
  if self.autoSizeFitMode then
    LoadDefaultSize(self)
  end
  self.spritePath = nil
  self.unityRawImage = nil
  base.OnDestroy(self)
end

local function SetTexture(self, texture)
  self.unityRawImage.texture = texture
  self.spritePath = ""
end

local function SetAutoSizeFitMode(self, bool)
  self.autoSizeFitMode = bool
  if bool then
    SaveDefaultSize(self)
  else
    LoadDefaultSize(self)
  end
end

function UIRawImage:SetColorHex(hexValue)
  self:SetColor(UIUtil.HexToColor(hexValue))
end

local function SetColor(self, value)
  self.unityRawImage:Set_color(value.r, value.g, value.b, value.a)
end

local function SetColorRGBA(self, r, g, b, a)
  self.unityRawImage:Set_color(r, g, b, a)
end

local function SetColorRGBA255(self, r, g, b, a)
  if self.unityRawImage == nil then
    return
  end
  if a == nil then
    a = 255
  end
  self.unityRawImage:Set_color(r / 255, g / 255, b / 255, a / 255)
end

local function SetAlpha(self, value)
  local color = self:GetColor()
  self:SetColorRGBA(color.r, color.g, color.b, value)
end

local function GetColorRGBA(self)
  return self.unityRawImage:Get_color()
end

local function GetColor(self)
  local r, g, b, a = self:GetColorRGBA()
  return Color.New(r, g, b, a)
end

local function SetMaterial(self, value)
  if self.unityRawImage == nil then
    return
  end
  self.unityRawImage.material = value
end

local function GetMaterial(self)
  if self.unityRawImage == nil then
    return nil
  end
  return self.unityRawImage.material
end

local function SetEnable(self, enable)
  self.unityRawImage.enabled = enable
end

local function SetUVRectPosition(self, x, y)
  local rect = self.unityRawImage.uvRect
  rect.position = Vector2.New(x, y)
  self.unityRawImage.uvRect = rect
end

local function SetUVRectPositionAndSize(self, x, y, w, h)
  local rect = self.unityRawImage.uvRect
  rect.position = Vector2.New(x, y)
  rect.size = Vector2.New(w, h)
  self.unityRawImage.uvRect = rect
end

local prefix = "Assets/Main/Sprites/"
local white_list_prefix = {
  "Assets/Main/Sprites/LW_HeroBody",
  "Assets/Main/Sprites/UI/UISeason/UISeasonFarmer",
  "Assets/Main/Sprites/UI/UIChampionDuel/Texture"
}

local function LoadSprite(self, sprite_path, default_sprite)
  if sprite_path == nil then
    Logger.LogError("sprite_path is nil")
    return false
  end
  if sprite_path == "" then
    Logger.LogError("sprite_path is empty string")
    return false
  end
  if self.spritePath == sprite_path then
    return
  end
  if IsNull(self.unityRawImage) then
    return
  end
  self.spritePath = sprite_path
  self.unityRawImage:LoadSprite(imageLink[sprite_path] or sprite_path, default_sprite)
  self:SizeFit()
  if CommonUtil.IsDebug() and string.sub(sprite_path, 1, #prefix) == prefix then
    local inWhite = false
    for _, v in ipairs(white_list_prefix) do
      if string.sub(sprite_path, 1, #v) == v then
        inWhite = true
        break
      end
    end
    if not inWhite then
      Logger.LogError("\229\176\157\232\175\149\231\148\168RawImage\230\152\190\231\164\186\229\155\190\233\155\134\228\184\173\231\154\132\229\155\190\231\137\135\229\156\168\231\156\159\230\156\186\228\184\138\228\188\154\230\156\137\233\151\174\233\162\152 " .. sprite_path)
    end
  end
end

function UIRawImage:LoadSpriteAsync(sprite_path, default_sprite)
  if string.IsNullOrEmpty(sprite_path) then
    Logger.LogError("sprite_path is nil")
    return
  end
  if self.spritePath == sprite_path then
    return
  end
  if IsNull(self.unityRawImage) then
    return
  end
  self.spritePath = sprite_path
  self.unityRawImage:LoadSpriteAsync(sprite_path, default_sprite)
end

function UIRawImage:LoadSpriteAsyncWithCallback(sprite_path, callback, default_sprite)
  if string.IsNullOrEmpty(sprite_path) then
    Logger.LogError("sprite_path is nil")
    return
  end
  if self.spritePath == sprite_path then
    return
  end
  if IsNull(self.unityRawImage) then
    return
  end
  self.spritePath = sprite_path
  self.unityRawImage:LoadSpriteAsync(sprite_path, callback, default_sprite)
end

function UIRawImage:LoadSpriteAuto(sprite_path, callback, default_sprite)
  if string.IsNullOrEmpty(sprite_path) then
    Logger.LogError("sprite_path is nil")
    return
  end
  if self.spritePath == sprite_path then
    return
  end
  if IsNull(self.unityRawImage) then
    return
  end
  self.spritePath = sprite_path
  local assetPath = sprite_path
  local nameLength = #sprite_path
  if 4 < nameLength and string.find(sprite_path, ".png", nameLength - 3, true) == nil then
    assetPath = sprite_path .. ".png"
  end
  local isReady = UIUtil.CheckAssetDownloaded(assetPath)
  if isReady then
    self.unityRawImage:LoadSprite(imageLink[sprite_path] or assetPath, default_sprite)
    self:SizeFit()
    if type(callback) == "function" then
      callback()
    end
    if CommonUtil.IsDebug() and string.sub(sprite_path, 1, #prefix) == prefix then
      local inWhite = false
      for _, v in ipairs(white_list_prefix) do
        if string.sub(sprite_path, 1, #v) == v then
          inWhite = true
          break
        end
      end
      if not inWhite then
        Logger.LogError("\229\176\157\232\175\149\231\148\168RawImage\230\152\190\231\164\186\229\155\190\233\155\134\228\184\173\231\154\132\229\155\190\231\137\135\229\156\168\231\156\159\230\156\186\228\184\138\228\188\154\230\156\137\233\151\174\233\162\152 " .. sprite_path)
      end
    end
  else
    self.unityRawImage:LoadSpriteAsync(assetPath, function()
      if IsNull(self.unityRawImage) then
        return
      end
      self:SizeFit()
      if type(callback) == "function" then
        callback()
      end
    end, default_sprite)
  end
  return true
end

local function SetNativeSize(self)
  self.unityRawImage:SetNativeSize()
end

function UIRawImage:SetPreserveAspectSize(width, height)
  local mainTex = self.unityRawImage.mainTexture
  if not mainTex then
    return
  end
  local texWidth, texHeight = mainTex.width, mainTex.height
  if texHeight <= 0 then
    return
  end
  local texRatio = texWidth / texHeight
  if width and 0 < width then
    height = width / texRatio
  elseif height and 0 < height then
    width = height * texRatio
  end
  self.transform.sizeDelta = Vector2.New(width, height)
end

function UIRawImage:SetFlipX(status)
  local x, y, z = self:GetLocalScaleXYZ()
  if status then
    self:SetLocalScaleXYZ(-math.abs(x), y, z)
  else
    self:SetLocalScaleXYZ(math.abs(x), y, z)
  end
end

function UIRawImage:SetFlipY(status)
  local x, y, z = self:GetLocalScaleXYZ()
  if status then
    self:SetLocalScaleXYZ(x, -math.abs(y), z)
  else
    self:SetLocalScaleXYZ(x, math.abs(y), z)
  end
end

function UIRawImage:DOFade(to, duration)
  if self.unityRawImage then
    return self.unityRawImage:DOFade(to, duration)
  end
  return nil
end

function UIRawImage.Link(a, b)
  imageLink[a] = b
end

function UIRawImage:SetRaycastTarget(bool)
  if self.unityRawImage == nil then
    return
  end
  self.unityRawImage.raycastTarget = bool
end

UIRawImage.OnCreate = OnCreate
UIRawImage.OnDestroy = OnDestroy
UIRawImage.SetTexture = SetTexture
UIRawImage.SetColor = SetColor
UIRawImage.GetColor = GetColor
UIRawImage.SetEnable = SetEnable
UIRawImage.SetColorRGBA = SetColorRGBA
UIRawImage.SetColorRGBA255 = SetColorRGBA255
UIRawImage.GetColorRGBA = GetColorRGBA
UIRawImage.SetAlpha = SetAlpha
UIRawImage.SetUVRectPosition = SetUVRectPosition
UIRawImage.SetUVRectPositionAndSize = SetUVRectPositionAndSize
UIRawImage.LoadSprite = LoadSprite
UIRawImage.SetNativeSize = SetNativeSize
UIRawImage.SetAutoSizeFitMode = SetAutoSizeFitMode
UIRawImage.SizeFit = SizeFit
UIRawImage.SetMaterial = SetMaterial
UIRawImage.GetMaterial = GetMaterial
return UIRawImage
