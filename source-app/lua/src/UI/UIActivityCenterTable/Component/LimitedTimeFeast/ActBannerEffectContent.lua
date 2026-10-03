local ActBannerEffectContent = BaseClass("ActBannerEffectContent", UIBaseContainer)
local base = UIBaseContainer
local Resource = CS.GameEntry.Resource
local unity_time = CS.UnityEngine.Time
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local DecorationModelShow = require("UI.UIDecorationChoiceBox.Component.DecorationModelShow")
local effect_content_path = "EffectContent"
local perfab_content_path = "PerfabContent"
local spine_content_path = "SpineContent"
local main_city_path = "PerfabContent/MainCity"
local chat_dynamic_sticker_path = "StickerContent/ChatDynamicSticker"
local MainCityRTSizeX = 750
local MainCityRTSizeY = 600

function ActBannerEffectContent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ActBannerEffectContent:OnDestroy()
  self:DestroyBannerSpine()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ActBannerEffectContent:ComponentDefine()
  self.effect_content = self:AddComponent(UIBaseContainer, effect_content_path)
  self.perfab_content = self:AddComponent(UIBaseContainer, perfab_content_path)
  self.spine_content = self:AddComponent(UIBaseContainer, spine_content_path)
  self.main_city = self:AddComponent(DecorationModelShow, main_city_path)
  self.main_city:SetActive(false)
  self.chat_dynamic_sticker = self:TryAddComponent(UIImage, chat_dynamic_sticker_path)
  if self.chat_dynamic_sticker ~= nil then
    self.chat_dynamic_sticker:SetActive(false)
    local anchoredPos = self.chat_dynamic_sticker:GetAnchoredPosition()
    self.initStickerPos = {
      x = anchoredPos.x,
      y = anchoredPos.y
    }
  end
end

function ActBannerEffectContent:ComponentDestroy()
  self.effect_content = nil
  self.perfab_content = nil
  self.spine_content = nil
  self.main_city = nil
  self.chat_dynamic_sticker = nil
end

function ActBannerEffectContent:DataDefine()
  self.effectPath = nil
  self.effectRequest = nil
  self.banner_spine = nil
  self.decorationId = nil
  self.decorationAniList = nil
  self.stickerMatReq = nil
  self.isKeepEffectRotationZ = false
  self.hasStickerOffset = false
end

function ActBannerEffectContent:DataDestroy()
  self.effectPath = nil
  self.effectRequest = nil
  self.banner_spine = nil
  self.decorationId = nil
  self.decorationAniList = nil
  self.stickerMatReq = nil
  self.isKeepEffectRotationZ = false
  self.initStickerPos = nil
  self.hasStickerOffset = nil
end

function ActBannerEffectContent:OnEnable()
  base.OnEnable(self)
end

function ActBannerEffectContent:OnDisable()
  base.OnDisable(self)
  self:DeleteEffectContent()
  self:DeleteMainCityContent()
  self:DeleteStickerContent()
  self:DestroyBannerSpine()
  self:ResetStickerPos()
end

function ActBannerEffectContent:SetData(activityInfo, isKeepEffectRotationZ)
  self.activityInfo = activityInfo
  self.isKeepEffectRotationZ = isKeepEffectRotationZ
  self:RefreshShow()
end

