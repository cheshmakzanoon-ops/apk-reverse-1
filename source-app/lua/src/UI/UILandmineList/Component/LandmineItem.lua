local LandmineItem = BaseClass("LandmineItem", UIBaseContainer)
local base = UIBaseContainer
local first_name_path = "ImgBg/title/firstNameTxt"
local editImg_path = "ImgBg/title/editImg"
local second_name_path = "ImgBg/secondNameTxt"
local jump_txt_path = "ImgBg/jumpButton/jumpText"
local jump_btn_path = "ImgBg/jumpButton"
local share_btn_path = "ImgBg/shareButton"
local flag_path = "ImgBg/Flag"

function LandmineItem:OnCreate()
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
  self.share_btn = self:AddComponent(UIButton, share_btn_path)
  self.share_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnShareClick()
  end)
  self.flag = self:AddComponent(UIImage, flag_path)
end

function LandmineItem:SetItemShow(data)
  self.data = data
  local meta = DataCenter.WorldTriggerTemplateManager:GetMeta(data.cfgId)
  local showName = meta:GetName()
  self.first_txt:SetText(showName)
  local pos = SceneUtils.IndexToTilePos(data.pointId, ForceChangeScene.World)
  self.second_txt:SetLocalText(128005, LuaEntry.Player:GetSourceServerId(), pos.x, pos.y)
  self.flag:LoadSprite(meta.icon)
end

function LandmineItem:OnJumpClick()
  local pointId = self.data.pointId
  GoToUtil.CloseAllWindows()
  GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World), CS.SceneManager.World.InitZoom, nil, nil, LuaEntry.Player:GetSourceServerId())
end

return LandmineItem
