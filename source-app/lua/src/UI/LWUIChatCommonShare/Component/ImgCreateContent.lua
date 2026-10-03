local ImgCreateContent = BaseClass("ImgCreateContent", UIBaseContainer)
local base = UIBaseContainer
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
local Camera = CS.UnityEngine.Camera
local QualitySettingUtil = require("Util.QualitySettingUtil")
local pic_bg_path = "Content/PicContent/picBg"
local txt_title_path = "Content/PicContent/txtTitle"
local u_i_player_head_path = "Content/PicContent/bottomContent/HeadContent/UIPlayerHead"
local name_text_path = "Content/PicContent/bottomContent/playerNameContent/NameText"
local al_simple_text_path = "Content/PicContent/bottomContent/playerNameContent/AlSimpleText"
local camera_path = "Content/Camera"

function ImgCreateContent:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function ImgCreateContent:OnDestroy()
  self:EndShow()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ImgCreateContent:ComponentDefine()
  self.pic_bg = self:AddComponent(UIRawImage, pic_bg_path)
  self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
  self.u_i_player_head = self:AddComponent(UICommonHead, u_i_player_head_path)
  self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
  self.al_simple_text = self:AddComponent(UITextMeshProUGUIEx, al_simple_text_path)
  self.camera = self.gameObject.transform:Find(camera_path):GetComponentInChildren(typeof(Camera))
end

function ImgCreateContent:ComponentDestroy()
  self.pic_bg = nil
  self.txt_title = nil
  self.u_i_player_head = nil
  self.name_text = nil
  self.al_simple_text = nil
  self.camera = nil
end

function ImgCreateContent:DataDefine()
  self.renderTexture = nil
  self.renderTextureSmall = nil
  self.inputParam = nil
  self.targetUIImg = nil
end

function ImgCreateContent:DataDestroy()
  self.renderTexture = nil
  self.renderTextureSmall = nil
  self.inputParam = nil
  self.targetUIImg = nil
end

function ImgCreateContent:OnEnable()
  base.OnEnable(self)
end

function ImgCreateContent:OnDisable()
  base.OnDisable(self)
end

function ImgCreateContent:OnAddListener()
end

function ImgCreateContent:OnRemoveListener()
end

function ImgCreateContent:ReInit(inputParam, targetUIImg)
  self.inputParam = inputParam
  self.targetUIImg = targetUIImg
  if self.renderTexture == nil then
    local imgRect = self.targetUIImg.rectTransform.rect
    local rtWidth = imgRect.width
    local rtHeight = imgRect.height
    local rtFormat = RenderTextureFormat.ARGB32
    self.renderTexture = RenderTexture.GetTemporary(rtWidth, rtHeight, 24, rtFormat)
    self.renderTexture.name = "imgCreateContentRT"
    self.targetUIImg:SetTexture(self.renderTexture)
    local targetEdge = 200
    local targetScale = 1
    local maxEdge = math.max(rtWidth, rtHeight)
    if targetEdge < maxEdge then
      targetScale = targetEdge / maxEdge
    end
    local rtWidthSmall = toInt(rtWidth * targetScale)
    local rtHeightSmall = toInt(rtHeight * targetScale)
    self.renderTextureSmall = RenderTexture.GetTemporary(rtWidthSmall, rtHeightSmall, 24, rtFormat)
    self.renderTextureSmall.name = "imgCreateContentRTSmall"
  end
  self.camera.targetTexture = self.renderTexture
  local titleTxtKey = self.inputParam.titleTxtKey
  local picPath = self.inputParam.picPath
  self.pic_bg:LoadSprite(picPath)
  self.txt_title:SetLocalText(titleTxtKey)
  self.txt_title:SetAlignment(CommonUtil.IsArabicAutoMirrorOpen() and CS.TMPro.TextAlignmentOptions.TopRight or CS.TMPro.TextAlignmentOptions.TopLeft)
  local serverTxt = "#" .. LuaEntry.Player:GetSourceServerId()
  if LuaEntry.Player:IsInAlliance() then
    local allianceName = LuaEntry.Player:GetAllianceAbbr()
    self.al_simple_text:SetText(serverTxt .. " " .. allianceName)
  else
    self.al_simple_text:SetText(serverTxt)
  end
  local playerName = LuaEntry.Player:GetName()
  self.name_text:SetText(playerName)
  local uid = LuaEntry.Player:GetUid()
  local pic = LuaEntry.Player:GetPic()
  local picVer = LuaEntry.Player.picVer
  local headSkinPath = LuaEntry.Player:GetHeadBgImg()
  self.u_i_player_head:SetData(uid, pic, picVer, nil, headSkinPath)
  self.u_i_player_head:SetEnableClickShowInfo(false)
  self:ReInitExtra()
  return self.renderTexture
end

function ImgCreateContent:ReInitExtra()
end

function ImgCreateContent:EndShow()
  if self.targetUIImg and self.targetUIImg.unityRawImage then
    self.targetUIImg:SetTexture(nil)
  end
  if not IsNull(self.camera) then
    self.camera.targetTexture = nil
  end
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
  if self.renderTextureSmall ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTextureSmall)
    self.renderTextureSmall = nil
  end
end

function ImgCreateContent:CameraRenderTestureSmall()
  self.camera.targetTexture = self.renderTextureSmall
  self.camera:Render()
  self.camera.targetTexture = self.renderTexture
  return self.renderTextureSmall
end

return ImgCreateContent
