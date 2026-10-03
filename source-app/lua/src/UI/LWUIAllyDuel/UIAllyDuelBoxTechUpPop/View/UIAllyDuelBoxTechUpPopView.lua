local UIAllyDuelBoxTechUpPopView = BaseClass("UIAllyDuelBoxTechUpPopView", UIBaseView)
local base = UIBaseView
local AllianceArmsBox = require("UI.UIActivityCenterTable.Component.AllianceArms.AllianceArmsActivityBoxItem")
local AllianceScoreProg = require("UI.UIActivityCenterTable.Component.AllianceArms.AllianceArmsScoreProgress")
local BOX_NUM_PER_PAGE = 3
local sliderDataTb = {
  {
    num = 0,
    percent = 0,
    isHide = true
  },
  {num = 20, percent = 0.15},
  {num = 50, percent = 0.5},
  {num = 100, percent = 0.85}
}

function UIAllyDuelBoxTechUpPopView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshUI()
end

function UIAllyDuelBoxTechUpPopView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAllyDuelBoxTechUpPopView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.btnBack = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.textUnlockTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.box1 = self.viewSkin:AddComponent(self, AllianceArmsBox, 4)
  self.box2 = self.viewSkin:AddComponent(self, AllianceArmsBox, 5)
  self.box3 = self.viewSkin:AddComponent(self, AllianceArmsBox, 6)
  self.slider = self.viewSkin:AddComponent(self, AllianceScoreProg, 7)
  self.toggle1 = self.viewSkin:AddComponent(self, UIToggle, 8)
  self.toggle2 = self.viewSkin:AddComponent(self, UIToggle, 9)
end

function UIAllyDuelBoxTechUpPopView:ComponentDestroy()
  self.viewSkin = nil
  self.btnPanel = nil
  self.btnBack = nil
  self.textUnlockTip = nil
  self.box1 = nil
  self.box2 = nil
  self.box3 = nil
  self.slider = nil
  self.toggle1 = nil
  self.toggle2 = nil
end

function UIAllyDuelBoxTechUpPopView:DataDefine()
  self.boxes = {
    self.box1,
    self.box2,
    self.box3
  }
end

function UIAllyDuelBoxTechUpPopView:DataDestroy()
end

function UIAllyDuelBoxTechUpPopView:OnAddListener()
  base.OnAddListener(self)
end

function UIAllyDuelBoxTechUpPopView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIAllyDuelBoxTechUpPopView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIAllyDuelBoxTechUpPopView:OnBtnBackClick()
  self.ctrl:CloseSelf()
end

function UIAllyDuelBoxTechUpPopView:RefreshUI()
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
  local eventInfo = activityInfo ~= nil and activityInfo:GetEventInfo() or nil
  local gemPriceList = eventInfo ~= nil and eventInfo.gemPriceList or {}
  local targetList = eventInfo ~= nil and eventInfo.targetList or {}
  local curPage = self:GetUserData() or 1
  local key
  if curPage == 1 then
    self.toggle1:SetIsOn(true)
    key = "221061"
  elseif curPage == 2 then
    self.toggle2:SetIsOn(true)
    key = "221063"
  end
  for i = 1, 3 do
    local box = self.boxes[i]
    local index = (curPage - 1) * BOX_NUM_PER_PAGE + i
    box:SetBoxInfo(index, 0, gemPriceList[index], false)
    box:ShowDiamond(true)
    box:SetLocked(index)
  end
  if key then
    self.textUnlockTip:SetLocalText(key)
  else
    self.textUnlockTip:SetText()
  end
  local curScore = 0
  local lastEndScore = curPage == 1 and 0 or toInt(targetList[(curPage - 1) * 3])
  sliderDataTb[1].num = lastEndScore
  sliderDataTb[2].num = toInt(targetList[(curPage - 1) * BOX_NUM_PER_PAGE + 1])
  sliderDataTb[3].num = toInt(targetList[(curPage - 1) * BOX_NUM_PER_PAGE + 2])
  sliderDataTb[4].num = toInt(targetList[(curPage - 1) * BOX_NUM_PER_PAGE + 3])
  self.slider:SetCurProg(curScore, sliderDataTb)
end

return UIAllyDuelBoxTechUpPopView
