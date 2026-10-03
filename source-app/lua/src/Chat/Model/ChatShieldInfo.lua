local ChatShieldInfo = BaseClass("ChatShieldInfo")

function ChatShieldInfo:__init()
  self.uuid = ""
  self.uid = ""
end

function ChatShieldInfo:onParseServerData(shieldTab)
  self.uuid = shieldTab.uuid
  if shieldTab.other then
    self.uid = shieldTab.other
  end
  if shieldTab.name then
    self.name = shieldTab.name
  end
  if shieldTab.pic then
    self.pic = shieldTab.pic
  end
  if shieldTab.picVer then
    self.picVer = shieldTab.picVer
  end
  if shieldTab.power then
    self.power = shieldTab.power
  end
  if shieldTab.server then
    self.server = shieldTab.server
  end
  if shieldTab.abbr then
    self.abbr = shieldTab.abbr
  end
end

return ChatShieldInfo
