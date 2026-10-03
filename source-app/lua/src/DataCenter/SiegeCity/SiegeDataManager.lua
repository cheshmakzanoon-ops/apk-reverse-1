local SiegeDataManager = BaseClass("SiegeDataManager")
local SiegeUtil = require("DataCenter.SiegeCity.SiegeUtil")
local Localization = CS.GameEntry.Localization

function SiegeDataManager:__init()
  self.eventQueue = {}
  self.allOutReadyTs = 0
end

function SiegeDataManager:__delete()
  self.eventQueue = {}
  self.allOutReadyTs = 0
end

function SiegeDataManager:SetAllOutReadyTS(msg)
  local cd = LuaEntry.DataConfig:TryGetNum("new_city_battle", "k4", 300)
  if msg.autoStartTime then
    self.allOutReadyTs = msg.autoStartTime + cd * 1000
  end
end

function SiegeDataManager:GetAllOutReadyTS()
  return self.allOutReadyTs
end

function SiegeDataManager:AddSiegeEvent(msg)
  table.insert(self.eventQueue, msg)
  self:ShowSiegeEvent()
end

function SiegeDataManager:ShowSiegeEvent()
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UISiegeBanner) then
    return
  end
  if #self.eventQueue > 0 then
    local msg = table.remove(self.eventQueue, 1)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISiegeBanner, {anim = true}, msg)
  end
end

return SiegeDataManager
