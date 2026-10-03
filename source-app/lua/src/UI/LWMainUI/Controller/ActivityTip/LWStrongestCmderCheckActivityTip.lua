local LWBaseCheckActivityTip = require("UI.LWMainUI.Controller.ActivityTip.LWBaseCheckActivityTip")
local LWStrongestCmderCheckActivityTip = BaseClass("LWStrongestCmderCheckActivityTip", LWBaseCheckActivityTip)
local Localization = CS.GameEntry.Localization

function LWStrongestCmderCheckActivityTip:__init()
  self.prevStrComRedPointCount = 0
end

function LWStrongestCmderCheckActivityTip:__delete()
  self.prevStrComRedPointCount = nil
end

function LWStrongestCmderCheckActivityTip:CheckIsShowTip()
  local isDataInit = true
  local tipTxt, jumpAction
  local strComActData = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.StrongestCommander.Type)
  local isStrComOn = table.IsNullOrEmpty(strComActData) == false
  if isStrComOn then
    local actData = strComActData[1]
    local rewardCount = DataCenter.StrongestCommanderDataManager:GetEventCanRewardCount()
    if rewardCount > self.prevStrComRedPointCount then
      tipTxt = Localization:GetString("2000262")
      
      function jumpAction()
        GoToUtil.GotoOpenView(UIWindowNames.UIActivityCenterTable, {anim = true}, actData.id)
      end
    end
    self.prevStrComRedPointCount = rewardCount
    local lastStageId = Setting:GetInt(SettingKeys.NEWEST_STR_COM_STAGE_ID, 0)
    local curStageId = DataCenter.StrongestCommanderDataManager:GetCurStage()
    if curStageId ~= lastStageId then
      tipTxt = Localization:GetString("2000263")
      
      function jumpAction()
        GoToUtil.GotoOpenView(UIWindowNames.UIActivityCenterTable, {anim = true}, actData.id)
      end
      
      Setting:SetInt(SettingKeys.NEWEST_STR_COM_STAGE_ID, curStageId)
    end
  end
  return isDataInit, tipTxt, jumpAction
end

return LWStrongestCmderCheckActivityTip
