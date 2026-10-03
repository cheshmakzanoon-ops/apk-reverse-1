local PveDropRewardInfo = BaseClass("PveDropRewardInfo")

function PveDropRewardInfo:__init()
  self.uuid = 0
  self.x = 0
  self.y = 0
  self.resArr = {}
end

function PveDropRewardInfo:__delete()
  self.uuid = 0
  self.x = 0
  self.y = 0
  self.resArr = {}
end

function PveDropRewardInfo:UpdateData(message)
  if message == nil then
    return
  end
  if message.uuid ~= nil then
    self.uuid = message.uuid
  end
  if message.x ~= nil then
    self.x = message.x
  end
  if message.y ~= nil then
    self.y = message.y
  end
  local res = message.resArr
  if res ~= nil then
    self.resArr = {}
    for k, v in pairs(res) do
      local param = {}
      param.id = v.id
      param.num = v.num
      table.insert(self.resArr, param)
    end
  end
end

function PveDropRewardInfo:GetPosition()
  return SceneUtils.TileToWorld({
    x = self.x,
    y = self.y
  })
end

return PveDropRewardInfo
