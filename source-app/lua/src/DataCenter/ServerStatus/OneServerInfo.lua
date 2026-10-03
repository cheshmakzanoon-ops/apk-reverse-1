local OneServerInfo = BaseClass("OneServerInfo")

function OneServerInfo:__init(serverId)
  self.serverId = serverId
  self.zoneStar = 0
end

function OneServerInfo:__delete()
  self.serverId = nil
  self.zoneStar = nil
end

function OneServerInfo:UpdateFromMsg(msg)
  if not msg then
    return
  end
  self.zoneStar = msg.zoneStar or 0
end

return OneServerInfo
