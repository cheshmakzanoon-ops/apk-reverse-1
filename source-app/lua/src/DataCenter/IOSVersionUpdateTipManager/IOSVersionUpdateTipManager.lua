local IOSVersionUpdateTipManager = BaseClass("IOSVersionUpdateTipManager", CEventable)
local IOSVersionUpdateTipLastShowTime = "IOSVersionUpdateTipLastShowTime"
local IOSVersionUpdateTipShowTimes = "IOSVersionUpdateTipShowTimes"

function IOSVersionUpdateTipManager:__init()
  self:RegisterEvent(EventId.GF_enter_city, self.OnLoadComplete)
end

function IOSVersionUpdateTipManager:InitData()
  self.valid = true
end

function IOSVersionUpdateTipManager:__delete()
  self.valid = false
end

function IOSVersionUpdateTipManager:OnLoadComplete()
  if not self.valid then
    return
  end
  self.valid = false
  local check = CS.CSUtils.CheckiOSSystemVersion(14)
  if not check then
    return
  end
  if LuaEntry.Player.iOSVersionUpdateTipLimit and LuaEntry.Player.iOSVersionUpdateTipLimit > 0 then
    self:TryPopTip()
  end
end

function IOSVersionUpdateTipManager:TryPopTip()
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local lastTime = Setting:GetPrivateString(IOSVersionUpdateTipLastShowTime, "")
  if string.IsNullOrEmpty(lastTime) then
    Setting:SetPrivateInt(IOSVersionUpdateTipShowTimes, 1)
  else
    local sameDay = UITimeManager:GetInstance():IsSameDayForServer(tonumber(lastTime), curTime)
    if not sameDay then
      Setting:SetPrivateInt(IOSVersionUpdateTipShowTimes, 1)
    else
      local curTimes = Setting:GetPrivateInt(IOSVersionUpdateTipShowTimes, 0)
      local max = LuaEntry.Player.iOSVersionUpdateTipLimit
      if curTimes < max then
        Setting:SetPrivateInt(IOSVersionUpdateTipShowTimes, curTimes + 1)
      else
        return
      end
    end
  end
  Setting:SetPrivateString(IOSVersionUpdateTipLastShowTime, tostring(curTime))
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIIOSVersionUpdateTip, {anim = true})
end

return IOSVersionUpdateTipManager
