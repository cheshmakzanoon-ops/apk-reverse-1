local UILWMummyInfoTipS5 = BaseClass("UILWMummyInfoTipS5", UICanvasGroup)
local UILWMummyInfoTipCellS5 = require("UI.LWSeason5.UILWMummyS5.UILWMummyMainS5.Component.UILWMummyInfoTipCellS5")
local base = UICanvasGroup
local cellInfo = {
  [1] = {
    path = "Assets/Main/Sprites/UI/UIMain/LWMainUINew/cfm_zhujiemian_tubiao_zhanli.png",
    text = 100644
  },
  [2] = {
    path = "Assets/Main/Sprites/UI/UIPveBattleBuff/UIexplore_icon_skill.png",
    text = 211240,
    tipId = "soldier_attr_02"
  },
  [3] = {
    path = "Assets/Main/Sprites/ItemIcons/lyp_bingying_fuzhong.png",
    text = 220357,
    tipId = "soldier_attr_03"
  },
  [4] = {
    path = "Assets/Main/Sprites/UI/UIPveBattleBuff/UIBattleBuff_att_hp.png",
    text = 220357,
    tipId = "soldier_attr_04"
  },
  [5] = {
    path = "Assets/Main/Sprites/UI/UIPveBattleBuff/UIexplore_icon_attack.png",
    text = 152019,
    tipId = "soldier_attr_05"
  },
  [6] = {
    path = "Assets/Main/Sprites/UI/UIPveBattleBuff/UIexplore_icon_2.png",
    text = 152020,
    tipId = "soldier_attr_06"
  }
}
local tip_path = "Tip"
local skill_path = "Tip/skill"
local icon1_path = "Tip/skill/s1/icon1"
local icon2_path = "Tip/skill/s2/icon2"
local icon3_path = "Tip/skill/s3/icon3"
local icon4_path = "Tip/skill/s4/icon4"
local icon5_path = "Tip/skill/s5/icon5"

function UILWMummyInfoTipS5:OnCreate()
  base.OnCreate(self)
  self.tip = self:AddComponent(UIImage, tip_path)
  self.skill = self:AddComponent(UIBaseContainer, skill_path)
  self.icon1 = self:AddComponent(UIButton, icon1_path)
  self.icon2 = self:AddComponent(UIButton, icon2_path)
  self.icon3 = self:AddComponent(UIButton, icon3_path)
  self.icon4 = self:AddComponent(UIButton, icon4_path)
  self.icon5 = self:AddComponent(UIButton, icon5_path)
  self.hide_btn1 = self:AddComponent(UIButton, "")
  self.hide_btn2 = self:AddComponent(UIButton, "HideBtn")
  self.hide_btn1:SetOnClick(function()
    if self.theCallback then
      pcall(self.theCallback, self.theTarget)
    else
      self:SetActive(false)
    end
  end)
  self.hide_btn2:SetOnClick(function()
    if self.theCallback then
      pcall(self.theCallback, self.theTarget)
    else
      self:SetActive(false)
    end
  end)
  local cellList = {}
  for i = 1, 6 do
    local soldier_info_cell = self:AddComponent(UILWMummyInfoTipCellS5, "Tip/view/SoldierInoCell" .. i)
    soldier_info_cell:InitInfo(cellInfo[i])
    table.insert(cellList, soldier_info_cell)
  end
  self.cellList = cellList
  self.skill:SetActive(false)
  self.icon1:SetOnClick(function()
    self:ShowDescT11(1, self.icon1)
  end)
  self.icon2:SetOnClick(function()
    self:ShowDescT11(2, self.icon2)
  end)
  self.icon3:SetOnClick(function()
    self:ShowDescT11(3, self.icon3)
  end)
  self.icon4:SetOnClick(function()
    self:ShowDescT11(4, self.icon4)
  end)
  self.icon5:SetOnClick(function()
    self:ShowDescT11(5, self.icon5)
  end)
end

function UILWMummyInfoTipS5:OnDestroy()
  self.cellList = nil
  self.tip = nil
  self.skill = nil
  self.icon1 = nil
  self.icon2 = nil
  self.icon3 = nil
  self.icon4 = nil
  self.icon5 = nil
  base.OnDestroy(self)
end

function UILWMummyInfoTipS5:SetCallback(target, callback)
  self.theTarget = target
  self.theCallback = callback
end

function UILWMummyInfoTipS5:Refresh(template)
  local values = string.split_ff_array(template.attr_denominator, ";")
  local info = {
    [1] = {},
    [2] = {},
    [3] = {},
    [4] = {},
    [5] = {},
    [6] = {}
  }
  info[1].curNumber = toInt(template.power)
  info[2].curNumber = toInt(template.level_factor)
  info[3].curNumber = toInt(template.burden)
  info[4].effect = template.life
  info[5].effect = template.attack
  info[6].effect = template.defense
  if template.type ~= SoldierType.Mummy then
    local valuesMummy = {}
    local mummyMeta = DataCenter.SoldierDataManager:GetSoldierTemplateByLevel(template.lv, SoldierType.Mummy)
    if mummyMeta then
      info[1].curNumberMummy = toInt(mummyMeta.power)
      info[2].curNumberMummy = toInt(mummyMeta.level_factor)
      info[3].curNumberMummy = toInt(mummyMeta.burden)
      info[4].effectMummy = mummyMeta.life
      info[5].effectMummy = mummyMeta.attack
      info[6].effectMummy = mummyMeta.defense
      valuesMummy = string.split_ff_array(mummyMeta.attr_denominator, ";")
    end
    for i = 1, 6 do
      info[i].allNumber = values[i] or 0
      info[i].allNumberMummy = valuesMummy[i] or 0
      self.cellList[i]:RefreshSlider(info[i], i, template)
    end
    self.skill:SetActive(false)
  else
    local soldier_lv = toInt(template.lv)
    if soldier_lv == 11 then
      self:RefreshT11()
    else
      self.skill:SetActive(false)
    end
    for i = 1, 6 do
      info[i].allNumber = values[i] or 0
      self.cellList[i]:RefreshMummy(info[i], i, template)
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.tip.transform)
end

function UILWMummyInfoTipS5:RefreshT11()
  local theSkillList = T11Util.GetStageSkillList()
  if theSkillList then
    self.theSkillList = theSkillList
    for k, v in ipairs(theSkillList) do
      local icon = self["icon" .. k]
      if icon and v then
        local effect_mummy_icon = v.effect_mummy_icon
        CS.UIGray.SetGray(icon.transform, v.isUnlock ~= true, true)
        if effect_mummy_icon and icon.LoadSpriteAsync ~= nil then
          icon:LoadSpriteAsync(effect_mummy_icon)
        end
      end
    end
    self.skill:SetActive(true)
  else
    self.skill:SetActive(false)
  end
end

function UILWMummyInfoTipS5:ShowDescT11(index, btn)
  local theSkillList = self.theSkillList
  if theSkillList == nil or btn == nil then
    return
  end
  local data = theSkillList[index]
  if data == nil then
    return
  end
  local param = {}
  param.alignObject = btn
  param.width = 515
  param.skillData = data
  param.fixedSoldierType = SoldierType.Mummy
  param.showArrow = true
  param.showLockImage = true
  param.addPosY = 80
  UIManager:GetInstance():OpenWindow(UIWindowNames.T11SoldierSkillTip, {anim = true}, param)
end

return UILWMummyInfoTipS5
