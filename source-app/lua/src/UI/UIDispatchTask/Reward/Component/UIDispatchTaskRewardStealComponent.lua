local UIDispatchTaskRewardStealComponent = BaseClass("UIDispatchTaskRewardStealComponent", UIBaseContainer)
local base = UIBaseContainer
local player_path = "player"
local user_name_path = "userName"
local tip_box_happy_path = "TipRoot/TipBoxHappy"
local tip_box_angry_path = "TipRoot/TipBoxAngry"

function UIDispatchTaskRewardStealComponent:OnCreate()
  base.OnCreate(self)
  self.player = self:AddComponent(UICommonHead, player_path)
  self.playerName = self:AddComponent(UITextMeshProUGUIEx, user_name_path)
  self.tip_box_happy = self:AddComponent(UIBaseComponent, tip_box_happy_path)
  self.tip_box_angry = self:AddComponent(UIBaseComponent, tip_box_angry_path)
  self.player:SetEnableClickShowInfo(true)
end

function UIDispatchTaskRewardStealComponent:OnDestroy()
  self.player = nil
  self.playerName = nil
  self.tip_box_happy = nil
  self.tip_box_angry = nil
  base.OnDestroy(self)
end

function UIDispatchTaskRewardStealComponent:ReInit(param)
  self.param = param
  self.ownerInfo = self.param.ownerInfo
  if param.fromDispatchStealMessage then
    self.tip_box_angry:SetActive(true)
    self.tip_box_happy:SetActive(false)
  elseif param.fromDispatchAssistMessage then
    self.tip_box_angry:SetActive(false)
    self.tip_box_happy:SetActive(true)
  end
  self.playerName:SetText(self:GetFullName())
  self.player:SetHead(self.ownerInfo.uid, self.ownerInfo.headPic, self.ownerInfo.headPicVer, nil, self:GetHeadBgImg())
end

function UIDispatchTaskRewardStealComponent:GetFullName()
  local name = self.ownerInfo.name or ""
  local abbr = self.ownerInfo.abbr
  if not string.IsNullOrEmpty(abbr) then
    return "[" .. abbr .. "]" .. name
  end
  return name
end

function UIDispatchTaskRewardStealComponent:GetHeadBgImg()
  local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(self.ownerInfo.headSkinId, self.ownerInfo.headSkinET, false)
  return headBgImg
end

return UIDispatchTaskRewardStealComponent
