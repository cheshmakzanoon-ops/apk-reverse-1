local repaidJson = require("rapidjson")
local MailBreakIceReport = BaseClass("MailBreakIceReport")
local MailScoutParseHelper = require("DataCenter.MailData.MailScoutParseHelper")

function MailBreakIceReport:__init()
end

function MailBreakIceReport:ParseContent(mailContent)
  if table.IsNullOrEmpty(mailContent) then
    return
  end
  self.dmg = mailContent.dmg
  self.pointId = mailContent.pointId
  self.targetUser = mailContent.targetUser
  self.user = mailContent.user
  self.pos = SceneUtils.IndexToTilePos(self.pointId, ForceChangeScene.World)
end

function MailBreakIceReport:IsPassive()
  return self.targetUser.uid == LuaEntry.Player.uid
end

function MailBreakIceReport:IsEnemy()
  if self:IsPassive() and (self.user.abbr ~= self.targetUser.abbr or self.user.abbr == "") then
    return true
  end
  return false
end

function MailBreakIceReport:GetOtherFullName()
  if self:IsPassive() then
    return UIUtil.FormatServerAllianceName(nil, self.user.abbr, self.user.name)
  end
  return UIUtil.FormatServerAllianceName(nil, self.targetUser.abbr, self.targetUser.name)
end

return MailBreakIceReport
