local UILWAlSelectLanguageCell = BaseClass("UILWAlSelectLanguageCell", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local this_path = ""
local select_go_path = "Common_duihao"
local des_path = "Name"

function UILWAlSelectLanguageCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlSelectLanguageCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlSelectLanguageCell:ComponentDefine()
  self.select_go = self:AddComponent(UIBaseContainer, select_go_path)
  self.des = self:AddComponent(UIText, des_path)
  self.btn = self:AddComponent(UIButton, this_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
end

function UILWAlSelectLanguageCell:ComponentDestroy()
  self.select_go = nil
  self.des = nil
  self.btn = nil
end

function UILWAlSelectLanguageCell:DataDefine()
  self.param = {}
end

function UILWAlSelectLanguageCell:DataDestroy()
  self.param = nil
end

function UILWAlSelectLanguageCell:OnEnable()
  base.OnEnable(self)
end

function UILWAlSelectLanguageCell:OnDisable()
  base.OnDisable(self)
end

function UILWAlSelectLanguageCell:OnAddListener()
  base.OnAddListener(self)
end

function UILWAlSelectLanguageCell:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWAlSelectLanguageCell:ReInit(param)
  self.param = param
  if param.name ~= nil then
    self.des:SetLocalText(param.name)
  end
  self:SetSelect(param.isSelect)
end

function UILWAlSelectLanguageCell:OnBtnClick()
  if self.param.callBack ~= nil then
    self.param.callBack(self.param.index)
  end
end

function UILWAlSelectLanguageCell:SetSelect(value)
  self.select_go:SetActive(value)
end

return UILWAlSelectLanguageCell
