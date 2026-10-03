local TorchRelayStageResourceTemplate = BaseClass("TorchRelayStageResourceTemplate")
local TRAP_MOTION_PATH_FORMAT = "DataCenter.LWBattle.Logic.CountBattle.Traps.Motion.Motion%s"

function TorchRelayStageResourceTemplate:__init()
  self.id = 0
  self.type = 0
  self.prefab = ""
  self.sleep_time = 0
  self.motion_parts = ""
  self.motion_type = ""
  self.motion_param1 = ""
  self.motion_param2 = ""
  self.motion_param3 = ""
  self.buff_resource = ""
  self.triiger_effect_resource = ""
  self.buff_pic = ""
  self:InitCustom()
end

function TorchRelayStageResourceTemplate:__delete()
  self.id = nil
  self.type = nil
  self.prefab = nil
  self.sleep_time = nil
  self.motion_parts = nil
  self.motion_type = nil
  self.motion_param1 = nil
  self.motion_param2 = nil
  self.motion_param3 = nil
  self.buff_resource = nil
  self.triiger_effect_resource = nil
  self.buff_pic = nil
  self:DeleteCustom()
end

function TorchRelayStageResourceTemplate:InitCustom()
  self.motionCfgs = {}
end

function TorchRelayStageResourceTemplate:DeleteCustom()
  self.motionCfgs = nil
end

function TorchRelayStageResourceTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.type = tonumber(row:getValue("type")) or 0
  self.prefab = row:getValue("prefab") or ""
  self.sleep_time = tonumber(row:getValue("sleep_time")) or 0
  self.motion_parts = row:getValue("motion_parts") or ""
  self.motion_type = row:getValue("motion_type") or ""
  self.motion_param1 = row:getValue("motion_param1") or ""
  self.motion_param2 = row:getValue("motion_param2") or ""
  self.motion_param3 = row:getValue("motion_param3") or ""
  self.buff_resource = row:getValue("buff_resource") or ""
  self.triiger_effect_resource = row:getValue("triiger_effect_resource") or ""
  self.buff_pic = row:getValue("buff_pic") or ""
  for i = 1, #self.motion_parts do
    local motionCfg = {}
    motionCfg.part = self.motion_parts[i]
    motionCfg.type = self.motion_type[i]
    motionCfg.class = require(string.format(TRAP_MOTION_PATH_FORMAT, motionCfg.type))
    if not motionCfg.class then
      Logger.LogError("[TorchRelay] Count Battle config error! invalide trap motion type:" .. motionCfg.type)
      return nil
    end
    motionCfg.class.ParseParams(motionCfg, {
      self.motion_param1[i],
      self.motion_param2[i],
      self.motion_param3[i]
    })
    table.insert(self.motionCfgs, motionCfg)
  end
end

return TorchRelayStageResourceTemplate
