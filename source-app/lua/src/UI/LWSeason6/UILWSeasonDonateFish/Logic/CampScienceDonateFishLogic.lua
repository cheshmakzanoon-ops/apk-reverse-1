local ISeasonDonateInterface = require("UI.LWSeason6.UILWSeasonDonateFish.Logic.ISeasonDonateInterface")
local CampScienceDonateFishLogic = BaseClass("CampScienceDonateFishLogic", ISeasonDonateInterface)

function CampScienceDonateFishLogic:GetProgressIcon()
  local group = DataCenter.CampScienceDataManager:GetCampScienceGroupTemplate()
  return group.icon
end

function CampScienceDonateFishLogic:GetExtraIcon()
  local militaryItemId = DataCenter.SeasonMilitaryManager:GetMilitaryItemId()
  return DataCenter.ItemTemplateManager:GetIconPath(militaryItemId)
end

function CampScienceDonateFishLogic:GetProgressInfo()
  return {
    curValue = self.data.currentPro,
    maxValue = self.data.needPro,
    max = self.data.curLevel == self.data.maxLevel,
    oo = self.data:GetIsOO()
  }
end

function CampScienceDonateFishLogic:GetDonateInfo()
  local selfCampScienceInfo = DataCenter.CampScienceDataManager:GetSelfCampScienceInfo()
  return {
    curCount = selfCampScienceInfo.num,
    maxCount = selfCampScienceInfo:GetAllDonateCount(),
    nextRecoverTime = selfCampScienceInfo.timePoint + selfCampScienceInfo:GetRefreshTime()
  }
end

function CampScienceDonateFishLogic:GetShowDonateList()
  return DataCenter.FishingDataManager:GetMyFishList(true)
end

function CampScienceDonateFishLogic:ToDonate(selectList)
  SFSNetwork.SendMessage(MsgDefines.CampScienceDonate, self.data.scienceId, self.data.curLevel, selectList, 1)
end

function CampScienceDonateFishLogic:RecoverTimeFinish()
  SFSNetwork.SendMessage(MsgDefines.CampScienceView)
end

return CampScienceDonateFishLogic
