local UIGolloesCampCtrl = BaseClass("UIGolloesCampCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIGolloesCamp, {anim = true})
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

local function OpenMonthCardPanel(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackage, {anim = true}, {
    welfareTagType = WelfareTagType.MonthCard
  })
  self:CloseSelf()
end

local function ClaimDailyRewards(self, mcId)
  SFSNetwork.SendMessage(MsgDefines.ClaimGolloesDailyReward, mcId)
end

local function ClaimFreeRewards(self)
  SFSNetwork.SendMessage(MsgDefines.ClaimGolloesFreeReward)
end

local function GetExploreEndTime(self)
  local endT = DataCenter.GolloesCampManager:GetGolloesMarchEndTime(GolloesType.Explorer)
  return endT
end

local function GetTraderEndTime(self)
  local endT = DataCenter.GolloesCampManager:GetGolloesMarchEndTime(GolloesType.Trader)
  return endT
end

local function GetGolloesWarriorBuffEndTime(self)
  local strEffId = LuaEntry.DataConfig:TryGetStr("golloes_dispatch_para", "k10")
  local effIdTb = string.split(strEffId, ";")
  if 0 < #effIdTb then
    local tempId = tonumber(effIdTb[1])
    local timeInfo = DataCenter.StatusManager:GetBuffTimeInfo(tempId)
    if timeInfo then
      return timeInfo.endTime
    end
  end
  return -1
end

local function ActiveGolloesFunc(self, golloesType)
  if golloesType == GolloesType.Worker then
    SFSNetwork.SendMessage(MsgDefines.ActiveGolloesFunc, 1)
    DataCenter.LWSoundManager:PlaySound(GolloesSound[GolloesType.Worker], false)
    UIUtil.ShowTipsId(320329)
  elseif golloesType == GolloesType.Warrior then
    SFSNetwork.SendMessage(MsgDefines.ActiveGolloesFunc, 2)
    DataCenter.LWSoundManager:PlaySound(GolloesSound[GolloesType.Warrior], false)
    UIUtil.ShowTipsId(320332)
  elseif golloesType == GolloesType.Explorer then
    self:TryExplore()
  elseif golloesType == GolloesType.Trader then
    if not LuaEntry.Player:IsInAlliance() then
      UIUtil.ShowTipsId(390536)
      return
    end
    local canSend, formationInfo = DataCenter.GolloesCampManager:GetFreeFormationByGolloesType(GolloesType.Trader)
    if canSend and formationInfo then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceMemberDetail, {
        anim = true,
        back = {
          ui = UIWindowNames.UIGolloesCamp,
          anim = true
        }
      }, LuaEntry.Player.allianceId, AllianceMemberOpenType.GolloesTrande)
    else
      UIUtil.ShowTipsId(320334)
    end
  end
end

local function MilliSecondToFmtString(self, ms)
  local secs, delta = math.modf(ms / 1000)
  if 0 < delta then
    secs = secs + 1
  end
  local temp = ""
  local hour = math.modf(secs / 3600)
  local minute = math.modf(secs / 60) % 60
  local second = math.floor(secs % 60)
  return string.format("%d:%02d:%02d", hour, minute, second)
end

local function TryExplore(self)
  local canSend, formation = DataCenter.GolloesCampManager:GetFreeFormationByGolloesType(GolloesType.Explorer)
  if canSend and formation then
    DataCenter.LWSoundManager:PlaySound(GolloesSound[GolloesType.Explorer], false)
    self:StartExplore(0, formation.uuid)
    UIUtil.ShowTipsId(320330)
  else
    UIUtil.ShowTipsId(320333)
  end
end

local function StartExplore(self, pointId, formationUuid)
  local marchTargetType = MarchTargetType.GOLLOES_EXPLORE
  local sfsObj = SFSObject.New()
  sfsObj:PutLong("uuid", formationUuid)
  local formationArray = SFSArray.New()
  sfsObj:PutSFSArray("formations", formationArray)
  local heroArray = SFSArray.New()
  sfsObj:PutSFSArray("heroInfos", heroArray)
  local dataObj = sfsObj
  local startPoint = LuaEntry.Player:GetMainWorldPos()
  local targetUuid = DataCenter.GuideManager:InGuide() and 1 or 0
  MarchUtil.StartMarch(marchTargetType, pointId, targetUuid, -1, 0, formationUuid, 1, dataObj, startPoint)
end

local function GetRandomPoint(self)
  return 0
end

local function JumpToGolloesTroop(self, golloesType)
  local worldMarch, formationInfo = DataCenter.GolloesCampManager:GetGolloesMarchByType(golloesType)
  if worldMarch then
    CS.SceneManager.World:TrackMarch(worldMarch.uuid)
    WorldMarchTileUIManager:GetInstance():ShowTroop(worldMarch.uuid)
    self:CloseSelf()
  end
end

UIGolloesCampCtrl.CloseSelf = CloseSelf
UIGolloesCampCtrl.Close = Close
UIGolloesCampCtrl.OpenMonthCardPanel = OpenMonthCardPanel
UIGolloesCampCtrl.ClaimDailyRewards = ClaimDailyRewards
UIGolloesCampCtrl.GetExploreEndTime = GetExploreEndTime
UIGolloesCampCtrl.GetTraderEndTime = GetTraderEndTime
UIGolloesCampCtrl.GetGolloesWarriorBuffEndTime = GetGolloesWarriorBuffEndTime
UIGolloesCampCtrl.ActiveGolloesFunc = ActiveGolloesFunc
UIGolloesCampCtrl.StartExplore = StartExplore
UIGolloesCampCtrl.TryExplore = TryExplore
UIGolloesCampCtrl.GetRandomPoint = GetRandomPoint
UIGolloesCampCtrl.JumpToGolloesTroop = JumpToGolloesTroop
UIGolloesCampCtrl.MilliSecondToFmtString = MilliSecondToFmtString
UIGolloesCampCtrl.ClaimFreeRewards = ClaimFreeRewards
return UIGolloesCampCtrl
