local UIMultipleParkourLoseView = BaseClass("UIMultipleParkourLoseView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIMultipleParkourLoseResult = require("UI.UIMultipleParkour.Lose.Component.UIMultipleParkourLoseResult")
local UIMultipleParkourRank = require("UI.UIMultipleParkour.Win.Component.UIMultipleParkourRank")
local LayoutLayer = "Layout/"
local back_btn_path = "Layout/BackBtn"
local back_btn_text_path = "Layout/BackBtn/BackBtnText"
local make_btn_path = "Layout/Tabs/MakeBtn"
local make_btn_text_path = "Layout/Tabs/MakeBtn/MakeBtnText"
local take_btn_path = "Layout/Tabs/TakeBtn"
local take_btn_text_path = "Layout/Tabs/TakeBtn/TakeBtnText"
local mask_path = "Layout/Tabs/Highlight/Mask"
local inner_path = "Layout/Tabs/Highlight/Mask/Inner"
local make_btn_high_path = "Layout/Tabs/Highlight/Mask/Inner/MakeBtnHigh"
local make_btn_high_text_path = "Layout/Tabs/Highlight/Mask/Inner/MakeBtnHigh/MakeBtnHighText"
local take_btn_high_path = "Layout/Tabs/Highlight/Mask/Inner/TakeBtnHigh"
local take_btn_high_text_path = "Layout/Tabs/Highlight/Mask/Inner/TakeBtnHigh/TakeBtnHighText"
local victory_text_path = "Layout/Title/VictoryGo/VictoryText"
local level_text_path = "Layout/LevelText"
local result_content_path = "Layout/ResultContent"
local rank_content_path = "Layout/RankContent"

function UIMultipleParkourLoseView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIMultipleParkourLoseView:OnDestroy()
  if not IsNull(self.tabTween) then
    self.tabTween:Kill()
    self.tabTween = nil
  end
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIMultipleParkourLoseView:OnAddListener()
  base.OnAddListener(self)
end

function UIMultipleParkourLoseView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIMultipleParkourLoseView:ComponentDefine()
  self.canvasGroup = self.transform:Find(LayoutLayer).gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  self.canvasGroup.alpha = 0
  self.back_btn = self:AddComponent(UIButton, back_btn_path)
  self.back_btn_text = self:AddComponent(UITextMeshProUGUIEx, back_btn_text_path)
  self.back_btn:SetOnClick(function()
    self:OnBackBtnClick()
  end)
  self.back_btn_text:SetText(Localization:GetString(300520))
  self.defeatText = self:AddComponent(UITextMeshProUGUIEx, "Layout/Title/BattleDefeatPanel_ani/DefeatGo/DefeatText")
  self.defeatText:SetText(Localization:GetString("311106"))
  self.level_text = self:AddComponent(UITextMeshProUGUIEx, level_text_path)
  self.level_text:SetText(Localization:GetString("dev_multiple_stage_04"))
  self.tabComps = {
    self:AddComponent(UIMultipleParkourLoseResult, result_content_path),
    self:AddComponent(UIMultipleParkourRank, rank_content_path)
  }
  self.tabIdx = 1
  self.mask = self:AddComponent(UIImage, mask_path)
  self.inner = self:AddComponent(UIBaseContainer, inner_path)
  self.mask:SetAnchoredPositionXY(0, -1)
  self.inner:SetAnchoredPositionXY(0, 0)
  self.make_btn_high_text = self:AddComponent(UITextMeshProUGUIEx, make_btn_high_text_path)
  self.take_btn_high_text = self:AddComponent(UITextMeshProUGUIEx, take_btn_high_text_path)
  self.make_btn_high_text:SetText(Localization:GetString(150212))
  self.take_btn_high_text:SetText(Localization:GetString(456531))
  for i, tabCom in ipairs(self.tabComps) do
    tabCom:SetActive(true)
  end
end

function UIMultipleParkourLoseView:DataDefine()
end

function UIMultipleParkourLoseView:ComponentDestroy()
  self.back_btn = nil
  self.back_btn_text = nil
  self.make_btn = nil
  self.make_btn_text = nil
  self.take_btn = nil
  self.take_btn_text = nil
  self.defeatText = nil
  self.level_text = nil
  self.mask = nil
  self.inner = nil
  self.make_btn_high = nil
  self.make_btn_high_text = nil
  self.take_btn_high = nil
  self.take_btn_high_text = nil
  self.result_content = nil
  self.rank_content = nil
end

function UIMultipleParkourLoseView:DataDestroy()
end

function UIMultipleParkourLoseView:ReInit()
  TimerManager:GetInstance():DelayInvoke(function()
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIMultipleParkourLose) then
      self.canvasGroup:DOFade(1, 0.2)
      self:ShowData()
    end
  end, 1.5)
end

function UIMultipleParkourLoseView:ShowData()
  for i, tabComp in ipairs(self.tabComps) do
    tabComp:SetActive(true)
    tabComp:FadeIn()
  end
end

function UIMultipleParkourLoseView:OnBackBtnClick()
  self.ctrl:CloseSelf()
  DataCenter.MultipleParkourManager:Exit(function()
    if CS.SceneManager.IsInCity() then
      local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.MultipleParkour.Type)
      if actList and 0 < #actList then
        local actId = tonumber(actList[1].id)
        GoToUtil.GoActWindow({
          tonumber(actId)
        })
      else
        UIUtil.ShowTipsId(801141)
      end
    end
  end)
end

function UIMultipleParkourLoseView:OnTabBtnClick(idx)
  if self.tabIdx == idx then
    return
  end
  self.tabIdx = idx
  self:ShowData()
  if not IsNull(self.tabTween) then
    self.tabTween:Kill()
    self.tabTween = nil
  end
  self.tabTween = CS.DG.Tweening.DOTween.To(function()
    return self.mask:GetAnchoredPositionX()
  end, function(value)
    self.mask:SetAnchoredPositionXY(value, -1)
    self.inner:SetAnchoredPositionXY(-value, 0)
  end, (self.tabIdx - 1) * 334, 0.5):SetEase(CS.DG.Tweening.Ease.OutQuint)
end

return UIMultipleParkourLoseView
