local TacticalChipProductNewMessage = BaseClass("TacticalChipProductNewMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, cfgId, num)
  base.OnCreate(self)
  self.sfsObj:PutInt("cfgId", cfgId)
  self.sfsObj:PutInt("num", num)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif message ~= nil then
    local rewardMessage = {}
    rewardMessage.reward = {}
    local rewardData = {}
    rewardData.type = RewardType.TWSkillChip
    rewardData.value = {}
    rewardData.value.updates = {}
    local chipData = {}
    chipData.cfgId = message.chipId
    chipData.num = message.num
    chipData.uuid = message.uuid
    table.insert(rewardData.value.updates, chipData)
    table.insert(rewardMessage.reward, rewardData)
    DataCenter.RewardManager:ShowCommonReward(rewardMessage)
    EventManager:GetInstance():Broadcast(EventId.TacticalChipProductComplete)
  end
end

TacticalChipProductNewMessage.OnCreate = OnCreate
TacticalChipProductNewMessage.HandleMessage = HandleMessage
return TacticalChipProductNewMessage
