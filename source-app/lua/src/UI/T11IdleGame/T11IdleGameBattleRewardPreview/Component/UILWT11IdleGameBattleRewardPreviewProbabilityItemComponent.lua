local base = UIBaseContainer
local UILWT11IdleGameBattleRewardPreviewProbabilityItemComponent = BaseClass("UILWT11IdleGameBattleRewardPreviewProbabilityItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")
local UILWT11IdleGameBattleRewardPreviewProbabilityResItemComponent = require("UI/T11IdleGame/T11IdleGameBattleRewardPreview/Component/UILWT11IdleGameBattleRewardPreviewProbabilityResItemComponent")

function UILWT11IdleGameBattleRewardPreviewProbabilityItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWT11IdleGameBattleRewardPreviewProbabilityItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWT11IdleGameBattleRewardPreviewProbabilityItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compNormal = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.imgHeadIcon = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textHeadTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textHeadDes = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.compBoss = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.textHeadTitleBoss = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textHeadDesBoss = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.compReward = self.viewSkin:AddComponent(self, UIBaseComponent, 8)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 9)
  self.textHeadProb = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
end

function UILWT11IdleGameBattleRewardPreviewProbabilityItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compNormal = nil
  self.imgHeadIcon = nil
  self.textHeadTitle = nil
  self.textHeadDes = nil
  self.compBoss = nil
  self.textHeadTitleBoss = nil
  self.textHeadDesBoss = nil
  self.compReward = nil
  self.compContent = nil
  self.textHeadProb = nil
end

function UILWT11IdleGameBattleRewardPreviewProbabilityItemComponent:DataDefine()
  self.rewards = nil
end

function UILWT11IdleGameBattleRewardPreviewProbabilityItemComponent:DataDestroy()
  self.rewards = nil
end

function UILWT11IdleGameBattleRewardPreviewProbabilityItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWT11IdleGameBattleRewardPreviewProbabilityItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWT11IdleGameBattleRewardPreviewProbabilityItemComponent:ReInit(icon, title, des, prob, rewards)
  local isBoss = icon == nil
  self.compNormal:SetActive(not isBoss)
  self.compBoss:SetActive(isBoss)
  if not isBoss then
    self.imgHeadIcon:LoadSprite(icon)
    self.textHeadTitle:SetText(title)
    self.textHeadDes:SetText(des)
    self.textHeadProb:SetActive(prob ~= nil)
    if prob ~= nil then
      self.textHeadProb:SetText(prob)
    end
  else
    self.textHeadTitleBoss:SetText(title)
    self.textHeadDesBoss:SetText(des)
  end
  self.rewards = rewards
  self.compReward:SetActive(not table.IsNullOrEmpty(self.rewards))
  if not table.IsNullOrEmpty(self.rewards) then
    for i, v in ipairs(self.rewards) do
      self:GameObjectInstantiateAsync(Const.BattleRewardPreviewProbRes, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.transform:SetParent(self.compContent.transform)
        go.transform:Set_localScale(1, 1, 1)
        go.name = "item" .. i
        local cell = self.compContent:AddComponent(UILWT11IdleGameBattleRewardPreviewProbabilityResItemComponent, go.name)
        cell:ReInit(v)
      end)
    end
  end
end

return UILWT11IdleGameBattleRewardPreviewProbabilityItemComponent
