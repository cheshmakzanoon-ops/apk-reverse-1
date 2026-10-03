local MailBattleOneRound = require("DataCenter.MailData.BattleReport.MailBattleOneRound")
local BattleReport = require("DataCenter.MailData.DataExtModule.MailBattleReport")
local MailChampionBattleReport = BaseClass("MailChampionBattleReport", BattleReport)

function MailChampionBattleReport:__init()
  self._fightRoundList = {}
  self._battlePointId = 0
  self._battleBuffList = {}
  self.version = 0
  self.showRoundList = {}
end

function MailChampionBattleReport:ParseContent(mailContent)
  if table.IsNullOrEmpty(mailContent) then
    return
  end
  local battleReport = mailContent.battleContent or ""
  local pb_BattleReport = PBController.ParsePb1(battleReport, "protobuf.DeliteReport") or {}
  self.mailType = MailType.ELITE_FIGHT_MAIL
  local fightReports = pb_BattleReport.fightReports or {}
  for _, roundItem in pairs(fightReports) do
    if pb_BattleReport.otherInfo.uid == LuaEntry.Player.uid then
      roundItem.selfInfo = pb_BattleReport.otherInfo
      roundItem.otherInfo = pb_BattleReport.selfInfo
      
      local function swapValue(obj, name1, name2)
        local tmp = obj[name1]
        obj[name1] = obj[name2]
        obj[name2] = tmp
      end
      
      swapValue(roundItem, "otherArmyResult", "selfArmyResult")
      swapValue(roundItem, "otherBattleEffectGroups", "selfBattleEffectGroups")
      if roundItem.fightResult == 0 then
        roundItem.fightResult = 1
      elseif roundItem.fightResult == 1 then
        roundItem.fightResult = 0
      elseif roundItem.fightResult == FightResult.DRAW then
        roundItem.fightResult = 0
      end
    else
      roundItem.selfInfo = pb_BattleReport.selfInfo
      roundItem.otherInfo = pb_BattleReport.otherInfo
      if roundItem.fightResult == FightResult.DRAW then
        roundItem.fightResult = 1
      end
    end
    local battleRound = MailBattleOneRound.New()
    battleRound:ParseContent(roundItem, true)
    self:InsertRound(battleRound)
  end
  if pb_BattleReport.battlePointInfo and pb_BattleReport.battlePointInfo.pointId then
    self._battlePointId = pb_BattleReport.battlePointInfo.pointId
  end
  local battleResult = pb_BattleReport.battleResult or 0
  self.selfWin = battleResult == 0
  self._startRound = pb_BattleReport.startRound or 0
  self.phase = pb_BattleReport.parse or 0
  self.round = pb_BattleReport.round or 0
  self.version = pb_BattleReport.version or 0
end

return MailChampionBattleReport
