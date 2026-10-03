local base = UIBaseContainer
local UILWT11IdleGameBattleRewardPreviewItemComponent = BaseClass("UILWT11IdleGameBattleRewardPreviewItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWT11IdleGameBattleRewardPreviewItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWT11IdleGameBattleRewardPreviewItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWT11IdleGameBattleRewardPreviewItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgHeadIcon = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textHeadTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textHeadDes = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.compReward = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.textHeadTitleBoss = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textHeadDesBoss = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.compNormal = self.viewSkin:AddComponent(self, UIBaseComponent, 8)
  self.compBoss = self.viewSkin:AddComponent(self, UIBaseComponent, 9)
  self.textHeadProb = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
end

function UILWT11IdleGameBattleRewardPreviewItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.imgHeadIcon = nil
  self.textHeadTitle = nil
  self.textHeadDes = nil
  self.compContent = nil
  self.compReward = nil
  self.textHeadTitleBoss = nil
  self.textHeadDesBoss = nil
  self.compNormal = nil
  self.compBoss = nil
  self.textHeadProb = nil
end

function UILWT11IdleGameBattleRewardPreviewItemComponent:DataDefine()
  self.rewards = nil
end

function UILWT11IdleGameBattleRewardPreviewItemComponent:DataDestroy()
  self.rewards = nil
end

function UILWT11IdleGameBattleRewardPreviewItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWT11IdleGameBattleRewardPreviewItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWT11IdleGameBattleRewardPreviewItemComponent:ReInit(icon, title, des, prob, rewards)
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
      self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.transform:SetParent(self.compContent.transform)
        go.transform:Set_localScale(0.9, 0.9, 0.9)
        go.transform.pivot = Vector2.New(0, 1)
        go.name = "item" .. i
        local cell = self.compContent:AddComponent(UICommonResItem, go.name)
        cell:ReInit(v)
      end)
    end
  end
end

return UILWT11IdleGameBattleRewardPreviewItemComponent
