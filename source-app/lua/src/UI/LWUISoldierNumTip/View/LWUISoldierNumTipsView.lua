local LWUISoldierNumTipsView = BaseClass("LWUISoldierNumTipsView", UIBaseView)
local base = UIBaseView
local panel_btn_path = "Panel"
local img_arrow_path = "ImgArrow"
local content_path = "content"
local des_text_path = "content/DesText"
local soldier_num_slider_path = "content/SliderNewRoot/SoldierNumSlider"
local soldier_num_progress_text_path = "content/SliderNewRoot/SoldierNumSlider/SoldierNumProgressText"
local soldier_icon_image_path = "content/SliderNewRoot/SoldierIcon"

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

local function ComponentDefine(self)
  self.panelBtn = self:AddComponent(UIButton, panel_btn_path)
  self.panelBtn:SetOnClick(function()
    if self.param ~= nil and self.param.closeCallBack ~= nil then
      self.param.closeCallBack()
    end
    self.ctrl.CloseSelf(self.ctrl)
  end)
  self.imgArrow = self:AddComponent(UIBaseContainer, img_arrow_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.desText = self:AddComponent(UIText, des_text_path)
  self.soldierNumSlider = self:AddComponent(UISlider, soldier_num_slider_path)
  self.soldierNumProgressText = self:AddComponent(UIText, soldier_num_progress_text_path)
  self.soldierIcon = self:AddComponent(UIImage, soldier_icon_image_path)
end

local function ComponentDestroy(self)
  self.panelBtn = nil
  self.imgArrow.transform.localRotation = Vector3.New(0, 0, 0)
  self.imgArrow = nil
  self.content.transform.sizeDelta = self.contentWidth
  self.content = nil
  self.desText = nil
  self.soldierNumSlider = nil
  self.soldierNumProgressText = nil
  self.soldierIcon = nil
end

local function OnEnable(self)
  self.param = self:GetUserData()
  local contentDeltaX = 166
  local contentDeltaY = 3
  local arrowMidPosX = 80
  self.contentWidth = self.content.transform.sizeDelta
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
  contentPosX = contentPosX + self.param.contentX
  self.content:SetAnchoredPositionXY(contentPosX, contentPosY)
  if string.IsNullOrEmpty(self.param.content) then
    self.desText:SetActive(false)
  else
    self.desText:SetActive(true)
    self.desText:SetText(self.param.content)
    self.desText:SetColor(CommonTipTxtColor2)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
  if self.param.exe then
    local soldierTotal = self.param.exe.soldierCount
    local soldierUpperLimit = self.param.exe.soldierCapacity
    self.soldierNumProgressText:SetText(soldierTotal .. "/" .. soldierUpperLimit)
    self.soldierNumSlider:SetValue(soldierTotal / soldierUpperLimit)
  end
end

local function OnDisable(self)
end

LWUISoldierNumTipsView.OnCreate = OnCreate
LWUISoldierNumTipsView.OnDestroy = OnDestroy
LWUISoldierNumTipsView.OnEnable = OnEnable
LWUISoldierNumTipsView.OnDisable = OnDisable
LWUISoldierNumTipsView.ComponentDefine = ComponentDefine
LWUISoldierNumTipsView.ComponentDestroy = ComponentDestroy
return LWUISoldierNumTipsView
