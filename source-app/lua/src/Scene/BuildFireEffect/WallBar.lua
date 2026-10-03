local base = UIAsyncNode
local WallBar = BaseClass("WallBar", base)
local SliderLength = Vector2.New(4.9, 1)

function WallBar:OnCreate()
  base.OnCreate(self)
  local transform = self.transform
  if IsNull(transform) then
    return
  end
  self.hpText = transform:Find("TimeText"):GetComponent(typeof(CS.SuperTextMesh))
  self.slider = transform:Find("Slider"):GetComponent(typeof(CS.SceneHealthBarController))
  transform:Set_localPosition(0, 1, 0)
  
  function self.FuncPushWorldWallBarRefresh(pointId)
    if self and self.transform then
      self:OnPushWorldWallBarRefresh(pointId)
    end
  end
  
  EventManager:GetInstance():AddListener(EventId.PushWorldWallBarRefresh, self.FuncPushWorldWallBarRefresh)
end

function WallBar:OnDestroy()
  EventManager:GetInstance():RemoveListener(EventId.PushWorldWallBarRefresh, self.FuncPushWorldWallBarRefresh)
  self.FuncPushWorldWallBarRefresh = nil
  self.wallBarInfo = nil
  self.hpText = nil
  self.slider = nil
  self.pointId = nil
  base.OnDestroy(self)
end

function WallBar:OnPushWorldWallBarRefresh(pointId)
  if self.pointId ~= pointId then
    return
  end
  local theWorld = CS.SceneManager.World
  if theWorld == nil then
    return
  end
  local info = theWorld:GetPointInfo(pointId)
  if info and info.wallBarInfo then
    self:SetData(info.wallBarInfo, pointId)
  end
end

function WallBar:SetData(wallBarInfo, pointId)
  self.wallBarInfo = wallBarInfo
  self.pointId = pointId
  if self:AsyncLoadDone() then
    self:UpdateData()
  end
end

function WallBar:UpdateData()
  if self.hpText and self.wallBarInfo then
    local shieldValue = self.wallBarInfo.shieldValue or 0
    local maxValue = self.wallBarInfo.shieldMaxValue or 1
    self.hpText.text = string.GetFormattedSeperatorNum(shieldValue)
    self.slider:SetCurAndMaxHP(shieldValue, maxValue)
  end
end

return WallBar
