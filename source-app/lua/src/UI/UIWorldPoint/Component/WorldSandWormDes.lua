local RewardItem = require("UI.UIWorldPoint.Component.WorldPointRewardItem")
local WorldSandWormDes = BaseClass("WorldSandWormDes", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local main_obj_path = "BuildInfo"
local des_obj_path = "BuildDetails"
local content_path = "BuildInfo/ScrollView/Viewport/Content"
local content2_path = "BuildInfo/ScrollView2/Viewport/Content2"
local the_name_path = "TheName"
local animator_path = ""
local icon_path = "BuildInfo/headBg/head/icon"
local time_node_path = "BuildInfo/headBg/head/timeNode"
local time_desc_path = "BuildInfo/headBg/head/timeNode/timeDesc"
local time_text_path = "BuildInfo/headBg/head/timeNode/timeText"
local stun_text_path = "BuildInfo/headBg/head/stunText"
local stun_text_image1_path = "BuildInfo/headBg/head/stunText/Image1"
local stun_text_image2_path = "BuildInfo/headBg/head/stunText/Image2"
local l_w_btn_info_path = "BuildInfo/finder/LW_Btn_Info"
local desc_txt_path = "BuildInfo/headBg/descTxt"
local finder_name_path = "BuildInfo/finder/finderName"
local finder_reward_path = "BuildInfo/finder/finderReward"
local recommend_power_path = "BuildInfo/RecommendPower"
local simple_tip_path = "BuildInfo/simple_tip"
local des_txt_path = "BuildDetails/ScrollView/Viewport/Content/desTxt"
local find_reward_scroll = "BuildInfo/ScrollView"
local find_reward_banner = "BuildInfo/finder"
local reward_path = "BuildInfo/Reward"
local reward_scroll = "BuildInfo/ScrollView2"

function WorldSandWormDes:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.stun_text_image1:LoadSprite("Assets/Main/SeasonRes/S3/Sprites/Sandworm/mjc_S3_judashachong_biaoqingbg.png")
  self.stun_text_image2:LoadSprite("Assets/Main/SeasonRes/S3/Sprites/Sandworm/biaaoqing_xuanyun_stun.png")
end

function WorldSandWormDes:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function WorldSandWormDes:OnEnable()
  base.OnEnable(self)
end

function WorldSandWormDes:OnDisable()
  self:OnReturnClick()
  base.OnDisable(self)
end

function WorldSandWormDes:ComponentDefine()
  self.the_name = self:AddComponent(UITextMeshProUGUIEx, the_name_path)
  self.animator = self:AddComponent(UIAnimator, animator_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.content_2 = self:AddComponent(UIBaseContainer, content2_path)
  self.main_obj_canvas = self:AddComponent(UICanvasGroup, main_obj_path)
  self.des_obj_canvas = self:AddComponent(UICanvasGroup, des_obj_path)
  self.main_obj_canvas:SetAlpha(1)
  self.des_obj_canvas:SetAlpha(1)
  self.des_txt = self:AddComponent(UIText, des_txt_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.time_node = self:AddComponent(UIBaseContainer, time_node_path)
  self.time_desc = self:AddComponent(UITextMeshProUGUIEx, time_desc_path)
  self.time_text = self:AddComponent(UITextMeshProUGUIEx, time_text_path)
  self.stun_text = self:AddComponent(UITextMeshProUGUIEx, stun_text_path)
  self.stun_text_image1 = self:AddComponent(UIImage, stun_text_image1_path)
  self.stun_text_image2 = self:AddComponent(UIImage, stun_text_image2_path)
  self.desc_txt = self:AddComponent(UITextMeshProUGUIEx, desc_txt_path)
  self.finder_name = self:AddComponent(UITextMeshProUGUIEx, finder_name_path)
  self.finder_reward = self:AddComponent(UITextMeshProUGUIEx, finder_reward_path)
  self.reward = self:AddComponent(UITextMeshProUGUIEx, reward_path)
  self.reward:SetLocalText("season_s3_activity_1000074_desc13")
  self.recommend_power = self:AddComponent(UITextMeshProUGUIEx, recommend_power_path)
  self.simple_tip = self:AddComponent(UITextMeshProUGUIEx, simple_tip_path)
  self.tip_btn = self:AddComponent(UIButton, l_w_btn_info_path)
  self.tip_btn:SetOnClick(function()
    local content = Localization:GetString("season_s3_sandworm_tips010")
    if self.data and DataCenter.JungleTrialDataManager:IsChomper(self.data.monsterId) then
      content = Localization:GetString("season6_piranha_kill_reward_desc")
    end
    UIUtil.ShowBubbleTips(content, self.tip_btn.transform.position, 0, -30, -30)
  end)
  self.finderRewardBanner = self:AddComponent(UIBaseContainer, find_reward_banner)
  self.finderRewardScroll = self:AddComponent(UIBaseContainer, find_reward_scroll)
  self.rewardScroll = self:AddComponent(UIBaseContainer, reward_scroll)
end

function WorldSandWormDes:ComponentDestroy()
  self.the_name = nil
  self.animator = nil
  self.content = nil
  self.content_2 = nil
  self.main_obj_canvas = nil
  self.des_obj_canvas = nil
  self.icon = nil
  self.time_node = nil
  self.time_desc = nil
  self.time_text = nil
  self.stun_text = nil
  self.desc_txt = nil
  self.finder_name = nil
  self.finder_reward = nil
  self.reward = nil
  self.recommend_power = nil
  self.simple_tip = nil
  self.des_txt = nil
  self.tip_btn = nil
  self.finderRewardBanner = nil
  self.finderRewardScroll = nil
  self.rewardScroll = nil
end

function WorldSandWormDes:DataDefine()
end

function WorldSandWormDes:DataDestroy()
  self.data = nil
end

function WorldSandWormDes:SetAllCellDestroy()
  self.content:RemoveComponents(RewardItem)
  self.content_2:RemoveComponents(RewardItem)
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

function WorldSandWormDes:RefreshData(data)
  self.data = data
  self:RefreshView()
end

function WorldSandWormDes:UpdateData()
  self.expireTime = nil
  self.stateEndTime = nil
  local data = self.data
  if data == nil or data.name == nil then
    return
  end
  if DataCenter.JungleTrialDataManager:IsChomper(data.monsterId) then
    self.time_desc:SetLocalText("season6_piranha_leave_time")
    self.finder_reward:SetLocalText("season6_piranha_kill_reward")
  else
    self.time_desc:SetLocalText("season_s3_activity_1000074_desc10")
    self.finder_reward:SetLocalText("season_s3_activity_1000074_desc12")
  end
  self.the_name:SetLocalText(data.name)
  self.icon:LoadSprite(data.icon)
  self.simple_tip:SetText(data.stamina)
  self.expireTime = data.expireTime
  if data.state == 0 then
    self.time_node:SetActive(true)
    self.stun_text:SetActive(false)
  else
    self.time_node:SetActive(false)
    self.stun_text:SetActive(true)
    if data.stateEndTime and data.expireTime then
      self.stateEndTime = math.min(data.stateEndTime, data.expireTime)
    end
  end
  self:Update1000MS()
  self.des_txt:SetLocalText(data.des)
  self.desc_txt:SetLocalText(data.special_info)
  self.recommend_power:SetText(data.recommend_power)
  self.finder_name:SetLocalText("season_s3_activity_1000074_desc11", UIUtil.FormatServerAllianceName(data.finderServerId, data.finderAbbr, data.finderName, data.finderUid))
  self:SetAllCellDestroy()
  if not data.discover_reward_show or #data.discover_reward_show == 0 then
    self.finderRewardBanner:SetActive(false)
    self.finderRewardScroll:SetActive(false)
  else
    self.finderRewardBanner:SetActive(true)
    self.finderRewardScroll:SetActive(true)
    self:AddRewardToContainer(data.discover_reward_show, self.content)
  end
  if not data.world_treasure_show or #data.world_treasure_show == 0 then
    self.reward:SetActive(false)
    self.rewardScroll:SetActive(false)
  else
    self.reward:SetActive(true)
    self.rewardScroll:SetActive(true)
    self:AddRewardToContainer(data.world_treasure_show, self.content_2)
  end
end

function WorldSandWormDes:AddRewardToContainer(list, container)
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

function WorldSandWormDes:OnInfoClick()
  self.animator:Enable(true)
  self.animator:Play("switchEnter", 0, 0)
end

function WorldSandWormDes:OnReturnClick()
  self.animator:Enable(true)
  self.animator:Play("switchOut", 0, 0)
end

function WorldSandWormDes:Update1000MS()
  if self.expireTime then
    local now = UITimeManager:GetInstance():GetServerTime()
    if now < self.expireTime then
      local str = UITimeManager:GetInstance():SecondToFmtString((self.expireTime - now) / 1000)
      self.time_text:SetText(str)
    else
      self.time_text:SetText("")
      self.expireTime = nil
    end
  end
  if self.stateEndTime then
    local now = UITimeManager:GetInstance():GetServerTime()
    if now < self.stateEndTime then
      local timeStr = UITimeManager:GetInstance():SecondToFmtString((self.stateEndTime - now) / 1000)
      self.stun_text:SetText(self.data.stateTriggerInfo .. "\n" .. timeStr)
    else
      self.stun_text:SetText(self.data.stateTriggerInfo)
      self.stateEndTime = nil
      self.time_node:SetActive(true)
      self.stun_text:SetActive(false)
    end
  end
end

return WorldSandWormDes
