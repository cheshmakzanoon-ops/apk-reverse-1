local base = require("DataCenter.LWGuideFlowManager.Behaviours.__click_base")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
behaviour.params = {
  {"number", "posX"},
  {"number", "posY"},
  {"number", "sizeW"},
  {"number", "sizeH"}
}
behaviour.params = table.mergeArray(behaviour.params, base.params)

function behaviour:__SetupMaskParams(maskParams)
  local screenRatio = Screen.height / Screen.width / (DefaultScreenHeight / DefaultScreenWidth)
  maskParams.rect = {}
  maskParams.rect.x = self.posX * screenRatio
  maskParams.rect.y = self.posY * screenRatio
  maskParams.rect.w = self.sizeW * screenRatio
  maskParams.rect.h = self.sizeH * screenRatio
  return nil
end

return behaviour
