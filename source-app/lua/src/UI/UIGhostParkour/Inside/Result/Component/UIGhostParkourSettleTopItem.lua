local base = UIBaseContainer
local UIGhostParkourSettleTopItem = BaseClass("UIGhostParkourSettleTopItem", base)
local bg1_path = "Bg1"
local bg2_path = "Bg2"
local banner_path = "FirstRoot/Banner"
local result_text_path = "FirstRoot/ResultText"
local time_text_path = "FirstRoot/TimeRoot/TimeText"
local tag_bg_path = "FirstRoot/TagBg"
local tag_text_path = "FirstRoot/TagBg/TagText"
local rank_pic_path = "FirstRoot/RankPic"
local RANK_PIC_PATH = {
  "Assets/Main/Sprites/UI/UIGhostParkour/UIGhostParkourBattle/lrb_YZPK_jiesuan01a.png",
  "Assets/Main/Sprites/UI/UIGhostParkour/UIGhostParkourBattle/lrb_YZPK_jiesuan02a.png",
  "Assets/Main/Sprites/UI/UIGhostParkour/UIGhostParkourBattle/lrb_YZPK_jiesuan03a.png"
}
local COLOR_PNG_PATH = {
  "Assets/Main/TextureEx/UIGhostParkour/lrb_YZPK_jiesuan01b.png",
  "Assets/Main/TextureEx/UIGhostParkour/lrb_YZPK_jiesuan02b.png",
  "Assets/Main/TextureEx/UIGhostParkour/lrb_YZPK_jiesuan03b.png"
}
local RANK_ANIM_NAME = {
  "V_ui_UIGhostParkourBattleResult_banner_in1",
  "V_ui_UIGhostParkourBattleResult_banner_in2",
  "V_ui_UIGhostParkourBattleResult_banner_in3"
}

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

local function ComponentDefine(self)
  self.rootAnim = self:AddComponent(UIAnimator, "")
  self.bg1 = self:AddComponent(UIRawImage, bg1_path)
  self.bg2 = self:AddComponent(UIRawImage, bg2_path)
  self.banner = self:AddComponent(UIImage, banner_path)
  self.score_text = self:AddComponent(UITextMeshProUGUIEx, result_text_path)
  self.time_text = self:AddComponent(UITextMeshProUGUIEx, time_text_path)
  self.tag_bg = self:AddComponent(UIImage, tag_bg_path)
  self.tag_text = self:AddComponent(UITextMeshProUGUIEx, tag_text_path)
  self.rank_pic = self:AddComponent(UIImage, rank_pic_path)
end

local function ComponentDestroy(self)
  self.rootAnim = nil
  self.bg1 = nil
  self.bg2 = nil
  self.banner = nil
  self.score_text = nil
  self.time_text = nil
  self.tag_bg = nil
  self.tag_text = nil
  self.rank_pic = nil
end

function UIGhostParkourSettleTopItem:DataDefine()
  self.rank = nil
end

function UIGhostParkourSettleTopItem:DataDestroy()
  self.rank = nil
end

function UIGhostParkourSettleTopItem:InitView(message, rank)
  if message then
    rank = rank or 1
    self.rank = rank
    local addTierExp = message.addTierExp or 0
    self.banner:SetActive(rank == 1)
    self.rank_pic:LoadSpriteAuto(RANK_PIC_PATH[rank])
    local colorPic = COLOR_PNG_PATH[rank]
    self.bg1:LoadSpriteAuto(colorPic)
    self.bg2:LoadSpriteAuto(colorPic)
    self.time_text:SetText(DataCenter.LWGhostParkourDataManager:GetTimeFormat(message.totalRunTime * 1000))
    if addTierExp == 0 then
      self.score_text:SetLocalText("")
    else
      self.score_text:SetLocalText("ghost_parkour_add_points", addTierExp)
    end
    local isNewRecord = message.isNewRecord
    if isNewRecord then
      self.tag_bg:SetActive(true)
      self.tag_text:SetLocalText("ghost_parkour_new_record")
    else
      self.tag_bg:SetActive(false)
    end
  end
end

function UIGhostParkourSettleTopItem:PlayPanelAnim()
  if self.rank then
    local name = RANK_ANIM_NAME[self.rank]
    return self.rootAnim:PlayAnimationReturnTime(name)
  end
  return true, 0
end

UIGhostParkourSettleTopItem.OnCreate = OnCreate
UIGhostParkourSettleTopItem.OnDestroy = OnDestroy
UIGhostParkourSettleTopItem.ComponentDefine = ComponentDefine
UIGhostParkourSettleTopItem.ComponentDestroy = ComponentDestroy
return UIGhostParkourSettleTopItem
