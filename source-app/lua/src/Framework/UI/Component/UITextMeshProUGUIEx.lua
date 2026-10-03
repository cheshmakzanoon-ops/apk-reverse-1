local UITextMeshProUGUIEx = BaseClass("UITextMeshProUGUIEx", UIBaseComponent)
local base = UIBaseComponent
local UnityTextMeshProEx = typeof(CS.TextMeshProUGUIEx)
local UnityCamera = typeof(CS.UnityEngine.Camera)
local Localization = CS.GameEntry.Localization
local ArabicMatReplaceMap = {
  ["Title-Outline_Black"] = "Assets/Main/TMPFont/Main/Title-Outline.mat"
}

function UITextMeshProUGUIEx:OnCreate()
  base.OnCreate(self)
  self.unity_tmpro = self.gameObject:GetComponent(UnityTextMeshProEx)
  self:SetFillingUint(0)
end

function UITextMeshProUGUIEx:GetText()
  return self.unity_tmpro.text
end

function UITextMeshProUGUIEx:GetOriginalText()
  return self.unity_tmpro:GetOriginalText()
end

function UITextMeshProUGUIEx:SetText(text)
  if IsNull(self.unity_tmpro) then
    return
  end
  self.unity_tmpro:Native_SetText(text)
end

function UITextMeshProUGUIEx:SetTextFormat(fmt, ...)
  local txt = string.format(fmt, ...)
  self:SetText(txt)
end

function UITextMeshProUGUIEx:SetText_NotNative(text)
  if IsNull(self.unity_tmpro) then
    return
  end
  self.unity_tmpro:SetText_NotNative(text)
end

function UITextMeshProUGUIEx:SetLocalText(dialogId, ...)
  if IsNull(self.unity_tmpro) then
    return
  end
  if dialogId == nil or dialogId == "" then
    self.unity_tmpro:Native_SetText("")
  else
    self.unity_tmpro:Native_SetText(Localization:GetString(dialogId, ...))
  end
end

function UITextMeshProUGUIEx:SetLocalText(dialogId, ...)
  if IsNull(self.unity_tmpro) then
    return
  end
  if dialogId == nil or dialogId == "" then
    self.unity_tmpro.text = ""
  else
    self.unity_tmpro:SetLocalText(dialogId, ...)
  end
end

function UITextMeshProUGUIEx:OnDestroy()
  if not IsNull(self.unity_tmpro) then
    self.unity_tmpro.onPointerClick = nil
    self.unity_tmpro.onCharacterPointerClick = nil
    self.unity_tmpro = nil
  end
  base.OnDestroy(self)
end

function UITextMeshProUGUIEx:SetColorRGBA(r, g, b, a)
  if not IsNull(self.unity_tmpro) then
    local color = Color.New(r, g, b, a)
    self.unity_tmpro.color = color
  end
end

function UITextMeshProUGUIEx:SetColorRGBA255(r, g, b, a)
  if not IsNull(self.unity_tmpro) then
    local color = Color.New(r / 255, g / 255, b / 255, (a or 255) / 255)
    self.unity_tmpro.color = color
  end
end

function UITextMeshProUGUIEx:SetColor(value)
  if not IsNull(self.unity_tmpro) then
    self.unity_tmpro.color = value
  end
end

function UITextMeshProUGUIEx:SetColorHex(hexValue)
  self:SetColor(UIUtil.HexToColor(hexValue))
end

function UITextMeshProUGUIEx:SetAlpha(alpha)
  if not IsNull(self.unity_tmpro) then
    local value = self.unity_tmpro.color
    value.a = alpha
    self.unity_tmpro.color = value
  end
end

function UITextMeshProUGUIEx:GetColor()
  return self.unity_tmpro.color
end

function UITextMeshProUGUIEx:GetWidth()
  return self.unity_tmpro.preferredWidth
end

function UITextMeshProUGUIEx:GetHeight()
  return self.unity_tmpro.preferredHeight
end

function UITextMeshProUGUIEx:SetPreferSize(value)
  self.rectTransform:Set_sizeDelta(value.x, value.y)
