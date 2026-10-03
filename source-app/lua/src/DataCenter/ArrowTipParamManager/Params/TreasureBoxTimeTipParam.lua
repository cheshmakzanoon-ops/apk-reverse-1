local Base = require("DataCenter.ArrowTipParamManager.UIArrowTipBaseParam")
local TreasureBoxTimeTipParam = BaseClass("TreasureBoxTimeTipParam", Base)

function TreasureBoxTimeTipParam:Reset()
  Base.Reset(self)
  self.alignObject = nil
  self.screenPos = nil
  self.width = 350
  self.yPosFix = 0
  self.showArrow = true
  self.preferTop = false
  self.bgColor = WhiteColor
  self.closeCallback = nil
  self.xPadding = 0
end

return TreasureBoxTimeTipParam
