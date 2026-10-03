local UIButton = BaseClass("UIButton", UIBaseContainer)
local base = UIBaseContainer
local UnityButton = typeof(CS.UnityEngine.UI.Button)
local UnityImage = typeof(CS.UnityEngine.UI.Image)
local ButtonRef = {}

function UIButton.AddRef(btn)
  local ref = (ButtonRef[btn] or 0) + 1
  ButtonRef[btn] = ref
  return ref
end

function UIButton.DecRef(btn)
  local ref = (ButtonRef[btn] or 0) - 1
  if ref <= 0 then
    ref = 0
    ButtonRef[btn] = nil
  else
    ButtonRef[btn] = ref
  end
  return ref
end

function UIButton:OnCreate(relative_path)
  base.OnCreate(self)
  self.unity_uibutton = self.gameObject:GetComponent(UnityButton)
  self.unity_image = self.gameObject:GetComponent(UnityImage)
  self.unsafeBtnName = nil
  self.unsafeIcon = nil
  self.unsafeBackground = nil
  if self.unity_uibutton then
    local ref = UIButton.AddRef(self.unity_uibutton)
  end
  self.__onclick = nil
  self.safeClickMode = false
  self.stopClicking = false
  self.clickDuration = 0.5
  self.ForceUseDefaultSound1 = false
  self.ignoreSound = false
end

function UIButton:Click()
  if self.__onclick ~= nil then
    self.__onclick()
  end
end

local returnBtnNames = {
  "return",
  "close",
  "back",
  "exit",
  "cancel"
}

function UIButton:GetClickSound(btn)
  if self.ignoreSound or not btn then
    return
  end
  if self.clickSound then
    return self.clickSound
  end
  local click1st = SoundAssetId.SFX_UI_General_Click_1st
  local click2nd = SoundAssetId.SFX_UI_General_Click_2nd
  local clickReturn = SoundAssetId.SFX_UI_General_Return
  if self.ForceUseDefaultSound1 then
    return click1st
  end
  for _, btnName in ipairs(returnBtnNames) do
    if btn.name:lower():find(btnName) then
      self.clickSound = clickReturn
      return self.clickSound
    end
  end
  self.clickSound = click2nd
  return self.clickSound
end

function UIButton:SetOnClick(action)
  if IsNull(self.unity_uibutton) then
    return
  end
  if action then
    if self.__onclick then
      self.unity_uibutton.onClick:RemoveListener(self.__onclick)
    end
    
    local function interAction()
      if CommonUtil.IsEditor() and GMUtils.GetBool(GMConst.DebugClickLogWarning, false) and (CS.UnityEngine.Input.GetKey(CS.UnityEngine.KeyCode.LeftControl) or CS.UnityEngine.Input.GetKey(CS.UnityEngine.KeyCode.RightControl)) and DevUtils.EditorTryLogFunction(action) then
        return
      end
      if self.stopClicking then
        UIUtil.ShowTipsId(120289)
        return
      end
      if DataCenter.LWSoundManager:NewCommonSoundTest() and not self.Mute then
        local soundId = self:GetClickSound(self.unity_uibutton)
        if soundId then
          DataCenter.LWSoundManager:PlaySoundByCache(soundId)
        end
      end
      action(self.param)
      if self.safeClickMode then
        self.stopClicking = true
        self.preventTimer = TimerManager:GetInstance():DelayInvoke(function()
          self.stopClicking = false
          self.preventTimer = nil
        end, self.clickDuration)
      end
    end
    
    self.__onclick = interAction
    self.unity_uibutton.onClick:AddListener(self.__onclick)
  elseif self.__onclick then
    self.unity_uibutton.onClick:RemoveListener(self.__onclick)
    self.__onclick = nil
  end
end

local function RemoveBtnAllListeners(btn)
  if btn then
    btn.onClick:RemoveAllListeners()
  end
end

function UIButton:__OnFrameworkDestroy()
end

function UIButton:OnDestroy()
  self:SetOnClick()
  if self.preventTimer then
    self.preventTimer:Stop()
    self.preventTimer = nil
  end
  self.safeClickMode = false
  self.stopClicking = false
  self.clickDuration = 0.5
  self.unity_uibutton = nil
  self.unity_image = nil
  self.spritePath = nil
  self.__onclick = nil
  self.clickSound = nil
  self.ignoreSound = nil
  self.unsafeBtnName = nil
  self.unsafeIcon = nil
  self.unsafeBackground = nil
  base.OnDestroy(self)
end

function UIButton:SetInteractable(value)
  if self.unity_uibutton == nil then
    return
  end
  self.unity_uibutton.interactable = value
end

function UIButton:SetSprite(spr)
  if self.unity_uibutton == nil then
    return
  end
  local btnImage = self.unity_uibutton.transform:GetComponent(typeof(CS.UnityEngine.UI.Image))
  if btnImage ~= nil then
    btnImage.sprite = spr
  end
end

function UIButton:SetMaterial(value)
  if self.unity_uibutton == nil then
    return
  end
  local btnImage = self.unity_uibutton.transform:GetComponent(typeof(CS.UnityEngine.UI.Image))
  if btnImage ~= nil then
    btnImage.material = value
  end
end

function UIButton:SetParam(param)
  self.param = param
end

function UIButton:GetParam()
  return self.param
end

function UIButton:SetSafeClickMode(on)
  self.safeClickMode = on
