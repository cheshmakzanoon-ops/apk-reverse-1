local base = UIAsyncContainer
local UIWS_BattleResultMvpComp = BaseClass("UIWS_BattleResultMvpComp", UIAsyncContainer)
local UIWS_MvpCell = require("UI.UIActivityCenterTable.Component.ActWinterStorm.Result.Component.UIWS_MvpCell")
local ActMgr = DataCenter.ActWinterStormManager

function UIWS_BattleResultMvpComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIWS_BattleResultMvpComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWS_BattleResultMvpComp:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compMvpCell1 = self.viewSkin:AddComponent(self, UIWS_MvpCell, 1)
  self.compMvpCell2 = self.viewSkin:AddComponent(self, UIWS_MvpCell, 2)
  self.compMvpCell3 = self.viewSkin:AddComponent(self, UIWS_MvpCell, 3)
  self.compMvpCell4 = self.viewSkin:AddComponent(self, UIWS_MvpCell, 4)
  self.compMvpCell5 = self.viewSkin:AddComponent(self, UIWS_MvpCell, 5)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnOnceAgain = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnOnceAgain:SetOnClick(function()
    self:OnBtnOnceAgainClick()
  end)
  self.textClose = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textOnceAgain = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.btnRecord = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnRecord:SetOnClick(function()
    self:OnBtnRecordClick()
  end)
  self.btnList = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnList:SetOnClick(function()
    self:OnBtnListClick()
  end)
  self.compBottom = self.viewSkin:AddComponent(self, UIBaseComponent, 12)
  self.canvasGroup = self.viewSkin:AddComponent(self, UICanvasGroup, 13)
end

function UIWS_BattleResultMvpComp:ComponentDestroy()
  self.viewSkin = nil
  self.compMvpCell1 = nil
  self.compMvpCell2 = nil
  self.compMvpCell3 = nil
  self.compMvpCell4 = nil
  self.compMvpCell5 = nil
  self.btnClose = nil
  self.btnOnceAgain = nil
  self.textClose = nil
  self.textOnceAgain = nil
  self.btnRecord = nil
  self.btnList = nil
  self.compBottom = nil
  self.canvasGroup = nil
end

function UIWS_BattleResultMvpComp:DataDefine()
  self.mvpCells = {
    self.compMvpCell1,
    self.compMvpCell2,
    self.compMvpCell3,
    self.compMvpCell4,
    self.compMvpCell5
  }
  self.textClose:SetLocalText("trialtower_return")
  self.textOnceAgain:SetLocalText("winter_battlefield_tips1012")
  self.btnList:SetActive(true)
end

function UIWS_BattleResultMvpComp:DataDestroy()
  self.mvpCells = nil
end

function UIWS_BattleResultMvpComp:OnAddListener()
  base.OnAddListener(self)
end

function UIWS_BattleResultMvpComp:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIWS_BattleResultMvpComp:OnBtnCloseClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self.view.ctrl:CloseSelf()
end

function UIWS_BattleResultMvpComp:OnBtnOnceAgainClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self.view.ctrl:OnceAgain()
end

function UIWS_BattleResultMvpComp:OnBtnRecordClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIWinterStormBattleScore)
end

function UIWS_BattleResultMvpComp:OnBtnListClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIWinterStormAchievementList, {anim = true}, nil, true)
end

function UIWS_BattleResultMvpComp:UpdateData()
  local resultInfo = ActMgr:GetResult()
  local mvps = resultInfo ~= nil and resultInfo.mvp or {}
  for i, v in ipairs(self.mvpCells) do
    local teamArr = mvps[i]
    if teamArr then
      v:ReInit(teamArr, true)
      v:SetActive(true)
    else
      v:SetActive(false)
    end
  end
end

function UIWS_BattleResultMvpComp:CanvasShow(flag)
  if self:AsyncLoadDone() then
    self.canvasGroup:SetAlpha(flag and 1 or 0)
  end
end

return UIWS_BattleResultMvpComp
