local base = UIBaseContainer
local SeasonFactionWarMilitaryCenter = BaseClass("SeasonFactionWarMilitaryCenter", base)
local MilitaryBuild = require("UI.LWSeason3.UILWFactionWar.Component.SeasonFactionWarMilitaryBuild")
local MilitaryBuildPopup = require("UI.LWSeason3.UILWFactionWar.Component.SeasonFactionWarMilitaryBuildPopup")
local name_path = "name"
local key2_path = "InfoList/bg2/key2"
local value2_path = "InfoList/bg2/value2"
local res_full_title_path = "InfoList/bg5/res_full_title"
local res_full_path = "InfoList/bg5/res_full"
local res_war_title_path = "InfoList/bg7/res_war_title"
local res_war_path = "InfoList/bg7/res_war"
local build_path = "Build"
local build1_path = "Build1"
local build2_path = "Build2"
local build3_path = "Build3"
local build4_path = "Build4"
local attack_info_path = "AttackInfo"

function SeasonFactionWarMilitaryCenter:OnCreate()
  base.OnCreate(self)
  self.name = self:AddComponent(UITextMeshProUGUIEx, name_path)
  self.key2 = self:AddComponent(UITextMeshProUGUIEx, key2_path)
  self.value2 = self:AddComponent(UITextMeshProUGUIEx, value2_path)
  self.res_full_title = self:AddComponent(UITextMeshProUGUIEx, res_full_title_path)
  self.res_full = self:AddComponent(UITextMeshProUGUIEx, res_full_path)
  self.res_war_title = self:AddComponent(UITextMeshProUGUIEx, res_war_title_path)
  self.res_war = self:AddComponent(UITextMeshProUGUIEx, res_war_path)
  self.build = self:AddComponent(MilitaryBuild, build_path)
  self.build1 = self:AddComponent(MilitaryBuild, build1_path)
  self.build2 = self:AddComponent(MilitaryBuild, build2_path)
  self.build3 = self:AddComponent(MilitaryBuild, build3_path)
  self.build4 = self:AddComponent(MilitaryBuild, build4_path)
  self.attack_info = self:AddComponent(MilitaryBuildPopup, attack_info_path)
  self.attack_info:SetActive(false)
end

function SeasonFactionWarMilitaryCenter:OnDestroy()
  self.name = nil
  self.key2 = nil
  self.value2 = nil
  self.res_full_title = nil
  self.res_full = nil
  self.res_war_title = nil
  self.res_war = nil
  self.build = nil
  self.build1 = nil
  self.build2 = nil
  self.build3 = nil
  self.build4 = nil
  self.attack_info = nil
  base.OnDestroy(self)
end

function SeasonFactionWarMilitaryCenter:UpdateResChangeInfo(alResChangeInfo)
  if alResChangeInfo and self.res_war then
    local alResChange = 0
    for k, v in pairs(alResChangeInfo) do
      if 0 > toInt(v) then
        alResChange = alResChange + toInt(v)
      end
    end
    if alResChange < 0 then
      self.res_war:SetText("<color=#FF7373>" .. string.GetFormattedStr(alResChange) .. "</color>")
    end
  end
end

