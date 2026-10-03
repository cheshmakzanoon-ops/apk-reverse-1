local LWUIActRecycleLotteryAnimShowView = BaseClass("LWUIActRecycleLotteryAnimShowView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWUIActRecycleLotteryAnimShowComponent_2025christmas = require("UI.LWUIActRecycle.LotteryAnimShow.Component.LWUIActRecycleLotteryAnimShowComponent_2025christmas")

function LWUIActRecycleLotteryAnimShowView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

function LWUIActRecycleLotteryAnimShowView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActRecycleLotteryAnimShowView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compRoot = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
end

function LWUIActRecycleLotteryAnimShowView:ComponentDestroy()
  if self.req then
    self.req:Destroy()
    self.req = nil
  end
  self.viewSkin = nil
  self.compRoot = nil
end

function LWUIActRecycleLotteryAnimShowView:DataDefine()
  self.closeSelfTime = 7
  self.msgData = nil
  self.delayTimer = nil
end

function LWUIActRecycleLotteryAnimShowView:DataDestroy()
  self.closeSelfTime = nil
  self.msgData = nil
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

function LWUIActRecycleLotteryAnimShowView:OnAddListener()
  base.OnAddListener(self)
end

function LWUIActRecycleLotteryAnimShowView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIActRecycleLotteryAnimShowView:OnOpen()
  self.msgData = self:GetUserData()
  self.req = self:GameObjectInstantiateAsync(UIAssets.ActRecycleLotteryAnim_2025christmas, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go.transform:SetParent(self.compRoot.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    go.transform:Set_offsetMin(0, 0)
    go.transform:Set_offsetMax(0, 0)
    self.item = self.compRoot:AddComponent(LWUIActRecycleLotteryAnimShowComponent_2025christmas, go)
    self.item:ReInit(self.msgData)
    if self.item.GetAnimLength ~= nil then
      self.closeSelfTime = self.item:GetAnimLength()
    end
    if self.delayTimer ~= nil then
      self.delayTimer:Stop()
      self.delayTimer = nil
    end
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self.msgData ~= nil then
        UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIActRecycleReceiveGift, {anim = true}, self.msgData)
      end
    end, self.closeSelfTime)
  end)
end

return LWUIActRecycleLotteryAnimShowView
