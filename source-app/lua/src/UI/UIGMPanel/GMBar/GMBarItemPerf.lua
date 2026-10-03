local base = UIAsyncContainer
local GMBarItemPerf = BaseClass("GMBarItemPerf", base)
local Localization = CS.GameEntry.Localization
local CSShowFpsText = CS.ShowFPSText

function GMBarItemPerf:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshAll()
end

function GMBarItemPerf:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function GMBarItemPerf:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgIconFps = self.viewSkin:AddComponent(self, UIImage, 1)
  self.imgIconMem = self.viewSkin:AddComponent(self, UIImage, 2)
  self.imgIconGpuSkin = self.viewSkin:AddComponent(self, UIImage, 3)
  self.textTmpGpuSkin = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textTmpFps = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textTmpMem = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.btnGMBarItemPerf = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnGMBarItemPerf:SetOnClick(function()
    self:OnBtnGMBarItemPerfClick()
  end)
  self.showFpsComp = CSShowFpsText.Instance
  if IsNotNull(self.showFpsComp) then
    self.isValid = true
  else
    self.isValid = false
  end
end

function GMBarItemPerf:ComponentDestroy()
  self.viewSkin = nil
  self.imgIconFps = nil
  self.imgIconMem = nil
  self.imgIconGpuSkin = nil
  self.textTmpGpuSkin = nil
  self.textTmpFps = nil
  self.textTmpMem = nil
  self.btnGMBarItemPerf = nil
  self.showFpsComp = nil
  self.isValid = nil
  if self.timerRefresh then
    self.timerRefresh:Stop()
    self.timerRefresh = nil
  end
end

function GMBarItemPerf:DataDefine()
end

function GMBarItemPerf:RefreshAll()
  if self.isValid then
    self.textTmpFps:SetText(self.showFpsComp.FpsString)
    self.textTmpMem:SetText(self.showFpsComp.MemString)
    self.textTmpGpuSkin:SetText(self.showFpsComp.GpuSkinString)
    if not self.timerRefresh then
      self.timerRefresh = TimerManager:GetInstance():GetTimer(1, self.RefreshAll, self, false, false, false)
      self.timerRefresh:Start()
    end
  else
    self.textTmpGpuSkin:SetText("")
    self.textTmpFps:SetText("")
    self.textTmpMem:SetText("")
    if self.timerRefresh then
      self.timerRefresh:Stop()
      self.timerRefresh = nil
    end
  end
end

function GMBarItemPerf:DataDestroy()
end

function GMBarItemPerf:OnAddListener()
  base.OnAddListener(self)
end

function GMBarItemPerf:OnRemoveListener()
  base.OnRemoveListener(self)
end

function GMBarItemPerf:OnBtnGMBarItemPerfClick()
  if self.isValid then
    local sb = StringBuilder.New()
    sb:AppendLine(self.showFpsComp.FpsString)
    sb:AppendLine(self.showFpsComp.MemString)
    sb:AppendLine(self.showFpsComp.GpuSkinString)
    CommonUtil.CopyTextToClipboard(sb:ToString())
    UIUtil.ShowTips("\229\183\178\229\164\141\229\136\182\229\136\176\229\137\170\232\180\180\230\157\191")
  else
    UIUtil.ShowTips("\229\164\141\229\136\182\229\164\177\232\180\165...")
  end
end

return GMBarItemPerf
