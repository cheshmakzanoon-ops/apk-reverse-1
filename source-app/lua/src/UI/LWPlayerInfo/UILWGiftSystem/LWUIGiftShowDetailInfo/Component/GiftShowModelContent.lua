local base = UIBaseContainer
local GiftShowModelContent = BaseClass("GiftShowModelContent", base)
local Localization = CS.GameEntry.Localization
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
local ResourceManager = CS.GameEntry.Resource
local Camera = CS.UnityEngine.Camera
local DISPLAY_SCENE_PATH = "Assets/Main/Prefabs/UI/LWPlayerInfo/GiftSystem/prefab_zs/GiftModelScence.prefab"
local DISPLAY_MODEL_PATH = "Assets/Main/Prefabs/UI/LWPlayerInfo/GiftSystem/prefab_zs/%s.prefab"
local camera_path = "Camera"
local modelPos = "modelPos"
local light_path = "Directional Light"
local HideMenuImage = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_1"
local ShowMenuImage = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_2"
local model_img_path = "GiftIconContent/modelImg"
local to_left_btn_path = "toLeftBtn"
local ro_right_btn_path = "roRightBtn"
local gift_name_path = "giftName"
local gift_pic_path = "GiftIconContent/giftPic"
local model_num_select_bar_path = "ModelNumSelectBar"
local model_num_menu_icon_path = "ModelNumSelectBar/MenuBtn/ModelNumMenuIcon"
local model_num_img_path = "ModelNumSelectBar/ModelNumContent/modelNumImg"
local model_num_txt_path = "ModelNumSelectBar/ModelNumContent/ModelNumTxt"
local defaultShowParam = "0;0.4;2.5|0;180;0|2"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:TryDestroyShowGift()
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
  self.model_img = self:AddComponent(UIRawImage, model_img_path)
  self.to_left_btn = self:AddComponent(UIButton, to_left_btn_path)
  self.ro_right_btn = self:AddComponent(UIButton, ro_right_btn_path)
  self.gift_name = self:AddComponent(UITextMeshProUGUIEx, gift_name_path)
  self.to_left_btn:SetOnClick(function()
    if self.changeFunc then
      self.changeFunc(-1)
    end
  end)
  self.ro_right_btn:SetOnClick(function()
    if self.changeFunc then
      self.changeFunc(1)
    end
  end)
  self.gift_pic = self:AddComponent(UIImage, gift_pic_path)
  self.model_num_select_bar = self:AddComponent(UIButton, model_num_select_bar_path)
  self.model_num_menu_icon = self:AddComponent(UIImage, model_num_menu_icon_path)
  self.model_num_img = self:AddComponent(UIImage, model_num_img_path)
  self.model_num_txt = self:AddComponent(UITextMeshProUGUIEx, model_num_txt_path)
  self.model_num_select_bar:SetOnClick(function()
    self:OnModelNumSelectBarClick()
  end)
end

local function ComponentDestroy(self)
  self.model_img = nil
  self.to_left_btn = nil
  self.ro_right_btn = nil
  self.gift_name = nil
  self.gift_pic = nil
  self.model_num_select_bar = nil
  self.model_num_menu_icon = nil
  self.model_num_img = nil
  self.model_num_txt = nil
end

local function DataDefine(self)
  self.targetUid = nil
  self.originIdList = {}
  self.curOriginId = nil
  self.showData = nil
  self.changeFunc = nil
  self.giftGoodsTemp = nil
  self.goodsTemp = nil
  self.oldModelPath = nil
  self.modelPath = nil
  self.curReqModelPath = nil
  self.sceneLoading = nil
  self.sceneLoaded = nil
  self.sceneCamera = nil
  self.defaultLight = nil
  self.scencePosDotween = nil
  self.modelReqLoading = nil
  self.modelReqLoaded = nil
  self.defaultScenePos = Vector3.New(100, 0, 0)
  self.playAniRecord = {}
  self.menuShow = false
