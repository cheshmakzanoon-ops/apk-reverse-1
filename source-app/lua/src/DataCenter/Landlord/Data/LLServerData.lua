local LLServerData = BaseClass("LLServerData")

function LLServerData:__init()
  self.serverId = 0
  self.icon = 0
  self.king = nil
  self.king2 = nil
  self.group = 0
  self.isBigLord = false
  self.isBigFarmer = false
  self.invitedEndTime = 0
  self.invitedCDTime = 0
  self.giftId = 0
  self.giftNum = 0
  self.msg = ""
  self.rank = 0
end

function LLServerData:__delete()
  self.king = nil
  self.king2 = nil
end

function LLServerData:GetKing(king)
  return {
    uid = king.uid,
    name = king.name,
    abbr = king.allianceAbbr,
    pic = king.pic,
    picVer = king.picVer,
    headSkinId = king.headSkinId,
    headSkinET = king.headSkinET,
    power = king.power
  }
end

function LLServerData:ParseData(msg)
  self.serverId = msg.serverId or 0
  self.icon = msg.icon or 0
  local king = msg.king
  if king ~= nil then
    self.king = self:GetKing(king)
  else
    self.king = {}
  end
  local king2 = msg.king2
  if king2 ~= nil then
    self.king2 = self:GetKing(king2)
  else
    self.king2 = {}
  end
  self:SetGroup(msg.group)
  self.isBigLord = msg.isBigLord or false
  self.isBigFarmer = msg.isBigFarmer or false
  self.giftId = msg.giftId or 0
  self.giftNum = msg.giftNum or 0
  self.msg = msg.msg or ""
  self.rank = msg.rank or 0
end

function LLServerData:SetGroup(group)
  self.group = group or 0
  if self.serverId == LuaEntry.Player:GetSourceServerId() then
    local csInst = CS.LandlordManager.Instance
    if csInst then
      csInst.myCampId = self.group
    end
  end
end

function LLServerData:Description(sb)
  sb:AppendFormatLine("  serverId : %s", self.serverId)
  sb:AppendFormatLine("    icon : %s", self.icon)
  sb:AppendFormatLine("    king : %s", self.king ~= nil and self.king.uid or "\230\151\160")
  sb:AppendFormatLine("    king2 : %s", self.king2 ~= nil and self.king2.uid or "\230\151\160")
  sb:AppendFormatLine("    group : %s", self.group)
  sb:AppendFormatLine("    isBigLord : %s", self.isBigLord)
  sb:AppendFormatLine("    isBigFarmer : %s", self.isBigFarmer)
  sb:AppendFormatLine("    giftId : %s", self.giftId)
  sb:AppendFormatLine("    giftNum : %s", self.giftNum)
  sb:AppendFormatLine("    msg : %s", self.msg)
  sb:AppendFormatLine("    rank : %s", self.rank)
end

return LLServerData
