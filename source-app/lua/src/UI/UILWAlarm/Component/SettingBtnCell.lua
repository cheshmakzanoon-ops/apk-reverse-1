local SettingBtnCell = BaseClass("SettingBtnCell", UIBaseContainer)
local base = UIBaseContainer

function SettingBtnCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SettingBtnCell:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function SettingBtnCell:OnEnable()
  base.OnEnable(self)
end

function SettingBtnCell:OnDisable()
  base.OnDisable(self)
end

function SettingBtnCell:ComponentDefine()
  self.btn = self:AddComponent(UIButton, "BG")
  self.btnIcon = self:AddComponent(UIImage, "BG/check")
  self.title = self:AddComponent(UIText, "title")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function SettingBtnCell:OnBtnClick()
  self.isOn = not self.isOn
  self.btnIcon:SetActive(self.isOn)
  CommonUtil.PlayerPrefsSetBool(self.param.key, self.isOn)
  DataCenter.DefenceWallDataManager:RefreshScoutAlarmIsOn()
  EventManager:GetInstance():Broadcast(self.param.eventId)
end

function SettingBtnCell:ReInit(param)
  self.param = param
  self.isOn = CommonUtil.PlayerPrefsGetBool(param.key, true)
  self.btnIcon:SetActive(self.isOn)
  self.title:SetLocalText(self.param.language)
end

function SettingBtnCell:ComponentDestroy()
  self.btn = nil
  self.btnIcon = nil
  self.title = nil
end

function SettingBtnCell:DataDefine()
  self.param = {}
end

function SettingBtnCell:DataDestroy()
  self.param = nil
  self.isOn = nil
end

return SettingBtnCell
