local base = UIBaseContainer
local CampSelectItem = BaseClass("CampSelectItem", base)
local Localization = CS.GameEntry.Localization
local icon_path = "icon"
local desc_path = "desc"
local btnCancel_path = "btnCancel"
local btnOk_path = "btnOk"

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
  self.icon = self:AddComponent(UIImage, icon_path)
  self.desc = self:AddComponent(UIText, desc_path)
  self.btnCancel = self:AddComponent(UIButton, btnCancel_path)
  self.btnOk = self:AddComponent(UIButton, btnOk_path)
  self.btnOk:SetOnClick(function()
    self:OnClick(true)
  end)
  self.btnCancel:SetOnClick(function()
    self:OnClick(false)
  end)
end

local function ComponentDestroy(self)
  self.icon = nil
  self.desc = nil
  self.btnCancel = nil
  self.btnOk = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function CampSelectItem:RefreshItem(data, index)
  self.data = data
  local meta = DataCenter.AllianceCityTemplateManager:GetTemplate(toInt(data.initiatorOriginalCityId), data.initiatorServerId)
  local cityName = meta and Localization:GetString(meta.name) or "-"
  local str = string.format("<color=#099b4a>#%s%s</color>", data.initiatorServerId, cityName)
  self.desc:SetLocalText("season_s4_camp_battle_09", str)
end

function CampSelectItem:OnClick(agree)
  if not DataCenter.CampWarManager:CanOperateAreaOverview(true) then
    return
  end
  if agree then
    local meta = DataCenter.AllianceCityTemplateManager:GetTemplate(toInt(self.data.initiatorOriginalCityId), self.data.initiatorServerId)
    local cityName = meta and Localization:GetString(meta.name) or "-"
    cityName = string.format("<color=#099b4a>%s</color>", cityName)
    local str = string.format("<color=#099b4a>#%s%s</color>", self.data.initiatorServerId, cityName)
    UIUtil.ShowSecondMessageByParam({
      titleText = Localization:GetString("season_s4_camp_battle_10"),
      tipText = Localization:GetString("season_s4_camp_battle_11", str, cityName),
      btnNum = 2,
      showToggle = false,
      sureAction = function()
        SFSNetwork.SendMessage(MsgDefines.CrossThroneStrategicAreaExchangeRespond, self.data.uuid, agree)
      end
    })
    return
  end
  SFSNetwork.SendMessage(MsgDefines.CrossThroneStrategicAreaExchangeRespond, self.data.uuid, agree)
end

CampSelectItem.OnCreate = OnCreate
CampSelectItem.OnDestroy = OnDestroy
CampSelectItem.OnEnable = OnEnable
CampSelectItem.OnDisable = OnDisable
CampSelectItem.ComponentDefine = ComponentDefine
CampSelectItem.ComponentDestroy = ComponentDestroy
CampSelectItem.DataDefine = DataDefine
CampSelectItem.DataDestroy = DataDestroy
return CampSelectItem
