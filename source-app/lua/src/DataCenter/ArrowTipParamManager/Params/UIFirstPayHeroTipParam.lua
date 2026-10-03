local Base = require("DataCenter.ArrowTipParamManager.UIArrowTipBaseParam")
local UIFirstPayHeroTipParam = BaseClass("UIFirstPayHeroTipParam", Base)

function UIFirstPayHeroTipParam:Reset()
  Base.Reset(self)
  self.type = ArrowTipEnumtype.Type.FirstPayHeroTip
  self.heroId = 0
  self.heroLv = 0
  self.heroRank = 0
  self.width = 522
end

return UIFirstPayHeroTipParam
