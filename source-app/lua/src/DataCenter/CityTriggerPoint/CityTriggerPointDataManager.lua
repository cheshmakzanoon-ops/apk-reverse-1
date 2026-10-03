local CityTriggerPointDataManager = BaseClass("CityTriggerPointDataManager")
local CityTriggerPointData = require("DataCenter.CityTriggerPoint.CityTriggerPointData")

function CityTriggerPointDataManager:__init()
  self.triggersData = {}
  self.triggersDataByPoint = {}
end

function CityTriggerPointDataManager:__delete()
  self:RemoveAll()
end

function CityTriggerPointDataManager:InitAllTriggerPoints()
  local archive = CityPioneerArchive:GetInstance()
  local triggers = archive:GetTrigger()
  if triggers ~= nil then
    for k, v in pairs(triggers) do
      self:AddOneTrigger(v.id, v.giveRes)
    end
  end
end

function CityTriggerPointDataManager:AddOneTrigger(templateId, giveRes)
  templateId = tonumber(templateId)
  if self.triggersData[templateId] then
    return
  end
  local template = DataCenter.CityTriggerPointTemplateManager:GetTemplate(templateId)
  if template ~= nil then
    local data = CityTriggerPointData.New()
    data:SetData(template)
    self.triggersData[templateId] = data
    for _, p in ipairs(data:GetPointArray()) do
      data.pos = p
      self.triggersDataByPoint[SceneUtils.TilePosToIndex(p)] = data
    end
    if giveRes ~= nil then
      for k, v in pairs(giveRes) do
        data:SetGiveRes(tonumber(k), v)
      end
    end
    if data:IsWeaponType() or not data:IsFull() then
      CityTriggerPointManager:GetInstance():ShowOneTrigger(data)
    end
  end
end

function CityTriggerPointDataManager:RemoveOneTrigger(templateId)
  templateId = tonumber(templateId)
  local data = self.triggersData[templateId]
  if data ~= nil then
    for _, p in ipairs(data:GetPointArray()) do
      self.triggersDataByPoint[SceneUtils.TilePosToIndex(p)] = nil
    end
    self.triggersData[templateId] = nil
  end
end

function CityTriggerPointDataManager:GetAllTriggerPointData()
  return self.triggersData
end

function CityTriggerPointDataManager:GetTriggerPointData(pointIndex)
  return self.triggersDataByPoint[pointIndex]
end

function CityTriggerPointDataManager:GetTriggerPointDataFromId(id)
  return self.triggersData[id]
end

function CityTriggerPointDataManager:FindTriggerByTagType(tagType)
  for id, data in pairs(self.triggersData) do
    if data:GetTag() == tagType then
      return id
    end
  end
  return nil
end

function CityTriggerPointDataManager:SaveArchive()
  local archive = CityPioneerArchive:GetInstance()
  for id, data in pairs(self.triggersData) do
    archive:SetTrigger(id, data:GetAllGiveRes())
  end
end

function CityTriggerPointDataManager:RemoveAll()
  self.triggersData = {}
  self.triggersDataByPoint = {}
end

return CityTriggerPointDataManager
