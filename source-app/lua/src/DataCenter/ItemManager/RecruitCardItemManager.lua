local RecruitCardItemManager = BaseClass("RecruitCardItemManager")

local function __init(self)
  self:AddListeners()
end

local function __delete(self)
  self:RemoveListeners()
end

local function OnItemRefresh(itemInfo)
  local isOn = Setting:GetBool(SettingKeys.RECRUIT_CARD_REWARD_GET, true)
  if not isOn then
    return
  end
  TimerManager:GetInstance():DelayInvoke(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIRecruitCardRewardGet, {anim = true}, itemInfo)
  end, 0.5)
end

local function AddListeners(self)
  EventManager:GetInstance():AddListener(EventId.GF_recruit_card_refreshed, self.OnItemRefresh)
end

local function RemoveListeners(self)
  EventManager:GetInstance():RemoveListener(EventId.GF_recruit_card_refreshed, self.OnItemRefresh)
end

local function InitData(self)
end

RecruitCardItemManager.__init = __init
RecruitCardItemManager.__delete = __delete
RecruitCardItemManager.AddListeners = AddListeners
RecruitCardItemManager.RemoveListeners = RemoveListeners
RecruitCardItemManager.OnItemRefresh = OnItemRefresh
RecruitCardItemManager.InitData = InitData
return RecruitCardItemManager