end

function UITextMeshProUGUIEx:GetLinkInfo()
  return self.unity_tmpro.textInfo.linkInfo
end

function UITextMeshProUGUIEx:SetAlignment(_alignment)
  self.unity_tmpro.alignment = _alignment
end

function UITextMeshProUGUIEx:OnPointerClick(onPointerClick)
  self.unity_tmpro.onPointerClick = onPointerClick
end

function UITextMeshProUGUIEx:OnCharactorPointerClick(onCharacterPointerClick)
  self.unity_tmpro.onCharacterPointerClick = onCharacterPointerClick
end

local function CheckPointerClickWithCamera(theUnityTextMesh, thePosition, theCamera)
  local linkIndex = CS.TMPro.TMP_TextUtilities.FindIntersectingLink(theUnityTextMesh, thePosition, theCamera)
  if linkIndex == -1 then
    return nil
  end
  local linkInfo = theUnityTextMesh.textInfo.linkInfo
  if linkInfo == nil then
    return nil
  end
  local linkItem = linkInfo[linkIndex]
  if linkItem ~= nil then
    return linkItem:GetLinkID()
  end
  return nil
end

function UITextMeshProUGUIEx:TryGetPointerClickLinkID(position)
  local thePosition = Vector3.New(position.x, position.y, 0)
  local gameObject = CS.UnityEngine.GameObject.Find("GameFramework/UI/UICamera")
  if gameObject ~= nil then
    local camera = gameObject:GetComponent(UnityCamera)
    local linkId = CheckPointerClickWithCamera(self.unity_tmpro, thePosition, camera)
    if linkId ~= nil then
      return linkId
    end
  end
  return CheckPointerClickWithCamera(self.unity_tmpro, thePosition, nil)
end

local function CheckPointerClickWithCameraGetLinkItem(theUnityTextMesh, thePosition, theCamera)
  local linkIndex = CS.TMPro.TMP_TextUtilities.FindIntersectingLink(theUnityTextMesh, thePosition, theCamera)
  if linkIndex == -1 then
    return nil
  end
  local linkInfo = theUnityTextMesh.textInfo.linkInfo
  if linkInfo == nil then
    return nil
  end
  local linkItem = linkInfo[linkIndex]
  if linkItem ~= nil then
    return linkItem
  end
  return nil
end

function UITextMeshProUGUIEx:TryGetPointerClickLinkItme(position)
  local thePosition = Vector3.New(position.x, position.y, 0)
  local gameObject = CS.UnityEngine.GameObject.Find("GameFramework/UI/UICamera")
  if gameObject ~= nil then
    local camera = gameObject:GetComponent(UnityCamera)
    local linkItem = CheckPointerClickWithCameraGetLinkItem(self.unity_tmpro, thePosition, camera)
    if linkItem ~= nil then
      return linkItem
    end
  end
  return CheckPointerClickWithCameraGetLinkItem(self.unity_tmpro, thePosition, nil)
end

function UITextMeshProUGUIEx:ChangeNewMaterial(path)
  if not IsNull(self.unity_tmpro) then
    if string.IsNullOrEmpty(path) then
      self.unity_tmpro:SetNewMaterial(nil)
      return
    end
    UIManager:GetInstance():SetNewTMProFontMaterial(path, function(newMat)
      if not IsNull(self.unity_tmpro) then
        self.unity_tmpro:SetNewMaterial(newMat)
      end
    end)
  end
end

function UITextMeshProUGUIEx:SetSupportSpriteEmoji(isOn)
  if not IsNull(self.unity_tmpro) then
    self.unity_tmpro.supportSpriteEmoji = isOn
  end
end

function UITextMeshProUGUIEx:SetSupportSpriteTagOnly(isOn)
  if not IsNull(self.unity_tmpro) then
    self.unity_tmpro.supportSpriteTagOnly = isOn
  end
end

function UITextMeshProUGUIEx:SetRichText(isOn)
  if not IsNull(self.unity_tmpro) then
    self.unity_tmpro.richText = isOn
  end
