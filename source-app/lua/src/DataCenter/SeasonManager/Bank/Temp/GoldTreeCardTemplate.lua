local GoldTreeCardTemplate = BaseClass("GoldTreeCardTemplate")

local function __init(self)
  self.id = 0
  self.type = 0
  self.name = ""
  self.icon = ""
  self.rewardId = ""
end

local function __delete(self)
  self.id = 0
  self.type = 0
  self.name = ""
  self.icon = ""
  self.rewardId = ""
end

function GoldTreeCardTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.type = tonumber(row:getValue("type")) or 0
  self.name = row:getValue("name") or ""
  self.icon = row:getValue("icon") or ""
  self.rewardId = row:getValue("reward_id") or ""
end

function GoldTreeCardTemplate:GetFirstReward()
  if string.IsNullOrEmpty(self.rewardId) then
    return nil
  end
  local rewardList = DataCenter.RewardTemplateManager:GetList(self.rewardId)
  return rewardList and rewardList[1] or nil
end

GoldTreeCardTemplate.__init = __init
GoldTreeCardTemplate.__delete = __delete
return GoldTreeCardTemplate
