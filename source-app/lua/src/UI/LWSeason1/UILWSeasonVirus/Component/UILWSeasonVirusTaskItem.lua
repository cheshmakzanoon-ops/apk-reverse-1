local UILWSeasonVirusTaskItem = BaseClass("UILWSeasonVirusTaskItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIRewardTipView = require("UI.UIRewardTip.View.UIRewardTipView")
local new_version_path = "NewVersion"
local bg_new_path = "NewVersion/bgNew"
local icon_new_path = "NewVersion/iconNew"
local title_new_path = "NewVersion/titleNew"
local slider_new_path = "NewVersion/SliderNew"
local slider_value_path = "NewVersion/SliderNew/SliderValue"
local box_new_path = "NewVersion/boxNew"

function UILWSeasonVirusTaskItem:OnCreate()
  base.OnCreate(self)
  self.boxLight = self:AddComponent(UIBaseContainer, "active")
  self.boxClick = self:AddComponent(UIBaseContainer, "flowOpen")
  self.icon = self:AddComponent(UIButton, "icon")
  self.title = self:AddComponent(UIText, "title")
  self.desc = self:AddComponent(UIText, "desc")
  self.box_open = self:AddComponent(UIImage, "boxOpen")
  self.box = self:AddComponent(UIButton, "box")
  self.box:SetOnClick(function()
    self:OnClickBtn()
  end)
  self.icon:SetOnClick(function()
    if self.taskInfo then
      self:OnRewardShowClick()
    end
  end)
  self.boxLight:SetActive(false)
  self.boxClick:SetActive(false)
  self.new_version = self:AddComponent(UIImage, new_version_path)
  self.bg_new = self:AddComponent(UIImage, bg_new_path)
  self.icon_new = self:AddComponent(UIButton, icon_new_path)
  self.title_new = self:AddComponent(UITextMeshProUGUIEx, title_new_path)
  self.slider_new = self:AddComponent(UISlider, slider_new_path)
  self.slider_value = self:AddComponent(UITextMeshProUGUIEx, slider_value_path)
  self.box_new_anim = self:AddComponent(UIAnimator, box_new_path)
  self.box_new = self:AddComponent(UIButton, box_new_path)
  self.box_new:SetOnClick(function()
    self:OnClickBtn()
  end)
  self.icon_new:SetOnClick(function()
    if self.taskInfo then
      self:OnRewardShowClick()
    end
  end)
  self.box_new_anim:Enable(false)
end

function UILWSeasonVirusTaskItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MainTaskUpdate, self.OnMainTaskUpdate)
end

function UILWSeasonVirusTaskItem:OnRemoveListener()
  self:RemoveUIListener(EventId.MainTaskUpdate, self.OnMainTaskUpdate)
  base.OnRemoveListener(self)
end

local _clickPosCache = {}

function UILWSeasonVirusTaskItem:OnClickBtn()
  if self.taskInfo then
    if self.taskInfo.state == TaskState.NoComplete then
      self:OnRewardShowClick()
    elseif self.taskInfo.state == TaskState.CanReceive and self.taskId then
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.Music_Effect_Task_Done_Btn)
      if self.use_new_version then
      else
        self.boxClick:SetActive(true)
      end
      SFSNetwork.SendMessage(MsgDefines.TaskRewardGet, {
        id = self.taskId
      })
      SFSNetwork.SendMessage(MsgDefines.GetTempUserAchievementInfo)
      local rewardPos = self.box.transform.position
      _clickPosCache[self.taskId] = {
        taskInfo = self.taskInfo,
        lastState = self.taskInfo.state,
        rewardPos = rewardPos
      }
    elseif self.taskInfo.state == TaskState.Received then
    end
  end
end

function UILWSeasonVirusTaskItem:OnReceiveQuestReward()
  if self.taskInfo and self.taskInfo.state == TaskState.Received and self.lastState ~= self.taskInfo.state then
    local rewardPos = self.box.transform.position
    for i, v in ipairs(self.taskInfo.rewardList) do
      local rewardType = v.rewardType
      local itemId = v.itemId
      local pic = DataCenter.RewardManager:GetPicByType(rewardType, itemId)
      if not string.IsNullOrEmpty(pic) then
        local endPos = Vector3.New(0, 0, 0)
        local resourceType = RewardToResType[rewardType]
        if resourceType then
          endPos = UIUtil.GetResourcePos(resourceType)
        end
        UIUtil.DoFly(tonumber(rewardType), 3, pic, rewardPos, endPos, nil, nil, nil, nil, 1)
      end
    end
    self.lastState = self.taskInfo.state
    if self.use_new_version then
      self.box_new:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason1/virus/mjc_saijibingdu_pop_chengjiu_baoxiang02.png")
    else
      self.box:SetActive(false)
      self.box_open:SetActive(true)
      self.boxLight:SetActive(false)
      self.boxClick:SetActive(false)
    end
    for k, v in pairs(_clickPosCache) do
      if toInt(k) == toInt(self.taskId) then
        v.lastState = TaskState.Received
      end
    end
    return true
  end
  return _clickPosCache
end

