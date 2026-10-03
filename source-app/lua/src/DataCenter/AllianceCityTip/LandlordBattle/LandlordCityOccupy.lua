local base = UIBaseContainer
local LandlordCityOccupy = BaseClass("LandlordCityOccupy", base)
local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local low_lod_path = "LowLod"
local low_lod_img_path = "LowLod/LowLodImage"
local low_lod_icon_path = "LowLod/LowLodImage/bg/icon"
local pro1_num_path = "LowLod/LowLodImage/pro1_num"
local low_lod_slider_path = "LowLod/Slider"
local low_lod_fill_path = "LowLod/Slider/FillArea/Fill"
local low_lod_percent_path = "LowLod/Slider/Percent"
local mid_lod_path = "MidLod"
local mid_lod_image_path = "MidLod/MidLodImg"
local mid_lod_txt_path = "MidLod/MidLodImg/MidLodTxt"
local high_lod_path = "HighLod"
local high_lod_image_path = "HighLod/HighLodImg"
local high_lod_txt_path = "HighLod/HighLodImg/HighLodTxt"
local hig_lod_progress_path = "HighLod/progress"
local ruins_tip_path = "RuinsTip"
local ruins_icon_path = "RuinsTip/Icon"
local ruins_score_path = "RuinsTip/Score"
local LOW_MAX_LOD = 3
local HIGH_MIN_LOD = 5

function LandlordCityOccupy:__init(transform)
  local request = ResourceManager:InstantiateAsync("Assets/Main/Prefabs/UI/AllianceCityTip/LandlordCityOccupy.prefab")
  request:completed("+", function()
    local theWorld = CS.SceneManager.World
    if request.isError or transform == nil or theWorld == nil or IsNull(transform) then
      return
    end
    local go = request.gameObject
    go.transform:SetParent(transform)
    go.transform:Set_localScale(0.01, 0.01, 0.01)
    go.transform:Set_localPosition(0, -2, 0)
    go.transform:Set_localRotation(0, 0, 0, 1)
    base.Reinit(self, go, "")
    self:OnCreate()
    self:OnEnable()
    self:SetLod(theWorld:GetLodLevel())
    self:UpdateData()
  end)
  self.lodCache = 0
  self.request = request
end

function LandlordCityOccupy:__delete()
  if self.gameObject ~= nil then
    self:OnDisable()
    self:OnDestroy()
  else
    self.holder = nil
  end
  if self.request then
    self.request:Destroy()
    self.request = nil
  end
end

function LandlordCityOccupy:OnCreate()
  base.OnCreate(self)
  self.theCanvas = self:AddComponent(UICanvas, "")
  self.low_lod_root = self:AddComponent(UIBaseComponent, low_lod_path)
  self.low_lod_img = self:AddComponent(UIBaseComponent, low_lod_img_path)
  self.low_lod_icon = self:AddComponent(UIImage, low_lod_icon_path)
  self.pro1_num = self:AddComponent(UITextMeshProUGUIEx, pro1_num_path)
  self.low_lod_slider = self:AddComponent(UISlider, low_lod_slider_path)
  self.low_lod_fill = self:AddComponent(UIImage, low_lod_fill_path)
  self.low_lod_percent = self:AddComponent(UITextMeshProUGUIEx, low_lod_percent_path)
  self.mid_lod_root = self:AddComponent(UIBaseComponent, mid_lod_path)
  self.mid_lod_img = self:AddComponent(UIImage, mid_lod_image_path)
  self.mid_lod_txt = self:AddComponent(UITextMeshProUGUIEx, mid_lod_txt_path)
  self.high_lod_root = self:AddComponent(UIBaseContainer, high_lod_path)
  self.high_lod_img = self:AddComponent(UIImage, high_lod_image_path)
  self.high_lod_txt = self:AddComponent(UITextMeshProUGUIEx, high_lod_txt_path)
  self.high_lod_progress = self:AddComponent(UITextMeshProUGUIEx, hig_lod_progress_path)
  self.ruins_tip = self:AddComponent(UIBaseComponent, ruins_tip_path)
  self.ruins_icon = self:AddComponent(UIImage, ruins_icon_path)
  self.ruins_score = self:AddComponent(UITextMeshProUGUIEx, ruins_score_path)
