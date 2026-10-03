local UIArrowTipBaseParam = BaseClass("UIArrowTipBase")

function UIArrowTipBaseParam:__init()
  self:Reset()
end

function UIArrowTipBaseParam:Reset()
  self.type = ArrowTipEnumtype.Type.Default
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

return UIArrowTipBaseParam
