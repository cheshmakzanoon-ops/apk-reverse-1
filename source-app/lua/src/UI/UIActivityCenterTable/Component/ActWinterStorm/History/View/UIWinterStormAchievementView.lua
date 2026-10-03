local UIWinterStormAchievementView = BaseClass("UIWinterStormAchievementView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local CLS = "UI.UIActivityCenterTable.Component.ActWinterStorm.History.Component.UIWS_A_Line"
local PREFAB = "Assets/Main/Prefabs/UI/ActivityCenter/WinterStorm/S0/UIWS_A_Line.prefab"

function UIWinterStormAchievementView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIWinterStormAchievementView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWinterStormAchievementView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnBack = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.compUIPlayerHead = self.viewSkin:AddComponent(self, UICommonHead, 2)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textLv = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.textEmpty = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.btnList = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnList:SetOnClick(function()
    self:OnBtnListClick()
  end)
end

function UIWinterStormAchievementView:ComponentDestroy()
  self.viewSkin = nil
  self.btnBack = nil
  self.compUIPlayerHead = nil
  self.textName = nil
  self.textLv = nil
  self.compContent = nil
  self.textEmpty = nil
  self.btnList = nil
end

function UIWinterStormAchievementView:DataDefine()
  self.cells = {}
  self.textEmpty:SetActive(true)
  self.compUIPlayerHead:SetAsMyself()
  self.textName:SetText(LuaEntry.Player:GetFullName())
  self.textLv:SetLocalText(140002, LuaEntry.Player.level)
  SFSNetwork.SendMessage(MsgDefines.WinterStormAchievement)
end

function UIWinterStormAchievementView:DataDestroy()
  self.cells = nil
  self.data = nil
end

function UIWinterStormAchievementView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.WinterStormAchievementList, self.OnDataUpdate)
end

function UIWinterStormAchievementView:OnRemoveListener()
  self:RemoveUIListener(EventId.WinterStormAchievementList, self.OnDataUpdate)
  base.OnRemoveListener(self)
end

function UIWinterStormAchievementView:OnBtnBackClick()
  self.ctrl:CloseSelf()
end

function UIWinterStormAchievementView:OnBtnListClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIWinterStormAchievementList, {anim = true}, nil, true)
end

local function SortBA(a, b)
  if a.priority ~= b.priority then
    return a.priority < b.priority
  end
  return a.id < b.id
end

function UIWinterStormAchievementView:OnDataUpdate(t)
  local data = t.data or {}
  if not table.IsNullOrEmpty(data) then
    for _, info in ipairs(data) do
      info.priority = LocalController:instance():getIntValue(TableName.LW_BattleField_Achievement, info.id, "priority", 0)
    end
    table.sort(data, SortBA)
  end
  self.data = data
  self:RefreshView()
end

function UIWinterStormAchievementView:RefreshView()
  local lineCnt = 3
  local list = self.data
  local cCnt = #self.cells
  local lCnt, delta = math.modf(#list / lineCnt)
  if 0 < delta then
    lCnt = lCnt + 1
  end
  local max = math.max(cCnt, lCnt)
  self.textEmpty:SetActive(lCnt == 0)
  for i = 1, max do
    local cell = self.cells[i]
    local realI = (i - 1) * lineCnt + 1
    local data = list[realI]
    if data ~= nil then
      if cell == nil then
        cell = self:LoadComponentAsync(CLS, PREFAB, self.compContent, function(_, go, _, callback_param)
          go.transform:SetSiblingIndex(toInt(callback_param))
        end, i - 1)
        self.cells[i] = cell
      end
      cell:SetActive(true)
      cell:SetDatas(self.data[realI], self.data[realI + 1], self.data[realI + 2])
    elseif cell ~= nil then
      cell:SetActive(false)
    end
  end
end

return UIWinterStormAchievementView
