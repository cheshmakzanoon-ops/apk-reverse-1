local GuaranteedBoxTemplate = BaseClass("GuaranteedBoxTemplate")

local function __init(self)
  self.id = 0
  self.point_goods = 0
  self.name = ""
  self.list_goods = {}
  self.target_point = 0
  self.target_goods = {}
end

local function __delete(self)
  self.id = 0
  self.point_goods = 0
  self.name = ""
  self.list_goods = {}
  self.target_point = 0
  self.target_goods = {}
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.point_goods = row:getValue("point_goods") or 0
  self.name = row:getValue("name") or ""
  self.target_point = row:getValue("target_point") or 0
  local list_goods = row:getValue("list_goods") or ""
  self.list_goods = {}
  if not string.IsNullOrEmpty(list_goods) then
    local list = string.split(list_goods, "|")
    if list then
      for i = 1, #list do
        local item = string.split(list[i], ";")
        if #item == 2 then
          self.list_goods[#self.list_goods + 1] = {
            showType = tonumber(item[1]),
            id = tonumber(item[2])
          }
        end
      end
    end
  end
  local target_goods = row:getValue("target_goods") or ""
  self.target_goods = {}
  if not string.IsNullOrEmpty(target_goods) then
    local list = string.split(target_goods, "|")
    if list then
      for i = 1, #list do
        local item = string.split(list[i], ";")
        if #item == 2 then
          self.target_goods[#self.target_goods + 1] = {
            id = tonumber(item[1]),
            count = tonumber(item[2])
          }
        end
      end
    end
  end
end

local function GetFirstRewardInfo(self)
  if self.target_goods and #self.target_goods > 0 then
    return self.target_goods[1]
  end
  return nil
end

GuaranteedBoxTemplate.__init = __init
GuaranteedBoxTemplate.__delete = __delete
GuaranteedBoxTemplate.InitData = InitData
GuaranteedBoxTemplate.GetFirstRewardInfo = GetFirstRewardInfo
return GuaranteedBoxTemplate
