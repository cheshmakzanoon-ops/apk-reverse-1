local UIDecorationPreviewCtrl = BaseClass("UIDecorationPreviewCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting

local function CloseSelf(self, backToActivity)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDecorationPreview)
end

local function GetShowData(self, decorationId)
end

local function IsSpecialPeriod()
  local infoPlayer = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  if not infoPlayer then
    return false
  end
  local wait = infoPlayer and infoPlayer:ClientInReady() and not infoPlayer:ServerInReady()
  if wait then
    return true
  else
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if infoPlayer.nextSeasonPreviewTime and infoPlayer.nextSeasonStartTime and curTime > infoPlayer.nextSeasonPreviewTime and curTime < infoPlayer.nextSeasonStartTime then
      return true
    end
  end
  return false
end

local function IfShowSeasonSwitch(self, goodId, decorationId)
  local colorDecorationId = 0
  local activityOpen = false
  local isSpecialPeriod = false
  local seasonConfig = DataCenter.SeasonCallbackManager:GetConfigDataByCallbackId(SeasonCallbackType.Base, decorationId, nil, true)
  if not seasonConfig then
    if self:IsSpecialPeriod() then
      isSpecialPeriod = true
    else
      return false, colorDecorationId
    end
  end
  activityOpen = seasonConfig and seasonConfig:IsOpen() or false
  if not goodId then
    return false, colorDecorationId
  end
  local goodData = DataCenter.ItemTemplateManager:GetItemTemplate(goodId)
  if not goodData or string.IsNullOrEmpty(goodData.para6) then
    return false, colorDecorationId
  end
  local arr = string.split(goodData.para6, "|")
  if not arr then
    return false, colorDecorationId
  end
  local seasonInfo = arr[1]
  if seasonInfo == nil or type(seasonInfo) ~= "string" then
    return false, colorDecorationId
  end
  local season = string.split(seasonInfo, "-")
  if #season == 2 then
    local beginSeason = tonumber(season[1])
    local endSeason = tonumber(season[2])
    local curSeason = SeasonUtil.GetSeason()
    if curSeason then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local infoPlayer = DataCenter.SeasonDataManager:GetUserSeasonInfo()
      if not infoPlayer then
        return false, colorDecorationId
      end
      local inS1Prewarm = infoPlayer.nextSeasonId and infoPlayer.nextSeasonPreviewTime and infoPlayer.nextSeasonId == 1 and curTime > infoPlayer.nextSeasonPreviewTime
      local inBeginSeasonEndStage = curSeason == beginSeason and infoPlayer.seasonEndTime and curTime > infoPlayer.seasonEndTime
      local inEndSeasonBeforeSettleStage = curSeason == endSeason and infoPlayer.seasonSettleTime and curTime < infoPlayer.seasonSettleTime
      local inDuringStage = beginSeason < curSeason and endSeason > curSeason
      if inS1Prewarm and curSeason == beginSeason or inBeginSeasonEndStage or inEndSeasonBeforeSettleStage or inDuringStage then
        local dazzleInfo = DataCenter.DecorationDazzleManager:GetDazzleSkinTemplateFirst(decorationId)
        if dazzleInfo and dazzleInfo.id then
          colorDecorationId = tonumber(dazzleInfo.id)
          return true, colorDecorationId, activityOpen, isSpecialPeriod
        end
      end
    end
  end
  return false, colorDecorationId
end

local function IfShowSeasonContent()
  return Setting:GetPrivateBool(SettingKeys.DecorationPreview_ShowSeasonNode, false)
end

local function SetSeasonContentShow(self, show)
  Setting:SetPrivateBool(SettingKeys.DecorationPreview_ShowSeasonNode, show)
end

local function GetCallBackInfoByDecorationId(self, decorationId)
  if not decorationId or not tonumber(decorationId) then
    return
  end
  local seasonData
  decorationId = tonumber(decorationId)
  LocalController:instance():visitTable(TableName.SeasonCallback, function(id, lineData)
    if lineData ~= nil then
      local decorationConfigId = tonumber(lineData:getValue("callback_id")) or 0
      if decorationConfigId == decorationId then
        local SeasonCallbackData = require("DataCenter.SeasonCallback.SeasonCallbackData")
        seasonData = SeasonCallbackData.New(lineData)
      end
    end
  end)
  return seasonData
end

UIDecorationPreviewCtrl.CloseSelf = CloseSelf
UIDecorationPreviewCtrl.GetShowData = GetShowData
UIDecorationPreviewCtrl.IfShowSeasonSwitch = IfShowSeasonSwitch
UIDecorationPreviewCtrl.IfShowSeasonContent = IfShowSeasonContent
UIDecorationPreviewCtrl.SetSeasonContentShow = SetSeasonContentShow
UIDecorationPreviewCtrl.IsSpecialPeriod = IsSpecialPeriod
UIDecorationPreviewCtrl.GetCallBackInfoByDecorationId = GetCallBackInfoByDecorationId
return UIDecorationPreviewCtrl