function SeasonFactionWarMilitaryCenter:ReInit(vsInfo, data, furnaceChangeInfo, s3lootNumChangeObj, fightResult)
  self.data = data
  self.vsInfo = vsInfo
  self.furnaceChangeInfo = furnaceChangeInfo
  self.s3lootNumChangeObj = s3lootNumChangeObj
  self.fightResult = fightResult
  local s2_faction_war_k8 = LuaEntry.DataConfig:TryGetNum("s3_faction_war", "k8", 2000)
  if s2_faction_war_k8 <= 0 then
    s2_faction_war_k8 = 2000
  end
  local resourceNum = toInt(data.resourceNum)
  local canRobNum = toInt(data.canRobNum)
  if data.pointId then
    local link = {
      action = "Jump",
      pointId = data.pointId,
      server = data.buildServerId or data.allianceServer,
      worldId = 0
    }
    self.linkInfo = link
  end
  if data and data.abbr then
    self.name:SetText(UIUtil.FormatServerAllianceName(data.allianceServer, data.abbr, data.allianceName))
  else
    self.name:SetText("")
  end
  self.key2:SetLocalText("activity_berserkboss_title_08")
  self.value2:SetText(data.rank or "100+")
  self.res_full_title:SetLocalText("season_s2_faction_war_52")
  self.res_full:SetText(string.GetFormattedStr(resourceNum))
  local ratio = DataCenter.SeasonFactionWarDataManager:GetPlunderRatio()
  if data and data.buildList then
    local actData = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.SeasonFactionDeclareWarActivityMummy.Type)
    if actData and actData.para_3 then
      local mainBuildId = SeasonUtil.GetSeasonMilitaryCenterId()
      local num1, num2 = string.split_ii(actData.para_3)
      ratio = toInt(num1)
      for k, v in pairs(data.buildList) do
        if v and v.buildId ~= mainBuildId then
          ratio = ratio + toInt(num2)
        end
      end
      ratio = ratio / 100
    end
  end
  self.res_war_title:SetLocalText("season_s3_activity_1000064_desc01")
  if canRobNum <= 0 then
    self.res_war:SetText(string.GetFormattedStr(resourceNum * ratio))
  else
    self.res_war:SetText(string.GetFormattedStr(canRobNum))
  end
  self.build:ReInit(self, BuildingTypes.SEASON_MUMMY_CENTER, data, s3lootNumChangeObj, fightResult)
  self.build1:ReInit(self, BuildingTypes.SEASON_MUMMY_CENTER_PLUGIN_YLC, data, s3lootNumChangeObj, fightResult)
  self.build2:ReInit(self, BuildingTypes.SEASON_MUMMY_CENTER_PLUGIN_KTT, data, s3lootNumChangeObj, fightResult)
  self.build3:ReInit(self, BuildingTypes.SEASON_MUMMY_CENTER_PLUGIN_JS, data, s3lootNumChangeObj, fightResult)
  self.build4:ReInit(self, BuildingTypes.SEASON_MUMMY_CENTER_PLUGIN_SB, data, s3lootNumChangeObj, fightResult)
  if furnaceChangeInfo then
    if furnaceChangeInfo.newRank and furnaceChangeInfo.newRank < data.rank then
      local strRank = string.format("%s<color=#FF7373>(%s-%s)</color>", furnaceChangeInfo.newRank, data.rank, data.rank - furnaceChangeInfo.newRank)
      self.value2:SetText(strRank)
    end
    local newResourceNum = toInt(furnaceChangeInfo.newResourceNum)
    local oldResourceNum = toInt(data.resourceNum)
    if newResourceNum < oldResourceNum then
      local strRes = string.format("%s<color=#FF7373>(%s-%s)</color>", string.GetFormattedStr(newResourceNum), string.GetFormattedStr(oldResourceNum), string.GetFormattedStr(oldResourceNum - newResourceNum))
      self.res_full:SetText(strRes)
      self.res_war:SetText("<color=#FF7373>-" .. string.GetFormattedStr(oldResourceNum - newResourceNum) .. "</color>")
    elseif self.fightResult == 1 then
      self.res_war:SetLocalText("season_s2_faction_war_74")
    end
  end
end

function SeasonFactionWarMilitaryCenter:OnBuildClick(build, lootNumChangeList, scoreList, buildData)
  if build and buildData and lootNumChangeList then
    if scoreList == nil or table.count(scoreList) == 0 then
      UIUtil.ShowTipsId("season_s2_faction_war_tips_04")
      return
    end
    local x, y, z = build:GetLocalPositionXYZ()
    if 50 < x then
      x = 128
    elseif x < -50 then
      x = -128
    end
    self.attack_info:ShowIt(x, y, lootNumChangeList, scoreList, buildData)
  end
end

return SeasonFactionWarMilitaryCenter