end

function UITextMeshProUGUIEx:SetFillingUint(uncode)
  if not IsNull(self.unity_tmpro) then
    self.unity_tmpro:SetFontFillingUint(uncode)
  end
end

function UITextMeshProUGUIEx:SetEmojiAnalysis(isOn, richTextFixed)
  if not richTextFixed then
    self:SetRichText(not isOn)
  end
  self:SetSupportSpriteTagOnly(isOn)
  self:SetSupportSpriteEmoji(isOn)
  self:SetFillingUint(isOn and 8203 or 0)
end

function UITextMeshProUGUIEx:GetPreferredValues(width, height)
  if not IsNull(self.unity_tmpro) then
    return self.unity_tmpro:GetPreferredValues(width, height)
  end
end

function UITextMeshProUGUIEx:GetPreferredValuesStr(str)
  if not IsNull(self.unity_tmpro) then
    return self.unity_tmpro:GetPreferredValues(str)
  end
end

function UITextMeshProUGUIEx:SetSizeWithCurrentAnchors(axis, width)
  if not IsNull(self.unity_tmpro) then
    self.unity_tmpro.rectTransform:SetSizeWithCurrentAnchors(axis, width)
  end
end

function UITextMeshProUGUIEx:SetSpriteAsset(spriteAsset)
  if not IsNull(self.unity_tmpro) and not IsNull(spriteAsset) then
    self.unity_tmpro.spriteAsset = spriteAsset
  end
end

function UITextMeshProUGUIEx:GetColor(value)
  if not IsNull(self.unity_tmpro) then
    return self.unity_tmpro.color
  end
end

function UITextMeshProUGUIEx:SetFontSize(fontSize)
  if not IsNull(self.unity_tmpro) then
    self.unity_tmpro.fontSize = fontSize
  end
end

function UITextMeshProUGUIEx:DOText(value, duration)
  if not IsNull(self.unity_tmpro) then
    local tempText = ""
    local tween = DOTween.To(function()
      return tempText
    end, function(str)
      tempText = str
    end, value, duration):OnUpdate(function()
      self:SetText(tempText)
    end)
    tween:SetLink(self.unity_tmpro.gameObject)
    return tween
  end
end

function UITextMeshProUGUIEx:DOFade(value, duration)
  if self.unity_tmpro then
    return self.unity_tmpro:DOFade(value, duration)
  end
end

function UITextMeshProUGUIEx:ForceUpdate()
  self:ForceMeshUpdate()
end

function UITextMeshProUGUIEx:SetBestFitEnable(enable)
  if self.unity_tmpro then
    self.unity_tmpro.enableAutoSizing = enable
  end
end

function UITextMeshProUGUIEx:SetFontSizeMax(fontSizeMax)
  if self.unity_tmpro then
    self.unity_tmpro.fontSizeMax = fontSizeMax
  end
end

function UITextMeshProUGUIEx:SetFontSizeMin(fontSizeMin)
  if self.unity_tmpro then
    self.unity_tmpro.fontSizeMin = fontSizeMin
  end
end

function UITextMeshProUGUIEx:ForceMeshUpdate()
  if self.unity_tmpro then
    self.unity_tmpro:ForceMeshUpdate()
  end
end

function UITextMeshProUGUIEx:GetCharacterCount()
  if self.unity_tmpro then
    return self.unity_tmpro.textInfo.characterCount
  end
end

function UITextMeshProUGUIEx:SetMargin(left, top, right, bottom)
  if self.unity_tmpro then
    self.unity_tmpro.margin = Vector4.New(left, top, right, bottom)
  end
end

function UITextMeshProUGUIEx:SetMaxVisibleCharacters(value)
  if self.unity_tmpro then
    self.unity_tmpro.maxVisibleCharacters = value
  end
end

function UITextMeshProUGUIEx:SetRaycastTarget(bool)
  if self.unity_tmpro ~= nil then
    self.unity_tmpro.raycastTarget = bool
  end
end

return UITextMeshProUGUIEx
