local UIDailyCell = BaseClass("UIDailyCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Rect_path = "Rect"
local icon_path = "Rect/Bg/Icon"
local name_text_path = "Rect/NameText"
local des_text_path = "Rect/DesText"
local reward_text_path = "Rect/RewardBg/RewardText"
local go_btn_path = "Rect/GoBtn"
local go_btn_name_path = "Rect/GoBtn/GoBtnName"
local goreward_btn_path = "Rect/GoReward"
local goreward_btn_name_path = "Rect/GoReward/GoRewardName"
local received_txt_path = "Rect/Txt_Received"
local reward1_rect_path = "Rect/RewardBg/RewardList/reward1"
local reward1_icon_path = "Rect/RewardBg/RewardList/reward1/icon1"
local reward1_txt_path = "Rect/RewardBg/RewardList/reward1/RewardNum1"
local reward2_rect_path = "Rect/RewardBg/RewardList/reward2"
local reward2_icon_path = "Rect/RewardBg/RewardList/reward2/icon2"
local reward2_txt_path = "Rect/RewardBg/RewardList/reward2/RewardNum2"
local reward3_rect_path = "Rect/RewardBg/RewardList/reward3"
local reward3_icon_path = "Rect/RewardBg/RewardList/reward3/icon3"
local reward3_txt_path = "Rect/RewardBg/RewardList/reward3/RewardNum3"
local reward4_rect_path = "Rect/RewardBg/RewardList/reward4"
local reward4_txt_path = "Rect/RewardBg/RewardList/reward4/RewardNum4"
local Param = DataClass("Param", ParamData)
local ParamData = {
  id,
  time,
  allTime,
  totalNum,
  state,
  reward
}
local rewardMaxNum = 4

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
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.des_text = self:AddComponent(UIText, des_text_path)
  self.reward_text = self:AddComponent(UIText, reward_text_path)
  self.go_btn = self:AddComponent(UIButton, go_btn_path)
  self.go_btn_name = self:AddComponent(UIText, go_btn_name_path)
  self.goreward_btn = self:AddComponent(UIButton, goreward_btn_path)
  self.goreward_btn_name = self:AddComponent(UIText, goreward_btn_name_path)
  self._received_txt = self:AddComponent(UIText, received_txt_path)
  self._reward1_rect = self:AddComponent(UIBaseContainer, reward1_rect_path)
  self._reward1_icon = self:AddComponent(UIImage, reward1_icon_path)
  self._reward1_txt = self:AddComponent(UIText, reward1_txt_path)
  self._reward2_rect = self:AddComponent(UIBaseContainer, reward2_rect_path)
  self._reward2_icon = self:AddComponent(UIImage, reward2_icon_path)
  self._reward2_txt = self:AddComponent(UIText, reward2_txt_path)
  self._reward3_rect = self:AddComponent(UIBaseContainer, reward3_rect_path)
  self._reward3_icon = self:AddComponent(UIImage, reward3_icon_path)
  self._reward3_txt = self:AddComponent(UIText, reward3_txt_path)
  self._reward4_rect = self:AddComponent(UIBaseContainer, reward4_rect_path)
  self._reward4_txt = self:AddComponent(UIText, reward4_txt_path)
  self.rewardRect = {
    [1] = self._reward1_rect,
    [2] = self._reward2_rect,
    [3] = self._reward3_rect,
    [4] = self._reward4_rect
  }
  self.rewardTxt = {
    [1] = self._reward1_txt,
    [2] = self._reward2_txt,
    [3] = self._reward3_txt,
    [4] = self._reward4_txt
  }
  self.rewardImg = {
    [1] = self._reward1_icon,
    [2] = self._reward2_icon,
    [3] = self._reward3_icon
  }
  self.go_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnGoBtnClick()
  end)
  self.TweenObj = self:AddComponent(UIBaseContainer, Rect_path)
  self.goreward_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_GetReward, false)
    self:SendTaskReward()
  end)
  self:ResetDoTween()
end

local function ComponentDestroy(self)
  self.TweenObj = nil
  self.icon = nil
  self.name_text = nil
  self.des_text = nil
  self.reward_text = nil
  self.go_btn = nil
  self.go_btn_name = nil
  self.goreward_btn = nil
  self.goreward_btn_name = nil
  self._reward1_rect = nil
  self._reward1_txt = nil
  self._reward1_rect = nil
  self._reward2_txt = nil
  self._reward3_rect = nil
  self._reward3_txt = nil
  self._reward4_rect = nil
  self._reward4_txt = nil
end

local function DataDefine(self)
  self.param = {}
  self.template = nil
end

local function DataDestroy(self)
  self.param = nil
  self.template = nil
  self.rewardRect = nil
  self.rewardTxt = nil
  self.rewardImg = nil
end

