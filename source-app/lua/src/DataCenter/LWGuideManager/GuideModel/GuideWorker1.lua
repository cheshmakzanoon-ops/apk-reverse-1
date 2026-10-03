local GuideNpcUnit = require("DataCenter.LWGuideManager.GuideModel.GuideNpcUnit")
local GuideWorker1 = BaseClass("GuideWorker1", GuideNpcUnit)
local trigger_path = "TipRoot/Trigger"
local questionIcon = "TipRoot/Icon/questionIcon"
local p_entryPath = "ModelGo/point/p_entry"
local Localization = CS.GameEntry.Localization

function GuideWorker1:OnCreate()
  self.tipRoot = self.transform:Find("TipRoot")
  self.questionIcon = self.transform:Find(questionIcon)
  self.trigger = self.transform:Find(trigger_path):GetComponent(typeof(CS.TouchObjectEventTrigger))
  
  function self.trigger.onPointerClick()
    self:OnTriggerClick()
  end
  
  self.cancel_icon = self.questionIcon:GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  if self.data.CreateCallBack then
    self.data.CreateCallBack()
    self.data.CreateCallBack = nil
  end
  local pos = CS.UnityEngine.Camera.main.gameObject.transform.position
  local lookRot = Quaternion.LookRotation(Vector3.Normalize(Vector3.New(pos.x, self.transform.position.y, pos.z) - self.transform.position), Vector3.up)
  self.transform.rotation = lookRot
  if self.tipRoot then
    self.tipRoot.transform.rotation = CS.SceneManager.World:GetRotation()
  end
end

function GuideWorker1:OnTriggerClick()
end

function GuideWorker1:OnDialogueEnd()
  self.data.path = self.data.worker.city_model_path
  self.data.birthPos = Vector3.New(self.transform.position.x, self.transform.position.y, self.transform.position.z)
  self:ClearModel()
  self:CreateModel(function()
    self.effect = self.transform:Find("VFX_animal_grow"):GetComponent(typeof(CS.UnityEngine.ParticleSystem))
    local cityObj = CS.SceneManager.World:GetBuildingByPoint(self.data.buildData.pointId)
    local p_entry = cityObj.gameObject.transform:Find(p_entryPath)
    local pathList = DataCenter.InnerCityMapManager:FindPath(self.transform.position, p_entry.transform.position)
    self:SetTargetEndPos(pathList)
    self.delay = TimerManager:GetInstance():DelayInvoke(function()
      self.tipRoot.gameObject:SetActive(false)
    end, 1)
    if self.effect then
      self.effect.gameObject:SetActive(true)
      self.effect:Play()
    end
    self.working = true
  end)
end

function GuideWorker1:OnArrivalTerminal()
  if self.working == nil then
    self.tipRoot.gameObject:SetActive(true)
    self.questionIcon.gameObject:SetActive(true)
    self.cancel_icon:LoadSprite(string.format("Assets/Main/Sprites/UI/UITask/UI_building_%s.png", self.data.buildData.itemId))
    self.localPos = self.cancel_icon.gameObject.transform.localPosition
    self.localScale = self.cancel_icon.gameObject.transform.localScale
    self.cancel_icon.gameObject.transform:Set_localPosition(0, 0.12, -0.03)
    self.cancel_icon.gameObject.transform:Set_localScale(0.15, 0.15, 0.15)
  else
    self.isFinish = true
  end
end

function GuideWorker1:OnFinish()
  local param = {}
  param.uuid = tostring(self.data.buildData.uuid)
  param.gold = BuildUpgradeUseGoldType.No
  param.upLevel = 1
  param.clientParam = ""
  param.truckId = 0
  param.pathTime = 0
  param.robotUuid = 0
  SFSNetwork.SendMessage(MsgDefines.FreeBuildingUpNew, param)
  local t = {
    lwGuideRecord = GuideState.UnLanlockTwo
  }
  DataCenter.LWGuideManager:UpdateGuide(t)
  SFSNetwork.SendMessage(MsgDefines.LWSaveGuide, GuideState.UnLanlockTwo)
  self.isFinish = false
  self.localScale = nil
  self.localPos = nil
  self.questionIcon = nil
  self.tipRoot = nil
  self.trigger = nil
  self:Delete()
end

function GuideWorker1:OnDelete()
  if self.effect then
    self.effect.gameObject:SetActive(false)
    self.effect = nil
  end
end

function GuideWorker1:ClearModel()
  if self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.update = nil
  end
  if self.req then
    self.req:Destroy()
  end
  self.isArrival = nil
  self.simpleAnim = nil
  self.tipRoot = nil
  self.transform = nil
  self.gameObject = nil
end

return GuideWorker1
