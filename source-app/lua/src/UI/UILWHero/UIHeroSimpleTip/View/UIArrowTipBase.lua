local UIArrowTipBase = BaseClass("UIArrowTipBase", UIBaseView)
local base = UIBaseView
local Pivot_Max = 1.0
local Pivot_Min = 0.0
local Pivot_Mid = 0.5

local function CheckAlign(self)
  local _arrowX = 0
  local _arrowY = 0
  local _rotation = 0
  local ScreenSize = CS.UnityEngine.Screen
  local ScreenWidth = ScreenSize.width
  local ScreenHeight = ScreenSize.height
  local widthScale = ScreenWidth / DefaultScreenWidth
  local heightScale = ScreenHeight / DefaultScreenHeight
  local _rect = self.bgRoot.rectTransform.rect
  local BgWidth = _rect.width * widthScale
  local BgHeight = _rect.height * heightScale
  local alignObject = self.param.alignObject
  local position = Vector3.zero
  local _screenPos = Vector3.zero
  local xPosFix = self.param.xPosFix or 0
  local yPosFix = self.param.yPosFix or 0
  if not IsNull(alignObject) and not IsNull(alignObject.transform) then
    position = alignObject.transform.position
    if xPosFix ~= 0 then
      local worldOffset = self.bgRoot.transform:TransformVector(Vector3.New(xPosFix, 0, 0))
      position.x = position.x + worldOffset.x
    end
    if yPosFix ~= 0 then
      local worldOffset = self.bgRoot.transform:TransformVector(Vector3.New(0, yPosFix, 0))
      position.y = position.y + worldOffset.y
    end
    _screenPos = PosConverse.UIWorldToScreenPos(position)
  elseif self.param.screenPos then
    _screenPos = self.param.screenPos
    if xPosFix ~= 0 and xPosFix ~= 0 then
      local worldOffset = self.bgRoot.transform:TransformVector(Vector3.New(xPosFix, 0, 0))
      local screenOffset = PosConverse.UIWorldToScreenPos(worldOffset)
      _screenPos.x = _screenPos.x + screenOffset.x
    end
    if yPosFix ~= 0 and yPosFix ~= 0 then
      local worldOffset = self.bgRoot.transform:TransformVector(Vector3.New(0, yPosFix, 0))
      local screenOffset = PosConverse.UIWorldToScreenPos(worldOffset)
      _screenPos.y = _screenPos.y + screenOffset.y
    end
  end
  local targetScreenPos = _screenPos
  local pivot = Vector2.New(0.5, 0.5)
  if self.param.widthAdapter and (_screenPos.x + BgWidth < ScreenWidth - 10 or _screenPos.x - BgWidth > 10) then
    if _screenPos.x + BgWidth < ScreenWidth - 10 then
      pivot.x = Pivot_Min
      _arrowX = -BgWidth / widthScale * 0.5
    elseif _screenPos.x - BgWidth > 10 then
      pivot.x = Pivot_Max
      _arrowX = BgWidth / widthScale * 0.5
    end
  else
    local offsetX = 0
    if 10 > _screenPos.x - BgWidth / 2 then
      offsetX = BgWidth / 2 - _screenPos.x + (self.param.xPadding or 0)
    elseif _screenPos.x + BgWidth / 2 > ScreenWidth - 10 then
      offsetX = ScreenWidth - _screenPos.x - BgWidth / 2 - (self.param.xPadding or 0)
    end
    targetScreenPos.x = targetScreenPos.x + offsetX
    pivot.x = Pivot_Mid
    _arrowX = -offsetX / widthScale
  end
  if _screenPos.y + BgHeight < ScreenHeight - 10 or _screenPos.y - BgHeight > 10 then
    if self.param.preferTop then
      if _screenPos.y - BgHeight > 10 then
        pivot.y = Pivot_Max
        _arrowY = BgHeight / heightScale * 0.5
      elseif _screenPos.y + BgHeight < ScreenHeight - 10 then
        pivot.y = Pivot_Min
        _arrowY = -BgHeight / heightScale * 0.5
      end
    elseif _screenPos.y + BgHeight < ScreenHeight - 10 then
      pivot.y = Pivot_Min
      _arrowY = -BgHeight / heightScale * 0.5
    elseif _screenPos.y - BgHeight > 10 then
      pivot.y = Pivot_Max
      _arrowY = BgHeight / heightScale * 0.5
    end
  else
    pivot.y = Pivot_Mid
  end
  local arrowDelta = self.param.arrowDelta or 0
  if pivot.x == Pivot_Max and pivot.y == Pivot_Min then
    _rotation = 270
    _arrowX = _arrowX + 8 + arrowDelta
    _arrowY = _arrowY + 20
  elseif pivot.x == Pivot_Max and pivot.y == Pivot_Max then
    _rotation = 270
    _arrowX = _arrowX + 8
    _arrowY = _arrowY - 16 + arrowDelta
  elseif pivot.x == Pivot_Max and pivot.y == Pivot_Mid then
    _rotation = 270
    _arrowX = _arrowX + 8
  elseif pivot.x == Pivot_Min and pivot.y == Pivot_Min then
    _rotation = 90
    _arrowX = _arrowX - 8
    _arrowY = _arrowY + 20 + arrowDelta
  elseif pivot.x == Pivot_Min and pivot.y == Pivot_Max then
    _rotation = 90
    _arrowX = _arrowX - 8
    _arrowY = _arrowY - 16 + arrowDelta
  elseif pivot.x == Pivot_Min and pivot.y == Pivot_Mid then
    _rotation = 90
    _arrowX = _arrowX - 8
  elseif pivot.x == Pivot_Mid and pivot.y == Pivot_Max then
    _rotation = 0
    _arrowY = _arrowY + 8
  elseif pivot.x == Pivot_Mid and pivot.y == Pivot_Min then
    _rotation = 180
    _arrowY = _arrowY - 4
  else
    _rotation = 0
    _arrowX = 9999
    _arrowY = 9999
  end
  if self.param.showArrow == nil or self.param.showArrow == true then
    self.imgArrow.transform.localRotation = Quaternion.Euler(0, 0, _rotation)
    if self.param.addPosX then
      _arrowX = _arrowX - self.param.addPosX
    end
    self.imgArrow.rectTransform.anchoredPosition = Vector2.New(_arrowX, _arrowY)
    self.imgArrow:SetActive(true)
  end
  self.bgRoot.rectTransform.pivot = pivot
  local uiPos = PosConverse.ScreenToUIPos(self.root.transform, targetScreenPos)
  if self.param.addPosY then
    uiPos.y = self.param.addPosY + uiPos.y
  end
  if self.param.addPosX then
    uiPos.x = self.param.addPosX + uiPos.x
  end
  self.bgRoot.transform.anchoredPosition = uiPos
  if self.touchTrough then
    if self.param.unEnableTouchThrough then
      self.touchTrough:ToggleThrough(false)
      self.touchTrough:SetPassPointer(false)
    else
      self.touchTrough:ToggleThrough(true)
      self.touchTrough:SetPassPointer(true)
    end
  end
