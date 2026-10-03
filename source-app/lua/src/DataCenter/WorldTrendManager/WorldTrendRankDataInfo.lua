local WorldTrendRankDataInfo = BaseClass("WorldTrendRankDataInfo")

function WorldTrendRankDataInfo:__init()
  self.fullName = ""
  self.abbr = ""
  self.icon = ""
  self.num = 0
end

function WorldTrendRankDataInfo:__delete()
  self.fullName = nil
  self.abbr = nil
  self.icon = nil
  self.num = nil
end

function WorldTrendRankDataInfo:UpdateDataInfo(message)
  if message == nil then
    return
  end
  if message.fullName ~= nil then
    self.fullName = message.fullName
  end
  if message.abbr ~= nil then
    self.abbr = message.abbr
  end
  if message.icon ~= nil then
    self.icon = message.icon
  end
  if message.num then
    self.num = message.num
  end
end

function WorldTrendRankDataInfo:GetAllianceName()
  return "[" .. self.abbr .. "] " .. self.fullName
end

return WorldTrendRankDataInfo
