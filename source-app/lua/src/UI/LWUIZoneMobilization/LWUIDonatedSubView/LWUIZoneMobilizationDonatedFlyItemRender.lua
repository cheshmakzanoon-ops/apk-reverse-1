local base = UIBaseContainer
local LWUIZoneMobilizationDonatedFlyItemRender = BaseClass("LWUIZoneMobilizationDonatedFlyItemRender", base)

local function OnCreate(self)
  base.OnCreate(self)
end

local function OnDestroy(self)
  base.OnDestroy(self)
end

local function TryFlyPointsIcon(self, posFrom, posTo, icon, addNum, callback)
  local flyNum = addNum <= 5 and addNum or 8
  UIUtil.DoFly(nil, flyNum, icon, posFrom, posTo, nil, nil, callback)
end

LWUIZoneMobilizationDonatedFlyItemRender.OnCreate = OnCreate
LWUIZoneMobilizationDonatedFlyItemRender.OnDestroy = OnDestroy
LWUIZoneMobilizationDonatedFlyItemRender.TryFlyPointsIcon = TryFlyPointsIcon
return LWUIZoneMobilizationDonatedFlyItemRender
