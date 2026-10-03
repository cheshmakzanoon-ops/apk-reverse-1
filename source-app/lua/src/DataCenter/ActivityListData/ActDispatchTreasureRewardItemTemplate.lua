local ActDispatchTreasureRewardItemTemplate = BaseClass("ActDispatchTreasureRewardItemTemplate")

local function __init(self)
  self.prop = 0
  self.rewardParam = {}
  self:AddListener()
end

local function __delete(self)
  self.prop = nil
  self.rewardParam = nil
  self:RemoveListener()
end

local function AddListener(self)
end

local function RemoveListener(self)
end

local function InitData(self, prop, rewardId, num)
  self.prop = prop
  self.rewardParam = {}
  self.rewardParam.itemId = rewardId
  self.rewardParam.count = num
  self.rewardParam.rewardType = RewardType.GOODS
end

ActDispatchTreasureRewardItemTemplate.__init = __init
ActDispatchTreasureRewardItemTemplate.__delete = __delete
ActDispatchTreasureRewardItemTemplate.AddListener = AddListener
ActDispatchTreasureRewardItemTemplate.RemoveListener = RemoveListener
ActDispatchTreasureRewardItemTemplate.InitData = InitData
return ActDispatchTreasureRewardItemTemplate
