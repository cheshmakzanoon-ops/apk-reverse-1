local UIAttackCityS0ParkourBonusResultView = BaseClass("UIAttackCityS0ParkourBonusResultView", UIBaseView)
local UIParkourBonusResultRewardPanel = require("UI.LWCityAttackS0.Radar.Result.Component.UIRadarBonusResultRewardPanel")
local Const = require("Scene.LWBattle.Const")
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIAttackCityS0ParkourBonusResultView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIAttackCityS0ParkourBonusResultView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAttackCityS0ParkourBonusResultView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnImage = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnImage:SetOnClick(function()
    self:OnBtnImageClick()
  end)
  self.compRewardPanel = self.viewSkin:AddComponent(self, UIParkourBonusResultRewardPanel, 2)
  self.compAddRewardPanel = self.viewSkin:AddComponent(self, UIParkourBonusResultRewardPanel, 3)
  self.btnClaim = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnClaim:SetOnClick(function()
    self:OnBtnClaimClick()
  end)
end

function UIAttackCityS0ParkourBonusResultView:ComponentDestroy()
  self.viewSkin = nil
  self.btnImage = nil
  self.compRewardPanel = nil
  self.compAddRewardPanel = nil
  self.btnClaim = nil
end

function UIAttackCityS0ParkourBonusResultView:DataDefine()
  self.param = self:GetUserData()
  self:Refresh()
end

function UIAttackCityS0ParkourBonusResultView:DataDestroy()
  self.param = nil
end

function UIAttackCityS0ParkourBonusResultView:OnAddListener()
  base.OnAddListener(self)
end

function UIAttackCityS0ParkourBonusResultView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIAttackCityS0ParkourBonusResultView:OnBtnImageClick()
end

function UIAttackCityS0ParkourBonusResultView:OnBtnClaimClick()
  local cfg = {}
  for k, v in pairs(self.compRewardPanel:GetFlyReward()) do
    local data = {
      k.position,
      v
    }
    table.insert(cfg, data)
  end
  self.ctrl:CloseSelf()
  DataCenter.LWBattleManager:GetCurBattleLogic():NoticeWin()
  DataCenter.LWBattleManager:Exit(function()
    EventManager:GetInstance():Broadcast(EventId.UIMainFlyReward, cfg)
  end, "win")
end

function UIAttackCityS0ParkourBonusResultView:Refresh()
  if self.param.stageRewardList then
    local rewardList = DataCenter.RewardTemplateManager:GetRewardByIdList(self.param.stageRewardList)
    self.compRewardPanel:Refresh(rewardList)
  end
  self.btnClaim:SetActive(true)
end

return UIAttackCityS0ParkourBonusResultView
