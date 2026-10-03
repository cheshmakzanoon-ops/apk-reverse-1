local MailDestroyRankList = BaseClass("MailDestroyRankList")
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local base64 = require("Framework.Common.base64")

function MailDestroyRankList:__init()
  self._worldCityRankMail = {}
end

function MailDestroyRankList:ParseContent(mailContent)
  if table.IsNullOrEmpty(mailContent) then
    return
  end
  local worldCityRankMail = mailContent.content or ""
  local pb_worldCityRankMail = PBController.ParsePb1(worldCityRankMail, "protobuf.WorldCityRankMail")
  self._worldCityRankMail = pb_worldCityRankMail
end

function MailDestroyRankList:GetExtData()
  return self._worldCityRankMail
end

function MailDestroyRankList:GetDes()
  local des = ""
  if self._worldCityRankMail ~= nil then
    local cityId = self._worldCityRankMail.cityId
    local cityName = self._worldCityRankMail.cityName
    local template = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId)
    if template ~= nil then
      if cityName == nil or cityName == "" then
        cityName = Localization:GetString(template.name)
      end
      local battleFightV2Pt = template.pos
      local battleFightPt = SceneUtils.TilePosToIndex(battleFightV2Pt, ForceChangeScene.World)
      local strBattlePt = " (" .. tostring(battleFightV2Pt.x) .. ", " .. tostring(battleFightV2Pt.y) .. ")"
      local link = {
        action = "Jump",
        pointId = battleFightPt,
        x = battleFightV2Pt.x,
        y = battleFightV2Pt.y
      }
      local json = rapidjson.encode(link)
      json = base64.encode(json)
      local strLink = "<link=" .. json .. "><u>" .. strBattlePt .. "</u></link>"
      local targetName = Localization:GetString("310128", template.level, cityName)
      if self._worldCityRankMail.type == DestroyRankType.Blood then
        des = Localization:GetString("110189", targetName, strLink)
      elseif self._worldCityRankMail.type == DestroyRankType.Stamina then
        des = Localization:GetString("110190", targetName, strLink)
      end
    end
  end
  return des
end

function MailDestroyRankList:GetTitle()
  local name = ""
  if self._worldCityRankMail ~= nil then
    if self._worldCityRankMail.type == DestroyRankType.Blood then
      name = Localization:GetString("110191")
    elseif self._worldCityRankMail.type == DestroyRankType.Stamina then
      name = Localization:GetString("110192")
    elseif self._worldCityRankMail.type == DestroyRankType.DestroyRank then
      name = Localization:GetString("season_mail_title_90498")
    elseif CommonUtil.IsEditor() then
      name = string.format("[Editor]\230\156\170\231\159\165\231\177\187\229\158\139\239\188\154%s (MailDestroyRankList.GetTitle)", self._worldCityRankMail.type)
    end
  end
  return name
end

return MailDestroyRankList
