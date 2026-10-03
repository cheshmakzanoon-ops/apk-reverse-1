local LWUINewBeeMigrateView = BaseClass("LWUINewBeeMigrateView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local CLS_MAIL = "UI.LWUINewBeeMigrate.Component.LWUINewBeeMigrateMailBg"
local PREFAB_MAIL = "Assets/Main/Prefabs/UI/LWMainUI/LWUINewBeeMigrateMailBg.prefab"

function LWUINewBeeMigrateView:OnCreate()
  base.OnCreate(self)
  self.rewardList = DataCenter.ActMigrationManager:GetRewards(1)
  self.animator = self:AddComponent(UIAnimator, "")
  self.animator:Enable(true)
  self.panel = self:AddComponent(UIButton, "black")
  self.panel:SetOnClick(BindCallback(self, self.OnClickPanel))
  self.panelLoading = self:AddComponent(UIBaseContainer, "panelLoading")
  self.root_letter = self:AddComponent(UIBaseComponent, "envelopeBg")
  local newBeeMigrateWay = LuaEntry.Player:GetNewBeeMigrateWay()
  if newBeeMigrateWay % 2 == 0 then
    self:ShowLetter()
  else
    self.ctrl:CloseSelf()
  end
end

function LWUINewBeeMigrateView:OnDestroy()
  self.root_tip = nil
  self.newBeeMigrateAccept = nil
  self.ctrl:ClearData()
  DataCenter.ActMigrationManager:ClearFakeLoading()
  base.OnDestroy(self)
end

function LWUINewBeeMigrateView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.NewBeeMigrateMsg, self.HandleNewBeeMigrateMsg)
  self:AddUIListener(EventId.NewBeeMigratePushMsg, self.LoadLoading)
end

function LWUINewBeeMigrateView:OnRemoveListener()
  self:RemoveUIListener(EventId.NewBeeMigrateMsg, self.HandleNewBeeMigrateMsg)
  self:RemoveUIListener(EventId.NewBeeMigratePushMsg, self.LoadLoading)
  base.OnRemoveListener(self)
end

function LWUINewBeeMigrateView:OnClickPanel()
  if self.root_tip == nil then
    self.root_tip = self:LoadComponentAsync(CLS_MAIL, PREFAB_MAIL, self, function()
      self.animator:Play("LWUINewBeeMigrateLetterOpen", 0, 0)
      TimerManager:GetInstance():DelayFrameInvoke(function()
        self.root_tip:SetActive(true)
      end, 22)
    end)
    self.root_tip:SetName("mailBg")
    self.root_tip:SetActive(false)
  end
end

function LWUINewBeeMigrateView:HandleNewBeeMigrateMsg(status)
  self.ctrl:HandleNewBeeMigrateMsg(status, self.newBeeMigrateAccept)
end

function LWUINewBeeMigrateView:ShowLetter()
  self.root_letter:SetActive(true)
  if self.root_tip ~= nil then
    self.root_tip:SetActive(false)
  end
  self.panelLoading:SetActive(false)
end

function LWUINewBeeMigrateView:LoadLoading()
  self.animator:Enable(false)
  if self.root_tip ~= nil then
    self.root_tip:SetActive(false)
  end
  DataCenter.ActMigrationManager:LoadFakeLoading(self.panelLoading, function()
    local newBeeMigrateWay = LuaEntry.Player:GetNewBeeMigrateWay()
    if 2 < newBeeMigrateWay then
      self.ctrl:HandleNewBeeMigrateMsg(0, true)
    end
  end)
end

return LWUINewBeeMigrateView
