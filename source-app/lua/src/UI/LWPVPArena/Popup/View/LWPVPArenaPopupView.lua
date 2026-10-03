local LWPVPArenaPopupView = BaseClass("LWPVPArenaPopupView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local compBook = {
  {
    path = "txtTitle",
    name = "txtTitle",
    type = UIText
  },
  {
    path = "txtSub",
    name = "txtSub",
    type = UIText
  },
  {
    path = "btnGo/txtBtnGo",
    name = "txtBtnGo",
    type = UIText
  },
  {
    path = "btnGo",
    name = "btnGo",
    type = UIButton
  },
  {
    path = "btnBack",
    name = "btnBack",
    type = UIButton
  }
}

function LWPVPArenaPopupView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWPVPArenaPopupView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWPVPArenaPopupView:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function LWPVPArenaPopupView:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.txtBtnGo:SetText(Localization:GetString("110003"))
  self.txtTitle:SetText(Localization:GetString("801100"))
  self.txtSub:SetText(Localization:GetString("801101", tostring(self:GetUserData())))
  self.btnBack:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btnGo:SetOnClick(function()
    local state = DataCenter.LWPVPArenaManager.state
    if state == PVPArenaState.Invalide then
      local newbieArenaV2State = DataCenter.LWNewbieArenaV2Manager:GetState()
      if newbieArenaV2State ~= ActivityArenaState.None then
        DataCenter.LWPVPArenaManager.ShowPVPArenaMain(PVPArenaType.NewbieArenaV2, nil)
        self.ctrl:CloseSelf()
        return
      end
      local newbieArenaState = DataCenter.LWNewbieArenaManager:GetState()
      if newbieArenaState ~= ActivityArenaState.None then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityCenterTable, {
          anim = true,
          UIMainAnim = UIMainAnimType.AllHide
        }, DataCenter.LWNewbieArenaManager:GetArenaInfoId())
        self.ctrl:CloseSelf()
      else
        UIUtil.ShowTipsId(801141)
      end
    else
      DataCenter.LWPVPArenaManager.ShowPVPArenaMain(PVPArenaType.PeakArena, nil)
      self.ctrl:CloseSelf()
    end
  end)
end

return LWPVPArenaPopupView
