local p_btn_blur_path = "p_btn_blur"
local p_text_title_path = "Root/bg/title/Common_img_title/p_text_title"
local p_btn_close_path = "Root/bg/title/p_btn_close"
local p_text_desc_path = "Root/bg/content/p_text_desc"
local season_alliance_war_time_state_comp_path = "Root/bg/content/content_state/SeasonAllianceWarTimeStateComp"
local p_btn_cancel_path = "Root/bg/content/bottom/p_btn_cancel"
local p_text_cancel_path = "Root/bg/content/bottom/p_btn_cancel/LW_Btn_Common_New_Base/p_text_cancel"
local p_btn_confirm_path = "Root/bg/content/bottom/p_btn_confirm"
local p_text_confirm_path = "Root/bg/content/bottom/p_btn_confirm/LW_Btn_Common_New_Base/p_text_confirm"
local UILWSeasonAllianceWarTimeStateComp = require("UI/LWSeason5/UILWSeasonAllianceWarTime/Common/UILWSeasonAllianceWarTimeStateComp")
local base = UIBaseView
local SeasonAllianceWarTimeSetConfirmView = BaseClass("SeasonAllianceWarTimeSetConfirmView", UIBaseView)

function SeasonAllianceWarTimeSetConfirmView:ComponentDefine()
  self.p_btn_blur = self:AddComponent(UIButton, p_btn_blur_path)
  self.p_btn_blur:SetOnClick(BindCallback(self, self.OnCloseClicked))
  self.p_text_title = self:AddComponent(UITextMeshProUGUIEx, p_text_title_path)
  self.p_btn_close = self:AddComponent(UIButton, p_btn_close_path)
  self.p_btn_close:SetOnClick(BindCallback(self, self.OnCloseClicked))
  self.p_text_desc = self:AddComponent(UITextMeshProUGUIEx, p_text_desc_path)
  self.season_alliance_war_time_state_comp = self:AddComponent(UILWSeasonAllianceWarTimeStateComp, season_alliance_war_time_state_comp_path)
  self.p_btn_cancel = self:AddComponent(UIButton, p_btn_cancel_path)
  self.p_btn_cancel:SetOnClick(BindCallback(self, self.OnCancelClicked))
  self.p_text_cancel = self:AddComponent(UITextMeshProUGUIEx, p_text_cancel_path)
  self.p_btn_confirm = self:AddComponent(UIButton, p_btn_confirm_path)
  self.p_btn_confirm:SetOnClick(BindCallback(self, self.OnConfirmClicked))
  self.p_text_confirm = self:AddComponent(UITextMeshProUGUIEx, p_text_confirm_path)
end

function SeasonAllianceWarTimeSetConfirmView:ComponentDestroy()
  self.p_btn_blur = nil
  self.p_text_title = nil
  self.p_btn_close = nil
  self.p_text_desc = nil
  self.season_alliance_war_time_state_comp = nil
  self.p_btn_cancel = nil
  self.p_text_cancel = nil
  self.p_btn_confirm = nil
  self.p_text_confirm = nil
end

function SeasonAllianceWarTimeSetConfirmView:DataDefine()
end

function SeasonAllianceWarTimeSetConfirmView:DataDestroy()
  self.Data = nil
end

function SeasonAllianceWarTimeSetConfirmView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit(self:GetUserData())
end

function SeasonAllianceWarTimeSetConfirmView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonAllianceWarTimeSetConfirmView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonAllianceWarTimePush, self.OnWarTimeUpdate)
end

function SeasonAllianceWarTimeSetConfirmView:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonAllianceWarTimePush, self.OnWarTimeUpdate)
  base.OnRemoveListener(self)
end

function SeasonAllianceWarTimeSetConfirmView:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    self:Update1000MS()
  end
end

function SeasonAllianceWarTimeSetConfirmView:InitData(data)
  if data ~= nil then
    self.Data = data
    self.EndTime = UITimeManager:GetInstance():GetServerSeconds() + 10
    self.TickAct = true
    return true
  end
  return false
end

function SeasonAllianceWarTimeSetConfirmView:InitUi()
  self.p_text_title:SetLocalText("s5_alliance_battle_time_ui52")
  self.p_text_cancel:SetLocalText(GameDialogDefine.CANCEL)
  local severInfo = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  if severInfo ~= nil then
    if severInfo:InPreviewMode() then
      self.p_text_desc:SetLocalText("s5_alliance_battle_time_ui43")
    else
      self.p_text_desc:SetLocalText("s5_alliance_battle_time_ui13")
    end
  end
  local data = {}
  data.TimeIndex = self.Data.TimeIndex
  data.SetTime = 0
  data.PreviewMode = true
  self.season_alliance_war_time_state_comp:ReInit(data)
end

function SeasonAllianceWarTimeSetConfirmView:OnCloseClicked()
  self.ctrl:CloseSelf()
end

function SeasonAllianceWarTimeSetConfirmView:OnConfirmClicked()
  if self.Data ~= nil then
    if UITimeManager:GetInstance():GetServerSeconds() < checknumber(self.EndTime) then
      return
    end
    DataCenter.UILWSeasonAllianceWarTimeManager:SendSetTime(self.Data.TimeIndex)
  end
end

function SeasonAllianceWarTimeSetConfirmView:OnCancelClicked()
  self.ctrl:CloseSelf()
end

function SeasonAllianceWarTimeSetConfirmView:OnWarTimeUpdate(evtData)
  if evtData ~= nil and evtData.AllianceId == LuaEntry.Player.allianceId then
    self.ctrl:CloseSelf()
  end
end

function SeasonAllianceWarTimeSetConfirmView:Update1000MS()
  if self.TickAct then
    local leftTime = math.max(0, self.EndTime - UITimeManager:GetInstance():GetServerSeconds())
    if 0 < leftTime then
      local text = CS.GameEntry.Localization:GetString("s5_alliance_battle_time_ui53") .. " (" .. math.floor(leftTime) .. ")"
      self.p_text_confirm:SetText(text)
      CS.UIGray.SetGray(self.p_btn_confirm.transform, true, false)
    else
      self.TickAct = false
      self.p_text_confirm:SetLocalText("s5_alliance_battle_time_ui53")
      CS.UIGray.SetGray(self.p_btn_confirm.transform, false, true)
    end
  end
end

return SeasonAllianceWarTimeSetConfirmView
