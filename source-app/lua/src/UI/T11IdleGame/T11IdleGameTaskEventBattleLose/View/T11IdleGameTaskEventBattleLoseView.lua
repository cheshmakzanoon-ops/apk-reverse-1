local T11IdleGameTaskEventBattleLoseView = BaseClass("T11IdleGameTaskEventBattleLoseView", UIBaseView)
local M = T11IdleGameTaskEventBattleLoseView
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGrowthList = require("UI.UIJeepAdventure.UITowerupBattleLose.Component.UITowerupBattleResultGrowthList")
local UIStatisticList = require("UI.UIJeepAdventure.UITowerupBattleLose.Component.UITowerupBattleStatisticHeroList")
local DynamicAssetName = {
  GrowGuideScroll = "GrowGuideScroll",
  MakeDmgScroll = "MakeDmgScroll",
  TakeDmgScroll = "TakeDmgScroll"
}
local DynamicAsset = {
  [DynamicAssetName.GrowGuideScroll] = {
    prefabPath = "Assets/Main/Prefabs/UI/UIJeepAdventure/GrowGuideScroll.prefab",
    class = UIGrowthList,
    parentPath = "Root"
  },
  [DynamicAssetName.MakeDmgScroll] = {
    prefabPath = "Assets/Main/Prefabs/UI/UIJeepAdventure/LWTowerupBattleMakeDmgScroll.prefab",
    class = UIStatisticList,
    parentPath = "Root"
  },
  [DynamicAssetName.TakeDmgScroll] = {
    prefabPath = "Assets/Main/Prefabs/UI/UIJeepAdventure/LWTowerupBattleTakeDmgScroll.prefab",
    class = UIStatisticList,
    parentPath = "Root"
  }
}

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:RefreshView()
  self:Show()
end

function M:OnDestroy()
  if not IsNull(self.tabTween) then
    self.tabTween:Kill()
    self.tabTween = nil
  end
  if self.dynamicReqs then
    for k, v in pairs(self.dynamicReqs) do
      v:Destroy()
    end
    self.dynamicReqs = nil
  end
  self.tabIdx = nil
  base.OnDestroy(self)
end

function M:ComponentDefine()
  local param, battleManagerParam = self:GetUserData()
  self.battleManagerParam = battleManagerParam
  local stageId = param.stageId
  self.canvasGroup = self.transform:Find("Root").gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  self.canvasGroup.alpha = 0
  self.tryAgainBtn = self:AddComponent(UIButton, "Root/Bottom/TryAgainBtn")
  self.tryAgainBtnText = self:AddComponent(UIText, "Root/Bottom/TryAgainBtn/TryAgainBtnText")
  self.tryAgainBtn:SetOnClick(function()
    self:OnTryAgainBtnClick()
  end)
  self.tryAgainBtn:SetActive(true)
  self.backBtn = self:AddComponent(UIButton, "Root/Bottom/BackBtn")
  self.backBtnText = self:AddComponent(UIText, "Root/Bottom/BackBtn/BackBtnText")
  self.backBtn:SetOnClick(function()
    self:OnBackBtnClick()
  end)
  self.defeatText = self:AddComponent(UIText, "Root/Top/BattleDefeatPanel_ani/DefeatGo/DefeatText")
  self.defeatText:SetText(Localization:GetString("311106"))
  self.levelText = self:AddComponent(UIText, "Root/Top/LevelText")
  self.levelText:SetActive(false)
  self.backBtnText:SetText(Localization:GetString("300520"))
  self.tryAgainBtnText:SetText(Localization:GetString("450008"))
  self.tabBtns = {
    self:AddComponent(UIButton, "Root/Tabs/GuideBtn"),
    self:AddComponent(UIButton, "Root/Tabs/MakeBtn"),
    self:AddComponent(UIButton, "Root/Tabs/TakeBtn")
  }
  for i, tabBtn in ipairs(self.tabBtns) do
    local idx = i
    tabBtn:SetOnClick(function()
      self:OnTabBtnClick(idx)
    end)
  end
  self.tabComps = {
    [1] = {
      assetName = DynamicAssetName.GrowGuideScroll,
      comp = nil,
      param1 = self.ctrl
    },
    [2] = {
      assetName = DynamicAssetName.TakeDmgScroll,
      comp = nil,
      param1 = "makeDmg"
    },
    [3] = {
      assetName = DynamicAssetName.MakeDmgScroll,
      comp = nil,
      param1 = "takeDmg"
    }
  }
  self.tabIdx = 1
  self.highlightMask = self:AddComponent(UIBaseContainer, "Root/Tabs/Highlight/Mask")
  self.highlightInner = self:AddComponent(UIBaseContainer, "Root/Tabs/Highlight/Mask/Inner")
  self.highlightMask:SetAnchoredPositionXY(0, -1)
  self.highlightInner:SetAnchoredPositionXY(0, 0)
  self.transform:Find("Root/Tabs/GuideBtn/BtnText"):GetComponent(typeof(CS.TextMeshProUGUIEx)).text = CS.GameEntry.Localization:GetString(800799)
  self.transform:Find("Root/Tabs/Highlight/Mask/Inner/GuideBtnHigh/BtnText"):GetComponent(typeof(CS.TextMeshProUGUIEx)).text = CS.GameEntry.Localization:GetString(800799)
  self.transform:Find("Root/Tabs/MakeBtn/BtnText"):GetComponent(typeof(CS.TextMeshProUGUIEx)).text = CS.GameEntry.Localization:GetString(800800)
  self.transform:Find("Root/Tabs/Highlight/Mask/Inner/MakeBtnHigh/BtnText"):GetComponent(typeof(CS.TextMeshProUGUIEx)).text = CS.GameEntry.Localization:GetString(800800)
  self.transform:Find("Root/Tabs/TakeBtn/BtnText"):GetComponent(typeof(CS.TextMeshProUGUIEx)).text = CS.GameEntry.Localization:GetString(800801)
  self.transform:Find("Root/Tabs/Highlight/Mask/Inner/TakeBtnHigh/BtnText"):GetComponent(typeof(CS.TextMeshProUGUIEx)).text = CS.GameEntry.Localization:GetString(800801)
  self.dynamicReqs = {}
