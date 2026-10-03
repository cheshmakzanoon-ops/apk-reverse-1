local base = UIAsyncContainer
local UIWS_BattleResultAchievement = BaseClass("UIWS_BattleResultAchievement", UIAsyncContainer)
local UIWS_MvpCell = require("UI.UIActivityCenterTable.Component.ActWinterStorm.Result.Component.UIWS_MvpCell")
local UIWS_H_ACell = require("UI.UIActivityCenterTable.Component.ActWinterStorm.History.Component.UIWS_H_ACell")

function UIWS_BattleResultAchievement:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIWS_BattleResultAchievement:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWS_BattleResultAchievement:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compMvpCell = self.viewSkin:AddComponent(self, UIWS_MvpCell, 1)
  self.btn = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.btnRecord = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnRecord:SetOnClick(function()
    self:OnBtnRecordClick()
  end)
  self.btnList = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnList:SetOnClick(function()
    self:OnBtnListClick()
  end)
  self.scrollView = self.viewSkin:AddComponent(self, UIScrollView, 5)
  self.btnRoot = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnRoot:SetOnClick(function()
    self:OnBtnRootClick()
  end)
  self.gridLayout = self.viewSkin:AddComponent(self, UIGridLayoutGroup, 7)
end

function UIWS_BattleResultAchievement:ComponentDestroy()
  self.viewSkin = nil
  self.compMvpCell = nil
  self.btn = nil
  self.btnRecord = nil
  self.btnList = nil
  self.scrollView = nil
  self.btnRoot = nil
  self.gridLayout = nil
end

function UIWS_BattleResultAchievement:DataDefine()
  self.cells = {}
  self.showAnim = false
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
end

function UIWS_BattleResultAchievement:DataDestroy()
  self:CleanDelay()
  self:ClearScroll()
  self.teamArr = nil
  self.cells = nil
  self.showAnim = false
end

function UIWS_BattleResultAchievement:OnAddListener()
  base.OnAddListener(self)
end

function UIWS_BattleResultAchievement:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIWS_BattleResultAchievement:OnBtnRootClick()
  self:OnBtnClick()
end

function UIWS_BattleResultAchievement:OnBtnClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.showAnim then
    return
  end
  self:SetActive(false)
  EventManager:GetInstance():Broadcast(EventId.WinterStormResultAchievementShow)
end

function UIWS_BattleResultAchievement:OnBtnRecordClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIWinterStormBattleScore)
end

function UIWS_BattleResultAchievement:OnBtnListClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIWinterStormAchievementList, {anim = true}, nil, true)
end

function UIWS_BattleResultAchievement:SetData(teamArr)
  self.teamArr = teamArr
  self:RefreshView()
end

function UIWS_BattleResultAchievement:UpdateData()
  if self.teamArr == nil then
    return
  end
  self.compMvpCell:ReInit(self.teamArr, false)
  self:ShowList()
end

function UIWS_BattleResultAchievement:ShowList()
  self:ClearScroll()
  self:CleanDelay()
  self.showAnim = true
  self.btn:SetActive(true)
  local list = self.teamArr.achievement or {}
  local lCnt = #list
  if lCnt == 0 then
    self:SetActive(false)
    EventManager:GetInstance():Broadcast(EventId.WinterStormResultAchievementShow)
    return
  end
  self.scrollView:SetTotalCount(lCnt)
  self.scrollView:RefillCells()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.gridLayout.rectTransform)
  self.animDelay = TimerManager:GetInstance():DelayFrameInvoke(function()
    self.animDelay = nil
    self:TryPlayAnim()
  end, 2)
end

function UIWS_BattleResultAchievement:CleanDelay()
  if self.animDelay ~= nil then
    self.animDelay:Stop()
    self.animDelay = nil
  end
  if self.aniSeq ~= nil then
    self.aniSeq:Kill()
    self.aniSeq = nil
  end
end

function UIWS_BattleResultAchievement:ClearScroll()
  self.cells = {}
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(UIWS_H_ACell)
end

function UIWS_BattleResultAchievement:OnCreateCell(itemObj, index)
  local list = self.teamArr.achievement or {}
  local achievementId = list[index]
  itemObj.name = tostring(index)
  local cellItem = self.scrollView:AddComponent(UIWS_H_ACell, itemObj)
  cellItem:SetData({id = achievementId}, not self.showAnim)
  self.cells[index] = cellItem
end

function UIWS_BattleResultAchievement:OnDeleteCell(itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, UIWS_H_ACell)
  self.cells[index] = nil
end

function UIWS_BattleResultAchievement:TryPlayAnim()
  local seq = DOTween.Sequence()
  local lineCount = 3
  local cellDelay = 0.125
  local list = self.teamArr.achievement or {}
  local lCnt = #list
  for i = 1, lCnt do
    local idx = i
    seq:AppendInterval(cellDelay):AppendCallback(function()
      if idx > lineCount * 2 and idx ~= lCnt then
        self.scrollView:ScrollToCell(idx, 1000)
      end
      local cell = self.cells[idx]
      if cell then
        cell:ActiveRoot(true)
      end
      if idx == lCnt then
        self.showAnim = false
        for _, v in pairs(self.cells) do
          if v ~= nil then
            v:ActiveRoot(true)
          end
        end
      end
    end)
    if i == lCnt then
      seq:AppendInterval(cellDelay):AppendCallback(function()
        self.btn:SetActive(false)
        self.scrollView:StopMovement()
        self.scrollView:ScrollToCell(1, 2000)
      end)
    end
  end
  self.aniSeq = seq
end

return UIWS_BattleResultAchievement
