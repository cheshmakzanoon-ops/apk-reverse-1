local UIAllianceRallyCtrl = BaseClass("UIAllianceRallyCtrl", UIBaseCtrl)

local function CloseSelf(self, isNoDoAnim)
  if isNoDoAnim then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceRally, {anim = true})
  else
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceRally, {
      anim = true,
      UIMainAnim = UIMainAnimType.LeftRightBottomShow
    })
  end
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function InitData(self)
  self.list = {}
  local k1 = LuaEntry.DataConfig:TryGetStr("world_rally", "k1")
  local k2 = LuaEntry.DataConfig:TryGetStr("world_rally", "k2")
  local k3 = LuaEntry.DataConfig:TryGetStr("world_rally", "k3")
  local k4 = LuaEntry.DataConfig:TryGetStr("world_rally", "k4")
  self.list[1] = k1
  self.list[2] = k2
  self.list[3] = k3
  self.list[4] = k4
  return self.list
end

local function OnClickRally(self, point, index, uuid, rallyType)
  MarchUtil.OnClickStartMarch(rallyType, point, uuid, index, 1)
  self:CloseSelf(true)
end

UIAllianceRallyCtrl.CloseSelf = CloseSelf
UIAllianceRallyCtrl.Close = Close
UIAllianceRallyCtrl.InitData = InitData
UIAllianceRallyCtrl.OnClickRally = OnClickRally
return UIAllianceRallyCtrl
