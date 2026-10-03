local WorldBookmarkItemCell = BaseClass("WorldBookmarkItemCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local first_name_path = "ImgBg/title/firstNameTxt"
local editImg_path = "ImgBg/title/editImg"
local second_name_path = "ImgBg/secondNameTxt"
local jump_txt_path = "ImgBg/jumpButton/jumpText"
local jump_btn_path = "ImgBg/jumpButton"
local del_btn_path = "ImgBg/delButton"
local share_btn_path = "ImgBg/shareButton"
local flag_path = "ImgBg/Flag"
local editBtn_path = "ImgBg/editBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self.editImg = self:AddComponent(UIBaseContainer, editImg_path)
  self.first_txt = self:AddComponent(UIText, first_name_path)
  self.second_txt = self:AddComponent(UIText, second_name_path)
  self.jump_btn = self:AddComponent(UIButton, jump_btn_path)
  self.jump_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnJumpClick()
  end)
  self.jump_txt = self:AddComponent(UIText, jump_txt_path)
  self.jump_txt:SetLocalText(110003)
  self.del_btn = self:AddComponent(UIButton, del_btn_path)
  
  local function DelMark()
    self:OnDelClick()
  end
  
  self.del_btn:SetOnClick(function()
    UIUtil.ShowMessage(Localization:GetString("alliance_tag_opt_UI_5"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, DelMark)
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  end)
  self.share_btn = self:AddComponent(UIButton, share_btn_path)
  self.share_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnShareClick()
  end)
  self.flag = self:AddComponent(UIImage, flag_path)
  self.flagBtn = self:AddComponent(UIButton, flag_path)
  self.editBtn = self:AddComponent(UIButton, editBtn_path)
  self.editBtn:SetOnClick(function()
    self:OnClickFlagBtn()
  end)
end

local function SetItemShow(self, data)
  self.data = data
  local showName = self.data.name
  self.first_txt:SetText(showName)
  local pointId = (self.data.pos - self.data.pos % 10) / 10
  local pos = SceneUtils.IndexToTilePos(pointId)
  self.second_txt:SetLocalText("world_tip10013", self.data.server, pos.x, pos.y)
  local img = "Common_img_mark"
  self.editImg:SetActive(false)
  self.editBtn:SetActive(false)
  if self.data.type == 0 then
    img = string.format(LoadPath.CommonNewPath, "Common_img_mark")
  elseif self.data.type == 1 then
    img = string.format(LoadPath.CommonNewPath, "Common_img_mark_friend")
  elseif self.data.type == 2 then
    img = string.format(LoadPath.CommonNewPath, "Common_img_mark_enemy")
  else
    img = string.format(LoadPath.AllianceMark, DataCenter.WorldFavoDataManager:GetBookMarkIconName(self.data.type))
    self.editImg:SetActive(true)
    self.editBtn:SetActive(true)
  end
  self.flag:LoadSprite(img)
end

local function OnJumpClick(self)
  self.view.ctrl:OnClickPosBtn(self.data)
end

local function OnDelClick(self)
  self.view.ctrl:DelBookMark(self.data)
end

local function OnShareClick(self)
  self.view.ctrl:ShareBookMark(self.data)
end

local function OnClickFlagBtn(self)
  local share_param = {}
  share_param.sid = self.data.server
  share_param.pos = self.data.pos
  share_param.oname = self.data.name
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionAdd, {anim = true}, share_param)
  self.view.ctrl:CloseSelf()
end

WorldBookmarkItemCell.OnCreate = OnCreate
WorldBookmarkItemCell.SetItemShow = SetItemShow
WorldBookmarkItemCell.OnJumpClick = OnJumpClick
WorldBookmarkItemCell.OnDelClick = OnDelClick
WorldBookmarkItemCell.OnShareClick = OnShareClick
WorldBookmarkItemCell.OnClickFlagBtn = OnClickFlagBtn
return WorldBookmarkItemCell
