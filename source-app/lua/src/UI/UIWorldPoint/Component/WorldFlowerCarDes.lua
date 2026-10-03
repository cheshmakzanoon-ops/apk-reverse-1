local RewardItem = require("UI.UIWorldPoint.Component.WorldPointRewardItem")
local WorldFlowerCarDes = BaseClass("WorldFlowerCarDes", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local des_txt_path = "BuildDetails/ScrollView/Viewport/Content/desTxt"
local stage_title_path = "BuildInfo/Stage/StageTitle"
local stage_desc_path = "BuildInfo/Stage/StageDesc"
local reward1_desc_path = "BuildInfo/Reward1/Reward1Desc"
local reward1_btn_path = "BuildInfo/Reward1/Reward1Btn"
local content1_path = "BuildInfo/Reward1/ScrollView1/Viewport/Content1"
local reward2_desc_path = "BuildInfo/Reward2/Reward2Desc"
local reward2_btn_path = "BuildInfo/Reward2/Reward2Btn"
local content2_path = "BuildInfo/Reward2/ScrollView2/Viewport/Content2"
local commend_text_path = "BuildInfo/commendText"
local simple_tip_path = "BuildInfo/down/simple_tip"
local time_label_path = "BuildInfo/down/timeLabel"
local down_path = "BuildInfo/down"
local back_btn_path = "nameBg/backBtn"
local name_btn_path = "nameBg/nameBtn"
local name_txt_path = "nameBg/nameTxt"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  self:OnReturnClick()
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.animator = self:AddComponent(UIAnimator, "")
  self.des_txt = self:AddComponent(UIText, des_txt_path)
  self.back_btn = self:AddComponent(UIButton, back_btn_path)
  self.back_btn:SetOnClick(function()
    self:OnReturnClick()
  end)
  self.name_btn = self:AddComponent(UIButton, name_btn_path)
  self.name_btn:SetOnClick(function()
    self:OnInfoClick()
  end)
  self.name_txt = self:AddComponent(UITextMeshProUGUIEx, name_txt_path)
  self.stage_title = self:AddComponent(UITextMeshProUGUIEx, stage_title_path)
  self.stage_desc = self:AddComponent(UITextMeshProUGUIEx, stage_desc_path)
  self.reward1_desc = self:AddComponent(UITextMeshProUGUIEx, reward1_desc_path)
  self.reward1_btn = self:AddComponent(UIButton, reward1_btn_path)
  self.reward1_btn:SetOnClick(function()
    self:OnClickReward1Btn()
  end)
  self.content1 = self:AddComponent(UIBaseContainer, content1_path)
  self.reward2_desc = self:AddComponent(UITextMeshProUGUIEx, reward2_desc_path)
  self.reward2_btn = self:AddComponent(UIButton, reward2_btn_path)
  self.reward2_btn:SetOnClick(function()
    self:OnClickReward2Btn()
  end)
  self.content2 = self:AddComponent(UIBaseContainer, content2_path)
  self.commend_text = self:AddComponent(UITextMeshProUGUIEx, commend_text_path)
  self.simple_tip = self:AddComponent(UITextMeshProUGUIEx, simple_tip_path)
  self.time_label = self:AddComponent(UITextMeshProUGUIEx, time_label_path)
  self.down = self:AddComponent(UIBaseContainer, down_path)
end

local function ComponentDestroy(self)
  self.back_btn = nil
  self.name_btn = nil
  self.name_txt = nil
  self.stage_title = nil
  self.stage_desc = nil
  self.reward1_desc = nil
  self.reward1_btn = nil
  self.content1 = nil
  self.reward2_desc = nil
  self.reward2_btn = nil
  self.content2 = nil
  self.commend_text = nil
  self.simple_tip = nil
  self.time_label = nil
  self.des_txt = nil
end

local function DataDefine(self)
  self.data = nil
  self.updateNextSkillTime = false
  self.protectionEndTime = 0
end

local function DataDestroy(self)
  self.data = nil
end

local function SetAllCellDestroy(self)
  self.content1:RemoveComponents(RewardItem)
  self.content2:RemoveComponents(RewardItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v then
        for key, value in pairs(v) do
          if v ~= nil then
            self:GameObjectDestroy(value)
          end
        end
      end
    end
  end
  self.model = {}
end

local function RefreshData(self, param)
  self.data = param
  self.des_txt:SetLocalText(self.data.des)
  self.name_txt:SetLocalText(self.data.name)
  self.reward1_desc:SetLocalText("season_s4_monster_tips8")
  self.reward2_desc:SetLocalText("season_s4_monster_tips9")
  if self.data.monsterArmorRatio > 0 then
    if 0 < self.data.monsterHpRatio then
      self.commend_text:SetLocalText("season_s4_monster_tips10")
    else
      self.commend_text:SetLocalText("season_s4_monster_tips36")
    end
    self.simple_tip:SetActive(false)
    self.stage_title:SetLocalText("season_s4_monster_tips2")
    self.stage_desc:SetLocalText("season_s4_monster_tips3")
  else
    self.commend_text:SetText(self.data.recommend_power)
    self.simple_tip:SetActive(false)
    local costStamina = MarchUtil.GetCostStaminaByTargetType(MarchTargetType.RALLY_FOR_BOSS)
    self.simple_tip:SetText(math.floor(costStamina))
    self.stage_title:SetLocalText("season_s4_monster_tips4")
    self.stage_desc:SetLocalText("season_s4_monster_tips5")
  end
  self:SetAllCellDestroy()
  self:AddRewardToContainer(self.data.rewardStr, self.content1)
  self:AddRewardToContainer(self.data.possiRewardStr, self.content2)
  UIUtil.CheckEventTrigger(OpMode.ClickBtnBloodyNightFlowerCar)
end

local function AddRewardToContainer(self, list, container)
  if list ~= nil and container then
    container:RemoveComponents(RewardItem)
    if self.model[container] then
      for _, v in pairs(self.model[container]) do
        if v ~= nil then
          v:Destroy()
        end
      end
    end
    self.model = {}
    self.model[container] = {}
    local num = 0
    for i = 1, table.length(list) do
      num = num + 1
      self.model[container][i] = self:GameObjectInstantiateAsync(UIAssets.WorldPointRewardItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(container.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.transform:Set_sizeDelta(150, 150)
        go.transform:Set_pivot(0, 1)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local cell = container:AddComponent(RewardItem, nameStr)
        cell:RefreshData(list[i], self.view.ctrl.type)
      end)
    end
    if self.data.exp ~= nil and self.data.exp > 0 then
      self.model[container][num + 1] = self:GameObjectInstantiateAsync(UIAssets.WorldPointRewardItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(container.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local oneData = {}
        oneData.count = self.data.exp
        oneData.itemColor = "Assets/Main/Sprites/ItemIcons/Common_img_quality_green"
        oneData.iconName = "Assets/Main/Sprites/ItemIcons/item230001.png"
        oneData.itemFlag = ""
        oneData.rewardType = RewardType.EXP
        oneData.itemName = Localization:GetString("100083")
        oneData.itemDesc = Localization:GetString("302010", string.GetFormattedSeperatorNum(self.data.exp))
        oneData.isLocal = true
        local cell = container:AddComponent(RewardItem, nameStr)
        cell:RefreshData(oneData)
      end)
    end
  end
end

local function Update1000MS(self)
  if self.data == nil or self.data.refreshTime == nil then
    self.time_label:SetText("")
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local deltaTime = self.data.refreshTime - curTime
  if self.data ~= nil and 0 < deltaTime then
    self.time_label:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
  else
    self.time_label:SetText("")
  end
end

local function OnInfoClick(self)
  self.back_btn:SetActive(true)
  self.name_btn:SetActive(false)
  if self.animator then
    self.animator:Enable(true)
    self.animator:Play("switchEnter", 0, 0)
  end
end

local function OnReturnClick(self)
  self.back_btn:SetActive(false)
  self.name_btn:SetActive(true)
  if self.animator then
    self.animator:Enable(true)
    self.animator:Play("switchOut", 0, 0)
  end
end

local function OnClickReward1Btn(self)
  local strTip = Localization:GetString("season_s4_monster_tips32")
  UIUtil.ShowBubbleTips(strTip, self.reward1_btn.transform.position, 0, -30, 0)
end

local function OnClickReward2Btn(self)
  DataCenter.FlowerCarDataManager:FetchRankData(self.data.uuid)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIFlowerCarRank, {anim = true}, self.data.uuid)
end

WorldFlowerCarDes.OnCreate = OnCreate
WorldFlowerCarDes.OnDestroy = OnDestroy
WorldFlowerCarDes.OnEnable = OnEnable
WorldFlowerCarDes.OnDisable = OnDisable
WorldFlowerCarDes.ComponentDefine = ComponentDefine
WorldFlowerCarDes.ComponentDestroy = ComponentDestroy
WorldFlowerCarDes.DataDefine = DataDefine
WorldFlowerCarDes.DataDestroy = DataDestroy
WorldFlowerCarDes.RefreshData = RefreshData
WorldFlowerCarDes.AddRewardToContainer = AddRewardToContainer
WorldFlowerCarDes.SetAllCellDestroy = SetAllCellDestroy
WorldFlowerCarDes.OnReturnClick = OnReturnClick
WorldFlowerCarDes.OnInfoClick = OnInfoClick
WorldFlowerCarDes.Update1000MS = Update1000MS
WorldFlowerCarDes.OnClickReward1Btn = OnClickReward1Btn
WorldFlowerCarDes.OnClickReward2Btn = OnClickReward2Btn
return WorldFlowerCarDes
