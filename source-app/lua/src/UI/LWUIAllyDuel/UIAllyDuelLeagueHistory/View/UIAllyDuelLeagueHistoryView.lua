local base = UIBaseView
local UIAllyDuelLeagueHistoryView = BaseClass("UIAllyDuelLeagueHistoryView", base)
local Localization = CS.GameEntry.Localization
local AllyDuelLeagueHistoryItem = require("UI.LWUIAllyDuel.UIAllyDuelLeagueHistory.Component.AllyDuelLeagueHistoryItem")
local GrayColor = Color.New(0.64, 0.64, 0.64, 1)

function UIAllyDuelLeagueHistoryView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitUI()
end

function UIAllyDuelLeagueHistoryView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIAllyDuelLeagueHistoryView:ComponentDefine()
  self.returnBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.closeBtn = self:AddComponent(UIButton, "Root/CloseBtn")
  self.returnBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.focusBtn = self:AddComponent(UIButton, "Root/BtnFocus")
  self.focusBtn:SetOnClick(function()
    self:OnClickFocus()
  end)
  self.toggle = {}
  self.toggleText = {}
  self.toggleCur = {}
  for i = 1, 4 do
    self.toggle[i] = self:AddComponent(UIToggle, "Root/ToggleGroup/Toggle" .. i)
    self.toggleText[i] = self:AddComponent(UIText, "Root/ToggleGroup/Toggle" .. i .. "/CheckText" .. i)
    self.toggleText[i]:SetLocalText(459009, i)
    self.toggleCur[i] = self:AddComponent(UIBaseComponent, "Root/ToggleGroup/Toggle" .. i .. "/cur" .. i)
    self.toggle[i]:SetOnValueChanged(function(bool)
      if bool then
        self:ToggleOn(i)
      end
    end)
  end
  self.scrollView = self:AddComponent(UIScrollView, "Root/ScrollView")
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.content = self:AddComponent(UIBaseContainer, "Root/ScrollView/Viewport/Content")
  self.noContent = self:AddComponent(UIBaseComponent, "Root/noContent")
end

function UIAllyDuelLeagueHistoryView:ComponentDestroy()
  self.toggle = {}
  self.toggleText = {}
  self.toggleCur = {}
  self:ClearScroll()
end

function UIAllyDuelLeagueHistoryView:DataDefine()
  self.allianceGroupDic = {}
  self.cellList = {}
  self.jumpWeek = nil
  self.jumpAllyId = nil
  self.jumpWeek, self.jumpAllyId = self:GetUserData()
end

function UIAllyDuelLeagueHistoryView:DataDestroy()
  self.allianceGroupDic = nil
  self.cellList = {}
end

function UIAllyDuelLeagueHistoryView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllyDuelLeagueHistory, self.RefreshContent)
end

function UIAllyDuelLeagueHistoryView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllyDuelLeagueHistory, self.RefreshContent)
end

function UIAllyDuelLeagueHistoryView:ToggleOn(index)
  if self.selection == index then
    return
  end
  self.selection = index
  self:RefreshContent()
end

function UIAllyDuelLeagueHistoryView:InitUI()
  local curWeek = DataCenter.LeagueMatchManager:GetWeekCount()
  for i = 1, 4 do
    if i <= curWeek then
      self.toggleText[i]:SetColor(WhiteColor)
    else
      self.toggleText[i]:SetColor(GrayColor)
    end
    self.toggleCur[i]:SetActive(i == curWeek)
  end
  self.selection = Mathf.Clamp(self.jumpWeek and self.jumpWeek or curWeek, 0, 4)
  self.toggle[self.selection]:SetIsOn(true)
  self:RefreshContent()
  self:FocusItem(self.jumpAllyId)
end

function UIAllyDuelLeagueHistoryView:RefreshContent()
  self.vsList = DataCenter.LeagueMatchManager:GetWeekVsInfo(self.selection) or {}
  if #self.vsList == 0 then
    self:ClearScroll()
  else
    self.scrollView:SetTotalCount(#self.vsList)
    self.scrollView:RefillCells()
  end
  self.noContent:SetActive(#self.vsList == 0)
end

function UIAllyDuelLeagueHistoryView:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cell = self.scrollView:AddComponent(AllyDuelLeagueHistoryItem, itemObj)
  cell:Refresh(self.vsList[index])
  self.cellList[index] = cell
end

function UIAllyDuelLeagueHistoryView:OnItemMoveOut(itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, AllyDuelLeagueHistoryItem)
  self.cellList[index] = nil
end

function UIAllyDuelLeagueHistoryView:ClearScroll()
  self.cellList = {}
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(AllyDuelLeagueHistoryItem)
end

function UIAllyDuelLeagueHistoryView:OnClickFocus()
  self:FocusItem(LuaEntry.Player.allianceId)
end

function UIAllyDuelLeagueHistoryView:FocusItem(allianceId)
  if string.IsNullOrEmpty(allianceId) then
    return
  end
  for i = 1, #self.vsList do
    if self.vsList[i].vsAllianceInfo[1].allianceId == allianceId or self.vsList[i].vsAllianceInfo[2].allianceId == allianceId then
      self.scrollView:ScrollToCell(i, 1000)
      if self.cellList[i] and self.cellList[i].Focus then
        self.cellList[i]:Focus()
      end
      break
    end
  end
end

return UIAllyDuelLeagueHistoryView