end

local function RefreshShow(self)
  if self.param.showArrow ~= nil then
    self.imgArrow:SetActive(self.param.showArrow)
  else
    self.imgArrow:SetActive(true)
  end
  if self.param.width then
    self.contentContainer:SetSizeDeltaXY(self.param.width, 0)
    self.bgRoot:SetSizeDeltaXY(self.param.width + 20, 0)
  else
    self.contentContainer:SetSizeDeltaXY(350, 0)
    self.bgRoot:SetSizeDeltaXY(370, 0)
  end
  if self.param.bgColor then
    self.bgRoot:SetColor(self.param.bgColor)
  else
    self.bgRoot:SetColor(WhiteColor)
  end
  self.panel:SetActive(not self.param.hidePanel)
end

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self.param = self:GetUserData()
  self:RefreshShow()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.bgRoot.transform)
  CheckAlign(self)
  local rootRt
  if self.bgRoot then
    rootRt = self.bgRoot.rectTransform
  end
  if rootRt then
    DOTween.Kill(rootRt)
    rootRt:Set_localScale(0.9, 0.9, 0.9)
    rootRt:DOScale(Vector3.New(1.1, 1.1, 0), 0.1):OnComplete(function()
      rootRt:DOScale(Vector3.one, 0.1)
    end):SetEase(CS.DG.Tweening.Ease.InOutCubic)
  end
end

local function ReAlign(self)
  if not self or not self.bgRoot then
    return
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.bgRoot.transform)
  local ok, err = pcall(function()
    CheckAlign(self)
  end)
  if not ok then
    Logger.LogWarning("UIArrowTipBase.ReAlign CheckAlign error:" .. tostring(err))
  end
end

local function OnDestroy(self)
  if self.param and self.param.closeCallback then
    self.param.closeCallback()
  end
  if self.root then
    local rootRt = self.root.rectTransform
    DOTween.Kill(rootRt)
  end
  self:ComponentDestroy()
  if self.param then
    DataCenter.ArrowTipParamManager:Recycle(self.param)
  end
  self.param = nil
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.bgRoot = self:AddComponent(UIImage, "Root/ImgBg")
  self.imgArrow = self:AddComponent(UIImage, "Root/ImgBg/Arrow")
  self.panel = self:AddComponent(UIButton, "Panel")
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.panel:SetActive(true)
  self.touchTrough = self.panel.rectTransform:GetComponent(typeof(CS.LFTouchThrough))
  self.root = self:AddComponent(UIImage, "Root")
  self.contentContainer = self:AddComponent(UIBaseContainer, "Root/ImgBg/Content")
end

local function ComponentDestroy(self)
  self.bgRoot = nil
  self.imgArrow = nil
  self.panel = nil
  self.root = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

UIArrowTipBase.OnCreate = OnCreate
UIArrowTipBase.OnDestroy = OnDestroy
UIArrowTipBase.ComponentDefine = ComponentDefine
UIArrowTipBase.ComponentDestroy = ComponentDestroy
UIArrowTipBase.RefreshShow = RefreshShow
UIArrowTipBase.OnAddListener = OnAddListener
UIArrowTipBase.OnRemoveListener = OnRemoveListener
UIArrowTipBase.ReAlign = ReAlign
return UIArrowTipBase
