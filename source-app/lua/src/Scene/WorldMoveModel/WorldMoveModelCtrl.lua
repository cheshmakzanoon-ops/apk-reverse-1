local WorldMoveModelCtrl = BaseClass("WorldMoveModelCtrl")

local function __init(self, transform)
  self.transform = transform
end

local function __delete(self)
  self:Dispose()
end

local function Dispose(self)
  self.transform = nil
end

WorldMoveModelCtrl.__init = __init
WorldMoveModelCtrl.__delete = __delete
WorldMoveModelCtrl.Dispose = Dispose
return WorldMoveModelCtrl
