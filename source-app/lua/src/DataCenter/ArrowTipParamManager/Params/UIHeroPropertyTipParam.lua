local Base = require("DataCenter.ArrowTipParamManager.UIArrowTipBaseParam")
local UIHeroPropertyTipParam = BaseClass("UIHeroPropertyTipParam", Base)

function UIHeroPropertyTipParam:Reset()
  Base.Reset(self)
  self.mainPropName = ""
  self.mainPropValue = 0
  self.splitProp = nil
  self.width = 530
end

return UIHeroPropertyTipParam
