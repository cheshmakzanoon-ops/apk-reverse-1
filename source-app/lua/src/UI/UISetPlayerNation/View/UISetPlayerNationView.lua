local base = UIBaseView
local UISetPlayerNationView = BaseClass("UISetPlayerNationView", base)
local Localization = CS.GameEntry.Localization
local SetPlayerNationItem = require("UI.UISetPlayerNation.Component.SetPlayerNationItem")
local title_path = "Root/Content/UICommonPopBg/bg_3/TitleTxt"
local close_btn_path = "Panel"
local return_btn_path = "Root/Content/UICommonPopBg/bg_3/CloseBtn"
local svNation_path = "Root/Content/ImgBg/ScrollView"
local content_path = "Root/Content/ImgBg/ScrollView/Content"
local confirmBtn_path = "Root/Content/ImgBg/confirmBtn"
local confirmBtnTxt_path = "Root/Content/ImgBg/confirmBtn/confirmBtnTxt"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:RefreshAll()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.titleN = self:AddComponent(UIText, title_path)
  self.titleN:SetLocalText(143589)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.svNationN = self:AddComponent(UIBaseContainer, svNation_path)
  self.contentN = self:AddComponent(GridInfinityScrollView, content_path)
  local bindFunc1 = BindCallback(self, self.OnInitScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
  self.contentN:Init(bindFunc1, bindFunc2, bindFunc3)
  self.confirmBtnN = self:AddComponent(UIButton, confirmBtn_path)
  self.confirmBtnN:SetOnClick(function()
    self:OnClickConfirmBtn()
  end)
  self.confirmBtnTxtN = self:AddComponent(UIText, confirmBtnTxt_path)
  self.confirmBtnTxtN:SetLocalText(110006)
end

local function ComponentDestroy(self)
  self.titleN = nil
  self.close_btn = nil
  self.return_btn = nil
  self.svNationN = nil
  self.contentN = nil
  self.confirmBtnN = nil
  self.confirmBtnTxtN = nil
end

local function DataDefine(self)
  self.nationItems = {}
  self.nationList = nil
  self.curSelected = nil
end

local function DataDestroy(self)
  self.nationList = nil
  self.nationItems = nil
  self.curSelected = nil
end

local function RefreshAll(self)
  local param = self:GetUserData()
  self.cacheNation = param and param.nation or nil
  local tempNation = param and param.nation and param.nation or DefaultNation
  local nationTemplate = DataCenter.NationTemplateManager:GetNationTemplate(tempNation)
  self.curSelected = nationTemplate.nation
  self.selectCallBack = param and param.callback and param.callback or nil
  self.nationList = self.ctrl:GetAllNationsSorted()
  self.contentN:SetItemCount(#self.nationList)
end

local function OnInitScroll(self, go, index)
  local item = self.svNationN:AddComponent(SetPlayerNationItem, go)
  self.nationItems[go] = item
end

local function OnUpdateScroll(self, go, index)
  local nation = self.nationList[index + 1]
  go.name = nation.nation
  local cellItem = self.nationItems[go]
  if not cellItem then
    return
  end
  cellItem:SetItem(nation, self.curSelected)
end

local function OnDestroyScrollItem(self, go, index)
end

local function OnSelectNation(self, nationType)
  self.curSelected = nationType
  for i, v in pairs(self.nationItems) do
    v:RefreshSelectStatus(self.curSelected)
  end
end

local function OnClickConfirmBtn(self)
  if self.cacheNation ~= self.curSelected and self.selectCallBack then
    self.selectCallBack(self.curSelected)
  end
  self.ctrl:CloseSelf()
end

UISetPlayerNationView.OnCreate = OnCreate
UISetPlayerNationView.OnDestroy = OnDestroy
UISetPlayerNationView.ComponentDefine = ComponentDefine
UISetPlayerNationView.ComponentDestroy = ComponentDestroy
UISetPlayerNationView.DataDefine = DataDefine
UISetPlayerNationView.DataDestroy = DataDestroy
UISetPlayerNationView.RefreshAll = RefreshAll
UISetPlayerNationView.OnInitScroll = OnInitScroll
UISetPlayerNationView.OnUpdateScroll = OnUpdateScroll
UISetPlayerNationView.OnDestroyScrollItem = OnDestroyScrollItem
UISetPlayerNationView.OnSelectNation = OnSelectNation
UISetPlayerNationView.OnClickConfirmBtn = OnClickConfirmBtn
return UISetPlayerNationView
