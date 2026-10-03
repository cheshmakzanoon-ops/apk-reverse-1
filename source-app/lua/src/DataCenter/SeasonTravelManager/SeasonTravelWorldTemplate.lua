local SeasonTravelWorldTemplate = BaseClass("SeasonTravelWorldTemplate")

function SeasonTravelWorldTemplate:__init()
  self.id = 0
  self.season = 0
  self.piece_Prefab = ""
  self.show = ""
  self.small_banner = ""
  self.small_banner_season = ""
  self.big_banner = ""
  self.big_name = ""
  self.big_description_1 = ""
  self.big_description_2 = ""
  self.comicgroup = ""
  self.introduction = ""
  self.activeModel = nil
  self.condition = {}
  self.world_model_offset = nil
end

function SeasonTravelWorldTemplate:__delete()
  self.id = nil
  self.season = nil
  self.piece_Prefab = nil
  self.show = nil
  self.small_banner = nil
  self.small_banner_season = nil
  self.big_banner = nil
  self.big_name = nil
  self.big_description_1 = nil
  self.big_description_2 = nil
  self.comicgroup = nil
  self.introduction = nil
  self.activeModel = nil
  self.condition = nil
  self.world_model_offset = nil
end

function SeasonTravelWorldTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.season = rowData:getValue("season") or 0
  self.piece_Prefab = rowData:getValue("piece_Prefab") or ""
  self.show = rowData:getValue("show") or ""
  self.small_banner = rowData:getValue("small_banner") or ""
  self.small_banner_season = rowData:getValue("small_banner_season") or ""
  self.big_banner = rowData:getValue("big_banner") or ""
  self.big_name = rowData:getValue("big_name") or ""
  self.big_description_1 = rowData:getValue("big_description_1") or ""
  self.big_description_2 = rowData:getValue("big_description_2") or ""
  self.comicgroup = rowData:getValue("comicgroup") or ""
  self.introduction = rowData:getValue("introduction") or ""
  local activeModel = rowData:getValue("activeModel")
  if string.IsNullOrEmpty(activeModel) then
  end
  self.activeModel = tonumber(activeModel) == 1
  if not string.IsNullOrEmpty(self.show) then
    local conditionShow = string.split(self.show, ";")
    local type = toInt(conditionShow[1])
    local param = string.split(conditionShow[2], ",")
    self.condition = {
      type = type,
      param1 = toInt(param[1]),
      param2 = toInt(param[2])
    }
  end
  local world_model_offset = rowData:getValue("modelviewoffset") or ""
  if not string.IsNullOrEmpty(world_model_offset) then
    local offset = string.split(world_model_offset, ",")
    self.world_model_offset = {
      x = tonumber(offset[1]),
      y = tonumber(offset[2])
    }
  end
end

function SeasonTravelWorldTemplate:Condition()
  if self.condition.type == 1 then
    local curSeason = SeasonUtil.GetSeason()
    if curSeason >= self.condition.param1 then
      return true
    elseif curSeason + 1 == self.condition.param1 then
      if SeasonUtil.IsInSeasonPrepareMode(true) then
        return SeasonUtil.GetSeasonPrepareDay() >= self.condition.param2
      end
      return false
    else
      return false
    end
  end
  return true
end

return SeasonTravelWorldTemplate
