local UIDesCell = BaseClass("UIDesCell", UIBaseContainer)
local base = UIBaseContainer
local des_name_path = "LayoutContent/AccelerateText"
local des_add_path = "LayoutContent/Content/AddValue"
local des_add_dur_path = "LayoutContent/Content/AddDur"
local des_cur_path = "LayoutContent/Content/CurValue"

function UIDesCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIDesCell:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIDesCell:OnEnable()
  base.OnEnable(self)
end

function UIDesCell:OnDisable()
  base.OnDisable(self)
end

function UIDesCell:ComponentDefine()
  self.des_name = self:AddComponent(UIText, des_name_path)
  self.des_add = self:AddComponent(UIText, des_add_path)
  self.des_cur = self:AddComponent(UIText, des_cur_path)
  self.des_add_dur = self:AddComponent(UIBaseContainer, des_add_dur_path)
  self.des_bg = self:AddComponent(UIImage, "Image")
  self.btn = self:AddComponent(UIButton, "LayoutContent/Content/Btn")
  self.btn:SetOnClick(function()
    self:OnClickBtn()
  end)
end

function UIDesCell:ComponentDestroy()
  self.des_name = nil
  self.des_add = nil
  self.des_cur = nil
  self.line = nil
  self.des_add_dur = nil
  self.des_bg = nil
end

function UIDesCell:DataDefine()
  self.param = {}
end

function UIDesCell:DataDestroy()
  self.param = nil
end

function UIDesCell:ReInit(param)
  self.param = param
  self.des_name:SetText(param.name)
  if param.addValue == nil then
    self.des_add:SetActive(false)
  else
    self.des_add:SetActive(true)
    self.des_add:SetText(param.addValue)
  end
  if param.addValue == nil or param.curValue == nil then
    self.des_add_dur:SetActive(false)
  else
    self.des_add_dur:SetActive(true)
  end
  if param.curValue == nil then
    self.des_cur:SetActive(false)
  else
    self.des_cur:SetActive(true)
    self.des_cur:SetText(param.curValue)
  end
  self.des_bg:SetActive(param.index % 2 ~= 0)
  self.btn:SetActive(param.extra)
end

function UIDesCell:OnClickBtn()
  self.view:ShowTip(self.param.extra, self.btn.transform.position)
end

return UIDesCell