end

function M:ComponentDestroy()
  self.back_btn = nil
end

function M:Show()
  TimerManager:GetInstance():DelayInvoke(function()
    self.canvasGroup:DOFade(1, 0.2)
  end, 1.5)
  DataCenter.TowerUpSaveDataManager:SetAutoNextStage(false)
end

function M:RefreshView()
  for i, v in ipairs(self.tabComps) do
    local assetName = v.assetName
    local tabComp = v.comp
    if i == self.tabIdx then
      if tabComp then
        tabComp:SetActive(true)
        tabComp:FadeIn()
      else
        local req = self:GameObjectInstantiateAsync(DynamicAsset[assetName].prefabPath, function(request)
          if self.tabIdx == nil then
            request:Destroy()
            return
          end
          local go = request.gameObject
          go.name = assetName
          local parentPath = DynamicAsset[assetName].parentPath
          go.transform.parent = self.transform:Find(parentPath)
          local tabComp = self:AddComponent(DynamicAsset[assetName].class, parentPath .. "/" .. assetName, v.param1, self.battleManagerParam)
          self.tabComps[i].comp = tabComp
          tabComp:SetLocalScale(Vector3.one)
          tabComp:SetAnchorMinXY(0.5, 0)
          tabComp:SetAnchorMaxXY(0.5, 1)
          tabComp:SetAnchoredPositionXY(0, -594)
          tabComp:SetSizeDeltaXY(646, -784)
          if self.tabIdx == i then
            tabComp:SetActive(true)
            tabComp:RefreshView()
            tabComp:FadeIn()
          else
            tabComp:SetActive(false)
          end
        end)
        self.dynamicReqs[assetName] = req
      end
    elseif tabComp then
      tabComp:SetActive(false)
    end
  end
end

function M:OnTabBtnClick(idx)
  if self.tabIdx == idx then
    return
  end
  self.tabIdx = idx
  self:RefreshView()
  if not IsNull(self.tabTween) then
    self.tabTween:Kill()
    self.tabTween = nil
  end
  self.tabTween = CS.DG.Tweening.DOTween.To(function()
    return self.highlightMask:GetAnchoredPositionX()
  end, function(value)
    self.highlightMask:SetAnchoredPositionXY(value, -1)
    self.highlightInner:SetAnchoredPositionXY(-value, 0)
  end, (self.tabIdx - 1) * 223, 0.5):SetEase(CS.DG.Tweening.Ease.OutQuint)
end

function M:OnBackBtnClick()
  if self.battleManagerParam.enterType == PVEEnterType.T11IdleGameBattleEvent then
    if self.battleManagerParam.type == PVEType.FakePVP then
      self.ctrl:CloseSelf()
      DataCenter.LWBattleManager:Exit(function()
      end)
    end
  else
    DataCenter.LWBattleManager:Exit()
    self.ctrl:CloseSelf()
  end
end

function M:OnTryAgainBtnClick()
  if self.battleManagerParam.enterType == PVEEnterType.T11IdleGameBattleEvent then
    DataCenter.T11IdleGameDataManager:EnterBattle(self.battleManagerParam.extraData.levelId, self.battleManagerParam.extraData.eventUuid)
  end
end

function M:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
end

function M:OnRemoveListener()
  self:RemoveUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
  base.OnRemoveListener(self)
end

function M:OnKeyCodeEscape()
  TimerManager:GetInstance():DelayFrameInvoke(function()
    self:OnBackBtnClick()
  end, 1)
end

return M