function ActBannerEffectContent:RefreshShow()
  if not self.activityInfo then
    return
  end
  self.showConfigTemp = self.activityInfo:GetShowConfigTemp()
  if self.showConfigTemp == nil then
    return
  end
  self:DestroyBannerSpine()
  self:DeleteStickerContent()
  local effectPath = self.showConfigTemp.banner_effect
  self:ReloadEffectContent(effectPath)
  local decorationData = self.showConfigTemp.banner_act
  local decorationDataList = string.split(decorationData, "|")
  local decorationId = 0
  local decorationAniList = {}
  if decorationDataList then
    if decorationDataList[1] then
      decorationId = tonumber(decorationDataList[1]) or 0
    end
    if decorationDataList[2] then
      local aniData = string.string2array_s(decorationDataList[2], ",", ";")
      for i, v in ipairs(aniData) do
        if #v == 2 then
          decorationAniList[i] = {
            v[1],
            tonumber(v[2])
          }
        end
      end
    end
  end
  self:RefreshMainCityContent(decorationId, decorationAniList)
  local new_banner_sticker = self.showConfigTemp.newbanner_sticker
  if not string.IsNullOrEmpty(new_banner_sticker) then
    local newBannerInfoList = {}
    for v in string.gmatch(new_banner_sticker, "[^|]+") do
      table.insert(newBannerInfoList, v)
    end
    local path = newBannerInfoList[1]
    local posStr = newBannerInfoList[2]
    self:ReloadBannerSpine(path, posStr)
  else
    local stickerStr = self.showConfigTemp.banner_sticker
    local stickerArr = string.split(stickerStr, "|")
    local stickerId = stickerArr[1] ~= nil and tonumber(stickerArr[1]) or 0
    local stickerPosStr = stickerArr[2]
    self:RefreshStickerContent(stickerId, stickerPosStr)
  end
end

function ActBannerEffectContent:DeleteEffectContent()
  if self.effectRequest ~= nil then
    self.effectRequest:Destroy()
    self.effectRequest = nil
  end
  self.effectPath = nil
end

function ActBannerEffectContent:ReloadEffectContent(effectContentPath)
  if self.effectPath == effectContentPath then
    return
  end
  self:DeleteEffectContent()
  self.effectPath = effectContentPath
  if string.IsNullOrEmpty(effectContentPath) then
    return
  end
  local request = self:GameObjectInstantiateAsync(effectContentPath)
  self.effectRequest = request
  request:completed("+", function(req)
    if req.isError or req.gameObject == nil then
      return
    end
    local obj = req.gameObject
    local parent = self.effect_content
    obj:SetActive(true)
    local rectTransform = obj:GetComponent(typeof(CS.UnityEngine.RectTransform))
    if rectTransform ~= nil then
      rectTransform:SetParent(parent.transform)
      rectTransform:Set_localScale(1, 1, 1)
      rectTransform:Set_anchoredPosition(0, 0, 0)
    end
  end)
end

function ActBannerEffectContent:ReloadBannerSpine(path, posStr)
  self:DestroyBannerSpine()
  local offsetX, offsetY = 0, 0
  if not string.IsNullOrEmpty(posStr) then
    offsetX, offsetY = string.match(posStr, "([^;]+);(.+)")
    offsetX = tonumber(offsetX) or 0
    offsetY = tonumber(offsetY) or 0
  end
  if CommonUtil.IsArabicAutoMirrorOpen() then
    offsetX = -offsetX
  end
  self.banner_spine = self:GameObjectInstantiateAsync(path, function(request)
    local go = request.gameObject
    local go_tf = go.transform
    go_tf:SetParent(self.spine_content.transform)
    go_tf.localPosition = Vector3.New(offsetX, offsetY, 0)
    go_tf.localScale = Vector3.New(1, 1, 1)
  end)
end

function ActBannerEffectContent:TraverseAndFlipZRotation(go)
  if go == nil then
    return
  end
  local rotation = go.transform.localEulerAngles
  rotation.z = -rotation.z
  go.transform.localEulerAngles = rotation
  for i = 0, go.transform.childCount - 1 do
    local child = go.transform:GetChild(i).gameObject
    self:TraverseAndFlipZRotation(child)
  end
end

function ActBannerEffectContent:DestroyBannerSpine()
  if self.banner_spine ~= nil then
    self:GameObjectDestroy(self.banner_spine)
    self.banner_spine = nil
  end
end

function ActBannerEffectContent:DeleteMainCityContent()
  if self.decorationId ~= nil then
    self.decorationId = nil
    self.decorationAniList = nil
    self.main_city:SetActive(false)
    self.main_city:EndShow()
  end
end

