local base = UIBaseContainer
local UIWorldLLCityPointReward = BaseClass("UIWorldLLCityPointReward", UIBaseContainer)
local RewardUtil = require("Util.RewardUtil")
local Localization = CS.GameEntry.Localization

function UIWorldLLCityPointReward:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIWorldLLCityPointReward:OnDestroy()
  self:ClearRewards()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWorldLLCityPointReward:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnSwitch = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnSwitch:SetOnClick(function()
    self:OnBtnSwitchClick()
  end)
  self.textRewardTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.scrollRectScrollView = self.viewSkin:AddComponent(self, UIScrollRect, 3)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
end

function UIWorldLLCityPointReward:ComponentDestroy()
  self.viewSkin = nil
  self.btnSwitch = nil
  self.textRewardTips = nil
  self.scrollRectScrollView = nil
  self.compContent = nil
end

function UIWorldLLCityPointReward:DataDefine()
  self.reqList = {}
end

function UIWorldLLCityPointReward:DataDestroy()
  self.reqList = nil
end

function UIWorldLLCityPointReward:OnAddListener()
  base.OnAddListener(self)
end

function UIWorldLLCityPointReward:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIWorldLLCityPointReward:OnBtnSwitchClick()
  self:RefreshCamp(self.curCampId == LLConst.LandLordGroup.LORD and LLConst.LandLordGroup.FARMER or LLConst.LandLordGroup.LORD)
  self:RefreshRewards()
end

function UIWorldLLCityPointReward:Refresh(data)
  if self.activeSelf then
    self.data = data
    self.landlordCityTemplate = data.landlordCityTemplate
    local myCampId = DataCenter.LandlordMgr:GetMyGroup()
    self:RefreshCamp(myCampId)
    self:RefreshRewards()
  end
end

function UIWorldLLCityPointReward:RefreshCamp(campId)
  self.curCampId = campId ~= LLConst.LandLordGroup.NONE and campId or LLConst.LandLordGroup.LORD
  self.textRewardTips:SetLocalText(self.curCampId == LLConst.LandLordGroup.LORD and "zonewar_landlord_limit_1004" or "zonewar_landlord_limit_1003")
end

function UIWorldLLCityPointReward:ClearRewards()
  self.compContent:RemoveComponents(UICommonResItem)
  if self.reqList ~= nil then
    for k, v in pairs(self.reqList) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
    self.reqList = {}
  end
end

function UIWorldLLCityPointReward:RefreshRewards()
  if self.landlordCityTemplate then
    local rewardId = self.curCampId == LLConst.LandLordGroup.LORD and self.landlordCityTemplate.defend_reward or self.landlordCityTemplate.battle_destroy_reward
    self.rewardList = RewardUtil.GetRewardItemAndResource(rewardId)
    self:ClearRewards()
    local dataList = self.rewardList
    if not dataList or #dataList == 0 then
      return
    end
    for i = 1, #dataList do
      local idx = i
      local data = dataList[idx]
      self.reqList[idx] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.compContent.transform)
        go.transform:Set_localScale(0.72, 0.72, 0.72)
        go.name = "reward" .. idx
        local cell = self.compContent:AddComponent(UICommonResItem, go.name)
        cell:ParseInfo(data)
      end)
    end
  end
end

return UIWorldLLCityPointReward
