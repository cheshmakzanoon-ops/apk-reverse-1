local TorchRelayStageItemTemplate = BaseClass("TorchRelayStageItemTemplate")

function TorchRelayStageItemTemplate:__init()
  self.id = 0
  self.resource_id = 0
  self.road_line = ""
  self.length = 0
  self.buff_type = 0
  self.para1 = 0
  self.para2 = 0
  self.num_limit = 0
  self.type = 0
  self:InitCustom()
end

function TorchRelayStageItemTemplate:__delete()
  self.id = nil
  self.resource_id = nil
  self.road_line = nil
  self.length = nil
  self.buff_type = nil
  self.para1 = nil
  self.para2 = nil
  self.num_limit = nil
  self.type = nil
  self:DeleteCustom()
end

function TorchRelayStageItemTemplate:InitCustom()
  self.bornLines = {}
  self.treasureBoxId = 0
  self.treasureBoxNum = 0
end

function TorchRelayStageItemTemplate:DeleteCustom()
  self.bornLines = nil
  self.treasureBoxId = nil
  self.treasureBoxNum = nil
end

function TorchRelayStageItemTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.resource_id = tonumber(row:getValue("resource_id")) or 0
  self.road_line = row:getValue("road_line")
  self.length = tonumber(row:getValue("length")) or 0
  self.buff_type = tonumber(row:getValue("buff_type")) or 0
  self.para1 = tonumber(row:getValue("para1")) or 0
  self.para2 = tonumber(row:getValue("para2")) or 0
  self.num_limit = tonumber(row:getValue("num_limit")) or 0
  self.type = tonumber(row:getValue("type")) or 0
  if self.road_line then
    local roadStr = string.split(self.road_line, ";")
    for i, v in ipairs(roadStr) do
      table.insert(self.bornLines, tonumber(v))
    end
  end
end

function TorchRelayStageItemTemplate:GetRandomLine()
  if #self.bornLines == 1 then
    return self.bornLines[1]
  end
  local index = math.random(1, #self.bornLines)
  return self.bornLines[index]
end

return TorchRelayStageItemTemplate