end

local function DataDestroy(self)
  self.targetUid = nil
  self.originIdList = nil
  self.curOriginId = nil
  self.showData = nil
  self.changeFunc = nil
  self.giftGoodsTemp = nil
  self.goodsTemp = nil
  self.oldModelPath = nil
  self.modelPath = nil
  self.curReqModelPath = nil
  self.sceneLoading = nil
  self.sceneLoaded = nil
  self.sceneCamera = nil
  self.defaultLight = nil
  self.scencePosDotween = nil
  self.modelReqLoading = nil
  self.modelReqLoaded = nil
  self.defaultScenePos = nil
  self.playAniRecord = nil
  self.menuShow = nil
end

function GiftShowModelContent:SetData(targetUid, originIdList, curOriginId, showData, giftGoodsTemp, goodsTemp)
  self.targetUid = targetUid
  self.originIdList = originIdList
  self.curOriginId = curOriginId
  self.showData = showData
  self.giftGoodsTemp = giftGoodsTemp
  self.goodsTemp = goodsTemp
  self.isEditorType = self.targetUid == LuaEntry.Player.uid
  self.menuShow = false
  self.selectGroupId = -1
  self:RefreshView()
end

function GiftShowModelContent:SetChangeFunc(func)
  self.changeFunc = func
end