end

function LandlordCityOccupy:OnAddListener()
  base.OnAddListener(self)
  self.registerListener = true
end

function LandlordCityOccupy:OnRemoveListener()
  if self.registerListener then
    self.registerListener = false
  end
  base.OnRemoveListener(self)
end

function LandlordCityOccupy:OnDestroy()
  base.OnDestroy(self)
  self.theCanvas = nil
  self.low_lod_root = nil
  self.low_lod_icon = nil
  self.pro1_num = nil
  self.low_lod_slider = nil
  self.low_lod_fill = nil
  self.low_lod_percent = nil
  self.mid_lod_root = nil
  self.mid_lod_img = nil
  self.mid_lod_txt = nil
  self.high_lod_root = nil
  self.high_lod_img = nil
  self.high_lod_txt = nil
  self.high_lod_progress = nil
  self.ruins_tip = nil
  self.ruins_icon = nil
  self.ruins_score = nil
end

function LandlordCityOccupy:SetLod(lod)
  self.lodCache = toInt(lod)
  self:RefreshLod()
end

function LandlordCityOccupy:RefreshLod()
  if IsNotNull(self.gameObject) then
    local lodCache = self.lodCache or 0
    local showLow = 0 < lodCache and lodCache < LOW_MAX_LOD and (self.curClientState ~= LLConst.LLBuildingState.Ruins and self.startTime ~= nil and self.endTime ~= nil or self.curClientState == LLConst.LLBuildingState.NotOpen or self.curClientState == LLConst.LLBuildingState.OpenButShield or self.curClientState == LLConst.LLBuildingState.Fighting)
    self.low_lod_root:SetActive(showLow)
    local showMid = lodCache >= LOW_MAX_LOD and lodCache <= HIGH_MIN_LOD and (self.curClientState == LLConst.LLBuildingState.NotOpen or self.curClientState == LLConst.LLBuildingState.OpenButShield or self.curClientState == LLConst.LLBuildingState.Fighting)
    self.mid_lod_root:SetActive(showMid)
    local showHigh = lodCache > HIGH_MIN_LOD and (self.curClientState == LLConst.LLBuildingState.NotOpen or self.curClientState == LLConst.LLBuildingState.OpenButShield or self.curClientState == LLConst.LLBuildingState.Fighting)
    self.high_lod_root:SetActive(showHigh)
    local showRuins = self.isUnlocked and self.curClientState == LLConst.LLBuildingState.Ruins
    self.ruins_tip:SetActive(showRuins)
    self:Update1000MS()
  end
end

function LandlordCityOccupy:ReInit(data)
  self.data = data
  self.cityId = toInt(self.data.id)
  self.cityType = toInt(self.data.type)
  self.serverId = self.data:GetCurServerId()
  self:UpdateData()
end

local FIX_ICON = "Assets/Main/Sprites/UI/Landlord/lrb_jinmai_zhujiemian_xiujian.png"
local WILL_BOOM_ICON = "Assets/Main/Sprites/UI/Landlord/lrb_jinmai_zhujiemian_zhadan.png"
local NOT_OPEN_ICON = "Assets/Main/Sprites/UI/UILWMail/FX_youjianzhanbao_hudun.png"
local MID_LOD_BG_ENEMY = "mjc_wzz_jijianshitubg_hong.png"
local MID_LOD_BG_ME = "mjc_wzz_jijianshitubg_lan.png"
local MID_LOD_BG_NONE = "zyf_wzz_jijianshitubg_huang.png"
local MID_LOD_BG_UNOPEN = "zyf_wzz_jijianshitubg_hui.png"

