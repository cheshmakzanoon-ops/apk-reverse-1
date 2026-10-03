local VipTemplate = BaseClass("VipTemplate")

local function __init(self)
  self.id = 0
  self.point = 0
  self.level = 0
  self.icon = ""
  self.reward1 = 0
  self.reward2 = ""
  self.display = ""
  self.effect = {}
  self.freePackRewardList = {}
  self.freePackNameKey = ""
end

local function __delete(self)
  self.id = nil
  self.point = nil
  self.level = nil
  self.icon = nil
  self.reward1 = nil
  self.reward2 = nil
  self.display = nil
  self.effect = nil
  self.freePackRewardList = nil
  self.freePackNameKey = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.point = row:getValue("point")
  self.level = self.id
  self.icon = row:getValue("icon")
  self.reward2 = row:getValue("reward2")
  local displayStr = row:getValue("display")
  self.display = string.split(displayStr, "|")
  local effectStr = row:getValue("effect")
  local str = string.split(effectStr, "|")
  local temp = {}
  for i, v in ipairs(str) do
    if v ~= nil and v ~= "" then
      local param = string.split(v, ";")
      if param and #param == 2 then
        temp[i] = {}
        temp[i].id = param[1]
        temp[i].value = tonumber(param[2])
        temp[i].descID = GetTableData(TableName.LW_Effect_Number, param[1], "name")
        temp[i].num_type = GetTableData(TableName.LW_Effect_Number, param[1], "type")
        temp[i].isNew = false
      end
    end
  end
  for i, v in ipairs(temp) do
    for k = 1, #self.display do
      if tonumber(self.display[k]) == tonumber(v.id) then
        temp[i].isNew = true
      end
    end
  end
  for k = 1, #self.display do
    for i, v in ipairs(temp) do
      if tonumber(self.display[k]) == tonumber(v.id) then
        table.insert(self.effect, v)
      end
    end
  end
  for i = #temp, 1, -1 do
    if temp[i].isNew == true then
      table.remove(temp, i)
    end
  end
  for i = 1, #temp do
    table.insert(self.effect, temp[i])
  end
  local freePackRewardListStr = row:getValue("goods_show1")
  freePackRewardListStr = string.split(freePackRewardListStr, "|")
  if not table.IsNullOrEmpty(freePackRewardListStr) then
    for i = 1, #freePackRewardListStr do
      local reward = DataCenter.RewardManager:ParseOneRewardStr(freePackRewardListStr[i])
      table.insert(self.freePackRewardList, reward)
    end
  end
  self.freePackNameKey = row:getValue("key1")
end

VipTemplate.__init = __init
VipTemplate.__delete = __delete
VipTemplate.InitData = InitData
return VipTemplate
