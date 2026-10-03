local CityPioneerArchive = BaseClass("CityPioneerArchive", Singleton)
local rapidjson = require("rapidjson")
local Setting = CS.GameEntry.Setting
local tostring = _ENV.tostring
local IsInCity = CS.SceneManager.IsInCity

function CityPioneerArchive:__init()
  self.data = {}
end

function CityPioneerArchive:__delete()
  self:RemoveSaveTimer()
end

function CityPioneerArchive:SetPosRot(pos, rot)
  self.data.pos = {
    x = pos.x,
    y = pos.y,
    z = pos.z
  }
  self.data.rot = {
    x = rot.x,
    y = rot.y,
    z = rot.z,
    w = rot.w
  }
end

function CityPioneerArchive:GetPosRot()
  return self.load_data.pos, self.load_data.rot
end

function CityPioneerArchive:ClearCarry()
  self.data.carry = nil
end

function CityPioneerArchive:SetCarry(i, t)
  if self.data.carry == nil then
    self.data.carry = {}
  end
  self.data.carry[i] = t
end

function CityPioneerArchive:GetCarry()
  return self.load_data.carry
end

function CityPioneerArchive:ClearCutRes()
  self.data.cut_res = nil
end

function CityPioneerArchive:SetCutRes(t, n)
  if self.data.cut_res == nil then
    self.data.cut_res = {}
  end
  local cut_res = self.data.cut_res
  cut_res[tostring(t)] = n
end

function CityPioneerArchive:GetCutRes()
  if self.load_data.cut_res == nil then
    return
  end
  return self.load_data.cut_res
end

function CityPioneerArchive:ClearRemainRes()
  self.data.remain_res = nil
end

function CityPioneerArchive:SetRemainRes(uuid, n)
  if self.data.remain_res == nil then
    self.data.remain_res = {}
  end
  self.data.remain_res[tostring(uuid)] = n
end

function CityPioneerArchive:GetRemainRes(uuid)
  if self.load_data.remain_res == nil then
    return
  end
  return self.load_data.remain_res[tostring(uuid)]
end

function CityPioneerArchive:GetSaveKey()
  return tostring(LuaEntry.Player:GetUid()) .. "_citypioneer"
end

function CityPioneerArchive:Save()
  if self.save then
    self.data = {}
    DataCenter.CityTriggerPointDataManager:SaveArchive()
    CitySpaceMan:GetInstance():SaveArchive()
    DataCenter.CityNpcManager:SaveArchive()
    DataCenter.CityNoMovePointManager:SaveArchive()
    DataCenter.CityPrologueBuildManager:SaveArchive()
    WastelandFarmManager:GetInstance():SaveArchive()
    WastelandModelMgr:GetInstance():SaveArchive()
    self.data.ok_triggers = CityTriggerPointManager:GetInstance().ok_triggers
    local json = rapidjson.encode(self.data)
    Setting:SetString(self:GetSaveKey(), json)
    Setting:Save()
  end
end

function CityPioneerArchive:Load()
  local json = Setting:GetString(self:GetSaveKey())
  print("CityPioneerArchive::Load", json)
  if json ~= nil and json ~= "" then
    self.load_data = rapidjson.decode(json)
  end
  self.load_data = self.load_data or {}
  self.save = true
  if table.IsNullOrEmpty(self.load_data) or table.IsNullOrEmpty(self.load_data.ok_triggers) then
    return false
  end
  self:UnlockArchiveFog()
  DataCenter.CityPrologueBuildManager:InitBuild()
  TimerManager:GetInstance():DelayInvoke(function()
    self:DelayFunc()
  end, 1.5)
  return true
end

function CityPioneerArchive:DelayFunc()
  if self:FixLoad() == false then
    return false
  end
  CityTriggerPointManager:GetInstance().ok_triggers = self.load_data.ok_triggers or {}
  CitySpaceMan:GetInstance():LoadArchive(self.load_data.user)
end

