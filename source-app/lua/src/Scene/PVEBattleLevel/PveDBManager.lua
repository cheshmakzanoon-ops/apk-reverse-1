local PveDBManager = BaseClass("PveDBManager")
local Const = require("Scene.PVEBattleLevel.Const")
local rapidjson = require("rapidjson")
local Setting = CS.GameEntry.Setting

function PveDBManager:__init(battleLevel)
  self.battleLevel = battleLevel
  self.data = {}
  self.removeId = {}
end

function PveDBManager:GetSaveKey()
  return tostring(LuaEntry.Player:GetUid()) .. "_pveDB" .. self.battleLevel.levelId
end

function PveDBManager:__delete()
end

function PveDBManager:InitDB()
  self.data = {}
  self.removeId = {}
  local json = Setting:GetString(self:GetSaveKey())
  if json ~= nil and json ~= "" then
    self.data = rapidjson.decode(json)
    if self.data.saveTree ~= nil then
      for k, v in ipairs(self.data.saveTree) do
        self.removeId[v] = 1
      end
    end
  end
end

function PveDBManager:ClearDB()
  self.removeId = {}
  self.data = {}
  Setting:RemoveSetting(self:GetSaveKey())
end

function PveDBManager:SaveDB()
  if table.count(self.data) > 0 then
    self:SavePos()
    local json = rapidjson.encode(self.data)
    Setting:SetString(self:GetSaveKey(), json)
    Setting:Save()
  end
end

function PveDBManager:AddOneSaveTree(id)
  if self.data.saveTree == nil then
    self.data.saveTree = {}
  end
  table.insert(self.data.saveTree, id)
  self.removeId[id] = 1
end

function PveDBManager:IsBeRemove(id)
  if self.removeId[id] ~= nil then
    return true
  end
  return false
end

function PveDBManager:SavePos()
  self.data.position = self.battleLevel:GetPosition()
  self.data.rotation = self.battleLevel:GetRotation()
end

function PveDBManager:GetSavePos()
  return self.data.position, self.data.rotation
end

function PveDBManager:GetLastFinishTriggerId()
  return self.data.lastFinishTriggerId
end

function PveDBManager:SaveLastFinishTriggerId(triggerId)
  self.data.lastFinishTriggerId = triggerId
end

function PveDBManager:GetSkillSliderNum()
  return self.data.skillSliderNum
end

function PveDBManager:SaveSkillSliderNum(num)
  self.data.skillSliderNum = num
end

return PveDBManager
