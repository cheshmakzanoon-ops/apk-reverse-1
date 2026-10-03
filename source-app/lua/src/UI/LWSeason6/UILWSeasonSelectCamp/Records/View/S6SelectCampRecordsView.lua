local p_btn_blur_path = "p_btn_blur"
local p_text_title_path = "Root/bg/title/Common_img_title/p_text_title"
local p_btn_close_path = "Root/bg/title/p_btn_close"
local p_list_view_path = "Root/bg/content/bg/p_listView"
local UILoopListViewSimple = require("Framework.UI.Component.UILoopListViewSimple")
local S6SelectCampRecordsCell = require("UI.LWSeason6.UILWSeasonSelectCamp.Records.Comp.S6SelectCampRecordsCell")
local base = UIBaseView
local S6SelectCampRecordsView = BaseClass("S6SelectCampRecordsView", UIBaseView)

function S6SelectCampRecordsView:ComponentDefine()
  self.p_btn_blur = self:AddComponent(UIButton, p_btn_blur_path)
  self.p_btn_blur:SetOnClick(BindCallback(self, self.CloseSelf))
  self.p_text_title = self:AddComponent(UITextMeshProUGUIEx, p_text_title_path)
  self.p_btn_close = self:AddComponent(UIButton, p_btn_close_path)
  self.p_btn_close:SetOnClick(BindCallback(self, self.CloseSelf))
  self.p_list_view = self:AddComponent(UILoopListViewSimple, p_list_view_path)
end

function S6SelectCampRecordsView:ComponentDestroy()
  self.p_list_view:Clear()
  self.p_btn_blur = nil
  self.p_text_title = nil
  self.p_btn_close = nil
  self.p_list_view = nil
end

function S6SelectCampRecordsView:DataDefine()
end

function S6SelectCampRecordsView:DataDestroy()
  self.Data = nil
end

function S6SelectCampRecordsView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit(self:GetUserData())
end

function S6SelectCampRecordsView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function S6SelectCampRecordsView:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function S6SelectCampRecordsView:InitData(data)
  local info = DataCenter.SeasonSelectCampManager.InfoData
  if info ~= nil then
    self.Records = info.Records
    return true
  end
  return false
end

function S6SelectCampRecordsView:InitUi()
  self.p_list_view:Init(S6SelectCampRecordsCell)
  self.p_list_view:Clear()
  for _, record in ipairs(self.Records) do
    local recordData = {}
    recordData.Record = record
    self.p_list_view:AddData(recordData)
  end
  self.p_list_view:Show()
end

function S6SelectCampRecordsView:CloseSelf()
  self.ctrl:CloseSelf()
end

return S6SelectCampRecordsView