local function ReInit(self, param)
  self.param = param
  self.template = DataCenter.DailyTaskTemplateManager:GetQuestTemplate(param.id)
  self.isClick = false
  if self.template ~= nil then
    self.icon:LoadSprite(string.format(LoadPath.UITask, self.template.icon))
    self.name_text:SetLocalText(self.template.name)
    if self.template.para2 == 1 then
      self.des_text:SetLocalText(self.template.desc, self.template.para2)
    else
      self.des_text:SetText(string.format("(%d/%d)", self.param.num, self.template.para2) .. Localization:GetString(self.template.desc, self.template.para2))
    end
    self.go_btn_name:SetLocalText(110003)
    self.goreward_btn_name:SetLocalText(170004)
    local perPoint = tonumber(self.template.point)
    self.reward_text:SetLocalText(130065)
    if self.param.state == 0 then
      self.go_btn:SetActive(true)
      self.goreward_btn:SetActive(false)
      self._received_txt:SetActive(false)
    elseif self.param.state == 1 then
      self.go_btn:SetActive(false)
      self.goreward_btn:SetActive(true)
      self._received_txt:SetActive(false)
    elseif self.param.state == 2 then
      self.go_btn:SetActive(false)
      self.goreward_btn:SetActive(false)
      self._received_txt:SetActive(true)
      self._received_txt:SetLocalText(170008)
    end
    for i = 1, 4 do
      self.rewardRect[i]:SetActive(false)
    end
    if self.param.reward ~= nil and next(self.param.reward) then
      table.walk(self.param.reward, function(k, v)
        if v.rewardType == RewardType.GOLD then
          self.rewardImg[k]:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold))
        elseif v.rewardType == RewardType.OIL or v.rewardType == RewardType.METAL or v.rewardType == RewardType.WATER or v.rewardType == RewardType.FOOD or v.rewardType == RewardType.ELECTRICITY then
          self.rewardImg[k]:LoadSprite(DataCenter.RewardManager:GetPicByType(v.rewardType))
        elseif v.rewardType == RewardType.RESOURCE_ITEM then
          local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(param.itemId)
          if template ~= nil then
            self.rewardImg[k]:LoadSprite(string.format(LoadPath.ItemPath, template.pic))
          end
        end
        self.rewardTxt[k]:SetText("x" .. v.count)
        self.rewardRect[k]:SetActive(true)
      end)
    end
    self.rewardRect[rewardMaxNum]:SetActive(true)
    self.rewardTxt[rewardMaxNum]:SetText("x" .. perPoint)
  end
end

local function PlayShowAnimation(self, state)
  if state == 1 then
    DOTween.Restart(self.TweenObj.gameObject, "Dissolve")
  else
    DOTween.Play(self.TweenObj.gameObject, "Move")
  end
end

local function OnGoBtnClick(self)
  GoToUtil.GoToByQuestId(self.template)
end

local function ResetDoTween(self)
  DOTween.Rewind(self.TweenObj.gameObject)
end

local function ResetDoTweens(self)
  DOTween.Restart(self.TweenObj.gameObject, "show_idle")
end

local function SendTaskReward(self)
  if self.view:IsTween() then
    return
  end
  self.param.callBack(self.param.index)
  self:GetForward()
  self:PlayShowAnimation(1)
  SFSNetwork.SendMessage(MsgDefines.DailyTaskReward, self.param.id)
end

local function GetForward(self)
  local tempType = {}
  if self.param == nil or self.param.reward == nil then
    return
  end
  for i = 1, 3 do
    if self.param.reward[i] and self.param.reward[i].rewardType ~= RewardType.FOOD then
      table.insert(tempType, RewardToResType[self.param.reward[i].rewardType])
    end
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshTopResByPickUp, tempType)
  for i = 1, 4 do
    local result = self.rewardRect[i].gameObject.activeSelf
    local flyPos = Vector3.New(0, 0, 0)
    local rewardTyp
    local pic = ""
    if result == true then
      if i ~= 4 then
        if self.param.reward[i] then
          rewardTyp = self.param.reward[i].rewardType
          pic = DataCenter.RewardManager:GetPicByType(rewardTyp)
        end
      else
        flyPos = self.param.flyPos.position
        rewardTyp = RewardType.ALLIANCE_POINT
        pic = "Assets/Main/Sprites/UI/UIAlliance/UIAlliance_icon_activity.png"
      end
      UIUtil.DoFly(tonumber(rewardTyp), 4, pic, self.rewardRect[i].transform.position, flyPos, 40, 40)
    end
  end
end

local function GetIndex(self)
  if self.param ~= nil and self.param.index ~= nil then
    return self.param.index
  end
  return 0
end

UIDailyCell.OnCreate = OnCreate
UIDailyCell.OnDestroy = OnDestroy
UIDailyCell.Param = Param
UIDailyCell.OnEnable = OnEnable
UIDailyCell.OnDisable = OnDisable
UIDailyCell.ComponentDefine = ComponentDefine
UIDailyCell.ComponentDestroy = ComponentDestroy
UIDailyCell.DataDefine = DataDefine
UIDailyCell.DataDestroy = DataDestroy
UIDailyCell.ReInit = ReInit
UIDailyCell.OnGoBtnClick = OnGoBtnClick
UIDailyCell.SendTaskReward = SendTaskReward
UIDailyCell.PlayShowAnimation = PlayShowAnimation
UIDailyCell.GetIndex = GetIndex
UIDailyCell.ResetDoTween = ResetDoTween
UIDailyCell.ResetDoTweens = ResetDoTweens
UIDailyCell.GetForward = GetForward
return UIDailyCell
