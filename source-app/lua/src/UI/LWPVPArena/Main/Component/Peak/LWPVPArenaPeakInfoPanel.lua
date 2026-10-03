local LWPVPArenaPeakRecordsPanel = BaseClass("LWPVPArenaPeakRecordsPanel", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local compBook = {
  {
    path = "txtTitle",
    name = "txtTitle",
    type = UIText
  },
  {
    path = "btnClose",
    name = "btnClose",
    type = UIButton
  },
  {
    path = "scrollContent/Viewport/Content",
    name = "txtContent",
    type = UIText
  },
  {
    path = "black",
    name = "btnBlack",
    type = UIButton
  }
}

function LWPVPArenaPeakRecordsPanel:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWPVPArenaPeakRecordsPanel:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWPVPArenaPeakRecordsPanel:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.btnClose:SetOnClick(function()
    if self.holder then
      self.holder:SetActive(false)
    end
  end)
  self.btnBlack:SetOnClick(function()
    if self.holder then
      self.holder:SetActive(false)
    end
  end)
end

function LWPVPArenaPeakRecordsPanel:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function LWPVPArenaPeakRecordsPanel:Refresh(titleID, contentID)
  self.txtTitle:SetText(Localization:GetString(titleID))
  self.txtContent:SetText(Localization:GetString(contentID))
end

return LWPVPArenaPeakRecordsPanel
