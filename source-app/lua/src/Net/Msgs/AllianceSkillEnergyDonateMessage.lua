local AllianceSkillEnergyDonateMessage = BaseClass("AllianceSkillEnergyDonateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceSkillEnergyDonateMessage:OnCreate(selectList)
  base.OnCreate(self)
  local arrayObjs = SFSArray.New()
  for id, count in pairs(selectList) do
    local obj = SFSObject.New()
    obj:PutInt("fishId", id)
    obj:PutInt("count", count)
    arrayObjs:AddSFSObject(obj)
  end
  self.sfsObj:PutSFSArray("fishList", arrayObjs)
end

function AllianceSkillEnergyDonateMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local contributionInfo = t.contributionInfo
    if contributionInfo ~= nil then
      DataCenter.AllianceBaseDataManager:UpdateAccPoint(contributionInfo.accPoint)
    end
    if t.fishInfo then
      DataCenter.FishingDataManager:HandleMyFishList(t.fishInfo)
    end
    DataCenter.AllianceGovernmentCommonSkillManager:ReqSkillEnergyGetInfo(t)
    EventManager:GetInstance():Broadcast(EventId.AllianceEnergyDonateSuccess)
  end
end

return AllianceSkillEnergyDonateMessage
