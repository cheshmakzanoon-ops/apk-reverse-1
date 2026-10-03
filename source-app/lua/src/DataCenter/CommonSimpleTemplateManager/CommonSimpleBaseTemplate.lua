local CommonSimpleBaseTemplate = BaseClass("CommonSimpleBaseTemplate")

local function __init(self)
  self.id = 0
end

local function __delete(self)
end

local function InitData(self, row)
  self.id = tonumber(row:getValue("id")) or 0
end

CommonSimpleBaseTemplate.__init = __init
CommonSimpleBaseTemplate.__delete = __delete
CommonSimpleBaseTemplate.InitData = InitData
return CommonSimpleBaseTemplate
