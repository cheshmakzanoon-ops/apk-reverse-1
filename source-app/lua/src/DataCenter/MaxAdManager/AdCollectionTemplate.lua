local AdCollectionTemplate = BaseClass("AdCollectionTemplate")
local Sdk = CS.GameEntry.Sdk

local function __init(self)
  self.id = 0
  self.type = ""
  self.unlock_lv = 0
  self.server = ""
  self.nation = ""
  self.pf = ""
  self.reward = 0
  self.times = ""
  self.AdUnitID = {}
  self.AdUnitID_ios = {}
  self.AdUnitID2 = {}
  self.AdUnitID_ios2 = {}
  self.name = ""
  self.rewardList = nil
end

local function __delete(self)
  self.id = 0
  self.type = ""
  self.unlock_lv = 0
  self.server = ""
  self.nation = ""
  self.pf = ""
  self.reward = 0
  self.times = ""
  self.AdUnitID = {}
  self.AdUnitID_ios = {}
  self.AdUnitID2 = {}
  self.AdUnitID_ios2 = {}
  self.name = ""
  self.rewardList = nil
end

local function InitData(self, data)
  self.id = data.id
  self.type = data.type
  self.unlock_lv = data.unlock_lv
  self.server = data.server
  self.nation = data.nation
  self.pf = data.pf
  self.reward = data.reward
  self.times = data.times
  self.AdUnitID = data.AdUnitID or {}
  self.AdUnitID_ios = data.AdUnitID_ios or {}
  self.AdUnitID2 = data.AdUnitID2 or {}
  self.AdUnitID_ios2 = data.AdUnitID_ios2 or {}
  self.name = data.name
end

function AdCollectionTemplate:GetAdUnitId()
  if self.curAdUnitId then
    return self.curAdUnitId
  end
  local index = 1
  if Sdk:IsVNPlatform() then
    index = 2
  end
  if CS.SDKManager.IS_UNITY_ANDROID() then
    self.curAdUnitId = self.AdUnitID[index]
  elseif CS.SDKManager.IS_UNITY_IOS() then
    self.curAdUnitId = self.AdUnitID_ios[index]
  else
    self.curAdUnitId = ""
  end
  return self.curAdUnitId
end

function AdCollectionTemplate:GetRewardData()
  if self.rewardList then
    return self.rewardList
  end
  local res = {}
  local rewardConfig = LocalController:instance():getLine(TableName.RewardConfig, tonumber(self.reward))
  if rewardConfig ~= nil then
    local itemValues = rewardConfig:getValue("item") or ""
    local numValues = rewardConfig:getValue("num") or ""
    if not string.IsNullOrEmpty(itemValues) and not string.IsNullOrEmpty(numValues) then
      local ids = string.split(itemValues, "|")
      local nums = string.split(numValues, "|")
      if ids ~= nil and 0 < #ids then
        for i, id in pairs(ids) do
          local oneData = {}
          oneData.itemId = id
          oneData.count = nums[i] or 0
          oneData.rewardType = RewardType.GOODS
          table.insert(res, oneData)
        end
      end
    end
  end
  self.rewardList = res
  return self.rewardList
end

AdCollectionTemplate.__init = __init
AdCollectionTemplate.__delete = __delete
AdCollectionTemplate.InitData = InitData
return AdCollectionTemplate
