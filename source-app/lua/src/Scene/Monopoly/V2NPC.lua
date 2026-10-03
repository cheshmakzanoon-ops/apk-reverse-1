local V2NPC = BaseClass("V2NPC")
local Const = require("Scene.Monopoly.Const")
local Resource = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization

function V2NPC:__init()
  self.isCreate = false
end

function V2NPC:__delete()
  self.isCreate = nil
  if not IsNull(self.trigger) then
    self.trigger.onPointerClick = nil
    self.trigger = nil
  end
  if self.req then
    self.req:Destroy()
    self.req = nil
  end
  if not IsNull(self.fingerClickHandle) then
    self.fingerClickHandle:Destroy()
  end
  self.fingerClickHandle = nil
end

function V2NPC:CreateModel(prefabPath, parent, isShowGuide)
  self.isCreate = true
  self.req = Resource:InstantiateAsync(prefabPath)
  self.req:completed("+", function(req)
    self.gameObject = req.gameObject
    self.gameObject.name = "monopolyV2Npc"
    self.transform = req.gameObject.transform
    local lookRot = Vector3.back
    lookRot = Quaternion.LookRotation(lookRot, Vector3.up)
    self.transform.rotation = lookRot
    self.transform:SetParent(parent.transform)
    self.transform:Set_localPosition(146, 0, 80)
    local modelHeightCom = self.gameObject:GetComponent(typeof(CS.ModelHeight))
    if modelHeightCom then
      self.modelHeight = modelHeightCom:GetHeight()
    end
    self.trigger = self.transform.gameObject:GetComponent(typeof(CS.TouchObjectEventTrigger))
    self.collider = self.transform.gameObject:GetComponent(typeof(CS.UnityEngine.Collider))
    if self.trigger == nil then
      self.trigger = self.transform.gameObject:AddComponent(typeof(CS.TouchObjectEventTrigger))
    end
    if IsNull(self.collider) then
      self.collider = self.transform.gameObject:AddComponent(typeof(CS.UnityEngine.CapsuleCollider))
      self.collider.height = 3
      self.collider.center = Vector3.New(0, 1, 0)
    end
    
    function self.trigger.onPointerClick()
      self:OnTriggerClick()
    end
    
    local isShown = Setting:GetPrivateBool(SettingKeys.MONOPOLY_V2_GUIDE_SHOWN, false)
    if not isShown and isShowGuide then
      TimerManager:GetInstance():DelayInvoke(function()
        GoToUtil.GotoPos(self.transform.position, CS.SceneManager.World.InitZoom, 1)
        Setting:SetPrivateBool(SettingKeys.MONOPOLY_V2_GUIDE_SHOWN, true)
        self.fingerClickHandle = CS.GameEntry.Resource:InstantiateAsync("Assets/Main/Prefabs/LWOpeningStage/finger_click.prefab")
        self.fingerClickHandle:completed("+", function(handle)
          if handle.isError then
            return
          end
          local gameObject = handle.gameObject
          local transform = gameObject.transform
          transform:SetParent(self.transform, false)
          transform.position = self.transform.position
          transform.localScale = Vector3.one * 2
          transform.localRotation = Quaternion.Euler(0, -180, 0)
          TimerManager:GetInstance():DelayInvoke(function()
            handle:Destroy()
          end, 3)
        end)
      end, 2)
    end
  end)
end

function V2NPC:OnTriggerClick()
  self.plotId = LuaEntry.DataConfig:TryGetNum("city_land_unlock_v2", "k5", 0)
  EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {
    plotGroupId = self.plotId,
    hideMainUI = false
  })
  SFSNetwork.SendMessage(MsgDefines.MonopolyV2Unlock)
end

return V2NPC
