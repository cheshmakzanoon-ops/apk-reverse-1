local AllianceScienceTemplate = BaseClass("AllianceScienceTemplate")

local function __init(self)
  self.id = 0
  self.name = ""
  self.icon = ""
  self.description = ""
  self.description_value = {}
  self.description_type = 0
  self.order = 0
end

local function __delete(self)
  self.id = nil
  self.name = nil
  self.icon = nil
  self.description = nil
  self.description_value = nil
  self.description_type = nil
  self.order = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.name = row:getValue("name")
  self.icon = row:getValue("icon")
  self.description = row:getValue("description")
  self.description_value = {}
  local str = row:getValue("description_value")
  if str ~= nil and str ~= "" then
    local all = string.split_ss_array(str, ";")
    for k, v in ipairs(all) do
      local para1 = string.split_ss_array(v, ",")
      if table.count(para1) > 1 then
        local param = {}
        param.careerType = tonumber(para1[1])
        param.num = tonumber(para1[2])
        table.insert(self.description_value, param)
      end
    end
  end
  self.description_type = row:getValue("description_type")
  self.order = row:getValue("order")
end

AllianceScienceTemplate.__init = __init
AllianceScienceTemplate.__delete = __delete
AllianceScienceTemplate.InitData = InitData
return AllianceScienceTemplate
