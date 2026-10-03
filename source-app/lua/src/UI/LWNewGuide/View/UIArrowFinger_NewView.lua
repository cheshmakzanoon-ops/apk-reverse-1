local UIArrowFinger_NewView = BaseClass("UIArrowFinger_NewView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local delayCloseTime = 0.618
local delayCloseFrame = 10

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitData()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.parentRect = self.gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
  self.finger = self:AddComponent(UIBaseContainer, "finger")
  self.textBg = self:AddComponent(UIImage, "txtBg")
  self.textBgRect = self.textBg.gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
  self.textBgCanvasGroup = self.textBg.gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  self.contentText = self:AddComponent(UIText, "txtBg/contentTxt")
  self.arrowTop = self:AddComponent(UIImage, "arrowTop")
  self.arrowTopRect = self.arrowTop.gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
  self.arrowBottom = self:AddComponent(UIImage, "arrowBottom")
  self.arrowBottomRect = self.arrowBottom.gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
  self.e4r = self:AddComponent(UIEmpty4Raycast, "Bg")
  self.e4r:SetRaycastTarget(true)
  self.delayDisableRaycastTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.delayDisableRaycastTimer = nil
    self.e4r:SetRaycastTarget(false)
  end, delayCloseTime)
end

local function ComponentDestroy(self)
  self.object = nil
  self.finger = nil
  self.textBg = nil
  self.textBgRect = nil
  self.contentText = nil
  self.arrowTop = nil
  self.arrowBottom = nil
  self.textBgCanvasGroup = nil
  self.arrowTopRect = nil
  if self.delayDisableRaycastTimer then
    self.delayDisableRaycastTimer:Stop()
    self.delayDisableRaycastTimer = nil
  end
end

local startTime

local function DataDefine(self)
  self.param = self:GetUserData()
  startTime = Time.realtimeSinceStartup
end

local function DataDestroy(self)
  self.param = nil
  self:DeleteDelayTimer()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  UpdateManager:GetInstance():AddUpdate(self.OnUpdate)
end

local function OnRemoveListener(self)
  UpdateManager:GetInstance():RemoveUpdate(self.OnUpdate)
  base.OnRemoveListener(self)
end

function UIArrowFinger_NewView.OnUpdate()
  if CS.UnityEngine.Input.GetMouseButtonDown(0) then
    if Time.realtimeSinceStartup - startTime < delayCloseTime then
      return
    end
    local timer = TimerManager:GetInstance():GetTimer(delayCloseFrame, function()
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIArrowFinger_New)
    end, self, true, true)
    timer:Start()
  end
end

local function InitData(self)
  if self.param then
    if self.param.hideFinger then
      self.finger:SetActive(false)
      self.finger.transform:Set_anchoredPosition(63, -63)
    else
      self.finger:SetActive(true)
      self.finger.transform.position = self.param.position
      self.finger.transform.localScale = self.param.scale
    end
    if string.IsNullOrEmpty(self.param.textKey) then
      self.textBg:SetActive(false)
      self.arrowTop:SetActive(false)
      self.arrowBottom:SetActive(false)
    else
      self.textBgCanvasGroup.alpha = 0
      self.arrowTop:SetActive(false)
      self.arrowBottom:SetActive(false)
      self.contentText:SetLocalText(self.param.textKey)
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.textBg.transform)
      self:AddDelayTimer()
    end
  end
end

local function DeleteDelayTimer(self)
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

