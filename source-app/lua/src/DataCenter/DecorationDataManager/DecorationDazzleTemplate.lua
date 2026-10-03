local DecorationDazzleTemplate = BaseClass("DecorationDazzleTemplate")

local function __init(self)
  self.id = 0
  self.type = 0
  self.name = ""
  self.decoration_id = 0
  self.decoration_id_new = 0
  self.show_condition = {}
  self.fov = 20
  self.cameraY = 16.6
  self.gainMethod = {}
  self.get_fov = 20
  self.get_cameraY = 16.6
end

local function __delete(self)
  self.id = nil
  self.type = nil
  self.name = nil
  self.decoration_id = nil
  self.decoration_id_new = nil
  self.show_condition = nil
  self.fov = nil
  self.cameraY = nil
  self.gainMethod = nil
  self.get_fov = nil
  self.get_cameraY = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.type = tonumber(row:getValue("type")) or 0
  self.name = row:getValue("name") or ""
  self.decoration_id = tonumber(row:getValue("decoration_id")) or 0
  self.decoration_id_new = tonumber(row:getValue("decoration_id_new")) or 0
  local show_condition = row:getValue("show_condition")
  if not string.IsNullOrEmpty(show_condition) then
    local showConditionStr1 = string.split(show_condition, "|")
    if not table.IsNullOrEmpty(showConditionStr1) then
      for k, v in pairs(showConditionStr1) do
        local condition = string.split(v, ";")
        if table.count(condition) == 2 then
          table.insert(self.show_condition, {
            tonumber(condition[1]),
            tostring(condition[2])
          })
        end
      end
    end
  end
  self.fov = tonumber(row:getValue("fov")) or 20
  self.cameraY = tonumber(row:getValue("cameraY")) or 16.6
  self.gainMethod = {}
  local gainStr = row:getValue("para_gain")
  local vec1 = string.split(gainStr, "|")
  for k, v in ipairs(vec1) do
    if not string.IsNullOrEmpty(v) then
      local effectVec = string.split(v, ";")
      if not table.IsNullOrEmpty(effectVec) then
        local para = {}
        para.id = toInt(effectVec[1])
        local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(para.id)
        if itemTemplate then
          para.name = tonumber(itemTemplate.para2)
        end
        para.index = k
        para.skinId = self.id
        table.insert(self.gainMethod, para)
      end
    end
  end
  self.get_fov = tonumber(row:getValue("get_fov")) or 20
  self.get_cameraY = tonumber(row:getValue("get_cameraY")) or 16.6
end

local function CheckTemplateCanShow(self)
  return DataCenter.DecorationTemplateManager:CheckTemplateCanShow(self.show_condition)
end

local function HasOpen(self)
  if self.type == 1 then
    local data = DataCenter.SeasonCallbackManager:GetConfigDataByCallbackId(SeasonCallbackType.Base, self.decoration_id, true)
    if not data then
      return false
    end
  elseif self.type == 2 then
    local data = DataCenter.ItemSkinDataManager:GetItemSkinDataById(self.id)
    return data ~= nil and data:IsInExpireTime()
  end
  return true
end

local function GetShowTime(self)
  if self.type == 1 then
    local data = DataCenter.SeasonCallbackManager:GetConfigDataByCallbackId(SeasonCallbackType.Base, self.decoration_id, true)
    if not data then
      return 0
    end
    return data.startTime or 0, data.endTime
  elseif self.type == 2 then
    local data = DataCenter.ItemSkinDataManager:GetItemSkinDataById(self.id)
    if not data then
      return 0
    end
    return 0, data.expireTime
  end
  return 0
end

DecorationDazzleTemplate.__init = __init
DecorationDazzleTemplate.__delete = __delete
DecorationDazzleTemplate.InitData = InitData
DecorationDazzleTemplate.CheckTemplateCanShow = CheckTemplateCanShow
DecorationDazzleTemplate.HasOpen = HasOpen
DecorationDazzleTemplate.GetShowTime = GetShowTime
return DecorationDazzleTemplate
