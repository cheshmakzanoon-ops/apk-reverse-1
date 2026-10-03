local BattleReportShareHelper = {}

local function ActWorldBossBattleRecordCallBack(openType)
  if openType == UIMailOpenType.History then
    local bossLoginDataList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.BossLogin.Type)
    if table.count(bossLoginDataList) ~= 0 then
      SeasonUtil.OpenSeasonMain(true)
      SeasonUtil.OpenSeasonActivity(bossLoginDataList[1])
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWSeasonBossLoginRecord, {anim = true})
      return
    end
    local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.WorldBoss.Type)
    if table.count(dataList) == 0 then
      UIUtil.ShowTipsId(458822)
      return
    end
    local data = dataList[1]
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityCenterTable, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, tonumber(data.id))
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIWorldBossRecord, {anim = true})
  end
end

local ConvertBattleReportToVirtualMail = {
  [BattleReportPreviewEnterType.ActWorldBossBattleRecord] = {isShowSharedButton = true, callBackAfterCloseMailUI = ActWorldBossBattleRecordCallBack},
  [BattleReportPreviewEnterType.NewBattleReportChatShare] = {isShowSharedButton = false, callBackAfterCloseMailUI = nil}
}

local function HasData(enterType)
  return ConvertBattleReportToVirtualMail[enterType] ~= nil
end

local function GetData(enterType)
  local data = ConvertBattleReportToVirtualMail[enterType]
  if data == nil then
    Logger.LogError(string.format("\230\151\160\230\149\136\231\154\132BattleReportPreviewEnterType: %s", tostring(enterType)))
  end
  return data
end

BattleReportShareHelper.HasData = HasData
BattleReportShareHelper.GetData = GetData
return BattleReportShareHelper