function LandlordCityOccupy:UpdateData()
  if IsNull(self.gameObject) or not self.data then
    return
  end
  local info = self.data:GetPointInfo()
  self.isUnlocked = false
  if info then
    local tableName = DataCenter.LandlordMgr:GetCityTemplateTableName()
    self.curClientState = info.curClientState
    self.tmpOwnerCampId = LLConst.LandLordGroup.NONE
    self.myCampId = DataCenter.LandlordMgr:GetMyGroup()
    self.progress = info.progress
    self.maxProgress = info.progressMax
    local curTime = UITimeManager:GetInstance():GetServerTime()
    self.endTime = nil
    local iconPath
    self.startTime = nil
    if info.curClientState == LLConst.LLBuildingState.WillExplode then
      iconPath = WILL_BOOM_ICON
      self.startTime = info.overTime
      local boom_time = GetTableData(tableName, info.cityId, "boom_time")
      self.endTime = info.overTime + tonumber(boom_time) * 1000
    elseif info.curClientState == LLConst.LLBuildingState.Rebuilding then
      iconPath = FIX_ICON
      self.startTime = info.fixStartTime
      self.endTime = info.fixEndTime
    elseif info.curClientState == LLConst.LLBuildingState.NotOpen then
      iconPath = NOT_OPEN_ICON
      self.isUnlocked = DataCenter.LandlordMgr:IsUnlockCityByWeek(info.cityId)
      self.endTime = math.max(info.unlockTime, DataCenter.LandlordMgr:GetLLCityNextOpenTimeByCityId(info.cityId))
    elseif info.curClientState == LLConst.LLBuildingState.OpenButShield then
      iconPath = NOT_OPEN_ICON
      local buildingUnlockTime = info.unlockTime or 0
      self.endTime = buildingUnlockTime
      self.isUnlocked = true
    elseif info.curClientState == LLConst.LLBuildingState.Fighting then
      self.isUnlocked = true
      self.occupyStartTime = info.occupyStartTime
      self.occupyStartProgress = info.occupyStartProgress
      self.tmpOwnerCampId = info.tmpOwnerCampId
      self.alAbbr = info.alAbbr
      self.alServerId = info.alServerId
      self.extraEffectValue = 0
      local effectId = LLConst.OccupySpeedEffectId[info.tmpOwnerCampId]
      if effectId and info.effects:ContainsKey(effectId) then
        self.extraEffectValue = info.effects[effectId] or 0
      end
    elseif self.curClientState == LLConst.LLBuildingState.Ruins then
      self.ruins_points = GetTableData(tableName, info.cityId, "ruins_points")
      self.isUnlocked = DataCenter.LandlordMgr:IsUnlockCityByWeek(info.cityId)
    end
    if iconPath then
      self.low_lod_icon:LoadSpriteAuto(iconPath)
    end
    if self.curClientState == LLConst.LLBuildingState.NotOpen or self.curClientState == LLConst.LLBuildingState.OpenButShield or self.curClientState == LLConst.LLBuildingState.Fighting then
      self.cityName = GetTableData(tableName, info.cityId, "name")
      if self:IsThroneCity() then
        self.cityName = Localization:GetString(self.cityName)
        self.mid_lod_img:SetSizeDeltaX(205)
        self.high_lod_img:SetSizeDeltaX(125)
      else
        self.mid_lod_img:SetSizeDeltaX(180)
        self.high_lod_img:SetSizeDeltaX(100)
      end
      local fillName, imgName
      if self.isUnlocked then
        if self.tmpOwnerCampId == LLConst.LandLordGroup.NONE then
          fillName = "cfm_tongyong_jindutiao_huang.png"
          imgName = MID_LOD_BG_NONE
        else
          fillName = self.myCampId == self.tmpOwnerCampId and "lyp_tongyong_jindutiao_lan.png" or "lrb_tongyong_jindutiao_hong.png"
          imgName = self.myCampId == self.tmpOwnerCampId and MID_LOD_BG_ME or MID_LOD_BG_ENEMY
        end
      else
        fillName = "lrb_tongyong_jindutiao_hui.png"
        imgName = MID_LOD_BG_UNOPEN
      end
      self.low_lod_fill:LoadSpriteAuto(string.format(LoadPath.CommonNewPath, fillName))
      self.low_lod_slider:SetActive(true)
      self.low_lod_slider:SetValue(self.progress / self.maxProgress)
      local percent = string.percentage(self.progress, self.maxProgress, 1)
      self.low_lod_percent:SetText(percent)
      self.mid_lod_img:LoadSpriteAuto(string.format(LoadPath.LodIcon, imgName))
      self.high_lod_img:LoadSpriteAuto(string.format(LoadPath.LodIcon, imgName))
      self.mid_lod_txt:SetText(string.format("%s %s", self.cityName, percent))
      self.high_lod_txt:SetText(self.cityName)
      self:UpdateHigLodProgress(self.progress)
    else
      self.low_lod_slider:SetActive(false)
      if self.curClientState == LLConst.LLBuildingState.Ruins then
        local point = toInt(self.ruins_points)
        self.ruins_score:SetText("+" .. point)
        self.ruins_icon:LoadSpriteAuto(string.format(LoadPath.LandlordPath, self.myCampId == LLConst.LandLordGroup.LORD and "lrb_jinmai_beizhan_pocheng_hong.png" or "lrb_jinmai_beizhan_pocheng_lan.png"))
      end
    end
    if self.endTime and curTime > self.endTime then
      self.endTime = nil
    end
  end
  self:RefreshLod()
