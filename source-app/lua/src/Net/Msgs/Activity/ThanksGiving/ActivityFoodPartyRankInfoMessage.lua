local ActivityFoodPartyRankInfoMessage = BaseClass("ActivityFoodPartyRankInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, param)
  base.OnCreate(self)
  if param then
    self.sfsObj:PutInt("aid", param.aid)
    self.sfsObj:PutInt("id", param.id)
    self.sfsObj:PutInt("type", param.type)
    self.sfsObj:PutInt("start", param.startN)
    self.sfsObj:PutInt("end", param.endN)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActBanquetData:ParseRankingData(t)
  end
end

ActivityFoodPartyRankInfoMessage.OnCreate = OnCreate
ActivityFoodPartyRankInfoMessage.HandleMessage = HandleMessage
return ActivityFoodPartyRankInfoMessage
