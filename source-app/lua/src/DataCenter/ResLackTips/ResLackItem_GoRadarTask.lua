local ResLackItemBase = require("DataCenter.ResLackTips.ResLackItemBase")
local ResLackItem_GoRadarTask = BaseClass("ResLackItem_GoRadarTask", ResLackItemBase)
local Localization = CS.GameEntry.Localization
local resType = {
  [1] = ResourceItem.Wood,
  [2] = ResourceItem.Stone
}

function ResLackItem_GoRadarTask:CheckIsOk(_resType, _needCnt, isResItem)
  if CS.SceneManager.IsInPVE() then
    return false
  end
  local list = DataCenter.RadarCenterDataManager:GetDetectEventInfoUuids()
  local result = {}
  
  local function GetOneEventData(uuid)
    local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(uuid)
    if data == nil then
      return nil
    end
    local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(data.eventId)
    if template == nil then
      return nil
    end
    local param = {}
    param.uuid = uuid
    param.eventId = tonumber(data.eventId)
    param.template = template
    return param
  end
  
  table.walk(list, function(k, v)
    local param = GetOneEventData(v)
    if param ~= nil then
      table.insert(result, param)
    end
  end)
  local para1 = self._config:getValue("para1")
  if string.IsNullOrEmpty(para1) then
    if isResItem then
      for i = 1, #result do
        if result[i].template.type2 ~= "" and resType[tonumber(result[i].template.type2)] == _resType then
          self.eventType = result[i].template.type
          return true
        end
      end
    end
  else
    for i = 1, #result do
      if tonumber(para1) == result[i].template.type then
        self.eventType = result[i].template.type
        return true
      end
    end
  end
  return false
end

function ResLackItem_GoRadarTask:TodoAction()
  local para1 = self._config:getValue("para1")
  GoToUtil.GoRadarProbe(nil, tonumber(self.eventType))
end

return ResLackItem_GoRadarTask
