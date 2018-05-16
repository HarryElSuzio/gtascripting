local caravana = {x = 1974.2, y = 3814.64, z = 33.44,rotation = 285.01,NetworkSync = true}
local entrega = {x = 1985.16, y = 3820.08,z= 32.36}
local cantidad = nil
local isInJob = false
ESX                           = nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

------------------------------
------------CREAR NPC---------
------------------------------
Citizen.CreateThread(function()
    modelHash = GetHashKey("G_M_Y_Lost_03")
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
       	Wait(1)
    end
    createNPC() 
end)

function createNPC()
	created_ped = CreatePed(5, modelHash , caravana.x,caravana.y,caravana.z - 1, caravana.rotation, caravana.NetworkSync, caravana.NetworkSync)
	FreezeEntityPosition(created_ped, true)
	SetEntityInvincible(created_ped, true)
	SetBlockingOfNonTemporaryEvents(created_ped, true)
	TaskStartScenarioInPlace(created_ped, "WORLD_HUMAN_DRINKING", 0, true)
end

------------------------------
-------HILO PRINCIPAL---------
------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if isInJob == false then
			if GetDistanceBetweenCoords(caravana.x, caravana.y, caravana.z, GetEntityCoords(GetPlayerPed(-1),true)) <= 3 then
				DrawText3D(caravana.x, caravana.y, caravana.z + 1, "Pulsa E para hablar con Jeisenberj", 255,0,0)
				if IsControlJustPressed(1,38) then
					OpenMenu()
				end
			end
		else
			DrawMarker(1,entrega.x, entrega.y, entrega.z - 1, 0, 0, 0, 0, 0, 0, 1.5001, 1.5001, 0.6001,255,255,51, 200, 0, 0, 0, 0)
			if GetDistanceBetweenCoords(entrega.x, entrega.y, entrega.z, GetEntityCoords(GetPlayerPed(-1),true)) <= 1.5 then
				drawTxt("Pulsa E para entregar la droga",4, 1, 0.45, 0.92, 0.70,255,255,255,255)
				if IsControlJustPressed(1,38) then
					TriggerServerEvent('tm1_empresa:removeItem',cantidad)
					isInJob = false
					RemoveBlip(blip)
					local dinero = cantidad * 550
					TriggerEvent("pNotify:SetQueueMax", "center", 2)
                	TriggerEvent("pNotify:SendNotification", {
	                    text = "Killo gracias por la droga de moda colega, te voy a dar "..dinero.."€",
	                    type = "success",
	                    timeout = 3000,
	                    layout = "centerRight",
	                    queue = "center"
                	})
				end
			end
		end
	end	
end)

function startJob()
	blip = AddBlipForCoord(entrega.x,entrega.y,entrega.z)
	SetBlipRoute(blip, true)
end

function OpenMenu()

	local elements = {
		{label = "Aceptar" ,value = "yes"},
		{label = "Denegar" ,value = "no"}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'menu_empresa',
		{
			title  = "¿Quieres aceptar el trabajo?",
			elements = elements
		},
		function(data, menu)
			if data.current.value == "yes" then
				isInJob = true
				local numero = math.random(20,30)
				cantidad = numero
				TriggerServerEvent('tm1_empresa:addItem',"hw",numero)
				startJob()
				TriggerEvent("pNotify:SetQueueMax", "center", 2)
                	TriggerEvent("pNotify:SendNotification", {
	                    text = "Io, lleva la mercansia en el top de el kondado, te mando la posision gps para que vallas, bueno te la manda mi colega que yo no se de estas nuevas tecnologiah. Hasta luego flaco.",
	                    type = "error",
	                    timeout = 12000,
	                    layout = "centerRight",
	                    queue = "center"
                	})
				menu.close()
			else
				menu.close()
			end
		end,
		function(data, menu)
			menu.close()
		end
	)
end

function DrawText3D(x,y,z, text, r,g,b) -- some useful function, use it if you want!
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(0)
        SetTextProportional(1)
        -- SetTextScale(0.0, 0.55)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(centre)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x , y)
end


