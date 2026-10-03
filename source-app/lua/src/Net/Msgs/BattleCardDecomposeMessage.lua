local BattleCardDecomposeMessage = BaseClass("BattleCardDecomposeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BattleCardDecomposeMessage:OnCreate(params)
  base.OnCreate(self)
  local array = SFSArray.New()
  table.walk(params, function(k, v)
    array:AddLong(v)
  end)
  self.sfsObj:PutSFSArray("uuids", array)
end

function BattleCardDecomposeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if not table.IsNullOrEmpty(t.retResourceItem) then
      local msg = {}
      msg.reward = {}
      for _, v in pairs(t.retResourceItem) do
        local reward = {}
        reward.value = {}
        reward.value.id = v.id
        reward.value.count = v.num
        reward.type = RewardType.RESOURCE_ITEM
        table.insert(msg.reward, reward)
      end
      DataCenter.RewardManager:ShowCommonReward(msg)
    end
    if t.uuids then
      for _, v in ipairs(t.uuids) do
        DataCenter.TacticalCardDataManager:RemoveOneCard(v)
      end
      EventManager:GetInstance():Broadcast(EventId.TCCardSalvageSuccess)
    end
  end
end

return BattleCardDecomposeMessage
