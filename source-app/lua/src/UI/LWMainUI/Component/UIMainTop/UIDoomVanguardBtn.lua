local UIDoomVanguardBtn = BaseClass("UIDoomVanguardBtn", UIBaseContainer)
local base = UIBaseContainer
local Setting = CS.GameEntry.Setting
local bg_path = "Bg"
local btn_text_path = "BtnText"
local common_red_point_path = "CommonRedPoint"
local activity_goto_tip_path = "ActivityGotoTip"
local tip_txt_path = "ActivityGotoTip/tipTxt"
local goto_btn_path = "ActivityGotoTip/gotoBtn"

function UIDoomVanguardBtn:RefreshShowState()
  local isShow = false
  local actList = DataCenter.ActivityListDataManager:GetNowActivityList(false)
  if actList ~= nil then
    for _, v in pairs(actList) do
      local group = v.festivalEntrance
      if group == CommonActivityGroupEnum.DoomVanguard then
        isShow = true
        break
      end
    end
  end
  local needWait = DataCenter.FunctionOnManager:GetNeedWaitById(FunctionOnType.FestivalEntrance, CommonActivityGroupEnum.DoomVanguard)
  if needWait then
    isShow = false
  end
  if isShow then
    self:SetActive(true)
    self:TryShowTips()
    self:OnRedPointRefresh()
  else
    self:SetActive(false)
    self.commonRedPoint:SetActive(false)
  end
end

function UIDoomVanguardBtn:TryShowTips()
  self.tip_root:SetActive(false)
end

function UIDoomVanguardBtn:OnBtnClick()
  self.commonRedPoint:SetViewed()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityCommonGroupShow, CommonActivityGroupEnum.DoomVanguard)
  CommonUtil.FeatureExplorationTrack(FeatureExplorationType.DoomVanguard)
end

function UIDoomVanguardBtn:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIDoomVanguardBtn:OnDestroy()
  self:ComponentDestroy()
  self.groupActList = nil
  base.OnDestroy(self)
end

function UIDoomVanguardBtn:OnRedPointRefresh()
  local count = 0
  self.groupActList = {}
  local actList = DataCenter.ActivityListDataManager:GetNowActivityList(false)
  if actList ~= nil then
    for _, v in pairs(actList) do
      local group = v.festivalEntrance
      if group == CommonActivityGroupEnum.DoomVanguard then
        table.insert(self.groupActList, v)
      end
    end
  end
  for k, v in ipairs(self.groupActList) do
    local redNum = DataCenter.ActivityListDataManager:GetRewardNumByTypeAndId(v.type, v.id)
    if redNum == nil then
      redNum = 0
    end
    if 0 < redNum then
      count = count + tonumber(redNum)
    end
  end
  self.commonRedPoint:SetNum(count)
end

function UIDoomVanguardBtn:ComponentDefine()
  self.bg = self:AddComponent(UIImage, bg_path)
  self.btnText = self:AddComponent(UIText, btn_text_path)
  self.btn = self:AddComponent(UIButton, "")
  self.commonRedPoint = self:AddComponent(UICommonRedPoint, common_red_point_path)
  self.commonRedPoint:SetType(CommonRedPointPriority.Level1)
  self.tip_root = self:AddComponent(UIBaseContainer, activity_goto_tip_path)
  self.tip_txt = self:AddComponent(UIText, tip_txt_path)
  self.goto_btn = self:AddComponent(UIButton, goto_btn_path)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.goto_btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.tip_root:SetActive(false)
  self.btnText:SetLocalText("sevenday_event_des12")
end

function UIDoomVanguardBtn:ComponentDestroy()
  self.bg = nil
  self.btnText = nil
  self.commonRedPoint = nil
  self.tip_root = nil
  self.tip_txt = nil
  self.goto_btn = nil
end

return UIDoomVanguardBtn
