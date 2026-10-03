local SeasonPhotoTemplateBorder = BaseClass("SeasonPhotoTemplateBorder")

function SeasonPhotoTemplateBorder:__init()
  self.id = 0
  self.name = ""
  self.resource = ""
  self.condition = nil
  self.resource_icon = ""
  self.resource_big = ""
end

function SeasonPhotoTemplateBorder:__delete()
  self.id = nil
  self.name = nil
  self.resource = nil
  self.condition = nil
  self.resource_icon = nil
  self.resource_big = nil
end

function SeasonPhotoTemplateBorder:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.name = rowData:getValue("name") or ""
  self.resource = rowData:getValue("resource") or ""
  self.resource_icon = rowData:getValue("resource_icon") or ""
  self.resource_big = rowData:getValue("resource_big") or ""
  local param = rowData:getValue("condition") or ""
  param = string.split(param, ";")
  local paramType = tonumber(param[1] or 2)
  if paramType == 2 then
    self.condition = nil
  elseif paramType == 1 then
    if param[2] then
      local range = string.split(param[2], "-")
      self.condition = {
        tonumber(range[1] or 0),
        tonumber(range[2] or 0)
      }
    end
  elseif paramType == 3 and param[2] then
    local ids = string.split(param[2], ",")
    local idList = {}
    for i, v in ipairs(ids) do
      idList[i] = toInt(v)
    end
    self.condition = {type = 3, ids = idList}
  end
end

function SeasonPhotoTemplateBorder:IsLock(rank, seasonRewardConfigId)
  if not self.condition then
    return false
  end
  if type(self.condition) == "table" and self.condition.type == 3 then
    if not seasonRewardConfigId or toInt(seasonRewardConfigId) <= 0 then
      return true
    end
    local ids = self.condition.ids or {}
    for _, rid in ipairs(ids) do
      if toInt(rid) == toInt(seasonRewardConfigId) then
        return false
      end
    end
    return true
  end
  rank = rank or 0
  if rank < (self.condition[1] or 0) or rank > (self.condition[2] or 0) then
    return true
  end
  return false
end

return SeasonPhotoTemplateBorder
