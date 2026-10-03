local AllyDrillCowDes = BaseClass("AllyDrillCowDes", UIAsyncContainer)
local base = UIAsyncContainer
local build_details_path = "BuildDetails"
local des_txt_path = "BuildDetails/ScrollView/Viewport/Content0/desTxt"
local build_info_path = "BuildInfo"
local title_path = "BuildInfo/title"
local image_path = "BuildInfo/top/Image"
local desc_path = "BuildInfo/top/desc"
local power_path = "BuildInfo/hori/power"
local stamina_path = "BuildInfo/bot/stamina"
local time_path = "BuildInfo/bot/time"
local rally_path = "BuildInfo/hori/rally"
local rally_tip_text_path = "BuildInfo/hori/rally/RallyTipText"

function AllyDrillCowDes:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function AllyDrillCowDes:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function AllyDrillCowDes:OnEnable()
  base.OnEnable(self)
end

function AllyDrillCowDes:OnDisable()
  base.OnDisable(self)
end

function AllyDrillCowDes:ComponentDefine()
  self.animator = self:AddComponent(UIAnimator, "")
  self.build_details = self:AddComponent(UICanvasGroup, build_details_path)
  self.build_details:SetAlpha(1)
  self.build_info = self:AddComponent(UICanvasGroup, build_info_path)
  self.build_info:SetAlpha(1)
  self.des_txt = self:AddComponent(UITextMeshProUGUIEx, des_txt_path)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.image = self:AddComponent(UIImage, image_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.power = self:AddComponent(UITextMeshProUGUIEx, power_path)
  self.stamina = self:AddComponent(UITextMeshProUGUIEx, stamina_path)
  self.time = self:AddComponent(UITextMeshProUGUIEx, time_path)
  self.rally = self:AddComponent(UIBaseContainer, rally_path)
  self.rally_tip_text = self:AddComponent(UITextMeshProUGUIEx, rally_tip_text_path)
end

function AllyDrillCowDes:ComponentDestroy()
  self.build_details = nil
  self.des_txt = nil
  self.build_info = nil
  self.title = nil
  self.image = nil
  self.desc = nil
  self.power = nil
  self.stamina = nil
  self.time = nil
  self.rally = nil
  self.rally_tip_text = nil
end

function AllyDrillCowDes:DataDefine()
end

function AllyDrillCowDes:DataDestroy()
end

function AllyDrillCowDes:RefreshData(data)
  local damage = DataCenter.AllyDrillDataManager:GetCowDamage(data.monsterTemplate.id)
  damage = string.GetFormattedStr2(damage)
  self.desc:SetLocalText("monster_bull_limit_17", damage)
  self.des_txt:SetLocalText(data.des)
  self.title:SetLocalText(data.name)
  self.stamina:SetText("10")
  self.power:SetText(data.recommend_power)
  self.image:LoadSpriteAsync("Assets/Main/SeasonRes/Shared/Sprites/UI/MadCow/" .. data.monsterTemplate.pic)
  self.endTime = data.refreshTime
  self.rally:SetActive(false)
  if CS.SceneManager.World ~= nil then
    local marchData = CS.SceneManager.World:GetMarch(data.uuid)
    if marchData then
      local num = marchData.monsterRallyNum
      if num and 0 < num then
        self.rally:SetActive(true)
        if 99 < num then
          self.rally_tip_text:SetText("(99+)")
        else
          self.rally_tip_text:SetText("(" .. num .. ")")
        end
      end
    end
  end
  self:Update1000MS()
end

function AllyDrillCowDes:Update1000MS()
  local now = UITimeManager:GetInstance():GetServerTime()
  local remain = UITimeManager:GetInstance():MilliSecondToFmtString(self.endTime - now)
  self.time:SetText(remain)
  if now > self.endTime then
    self.view.ctrl:CloseSelf()
  end
end

function AllyDrillCowDes:OnInfoClick()
  self.animator:Enable(true)
  self.animator:Play("switchEnter", 0, 0)
end

function AllyDrillCowDes:OnReturnClick()
  self.animator:Enable(true)
  self.animator:Play("switchOut", 0, 0)
end

return AllyDrillCowDes