end

function LandlordCityOccupy:GetProgress()
  local progress = DataCenter.LandlordMgr:CalculateOccupyCurProgress(self.occupyStartTime, self.occupyStartProgress, self.maxProgress, self.tmpOwnerCampId, self.extraEffectValue, self:IsThroneCity())
  return progress
end

function LandlordCityOccupy:UpdateHigLodProgress(progress)
  self.high_lod_progress:SetText(string.percentage(progress, self.maxProgress, 1))
  if not self.isUnlocked then
    self.high_lod_progress:SetColorRGBA255(232, 232, 232, 255)
  elseif progress < self.maxProgress / 2 then
    self.high_lod_progress:SetColorRGBA255(255, 255, 255, 255)
  else
    self.high_lod_progress:SetColorRGBA255(249, 246, 112, 255)
  end
end

function LandlordCityOccupy:IsThroneCity()
  return self.cityType == WorldAllianceCityType.LLThroneCity
end

function LandlordCityOccupy:Update1000MS()
  if IsNull(self.gameObject) or not self.curClientState then
    return
  end
  if self.lodCache < LOW_MAX_LOD and self.low_lod_root:GetActive() then
    self.low_lod_img:SetActive(self.endTime ~= nil)
    if self.endTime then
      local timeMgr = UITimeManager:GetInstance()
      local curTime = timeMgr:GetServerTime()
      local remainTime = self.endTime - curTime
      if 0 <= remainTime then
        self.pro1_num:SetText(timeMgr:MilliSecondToFmtString(remainTime))
      else
        self.pro1_num:SetText("")
      end
    end
    if self.isUnlocked and self.curClientState == LLConst.LLBuildingState.Fighting and self.tmpOwnerCampId ~= LLConst.LandLordGroup.NONE then
      local progress = self:GetProgress()
      self.low_lod_slider:SetValue(progress / self.maxProgress)
      self.low_lod_percent:SetText(string.percentage(progress, self.maxProgress, 1))
    end
  elseif self.lodCache >= LOW_MAX_LOD and self.lodCache <= HIGH_MIN_LOD and self.mid_lod_root:GetActive() then
    if self.curClientState == LLConst.LLBuildingState.Fighting and self.tmpOwnerCampId ~= LLConst.LandLordGroup.NONE then
      local progress = self:GetProgress()
      self.mid_lod_txt:SetText(string.format("%s %s", self.cityName, string.percentage(progress, self.maxProgress, 1)))
    end
  elseif self.lodCache > HIGH_MIN_LOD and self.high_lod_root:GetActive() and self.curClientState == LLConst.LLBuildingState.Fighting and self.tmpOwnerCampId ~= LLConst.LandLordGroup.NONE then
    local progress = self:GetProgress()
    self:UpdateHigLodProgress(progress)
  end
end

return LandlordCityOccupy
