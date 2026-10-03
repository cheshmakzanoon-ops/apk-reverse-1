local PerformData = BaseClass("PerformData")
local Const = require("Scene.LWCityPerformNpc.Const")

function PerformData:__init()
  self.birthPos = Vector3.zero
  self.endPos = Vector3.zero
  self.modelId = 0
  self.arriveCallBack = nil
  self.isArriveDelete = true
  self.posList = {}
  self.speed = Const.npcSpeed
  self.modelPatch = ""
end

function PerformData:SetModelPatch(modelId)
  self.modelId = modelId
  local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(modelId)
  self.modelPatch = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "city_model_path")
end

function PerformData:InitData(birthPos, endPos, modelPatch)
  self.birthPos = Vector3.New(birthPos.x, birthPos.y, birthPos.z)
  self.modelPatch = modelPatch
  self.endPos = Vector3.New(endPos.x, endPos.y, endPos.z)
end

return PerformData
