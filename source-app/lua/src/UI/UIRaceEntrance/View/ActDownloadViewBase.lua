local base = UIBaseView
local ActDownloadViewBase = BaseClass("ActDownloadViewBase", base)
local ActDownloadContentBase = require("UI.UIRaceEntrance.Component.ActDownloadContentBase")
local btn_back_path = "Root/Bottom/BtnBack"
local text_title_path = "Root/TopBar/TextTitle"
local root_path = "Root/CenterView"

function ActDownloadViewBase:OnCreate()
  base.OnCreate(self)
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.text_title = self:AddComponent(UITextMeshProUGUIEx, text_title_path)
  self.actDCBase = self:AddComponent(ActDownloadContentBase, root_path)
  self.actDCBase:SetLoadFinishCb(BindCallback(self, self.LoadActFinish))
  self:EntranceReEnter()
end

function ActDownloadViewBase:OnDestroy()
  self.btn_back = nil
  self.actDCBase = nil
  base.OnDestroy(self)
end

function ActDownloadViewBase:SetData(activityId)
  self.actDCBase:SetData(activityId)
end

function ActDownloadViewBase:EntranceReEnter()
  self.actDCBase:EntranceReEnter()
end

function ActDownloadViewBase:SetRootCP(cls, prefab)
  self.actDCBase:SetRootCP(cls, prefab)
end

function ActDownloadViewBase:OnBtnBackClick()
end

function ActDownloadViewBase:LoadActFinish()
end

function ActDownloadViewBase.getters:compAct()
  return self.actDCBase.compAct
end

return ActDownloadViewBase
