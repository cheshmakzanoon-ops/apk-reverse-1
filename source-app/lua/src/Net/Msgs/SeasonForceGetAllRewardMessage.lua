local SeasonForceGetAllRewardMessage = BaseClass("SeasonForceGetAllRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if message.forceRewardArr ~= nil then
      DataCenter.DesertDataManager:RefreshForceReward(message.forceRewardArr)
    end
    local actPass
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local actListData = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.SeasonPass.Type)
    if actListData and next(actListData) then
      for i = 1, table.count(actListData) do
        local actData = DataCenter.SeasonPassManager:GetSeasonPassInfo(tonumber(actListData[i].id))
        if actData and next(actData) and actData.battlePass.unlock == 0 then
          actPass = actListData[i]
        end
      end
      if actPass then
        local k1 = LuaEntry.DataConfig:TryGetStr("gift_config", "k1")
        local seasonId = DataCenter.SeasonDataManager:GetSeasonId()
        if curTime - actPass.startTime > tonumber(k1) * OneDayTime * 1000 then
          local str = Setting:GetString(SettingKeys.SEASON_FORCE_REWARD .. LuaEntry.Player.uid .. seasonId, "")
          if str == "" or curTime - tonumber(str) > tonumber(k1) * OneDayTime * 1000 then
            DataCenter.RewardManager:SetCloseViewName(UIWindowNames.UISeasonPassGiftPackagePopUp, tonumber(actPass.id))
          end
        end
        Setting:SetString(SettingKeys.SEASON_FORCE_REWARD .. LuaEntry.Player.uid .. seasonId, curTime)
      end
    end
    if message.reward ~= nil then
      DataCenter.RewardManager:ShowCommonReward(message, nil, nil)
      for k, v in pairs(message.reward) do
        DataCenter.RewardManager:AddOneReward(v)
      end
    end
    SFSNetwork.SendMessage(MsgDefines.SeasonForceReward)
  end
end

SeasonForceGetAllRewardMessage.OnCreate = OnCreate
SeasonForceGetAllRewardMessage.HandleMessage = HandleMessage
return SeasonForceGetAllRewardMessage
