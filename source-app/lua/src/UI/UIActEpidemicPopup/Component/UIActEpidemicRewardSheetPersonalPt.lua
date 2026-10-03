local base = UIAsyncContainer
local UIActEpidemicRewardSheetPersonalPt = BaseClass("UIActEpidemicRewardSheetPersonalPt", base)
local Localization = CS.GameEntry.Localization
local UIActEpidemicRewardSheetPersonalRewardItem = require("UI.UIActEpidemicPopup.Component.UIActEpidemicRewardSheetPersonalRewardItem")

local function OnCreate(self, view)
  base.OnCreate(self)
  self.view = view
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearDropListDynamicCreate()
  self:ClearScrollRewards()
  self.sideInfos = nil
  self.rewardList = nil
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
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTmpDropTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textTmpDropSelectLabel = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnShowDropList = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnShowDropList:SetOnClick(function()
    self:OnBtnShowDropListClick()
  end)
  self.imgBtnShowDropList = self.viewSkin:AddComponent(self, UIImage, 4)
  self.btnCollapseDropList = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnCollapseDropList:SetOnClick(function()
    self:OnBtnCollapseDropListClick()
  end)
  self.compDropExpandRootLayout = self.viewSkin:AddComponent(self, UIBaseComponent, 6)
  self.compDropSelectItemRenderer = self.viewSkin:AddComponent(self, UIBaseComponent, 7)
  self.compDropExpandRoot = self.viewSkin:AddComponent(self, UIBaseComponent, 8)
  self.scrollViewRewardsRect = self.viewSkin:AddComponent(self, UIScrollView, 9)
  self.compTitleBg = self.viewSkin:AddComponent(self, UIBaseComponent, 10)
  self.textTmpMyScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 12)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.scrollViewRewardsRect:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveInRewards(itemObj, index)
  end)
  self.scrollViewRewardsRect:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOutRewards(itemObj, index)
  end)
  self:InitSheet()
  self.textTmpDropTitle:SetLocalText("YiBianJinQu_skill_charge_tips_3")
  self.currentSide = nil
  self.isExpandDropList = nil
  self.dropListItems = nil
  self:CollapseDropList()
  self:SwitchSide(self:GetMyScoreType())
end

function UIActEpidemicRewardSheetPersonalPt:GetMyScoreType()
  local myScoreType = ActEpidemicUtils.GetMyBattleScoreType()
  return myScoreType
end

local function ComponentDestroy(self)
  self.viewSkin = nil
  self.textTmpDropTitle = nil
  self.textTmpDropSelectLabel = nil
  self.btnShowDropList = nil
  self.imgBtnShowDropList = nil
  self.btnCollapseDropList = nil
  self.compDropExpandRootLayout = nil
  self.compDropSelectItemRenderer = nil
  self.compDropExpandRoot = nil
  self.scrollViewRewardsRect = nil
  self.compTitleBg = nil
  self.textTmpMyScore = nil
  self.btnInfo = nil
end

function UIActEpidemicRewardSheetPersonalPt:InitSheet()
  self.sideInfos = {
    {
      key = "YiBianJinQu_role_name_1",
      side = EpidemicBattleScoreType.Arbiter
    },
    {
      key = "YiBianJinQu_role_name_2",
      side = EpidemicBattleScoreType.Lord
    },
    {
      key = "YiBianJinQu_role_name_3",
      side = EpidemicBattleScoreType.Farmer
    }
  }
  UIUtil.SetTextLit(self.compTitleBg.transform, "Label0", "YiBianJinQu_battle_detail_tips_1")
  UIUtil.SetTextLit(self.compTitleBg.transform, "Label1", "YiBianJinQu_reward_tips_1")
end

function UIActEpidemicRewardSheetPersonalPt:CollapseDropList()
  if self.isExpandDropList == false then
    return
  end
  self.isExpandDropList = false
  self.compDropExpandRoot:SetActive(false)
  self.imgBtnShowDropList:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_2.png")
end

function UIActEpidemicRewardSheetPersonalPt:OnBtnCollapseDropListClick()
  self:CollapseDropList()
end

local function _getScoreNameLabel(type, myType, label)
  if type == myType then
    return string.format("%s<color=#CB6565>(%s)</color>", label, Localization:GetString("Treasure_map_38"))
  else
    return label
  end
end

function UIActEpidemicRewardSheetPersonalPt:ExpandDropList()
  if self.isExpandDropList == true then
    return
  end
  self.isExpandDropList = true
  self.compDropExpandRoot:SetActive(true)
  self.imgBtnShowDropList:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_1.png")
  if not self.dropListItems then
    self.dropListItems = {}
    local _temp = {}
    local _go = CS.UnityEngine.GameObject
    local typeOfBtn = typeof(CS.UnityEngine.UI.Button)
    local typeOfTmp = typeof(CS.TextMeshProUGUIEx)
    local _template = self.compDropSelectItemRenderer.gameObject
    table.insert(_temp, _template)
    for i = 1, #self.sideInfos - 1 do
      local go = _go.Instantiate(_template, self.compDropExpandRootLayout.transform)
      table.insert(_temp, go)
    end
    for k, v in ipairs(_temp) do
      local info = self.sideInfos[k]
      local btn = v:GetComponent(typeOfBtn)
      local goActive = v.transform:Find("active").gameObject
      local tmp = v.transform:Find("Label"):GetComponent(typeOfTmp)
      btn.onClick:RemoveAllListeners()
      btn.onClick:AddListener(function()
        self:SwitchSide(info.side)
      end)
      table.insert(self.dropListItems, {
        btn = btn,
        gameObject = v,
        delete = k ~= 1,
        side = self.sideInfos[k].side,
        goActive = goActive,
        text = Localization:GetString(info.key),
        tmp = tmp
      })
    end
  end
  local myScoreType = self:GetMyScoreType()
  if self.dropListItems then
    for k, v in ipairs(self.dropListItems) do
      if v.goActive then
        v.goActive:SetActive(v.side == self.currentSide)
      end
      v.tmp.text = _getScoreNameLabel(v.side, myScoreType, v.text)
    end
  end
