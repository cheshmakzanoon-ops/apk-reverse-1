local base = UIAsyncContainer
local GMBarItemOriginLitMode = BaseClass("GMBarItemOriginLitMode", base)
local Localization = CS.GameEntry.Localization

function GMBarItemOriginLitMode:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Refresh()
end

function GMBarItemOriginLitMode:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function GMBarItemOriginLitMode:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTmpDisplayModeDetail = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnAuto = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnAuto:SetOnClick(function()
    self:OnBtnAutoClick()
  end)
  self.btnLeft = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnLeft:SetOnClick(function()
    self:OnBtnLeftClick()
  end)
  self.btnRight = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnRight:SetOnClick(function()
    self:OnBtnRightClick()
  end)
end

function GMBarItemOriginLitMode:ComponentDestroy()
  self.viewSkin = nil
  self.textTmpDisplayModeDetail = nil
  self.btnAuto = nil
  self.btnLeft = nil
  self.btnRight = nil
end

function GMBarItemOriginLitMode:DataDefine()
end

function GMBarItemOriginLitMode:DataDestroy()
end

function GMBarItemOriginLitMode:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.Settings_Graphic_Lv_Changed, self.Refresh)
  self:AddUIListener(EventId.WorldMarchUpdateDisplayMode, self.Refresh)
end

function GMBarItemOriginLitMode:OnRemoveListener()
  self:RemoveUIListener(EventId.Settings_Graphic_Lv_Changed, self.Refresh)
  self:RemoveUIListener(EventId.WorldMarchUpdateDisplayMode, self.Refresh)
  base.OnRemoveListener(self)
end

function GMBarItemOriginLitMode:OnBtnLeftClick()
  local lv = DevUtils.GetPerformanceLevelLv()
  lv = lv - 1
  if lv < 1 then
    lv = 5
  end
  DevUtils.SetPerformanceLevel(lv)
  self:Refresh()
end

function GMBarItemOriginLitMode:OnBtnRightClick()
  local lv = DevUtils.GetPerformanceLevelLv()
  lv = lv + 1
  if 5 < lv then
    lv = 1
  end
  DevUtils.SetPerformanceLevel(lv)
  self:Refresh()
end

function GMBarItemOriginLitMode:OnBtnAutoClick()
  DevUtils.SetPerformanceLevel(0)
end

local graphicLvConvert = {
  [1] = "\228\189\142",
  [2] = "\228\184\173",
  [3] = "\233\171\152",
  ["?"] = "?"
}
local disLvConvert = {
  [0] = "\229\133\179",
  [-1] = "\228\189\142",
  [-2] = "\228\184\173",
  [-3] = "\233\171\152",
  [-4] = "\232\182\133\233\171\152",
  ["?"] = "?"
}

function GMBarItemOriginLitMode:Refresh()
  if IsNull(self.gameObject) then
    return
  end
  local displayMode = disLvConvert[DisplaySettings.GetCurrentDisplayLevel() or "?"]
  local graphicLevel = graphicLvConvert[GameQualitySettings.GetQuality() or "?"]
  self.textTmpDisplayModeDetail:SetText(string.format("\230\158\129\231\174\128:%s, \231\148\187\232\180\168:%s", displayMode, graphicLevel))
end

return GMBarItemOriginLitMode
