local LWUINewBeeMigrateLoadingView = BaseClass("LWUINewBeeMigrateLoadingView", UIBaseView)
local base = UIBaseView

function LWUINewBeeMigrateLoadingView:OnCreate()
  base.OnCreate(self)
  local newBeeMigrateWay = LuaEntry.Player:GetNewBeeMigrateWay()
  if newBeeMigrateWay % 2 ~= 1 then
    self.ctrl:CloseSelf()
    return
  end
  DataCenter.ActMigrationManager:LoadMReward(self)
end

function LWUINewBeeMigrateLoadingView:OnDestroy()
  self.ctrl:ClearData()
  base.OnDestroy(self)
end

function LWUINewBeeMigrateLoadingView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.NewBeeMigrateMsg, self.HandleNewBeeMigrateMsg)
  self:AddUIListener(EventId.GF_window_opened, self.OnWindowOpened)
end

function LWUINewBeeMigrateLoadingView:OnRemoveListener()
  self:RemoveUIListener(EventId.NewBeeMigrateMsg, self.HandleNewBeeMigrateMsg)
  self:RemoveUIListener(EventId.GF_window_opened, self.OnWindowOpened)
  base.OnRemoveListener(self)
end

function LWUINewBeeMigrateLoadingView:HandleNewBeeMigrateMsg(status)
  self.ctrl:HandleNewBeeMigrateMsg(status, self.newBeeMigrateAccept)
end

function LWUINewBeeMigrateLoadingView:OnWindowOpened(windowName)
  if windowName == UIWindowNames.LWUINewBeeMigrateLoading and self.newBeeMigrateAccept == nil then
    self.newBeeMigrateAccept = true
    self.ctrl:SendNewBeeMigrateMsg(true)
  end
end

return LWUINewBeeMigrateLoadingView
