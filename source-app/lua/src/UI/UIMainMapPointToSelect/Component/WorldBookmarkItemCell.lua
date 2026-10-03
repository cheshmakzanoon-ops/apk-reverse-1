local WorldBookmarkItemCell = BaseClass("WorldBookmarkItemCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
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
    self:OnJumpClick()
  end)
  self.jump_txt = self:AddComponent(UIText, jump_txt_path)
  self.jump_txt:SetLocalText("alliance_announcement_4")
  self.del_btn = self:AddComponent(UIButton, del_btn_path)
  
  local function DelMark()
    self:OnDelClick()
  end
  
  self.del_btn:SetActive(false)
  self.del_btn:SetOnClick(function()
    UIUtil.ShowMessage(Localization:GetString("alliance_tag_opt_UI_5"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, DelMark)
  end)
  self.share_btn = self:AddComponent(UIButton, share_btn_path)
  self.share_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnShareClick()
  end)
  self.share_btn:SetActive(false)
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
  self.second_txt:SetLocalText(128005, self.data.server, pos.x, pos.y)
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
    self.editImg:SetActive(false)
    self.editBtn:SetActive(true)
  end
  self.flag:LoadSprite(img)
end

local function OnJumpClick(self)
  local selectItem = self.data
  local share_param = {}
  share_param.sid = selectItem.server
  share_param.pos = (selectItem.pos - selectItem.pos % 10) / 10
  share_param.uname = selectItem.name
  if selectItem.pointInfo and not string.IsNullOrEmpty(selectItem.pointInfo) then
    local info = rapidjson.decode(selectItem.pointInfo)
    if info then
      if info.uname then
        share_param.uname = info.uname
      else
        share_param.uname = ""
      end
      if info.abbr then
        share_param.abbr = info.abbr
      end
      if info.oname then
        share_param.oname = info.oname
      end
      if info.olv then
        share_param.olv = info.olv
      end
      share_param.uid = info.uid
      if not string.IsNullOrEmpty(info.posType) then
        share_param.posType = toInt(info.posType)
      end
    end
  end
  self.view:GetShareDataAndClose(share_param)
end

local function OnDelClick(self)
end

local function OnShareClick(self)
end

local function OnClickFlagBtn(self)
end

WorldBookmarkItemCell.OnCreate = OnCreate
WorldBookmarkItemCell.SetItemShow = SetItemShow
WorldBookmarkItemCell.OnJumpClick = OnJumpClick
WorldBookmarkItemCell.OnDelClick = OnDelClick
WorldBookmarkItemCell.OnShareClick = OnShareClick
WorldBookmarkItemCell.OnClickFlagBtn = OnClickFlagBtn
return WorldBookmarkItemCell
