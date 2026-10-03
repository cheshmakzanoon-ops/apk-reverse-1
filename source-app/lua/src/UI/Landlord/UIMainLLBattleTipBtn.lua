local UIMainLLBattleTipBtn = BaseClass("UIMainLLBattleTipBtn", UIButton)
local base = UIButton
local Localization = CS.GameEntry.Localization

function UIMainLLBattleTipBtn:OnCreate()
  base.OnCreate(self)
  self:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILandlordMain, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
  end)
  self.root = self:AddComponent(UIBaseContainer, "")
  self.tips = self:AddComponent(UIBaseContainer, "Tips")
  self.tips:SetActive(false)
  self.time_text = self:AddComponent(UITextMeshProUGUIEx, "Tips/TipsText")
  self.time_text:SetLocalText("458155")
  self.needShowTipsOnReturnToSource = true
end

function UIMainLLBattleTipBtn:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MoveCrossServerMessage, self.OnMoveCrossServerMessage)
end

function UIMainLLBattleTipBtn:OnRemoveListener()
  self:RemoveUIListener(EventId.MoveCrossServerMessage, self.OnMoveCrossServerMessage)
  base.OnRemoveListener(self)
end

function UIMainLLBattleTipBtn:OnDestroy()
  base.OnDestroy(self)
  self:StopTipsTimer()
end

function UIMainLLBattleTipBtn:StopTipsTimer()
  if self.tipsTimer ~= nil then
    self.tipsTimer:Stop()
    self.tipsTimer = nil
  end
end

function UIMainLLBattleTipBtn:ShowTipsFor5Seconds()
  self:StopTipsTimer()
  self.tips:SetActive(true)
  self.tipsTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.tips:SetActive(false)
    self.tipsTimer = nil
  end, 5)
end

function UIMainLLBattleTipBtn:IsLoginSourceServer()
  return LuaEntry.Player:GetSelfServerId() == LuaEntry.Player:GetSourceServerId()
end

function UIMainLLBattleTipBtn:CalcBtnActive()
  local active = false
  local isInBattle = DataCenter.LandlordMgr:IsInBattle()
  local centerServerId = DataCenter.LandlordMgr:GetCenterServerId()
  if 0 < centerServerId then
    local isInCenterServer = LuaEntry.Player:GetServerId() == DataCenter.LandlordMgr:GetCenterServerId()
    active = isInBattle == true and not isInCenterServer and DataCenter.LandlordMgr:IsInMyServerGroup()
  end
  return active
end

function UIMainLLBattleTipBtn:Refresh()
  local active = self:CalcBtnActive()
  self.root:SetActive(active)
  if self.needShowTipsOnReturnToSource and active and self:IsLoginSourceServer() then
    self.needShowTipsOnReturnToSource = false
    self:ShowTipsFor5Seconds()
  end
end

function UIMainLLBattleTipBtn:OnMoveCrossServerMessage()
  self.needShowTipsOnReturnToSource = true
  self:StopTipsTimer()
  self.tips:SetActive(false)
  self:Refresh()
end

return UIMainLLBattleTipBtn
