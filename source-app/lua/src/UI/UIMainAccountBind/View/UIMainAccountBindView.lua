local UIMainAccountBindView = BaseClass("UIMainAccountBindView", UIBaseView)
local base = UIBaseView
local Setting = CS.GameEntry.Setting
local Localization = CS.GameEntry.Localization
local title_text_path = "titleText"
local DesName_path = "DesName"
local close_btn_path = "Image/CloseBtn"
local go_bind_btn_path = "Btn_GoBind"
local go_bind_txt_path = "Btn_GoBind/Txt_GoBind"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function ComponentDefine(self)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.desName = self:AddComponent(UIText, DesName_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self._goBind_btn = self:AddComponent(UIButton, go_bind_btn_path)
  self._goBind_btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self._goBind_txt = self:AddComponent(UIText, go_bind_txt_path)
  self.rewardList = {}
  for i = 1, 2 do
    self.rewardList[i] = {}
    local rect = self:AddComponent(UIBaseContainer, "Rect_Reward/Rect_Reward" .. i)
    local icon = self:AddComponent(UIImage, "Rect_Reward/Rect_Reward" .. i .. "/Img_Reward" .. i)
    local txt = self:AddComponent(UIText, "Rect_Reward/Rect_Reward" .. i .. "/Txt_Reward" .. i)
    self.rewardList[i].rect = rect
    self.rewardList[i].icon = icon
    self.rewardList[i].txt = txt
  end
end

local function OnDestroy(self)
  self.close_btn = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.type = self:GetUserData()
  self:RefreshView()
  self:RefreshReward()
  CS.GameEntry.Setting:SetBool(SettingKeys.FIRST_ACCOUNTBIND_SHOW .. LuaEntry.Player.uid, true)
  EventManager:GetInstance():Broadcast(EventId.ClickMainAccountBind)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function RefreshView(self)
  if self.type == AccountViewType.Bind then
    self.title_text:SetLocalText(208216)
    self.desName:SetLocalText(208217)
    self._goBind_txt:SetLocalText(110003)
  elseif self.type == AccountViewType.Question then
    self.title_text:SetLocalText(121370)
    self.desName:SetLocalText(121371)
    self._goBind_txt:SetLocalText(110003)
  end
end

local function RefreshReward(self)
  local reward = {}
  if self.type == AccountViewType.Bind then
    reward = DataCenter.AccountManager:GetBindAccountReward()
  else
    reward = DataCenter.QNManager:GetRewardData()
  end
  if next(reward) then
    for i = 1, 2 do
      if reward[i] then
        self.rewardList[i].rect:SetActive(true)
        if reward[i].type == RewardType.GOLD then
          self.rewardList[i].icon:LoadSprite(DataCenter.RewardManager:GetPicByType(reward[i].type))
          self.rewardList[i].txt:SetText(reward[i].value)
        else
          self.rewardList[i].icon:LoadSprite(DataCenter.RewardManager:GetPicByType(reward[i].type, reward[i].value.id))
          self.rewardList[i].txt:SetText(reward[i].value.num)
        end
      else
        self.rewardList[i].rect:SetActive(false)
      end
    end
  end
end

local function OnBtnClick(self)
  if self.type == AccountViewType.Bind then
    GoToUtil.GotoOpenView(UIWindowNames.UILWPlayerDetail, LuaEntry.Player.uid, 2)
  elseif self.type == AccountViewType.Question then
    local list = DataCenter.QNManager:GetQuestionList()
    if list then
      for i = 1, #list.questions do
        local questionTemp = DataCenter.NpcQATemplateManager:GetQuestionnaireTemplate(list.questions[i])
        if not questionTemp then
          UIUtil.ShowTipsId(121372)
          return
        end
      end
    end
    GoToUtil.GotoOpenView(UIWindowNames.UINpcQN)
  end
end

UIMainAccountBindView.OnCreate = OnCreate
UIMainAccountBindView.OnDestroy = OnDestroy
UIMainAccountBindView.OnEnable = OnEnable
UIMainAccountBindView.OnDisable = OnDisable
UIMainAccountBindView.ComponentDefine = ComponentDefine
UIMainAccountBindView.RefreshView = RefreshView
UIMainAccountBindView.RefreshReward = RefreshReward
UIMainAccountBindView.OnBtnClick = OnBtnClick
return UIMainAccountBindView
