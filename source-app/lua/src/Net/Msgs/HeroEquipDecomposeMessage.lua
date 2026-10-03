local HeroEquipDecomposeMessage = BaseClass("HeroEquipDecomposeMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, equipUuids)
  base.OnCreate(self)
  if table.IsNullOrEmpty(equipUuids) then
    return
  end
  self.sfsObj:PutLongArray("ids", equipUuids)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  if not table.IsNullOrEmpty(message.retResourceItem) then
    local msg = {}
    msg.reward = {}
    for _, v in pairs(message.retResourceItem) do
      local reward = {}
      reward.value = {}
      reward.value.id = v.id
      reward.value.count = v.num
      reward.type = RewardType.RESOURCE_ITEM
      table.insert(msg.reward, reward)
    end
    DataCenter.RewardManager:ShowCommonReward(msg)
  end
  EventManager:GetInstance():Broadcast(EventId.EquipDecompose)
end

HeroEquipDecomposeMessage.OnCreate = OnCreate
HeroEquipDecomposeMessage.HandleMessage = HandleMessage
return HeroEquipDecomposeMessage
