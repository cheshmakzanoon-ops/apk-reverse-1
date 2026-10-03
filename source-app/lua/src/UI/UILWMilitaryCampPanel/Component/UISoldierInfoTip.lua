local UISoldierInfoTip = BaseClass("UISoldierInfoTip", UIBaseContainer)
local UISoliderInfoItemCell = require("UI.UILWMilitaryCampPanel.Component.UISoliderInfoItemCell")
local base = UIBaseContainer
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
local minX = -170
local maxX = 170

function UISoldierInfoTip:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UISoliderInfoItemCell:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISoldierInfoTip:ComponentDestroy()
  self.view = nil
  self.closeBtn = nil
  self.cellList = nil
  self.tipParent = nil
end

function UISoldierInfoTip:ComponentDefine()
  self.tipParent = self:AddComponent(UIBaseContainer, "Tip")
  self.tipPosImg = self:AddComponent(UIBaseContainer, "Tip/tipPosImg")
  self.view = self:AddComponent(UIBaseContainer, "Tip/view")
  self.closeBtn = self:AddComponent(UIButton, "")
  self.closeBtn:SetOnClick(function()
    self:SetActive(false)
  end)
  self.cellList = {}
  for i = 0, self.view.transform.childCount - 1 do
    local cell = self.view.transform:GetChild(i)
    local item = self.view:AddComponent(UISoliderInfoItemCell, cell)
    item:InitInfo(cellInfo[i + 1])
    table.insert(self.cellList, item)
  end
end

function UISoldierInfoTip:Refresh(template, pos, ignoreContentPosX)
  local values = string.split(template.attr_denominator, ";")
  local info = {
    [1] = {},
    [2] = {},
    [3] = {},
    [4] = {},
    [5] = {},
    [6] = {}
  }
  info[1].curNumber = template.power
  info[2].curNumber = template.level_factor
  info[3].curNumber = template.burden
  info[4].effect = template.life
  info[5].effect = template.attack
  info[6].effect = template.defense
  for i = 1, #self.cellList do
    info[i].allNumber = tonumber(values[i])
    self.cellList[i]:RefreshSlider(info[i], i)
  end
  if not pos then
    return
  end
  if ignoreContentPosX then
    self.tipParent.transform.position = Vector3.New(self.tipParent.transform.position.x, pos.y + 120, 0)
  else
    self.tipParent.transform.position = pos + Vector3.New(0, 120, 0)
    if self.tipParent.rectTransform.anchoredPosition.x < minX then
      self.tipParent.rectTransform.anchoredPosition = Vector2.New(minX, self.tipParent.rectTransform.anchoredPosition.y)
    elseif self.tipParent.rectTransform.anchoredPosition.x > maxX then
      self.tipParent.rectTransform.anchoredPosition = Vector2.New(maxX, self.tipParent.rectTransform.anchoredPosition.y)
    end
  end
  self.tipPosImg.transform.position = Vector3.New(pos.x, self.tipPosImg.transform.position.y, 0)
end

return UISoldierInfoTip
