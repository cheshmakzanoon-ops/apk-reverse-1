local FlyTextContext = BaseClass("FlyTextContext")

function FlyTextContext:__init()
end

function FlyTextContext:__delete()
  self.icon = nil
  self.text = nil
  self.srcPos = nil
  self.dstPos = nil
  self.srcScale = nil
  self.dstScale = nil
  self.fontSize = nil
  self.moveTime = nil
  self.startDelay = nil
  self.callback = nil
  self.parent = nil
  self.iconIsLeft = nil
end

function FlyTextContext:SetIcon(icon)
  self.icon = icon
end

function FlyTextContext:SetText(text)
  self.text = text
end

function FlyTextContext:SetSrcPos(srcPos)
  self.srcPos = srcPos
end

function FlyTextContext:SetDstPos(dstPos)
  self.dstPos = dstPos
end

function FlyTextContext:SetSrcScale(srcScale)
  self.srcScale = srcScale
end

function FlyTextContext:SetDstScale(dstScale)
  self.dstScale = dstScale
end

function FlyTextContext:SetFontSize(fontSize)
  self.fontSize = fontSize
end

function FlyTextContext:SetMoveTime(moveTime)
  self.moveTime = moveTime
end

function FlyTextContext:SetStartDelayTime(startDelay)
  self.startDelay = startDelay
end

function FlyTextContext:SetCallback(callback)
  self.callback = callback
end

function FlyTextContext:SetParent(parent)
  self.parent = parent
end

function FlyTextContext:SetIconIsLeft(iconIsLeft)
  self.iconIsLeft = iconIsLeft
end

return FlyTextContext
