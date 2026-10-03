local WorldAllianceBuildAttackInfo = BaseClass("WorldAllianceBuildAttackInfo", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local btn_info_path = "btnInfo"
local attack1_path = "content/attack1"
local name1_path = "content/attack1/name1"
local slider1_path = "content/attack1/Slider1"
local txt_num1_path = "content/attack1/Txt_Num1"
local attack2_path = "content/attack2"
local name2_path = "content/attack2/name2"
local slider2_path = "content/attack2/Slider2"
local txt_num2_path = "content/attack2/Txt_Num2"
local attack3_path = "content/attack3"
local name3_path = "content/attack3/name3"
local slider3_path = "content/attack3/Slider3"
local txt_num3_path = "content/attack3/Txt_Num3"

function WorldAllianceBuildAttackInfo:OnCreate()
  base.OnCreate(self)
  self.btn_info = self:AddComponent(UIButton, btn_info_path)
  self.attack1 = self:AddComponent(UIBaseContainer, attack1_path)
  self.name1 = self:AddComponent(UITextMeshProUGUIEx, name1_path)
  self.slider1 = self:AddComponent(UISlider, slider1_path)
  self.txt_num1 = self:AddComponent(UITextMeshProUGUIEx, txt_num1_path)
  self.attack2 = self:AddComponent(UIBaseContainer, attack2_path)
  self.name2 = self:AddComponent(UITextMeshProUGUIEx, name2_path)
  self.slider2 = self:AddComponent(UISlider, slider2_path)
  self.txt_num2 = self:AddComponent(UITextMeshProUGUIEx, txt_num2_path)
  self.attack3 = self:AddComponent(UIBaseContainer, attack3_path)
  self.name3 = self:AddComponent(UITextMeshProUGUIEx, name3_path)
  self.slider3 = self:AddComponent(UISlider, slider3_path)
  self.txt_num3 = self:AddComponent(UITextMeshProUGUIEx, txt_num3_path)
  self.btn_info:SetOnClick(function()
    local param = {}
    param.type = "desc"
    param.title = ""
    param.desc = "season_s2_faction_war_97"
    param.alignObject = self.btn_info
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  end)
end

function WorldAllianceBuildAttackInfo:OnDestroy()
  self.btn_info = nil
  self.attack1 = nil
  self.name1 = nil
  self.slider1 = nil
  self.txt_num1 = nil
  self.attack2 = nil
  self.name2 = nil
  self.slider2 = nil
  self.txt_num2 = nil
  self.attack3 = nil
  self.name3 = nil
  self.slider3 = nil
  self.txt_num3 = nil
  base.OnDestroy(self)
end

function WorldAllianceBuildAttackInfo:ReInit(data, lineNode, maxHp)
  if data and 0 < #data then
    self:SetAttackValue(data[1], self.attack1, self.name1, self.slider1, self.txt_num1, maxHp)
    self:SetAttackValue(data[2], self.attack2, self.name2, self.slider2, self.txt_num2, maxHp)
    self:SetAttackValue(data[3], self.attack3, self.name3, self.slider3, self.txt_num3, maxHp)
    self:SetActive(true)
    lineNode:SetActive(true)
  else
    self:SetActive(false)
    lineNode:SetActive(false)
  end
end

function WorldAllianceBuildAttackInfo:SetAttackValue(data, rootNode, name, slider, txt_num, maxHp)
  if data == nil then
    rootNode:SetActive(false)
  else
    rootNode:SetActive(true)
    name:SetText(UIUtil.FormatServerAllianceName(data.serverId, data.abbr, data.name))
    if maxHp ~= 0 then
      slider:SetValue(toInt(data.score) / maxHp)
    else
      slider:SetValue(0)
    end
    txt_num:SetText(string.GetFormattedSeparatorNum(data.score or 0))
  end
end

return WorldAllianceBuildAttackInfo