end

function UIActEpidemicRewardSheetPersonalPt:ClearDropListDynamicCreate()
  if self.dropListItems then
    for k, v in ipairs(self.dropListItems) do
      if IsNotNull(v.btn) then
        v.btn.onClick:RemoveAllListeners()
      end
      if v.delete and IsNotNull(v.gameObject) then
        CS.UnityEngine.GameObject.Destroy(v.gameObject)
      end
    end
    self.dropListItems = nil
  end
end

function UIActEpidemicRewardSheetPersonalPt:SwitchSide(side)
  if not side or side == EpidemicBattleScoreType.None then
    side = EpidemicBattleScoreType.Arbiter
  end
  if self.currentSide == side then
    self:CollapseDropList()
    return
  end
  self:CollapseDropList()
  self.currentSide = side
  local info = self.sideInfos[side]
  if info then
    local _text = Localization:GetString(info.key)
    self.textTmpDropSelectLabel:SetText(_getScoreNameLabel(side, self:GetMyScoreType(), _text))
  end
  self:RefreshRewardList()
end

function UIActEpidemicRewardSheetPersonalPt:OnBtnShowDropListClick()
  if self.isExpandDropList then
    self:CollapseDropList()
  else
    self:ExpandDropList()
  end
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.myScore = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function UIActEpidemicRewardSheetPersonalPt:RefreshMyInfo()
  local groupIdx = ActEpidemicUtils.GetMyGroupIndex()
  local stage = DataCenter.ActEpidemicZoneManager:FixStage(groupIdx)
  if stage ~= EpidemicZoneStage.Battle then
    self.myScore = 0
    self.textTmpMyScore:SetActive(false)
    return
  end
  self.textTmpMyScore:SetActive(true)
  local myRankInfo = DataCenter.ActEpidemicZoneManager:GetMyScoreRankInfo()
  self.myScore = myRankInfo and myRankInfo.score or 0
  self.textTmpMyScore:SetLocalText("100350", string.GetFormattedSeparatorNum(self.myScore))
end

function UIActEpidemicRewardSheetPersonalPt:RefreshRewardList()
  self:RefreshMyInfo()
  self.rewardList = DataCenter.ActEpidemicZoneManager:GetScoreRewardsBySide(self.currentSide)
  self.myRewardIndex = 0
  if #self.rewardList > 0 then
    if 0 < self.myScore then
      for k, v in ipairs(self.rewardList) do
        local score = v[1] or 0
        if score <= self.myScore then
          self.myRewardIndex = k
        end
      end
    end
    self.scrollViewRewardsRect:SetTotalCount(#self.rewardList)
    self.scrollViewRewardsRect:RefillCells()
  end
end

function UIActEpidemicRewardSheetPersonalPt:OnItemMoveInRewards(itemObj, index)
  itemObj.name = tostring(index)
  local reward = self.rewardList[index]
  local cellItem = self.scrollViewRewardsRect:AddComponent(UIActEpidemicRewardSheetPersonalRewardItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(index, {
      score = reward[1] or 0,
      rewardId = reward[2] or 0,
      my = self.myRewardIndex == index
    })
  end
end

function UIActEpidemicRewardSheetPersonalPt:OnItemMoveOutRewards(itemObj, index)
  self.scrollViewRewardsRect:RemoveComponent(itemObj.name, UIActEpidemicRewardSheetPersonalRewardItem)
end

function UIActEpidemicRewardSheetPersonalPt:ClearScrollRewards()
  if self.scrollViewRewardsRect then
    self.scrollViewRewardsRect:ClearCells()
    self.scrollViewRewardsRect:RemoveComponents(UIActEpidemicRewardSheetPersonalRewardItem)
  end
end

function UIActEpidemicRewardSheetPersonalPt:RefreshSheet()
end

function UIActEpidemicRewardSheetPersonalPt:RefreshCurrentRole(role)
end

function UIActEpidemicRewardSheetPersonalPt:UpdateCurrentRole(role)
end

function UIActEpidemicRewardSheetPersonalPt:OnBtnInfoClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIEpidemicBattleSkillPoint)
end

UIActEpidemicRewardSheetPersonalPt.OnCreate = OnCreate
UIActEpidemicRewardSheetPersonalPt.OnDestroy = OnDestroy
UIActEpidemicRewardSheetPersonalPt.OnEnable = OnEnable
UIActEpidemicRewardSheetPersonalPt.OnDisable = OnDisable
UIActEpidemicRewardSheetPersonalPt.ComponentDefine = ComponentDefine
UIActEpidemicRewardSheetPersonalPt.ComponentDestroy = ComponentDestroy
UIActEpidemicRewardSheetPersonalPt.DataDefine = DataDefine
UIActEpidemicRewardSheetPersonalPt.DataDestroy = DataDestroy
UIActEpidemicRewardSheetPersonalPt.OnAddListener = OnAddListener
UIActEpidemicRewardSheetPersonalPt.OnRemoveListener = OnRemoveListener
return UIActEpidemicRewardSheetPersonalPt
