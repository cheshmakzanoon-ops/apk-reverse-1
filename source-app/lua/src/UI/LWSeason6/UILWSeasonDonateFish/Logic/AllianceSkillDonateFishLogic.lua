local ISeasonDonateInterface = require("UI.LWSeason6.UILWSeasonDonateFish.Logic.ISeasonDonateInterface")
local AllianceSkillDonateFishLogic = BaseClass("AllianceSkillDonateFishLogic", ISeasonDonateInterface)

function AllianceSkillDonateFishLogic:GetProgressIcon()
  return self.data:GetCostIcon()
end

function AllianceSkillDonateFishLogic:GetExtraIcon()
  return "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_lianmengkejijuanxian_jifen.png"
end

function AllianceSkillDonateFishLogic:GetAllianceGGCount(selectList)
  local extraCount = 0
  local allianceOneCount = LuaEntry.DataConfig:TryGetNum("season_s6_alliance_skill_fish", "k4") or 0
  for _, count in pairs(selectList) do
    extraCount = extraCount + allianceOneCount * count
  end
  return extraCount
end

function AllianceSkillDonateFishLogic:GetProgressInfo()
  return {
    curValue = self.data.currentEnergy,
    maxValue = self.data:GetMaxEnergy(),
    max = self.data.currentEnergy == self.data:GetMaxEnergy(),
    oo = false,
    donShowTip = true
  }
end

function AllianceSkillDonateFishLogic:GetDonateInfo()
  if self.data.donateInfo == nil then
    return nil
  end
  return {
    curCount = self.data.donateInfo.num,
    maxCount = self.data.donateInfo.max,
    nextRecoverTime = self.data.donateInfo.cdEndTime
  }
end

function AllianceSkillDonateFishLogic:GetShowDonateList()
  return DataCenter.FishingDataManager:GetMyFishList(true)
end

function AllianceSkillDonateFishLogic:ToDonate(selectList)
  SFSNetwork.SendMessage(MsgDefines.AllianceSkillEnergyDonate, selectList)
end

function AllianceSkillDonateFishLogic:RecoverTimeFinish()
  SFSNetwork.SendMessage(MsgDefines.AllianceSkillEnergyGetInfo)
end

return AllianceSkillDonateFishLogic
