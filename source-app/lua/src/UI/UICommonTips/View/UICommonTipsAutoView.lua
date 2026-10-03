local UICommonTipsAutoView = BaseClass("UICommonTipsAutoView", UIBaseView)
local base = UIBaseView
local Direction = {LEFT = 1, RIGHT = 2}
local ParamData = {
  title = "",
  content = "",
  position = Vector2.zero,
  deltaX = 0,
  deltaY = 0,
  contentX = 0,
  closeCallBack = nil
}
local ParamDataClass = DataClass("ParamDataClass", ParamData)

local function OnCreate(self)
  base.OnCreate(self)
  self.param = nil
  self:ComponentDefine()
end

local function OnDestroy(self)
  self.param = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.param = self:GetUserData()
  if string.IsNullOrEmpty(self.param.title) then
    self.textTitle:SetActive(false)
    self.textContent:SetColor(CommonTipTxtColor1)
    self.textContent:SetText(self.param.content)
  else
    self.textTitle:SetActive(true)
    self.textTitle:SetText(self.param.title)
    self.textContent:SetColor(CommonTipTxtColor2)
    self.textContent:SetText(self.param.content)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.textContent.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
  self.contentSizeDelta = self.content.transform.sizeDelta
  local contentDeltaY = 3
  local halfContentWidth = self.contentSizeDelta.x * 0.5
  local arrowMidPosX = 80
  local arrowX = self.param.position.x + self.param.deltaX
  local arrowY = self.param.position.y + self.param.deltaY
  self.imgArrow:SetPositionXYZ(arrowX, arrowY, 0)
  local anchoredPosition = self.imgArrow:GetAnchoredPosition()
  local contentPosX = 0
  local contentPosY = 0
  arrowX = anchoredPosition.x
  arrowY = anchoredPosition.y
  local halfWidth = self.rectTransform.rect.width * 0.5
  if anchoredPosition.x > 0 then
    if halfWidth < anchoredPosition.x + halfContentWidth then
      contentPosX = halfWidth - halfContentWidth
    else
      contentPosX = anchoredPosition.x
    end
  elseif anchoredPosition.x - halfContentWidth < -halfWidth then
    contentPosX = -halfWidth + halfContentWidth
  else
    contentPosX = anchoredPosition.x
  end
  contentPosY = arrowY + contentDeltaY
  contentPosX = contentPosX + self.param.contentX
  self.content:SetAnchoredPositionXY(contentPosX, contentPosY)
  if self.param.exe then
    if self.param.exe.titleAlignment then
      self.textTitle:SetAlignment(self.param.exe.titleAlignment)
    end
    if self.param.exe.contentAlignment then
      self.textContent:SetAlignment(self.param.exe.contentAlignment)
    end
    self.textContent:SetActive(true)
    if string.IsNullOrEmpty(self.param.title) then
      self.textContent:SetText(self.param.content)
    else
      self.textTitle:SetActive(true)
      self.textContent:SetText(self.param.content)
    end
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
    if self.param.exe.reversal then
      contentPosY = arrowY + self.content.transform.rect.height - 6
      self.content:SetAnchoredPositionXY(contentPosX, contentPosY)
      self.imgArrow.transform.localRotation = Vector3.New(0, 0, 180)
    end
  else
    self.textContent:SetActive(true)
    if string.IsNullOrEmpty(self.param.title) then
      self.textContent:SetText(self.param.content)
    else
      self.textTitle:SetActive(true)
      self.textContent:SetText(self.param.content)
    end
  end
end

local function ComponentDefine(self)
  local btnPanel = self:AddComponent(UIButton, "Panel")
  btnPanel:SetOnClick(function()
    if self.param ~= nil and self.param.closeCallBack ~= nil then
      self.param.closeCallBack()
    end
    self.ctrl.CloseSelf(self.ctrl)
  end)
  self.imgArrow = self:AddComponent(UIBaseContainer, "ImgArrow")
  self.content = self:AddComponent(UIBaseContainer, "content")
  self.textContent = self:AddComponent(UIText, "content/TextContent")
  self.textTitle = self:AddComponent(UIText, "content/TitleTextContent")
end

local function ComponentDestroy(self)
  self.imgArrow.transform.localRotation = Vector3.New(0, 0, 0)
  self.content.transform.sizeDelta = self.contentSizeDelta
  self.imgArrow = nil
  self.textContent = nil
  self.textTitle = nil
  self.content = nil
end

UICommonTipsAutoView.ParamDataClass = ParamDataClass
UICommonTipsAutoView.Direction = Direction
UICommonTipsAutoView.OnCreate = OnCreate
UICommonTipsAutoView.OnDestroy = OnDestroy
UICommonTipsAutoView.OnEnable = OnEnable
UICommonTipsAutoView.ComponentDefine = ComponentDefine
UICommonTipsAutoView.ComponentDestroy = ComponentDestroy
return UICommonTipsAutoView
