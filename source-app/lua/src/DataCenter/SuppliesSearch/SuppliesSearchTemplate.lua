local SuppliesSearchTemplate = BaseClass("SuppliesSearchTemplate")

function SuppliesSearchTemplate:__init()
  self.id = 0
  self.type = 0
  self.level_rate = ""
  self.reward_id = ""
  self.reward_fail_id = ""
  self.para1 = 0
  self.para2 = ""
  self.para3 = ""
  self.dialog_id = ""
  self.win_diamond = ""
  self.fail_diamond = ""
end

function SuppliesSearchTemplate:__delete()
  self.id = nil
  self.type = nil
  self.level_rate = nil
  self.reward_id = nil
  self.reward_fail_id = nil
  self.para1 = nil
  self.para2 = nil
  self.para3 = nil
  self.dialog_id = nil
  self.win_diamond = nil
  self.fail_diamond = nil
end

function SuppliesSearchTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.type = rowData:getValue("type") or 0
  self.level_rate = rowData:getValue("level_rate") or ""
  self.reward_id = rowData:getValue("reward_id") or ""
  self.reward_fail_id = rowData:getValue("reward_fail_id") or ""
  self.para1 = rowData:getValue("para1") or 0
  self.para2 = rowData:getValue("para2") or ""
  self.para3 = rowData:getValue("para3") or ""
  self.dialog_id = rowData:getValue("dialog_id") or ""
  self.win_diamond = rowData:getValue("win_diamond") or ""
  self.fail_diamond = rowData:getValue("fail_diamond") or ""
  self.tLevelDict = {}
  local tLevelRate = string.split(self.level_rate, "|")
  local tRewardId = string.split(self.reward_id, "|")
  local tRewardFailId = string.split(self.reward_fail_id, "|")
  local tDialogId = string.split(self.dialog_id, "|")
  local tWinDiamondVal = string.split(self.win_diamond, "|")
  local tFailDiamondVal = string.split(self.fail_diamond, "|")
  for i, v in ipairs(tLevelRate) do
    self.tLevelDict[i] = {}
    local arr = string.split(v, ";")
    local nRate = tonumber(arr[2])
    local nRewardId = tonumber(tRewardId[i])
    local nRewardFailId = tonumber(tRewardFailId[i])
    self.tLevelDict[i].nRate = nRate / 10000
    self.tLevelDict[i].tRewardList = self:GetRewardShow(nRewardId)
    self.tLevelDict[i].tRewardFailList = self:GetRewardShow(nRewardFailId)
    self.tLevelDict[i].nWinDiamondVal = tonumber(tWinDiamondVal[i])
    self.tLevelDict[i].nFailDiamondVal = tonumber(tFailDiamondVal[i])
    self.tLevelDict[i].sDialogId = tDialogId[i + 1]
  end
  self.zeroLevelDialogId = tDialogId[1]
end

function SuppliesSearchTemplate:GetRewardShow(rewardId)
  local result = {}
  local line = LocalController:instance():getLine(TableName.RewardConfig, rewardId)
  if line == nil then
    return result
  end
  local itemValues = line:getValue("item") or ""
  local numValues = line:getValue("num") or ""
  if not string.IsNullOrEmpty(itemValues) and not string.IsNullOrEmpty(numValues) then
    local ids = string.split(itemValues, "|")
    local nums = string.split(numValues, "|")
    if ids ~= nil and 0 < #ids then
      for i, id in pairs(ids) do
        local oneData = {}
        oneData.itemId = id
        oneData.count = nums[i] or 0
        oneData.rewardType = RewardType.GOODS
        table.insert(result, oneData)
      end
    end
  end
  return result
end

return SuppliesSearchTemplate