function UILWSeasonVirusTaskItem:OnUpdateTaskNew()
  local taskInfo = DataCenter.TaskManager:FindTaskInfo(self.taskId)
  if taskInfo ~= nil then
    self.box_new:SetEulerAnglesXYZ(0, 0, 0)
    if taskInfo.state == TaskState.NoComplete then
      self.box_new:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason1/virus/mjc_saijibingdu_pop_chengjiu_baoxiang02.png")
    elseif taskInfo.state == TaskState.CanReceive then
      self.box_new:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason1/virus/mjc_saijibingdu_pop_chengjiu_baoxiang01.png")
    elseif taskInfo.state == TaskState.Received then
      self.box_new:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason1/virus/mjc_saijibingdu_pop_chengjiu_baoxiang02.png")
    end
    self.box_new_anim:Enable(taskInfo.state == TaskState.CanReceive)
    self.lastState = taskInfo.state
    self.taskInfo = taskInfo
  end
  self.box:SetActive(false)
  self.box_open:SetActive(false)
  self.boxLight:SetActive(false)
  self.boxClick:SetActive(false)
end

function UILWSeasonVirusTaskItem:OnUpdateTask()
  local taskInfo = DataCenter.TaskManager:FindTaskInfo(self.taskId)
  if taskInfo ~= nil then
    if taskInfo.state == TaskState.NoComplete then
      self.box:SetActive(true)
      self.box_open:SetActive(false)
      self.boxLight:SetActive(false)
      self.boxClick:SetActive(false)
      CS.UIGray.SetGray(self.box.transform, true, true)
    elseif taskInfo.state == TaskState.CanReceive then
      self.box:SetActive(true)
      self.box_open:SetActive(false)
      self.boxLight:SetActive(true)
      self.boxClick:SetActive(false)
      CS.UIGray.SetGray(self.box.transform, false, true)
    elseif taskInfo.state == TaskState.Received then
      self.box:SetActive(false)
      self.box_open:SetActive(true)
    end
    self.lastState = taskInfo.state
    self.taskInfo = taskInfo
  end
end

function UILWSeasonVirusTaskItem:OnDestroy()
  self.icon = nil
  self.title = nil
  self.desc = nil
  self.box_open = nil
  self.box = nil
  self.new_version = nil
  self.bg_new = nil
  self.icon_new = nil
  self.title_new = nil
  self.slider_new = nil
  self.slider_value = nil
  self.box_new = nil
  base.OnDestroy(self)
end

function UILWSeasonVirusTaskItem:OnMainTaskUpdate()
  if self.data ~= nil then
    self:UpdateUI(self.data)
  end
end

function UILWSeasonVirusTaskItem:ReInit(data, seasonVersion)
  self.use_new_version = toInt(seasonVersion) > 0
  self.data = data
  self:UpdateUI(data)
end

function UILWSeasonVirusTaskItem:UpdateUI(data)
  if data ~= nil then
    local taskInfo = data.data
    local metaQuest = data.meta
    local count = toInt(metaQuest.para2 or 999)
    local desc = Localization:GetString(metaQuest.desc, count)
    self.taskId = taskInfo.id
    self.box_new_anim:Enable(false)
    if self.use_new_version then
      self.new_version:SetActive(true)
      if data.list == 1020 then
        self.title_new:SetLocalText("season_quest_desc_601020", count)
        self.icon_new:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason1_Remote/virus/mjc_saijibingdu_pop_chengjiu_icon_1.png")
        self.bg_new:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason1_Remote/virus/mjc_saijibingdu_pop_chengjiu_bg01.png")
      elseif data.list == 1021 then
        self.title_new:SetLocalText("season_quest_desc_601021", count)
        self.icon_new:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason1_Remote/virus/mjc_saijibingdu_pop_chengjiu_icon_2.png")
        self.bg_new:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason1_Remote/virus/mjc_saijibingdu_pop_chengjiu_bg02.png")
      elseif data.list == 1022 then
        self.title_new:SetLocalText("season_quest_desc_601022", count)
        self.icon_new:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason1_Remote/virus/mjc_saijibingdu_pop_chengjiu_icon_3.png")
        self.bg_new:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason1_Remote/virus/mjc_saijibingdu_pop_chengjiu_bg03.png")
      end
      self.slider_new:SetValue(math.min(taskInfo.num, count) * 100 / count)
      self.slider_value:SetText(string.format("%s/%s", math.min(taskInfo.num, count), count))
      self:OnUpdateTaskNew()
    else
      self.new_version:SetActive(false)
      self.title:SetLocalText(metaQuest.name)
      self.desc:SetText(desc .. string.format("(%s/%s)", math.min(taskInfo.num, count), count))
      self.icon:LoadSprite("Assets/Main/Sprites/ItemIcons/icon_junbeijiangzhang.png")
      self:OnUpdateTask()
    end
  else
    self:SetActive(false)
  end
end

function UILWSeasonVirusTaskItem:OnRewardShowClick()
  if self.RewardHasShown then
    self.RewardHasShown = false
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIRewardTip)
    return
  end
  local param = UIRewardTipView.ParamDataClass.New()
  if self.use_new_version then
    param.position = self.box_new:GetPosition()
  else
    param.position = self.box:GetPosition()
  end
  local _screenPos = PosConverse.UIWorldToScreenPos(param.position)
  local ScreenSize = CS.UnityEngine.Screen
  if _screenPos.x * 2 < ScreenSize.width then
    param.deltaX = 30
    param.dir = UIRewardTipView.Direction.LEFT
  else
    param.deltaX = -30
    param.dir = UIRewardTipView.Direction.RIGHT
  end
  param.rewardList = self.taskInfo.rewardList
  param.totalVal = 0
  if param.rewardList then
    self.RewardHasShown = true
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIRewardTip, {anim = false}, param)
  end
end

return UILWSeasonVirusTaskItem
