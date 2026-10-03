local LwSeasonDiggingGameTemplate = BaseClass("LwSeasonDiggingGameTemplate")

function LwSeasonDiggingGameTemplate:__init()
  self.id = 0
  self.type = 0
  self.group = 0
  self.name = ""
  self.num_width = 0
  self.num_height = 0
  self.reward = ""
  self.consolation_prize = ""
  self.block = ""
  self.digging_id = ""
  self.pic = ""
  self.pic_lock = ""
end

function LwSeasonDiggingGameTemplate:__delete()
  self.id = nil
  self.type = nil
  self.group = nil
  self.name = nil
  self.num_width = nil
  self.num_height = nil
  self.reward = nil
  self.consolation_prize = nil
  self.block = nil
  self.digging_id = nil
  self.pic = nil
  self.pic_lock = nil
end

function LwSeasonDiggingGameTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.type = rowData:getValue("type") or 0
  self.group = rowData:getValue("group") or 0
  self.name = rowData:getValue("name") or ""
  self.num_width = rowData:getValue("num_width") or 0
  self.num_height = rowData:getValue("num_height") or 0
  self.reward = rowData:getValue("reward") or ""
  self.consolation_prize = rowData:getValue("consolation_prize") or ""
  self.block = rowData:getValue("block") or ""
  self.block = string.split(self.block, "|")
  for i, v in ipairs(self.block) do
    self.block[i] = tonumber(v)
  end
  self.digging_id = rowData:getValue("digging_id") or ""
  self.pic = rowData:getValue("pic") or ""
  self.pic_lock = rowData:getValue("pic_lock") or ""
  self.hammer_num = tonumber(rowData:getValue("hammer_num"))
  self.layer = tonumber(rowData:getValue("layer"))
  self.level_limit_time = tonumber(rowData:getValue("level_limit_time"))
  local blockPos = rowData:getValue("block_position")
  if not string.IsNullOrEmpty(blockPos) then
    self.block_position = self:ConvertPosAndScaleStr(blockPos)
  end
  local strPosList = rowData:getValue("block_position_client")
  if not string.IsNullOrEmpty(strPosList) then
    self.posList = {}
    local posArr = string.split(strPosList, "|")
    for i, v in ipairs(posArr) do
      local arr = string.string2array_i_oneSep(v, ";")
      self.posList[i] = arr
    end
  end
end

function LwSeasonDiggingGameTemplate:ConvertPosAndScaleStr(posStr)
  local t = {}
  local arr1 = string.split(posStr, "|")
  for i, v in ipairs(arr1) do
    local arr2 = string.split(v, ",")
    local arr3 = string.split(arr2[1], ";")
    local arr4 = string.split(arr2[2], ";")
    local pos = {
      x = tonumber(arr3[1]),
      y = tonumber(arr3[2]),
      scaleBlock = tonumber(arr4[1]),
      scaleBg = tonumber(arr4[2])
    }
    table.insert(t, pos)
  end
  return t
end

return LwSeasonDiggingGameTemplate
