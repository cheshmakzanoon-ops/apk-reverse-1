local PushServerToStopMessage = BaseClass("PushServerToStopMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.time ~= nil then
    local endTime = t.time
    local now = UITimeManager:GetInstance():GetServerTime()
    local deltaTime = (endTime - now) / 1000
    if 0 < deltaTime then
      if deltaTime + 1 > 60 then
        local timeStr = math.floor(deltaTime / 60)
        if t.reasonMin then
          UIUtil.ShowTips(Localization:GetString(t.reasonMin, timeStr), 4)
        else
          UIUtil.ShowTips(Localization:GetString(120036, timeStr), 4)
        end
      else
        local timeStr = math.floor(deltaTime)
        if t.reasonSec then
          UIUtil.ShowTips(Localization:GetString(t.reasonSec, timeStr), 4)
        else
          UIUtil.ShowTips(Localization:GetString(120037, timeStr), 4)
        end
      end
    end
  end
end

PushServerToStopMessage.OnCreate = OnCreate
PushServerToStopMessage.HandleMessage = HandleMessage
return PushServerToStopMessage
