local UILWMailListSearchRecordItem = BaseClass("UILWMailListSearchRecordItem", UIBaseContainer)
local base = UIBaseContainer
local filter_name_path = "FilterName"
local bg_path = "Bg"
local bg2_path = "Bg2"
local select_btn_path = "SelectBtn"

function UILWMailListSearchRecordItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailListSearchRecordItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailListSearchRecordItem:ComponentDefine()
  self.filter_name = self:AddComponent(UITextMeshProUGUIEx, filter_name_path)
  self.bg_go = self:AddComponent(UIBaseContainer, bg_path)
  self.bg2_go = self:AddComponent(UIBaseContainer, bg2_path)
  self.select_btn = self:AddComponent(UIButton, select_btn_path)
  self.select_btn:SetOnClick(function()
    if self.selectFunc then
      self.selectFunc(self.index, self.data)
    end
  end)
end

function UILWMailListSearchRecordItem:ComponentDestroy()
  self.filter_name = nil
  self.bg_go = nil
  self.bg2_go = nil
  self.select_btn = nil
end

function UILWMailListSearchRecordItem:DataDefine()
end

function UILWMailListSearchRecordItem:DataDestroy()
end

function UILWMailListSearchRecordItem:OnEnable()
  base.OnEnable(self)
end

function UILWMailListSearchRecordItem:OnDisable()
  base.OnDisable(self)
end

function UILWMailListSearchRecordItem:OnAddListener()
end

function UILWMailListSearchRecordItem:OnRemoveListener()
end

function UILWMailListSearchRecordItem:RefreshView(index, data, selectFunc)
  self.index = index
  self.data = data
  self.selectFunc = selectFunc
  self.bg_go:SetActive(index % 2 == 0)
  self.bg2_go:SetActive(index % 2 ~= 0)
  self.filter_name:SetText(data)
end

return UILWMailListSearchRecordItem
