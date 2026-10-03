local repaidJson = require("rapidjson")
local MailScoutReport = BaseClass("MailScoutReport")
local MailScoutParseHelper = require("DataCenter.MailData.MailScoutParseHelper")

function MailScoutReport:__init()
  self._scoutReport = {}
  self._hasParsedHero = false
  self._hasPrasedTacticalWeapon = false
  self._hasParsedPlayer = false
  self.disturbedScoutLv = 1
  self.scoutLv = 1
end

function MailScoutReport:ParseContent(mailContent)
  if table.IsNullOrEmpty(mailContent) then
    return
  end
  local scoutReport = mailContent.scoutContent or ""
  local pb_ScoutReport = PBController.ParsePb1(scoutReport, "protobuf.ScoutReport")
  self._scoutReport = pb_ScoutReport
  local scoutLv = 1
  local hideCount = 0
  if self._scoutReport then
    scoutLv = self._scoutReport.scoutLevel
    hideCount = self._scoutReport.hideCount
  end
  self.disturbedScoutLv = scoutLv - hideCount
  self.scoutLv = scoutLv
end

function MailScoutReport:GetExtData()
  return self._scoutReport
end

function MailScoutReport:GetHeroExpAddInfo()
  return {}
end

function MailScoutReport:ParseHero()
  if not self._scoutReport then
    return
  end
  if self._hasParsedHero then
    return
  end
  local army = self._scoutReport.army
  local targets = army.target
  if not table.IsNullOrEmpty(targets) then
    local formations = targets.formation
    if not table.IsNullOrEmpty(formations) then
      for i = 1, #formations do
        local formation = formations[i]
        MailScoutParseHelper.DecodeHero(formation)
      end
    end
  end
  local help = army.help
  if not table.IsNullOrEmpty(help) and not table.IsNullOrEmpty(help.formation) then
    for i = 1, #help.formation do
      local helpFormation = help.formation[i]
      local heroFormation = helpFormation.formation
      if not table.IsNullOrEmpty(heroFormation) then
        for j = 1, #heroFormation do
          local formation = heroFormation[j]
          MailScoutParseHelper.DecodeHero(formation)
        end
      end
    end
  end
  self._hasParsedHero = true
end

function MailScoutReport:ParseTacticalWeapon()
  if not self._scoutReport then
    return
  end
  if self._hasPrasedTacticalWeapon then
    return
  end
  local weapon = self._scoutReport.battleWeapon
  if weapon then
    MailScoutParseHelper.DecodeTacticalWeapon(weapon)
  end
  self._hasPrasedTacticalWeapon = true
end

function MailScoutReport:ParsePlayer()
  if not self._scoutReport then
    return
  end
  if self._hasParsedPlayer then
    return
  end
  MailScoutParseHelper.DecodePlayerEffect(self._scoutReport)
  self._hasParsedPlayer = true
end

return MailScoutReport
