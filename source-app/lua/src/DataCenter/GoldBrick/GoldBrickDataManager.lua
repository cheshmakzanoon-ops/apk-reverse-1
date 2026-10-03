local GoldBrickDataManager = BaseClass("GoldBrickDataManager")
local CommonUtils = CS.CommonUtils

function GoldBrickDataManager:__init()
  self.goldBrickCount = 0
end

function GoldBrickDataManager:__delete()
  self.goldBrickCount = nil
end

function GoldBrickDataManager:ParseData(msg)
  if not msg then
    return
  end
  if msg then
    self.goldBrickCount = msg.goldBrickCount
  end
  EventManager:GetInstance():Broadcast(EventId.GoldBrickUpdate)
end

function GoldBrickDataManager:GetGoldBrickCount()
  return self.goldBrickCount or 0
end

return GoldBrickDataManager
