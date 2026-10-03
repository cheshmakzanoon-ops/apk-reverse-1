local UISmallTipsView = BaseClass("UISmallTipsView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Screen = CS.UnityEngine.Screen
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
  self.param = self:GetUserData()
  self.param.content = self.param.langKey
  if UIManager:GetInstance():IsWindowOpen(self.param.windowName) then
    local window = UIManager:GetInstance():GetWindow(self.param.windowName).View
    local transform = window:GetWidgetTransform(self.param.widgetName)
    self.param.position = transform.position
    self.param.deltaY = transform.sizeDelta.y * 0.5
  end
  local contentDeltaX = 166
  local contentDeltaY = 3
  local arrowMidPosX = 80
  local arrowX = self.param.position.x
  local arrowY = self.param.position.y - self.param.deltaY
  self.imgArrow:SetPositionXYZ(arrowX, arrowY, 0)
  local anchoredPosition = self.imgArrow:GetAnchoredPosition()
  local contentPosX = 0
  local contentPosY = 0
  arrowX = anchoredPosition.x
  arrowY = anchoredPosition.y
  if anchoredPosition.x > 0 then
    if arrowMidPosX < anchoredPosition.x then
      contentPosX = arrowX - contentDeltaX
    else
      contentPosX = arrowX - contentDeltaX - (arrowMidPosX - anchoredPosition.x)
    end
  elseif anchoredPosition.x < -arrowMidPosX then
    contentPosX = arrowX + contentDeltaX
  else
    contentPosX = arrowX + contentDeltaX - (arrowMidPosX - anchoredPosition.x)
  end
  contentPosY = arrowY + contentDeltaY
  contentPosX = contentPosX - 20
  self.content:SetAnchoredPositionXY(contentPosX, contentPosY)
  if string.IsNullOrEmpty(self.param.title) then
    self.textTitle:SetActive(false)
    self.textContent:SetLocalText(self.param.content)
    self.textContent:SetColor(CommonTipTxtColor1)
  else
    self.textTitle:SetActive(true)
    self.textTitle:SetText(self.param.title)
    self.textContent:SetLocalText(self.param.content)
    self.textContent:SetColor(CommonTipTxtColor2)
  end
end

local function OnDisable(self)
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
  self.imgArrow = nil
  self.content = nil
  self.textContent = nil
  self.textTitle = nil
end

UISmallTipsView.ParamDataClass = ParamDataClass
UISmallTipsView.Direction = Direction
UISmallTipsView.OnCreate = OnCreate
UISmallTipsView.OnDestroy = OnDestroy
UISmallTipsView.OnEnable = OnEnable
UISmallTipsView.OnDisable = OnDisable
UISmallTipsView.ComponentDefine = ComponentDefine
UISmallTipsView.ComponentDestroy = ComponentDestroy
return UISmallTipsView
