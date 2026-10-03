local MailDestroyBuild = BaseClass("MailDestroyBuild")
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local base64 = require("Framework.Common.base64")

function MailDestroyBuild:__init()
  self._destroyReport = {}
end

function MailDestroyBuild:ParseContent(mailContent)
  if table.IsNullOrEmpty(mailContent) then
    return
  end
  local destroyReport = mailContent.content or ""
  local pb_DestroyReport = PBController.ParsePb1(destroyReport, "protobuf.DestroyMail")
  self._destroyReport = pb_DestroyReport
end

function MailDestroyBuild:GetExtData()
  return self._destroyReport
end

function MailDestroyBuild:GetBattleFightPt()
  return self._destroyReport.pointId or 0
end

function MailDestroyBuild:GetBattleFightServerId()
  return self._destroyReport.serverId or 0
end

function MailDestroyBuild:GetTargetName()
  local targetName = ""
  if self._destroyReport ~= nil then
    local targetType = self._destroyReport.destroyUnitInfo.type
    local buildId = self._destroyReport.destroyUnitInfo.itemId
    local level = self._destroyReport.destroyUnitInfo.level
    if targetType == BattleType.Building or targetType == BattleType.City then
      local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
      if template ~= nil then
        targetName = Localization:GetString("310128", level, Localization:GetString(template.name))
      end
    elseif targetType == BattleType.ALLIANCE_NEUTRAL_CITY or targetType == BattleType.ALLIANCE_OCCUPIED_CITY then
      local template = DataCenter.AllianceCityTemplateManager:GetTemplate(buildId)
      if template ~= nil then
        targetName = Localization:GetString("310128", template.level, Localization:GetString(template.name))
      end
    elseif targetType == BattleType.Road then
      targetName = Localization:GetString("100308")
    end
  end
  return targetName
end

function MailDestroyBuild:GetOwnerName()
  local ownerName = ""
  if self._destroyReport ~= nil then
    local targetType = self._destroyReport.destroyUnitInfo.type
    if targetType == BattleType.Building or targetType == BattleType.City or targetType == BattleType.Road then
      if self._destroyReport.destroyPlayerInfo ~= nil then
        local playerName = self._destroyReport.destroyPlayerInfo.name
        local allianceInfo = self._destroyReport.destroyPlayerInfo.allianceInfo
        if allianceInfo ~= nil and allianceInfo.alAbbr ~= nil then
          ownerName = "[" .. allianceInfo.alAbbr .. "] " .. playerName
        else
          ownerName = playerName
        end
      end
    elseif targetType == BattleType.ALLIANCE_OCCUPIED_CITY then
      local allianceInfo = self._destroyReport.allianceInfo
      if allianceInfo ~= nil and allianceInfo.alAbbr ~= nil then
        ownerName = "[" .. allianceInfo.alAbbr .. "] " .. allianceInfo.alName
      end
    elseif targetType == BattleType.ALLIANCE_NEUTRAL_CITY then
      ownerName = Localization:GetString("300733")
    end
  end
  return ownerName
end

function MailDestroyBuild:GetTargetIcon()
  local targetIcon = ""
  if self._destroyReport ~= nil then
    local targetType = self._destroyReport.destroyUnitInfo.type
    local buildId = self._destroyReport.destroyUnitInfo.itemId
    local level = self._destroyReport.destroyUnitInfo.level
    if targetType == BattleType.Building or targetType == BattleType.City then
      targetIcon = DataCenter.BuildManager:GetBuildIconPath(buildId, level)
    elseif targetType == BattleType.ALLIANCE_NEUTRAL_CITY or targetType == BattleType.ALLIANCE_OCCUPIED_CITY then
      local template = DataCenter.AllianceCityTemplateManager:GetTemplate(buildId)
      if template ~= nil then
        targetIcon = "Assets/Main/Sprites/BuildIconOutCity/alliance_city.png"
      end
    elseif targetType == BattleType.Road then
      targetIcon = "Assets/Main/Sprites/UI/UIBuild/UIBuild_build_road.png"
    end
  end
  return targetIcon
end

function MailDestroyBuild:GetSummary(withoutlink)
  local battleFightPt = self:GetBattleFightPt()
  local battleServerId = self:GetBattleFightServerId()
  local battleFightV2Pt = SceneUtils.IndexToTilePos(battleFightPt, ForceChangeScene.World)
  local strBattlePt = " (" .. tostring(battleFightV2Pt.x) .. ", " .. tostring(battleFightV2Pt.y) .. ")"
  local link = {
    action = "Jump",
    pointId = battleFightPt,
    server = battleServerId
  }
  local json = rapidjson.encode(link)
  json = base64.encode(json)
  local strLink = "<link=" .. json .. "><u>" .. strBattlePt .. "</u></link>"
  if withoutlink then
    strLink = ""
  end
  local name = ""
  if self._destroyReport ~= nil then
    local targetName = self:GetTargetName()
    local ownerName = self:GetOwnerName()
    if self._destroyReport.type == DestroyBuildType.Self then
      name = Localization:GetString("311114", ownerName, targetName)
    elseif self._destroyReport.type == DestroyBuildType.Other then
      name = Localization:GetString("311115", targetName, ownerName)
    end
  end
  return name .. strLink
end

function MailDestroyBuild:GetName()
  local name = ""
  if self._destroyReport ~= nil then
    local targetName = self:GetTargetName()
    local ownerName = self:GetOwnerName()
    if self._destroyReport.type == DestroyBuildType.Self then
      name = Localization:GetString("311114", ownerName, targetName)
    elseif self._destroyReport.type == DestroyBuildType.Other then
      name = Localization:GetString("311136", targetName, ownerName)
    end
  end
  return name
end

function MailDestroyBuild:GetTitle()
  local name = ""
  if self._destroyReport ~= nil then
    if self._destroyReport.type == DestroyBuildType.Self then
      name = Localization:GetString("311112")
    elseif self._destroyReport.type == DestroyBuildType.Other then
      name = Localization:GetString("311113")
    end
  end
  return name
end

function MailDestroyBuild:GetBattleWin()
  if self._destroyReport ~= nil then
    if self._destroyReport.type == DestroyBuildType.Self then
      return true
    elseif self._destroyReport.type == DestroyBuildType.Other then
      return false
    end
  end
  return false
end

return MailDestroyBuild