function CityPioneerArchive:FixLoad()
  local lastTrigger = self.load_data.ok_triggers[#self.load_data.ok_triggers]
  if not lastTrigger then
    return false
  end
  local template = DataCenter.CityTriggerPointTemplateManager:GetTemplate(lastTrigger)
  if not template then
    return false
  end
  if template.posArr == nil or template.posArr[1] == nil then
    return false
  end
  self.load_data.user.pos = template.posArr[1]
  CityTriggerPointManager:GetInstance():DoTriggerOK(lastTrigger)
  return true
end

function CityPioneerArchive:UnlockArchiveFog()
  CityPioneerFog:GetInstance():UnlockAreaFog(1, true)
  local t = self.load_data.ok_triggers
  if table.IsNullOrEmpty(t) then
    return
  end
  for k, v in ipairs(t) do
    CityPioneerFog:GetInstance():UnlockAreaFog(v, true)
  end
end

function CityPioneerArchive:StartSaveTimer()
  self.saveTimer = TimerManager:GetInstance():GetTimer(1, function()
    self:Save()
  end, nil, false, false, false)
  self.saveTimer:Start()
end

function CityPioneerArchive:RemoveSaveTimer()
  if self.saveTimer then
    self.saveTimer:Stop()
    self.saveTimer = nil
  end
end

function CityPioneerArchive:SetNpc(modelName, posArr, angle)
  if self.data.npc == nil then
    self.data.npc = {}
  end
  local npc = {}
  npc.posArr = posArr
  npc.angle = angle
  self.data.npc[modelName] = npc
end

function CityPioneerArchive:GetNpc()
  if self.load_data.npc == nil then
    return
  end
  return self.load_data.npc
end

function CityPioneerArchive:SetBuild(point, modelName, state, activeState)
  if self.data.build == nil then
    self.data.build = {}
  end
  local build = {}
  build.point = point
  build.modelName = modelName
  build.state = state
  build.activeState = activeState
  self.data.build[tostring(point)] = build
end

function CityPioneerArchive:GetBuild()
  if self.load_data.build == nil then
    return
  end
  return self.load_data.build
end

function CityPioneerArchive:SetUserState(tbl)
  self.data.user = tbl
end

function CityPioneerArchive:SetTrigger(id, giveRes)
  if self.data.trigger == nil then
    self.data.trigger = {}
  end
  local trigger = {}
  trigger.id = id
  trigger.giveRes = {}
  if giveRes ~= nil then
    for k, v in pairs(giveRes) do
      trigger.giveRes[tostring(k)] = v
    end
  end
  self.data.trigger[tostring(id)] = trigger
end

function CityPioneerArchive:GetTrigger()
  if self.load_data.trigger == nil then
    return
  end
  return self.load_data.trigger
end

function CityPioneerArchive:SetNoMovePoint(point)
  if self.data.noMovePoint == nil then
    self.data.noMovePoint = {}
  end
  local noMovePoint = {}
  noMovePoint.point = point
  self.data.noMovePoint[tostring(point)] = noMovePoint
end

function CityPioneerArchive:GetNoMovePoint()
  if self.load_data.noMovePoint == nil then
    return
  end
  return self.load_data.noMovePoint
end

function CityPioneerArchive:SetFarmList(pos, restype)
  if self.data.farmlist == nil then
    self.data.farmlist = {}
  end
  local tbl = {}
  tbl.pos = pos
  tbl.restype = restype
  self.data.farmlist[#self.data.farmlist + 1] = tbl
end

function CityPioneerArchive:GetFarmList()
  if self.load_data.farmlist == nil then
    return {}
  end
  return self.load_data.farmlist
end

function CityPioneerArchive:SetPrologueBuild(tbl)
  self.data.build = tbl
end

function CityPioneerArchive:GetPrologueBuild()
  return self.load_data.build
end

function CityPioneerArchive:SetAtkModel(pos, restype)
  if self.data.atkModel == nil then
    self.data.atkModel = {}
  end
  local tbl = {}
  tbl.pos = pos
  tbl.restype = restype
  self.data.atkModel[#self.data.atkModel + 1] = tbl
end

function CityPioneerArchive:GetAtkModelList()
  if self.load_data.atkModel == nil then
    return {}
  end
  return self.load_data.atkModel
end

return CityPioneerArchive