function GiftShowModelContent:RefreshView()
  if self.giftGoodsTemp == nil or self.goodsTemp == nil then
    return
  end
  local bg, modelBg, txtColor = GiftSystemConst.GetGiftDetailShowQualityPic(self.goodsTemp.color)
  self.gift_name:SetColorHex(txtColor)
  self.gift_name:SetLocalText(self.goodsTemp.name)
  self.to_left_btn:SetActive(#self.originIdList > 1)
  self.ro_right_btn:SetActive(#self.originIdList > 1)
  self:TryShowGift()
end

function GiftShowModelContent:RefreshMenuShowBtn()
  if self.menuShow then
    self.model_num_menu_icon:LoadSprite(ShowMenuImage)
  else
    self.model_num_menu_icon:LoadSprite(HideMenuImage)
  end
end

function GiftShowModelContent:TryShowGift()
  if self.showData == nil then
    return
  end
  local giftNum = 1
  if self.showData.contentObj and self.showData.contentObj.num then
    giftNum = self.showData.contentObj.num
  end
  if self.showData.giftDetailSet and self.showData.giftDetailSet.count and self.showData.giftDetailSet.count > 0 then
    giftNum = self.showData.giftDetailSet.count
  end
  local modelPath = ""
  local icon_big = ""
  local groupId = -1
  local groupNum = 0
  for i, v in ipairs(self.giftGoodsTemp.group_id) do
    if giftNum >= tonumber(v) then
      groupId = i
      groupNum = tonumber(v)
    else
      break
    end
  end
  self.selectGroupId = groupId
  if 0 < groupId then
    modelPath = self.giftGoodsTemp.group_model[groupId]
    icon_big = self.giftGoodsTemp.group_pic[groupId]
  end
  if string.IsNullOrEmpty(modelPath) and string.IsNullOrEmpty(icon_big) then
    modelPath = self.giftGoodsTemp.model
    icon_big = self.giftGoodsTemp.icon_big
  end
  local hOffset, minScale, midScale, maxScale = DataCenter.GiftSystemManager.GetGiftIconParam(self.giftGoodsTemp)
  self.oldModelPath = self.modelPath
  if not string.IsNullOrEmpty(modelPath) then
    self.model_img:SetActive(false)
    self.gift_pic:SetActive(false)
    self.modelPath = modelPath
    self:LoadScene()
  else
    self.model_img:SetActive(false)
    self.gift_pic:SetActive(true)
    self.gift_pic:LoadSpriteAsyncWithCallback(GiftSystemConst.GetIconPathNew(icon_big), function()
      if self.gift_pic then
        self.gift_pic:SetNativeSize()
      end
    end)
    self.gift_pic:SetLocalScaleXYZ(maxScale, maxScale, maxScale)
    self.modelPath = nil
  end
  if self.isEditorType and 0 < groupId then
    self.model_num_select_bar:SetActive(true)
    self:RefreshMenuShowBtn()
    local icon = self.giftGoodsTemp.group_icon[groupId]
    self.model_num_img:LoadSprite(GiftSystemConst.GetIconPath(icon))
    self.model_num_img:SetSizeDeltaXY(56, 56)
    self.model_num_txt:SetText("\195\151" .. groupNum)
  else
    self.model_num_select_bar:SetActive(false)
  end
end

function GiftShowModelContent:LoadScene()
  if self.sceneLoading then
    return
  end
  if self.sceneLoaded then
    self:DoWhenSceneLoaded()
    return
  end
  local scenePath = DISPLAY_SCENE_PATH
  local request = ResourceManager:InstantiateAsync(scenePath)
  self.sceneLoading = request
  request:completed("+", function()
    if request.isError then
      self.sceneLoading = nil
      self:DoWhenSceneLoaded()
      return
    end
    self.sceneObj = request.gameObject
    self.sceneObj:SetActive(true)
    self.sceneObj.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.sceneObj.transform:Set_position(self.defaultScenePos.x, self.defaultScenePos.y, self.defaultScenePos.z)
    local camera = self.sceneObj.transform:Find(camera_path):GetComponentInChildren(typeof(Camera))
    local modelTweenPos = self.sceneObj.transform:Find(modelPos):GetComponentInChildren(typeof(CS.DG.Tweening.DOTweenAnimation))
    local defaultLight = self.sceneObj.transform:Find(light_path)
    self.sceneLoading = nil
    self.sceneLoaded = request
    self.sceneCamera = camera
    self.defaultLight = defaultLight
    self.scencePosDotween = modelTweenPos
    self:ToggleSceneCamera(true)
    self:DoWhenSceneLoaded()
  end)
end

function GiftShowModelContent:ToggleSceneCamera(b)
  local sceneCamera = self.sceneCamera
  if not IsNull(sceneCamera) then
    sceneCamera.gameObject:SetActive(b)
    if b then
      self:OnRenderTexture(sceneCamera)
    else
      sceneCamera.targetTexture = nil
    end
  end
end

function GiftShowModelContent:DoWhenSceneLoaded()
  if not IsNull(self.sceneObj) then
    self.sceneObj:SetActive(true)
  end
  if IsNull(self.scencePosDotween) then
    return
  end
  if IsNull(self.defaultLight) then
    return
  end
  local showParam = defaultShowParam
  if self.giftGoodsTemp and not string.IsNullOrEmpty(self.giftGoodsTemp.show_param) then
    showParam = self.giftGoodsTemp.show_param
  end
  local showParamTab = string.string2array_num(showParam, ";", "|")
  if #showParamTab == 3 then
    if #showParamTab[1] == 3 then
      self.sceneCamera.transform:Set_localPosition(showParamTab[1][1], showParamTab[1][2], showParamTab[1][3])
    end
    if #showParamTab[2] == 3 then
      self.sceneCamera.transform:Set_eulerAngles(showParamTab[2][1], showParamTab[2][2], showParamTab[2][3])
    end
    if #showParamTab[3] == 1 then
      self.scencePosDotween.duration = showParamTab[3][1]
    end
  end
  self.defaultLight.gameObject:SetActive(self.giftGoodsTemp.default_light == 0)
  if self.oldModelPath ~= self.modelPath then
    if self.modelPath ~= self.curReqModelPath then
      if not string.IsNullOrEmpty(self.modelPath) then
        self:TryDestroyModelReq()
        self.curReqModelPath = self.modelPath
        local request = ResourceManager:InstantiateAsync(string.format(DISPLAY_MODEL_PATH, self.modelPath))
        self.modelReqLoading = request
        request:completed("+", function()
          if request.isError then
            self.modelReqLoading = nil
            self:TryShowGift()
            return
          end
          self.modelReqLoading = nil
          self.modelReqLoaded = request
          self.modelObj = request.gameObject
          self.modelObj.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          self.modelObj.transform:SetParent(self.scencePosDotween.transform, false)
          self.modelObj.transform:Set_localPosition(0, 0, 0)
          self.scencePosDotween:DORestart()
        end)
      end
    elseif not string.IsNullOrEmpty(self.modelPath) and not IsNull(self.modelReqLoaded) then
      self.scencePosDotween:DORestart()
    end
  end
  if not string.IsNullOrEmpty(self.modelPath) then
    self.model_img:SetActive(true)
  end
end

function GiftShowModelContent:OnRenderTexture(camera)
  if camera == nil then
    Logger.LogError("OnRenderTexture camera is nil!")
    return
  end
  if self.renderTexture == nil then
    local rtImgWidth = self.model_img.rectTransform.rect.width
    local rtImgHeight = self.model_img.rectTransform.rect.height
    local rtFormat = RenderTextureFormat.ARGBHalf
    self.renderTexture = RenderTexture.GetTemporary(math.floor(rtImgWidth), math.floor(rtImgHeight), 24, rtFormat)
    self.renderTexture.name = "GiftSpecialRT"
    self.model_img:SetTexture(self.renderTexture)
    self.model_img:SetColor(Color.white)
  end
  camera.targetTexture = self.renderTexture
end

function GiftShowModelContent:TryDestroyShowGift()
  self:TryDestroyModelReq()
  if self.sceneCamera then
    self.sceneCamera.targetTexture = nil
  end
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
  self.renderTexture = nil
  if self.sceneLoaded ~= nil then
    self.sceneLoaded:Destroy()
  end
  self.sceneLoaded = nil
  if self.sceneLoading ~= nil then
    self.sceneLoading:Destroy()
  end
  self.sceneLoading = nil
end

function GiftShowModelContent:TryDestroyModelReq()
  if self.modelReqLoading ~= nil then
    self.modelReqLoading:Destroy()
  end
  self.modelReqLoading = nil
  if self.modelReqLoaded ~= nil then
    self.modelReqLoaded:Destroy()
  end
  self.modelReqLoaded = nil
end

function GiftShowModelContent:OnModelNumSelectBarClick()
  if self.showData == nil then
    return
  end
  if self.menuShow then
    return
  end
  self.menuShow = true
  self:RefreshMenuShowBtn()
  local show_list = {}
  for i, v in ipairs(self.giftGoodsTemp.group_id) do
    local curNum = tonumber(v)
    table.insert(show_list, {
      id = i,
      num = curNum,
      icon = self.giftGoodsTemp.group_icon[i],
      isUnlock = DataCenter.GiftDetailShowDataManager:CheckGiftNumIsUnlock(self.giftGoodsTemp.id, curNum),
      selectId = self.selectGroupId,
      clickFunc = function(num)
        self.showData:SendSetDataMsg(false, false, false, nil, num)
      end
    })
  end
  self.view:OnSetMenuShow(self.model_num_select_bar, show_list, self.selectGroupId)
end

GiftShowModelContent.OnCreate = OnCreate
GiftShowModelContent.OnDestroy = OnDestroy
GiftShowModelContent.OnEnable = OnEnable
GiftShowModelContent.OnDisable = OnDisable
GiftShowModelContent.ComponentDefine = ComponentDefine
GiftShowModelContent.ComponentDestroy = ComponentDestroy
GiftShowModelContent.DataDefine = DataDefine
GiftShowModelContent.DataDestroy = DataDestroy
return GiftShowModelContent
