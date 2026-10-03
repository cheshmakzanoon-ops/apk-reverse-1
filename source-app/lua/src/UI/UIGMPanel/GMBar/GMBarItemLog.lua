local UIGray = CS.UIGray
local base = UIAsyncContainer
local GMBarItemLog = BaseClass("GMBarItemLog", base)
local Localization = CS.GameEntry.Localization

function GMBarItemLog:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshLogCount()
end

function GMBarItemLog:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function GMBarItemLog:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTmpWarning = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textTmpError = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnGMBarItemLog = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnGMBarItemLog:SetOnClick(function()
    self:OnBtnGMBarItemLogClick()
  end)
  self.imgWarning = self.viewSkin:AddComponent(self, UIImage, 4)
  self.imgError = self.viewSkin:AddComponent(self, UIImage, 5)
  self:RefreshLabelColor()
end

function GMBarItemLog:ComponentDestroy()
  self.viewSkin = nil
  self.textTmpWarning = nil
  self.textTmpError = nil
  self.btnGMBarItemLog = nil
  self.imgWarning = nil
  self.imgError = nil
end

function GMBarItemLog:DataDefine()
end

function GMBarItemLog:DataDestroy()
end

function GMBarItemLog:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GM_LOG_COUNT_CHANGED, self.RefreshLogCount)
  self:AddUIListener(EventId.GM_SomeValChanged, self.OnGMValChanged)
end

function GMBarItemLog:OnRemoveListener()
  self:RemoveUIListener(EventId.GM_LOG_COUNT_CHANGED, self.RefreshLogCount)
  self:RemoveUIListener(EventId.GM_SomeValChanged, self.OnGMValChanged)
  base.OnRemoveListener(self)
end

function GMBarItemLog:RefreshLogCount()
  local warning, error = GMUtils.GetLogCount()
  self.textTmpWarning:SetText(string.format("%s", 999 < warning and "999+" or warning))
  self.textTmpError:SetText(string.format("%s", 999 < error and "999+" or error))
end

function GMBarItemLog:OnBtnGMBarItemLogClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIGMLogPanel, {anim = true})
end

local colorWarning = Color.New(1.0, 0.6236605, 0)
local colorError = Color.New(1.0, 0.1387604, 0)
local grayColor = Color.New(0.3773585, 0.3773585, 0.3773585)

function GMBarItemLog:RefreshLabelColor()
  local lv = GMUtils.GetInt(GMConst.DebugLocalLogLevel, 3)
  local warningLog = lv & 1 ~= 0
  local errorLog = lv & 2 ~= 0
  UIGray.SetGray(self.imgWarning.transform, not warningLog)
  UIGray.SetGray(self.imgError.transform, not errorLog)
  self.textTmpWarning:SetColor(warningLog and colorWarning or grayColor)
  self.textTmpError:SetColor(errorLog and colorError or grayColor)
end

function GMBarItemLog:OnGMValChanged(val)
  if val == GMConst.DebugLocalLogLevel then
    self:RefreshLabelColor()
  end
end

return GMBarItemLog
