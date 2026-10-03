local UIMainLLGroupInvitationBtn = BaseClass("UIMainLLGroupInvitationBtn", UIButton)
local base = UIButton
local Localization = CS.GameEntry.Localization

function UIMainLLGroupInvitationBtn:OnCreate()
  base.OnCreate(self)
  self:SetOnClick(function()
    local flag = DataCenter.LandlordMgr:CheckBeInvited()
    if flag then
      DataCenter.LandlordMgr:ReqServerGetInvitedInfo()
    end
  end)
  self.time_text = self:AddComponent(UITextMeshProUGUIEx, "TimeText")
  self.time_text:SetActive(false)
end

function UIMainLLGroupInvitationBtn:OnDestroy()
  self.endTime = nil
  base.OnDestroy(self)
end

function UIMainLLGroupInvitationBtn:Refresh()
  local flag, time = DataCenter.LandlordMgr:CheckBeInvited()
  self.time_text:SetText("")
  if not flag then
    self.endTime = nil
    self:SetActive(false)
    return
  end
  self.endTime = time
  self:SetActive(true)
end

return UIMainLLGroupInvitationBtn
