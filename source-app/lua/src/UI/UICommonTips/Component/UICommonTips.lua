local UICommonTips = BaseClass("UICommonTips", UIBaseContainer)
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

local function SetData(self, param)
  self.param = param
end

local function OnEnable(self)
  if self.param == nil then
    return
  end
  local contentDeltaX = 166
  local contentDeltaY = 3
  local arrowMidPosX = 80
  local arrowX = self.param.position.x + self.param.deltaX
  local arrowY = self.param.position.y + self.param.deltaY
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
  self.content:SetAnchoredPositionXY(contentPosX, contentPosY)
  if string.IsNullOrEmpty(self.param.title) then
    self.textTitle:SetActive(false)
    self.textContent:SetText(self.param.content)
    self.textContent:SetColor(CommonTipTxtColor1)
  else
    self.textTitle:SetActive(true)
    self.textTitle:SetText(self.param.title)
    self.textContent:SetText(self.param.content)
    self.textContent:SetColor(CommonTipTxtColor2)
  end
end

local function OnDisable(self)
end

local function ComponentDefine(self)
  local btnPanel = self:AddComponent(UIButton, "Panel")
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

UICommonTips.ParamDataClass = ParamDataClass
UICommonTips.Direction = Direction
UICommonTips.OnCreate = OnCreate
UICommonTips.OnDestroy = OnDestroy
UICommonTips.OnEnable = OnEnable
UICommonTips.OnDisable = OnDisable
UICommonTips.ComponentDefine = ComponentDefine
UICommonTips.ComponentDestroy = ComponentDestroy
UICommonTips.SetData = SetData
return UICommonTips
