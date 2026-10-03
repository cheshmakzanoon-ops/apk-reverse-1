local PushMyLightAffectInfoMessage = BaseClass("PushMyLightAffectInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function PushMyLightAffectInfoMessage:OnCreate()
  base.OnCreate(self)
end

function PushMyLightAffectInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode == nil and t.num then
    local lightHouseStatus = DataCenter.SeasonPowerWorkerManager.lightHouseStatus
    if lightHouseStatus and lightHouseStatus.active then
      local brightnessLevel = toInt(lightHouseStatus.brightnessLevel)
      if 0 < brightnessLevel then
        local lightSize = 5
        local cfg = LocalController:instance():getLine(TableName.LW_LIGHTS_ON_S4, brightnessLevel)
        if cfg and cfg.electricity_use ~= nil then
          lightSize = toInt(cfg.size) * 2 + 1
        end
        local lightSizeStr = string.format("%s\195\151%s", lightSize, lightSize)
        local levelStr = Localization:GetString("season_s4_building_ui_info0" .. 1 + brightnessLevel)
        local message = Localization:GetString("season_s4_tips055", levelStr, lightSizeStr, t.num)
        UIUtil.ShowTips(message)
      end
    end
  end
end

return PushMyLightAffectInfoMessage
