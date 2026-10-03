local ChampionDuelDonateMsgData = BaseClass("ChampionDuelDonateMsgData")

function ChampionDuelDonateMsgData:__init()
  self:ResetData()
end

function ChampionDuelDonateMsgData:__delete()
  self:ResetData()
end

function ChampionDuelDonateMsgData:ResetData()
  self.picVer = 0
  self.server = 0
  self.lv = 0
  self.uid = ""
  self.pic = ""
  self.name = ""
  self.allianceName = ""
  self.headSkinId = 0
  self.headSkinET = 0
  self.word = ""
  self.rank = 0
  self.groupId = 0
  self.translateMsg = ""
  self.translating = false
end

function ChampionDuelDonateMsgData:ParseData(msg)
  self.picVer = msg.picVer or 0
  self.server = msg.server or 0
  self.lv = msg.lv or 0
  self.uid = msg.uid or ""
  self.pic = msg.pic or ""
  self.name = msg.name or ""
  self.allianceName = msg.allianceName or ""
  self.headSkinId = msg.headSkinId or 0
  self.headSkinET = msg.headSkinET or 0
  local word = msg.word or ""
  if self.word ~= word then
    self.word = word
    self.translateMsg = ""
    self.translating = false
  end
  self.rank = msg.rank or 0
  self.groupId = msg.groupId or 0
end

function ChampionDuelDonateMsgData:GetMessage()
  return self.word
end

function ChampionDuelDonateMsgData:SetIsTranslating(translatingFlag)
  self.translating = translatingFlag
end

function ChampionDuelDonateMsgData:SetTranslationMsg(msg)
  self.translateMsg = msg
end

return ChampionDuelDonateMsgData
