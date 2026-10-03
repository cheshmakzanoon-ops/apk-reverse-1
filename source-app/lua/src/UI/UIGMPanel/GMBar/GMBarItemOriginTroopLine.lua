local base = UIAsyncContainer
local GMBarItemOriginTroopLine = BaseClass("GMBarItemOriginTroopLine", base)
local Localization = CS.GameEntry.Localization

function GMBarItemOriginTroopLine:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function GMBarItemOriginTroopLine:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function GMBarItemOriginTroopLine:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnActiveSwitch = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnActiveSwitch:SetOnClick(function()
    self:OnBtnActiveSwitchClick()
  end)
  self.textTmpRate = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.imgArrow = self.viewSkin:AddComponent(self, UIImage, 3)
  self.textTmpScale = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnLeftScale = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnLeftScale:SetOnClick(function()
    self:OnBtnLeftScaleClick()
  end)
  self.btnRightScale = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnRightScale:SetOnClick(function()
    self:OnBtnRightScaleClick()
  end)
  self.textTmpAlpha = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.btnLeftAlpha = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnLeftAlpha:SetOnClick(function()
    self:OnBtnLeftAlphaClick()
  end)
  self.btnRightAlpha = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnRightAlpha:SetOnClick(function()
    self:OnBtnRightAlphaClick()
  end)
  self.compScaleLayout = self.viewSkin:AddComponent(self, UIBaseContainer, 10)
  self.compAlphaLayout = self.viewSkin:AddComponent(self, UIBaseContainer, 11)
  self.textTmpRate:SetText("\229\188\128\229\133\179:")
  self:RefreshAll()
end

function GMBarItemOriginTroopLine:ComponentDestroy()
  self.viewSkin = nil
  self.btnActiveSwitch = nil
  self.textTmpRate = nil
  self.imgArrow = nil
  self.textTmpScale = nil
  self.btnLeftScale = nil
  self.btnRightScale = nil
  self.textTmpAlpha = nil
  self.btnLeftAlpha = nil
  self.btnRightAlpha = nil
  self.compScaleLayout = nil
  self.compAlphaLayout = nil
end

function GMBarItemOriginTroopLine:GetTroopLineManager()
  local world = CS.SceneManager.World
  if world then
    return world.TroopLineManager
  else
    return nil
  end
end

function GMBarItemOriginTroopLine:DataDefine()
end

function GMBarItemOriginTroopLine:DataDestroy()
end

function GMBarItemOriginTroopLine:Refresh()
  self:RefreshActiveState()
  self:RefreshScale()
end

function GMBarItemOriginTroopLine:OnAddListener()
  base.OnAddListener(self)
end

function GMBarItemOriginTroopLine:OnRemoveListener()
  base.OnRemoveListener(self)
end

function GMBarItemOriginTroopLine:RefreshActiveState()
  local enableTroopLine = WorldBattleUtil.EnableNewTroopLine()
  if self.enableNewTroopLine ~= enableTroopLine then
    self.enableNewTroopLine = enableTroopLine
    self.imgArrow:SetActive(enableTroopLine)
    self.enableTroopLine = enableTroopLine
    self.compScaleLayout:SetActive(enableTroopLine)
    self.compAlphaLayout:SetActive(enableTroopLine)
    if enableTroopLine then
      self:RefreshScale()
      self:RefreshAlpha()
    end
  end
end

function GMBarItemOriginTroopLine:OnBtnActiveSwitchClick()
  self:RefreshActiveState()
  self:RefreshAll()
end

function GMBarItemOriginTroopLine:RefreshScale()
  local scale = CS.WorldTroopLineLittleSmart.Line.GlobalTroopLineScale
  self.textTmpScale:SetText(string.format("\231\188\169\230\148\190:%.1f", scale))
end

function GMBarItemOriginTroopLine:OnBtnLeftScaleClick()
  local scale = CS.WorldTroopLineLittleSmart.Line.GlobalTroopLineScale
  scale = scale - 0.1
  scale = Mathf.Clamp(scale, 0.1, 2.0)
  CS.WorldTroopLineLittleSmart.Line.GlobalTroopLineScale = scale
  self:RefreshScale()
end

function GMBarItemOriginTroopLine:OnBtnRightScaleClick()
  local scale = CS.WorldTroopLineLittleSmart.Line.GlobalTroopLineScale
  scale = scale + 0.1
  scale = Mathf.Clamp(scale, 0.1, 2.0)
  CS.WorldTroopLineLittleSmart.Line.GlobalTroopLineScale = scale
  self:RefreshScale()
end

function GMBarItemOriginTroopLine:RefreshAlpha()
  local alpha = CS.WorldTroopLineLittleSmart.Line.GlobalTroopLineAlpha
  self.textTmpAlpha:SetText(string.format("Alpha:%.1f", alpha))
end

function GMBarItemOriginTroopLine:OnBtnLeftAlphaClick()
  local scale = CS.WorldTroopLineLittleSmart.Line.GlobalTroopLineAlpha
  scale = scale - 0.1
  scale = Mathf.Clamp(scale, 0.1, 1.0)
  CS.WorldTroopLineLittleSmart.Line.GlobalTroopLineAlpha = scale
  self:RefreshAlpha()
end

function GMBarItemOriginTroopLine:OnBtnRightAlphaClick()
  local scale = CS.WorldTroopLineLittleSmart.Line.GlobalTroopLineAlpha
  scale = scale + 0.1
  scale = Mathf.Clamp(scale, 0.1, 1.0)
  CS.WorldTroopLineLittleSmart.Line.GlobalTroopLineAlpha = scale
  self:RefreshAlpha()
end

function GMBarItemOriginTroopLine:OnBtnCloseClick()
end

function GMBarItemOriginTroopLine:RefreshAll()
  self:RefreshScale()
  self:RefreshAlpha()
  self:RefreshActiveState()
end

return GMBarItemOriginTroopLine
