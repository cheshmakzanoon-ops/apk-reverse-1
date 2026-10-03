local ZoneMobilizationModelCtrl = BaseClass("ZoneMobilizationModelCtrl")

local function __init(self, transform)
  self:Init(transform)
end

local function __delete(self)
  self:Destroy()
end

local function Destroy(self)
  self.transform = nil
end

local function Init(self, transform)
  self.transform = transform
end

ZoneMobilizationModelCtrl.__init = __init
ZoneMobilizationModelCtrl.__delete = __delete
ZoneMobilizationModelCtrl.Destroy = Destroy
ZoneMobilizationModelCtrl.Init = Init
return ZoneMobilizationModelCtrl
