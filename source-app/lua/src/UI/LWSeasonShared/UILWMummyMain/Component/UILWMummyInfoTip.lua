local UILWMummyInfoTip = BaseClass("UILWMummyInfoTip", UICanvasGroup)
local UILWMummyInfoTipCell = require("UI.LWSeasonShared.UILWMummyMain.Component.UILWMummyInfoTipCell")
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

function UILWMummyInfoTip:OnCreate()
  base.OnCreate(self)
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
    local soldier_info_cell = self:AddComponent(UILWMummyInfoTipCell, "Tip/view/SoldierInoCell" .. i)
    soldier_info_cell:InitInfo(cellInfo[i])
    table.insert(cellList, soldier_info_cell)
  end
  self.cellList = cellList
end

function UILWMummyInfoTip:OnDestroy()
  self.cellList = nil
  base.OnDestroy(self)
end

function UILWMummyInfoTip:SetCallback(target, callback)
  self.theTarget = target
  self.theCallback = callback
end

function UILWMummyInfoTip:Refresh(template)
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
  else
    for i = 1, 6 do
      info[i].allNumber = values[i] or 0
      self.cellList[i]:RefreshMummy(info[i], i, template)
    end
  end
end

return UILWMummyInfoTip
