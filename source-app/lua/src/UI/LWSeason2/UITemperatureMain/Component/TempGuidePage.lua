local TempGuidePage = BaseClass("TempGuidePage", UIBaseContainer)
local base = UIBaseContainer
local warm_node_path = "toggle/warmNode"
local warm_desc_path = "toggle/warmNode/warmDesc"
local warm_btn_path = "toggle/warmBtn"
local warm_btn_txt_path = "toggle/warmBtn/warmBtnTxt"
local cold_node_path = "toggle/coldNode"
local cold_desc_path = "toggle/coldNode/coldDesc"
local cold_btn_path = "toggle/coldBtn"
local cold_btn_txt_path = "toggle/coldBtn/coldBtnTxt"
local scroll_path = "Scroll"
local content_path = "Scroll/ViewPort/Content"
local warm_toggle_path = "toggle/warmNode/warmToggle"
local cold_toggle_path = "toggle/coldNode/coldToggle"
local TabType = {Warm = 1, Cold = 2}
local TempGuideCell = require("UI.LWSeason2.UITemperatureMain.Component.TempGuideCell")

function TempGuidePage:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function TempGuidePage:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TempGuidePage:DataDefine()
  local data = {
    [TabType.Warm] = {},
    [TabType.Cold] = {}
  }
  local config = DataCenter.SeasonDataManager:GetSeasonConfig()
  if config then
    if not string.IsNullOrEmpty(config.hint_2) then
      for item in string.gmatch(config.hint_2, "([^|]+)|?") do
        local index, theType, img, title, desc = string.match(item, "([^;]+);([^;]+);([^;]+);([^;]+);([^;]+)")
        if index and theType and img and title and desc and (theType == "1" or theType == "2") then
          table.insert(data[TabType.Warm], {
            index,
            theType,
            img,
            title,
            desc
          })
        end
      end
    end
    if not string.IsNullOrEmpty(config.hint_3) then
      for item in string.gmatch(config.hint_3, "([^|]+)|?") do
        local index, theType, img, title, desc = string.match(item, "([^;]+);([^;]+);([^;]+);([^;]+);([^;]+)")
        if index and theType and img and title and desc and (theType == "1" or theType == "2") then
          table.insert(data[TabType.Cold], {
            index,
            theType,
            img,
            title,
            desc
          })
        end
      end
    end
  end
  self.data = data
end

function TempGuidePage:DataDestroy()
  self.data = {}
end

function TempGuidePage:ComponentDefine()
  self.node = {}
  self.node[TabType.Warm] = self:AddComponent(UIImage, warm_node_path)
  self.node[TabType.Warm]:SetActive(false)
  local warm_desc = self:AddComponent(UITextMeshProUGUIEx, warm_desc_path)
  warm_desc:SetLocalText("season_s2_temperature_ui_tips02")
  local warm_btn = self:AddComponent(UIButton, warm_btn_path)
  warm_btn:SetOnClick(function()
    self:ClickTab(TabType.Warm)
  end)
  local warm_btn_txt = self:AddComponent(UITextMeshProUGUIEx, warm_btn_txt_path)
  warm_btn_txt:SetLocalText("season_s2_temperature_ui_tips01")
  self.node[TabType.Cold] = self:AddComponent(UIImage, cold_node_path)
  self.node[TabType.Cold]:SetActive(false)
  local cold_desc = self:AddComponent(UITextMeshProUGUIEx, cold_desc_path)
  cold_desc:SetLocalText("season_s2_temperature_ui_tips04")
  local cold_btn = self:AddComponent(UIButton, cold_btn_path)
  cold_btn:SetOnClick(function()
    self:ClickTab(TabType.Cold)
  end)
  local cold_btn_txt = self:AddComponent(UITextMeshProUGUIEx, cold_btn_txt_path)
  cold_btn_txt:SetLocalText("season_s2_temperature_ui_tips03")
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.warm_toggle = self:AddComponent(UIToggle, warm_toggle_path)
  self.warm_toggle:SetOnValueChanged(function(bool)
    Setting:SetBool("HIDE_OVERHEAT_BUBBLE", bool)
  end)
  self.cold_toggle = self:AddComponent(UIToggle, cold_toggle_path)
  self.cold_toggle:SetOnValueChanged(function(bool)
    Setting:SetBool("HIDE_FREEZE_BUBBLE", bool)
  end)
end

function TempGuidePage:ComponentDestroy()
  self.warm_toggle = nil
  self.cold_toggle = nil
end

function TempGuidePage:ClickTab(tab)
  if self.curTab == tab then
    return
  end
  if self.curTab then
    self.node[self.curTab]:SetActive(false)
  end
  self.node[tab]:SetActive(true)
  self.curTab = tab
  self:RefreshTab()
end

function TempGuidePage:Refresh()
  local cold_toggleState = Setting:GetBool("HIDE_FREEZE_BUBBLE", false)
  self.cold_toggle:SetIsOn(cold_toggleState)
  local warm_toggleState = Setting:GetBool("HIDE_OVERHEAT_BUBBLE", false)
  self.warm_toggle:SetIsOn(warm_toggleState)
  local conductor = DataCenter.TemperatureManager:GetMyBaseConductor()
  if conductor and (conductor.phase == ThermalPhase.Fire or conductor.nextPhase == ThermalPhase.Fire) then
    self:ClickTab(TabType.Cold)
  else
    self:ClickTab(TabType.Warm)
  end
end

function TempGuidePage:RefreshTab()
  self:RemoveCells()
  for k, v in pairs(self.data[self.curTab]) do
    self.reqs[k] = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWSeason2/TempGuideCell.prefab", function(req)
      if IsNull(req.gameObject) then
        return
      end
      local item = req.gameObject
      item.name = "TempGuideCell" .. k
      item.transform:SetParent(self.content.transform)
      item.transform:Set_localScale(1, 1, 1)
      local obj = self.content:AddComponent(TempGuideCell, item.name)
      obj:SetData(v)
    end)
  end
end

function TempGuidePage:RemoveCells()
  self.content:RemoveComponents(TempGuideCell)
  if self.reqs then
    for _, v in pairs(self.reqs) do
      v:Destroy()
    end
  end
  self.reqs = {}
end

return TempGuidePage
