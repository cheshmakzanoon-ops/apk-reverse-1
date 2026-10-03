local HeatSourcePage = BaseClass("HeatSourcePage", UIBaseContainer)
local base = UIBaseContainer
local HeatSourceCell = require("UI.LWSeason2.UITemperatureMain.Component.HeatSourceCell")
local tip_btn_path = "top/tipBtn"
local tip_text_path = "top/tipText"
local tip_temp_path = "top/tipTemp"

function HeatSourcePage:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function HeatSourcePage:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function HeatSourcePage:ComponentDefine()
  self.content = self:AddComponent(UIBaseContainer, "ViewPort/Content")
  self.toggle = self:AddComponent(UIToggle, "toggle")
  self.toggle:SetOnValueChanged(function(bool)
    Setting:SetBool("HIDE_BASE_TEMPERATURE", bool)
    EventManager:GetInstance():Broadcast(EventId.HideBaseTemperature, bool)
  end)
  local toggleText = self:AddComponent(UITextMeshProUGUIEx, "toggle/toggleText")
  toggleText:SetLocalText("season_s2_temperature_ui_status06")
  self.tip_btn = self:AddComponent(UIButton, tip_btn_path)
  self.tip_btn:SetOnClick(function()
    local content = CS.GameEntry.Localization:GetString("season_s2_temperature_ui_info03")
    UIUtil.ShowBubbleTips(content, self.tip_btn.transform.position, 0, -30, 53)
  end)
  local tip_text = self:AddComponent(UITextMeshProUGUIEx, tip_text_path)
  tip_text:SetLocalText("season_s2_temperature_ui_status05")
  self.tip_temp = self:AddComponent(UITextMeshProUGUIEx, tip_temp_path)
end

function HeatSourcePage:ComponentDestroy()
end

function HeatSourcePage:Refresh()
  self:RemoveCells()
  local data = DataCenter.TemperatureManager:GetAllHeatSourceAffectMe()
  for k, v in pairs(data) do
    self.reqs[k] = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWSeason2/HeatSourceCell.prefab", function(req)
      if IsNull(req.gameObject) then
        return
      end
      local item = req.gameObject
      NameCount = NameCount + 1
      item.name = "HeatSourceCell" .. NameCount
      item.transform:SetParent(self.content.transform)
      item.transform:Set_localScale(1, 1, 1)
      local obj = self.content:AddComponent(HeatSourceCell, item.name)
      obj:SetData(v)
    end)
  end
  local toggleState = Setting:GetBool("HIDE_BASE_TEMPERATURE", false)
  self.toggle:SetIsOn(toggleState)
  local myTileTemp = DataCenter.TemperatureManager:GetMyEnvTemperature()
  self.tip_temp:SetLocalText("season_s2_common_temperature", string.format("%.1f", myTileTemp))
end

function HeatSourcePage:RemoveCells()
  self.content:RemoveComponents(HeatSourceCell)
  if self.reqs then
    for _, v in pairs(self.reqs) do
      v:Destroy()
    end
  end
  self.reqs = {}
end

return HeatSourcePage
