local base = UIBaseContainer
local SeasonFarmerConvertItem = BaseClass("SeasonFarmerConvertItem", base)
local Localization = CS.GameEntry.Localization
local ConditionType = {
  Force = 1,
  City = 2,
  Point = 3,
  Other = 4,
  PowerNum = 5
}
local DesText_path = ""
local Toggle_path = "checkBox"
local BtnHelp_path = "help"
local line_path = "line"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.DesText = self:AddComponent(UIText, DesText_path)
  self.Toggle = self:AddComponent(UIToggle, Toggle_path)
  self.BtnHelp = self:AddComponent(UIButton, BtnHelp_path)
  self.line = self:AddComponent(UIBaseContainer, line_path)
  self.Toggle:SetOnValueChanged(function(isOn)
    self:OnToggleValueChanged(isOn)
  end)
  self.BtnHelp:SetOnClick(function()
    self:OnBtnHelpClick()
  end)
end

local function ComponentDestroy(self)
  self.DesText = nil
  self.Toggle = nil
  self.BtnHelp = nil
  self.line = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function ReInit(self, index, data, dataCount, callback)
  if data == nil then
    return
  end
  self.index = index
  self.data = data
  self.callback = callback
  self.Toggle:SetIsOn(data.result)
  self.DesText:SetText(CS.GameEntry.Localization:GetString(data.desc or 0, data.param or 0, data.configNum2 or ""))
  if data.result then
    self.DesText:SetColorRGBA(0.1647059, 0.1568628, 0.1882353, 1)
  else
    self.DesText:SetColorRGBA(0.9607843, 0.2352941, 0.2392157, 1)
  end
  self.line:SetActive(index ~= dataCount)
  self.BtnHelp:SetActive(data.type == ConditionType.Force or data.type == ConditionType.Point or data.type == ConditionType.PowerNum)
  if data.type == ConditionType.Force and LuaEntry.Player:IsInAlliance() then
    SFSNetwork.SendMessage(MsgDefines.GetSeasonForceValue, 1)
  end
end

local function OnToggleValueChanged(self, isOn)
  if isOn and not self.data.result then
    self.Toggle:SetIsOn(false)
    UIUtil.ShowTipsId("season_builders_alliance_tips_4")
    return
  end
  self.data.select = isOn
  if self.callback then
    self.callback(self.data)
  end
end

local function OnBtnHelpClick(self)
  if self.data.type == ConditionType.Force then
    local strTip = Localization:GetString("season_builders_alliance_tips_35", string.GetFormattedGoldNum(DataCenter.SeasonDataManager.allianceForceValue or 0))
    UIUtil.ShowBubbleTips(strTip, self.BtnHelp.transform.position, -30, -60, 0, nil, nil)
    return
  end
  if self.data.type == ConditionType.Point then
    local strongholdArr = self.data.serverStrongholdArr
    if table.IsNullOrEmpty(strongholdArr) then
      local strTip = Localization:GetString("season_stronghold_count", 0)
      UIUtil.ShowBubbleTips(strTip, self.BtnHelp.transform.position, -30, -60, 0, nil, nil)
      return
    end
    for i, v in ipairs(strongholdArr) do
      v.name = string.format("#%d", v.serverId)
      v.value = string.format("%d", v.num)
      v.height = 50
    end
    local parameter = {
      titleAlignment = CS.UnityEngine.TextAnchor.UpperCenter,
      comtentWidthAdd = 10,
      layoutShow = true,
      datalist = strongholdArr
    }
    UIUtil.ShowBubbleTips(nil, self.BtnHelp.transform.position, -30, -60, 120, nil, Localization:GetString("season_builders_alliance_tips_36"), parameter)
    return
  end
  if self.data.type == ConditionType.PowerNum then
    local strTip = Localization:GetString("season_builders_alliance_tips_41", self.data.currentNum or 0, self.data.configNum or 0)
    UIUtil.ShowBubbleTips(strTip, self.BtnHelp.transform.position, -30, -60, 0, nil, nil)
    return
  end
end

SeasonFarmerConvertItem.OnCreate = OnCreate
SeasonFarmerConvertItem.OnDestroy = OnDestroy
SeasonFarmerConvertItem.OnEnable = OnEnable
SeasonFarmerConvertItem.OnDisable = OnDisable
SeasonFarmerConvertItem.ComponentDefine = ComponentDefine
SeasonFarmerConvertItem.ComponentDestroy = ComponentDestroy
SeasonFarmerConvertItem.DataDefine = DataDefine
SeasonFarmerConvertItem.DataDestroy = DataDestroy
SeasonFarmerConvertItem.ReInit = ReInit
SeasonFarmerConvertItem.OnToggleValueChanged = OnToggleValueChanged
SeasonFarmerConvertItem.OnBtnHelpClick = OnBtnHelpClick
return SeasonFarmerConvertItem
