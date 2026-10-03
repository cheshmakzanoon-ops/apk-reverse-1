local LWCommonScoreDetailView = BaseClass("LWCommonScoreDetailView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWCommonScoreDetailItem = require("UI.LWCommonScoreDetail.Component.LWCommonScoreDetailItem")
local panel_path = "panel"
local title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local desc_path = "PopUpTitle/ScrollView/Viewport/Content/desc"
local t1_path = "PopUpTitle/ScrollView/Viewport/Content/LWCommonScoreDetailItem/t1"
local t2_path = "PopUpTitle/ScrollView/Viewport/Content/LWCommonScoreDetailItem/t2"
local content_path = "PopUpTitle/ScrollView/Viewport/Content/items"

function LWCommonScoreDetailView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Refresh()
end

function LWCommonScoreDetailView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWCommonScoreDetailView:ComponentDefine()
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.desc_text = self:AddComponent(UIText, desc_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.content = self:AddComponent(UIBaseContainer, content_path)
end

function LWCommonScoreDetailView:ComponentDestroy()
  self:ClearList()
  self.close_btn1 = nil
  self.close_btn = nil
  self.title_text = nil
  self.desc_text = nil
end

function LWCommonScoreDetailView:DataDefine()
  self.dataList, self.title, self.desc = self:GetUserData()
end

function LWCommonScoreDetailView:DataDestroy()
  self.scoreList = nil
  self.title = nil
  self.desc = nil
end

function LWCommonScoreDetailView:Refresh()
  self:ClearList()
  self.title_text:SetLocalText(self.title)
  if string.IsNullOrEmpty(self.desc) then
    self.desc_text:SetActive(false)
  else
    self.desc_text:SetActive(true)
    self.desc_text:SetLocalText(self.desc)
  end
  if self.dataList then
    for i, data in ipairs(self.dataList) do
      self.scoreList[i] = self:GameObjectInstantiateAsync(UIAssets.LWCommonScoreDetailItem, function(request)
        local go = request.gameObject
        go.transform:SetParent(self.content.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.name = "LWCommonScoreDetailItem" .. i
        local newCell = self.content:AddComponent(LWCommonScoreDetailItem, go.name)
        newCell:SetData(i, data)
      end)
    end
  end
end

function LWCommonScoreDetailView:ClearList()
  self.content:RemoveComponents(LWCommonScoreDetailItem)
  if self.scoreList then
    for k, v in pairs(self.scoreList) do
      if v then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.scoreList = {}
end

return LWCommonScoreDetailView