end

function UIButton:SetSafeClickModeTime(time)
  self.clickDuration = time
end

function UIButton:SetEnable(enable)
  if self.unity_uibutton == nil then
    return
  end
  self.unity_uibutton.enabled = enable
end

function UIButton:SetColorHex(hexValue)
  self:SetColor(UIUtil.HexToColor(hexValue))
end

function UIButton:SetColor(value)
  if self.unity_image == nil then
    return
  end
  self.unity_image:Set_color(value.r or 1, value.g or 1, value.b or 1, value.a or 1)
end

function UIButton:SetColorRGBA(r, g, b, a)
  if self.unity_image == nil then
    return
  end
  self.unity_image:Set_color(r or 1, g or 1, b or 1, a or 1)
end

function UIButton:SetColorRGBA255(r, g, b, a)
  if self.unity_image == nil then
    return
  end
  self.unity_image:Set_color((r or 255) / 255, (g or 255) / 255, (b or 255) / 255, (a or 255) / 255)
end

function UIButton:GetColorRGBA()
  if self.unity_image == nil then
    return 0, 0, 0, 0
  end
  return self.unity_image:Get_color()
end

function UIButton:GetColor()
  local r, g, b, a = self:GetColorRGBA()
  return Color.New(r, g, b, a)
end

function UIButton:SetAlpha(value)
  local color = self:GetColor()
  self:SetColorRGBA(color.r, color.g, color.b, value)
end

function UIButton:SetNativeSize()
  if self.unity_image == nil then
    return
  end
  self.unity_image:SetNativeSize()
end

function UIButton:CheckPath(path)
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

function UIButton:LoadSprite(sprite_path, default_sprite)
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

function UIButton:LoadSpriteAsync(sprite_path, default_sprite)
  if not self:CheckPath(sprite_path) then
    return false
  end
  if self.spritePath == sprite_path then
    return false
  end
  if self.unity_image == nil then
    return false
  end
  self.spritePath = sprite_path
  self.unity_image:LoadSpriteAsync(sprite_path, default_sprite)
end

function UIButton:LoadSpriteAuto(sprite_path, default_sprite)
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

function UIButton:SetButtonNameLocal(dialogId, ...)
  if not self.unity_uibutton or not dialogId then
    return
  end
  if self.unsafeBtnName == nil then
    local _ = self.unity_uibutton.btnLabel
    if IsNotNull(_) then
      self.unsafeBtnName = self:AddComponent(UIText, _)
    else
      self.unsafeBtnName = false
    end
  end
  if self.unsafeBtnName then
    self.unsafeBtnName:SetLocalText(dialogId, ...)
  end
end

function UIButton:SetButtonName(text)
  if not self.unity_uibutton or not text then
    return
  end
  if self.unsafeBtnName == nil then
    local _ = self.unity_uibutton.btnLabel
    if IsNotNull(_) then
      self.unsafeBtnName = self:AddComponent(UIText, _)
    else
      self.unsafeBtnName = false
    end
  end
  if self.unsafeBtnName then
    self.unsafeBtnName:SetText(text)
  end
end

function UIButton:SetButtonNameVisible(visible)
  if not self.unity_uibutton then
    return
  end
  if self.unsafeBtnName then
    self.unsafeBtnName:SetActive(visible)
    return
  end
  local _ = self.unity_uibutton.btnLabel
  if IsNotNull(_) then
    _.gameObject:SetActive(visible)
  end
end

function UIButton:SetIconPath(iconPath, defaultPath)
  if not self.unity_uibutton or not iconPath then
    return
  end
  if self.unsafeIcon == nil then
    local _ = self.unity_uibutton.imgIcon
    if IsNotNull(_) then
      self.unsafeIcon = self:AddComponent(UIImage, _)
    else
      self.unsafeIcon = false
    end
  end
  if self.unsafeIcon then
    self.unsafeIcon:LoadSprite(iconPath, defaultPath)
  end
end

function UIButton:SetIconVisible(visible)
  if not self.unity_uibutton then
    return
  end
  if self.unsafeIcon then
    self.unsafeIcon:SetActive(visible)
    return
  end
  local _ = self.unity_uibutton.imgIcon
  if IsNotNull(_) then
    _.gameObject:SetActive(visible)
  end
end

function UIButton:SetBackgroundPath(path, defaultPath)
  if not self.unity_uibutton or not path then
    return
  end
  if self.unsafeBackground == nil then
    local _ = self.unity_uibutton.imgBackground
    if IsNotNull(_) then
      self.unsafeBackground = self:AddComponent(UIImage, _)
    else
      self.unsafeBackground = false
    end
  end
  if self.unsafeBackground then
    self.unsafeBackground:LoadSprite(path, defaultPath)
  end
end

function UIButton:SetBackgroundVisible(visible)
  if not self.unity_uibutton then
    return
  end
  if self.unsafeBackground then
    self.unsafeBackground:SetActive(visible)
    return
  end
  local _ = self.unity_uibutton.imgBackground
  if IsNotNull(_) then
    _.gameObject:SetActive(visible)
  end
end

function UIButton:SetAspectSize(size)
  if self.unity_image then
    self.unity_image.preserveAspect = true
    self:SetSizeDeltaXY(size, size)
  end
end

function UIButton:LoadSpriteAsyncWithCallback(sprite_path, callback, default_sprite)
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

return UIButton
