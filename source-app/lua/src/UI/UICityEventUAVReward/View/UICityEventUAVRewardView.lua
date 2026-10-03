local UICityEventUAVRewardView = BaseClass("UICityEventUAVRewardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local AchieveItem = require("UI.UICityEventUAVReward.Component.UICityEventUAVRewardAchieveItem")
local txt_title_path = "Main/top/txtTitle"
local btn_close_path = "Main/top/btnClose"
local scroll_achieve_path = "Main/top/bg2/scrollAchieve"
local black_path = "black"

function UICityEventUAVRewardView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
  self:PlaySound()
end

function UICityEventUAVRewardView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UICityEventUAVRewardView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CityEventTaskUpdate, self.ReInit)
end

function UICityEventUAVRewardView:OnRemoveListener()
  self:RemoveUIListener(EventId.CityEventTaskUpdate, self.ReInit)
  base.OnRemoveListener(self)
end

function UICityEventUAVRewardView:ComponentDefine()
  self.mainAnimator = self:AddComponent(UIAnimator, "")
  self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
  self.btn_close = self:AddComponent(UIButton, btn_close_path)
  self.scroll_achieve = self:AddComponent(UIDynamicVerticleScrollRectEx, scroll_achieve_path)
  self.btn_close:SetOnClick(function()
    self:CloseWithAnim()
  end)
  self.itemIncNo = 1
  self.itemMap = {}
  self.scroll_achieve:AddInstantiateItemListener(function(itemObj, prefabIdx)
    itemObj.name = "achieveItem_" .. self.itemIncNo
    self.itemIncNo = self.itemIncNo + 1
    local achieveItem = self:AddComponent(AchieveItem, itemObj)
    self.itemMap[itemObj] = achieveItem
  end)
  self.scroll_achieve:AddDisplayItemListener(function(itemObj, dataIdx)
    local achieveItem = self.itemMap[itemObj]
    local data = self.rewardDatas[dataIdx + 1]
    achieveItem:Refresh(data)
  end)
  self.black = self:AddComponent(UIButton, black_path)
  self.black:SetOnClick(function()
    self:CloseWithAnim()
  end)
  local cityEventName = DataCenter.LWBeginnerDirectorManager:GetCurCityEventName()
  self.txt_title:SetLocalText(cityEventName)
end

function UICityEventUAVRewardView:ComponentDestroy()
  if self.closingTimer then
    self.closingTimer:Stop()
    self.closingTimer = nil
  end
  self.mainAnimator = nil
  self.txt_title = nil
  self.btn_close = nil
  self.scroll_achieve = nil
  self.black = nil
  self.itemMap = nil
end

function UICityEventUAVRewardView:DataDefine()
end

function UICityEventUAVRewardView:DataDestroy()
end

function UICityEventUAVRewardView:CloseWithAnim()
  if self.mainAnimator then
    local sucess, time = self.mainAnimator:PlayAnimationReturnTime("UICityEventUAVRewardsOut")
    if self.closingTimer then
      self.closingTimer:Stop()
      self.closingTimer = nil
    end
    if sucess then
      self.closingTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.closingTimer = nil
        self.ctrl:CloseSelf()
      end, time)
    else
      self.ctrl:CloseSelf()
    end
  end
end

function UICityEventUAVRewardView:ReInit()
  local cityEventId = DataCenter.LWBeginnerDirectorManager:GetCurCityEventID()
  if cityEventId ~= BeginnerDirectorEvent.UAV_Repaire then
    self:CloseWithAnim()
    return
  end
  if DataCenter.LWBeginnerDirectorManager:IsCurCityEventAllTaskReceived() then
    self:CloseWithAnim()
    return
  end
  local cityEventTaskArr = DataCenter.LWBeginnerDirectorManager:GetCurCityEventTaskArr()
  table.sort(cityEventTaskArr, function(a, b)
    if a.state ~= b.state and (a.state > 1 or b.state > 1) then
      return a.state < b.state
    else
      local taskIdA = tonumber(a.taskId)
      local taskIdB = tonumber(b.taskId)
      return taskIdA < taskIdB
    end
  end)
  self.rewardDatas = cityEventTaskArr
  self.scroll_achieve:SetDatas(self.rewardDatas)
  self.scroll_achieve:UpdateItems()
end

function UICityEventUAVRewardView:PlaySound()
  local soundId = DataCenter.LWBeginnerDirectorManager:GetCurCityEventUIPopSound()
  if soundId and 0 < soundId then
    DataCenter.LWSoundManager:PlaySound(soundId, false)
  end
end

return UICityEventUAVRewardView