local function AddDelayTimer(self)
  DeleteDelayTimer(self)
  self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.textBgCanvasGroup.alpha = 1
    self.arrowTop:SetActive(true)
    self.arrowBottom:SetActive(true)
    if self.textBgRect == nil or self.parentRect == nil then
      Logger.LogError("UIArrowFinger_NewView RectTransform \231\187\132\228\187\182\231\188\186\229\164\177")
      return
    end
    local bubbleWidth = self.textBgRect.rect.width
    local bubbleHeight = self.textBgRect.rect.height - 5
    local bubbleX = self.param.position.x - 50
    local bubbleY = self.param.position.y + 100
    local isUp = true
    local screenWidth = self.parentRect.rect.width
    local screenHeight = self.parentRect.rect.height
    local spaceAbove = bubbleY
    local spaceBelow = screenHeight - bubbleY
    if self.param.forceDown then
      bubbleY = self.param.position.y - bubbleHeight + 10
      self.arrowTop:SetActive(true)
      self.arrowBottom:SetActive(false)
      isUp = false
    elseif self.param.forceUp then
      self.arrowTop:SetActive(false)
      self.arrowBottom:SetActive(true)
      isUp = true
    elseif spaceAbove > spaceBelow then
      bubbleY = self.param.position.y - bubbleHeight + 10
      self.arrowTop:SetActive(true)
      self.arrowBottom:SetActive(false)
      isUp = false
    else
      self.arrowTop:SetActive(false)
      self.arrowBottom:SetActive(true)
    end
    local uiScale = UIManager:GetInstance():GetScaleFactor()
    local lowerY = 55
    self.textBgRect.transform.position = Vector2(bubbleX, bubbleY - lowerY)
    local x, y = self.textBgRect:Get_anchoredPosition()
    local fullRight = x + bubbleWidth > screenWidth / 2
    local finger_x = self.finger.transform:Get_anchoredPosition()
    local arrowY = isUp and bubbleY or y + bubbleHeight
    local finalX, finalY
    if isUp then
      self.arrowBottom.transform.position = Vector2(self.param.position.x + (self.param.arrowX or 0), arrowY + 5 - lowerY)
      finalX, finalY = self.arrowBottomRect:Get_anchoredPosition()
      finalY = finalY - 5
    else
      self.arrowTopRect:Set_anchoredPosition(finger_x + (self.param.arrowX or 0), arrowY + 28 + lowerY, 0)
      finalX, finalY = self.arrowTopRect:Get_anchoredPosition()
      finalY = finalY - (bubbleHeight + 11)
    end
    if fullRight then
      if CommonUtil.IsArabicAutoMirrorOpen() then
        finalX = finalX + 40
      else
        finalX = finalX - bubbleWidth + 40
      end
    elseif CommonUtil.IsArabicAutoMirrorOpen() then
      finalX = finalX + bubbleWidth - 50
    else
      finalX = finalX - 50
    end
    self.textBgRect:Set_anchoredPosition(finalX, finalY, 0)
  end, 0.2)
  self.delayTimer:Start()
end

local function OnCloseWindow(self)
  if self.e4r:GetRaycastTarget() then
    return
  end
  local timer = TimerManager:GetInstance():GetTimer(delayCloseFrame, function()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIArrowFinger_New)
  end, self, true, true)
  timer:Start()
end

UIArrowFinger_NewView.OnCreate = OnCreate
UIArrowFinger_NewView.OnDestroy = OnDestroy
UIArrowFinger_NewView.OnEnable = OnEnable
UIArrowFinger_NewView.OnDisable = OnDisable
UIArrowFinger_NewView.ComponentDefine = ComponentDefine
UIArrowFinger_NewView.ComponentDestroy = ComponentDestroy
UIArrowFinger_NewView.DataDefine = DataDefine
UIArrowFinger_NewView.DataDestroy = DataDestroy
UIArrowFinger_NewView.OnAddListener = OnAddListener
UIArrowFinger_NewView.OnRemoveListener = OnRemoveListener
UIArrowFinger_NewView.InitData = InitData
UIArrowFinger_NewView.OnCloseWindow = OnCloseWindow
UIArrowFinger_NewView.AddDelayTimer = AddDelayTimer
UIArrowFinger_NewView.DeleteDelayTimer = DeleteDelayTimer
return UIArrowFinger_NewView
