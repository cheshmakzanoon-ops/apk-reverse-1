local Base = require("DataCenter.ArrowTipParamManager.UIArrowTipBaseParam")
local UIHeroSimpleTipParam = BaseClass("UIHeroSimpleTipParam", Base)
local DEFAULT_DESC_COLOR = Color.New(0.2392, 0.2392, 0.2392, 1)

function UIHeroSimpleTipParam:Reset()
  Base.Reset(self)
  self.title = ""
  self.content = ""
  self.descTxtColor = DEFAULT_DESC_COLOR
  self.bgColor = WhiteColor
end

return UIHeroSimpleTipParam
