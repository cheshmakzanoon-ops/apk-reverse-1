local UIBattleResultMysteryTreasureDefeatView = BaseClass("UIBattleResultMysteryTreasureDefeatView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local CommonResultTabComponent = require("UI.UIBattleResultComponents.CommonResultTabComponent")

function UIBattleResultMysteryTreasureDefeatView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBattleResultMysteryTreasureDefeatView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBattleResultMysteryTreasureDefeatView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTxtTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textTxtStage = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compTab = self.viewSkin:AddComponent(self, CommonResultTabComponent, 3)
  self.loopListView2Scroll = self.viewSkin:AddComponent(self, UILoopListView2, 4)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.btnTryAgain = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnTryAgain:SetOnClick(function()
    self:OnBtnTryAgainClick()
  end)
  self.textTxtTryAgain = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.btnReturn = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnReturn:SetOnClick(function()
    self:OnBtnReturnClick()
  end)
  self.canvasGroupContent = self.viewSkin:AddComponent(self, UICanvasGroup, 9)
end

function UIBattleResultMysteryTreasureDefeatView:ComponentDestroy()
  self.viewSkin = nil
  self.textTxtTitle = nil
  self.textTxtStage = nil
  self.compTab = nil
  self.loopListView2Scroll = nil
  self.compContent = nil
  self.btnTryAgain = nil
  self.textTxtTryAgain = nil
  self.btnReturn = nil
  self.canvasGroupContent = nil
end

function UIBattleResultMysteryTreasureDefeatView:DataDefine()
end

function UIBattleResultMysteryTreasureDefeatView:DataDestroy()
end

function UIBattleResultMysteryTreasureDefeatView:OnAddListener()
  base.OnAddListener(self)
end

function UIBattleResultMysteryTreasureDefeatView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIBattleResultMysteryTreasureDefeatView:OnBtnTryAgainClick()
end

function UIBattleResultMysteryTreasureDefeatView:OnBtnReturnClick()
end

return UIBattleResultMysteryTreasureDefeatView
