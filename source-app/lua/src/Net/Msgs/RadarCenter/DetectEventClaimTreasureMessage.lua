local DetectEventClaimTreasureMessage = BaseClass("DetectEventClaimTreasureMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uuid, targetServer, worldTreasureType)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  if targetServer == nil then
    targetServer = LuaEntry.Player:GetSourceServerId()
  end
  self.sfsObj:PutInt("targetServer", targetServer)
  if worldTreasureType then
    self.sfsObj:PutInt("type", worldTreasureType)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if t.errorPara2 then
      UIUtil.ShowTips(Localization:GetString(errCode, table.unpack(t.errorPara2)))
    else
      UIUtil.ShowTipsId(errCode)
    end
  else
    if t.reward ~= nil then
      if t.hasLuckSiphonbuff ~= nil and t.hasLuckSiphonbuff then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIGetLuckyBuffPopup, {anim = true}, {treasureData = t, type = 2})
        DataCenter.RewardManager:AddRewardsAndRes(t)
      else
        DataCenter.RewardManager:ShowCommonReward(t)
        DataCenter.RewardManager:AddRewardsAndRes(t)
      end
    end
    DataCenter.ActDetectTreasureDataManager:OnGetDigTimesMsg(t)
    local seasonType = SeasonUtil.GetSeasonType()
    if seasonType == SeasonMapType.NineNation or seasonType == SeasonMapType.Darkness or seasonType == SeasonMapType.NineNation then
      SFSNetwork.SendMessage(MsgDefines.FetchUserCardBoxList)
    end
    if FlowerTrainUtils.IsFlowerTrainLvBoxReward(t) then
      DataCenter.FlowerTrainDataManager:OnClaimLvBoxReward()
    end
  end
end

DetectEventClaimTreasureMessage.OnCreate = OnCreate
DetectEventClaimTreasureMessage.HandleMessage = HandleMessage
return DetectEventClaimTreasureMessage