function ActBannerEffectContent:RefreshMainCityContent(decorationId, decorationAniList)
  if decorationId == self.decorationId then
    return
  end
  self:DeleteMainCityContent()
  self.decorationId = decorationId
  self.decorationAniList = decorationAniList
  if self.decorationId and self.decorationId > 0 then
    self.main_city:StartShow(MainCityRTSizeX * 1.5, MainCityRTSizeY * 1.5)
    self.main_city:SetCameraPos(Vector3.New(-2.55, 13.72, -13.55))
    self.main_city:SetRtFormat(CS.UnityEngine.RenderTextureFormat.ARGBHalf)
    self.main_city:SetData({
      decorationId = self.decorationId,
      decorationAniList = self.decorationAniList
    })
  end
end

function ActBannerEffectContent:DeleteStickerContent()
  if self.chat_dynamic_sticker ~= nil and not IsNull(self.chat_dynamic_sticker.unity_image) then
    self.chat_dynamic_sticker.unity_image.material = nil
    self.chat_dynamic_sticker:SetActive(false)
  end
  if self.stickerMatReq ~= nil then
    self.stickerMatReq:Release()
    self.stickerMatReq = nil
  end
end

function ActBannerEffectContent:RefreshStickerContent(stickerId, stickerPosStr)
  self:DeleteStickerContent()
  if stickerId <= 0 then
    return
  end
  local rowCfg = LocalController:instance():getLine(TableName.LW_Sticker, stickerId)
  if rowCfg == nil then
    return
  end
  local imgPath
  local startPosX = 0
  if string.IsNullOrEmpty(rowCfg.para1) then
    imgPath = string.format(ChatStickerDynamicPath, rowCfg.name)
    startPosX = 0
  else
    imgPath = ChatStickerImagePatch .. rowCfg.para1
    startPosX = tonumber(rowCfg.para2)
  end
  if self.chat_dynamic_sticker ~= nil then
    self.chat_dynamic_sticker:LoadSpriteAsync(imgPath)
  end
  local frame_rate = rowCfg.frame_rate
  local materialName = "MapSticker"
  local materailPath = string.format(ChatstickerMaterialPath, materialName)
  self.stickerMatReq = Resource:LoadAssetAsync(materailPath, typeof(CS.UnityEngine.Material))
  
  function self.stickerMatReq.completed(asset)
    if asset == nil then
      Logger.LogError("Sticker\229\175\185\229\186\148\231\154\132\230\157\144\232\180\168\229\138\160\232\189\189\229\164\177\232\180\165\239\188\154" .. materialName)
      return
    end
    local mat = CS.UnityEngine.Material.Instantiate(asset.asset)
    mat.name = materialName
    mat:SetFloat("_PlaySpeed", ChatStickerPlaySpeed)
    mat:SetFloat("_CurShowIndex", 0)
    mat:SetFloat("_StartTime", unity_time.timeSinceLevelLoad)
    mat:DisableKeyword("_FULLIMAGE_ON")
    mat:SetFloat("_StartX", startPosX)
    if self.chat_dynamic_sticker ~= nil and not IsNull(self.chat_dynamic_sticker.unity_image) then
      self.chat_dynamic_sticker.unity_image.material = mat
      self.chat_dynamic_sticker:SetActive(true)
    end
    if not string.IsNullOrEmpty(stickerPosStr) then
      local posArr = string.split(stickerPosStr, ";")
      local offsetX = posArr[1] and tonumber(posArr[1]) or 0
      local offsetY = posArr[2] and tonumber(posArr[2]) or 0
      local anchoredPos = self.chat_dynamic_sticker:GetAnchoredPosition()
      self.initStickerPos = {
        x = anchoredPos.x,
        y = anchoredPos.y
      }
      local targetLocalPos = Vector3(anchoredPos.x + offsetX, anchoredPos.y + offsetY, 0)
      self.chat_dynamic_sticker:SetAnchoredPositionXY(targetLocalPos.x, targetLocalPos.y)
      self.hasStickerOffset = true
    end
  end
end

function ActBannerEffectContent:ResetStickerPos()
  if self.chat_dynamic_sticker ~= nil and self.initStickerPos and self.hasStickerOffset then
    self.chat_dynamic_sticker:SetAnchoredPositionXY(self.initStickerPos.x, self.initStickerPos.y)
  end
end

return ActBannerEffectContent
