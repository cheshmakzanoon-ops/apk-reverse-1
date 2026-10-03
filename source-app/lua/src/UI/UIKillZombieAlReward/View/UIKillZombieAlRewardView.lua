local UIKillZombieAlRewardView = BaseClass("UIKillZombieAlRewardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIKillZombieAlRewardPreviewItem = require("UI.UIKillZombieAlReward.Component.UIKillZombieAlRewardPreviewItem")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.btnCloseBg = self:AddComponent(UIButton, "CloseBg")
  self.btnCloseBg:SetOnClick(function()
    self:OnBtnCloseBgClick()
  end)
  self.btnClose = self:AddComponent(UIButton, "UICommonPopUpTitle/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "UICommonPopUpTitle/Common_img_title/titleText")
  self.scrollView = self:AddComponent(UIScrollView, "Root/ScrollView")
  self.btnLeftArrow = self:AddComponent(UIButton, "Root/LeftArrow")
  self.btnLeftArrow:SetOnClick(function()
    self:OnBtnLeftArrowClick()
  end)
  self.btnRightArrow = self:AddComponent(UIButton, "Root/RightArrow")
  self.btnRightArrow:SetOnClick(function()
    self:OnBtnRightArrowClick()
  end)
  self.textTip = self:AddComponent(UIText, "Root/TipText")
  self.textTip:SetLocalText("challenge_zombie_reward_desc")
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  self.textTip = nil
  self.btnCloseBg = nil
  self.btnClose = nil
  self.textTitle = nil
  self.scrollView = nil
  self.btnLeftArrow = nil
  self.btnRightArrow = nil
end

local function DataDefine(self)
  self.level, self.maxLevel = self:GetUserData()
  self:Refresh()
end

local function DataDestroy(self)
  self.level = nil
  self.maxLevel = nil
  self.fullScore = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnBtnCloseBgClick(self)
  self.ctrl:CloseSelf()
end

local function OnBtnCloseClick(self)
  self.ctrl:CloseSelf()
end

local function OnBtnLeftArrowClick(self)
  self:OnBtnLeftClick()
end

local function OnBtnRightArrowClick(self)
  self:OnBtnRightClick()
end

local function Refresh(self)
  self:UpdateSwitchState()
  self.textTitle:SetLocalText("challenge_zombie_reward_title", self.level)
  local cfgData = DataCenter.ActivityKillZombieManager:GetDataWithTypeAndLevel(2, self.level)
  local data
  self.fullScore = 0
  if cfgData then
    local curLevelBossId = cfgData.advanced_challenge_boss
    local template = DataCenter.AdvancedChallengeBossTemplateManager:GetTemplate(curLevelBossId)
    local index = 1
    if template then
      data = {}
      local split1 = string.split(template.box_reward, ";")
      for _, v in ipairs(split1) do
        local split2 = string.split(v, "|")
        if 1 < #split2 then
          local num = tonumber(split2[2])
          if num ~= 0 then
            data[index] = split2
            self.fullScore = self.fullScore + num
            index = index + 1
          end
        end
      end
    end
  end
  if data and 0 < #data then
    self.scrollView:SetActive(true)
    self.showDatalist = data
    self.scrollView:SetTotalCount(#self.showDatalist)
    self.scrollView:RefillCells()
  else
    self.scrollView:SetActive(false)
  end
end

local function OnItemMoveIn(self, itemObj, index)
  local item = self.scrollCellPool[itemObj.name]
  if not item then
    local name = tostring(self.itemIndex)
    itemObj.name = name
    item = self.scrollView:AddComponent(UIKillZombieAlRewardPreviewItem, itemObj)
    self.scrollCellPool[name] = item
    self.itemIndex = self.itemIndex + 1
  end
  item:Refresh(self.showDatalist[index], self.fullScore)
end

local function OnItemMoveOut(self, itemObj, index)
end

local function ClearScroll(self)
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(UIKillZombieAlRewardPreviewItem)
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.showDatalist = {}
end

local function OnBtnLeftClick(self)
  if self.level == 1 then
    return
  end
  self.level = self.level - 1
  self:Refresh()
  EventManager:GetInstance():Broadcast(EventId.ChallengeZombieChangeLevelLeft)
end

local function OnBtnRightClick(self)
  if self.level == self.maxLevel then
    UIUtil.ShowTipsId("challenge_zombie_level_select_tips")
    return
  end
  self.level = self.level + 1
  self:Refresh()
  EventManager:GetInstance():Broadcast(EventId.ChallengeZombieChangeLevelRight)
end

local function UpdateSwitchState(self)
  local leftShow = true
  if self.level == 1 then
    leftShow = false
  end
  self.btnLeftArrow:SetActive(leftShow)
end

UIKillZombieAlRewardView.OnCreate = OnCreate
UIKillZombieAlRewardView.OnDestroy = OnDestroy
UIKillZombieAlRewardView.OnEnable = OnEnable
UIKillZombieAlRewardView.OnDisable = OnDisable
UIKillZombieAlRewardView.ComponentDefine = ComponentDefine
UIKillZombieAlRewardView.ComponentDestroy = ComponentDestroy
UIKillZombieAlRewardView.DataDefine = DataDefine
UIKillZombieAlRewardView.DataDestroy = DataDestroy
UIKillZombieAlRewardView.OnAddListener = OnAddListener
UIKillZombieAlRewardView.OnRemoveListener = OnRemoveListener
UIKillZombieAlRewardView.OnBtnCloseBgClick = OnBtnCloseBgClick
UIKillZombieAlRewardView.OnBtnCloseClick = OnBtnCloseClick
UIKillZombieAlRewardView.OnBtnLeftArrowClick = OnBtnLeftArrowClick
UIKillZombieAlRewardView.OnBtnRightArrowClick = OnBtnRightArrowClick
UIKillZombieAlRewardView.Refresh = Refresh
UIKillZombieAlRewardView.OnItemMoveIn = OnItemMoveIn
UIKillZombieAlRewardView.OnItemMoveOut = OnItemMoveOut
UIKillZombieAlRewardView.ClearScroll = ClearScroll
UIKillZombieAlRewardView.OnBtnLeftClick = OnBtnLeftClick
UIKillZombieAlRewardView.OnBtnRightClick = OnBtnRightClick
UIKillZombieAlRewardView.UpdateSwitchState = UpdateSwitchState
return UIKillZombieAlRewardView
