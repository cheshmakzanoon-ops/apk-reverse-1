local CampScienceDonateMessage = BaseClass("CampScienceDonateMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, scienceId, viewLevel, selectList, donateType)
  base.OnCreate(self)
  self.sfsObj:PutInt("scienceId", scienceId)
  self.sfsObj:PutInt("viewLevel", viewLevel)
  self.sfsObj:PutInt("donateType", donateType)
  local arrayObjs = SFSArray.New()
  for id, count in pairs(selectList) do
    local obj = SFSObject.New()
    obj:PutInt("fishId", id)
    obj:PutInt("fishNum", count)
    arrayObjs:AddSFSObject(obj)
  end
  self.sfsObj:PutSFSArray("fishArr", arrayObjs)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.CampScienceDataManager:RepCampScienceServer(t, true)
    local campScienceInfo = t.campScienceInfo
    if campScienceInfo ~= nil then
      DataCenter.CampScienceDataManager:UpdateOneCampScience(campScienceInfo, true)
    end
    if t.reward then
      DataCenter.RewardManager:AddRewardsAndRes(t)
    end
    if t.changeFishArr then
      DataCenter.FishingDataManager:UpdateFish(t.changeFishArr)
    end
    EventManager:GetInstance():Broadcast(EventId.CampScienceDonateSuccess)
  end
end

CampScienceDonateMessage.OnCreate = OnCreate
CampScienceDonateMessage.HandleMessage = HandleMessage
return CampScienceDonateMessage
