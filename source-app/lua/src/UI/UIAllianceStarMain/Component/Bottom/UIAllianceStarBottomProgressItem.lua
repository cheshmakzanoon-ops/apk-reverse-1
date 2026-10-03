local UIAllianceStarBottomProgressItem = BaseClass("UIAllianceStarBottomProgressItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

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
  self.imgBg1 = self:AddComponent(UIImage, "Bg1")
  self.imgBg2 = self:AddComponent(UIImage, "Bg2")
  self.imgBg3 = self:AddComponent(UIImage, "Bg3")
  self.imgBg4 = self:AddComponent(UIImage, "Bg4")
  self.textNum = self:AddComponent(UITextMeshProUGUIEx, "NumText")
  self.imgEmoji = self:AddComponent(UIImage, "EmojiImg")
  self.btn = self:AddComponent(UIButton, "Btn")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.imgBox = self:AddComponent(UIImage, "BoxImg")
  self.imgCur = self:AddComponent(UIImage, "CurImg")
  self.bubble = self:AddComponent(UIBaseComponent, "Bubble")
  self.bubble:SetActive(false)
end

local function ComponentDestroy(self)
  self.imgBg1 = nil
  self.imgBg2 = nil
  self.imgBg3 = nil
  self.imgBg4 = nil
  self.textNum = nil
  self.imgEmoji = nil
  self.btn = nil
  self.imgBox = nil
  self.imgCur = nil
  self.bubble = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.index = nil
  self.isSelect = nil
  self.configId = nil
  self.ownInNominate = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnBtnClick(self)
  if not self.isSelect then
    DataCenter.AllianceStarManager:ChangeProgressCtrlStageById(self.index)
  end
end

local function RefreshByThumb(self, index, selectIndex, fullIndex, configId, selfThumbs, ownInNominate)
  self.ownInNominate = ownInNominate
  self:Refresh(index, selectIndex, fullIndex, configId)
  self:RefreshThumb(selfThumbs)
end

local function RefreshByReward(self, index, selectIndex, fullIndex, configId, rewarded, ownInNominate)
  self.ownInNominate = ownInNominate
  self:Refresh(index, selectIndex, fullIndex, configId)
  self:RefreshReward(rewarded)
end

local function Refresh(self, index, selectIndex, fullIndex, configId)
  self.index = index
  self.isSelect = index == selectIndex
  self.imgCur:SetActive(self.isSelect)
  self.imgBg1:SetActive(false)
  self.imgBg2:SetActive(false)
  self.imgBg3:SetActive(false)
  self.imgBg4:SetActive(false)
  if index == 1 then
    self.imgBg1:SetActive(true)
  elseif index == fullIndex then
    self.imgBg4:SetActive(true)
  elseif index == selectIndex then
    self.imgBg2:SetActive(true)
  else
    self.imgBg3:SetActive(true)
  end
  self.textNum:SetText(index)
  self.configId = configId
end

local function RefreshThumb(self, selfThumbs)
  self.imgBox:SetActive(false)
  if selfThumbs then
    self.imgEmoji:SetActive(true)
    self.bubble:SetActive(false)
    for i, v in ipairs(selfThumbs) do
      local emojiSetting = DataCenter.AllianceStarManager:GetEmojiSetting()
      local emojiId = emojiSetting.emojiList[v]
      local line = LocalController:instance():getLine(TableName.LW_EMOJI, emojiId)
      self.imgEmoji:LoadSprite("Assets/Main/Sprites/UI/LWChatEmoji/Default/" .. line.path .. ".png")
      self.imgEmoji:SetNativeSize()
      break
    end
  else
    if DataCenter.AllianceStarManager:GetIsMvpByConfigId(self.configId) then
      self.imgEmoji:SetActive(true)
      self.imgEmoji:LoadSprite("Assets/Main/Sprites/UI/UIAllianceStar2/FX_tongmengzhixing_MVP.png")
      self.imgEmoji:SetNativeSize()
    else
      self.imgEmoji:SetActive(false)
    end
    self.bubble:SetActive(self.ownInNominate)
  end
end

local function RefreshReward(self, participateReceive)
  self.imgBox:SetActive(true)
  self.imgEmoji:SetActive(false)
  if participateReceive then
    self.imgBox:LoadSprite("Assets/Main/Sprites/UI/UIAllianceStar/zxl_tmzx_xiangzi_kai1.png")
  else
    self.imgBox:LoadSprite("Assets/Main/Sprites/UI/UIAllianceStar/zxl_tmzx_xiangzi_guan1.png")
  end
end

UIAllianceStarBottomProgressItem.OnCreate = OnCreate
UIAllianceStarBottomProgressItem.OnDestroy = OnDestroy
UIAllianceStarBottomProgressItem.OnEnable = OnEnable
UIAllianceStarBottomProgressItem.OnDisable = OnDisable
UIAllianceStarBottomProgressItem.ComponentDefine = ComponentDefine
UIAllianceStarBottomProgressItem.ComponentDestroy = ComponentDestroy
UIAllianceStarBottomProgressItem.DataDefine = DataDefine
UIAllianceStarBottomProgressItem.DataDestroy = DataDestroy
UIAllianceStarBottomProgressItem.OnAddListener = OnAddListener
UIAllianceStarBottomProgressItem.OnRemoveListener = OnRemoveListener
UIAllianceStarBottomProgressItem.OnBtnClick = OnBtnClick
UIAllianceStarBottomProgressItem.RefreshByThumb = RefreshByThumb
UIAllianceStarBottomProgressItem.RefreshThumb = RefreshThumb
UIAllianceStarBottomProgressItem.RefreshByReward = RefreshByReward
UIAllianceStarBottomProgressItem.Refresh = Refresh
UIAllianceStarBottomProgressItem.RefreshReward = RefreshReward
return UIAllianceStarBottomProgressItem
