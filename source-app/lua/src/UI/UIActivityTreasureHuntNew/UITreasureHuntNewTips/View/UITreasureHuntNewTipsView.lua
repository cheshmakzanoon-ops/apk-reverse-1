local UITreasureHuntNewTipsView = BaseClass("UITreasureHuntNewTipsView", UIBaseView)
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
  local contentDeltaX = 0
  local contentDeltaY = -6
  local arrowMidPosX = 80
  local arrowX = self.param.position.x + self.param.deltaX
  local arrowY = self.param.position.y + self.param.deltaY
  self.imgArrow:SetPositionXYZ(arrowX, arrowY, 0)
  local anchoredPosition = self.imgArrow:GetAnchoredPosition()
  local contentPosX = 0
  local contentPosY = 0
  arrowX = anchoredPosition.x
  arrowY = anchoredPosition.y
  if 0 < anchoredPosition.x then
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
  contentPosX = contentPosX + self.param.contentX
  self.content:SetAnchoredPositionXY(contentPosX, contentPosY)
  self.textContent:SetText(self.param.content)
  self.textContent:SetColor(CommonTipTxtColor2)
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
end

local function ComponentDestroy(self)
  self.imgArrow = nil
  self.content = nil
  self.textContent = nil
end

UITreasureHuntNewTipsView.ParamDataClass = ParamDataClass
UITreasureHuntNewTipsView.Direction = Direction
UITreasureHuntNewTipsView.OnCreate = OnCreate
UITreasureHuntNewTipsView.OnDestroy = OnDestroy
UITreasureHuntNewTipsView.OnEnable = OnEnable
UITreasureHuntNewTipsView.OnDisable = OnDisable
UITreasureHuntNewTipsView.ComponentDefine = ComponentDefine
UITreasureHuntNewTipsView.ComponentDestroy = ComponentDestroy
return UITreasureHuntNewTipsView
