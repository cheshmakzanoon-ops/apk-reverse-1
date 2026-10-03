local base = UIAsyncContainer
local GMBarItemHappyWatcher = BaseClass("GMBarItemHappyWatcher", base)
local Localization = CS.GameEntry.Localization

function GMBarItemHappyWatcher:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function GMBarItemHappyWatcher:OnDestroy()
  if self.refreshTimer then
    self.refreshTimer:Stop()
    self.refreshTimer = nil
  end
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function GMBarItemHappyWatcher:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTmpWorldInfo = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnGMBarItemHappyWatcher = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnGMBarItemHappyWatcher:SetOnClick(function()
    self:OnBtnGMBarItemHappyWatcherClick()
  end)
  self.compSplit = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.compScroller = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.happyInfo = ""
  if self.refreshTimer == nil then
    self.refreshTimer = TimerManager:GetInstance():GetTimer(0.5, self.RefreshHappyInfo, self, false, false, false)
    self.refreshTimer:Start()
  end
end

function GMBarItemHappyWatcher:ComponentDestroy()
  self.viewSkin = nil
  self.textTmpWorldInfo = nil
  self.btnGMBarItemHappyWatcher = nil
  self.compSplit = nil
  self.compScroller = nil
end

function GMBarItemHappyWatcher:DataDefine()
end

function GMBarItemHappyWatcher:DataDestroy()
end

function GMBarItemHappyWatcher:OnAddListener()
  base.OnAddListener(self)
end

function GMBarItemHappyWatcher:OnRemoveListener()
  base.OnRemoveListener(self)
end

function GMBarItemHappyWatcher:OnBtnGMBarItemHappyWatcherClick()
  if string.IsNullOrEmpty(self.happyInfo) then
    return
  end
  CommonUtil.CopyTextToClipboard(self.happyInfo)
  UIUtil.ShowTips("\229\183\178\229\164\141\229\136\182\229\136\176\229\137\170\232\180\180\230\157\191")
end

function GMBarItemHappyWatcher:RefreshHappyInfo()
  local mgr = GMUtils.GMManager
  self.happyInfo = mgr and mgr:GetHappyInfo() or ""
  if string.IsNullOrEmpty(self.happyInfo) then
    self.compScroller:SetActive(false)
  else
    self.compScroller:SetActive(true)
    self.textTmpWorldInfo:SetText(self.happyInfo)
  end
end

return GMBarItemHappyWatcher
