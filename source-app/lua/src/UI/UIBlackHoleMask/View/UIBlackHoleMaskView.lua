local UIBlackHoleMaskView = BaseClass("UIBlackHoleMaskView", UIBaseView)
local base = UIBaseView
local hole_img_path = "HoleImg"
local mask_img_path = "HoleImg/MaskImg"
local RefreshPositionTime = 0.5

function UIBlackHoleMaskView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.transform:SetAsFirstSibling()
end

function UIBlackHoleMaskView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIBlackHoleMaskView:ComponentDefine()
  self.hole_img = self:AddComponent(UIBaseContainer, hole_img_path)
  self.mask_img = self:AddComponent(UIImage, mask_img_path)
end

function UIBlackHoleMaskView:ComponentDestroy()
end

function UIBlackHoleMaskView:DataDefine()
  self.lossyScaleX = self.transform.lossyScale.x
  if self.lossyScaleX <= 0 then
    self.lossyScaleX = 1
  end
  self.lossyScaleY = self.transform.lossyScale.y
  if 0 >= self.lossyScaleY then
    self.lossyScaleY = 1
  end
  self.maxSize = Vector2.New(Screen.width / self.lossyScaleY, Screen.height / self.lossyScaleY)
  self.screenSize = Vector2.New(Screen.width, Screen.height)
  
  function self.refresh_position_action(temp)
    self:RefreshPositionTimerCallBack()
  end
  
  self.holeSizeX = 0
  self.holeSizeY = 0
  self.param = nil
end

function UIBlackHoleMaskView:DataDestroy()
  self:DeleteRefreshPositionTimer()
  self.refresh_position_action = nil
  self.holeSizeX = 0
  self.holeSizeY = 0
  self.param = nil
end

function UIBlackHoleMaskView:OnEnable()
  base.OnEnable(self)
  self:ReInit()
end

function UIBlackHoleMaskView:OnDisable()
  base.OnDisable(self)
end

function UIBlackHoleMaskView:ReInit()
  self.param = self:GetUserData()
  self.screenPosition = Vector3.New(0, 0, 0)
  self.mask_img.rectTransform.sizeDelta = self.maxSize
  self:Refresh()
end

function UIBlackHoleMaskView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshGuideAnim, self.RefreshGuideAnimSignal)
end

function UIBlackHoleMaskView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshGuideAnim, self.RefreshGuideAnimSignal)
end

function UIBlackHoleMaskView:Refresh()
  self:RefreshPositionTimerCallBack()
end

function UIBlackHoleMaskView:RefreshGuideAnimSignal(param)
  if param ~= nil and param.obj ~= nil then
    self.param = param
    self:Refresh()
  end
end

function UIBlackHoleMaskView:RefreshObjPosition(screenPosition)
  if screenPosition ~= nil then
    local screenX = screenPosition.x
    local screenY = screenPosition.y
    if self.screenPosition.x ~= screenX or self.screenPosition.y ~= screenY then
      self.screenPosition.x = screenX
      self.screenPosition.y = screenY
      self.hole_img.transform.position = self.screenPosition
      self.mask_img.transform.localPosition = -self.hole_img.transform.localPosition
    end
  end
end

function UIBlackHoleMaskView:DeleteRefreshPositionTimer()
  if self.refreshPositionTimer ~= nil then
    self.refreshPositionTimer:Stop()
    self.refreshPositionTimer = nil
  end
end

function UIBlackHoleMaskView:AddRefreshPositionTimer()
  self:DeleteRefreshPositionTimer()
  if self.refreshPositionTimer == nil then
    self.refreshPositionTimer = TimerManager:GetInstance():GetTimer(RefreshPositionTime, self.refresh_position_action, self, true, false, false)
    self.refreshPositionTimer:Start()
  end
end

function UIBlackHoleMaskView:RefreshPositionTimerCallBack()
  self:DeleteRefreshPositionTimer()
  self:ChangeHoleSize()
  self:AddRefreshPositionTimer()
end

function UIBlackHoleMaskView:ChangeHoleSize()
  local sizeX = 0
  local sizeY = 0
  if self.param.obj ~= nil then
    local rectTransform = self.param.obj.gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
    if rectTransform ~= nil then
      local orSize = rectTransform.rect.size
      local lossyScaleX = self.param.obj.transform.lossyScale.x
      local lossyScaleY = self.param.obj.transform.lossyScale.y
      sizeX = orSize.x * lossyScaleX / self.lossyScaleX
      sizeY = orSize.y * lossyScaleY / self.lossyScaleY
      local pivot = rectTransform.pivot
      local screenPosition = Vector3.New(self.param.obj.transform.position.x + (0.5 - pivot.x) * sizeX * lossyScaleX, self.param.obj.transform.position.y + (0.5 - pivot.y) * sizeY * lossyScaleY, 0)
      self:RefreshObjPosition(screenPosition)
    end
  end
  if self.holeSizeX ~= sizeX or self.holeSizeY ~= sizeY then
    self.holeSizeX = sizeX
    self.holeSizeY = sizeY
    self.hole_img.rectTransform:Set_sizeDelta(self.holeSizeX, self.holeSizeY)
  end
end

return UIBlackHoleMaskView
