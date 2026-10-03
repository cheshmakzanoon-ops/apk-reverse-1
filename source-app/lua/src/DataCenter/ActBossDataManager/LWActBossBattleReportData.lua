local LWActBossBattleReportData = BaseClass("LWActBossBattleReportData")

function LWActBossBattleReportData:__init()
  self.time = 0
  self.damage = 0
  self.reportId = 0
  self.reportAddress = ""
  self.heroList = {}
end

function LWActBossBattleReportData:__delete()
  self.time = nil
  self.damage = nil
  self.reportId = nil
  self.reportAddress = nil
  self.heroList = nil
end

function LWActBossBattleReportData:InitData(message)
  if message.time then
    self.time = message.time
  end
  if message.damage then
    self.damage = message.damage
  end
  if message.reportId then
    self.reportId = message.reportId
  end
  if message.marchInfo then
    self.heroList = {}
    local marchInfo = message.marchInfo
    local armyUnit = PBController.ParsePb1(marchInfo.armyInfo, "protobuf.ArmyCombatUnit")
    if armyUnit and armyUnit.armyInfo then
      local heroesArr = armyUnit.armyInfo.heroes
      for k, heroData in pairs(heroesArr) do
        table.insert(self.heroList, heroData)
      end
    end
    if marchInfo and marchInfo.reportAddress then
      self.reportAddress = marchInfo.reportAddress
    end
  end
end

return LWActBossBattleReportData
