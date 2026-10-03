local base = UIBaseContainer
local BirthdayRewardContent = BaseClass("BirthdayRewardContent", base)
local Localization = CS.GameEntry.Localization
local reward_get_btn_path = ""
local reward_get_txt_path = "rewardGetTxt"
local red_point_path = "redPoint"
local have_get_path = "HaveGet"

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
  self.reward_get_btn = self:AddComponent(UIButton, reward_get_btn_path)
  self.reward_get_txt = self:AddComponent(UITextMeshProUGUIEx, reward_get_txt_path)
  self.red_point = self:AddComponent(UIImage, red_point_path)
  self.have_get = self:AddComponent(UIImage, have_get_path)
  self.reward_get_btn:SetOnClick(function()
    self:OnClickRewardGetBtn()
  end)
end

local function ComponentDestroy(self)
  self.reward_get_btn = nil
  self.reward_get_txt = nil
  self.red_point = nil
  self.have_get = nil
end

local function DataDefine(self)
  self.data = nil
end

local function DataDestroy(self)
  self.data = nil
end

function BirthdayRewardContent:SetData(data)
  self.data = data
  self:RefreshView()
end

function BirthdayRewardContent:RefreshView()
  if self.data == nil then
    return
  end
  local birthdayHaveSet = DataCenter.BirthdayDataManager:IsSelfHaveSetBirthday()
  local haveGet = DataCenter.BirthdayDataManager:IsHaveGetBirthdayFirstSetReward()
  if birthdayHaveSet then
    if haveGet then
      self.red_point:SetActive(false)
      self.have_get:SetActive(true)
    else
      self.red_point:SetActive(true)
      self.have_get:SetActive(false)
    end
  else
    self.red_point:SetActive(false)
    self.have_get:SetActive(false)
  end
  local showNum = 0
  local goodsDataStr = LuaEntry.DataConfig:TryGetStr("player_birthday", "k10", "")
  local goodsData = string.string2array_i_oneSep(goodsDataStr, "|")
  if goodsData and #goodsData == 2 then
    local goodId = goodsData[1]
    local goodNum = goodsData[2]
    local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(goodId)
    if itemTemplate and itemTemplate.type == GOODS_TYPE.GOODS_TYPE_3 and tonumber(itemTemplate.para1) == 100 then
      showNum = tonumber(itemTemplate.para2) * goodNum
    end
  end
  self.reward_get_txt:SetText("\195\151" .. showNum)
end

function BirthdayRewardContent:OnClickRewardGetBtn()
  local birthdayHaveSet = DataCenter.BirthdayDataManager:IsSelfHaveSetBirthday()
  local haveGet = DataCenter.BirthdayDataManager:IsHaveGetBirthdayFirstSetReward()
  if birthdayHaveSet then
    if haveGet then
    else
      SFSNetwork.SendMessage(MsgDefines.UserBirthdaySetReward)
    end
  else
    UIUtil.ShowBubbleTips(Localization:GetString("birthday_tips_52"), self.reward_get_btn.transform.position, 0, 30, 0, nil, nil, {reversal = true})
  end
end

BirthdayRewardContent.OnCreate = OnCreate
BirthdayRewardContent.OnDestroy = OnDestroy
BirthdayRewardContent.OnEnable = OnEnable
BirthdayRewardContent.OnDisable = OnDisable
BirthdayRewardContent.ComponentDefine = ComponentDefine
BirthdayRewardContent.ComponentDestroy = ComponentDestroy
BirthdayRewardContent.DataDefine = DataDefine
BirthdayRewardContent.DataDestroy = DataDestroy
return BirthdayRewardContent
