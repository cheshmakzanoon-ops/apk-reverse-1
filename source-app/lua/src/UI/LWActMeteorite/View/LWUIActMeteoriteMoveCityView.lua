local LWUIActMeteoriteMoveCityView = BaseClass("LWUIActMeteoriteMoveCityView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function LWUIActMeteoriteMoveCityView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIActMeteoriteMoveCityView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActMeteoriteMoveCityView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textGo = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnJump = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnJump:SetOnClick(function()
    self:OnBtnJumpClick()
  end)
  local param = self:GetUserData()
  self.callback = param and param.callback
  self.textDesc:SetLocalText("yuntieBattle_interface_desc_1053")
end

function LWUIActMeteoriteMoveCityView:ComponentDestroy()
  self.viewSkin = nil
  self.textTips = nil
  self.textGo = nil
  self.textTitle = nil
  self.btnPanel = nil
  self.textDesc = nil
  self.btnClose = nil
  self.btnJump = nil
end

function LWUIActMeteoriteMoveCityView:DataDefine()
end

function LWUIActMeteoriteMoveCityView:DataDestroy()
end

function LWUIActMeteoriteMoveCityView:OnAddListener()
  base.OnAddListener(self)
end

function LWUIActMeteoriteMoveCityView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIActMeteoriteMoveCityView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function LWUIActMeteoriteMoveCityView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function LWUIActMeteoriteMoveCityView:OnBtnJumpClick()
  if self.callback then
    self.callback()
  end
  self.ctrl:CloseSelf()
end

function LWUIActMeteoriteMoveCityView:Update1000MS()
  self:RefreshCd()
end

function LWUIActMeteoriteMoveCityView:OnEnable()
  base.OnEnable(self)
  self:RefreshCd()
end

function LWUIActMeteoriteMoveCityView:RefreshCd()
  local time = MeteoriteBattleUtils.GetFreeMoveCdTime()
  if 0 < time then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local gap = time - curTime
    if gap < 0 then
      if self.showCd ~= false then
        self.textTips:SetLocalText("458044")
        self.showCd = false
      end
      return
    end
    self.textTips:SetText(UITimeManager:GetInstance():SecondToFmtStringWithoutHour(gap / 1000))
  elseif self.showCd ~= false then
    self.textTips:SetLocalText("458044")
    self.showCd = false
  end
end

return LWUIActMeteoriteMoveCityView
