local FormationBuffView = BaseClass("FormationBuffView", UIBaseContainer)
local FormationBuffCell = require("UI.UILWHero.UIHeroPVPFormationPanel.Component.FormationBuffCell")
local base = UIBaseContainer

function FormationBuffView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function FormationBuffView:ComponentDestroy()
  self.buffScroll = nil
end

function FormationBuffView:ComponentDefine()
  self.lineups = {}
  self.buffScroll = self:AddComponent(UIScrollView, "Bg/firmationBufflView")
  self.buffContent = self:AddComponent(UIBaseContainer, "Bg/firmationBufflView/Viewport/Content")
  self.buffScroll:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.buffScroll:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  for i = 1, 5 do
    table.insert(self.lineups, self:AddComponent(UIImage, string.format("Bg/titleBg/myLineupInfo/layout/lineup%s/icon%s", i, i)))
  end
  self.lockContent = self:AddComponent(UIBaseContainer, "Bg/lockContent")
  self.myLineupInfo = self:AddComponent(UIBaseContainer, "Bg/titleBg/myLineupInfo")
end

function FormationBuffView:RefillContent()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.buffContent.transform)
end

function FormationBuffView:ReInit(formationInfo)
  self.dataList = formationInfo.cfgList
  local lineupsInfo = formationInfo.heros
  local list = {}
  for i = 1, #lineupsInfo do
    for j = 1, lineupsInfo[i].count do
      table.insert(list, lineupsInfo[i].type)
    end
  end
  self:ShowScroll()
  for i = 1, 5 do
    if i <= #list then
      self.lineups[i]:SetActive(true)
      self.lineups[i]:LoadSprite(HeroUtils.GetHeroTypeIcon(list[i]))
    else
      self.lineups[i]:SetActive(false)
    end
  end
  local isFormationBuffOpen = UIUtil.IsFormationBuffInfoOpen()
  if isFormationBuffOpen then
    self.myLineupInfo:SetActive(true)
    self.buffScroll:SetActive(true)
    self.lockContent:SetActive(false)
  else
    self.myLineupInfo:SetActive(false)
    self.buffScroll:SetActive(false)
    self.lockContent:SetActive(true)
  end
end

function FormationBuffView:ShowScroll()
  self:ClearScroll()
  local count = #self.dataList
  self.buffScroll:SetTotalCount(count)
  if 0 < count then
    self.buffScroll:RefillCells()
  end
end

function FormationBuffView:ClearScroll()
  self.buffScroll:ClearCells()
  self.buffScroll:RemoveComponents(FormationBuffCell)
end

function FormationBuffView:OnCreateCell(itemObj, index)
  itemObj.name = tostring(index)
  local item = self.buffScroll:AddComponent(FormationBuffCell, itemObj)
  item:ReInit(self.dataList[index])
end

function FormationBuffView:OnDeleteCell(itemObj, index)
  self.buffScroll:RemoveComponent(itemObj.name, FormationBuffCell)
end

function FormationBuffView:RefreshLineups()
end

function FormationBuffView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

return FormationBuffView
