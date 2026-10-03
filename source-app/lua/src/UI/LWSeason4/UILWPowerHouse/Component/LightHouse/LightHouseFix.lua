local LightHouseFix = BaseClass("LightHouseFix", UIAsyncContainer)
local base = UIAsyncContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local task_title_path = "info/task_title"
local task_desc_path = "info/task_desc"
local goto_fix_btn_path = "gotoFixBtn"
local btn_fix_des_path = "gotoFixBtn/BtnFixDes"

function LightHouseFix:OnCreate()
  base.OnCreate(self)
  self.task_title = self:AddComponent(UITextMeshProUGUIEx, task_title_path)
  self.task_desc = self:AddComponent(UITextMeshProUGUIEx, task_desc_path)
  self.goto_fix_btn = self:AddComponent(UIButton, goto_fix_btn_path)
  self.btn_fix_des = self:AddComponent(UITextMeshProUGUIEx, btn_fix_des_path)
  self.goto_fix_btn:SetOnClick(function()
    local dataList = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.LW_BUILD_SEASON4_POWER_STATION1)
    if dataList and 0 < #dataList and dataList[1] then
      local buildData = dataList[1]
      if buildData ~= nil then
        local worldPointPos = buildData:GetCenterVec()
        GoToUtil.CloseAllWindows()
        SceneUtils.ChangeToCity(function()
          GoToUtil.GotoPos(worldPointPos, CS.SceneManager.World.InitZoom, 0.2)
          TimerManager:GetInstance():DelayInvoke(function()
            local uiPos = CS.CSUtils.WorldPositionToUISpacePosition(worldPointPos)
            local param = {}
            param.position = Vector3.New(uiPos.x, uiPos.y, uiPos.z)
            param.arrowType = ArrowType.Building
            param.positionType = PositionType.Screen
            param.isPanel = false
            param.isAutoClose = 2
            DataCenter.ArrowManager:ShowArrow(param)
          end, 0.5)
        end)
      end
    end
  end)
  local cfg = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(BuildingTypes.LW_BUILD_SEASON4_POWER_STATION1, 1)
  if cfg ~= nil then
    self.task_title:SetLocalText(cfg.name)
    self.task_desc:SetLocalText(cfg.des)
  else
    self.task_title:SetLocalText("season_s4_building_ui_info07")
    self.task_desc:SetLocalText("season_s4_building_ui_info08")
  end
  self.btn_fix_des:SetLocalText("500413")
end

function LightHouseFix:OnDestroy()
  self.task_title = nil
  self.task_desc = nil
  self.goto_fix_btn = nil
  self.btn_fix_des = nil
  base.OnDestroy(self)
end

return LightHouseFix
