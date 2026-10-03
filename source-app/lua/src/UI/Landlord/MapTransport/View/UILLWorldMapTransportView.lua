local UILLWorldMapTransportView = BaseClass("UILLWorldMapTransportView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UILLWorldMapTransportView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILLWorldMapTransportView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILLWorldMapTransportView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnJump = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnJump:SetOnClick(function()
    self:OnBtnJumpClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  local tipsKey = 458044
  local descKey = "zonewar_landlord_desc_1004"
  self.textTips:SetLocalText(tipsKey)
  self.textDesc:SetLocalText(descKey)
  self:OnCityMoveCoolDown()
end

function UILLWorldMapTransportView:ComponentDestroy()
  self.viewSkin = nil
  self.textDesc = nil
  self.textTips = nil
  self.btnJump = nil
  self.textTitle = nil
  self.btnClose = nil
  self.btnPanel = nil
end

function UILLWorldMapTransportView:DataDefine()
end

function UILLWorldMapTransportView:DataDestroy()
end

function UILLWorldMapTransportView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LandlordFreeMvEndTimeUpdate, self.OnCityMoveCoolDown)
end

function UILLWorldMapTransportView:OnRemoveListener()
  self:RemoveUIListener(EventId.LandlordFreeMvEndTimeUpdate, self.OnCityMoveCoolDown)
  base.OnRemoveListener(self)
end

function UILLWorldMapTransportView:OnBtnJumpClick()
  self.ctrl:CloseSelf()
  local pointId = SceneUtils.WorldToTileIndex(CS.SceneManager.World.CurTarget)
  MoveCityUtil.OnClickMoveCity(LuaEntry.Player:GetCurServerId(), pointId)
end

function UILLWorldMapTransportView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UILLWorldMapTransportView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UILLWorldMapTransportView:Update1000MS()
  if self.coolTime ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.coolTime - curTime
    if 0 < remainTime then
      self.textTips:SetText(Localization:GetString("458265") .. " " .. UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.textTips:SetLocalText(458044)
      self.coolTime = nil
    end
  end
end

function UILLWorldMapTransportView:OnCityMoveCoolDown()
  local isFree = false
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local nextFreeEndTime = DataCenter.LandlordMgr:GetFreeMoveInfoEndTime()
  if curTime > nextFreeEndTime then
    isFree = true
  else
    self.coolTime = nextFreeEndTime
  end
  self.textTips:SetActive(true)
  if isFree then
    self.textTips:SetLocalText(458044)
  else
    self.textTips:SetText("")
    self:Update1000MS()
  end
end

return UILLWorldMapTransportView
