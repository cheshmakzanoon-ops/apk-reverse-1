local UISurfingBattleGuideFinishView = BaseClass("UISurfingBattleGuideFinishView", UIBaseView)
local base = UIBaseView
local result_text_root_path = "SafeArea/ResultTextRoot"
local result_text_path = "SafeArea/ResultTextRoot/ResultText"
local scroll_view_path = "SafeArea/RewardRoot/Scroll View"
local again_btn_path = "SafeArea/BottomGroup/AgainBtnRoot/AgainBtn"
local again_btn_text_path = "SafeArea/BottomGroup/AgainBtnRoot/AgainBtn/LW_Btn_Common_New_Base/AgainBtnText"
local back_btn_path = "SafeArea/BottomGroup/BackBtnRoot/BackBtn"
local back_btn_text_path = "SafeArea/BottomGroup/BackBtnRoot/BackBtn/LW_Btn_Common_New_Base/BackBtnText"
local tip_text_path = "SafeArea/BottomGroup/TipText"

function UISurfingBattleGuideFinishView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function UISurfingBattleGuideFinishView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UISurfingBattleGuideFinishView:ComponentDefine()
  self.result_text_root = self:AddComponent(UIBaseContainer, result_text_root_path)
  self.result_text = self:AddComponent(UITextMeshProUGUIEx, result_text_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnRewardItemMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnRewardItemMoveOut(itemObj, index)
  end)
  self.again_btn = self:AddComponent(UIButton, again_btn_path)
  self.again_btn:SetOnClick(function()
  end)
  self.again_btn_text = self:AddComponent(UITextMeshProUGUIEx, again_btn_text_path)
  self.again_btn_text:SetLocalText("parkour_settlement_start_btn")
  self.back_btn = self:AddComponent(UIButton, back_btn_path)
  self.back_btn:SetOnClick(function()
    self:OnBackBtnClick()
  end)
  self.back_btn_text = self:AddComponent(UITextMeshProUGUIEx, back_btn_text_path)
  self.back_btn_text:SetLocalText("parkour_settlement_close_btn")
  self.tip_text = self:AddComponent(UITextMeshProUGUIEx, tip_text_path)
end

function UISurfingBattleGuideFinishView:ComponentDestroy()
  self.result_text_root = nil
  self.result_text = nil
  self:ClearScroll()
  self.scroll_view = nil
  self.again_btn = nil
  self.again_btn_text = nil
  self.back_btn = nil
  self.back_btn_text = nil
  self.tip_text = nil
end

function UISurfingBattleGuideFinishView:DataDefine()
  self.logic = nil
  self.dataList = nil
  self.message = nil
end

function UISurfingBattleGuideFinishView:DataDestroy()
  self.logic = nil
  self.dataList = nil
  self.message = nil
end

function UISurfingBattleGuideFinishView:OnAddListener()
  base.OnAddListener(self)
end

function UISurfingBattleGuideFinishView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UISurfingBattleGuideFinishView:InitView()
  DataCenter.LWSoundManager:PlaySound(11051, false)
  local data = self:GetUserData()
  local skip = data and data.skip
  local rewarded = data and data.rewarded
  if skip then
    if rewarded then
      self.result_text:SetLocalText("parkour_guide_reward_4")
      return
    else
      self.result_text:SetLocalText("parkour_guide_reward_3")
    end
  elseif rewarded then
    self.result_text:SetLocalText("parkour_guide_reward_2")
    return
  else
    self.result_text:SetLocalText("parkour_guide_reward_1")
  end
  local type = data.type or 1
  local rewardConfig = ""
  if type == 1 then
    rewardConfig = LuaEntry.DataConfig:TryGetStr("surfing_config", "k20")
  else
    rewardConfig = LuaEntry.DataConfig:TryGetStr("parkour_ghost_config", "k22")
  end
  if string.IsNullOrEmpty(rewardConfig) then
    return
  end
  local rewardList = DataCenter.RewardManager:ParseRewardsStr(rewardConfig)
  self.dataList = rewardList
  self.scroll_view:SetTotalCount(#self.dataList)
  self.scroll_view:RefillCells()
end

function UISurfingBattleGuideFinishView:OnRewardItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_view:AddComponent(UICommonResItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(self.dataList[index])
  end
end

function UISurfingBattleGuideFinishView:OnRewardItemMoveOut(itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UICommonResItem)
end

function UISurfingBattleGuideFinishView:ClearScroll()
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UICommonResItem)
end

function UISurfingBattleGuideFinishView:OnBackBtnClick()
  self.ctrl:CloseSelf()
  DataCenter.LWSurfingDataManager:GoBackToActivityPanel()
end

return UISurfingBattleGuideFinishView
