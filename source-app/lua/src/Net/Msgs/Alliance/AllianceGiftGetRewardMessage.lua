local AllianceGiftGetRewardMessage = BaseClass("AllianceGiftGetRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uuid, type)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("uuid", uuid)
  self.sfsObj:PutInt("type", type)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.receiveResult ~= nil then
    local receiveResult = t.receiveResult
    local type = t.type
    if receiveResult == 1 then
      if t.next then
        DataCenter.AllianceGiftDataManager:UpdateOneGiftInfo(t.next, type)
      end
      if t.redPoint and type then
        DataCenter.AllianceGiftDataManager:SetRedPointNum(type, t.redPoint)
      end
      if t.uuid ~= nil then
        local uuid = t.uuid
        if t.receiveTime and type then
          DataCenter.AllianceGiftDataManager:SetGiftReceive(uuid, type, t.receiveTime)
        end
        DataCenter.AllianceGiftDataManager:RetBaseData(t)
        if t.allianceNewMail ~= nil then
          DataCenter.AllianceGiftDataManager:UpdateGiftNum(t.allianceNewMail)
          EventManager:GetInstance():Broadcast(EventId.UpdateAllianceGiftNum)
        end
      end
      if t.info ~= nil then
        local list = t.info
        local tempMsg = {}
        tempMsg.reward = {}
        table.walk(list, function(k, v)
          if v.type == 11 then
            local addScore = v.value
            local accPoint = DataCenter.AllianceShopDataManager:GetAccPoint()
            DataCenter.AllianceShopDataManager:SetAccPoint(accPoint + addScore)
          end
          table.insert(tempMsg.reward, v)
        end)
      end
      EventManager:GetInstance():Broadcast(EventId.GetOneAllianceGift)
    end
  end
end

AllianceGiftGetRewardMessage.OnCreate = OnCreate
AllianceGiftGetRewardMessage.HandleMessage = HandleMessage
return AllianceGiftGetRewardMessage
