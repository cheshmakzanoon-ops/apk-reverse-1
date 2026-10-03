local Base = require("DataCenter.ArrowTipParamManager.UIArrowTipBaseParam")
local UIOffSeason1RecaptureBuffTipParam = BaseClass("UIOffSeason1RecaptureBuffTipParam", Base)

function UIOffSeason1RecaptureBuffTipParam:Reset()
  Base.Reset(self)
  self.width = 504
  self.yPosFix = -40
  self.preferTop = true
  self.xPadding = 15
  self.effectInfo = nil
  self.closeCallback = nil
  self.alignObject = nil
end

return UIOffSeason1RecaptureBuffTipParam
